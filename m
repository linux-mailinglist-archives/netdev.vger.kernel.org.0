Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB992D1BA0
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgLGVHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:07:50 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45809 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727068AbgLGVHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:07:49 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 7 Dec 2020 23:06:53 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B7L6qIG029788;
        Mon, 7 Dec 2020 23:06:53 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Or Gerlitz <ogerlitz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v1 net-next 08/15] nvme-tcp: Deal with netdevice DOWN events
Date:   Mon,  7 Dec 2020 23:06:42 +0200
Message-Id: <20201207210649.19194-9-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201207210649.19194-1-borisp@mellanox.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

For ddp setup/teardown and resync, the offloading logic
uses HW resources at the NIC driver such as SQ and CQ.

These resources are destroyed when the netdevice does down
and hence we must stop using them before the NIC driver
destroys them.

Use netdevice notifier for that matter -- offloaded connections
are stopped before the stack continues to call the NIC driver
close ndo.

We use the existing recovery flow which has the advantage
of resuming the offload once the connection is re-set.

This also buys us proper handling for the UNREGISTER event
b/c our offloading starts in the UP state, and down is always
there between up to unregister.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 drivers/nvme/host/tcp.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 3c10c8876036..35c898fc833f 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -145,6 +145,7 @@ struct nvme_tcp_ctrl {
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
 static DEFINE_MUTEX(nvme_tcp_ctrl_mutex);
+static struct notifier_block nvme_tcp_netdevice_nb;
 static struct workqueue_struct *nvme_tcp_wq;
 static const struct blk_mq_ops nvme_tcp_mq_ops;
 static const struct blk_mq_ops nvme_tcp_admin_mq_ops;
@@ -2900,6 +2901,27 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
 	return ERR_PTR(ret);
 }
 
+static int nvme_tcp_netdev_event(struct notifier_block *this,
+				 unsigned long event, void *ptr)
+{
+	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
+	struct nvme_tcp_ctrl *ctrl;
+
+	switch (event) {
+	case NETDEV_GOING_DOWN:
+		mutex_lock(&nvme_tcp_ctrl_mutex);
+		list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list) {
+			if (ndev != ctrl->offloading_netdev)
+				continue;
+			nvme_tcp_error_recovery(&ctrl->ctrl);
+		}
+		mutex_unlock(&nvme_tcp_ctrl_mutex);
+		flush_workqueue(nvme_reset_wq);
+		/* we assume that the going down part of error recovery is over */
+	}
+	return NOTIFY_DONE;
+}
+
 static struct nvmf_transport_ops nvme_tcp_transport = {
 	.name		= "tcp",
 	.module		= THIS_MODULE,
@@ -2914,13 +2936,26 @@ static struct nvmf_transport_ops nvme_tcp_transport = {
 
 static int __init nvme_tcp_init_module(void)
 {
+	int ret;
+
 	nvme_tcp_wq = alloc_workqueue("nvme_tcp_wq",
 			WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!nvme_tcp_wq)
 		return -ENOMEM;
 
+	nvme_tcp_netdevice_nb.notifier_call = nvme_tcp_netdev_event;
+	ret = register_netdevice_notifier(&nvme_tcp_netdevice_nb);
+	if (ret) {
+		pr_err("failed to register netdev notifier\n");
+		goto out_err_reg_notifier;
+	}
+
 	nvmf_register_transport(&nvme_tcp_transport);
 	return 0;
+
+out_err_reg_notifier:
+	destroy_workqueue(nvme_tcp_wq);
+	return ret;
 }
 
 static void __exit nvme_tcp_cleanup_module(void)
@@ -2928,6 +2963,7 @@ static void __exit nvme_tcp_cleanup_module(void)
 	struct nvme_tcp_ctrl *ctrl;
 
 	nvmf_unregister_transport(&nvme_tcp_transport);
+	unregister_netdevice_notifier(&nvme_tcp_netdevice_nb);
 
 	mutex_lock(&nvme_tcp_ctrl_mutex);
 	list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list)
-- 
2.24.1

