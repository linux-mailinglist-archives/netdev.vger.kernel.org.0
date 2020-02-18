Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DB71632CB
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgBRUQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:30 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51737 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgBRUQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:23 -0500
Received: by mail-wm1-f65.google.com with SMTP id t23so4100778wmi.1;
        Tue, 18 Feb 2020 12:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j9++cZ/IP+wbbDCQ64mmb3OUnzsqMjEjsl1uqLXQ9Hc=;
        b=WOSx8qaaGWz+JOaf5TSGTQ1tPjayIZ97VF3VmkCbwIm2Q0NJ8Ai7xUpq1PRwlGi9UH
         bluLaY8ZYv50q0quvdJCyLERldS3GSXemhexxoRNuZkwGiKy1vfXHTWpzJ3HMA1cKszL
         EnfhyuHkx37MwBFiN6qQA+kA8Kc13B1NeYrpv+G4Gl3Gq/UIwrCDc7xN1VejAF4ib2Ba
         K8uy4p87L3lUsxTTeJP4RSFlGQnA2IUlO40lqt1FBw9AaMRdMCcqxP3R8eQ25nRfQf0I
         haPjy6FFzIPgMK/QOdYA94GU9qoSnU+TveQ6hN1RqyVHPjvXNM8g5AXEFrYV4vERxVqG
         kD9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j9++cZ/IP+wbbDCQ64mmb3OUnzsqMjEjsl1uqLXQ9Hc=;
        b=sqS5483YEwaEJEzLYN9G0M2OUIWrIuC7mSA5zbPARpW4Y95EP93sNDCU5pv653F+A3
         KjONvx2pdoPXWY3SdRpHN20L61dPGKjOHaPJJIV5rW+79qJBu1ojqZn0JMYC91oO/3fJ
         aGGC8EEeVaxRdhmNNc/0T1/7UGcuV+LoZT9+vHbBrMF9fQJmi8YXSEoSPUeHwHaYY3D2
         6lGn6ThyxYEtYBShOOeO0WAnOjhnXtf13GmyHb/0p3P6qY0KejgFbjXvQ6CkrPkKaMcP
         n3dKKa0p7BuEfT3sgFUSXhDOAHz715/alxbwmwYES9Af4ucwEMOMqjFMFg6EX32Ya/D5
         q37w==
X-Gm-Message-State: APjAAAXfI/GMtguvZ6YNxQ+8esB05d8oZt72TP8u8KAqAZZtcugZsQZY
        AndNyMaZx3KkralWme+0lPHPd/V7
X-Google-Smtp-Source: APXvYqwssbUYngfobHc+Zd32PF8GyLWgR88HwW/3rHhOxchbGNWeIvyapBtxQhYHOPHxemQgyUkLhg==
X-Received: by 2002:a1c:1f56:: with SMTP id f83mr4832027wmf.93.1582056980798;
        Tue, 18 Feb 2020 12:16:20 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id j15sm8120513wrp.9.2020.02.18.12.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:20 -0800 (PST)
Subject: [PATCH net-next v2 12/13] r8152: use new helper tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <1dd1668a-b3c6-d441-681d-6cbe3ab22fa4@gmail.com>
Date:   Tue, 18 Feb 2020 21:12:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper tcp_v6_gso_csum_prep in additional network drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/usb/r8152.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 78ddbaf64..709578f4d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1948,29 +1948,6 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 	}
 }
 
-/* msdn_giant_send_check()
- * According to the document of microsoft, the TCP Pseudo Header excludes the
- * packet length for IPv6 TCP large packets.
- */
-static int msdn_giant_send_check(struct sk_buff *skb)
-{
-	const struct ipv6hdr *ipv6h;
-	struct tcphdr *th;
-	int ret;
-
-	ret = skb_cow_head(skb, 0);
-	if (ret)
-		return ret;
-
-	ipv6h = ipv6_hdr(skb);
-	th = tcp_hdr(skb);
-
-	th->check = 0;
-	th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
-
-	return ret;
-}
-
 static inline void rtl_tx_vlan_tag(struct tx_desc *desc, struct sk_buff *skb)
 {
 	if (skb_vlan_tag_present(skb)) {
@@ -2016,10 +1993,11 @@ static int r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc,
 			break;
 
 		case htons(ETH_P_IPV6):
-			if (msdn_giant_send_check(skb)) {
+			if (skb_cow_head(skb, 0)) {
 				ret = TX_CSUM_TSO;
 				goto unavailable;
 			}
+			tcp_v6_gso_csum_prep(skb);
 			opts1 |= GTSENDV6;
 			break;
 
-- 
2.25.1


