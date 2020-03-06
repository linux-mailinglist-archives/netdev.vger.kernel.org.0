Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4BE417C89C
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 23:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCFW7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 17:59:15 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36633 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCFW7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 17:59:14 -0500
Received: by mail-wm1-f67.google.com with SMTP id i14so4052191wmb.1
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 14:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lOASppHNgwv8dUo5uYicEIgStQnZo5GxmU2Lfkt+vZY=;
        b=dvWnw8yYe7bUwhbZcEQfJ8y/GGUKNwsk8trTt2KA6v5AzyNcuTtZCj9sYT8YcE1ulq
         ihrVTlwHnJ70CifNELVini9HWvFY+TJg3PNq04qrJqlGakZZH2FsSkMZxP7GvKhQSp1S
         JRXphsvTars9YLMEJzsvpplgL9UqUwBCTro4MeD1rFV+5UJSCo41QQtCo3NVNpURLt1n
         8G2NOz+9VjafshrsL1RjqPN3hoffHqGOleodYYU2HGeuwxnsoeQb8RnBUFK3eapJsiSH
         IdqnJ7n4t3vzJ227b+gS8dOhGOlf3udxaJB3tx20WOk1x6HZObR1R8mMCfdRX+BMi7a+
         B79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lOASppHNgwv8dUo5uYicEIgStQnZo5GxmU2Lfkt+vZY=;
        b=gX3goty4vWCEGhpsv57sUVPFze5ymhFR62/CsZ2tsTdmuD8GbszrlDk7b9xINEiJwl
         N7iBZ5B0LMZvHK7/jY+fUZpew/a8lcUTUsg4dJnnQWluUK0OX4wahAjakSB9jO+vJ/Qg
         NGRfMA10SuFNgcKQslCXDY4+ejxn72SpfF9Or5n56rpYaNnHLtOAKpUbOZIjhQPVHYC/
         PQT2TojuXy9JAzFfFxKtKWyJ1VVtXmnKCW7zmH3fcYN2k7CtSMenLCNfXlor8KFSJne+
         dcaL4qPaHaU7SIPv+8ac9xY3Ev9YANjzEXGGJPnDGOQStthcOel9ltwfUFhbXlfZj2BF
         by3A==
X-Gm-Message-State: ANhLgQ2Kucbd9Ph9iXBUeSWGPBpgV13GOwz0k5V28ChacjbNbAjFoq0d
        1Ll6KbVbIZ+pvgzahHS81qe8Q+43
X-Google-Smtp-Source: ADFU+vsT91eCdn3sPtqFM23JKRfyNVKq7bVDS++EyGx22oYpiRr7kFIk1g07G+axzPKtsNeH0VyDrQ==
X-Received: by 2002:a05:600c:2c44:: with SMTP id r4mr6008008wmg.140.1583535552977;
        Fri, 06 Mar 2020 14:59:12 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1447:bded:797c:45a5? (p200300EA8F2960001447BDED797C45A5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1447:bded:797c:45a5])
        by smtp.googlemail.com with ESMTPSA id j66sm15640544wmb.21.2020.03.06.14.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 14:59:12 -0800 (PST)
Subject: [PATCH net-next 2/4] r8169: ensure tx_skb is fully reset after
 calling rtl8169_unmap_tx_skb
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <de8e697e-dd20-cbae-4d2d-b1e8994ba65d@gmail.com>
Message-ID: <e9d50f95-0253-a1df-63d6-f6e7a5384d15@gmail.com>
Date:   Fri, 6 Mar 2020 23:55:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <de8e697e-dd20-cbae-4d2d-b1e8994ba65d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far tx_skb->skb is the only member of the two structs that is not
reset. Make understanding the code easier by resetting both structs
completely in rtl8169_unmap_tx_skb.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c0999efa0..359f029a7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3976,11 +3976,8 @@ static void rtl8169_unmap_tx_skb(struct device *d, struct ring_info *tx_skb,
 	unsigned int len = tx_skb->len;
 
 	dma_unmap_single(d, le64_to_cpu(desc->addr), len, DMA_TO_DEVICE);
-
-	desc->opts1 = 0x00;
-	desc->opts2 = 0x00;
-	desc->addr = 0x00;
-	tx_skb->len = 0;
+	memset(desc, 0, sizeof(*desc));
+	memset(tx_skb, 0, sizeof(*tx_skb));
 }
 
 static void rtl8169_tx_clear_range(struct rtl8169_private *tp, u32 start,
@@ -3998,10 +3995,8 @@ static void rtl8169_tx_clear_range(struct rtl8169_private *tp, u32 start,
 
 			rtl8169_unmap_tx_skb(tp_to_dev(tp), tx_skb,
 					     tp->TxDescArray + entry);
-			if (skb) {
+			if (skb)
 				dev_consume_skb_any(skb);
-				tx_skb->skb = NULL;
-			}
 		}
 	}
 }
@@ -4396,6 +4391,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 	for (tx_left = tp->cur_tx - dirty_tx; tx_left > 0; tx_left--) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
 		struct ring_info *tx_skb = tp->tx_skb + entry;
+		struct sk_buff *skb = tx_skb->skb;
 		u32 status;
 
 		status = le32_to_cpu(tp->TxDescArray[entry].opts1);
@@ -4410,11 +4406,10 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 		rtl8169_unmap_tx_skb(tp_to_dev(tp), tx_skb,
 				     tp->TxDescArray + entry);
-		if (tx_skb->skb) {
+		if (skb) {
 			pkts_compl++;
-			bytes_compl += tx_skb->skb->len;
-			napi_consume_skb(tx_skb->skb, budget);
-			tx_skb->skb = NULL;
+			bytes_compl += skb->len;
+			napi_consume_skb(skb, budget);
 		}
 		dirty_tx++;
 	}
-- 
2.25.1


