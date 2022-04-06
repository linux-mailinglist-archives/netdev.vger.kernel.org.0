Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8E54F670E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbiDFR0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239024AbiDFRZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:25:46 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E644B93EC;
        Wed,  6 Apr 2022 08:24:45 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 932D8FC6D8; Wed,  6 Apr 2022 15:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1649258684; bh=INTP7v0qhzz+7lqwwKVTY7o3YMQwp4+tE8jatZqfEwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxOjwXumbrOBDSj+qQ6+Z+QIKxshoEgdUw5sDd6t9B4LkEWjZnMdnGgMr8LBGKrc3
         9Zm+qv76gK3T3hXkN3joMf1PJusiqNlsbDI9jdQpj0D69indG3w9V7BJNIQDEAV2gj
         HTSNdxPn8mLNiA+ZrpE+sFs9PaJs6J4PFjy5WbEhTEx/hZ7HSJwjK2eQtHXTLtRB5h
         MhIsVAR3CDzXgbcICF4UVtBc6aQ34+vstusbDFJMCT+CF4GCfTGFPnP6soykq3XZis
         bnOlEKhTEDaFKMYscHgFSQ7Vx+dVREim3kinHULNcA6O4aSeN9r/wzJSCF/H/GlOt3
         KXlUFYrQfZbRg==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48::1e62])
        by stuerz.xyz (Postfix) with ESMTPSA id 25AC1FBC37;
        Wed,  6 Apr 2022 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1649258682; bh=INTP7v0qhzz+7lqwwKVTY7o3YMQwp4+tE8jatZqfEwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYNMTcj9ORTNLqRqbnfnQP1ZUlgWbAFI0DVI3rz/QKKJoxZo6PKkagU8x4MouJHeJ
         Mq9pLaQqq+L7+DuPCZCVunk/9ApSca9ZDodapyIqtm6MGhwcnVSaA2kwMTxzetokoL
         YmTV1dEQ1hV/lG9GFNtcRMlERb7FYqvH9fLJZdlxLECg1iuOqZP7ccNc+ir+r/PVYM
         I+GfyZhu6xSYnzQg+3rODEQNR4xAeYOsEtk5Z8xFvq5tTDH+dioBfNURFeoAsHLx27
         1Hhd9UtXW5CinL/cku+hjS1pZJSlo0Lhoz/fElb6cYcMKRr+rh7ukXSSuI46OizQ2R
         swLgk/wZbPvRA==
From:   =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
Subject: [PATCH v4 1/2] ray_cs: Improve card_status[]
Date:   Wed,  6 Apr 2022 17:22:46 +0200
Message-Id: <20220406152247.386267-2-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406152247.386267-1-benni@stuerz.xyz>
References: <20220406152247.386267-1-benni@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace comments with C99's designated initializers to improve
readability and maintainability.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 drivers/net/wireless/ray_cs.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 87e98ab068ed..3df795dc3d9f 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2529,20 +2529,23 @@ static void clear_interrupt(ray_dev_t *local)
 #define MAXDATA (PAGE_SIZE - 80)
 
 static const char *card_status[] = {
-	"Card inserted - uninitialized",	/* 0 */
-	"Card not downloaded",			/* 1 */
-	"Waiting for download parameters",	/* 2 */
-	"Card doing acquisition",		/* 3 */
-	"Acquisition complete",			/* 4 */
-	"Authentication complete",		/* 5 */
-	"Association complete",			/* 6 */
-	"???", "???", "???", "???",		/* 7 8 9 10 undefined */
-	"Card init error",			/* 11 */
-	"Download parameters error",		/* 12 */
-	"???",					/* 13 */
-	"Acquisition failed",			/* 14 */
-	"Authentication refused",		/* 15 */
-	"Association failed"			/* 16 */
+	[CARD_INSERTED]		= "Card inserted - uninitialized",
+	[CARD_AWAITING_PARAM]	= "Card not downloaded",
+	[CARD_DL_PARAM]		= "Waiting for download parameters",
+	[CARD_DOING_ACQ]	= "Card doing acquisition",
+	[CARD_ACQ_COMPLETE]	= "Acquisition complete",
+	[CARD_AUTH_COMPLETE]	= "Authentication complete",
+	[CARD_ASSOC_COMPLETE]	= "Association complete",
+	[7]			= "???",
+	[8]			= "???",
+	[9]			= "???",
+	[10]			= "???",
+	[CARD_INIT_ERROR]	= "Card init error",
+	[CARD_DL_PARAM_ERROR]	= "Download parameters error",
+	[13]			= "???",
+	[CARD_ACQ_FAILED]	= "Acquisition failed",
+	[CARD_AUTH_REFUSED]	= "Authentication refused",
+	[CARD_ASSOC_FAILED]	= "Association failed"
 };
 
 static const char *nettype[] = { "Adhoc", "Infra " };
-- 
2.35.1

