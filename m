Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EAC49D7D8
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbiA0CIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:08:34 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:52553 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229635AbiA0CId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 21:08:33 -0500
X-UUID: a3567812349a49adbe7774f30d35c4b4-20220127
X-CPASD-INFO: cbbd8d5ac1d04d7ab302cc3dced70a6f
        @rLKchGWWY5GPUaZ8g6eCm4JkYGKTj1OzpZ-
        EZ16RYoaVhH5xTWJsXVKBfG5QZWNdYVN_eGpQYl9gZFB5i3-XblBgXoZgUZB3sqSchGiSZQ==
X-CPASD-FEATURE: 0.0
X-CLOUD-ID: cbbd8d5ac1d04d7ab302cc3dced70a6f
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,EXT:0.0,OB:0.0,URL:-5,T
        VAL:185.0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:100.0,IP:-2.0,MAL:0.0,ATTNUM:0
        .0,PHF:-5.0,PHC:-5.0,SPF:4.0,EDMS:-3,IPLABEL:4488.0,FROMTO:0,AD:0,FFOB:0.0,CF
        OB:0.0,SPC:0.0,SIG:-5,AUF:105,DUF:31881,ACD:176,DCD:278,SL:0,AG:0,CFC:0.183,C
        FSR:0.173,UAT:0,RAF:0,VERSION:2.3.4
X-CPASD-ID: a3567812349a49adbe7774f30d35c4b4-20220127
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1, 1
X-UUID: a3567812349a49adbe7774f30d35c4b4-20220127
X-User: yinxiujiang@kylinos.cn
Received: from localhost.localdomain [(118.26.139.139)] by nksmu.kylinos.cn
        (envelope-from <yinxiujiang@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 2100141869; Thu, 27 Jan 2022 10:21:06 +0800
From:   Yin Xiujiang <yinxiujiang@kylinos.cn>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinxiujiang@kylinos.cn
Subject: [PATCH] vhost: Make use of the helper macro kthread_run()
Date:   Thu, 27 Jan 2022 10:08:07 +0800
Message-Id: <20220127020807.844630-1-yinxiujiang@kylinos.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Repalce kthread_create/wake_up_process() with kthread_run()
to simplify the code.

Signed-off-by: Yin Xiujiang <yinxiujiang@kylinos.cn>
---
 drivers/vhost/vhost.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..19e9eda9fc71 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -595,7 +595,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 
 	dev->kcov_handle = kcov_common_handle();
 	if (dev->use_worker) {
-		worker = kthread_create(vhost_worker, dev,
+		worker = kthread_run(vhost_worker, dev,
 					"vhost-%d", current->pid);
 		if (IS_ERR(worker)) {
 			err = PTR_ERR(worker);
@@ -603,7 +603,6 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 		}
 
 		dev->worker = worker;
-		wake_up_process(worker); /* avoid contributing to loadavg */
 
 		err = vhost_attach_cgroups(dev);
 		if (err)
-- 
2.30.0

