Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9476756B061
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 04:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbiGHCCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 22:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236922AbiGHCCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 22:02:32 -0400
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5073F73908;
        Thu,  7 Jul 2022 19:02:30 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id CZK00025;
        Fri, 08 Jul 2022 10:02:25 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201612.home.langchao.com (10.100.2.12) with Microsoft SMTP Server id
 15.1.2507.9; Fri, 8 Jul 2022 10:02:25 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <loic.poulain@linaro.org>, <ryazanov.s.a@gmail.com>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] net: wwan: call ida_free when device_register fails
Date:   Thu, 7 Jul 2022 22:02:23 -0400
Message-ID: <20220708020223.4234-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   2022708100226f1151e7cf1643e555c40cf86075d3ed9
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when device_register() fails, we should call ida_free().

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 drivers/net/wwan/wwan_core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index b8c7843730ed..0f653e320b2b 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -228,8 +228,7 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
 	wwandev = kzalloc(sizeof(*wwandev), GFP_KERNEL);
 	if (!wwandev) {
 		wwandev = ERR_PTR(-ENOMEM);
-		ida_free(&wwan_dev_ids, id);
-		goto done_unlock;
+		goto error_free_ida;
 	}
 
 	wwandev->dev.parent = parent;
@@ -242,7 +241,7 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
 	if (err) {
 		put_device(&wwandev->dev);
 		wwandev = ERR_PTR(err);
-		goto done_unlock;
+		goto error_free_ida;
 	}
 
 #ifdef CONFIG_WWAN_DEBUGFS
@@ -251,6 +250,8 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
 					   wwan_debugfs_dir);
 #endif
 
+error_free_ida:
+	ida_free(&wwan_dev_ids, id);
 done_unlock:
 	mutex_unlock(&wwan_register_lock);
 
@@ -448,8 +449,7 @@ struct wwan_port *wwan_create_port(struct device *parent,
 	port = kzalloc(sizeof(*port), GFP_KERNEL);
 	if (!port) {
 		err = -ENOMEM;
-		ida_free(&minors, minor);
-		goto error_wwandev_remove;
+		goto error_free_ida;
 	}
 
 	port->type = type;
@@ -484,6 +484,8 @@ struct wwan_port *wwan_create_port(struct device *parent,
 
 error_put_device:
 	put_device(&port->dev);
+error_free_ida:
+	ida_free(&minors, minor);
 error_wwandev_remove:
 	wwan_remove_dev(wwandev);
 
-- 
2.27.0

