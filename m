Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFA47A1825
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 13:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfH2LTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 07:19:31 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43818 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728303AbfH2LTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 07:19:30 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Aug 2019 14:19:24 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7TBJ8v7020002;
        Thu, 29 Aug 2019 14:19:22 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, davem@davemloft.net
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH v2 6/6] mtty: Optionally support mtty alias
Date:   Thu, 29 Aug 2019 06:19:04 -0500
Message-Id: <20190829111904.16042-7-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190829111904.16042-1-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190829111904.16042-1-parav@mellanox.com>
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
Changelog:
v1->v2:
 - Added mdev_alias() usage sample
---
 samples/vfio-mdev/mtty.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 92e770a06ea2..075d65440bc0 100644
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
 
 static int mtty_trigger_interrupt(const guid_t *uuid);
@@ -770,6 +774,9 @@ static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)
 	list_add(&mdev_state->next, &mdev_devices_list);
 	mutex_unlock(&mdev_list_lock);
 
+	if (mtty_alias_length)
+		dev_dbg(mdev_dev(mdev), "alias is %s\n", mdev_alias(mdev));
+
 	return 0;
 }
 
@@ -1410,6 +1417,11 @@ static struct attribute_group *mdev_type_groups[] = {
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
@@ -1422,6 +1434,7 @@ static const struct mdev_parent_ops mdev_fops = {
 	.read                   = mtty_read,
 	.write                  = mtty_write,
 	.ioctl		        = mtty_ioctl,
+	.get_alias_length	= mtty_get_alias_length
 };
 
 static void mtty_device_release(struct device *dev)
-- 
2.19.2

