Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C59027EEEA
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbgI3QUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:20:38 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50525 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731306AbgI3QUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:20:34 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 30 Sep 2020 19:20:28 +0300
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08UGKR2J032498;
        Wed, 30 Sep 2020 19:20:28 +0300
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH net-next RFC v1 08/10] nvme-tcp: Deal with netdevice DOWN events
Date:   Wed, 30 Sep 2020 19:20:08 +0300
Message-Id: <20200930162010.21610-9-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200930162010.21610-1-borisp@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
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
destroyes them.

Use netdevice notifier for that matter -- offloaded connections
are stopped before the stack continues to call the NIC driver
close ndo.

We use the existing recovery flow which has the advantage
of resuming the offload once the connection is re-set.

Since the recovery flow runs in a separate/dedicated WQ
we need to wait in the notifier code for an ACK that all
offloaded queues were stopped which means that the teardown
queue offload ndo was called and the NIC doesn't have any
resources related to that connection any more.

This also buys us proper handling for the UNREGISTER event
b/c our offloading starts in the UP state, and down is always
there between up to unregister.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 drivers/nvme/host/tcp.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 9a620d1dacb4..7569b47f0414 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -144,6 +144,7 @@ struct nvme_tcp_ctrl {
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
 static DEFINE_MUTEX(nvme_tcp_ctrl_mutex);
+static struct notifier_block nvme_tcp_netdevice_nb;
 static struct workqueue_struct *nvme_tcp_wq;
 static const struct blk_mq_ops nvme_tcp_mq_ops;
 static const struct blk_mq_ops nvme_tcp_admin_mq_ops;
@@ -412,8 +413,6 @@ int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
 		queue->ctrl->ctrl.max_segments = limits->max_ddp_sgl_len;
 		queue->ctrl->ctrl.max_hw_sectors =
 			limits->max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
-	} else {
-		queue->ctrl->offloading_netdev = NULL;
 	}
 
 	dev_put(netdev);
@@ -1992,6 +1991,8 @@ static int nvme_tcp_alloc_admin_queue(struct nvme_ctrl *ctrl)
 {
 	int ret;
 
+	to_tcp_ctrl(ctrl)->offloading_netdev = NULL;
+
 	ret = nvme_tcp_alloc_queue(ctrl, 0, NVME_AQ_DEPTH);
 	if (ret)
 		return ret;
@@ -2885,6 +2886,26 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
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
+	}
+	return NOTIFY_DONE;
+}
+
 static struct nvmf_transport_ops nvme_tcp_transport = {
 	.name		= "tcp",
 	.module		= THIS_MODULE,
@@ -2899,13 +2920,26 @@ static struct nvmf_transport_ops nvme_tcp_transport = {
 
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
@@ -2913,6 +2947,7 @@ static void __exit nvme_tcp_cleanup_module(void)
 	struct nvme_tcp_ctrl *ctrl;
 
 	nvmf_unregister_transport(&nvme_tcp_transport);
+	unregister_netdevice_notifier(&nvme_tcp_netdevice_nb);
 
 	mutex_lock(&nvme_tcp_ctrl_mutex);
 	list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list)
-- 
2.24.1

