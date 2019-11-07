Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9544AF3456
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389742AbfKGQJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:48 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53731 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389741AbfKGQJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:42 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:37 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4T007213;
        Thu, 7 Nov 2019 18:09:34 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Date:   Thu,  7 Nov 2019 10:08:34 -0600
Message-Id: <20191107160834.21087-19-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a module parameter to set alias length to optionally generate
mdev alias.

Example to request mdev alias.
$ modprobe mtty alias_length=12

Make use of mtty_alias() API when alias_length module parameter is set.

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 samples/vfio-mdev/mtty.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index ce84a300a4da..5a69121ed5ec 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -150,6 +150,10 @@ static const struct file_operations vd_fops = {
 	.owner          = THIS_MODULE,
 };
 
+static unsigned int mtty_alias_length;
+module_param_named(alias_length, mtty_alias_length, uint, 0444);
+MODULE_PARM_DESC(alias_length, "mdev alias length; default=0");
+
 /* function prototypes */
 
 static int mtty_trigger_interrupt(struct mdev_state *mdev_state);
@@ -755,6 +759,9 @@ static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)
 	list_add(&mdev_state->next, &mdev_devices_list);
 	mutex_unlock(&mdev_list_lock);
 
+	if (mtty_alias_length)
+		dev_dbg(mdev_dev(mdev), "alias is %s\n", mdev_alias(mdev));
+
 	return 0;
 }
 
@@ -1387,6 +1394,11 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static unsigned int mtty_get_alias_length(void)
+{
+	return mtty_alias_length;
+}
+
 static const struct mdev_parent_ops mdev_fops = {
 	.owner                  = THIS_MODULE,
 	.dev_attr_groups        = mtty_dev_groups,
@@ -1399,6 +1411,7 @@ static const struct mdev_parent_ops mdev_fops = {
 	.read                   = mtty_read,
 	.write                  = mtty_write,
 	.ioctl		        = mtty_ioctl,
+	.get_alias_length	= mtty_get_alias_length
 };
 
 static void mtty_device_release(struct device *dev)
-- 
2.19.2

