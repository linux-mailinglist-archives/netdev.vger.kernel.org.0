Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CD451F1F6
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 00:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiEHWxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 18:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiEHWx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 18:53:29 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64C03896
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 15:49:36 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4KxKHd2hGQz9sQp;
        Mon,  9 May 2022 00:49:33 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1652050171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w15Bl0kWKh9ytJ0DDSsmIBoP7JeJ85M+oT79ZYhI1hg=;
        b=TUCCIe8TFGF0OdV6A21Ddz7RuDjVrQzWVHx03Fr3XUzMlcj+X3c0FdqXj3uumOg+U32PkS
        3ep1cmWZ4zE12NnO5jEG66UxK4wwmN4C315vgp28kADseVDKE1wH3kF/JNlpFsKeCjLh2F
        kUipEKQwO7X0Z2jIR6jmtD0fUPyjRtr443SK4ymzE+GLEW2P024FE6jC2soauHdlRWsPRR
        2iL5myc/Ug2YpkcgfO6B4h5EgwUMYlDCdTCyZOhNPCs6CiUFV3w1yDfKkaDyasV3XWb4d3
        GO50wmmrcr/GZdIGb7UK5ABSAvmt1tWVkNMndMd/EQWIcuQsU9zR8v/4PNwWNw==
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] net: dsa: realtek: rtl8365mb: Fix interface type mask
Date:   Mon,  9 May 2022 00:48:45 +0200
Message-Id: <20220508224848.2384723-2-hauke@hauke-m.de>
In-Reply-To: <20220508224848.2384723-1-hauke@hauke-m.de>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mask should be shifted like the offset.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 3d70e8a77ecf..2cb722a9e096 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -237,7 +237,7 @@ static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2,
 		 (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1 : \
 		 0x0)
 #define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extint) \
-		(0xF << (((_extint) % 2)))
+		(0xF << (((_extint) % 2) * 4))
 #define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extint) \
 		(((_extint) % 2) * 4)
 
-- 
2.30.2

