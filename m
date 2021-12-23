Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C2947DFEB
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242926AbhLWHuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:50:04 -0500
Received: from mxus.zte.com.cn ([20.69.78.39]:56764 "EHLO mxus.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347199AbhLWHtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:49:36 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2021 02:49:33 EST
Received: from mxhk.zte.com.cn (unknown [192.168.250.137])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxus.zte.com.cn (FangMail) with ESMTPS id 4JKMcg4qd2zdmXY5;
        Thu, 23 Dec 2021 15:43:15 +0800 (CST)
Received: from mxct.zte.com.cn (unknown [192.168.251.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4JKMcb4cWhz7jYM7;
        Thu, 23 Dec 2021 15:43:11 +0800 (CST)
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4JKMcX0KgVz6DjmB;
        Thu, 23 Dec 2021 15:43:08 +0800 (CST)
Received: from kjyxapp03.zte.com.cn ([10.30.12.202])
        by mse-fl1.zte.com.cn with SMTP id 1BN7eYfH012388;
        Thu, 23 Dec 2021 15:40:34 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-cloudhost8.localdomain (unknown [10.234.72.110])
        by smtp (Zmail) with SMTP;
        Thu, 23 Dec 2021 15:40:34 +0800
X-Zmail-TransId: 3e8861c427f1016-c1630
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     mst@redhat.com
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, wang.liang82@zte.com.cn,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH] vdpa: regist vhost-vdpa dev class
Date:   Thu, 23 Dec 2021 15:31:45 +0800
Message-Id: <20211223073145.35363-1-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 2.33.0.rc0.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 1BN7eYfH012388
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at 10-207-168-8 with ID 61C42892.000 by FangMail milter!
X-FangMail-Envelope: 1640245396/4JKMcg4qd2zdmXY5/61C42892.000/192.168.250.137/[192.168.250.137]/mxhk.zte.com.cn/<wang.yi59@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 61C42892.000/4JKMcg4qd2zdmXY5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Min <zhang.min9@zte.com.cn>

Some applications like kata-containers need to acquire MAJOR/MINOR/DEVNAME
for devInfo [1], so regist vhost-vdpa dev class to expose uevent.

1. https://github.com/kata-containers/kata-containers/blob/main/src/runtime/virtcontainers/device/config/config.go

Signed-off-by: Zhang Min <zhang.min9@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 drivers/vhost/vdpa.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index fb41db3da611..90fbad93e7a2 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1012,6 +1012,7 @@ static void vhost_vdpa_release_dev(struct device *device)
 	kfree(v);
 }
 
+static struct class *vhost_vdpa_class;
 static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 {
 	const struct vdpa_config_ops *ops = vdpa->config;
@@ -1040,6 +1041,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	v->dev.release = vhost_vdpa_release_dev;
 	v->dev.parent = &vdpa->dev;
 	v->dev.devt = MKDEV(MAJOR(vhost_vdpa_major), minor);
+	v->dev.class = vhost_vdpa_class;
 	v->vqs = kmalloc_array(v->nvqs, sizeof(struct vhost_virtqueue),
 			       GFP_KERNEL);
 	if (!v->vqs) {
@@ -1097,6 +1099,14 @@ static int __init vhost_vdpa_init(void)
 {
 	int r;
 
+	vhost_vdpa_class = class_create(THIS_MODULE, "vhost-vdpa");
+	if (IS_ERR(vhost_vdpa_class)) {
+		r = PTR_ERR(vhost_vdpa_class);
+		pr_warn("vhost vdpa class create error %d,  maybe mod reinserted\n", r);
+		vhost_vdpa_class = NULL;
+		return r;
+	}
+
 	r = alloc_chrdev_region(&vhost_vdpa_major, 0, VHOST_VDPA_DEV_MAX,
 				"vhost-vdpa");
 	if (r)
@@ -1111,6 +1121,7 @@ static int __init vhost_vdpa_init(void)
 err_vdpa_register_driver:
 	unregister_chrdev_region(vhost_vdpa_major, VHOST_VDPA_DEV_MAX);
 err_alloc_chrdev:
+	class_destroy(vhost_vdpa_class);
 	return r;
 }
 module_init(vhost_vdpa_init);
@@ -1118,6 +1129,7 @@ module_init(vhost_vdpa_init);
 static void __exit vhost_vdpa_exit(void)
 {
 	vdpa_unregister_driver(&vhost_vdpa_driver);
+	class_destroy(vhost_vdpa_class);
 	unregister_chrdev_region(vhost_vdpa_major, VHOST_VDPA_DEV_MAX);
 }
 module_exit(vhost_vdpa_exit);
-- 
2.27.0
