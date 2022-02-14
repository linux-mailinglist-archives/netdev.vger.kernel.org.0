Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93014B5BCC
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 22:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiBNUxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:53:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiBNUxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:53:31 -0500
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1FC6100747
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:53:10 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id JgihnBT5U41cbJgihn7hOL; Mon, 14 Feb 2022 20:09:08 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 14 Feb 2022 20:09:08 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: hso: Use GFP_KERNEL instead of GFP_ATOMIC when possible
Date:   Mon, 14 Feb 2022 20:09:06 +0100
Message-Id: <93e4c78983de9a20b1f9009d79116591f20fd1c2.1644865733.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hso_create_device() is only called from function that already use
GFP_KERNEL. And all the callers are called from the probe function.

So there is no need here to explicitly require a GFP_ATOMIC when
allocating memory.

Use GFP_KERNEL instead.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/usb/hso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index f97813a4e8d1..f8221a7acf62 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2319,7 +2319,7 @@ static struct hso_device *hso_create_device(struct usb_interface *intf,
 {
 	struct hso_device *hso_dev;
 
-	hso_dev = kzalloc(sizeof(*hso_dev), GFP_ATOMIC);
+	hso_dev = kzalloc(sizeof(*hso_dev), GFP_KERNEL);
 	if (!hso_dev)
 		return NULL;
 
-- 
2.32.0

