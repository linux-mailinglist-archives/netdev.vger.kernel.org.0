Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67849132EC4
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgAGS5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:57:05 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:52669 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgAGS5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:57:05 -0500
Received: by mail-pg1-f202.google.com with SMTP id w21so258431pgf.19
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 10:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FUHTBGvgIY24Eh28kccUmUEdiGiPAXHjx/6bPAnKOcs=;
        b=mVxHq5coibItwtQJIrRg3k12jhi9TaPRXENvwT94U1OhjID3X58WIvxynw0oIBUPF2
         vOQRbMriKy6ohbcouQO+8o5EvMiKRDL2r++zYBX+75er/uLiT8gZpga0bU728/wA+MNB
         LUwv2J6e7q6UQs8ibHPpp1fdyHFGZKCCRDGvhzOok8l4c/m2vCaG5wr5L2Odt6EtmIyq
         XXcJPJ/8SsnMU/5FOZv88Lz7viCGu44c3P4WKA/AExoO0c5YG0m1UFSQndNKci/dMBH9
         zz1pCpblhK7O05l7KP/d46/v8HbqAOcKA71W6X5ILix6W7VElpoz4Nb4Xgouxm4ZMnZ4
         auVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FUHTBGvgIY24Eh28kccUmUEdiGiPAXHjx/6bPAnKOcs=;
        b=XfG3OgyULgnq+kwM/uklwzhUZGRMkaClh2F+VaYaCdg+j/4NziWoFAmgUwduIg/XBN
         1AHJHwtO2HscdsWJ8qnUMNY+aaJhANB6F6tbZWZyT4X0iG3BDt1LMcPGhlqpni5PeStf
         wOaf2sXnV7Hm7GiiTVVLAU7hZeMLxyaGMq0jUtWQ3+QbYdg0GEgi8oCxDdnw1NS6dGu3
         OLP+ubRzQyRvmEXQCrGOHaqtgJ7XuqhL8hFG9TFPztNHalfCRMMCLJMsyn0k1EDJtedp
         3pS10zDUApawhPfdcEoyPsrMjjMMGXbFJiiwyqys7XR4EsvQKDkae8ICDWZmI03AlnNd
         iDSA==
X-Gm-Message-State: APjAAAXmFKKGbDAv6r1RLvLpGrrgV2z5pvTDfM5lQvfSPU/uOamxzyQR
        rqvV5/RGAXDWwAMoB+ExdY7kaDcDMMypqA==
X-Google-Smtp-Source: APXvYqyW6cR9kS/kjXZYd5fhF2v/2ZnmZnPdyKctUDCmiJfpNeECVMnM7BConB9HJ1yHgcMu/2X3KAP5WI4IRQ==
X-Received: by 2002:a63:484b:: with SMTP id x11mr1005447pgk.148.1578423424565;
 Tue, 07 Jan 2020 10:57:04 -0800 (PST)
Date:   Tue,  7 Jan 2020 10:57:01 -0800
Message-Id: <20200107185701.137063-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net] net: usb: lan78xx: fix possible skb leak
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        RENARD Pierre-Francois <pfrenard@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If skb_linearize() fails, we need to free the skb.

TSO makes skb bigger, and this bug might be the reason
Raspberry Pi 3B+ users had to disable TSO.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
Cc: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
---
 drivers/net/usb/lan78xx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f940dc6485e56a7e8f905082ce920f5dd83232b0..fb4781080d6dec2af22f41c5e064350ea74130b3 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2724,11 +2724,6 @@ static int lan78xx_stop(struct net_device *net)
 	return 0;
 }
 
-static int lan78xx_linearize(struct sk_buff *skb)
-{
-	return skb_linearize(skb);
-}
-
 static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
 				       struct sk_buff *skb, gfp_t flags)
 {
@@ -2740,8 +2735,10 @@ static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
 		return NULL;
 	}
 
-	if (lan78xx_linearize(skb) < 0)
+	if (skb_linearize(skb)) {
+		dev_kfree_skb_any(skb);
 		return NULL;
+	}
 
 	tx_cmd_a = (u32)(skb->len & TX_CMD_A_LEN_MASK_) | TX_CMD_A_FCS_;
 
-- 
2.24.1.735.g03f4e72817-goog

