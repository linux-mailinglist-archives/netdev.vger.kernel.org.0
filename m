Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF10547EC91
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 08:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351744AbhLXHNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 02:13:08 -0500
Received: from mxhk.zte.com.cn ([63.216.63.35]:56460 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343520AbhLXHNI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Dec 2021 02:13:08 -0500
X-Greylist: delayed 84595 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Dec 2021 02:13:07 EST
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4JKyvP70Xyz4yjZ8;
        Fri, 24 Dec 2021 15:13:05 +0800 (CST)
Received: from kjyxapp05.zte.com.cn ([10.30.12.204])
        by mse-fl1.zte.com.cn with SMTP id 1BO7CqRn066889;
        Fri, 24 Dec 2021 15:12:52 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-cloudhost8.localdomain (unknown [10.234.72.110])
        by smtp (Zmail) with SMTP;
        Fri, 24 Dec 2021 15:12:52 +0800
X-Zmail-TransId: 3e8861c572f3016-f9693
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     mst@redhat.com
Cc:     sgarzare@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, wang.liang82@zte.com.cn,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH v2] vdpa: regist vhost-vdpa dev class
Date:   Fri, 24 Dec 2021 15:04:04 +0800
Message-Id: <20211224070404.54840-1-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 2.33.0.rc0.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 1BO7CqRn066889
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 61C57301.000 by FangMail milter!
X-FangMail-Envelope: 1640329986/4JKyvP70Xyz4yjZ8/61C57301.000/10.30.14.238/[10.30.14.238]/mse-fl1.zte.com.cn/<wang.yi59@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 61C57301.000/4JKyvP70Xyz4yjZ8
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
v2: remove redundant vhost_vdpa_class reset and pr_warn, adjust location
    of *vhost_vdpa_class impl and class_destroy.

 drivers/vhost/vdpa.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index e3c4f059b21a..55e966c508c8 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -53,6 +53,7 @@ struct vhost_vdpa {
 static DEFINE_IDA(vhost_vdpa_ida);
 
 static dev_t vhost_vdpa_major;
+static struct class *vhost_vdpa_class;
 
 static void handle_vq_kick(struct vhost_work *work)
 {
@@ -1140,6 +1141,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	v->dev.release = vhost_vdpa_release_dev;
 	v->dev.parent = &vdpa->dev;
 	v->dev.devt = MKDEV(MAJOR(vhost_vdpa_major), minor);
+	v->dev.class = vhost_vdpa_class;
 	v->vqs = kmalloc_array(v->nvqs, sizeof(struct vhost_virtqueue),
 			       GFP_KERNEL);
 	if (!v->vqs) {
@@ -1197,6 +1199,10 @@ static int __init vhost_vdpa_init(void)
 {
 	int r;
 
+	vhost_vdpa_class = class_create(THIS_MODULE, "vhost-vdpa");
+	if (IS_ERR(vhost_vdpa_class))
+		return PTR_ERR(vhost_vdpa_class);
+
 	r = alloc_chrdev_region(&vhost_vdpa_major, 0, VHOST_VDPA_DEV_MAX,
 				"vhost-vdpa");
 	if (r)
@@ -1211,6 +1217,7 @@ static int __init vhost_vdpa_init(void)
 err_vdpa_register_driver:
 	unregister_chrdev_region(vhost_vdpa_major, VHOST_VDPA_DEV_MAX);
 err_alloc_chrdev:
+	class_destroy(vhost_vdpa_class);
 	return r;
 }
 module_init(vhost_vdpa_init);
@@ -1219,6 +1226,7 @@ static void __exit vhost_vdpa_exit(void)
 {
 	vdpa_unregister_driver(&vhost_vdpa_driver);
 	unregister_chrdev_region(vhost_vdpa_major, VHOST_VDPA_DEV_MAX);
+	class_destroy(vhost_vdpa_class);
 }
 module_exit(vhost_vdpa_exit);
 
-- 
2.27.0
