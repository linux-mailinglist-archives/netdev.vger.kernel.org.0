Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC2E59D77E
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfHZUll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:41:41 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37912 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729599AbfHZUlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 16:41:39 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Aug 2019 23:41:36 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7QKfPDS021168;
        Mon, 26 Aug 2019 23:41:34 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, davem@davemloft.net
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH 4/4] mtty: Optionally support mtty alias
Date:   Mon, 26 Aug 2019 15:41:19 -0500
Message-Id: <20190826204119.54386-5-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190826204119.54386-1-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
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

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 samples/vfio-mdev/mtty.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 92e770a06ea2..92208245b057 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1410,6 +1410,15 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static unsigned int mtty_alias_length;
+module_param_named(alias_length, mtty_alias_length, uint, 0444);
+MODULE_PARM_DESC(alias_length, "mdev alias length; default=0");
+
+static unsigned int mtty_get_alias_length(void)
+{
+	return mtty_alias_length;
+}
+
 static const struct mdev_parent_ops mdev_fops = {
 	.owner                  = THIS_MODULE,
 	.dev_attr_groups        = mtty_dev_groups,
@@ -1422,6 +1431,7 @@ static const struct mdev_parent_ops mdev_fops = {
 	.read                   = mtty_read,
 	.write                  = mtty_write,
 	.ioctl		        = mtty_ioctl,
+	.get_alias_length	= mtty_get_alias_length
 };
 
 static void mtty_device_release(struct device *dev)
-- 
2.19.2

