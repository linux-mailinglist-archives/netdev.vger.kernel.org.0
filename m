Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0CE1632D4
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgBRUQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:16 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33716 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgBRUQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:13 -0500
Received: by mail-wm1-f65.google.com with SMTP id m10so2983865wmc.0;
        Tue, 18 Feb 2020 12:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NiB0gYJtVh4XqjFzKHUq7rr/qTHV5TRjAy5y8PoqEnI=;
        b=AgdQgVf1xtudUwbV3cxx0uX+jcPllvVK7pxFiQSbdbfANjaNdxD46+7yTsqX95X6VT
         KxYzen35g/I4ILmQr6cpOYzJspauqCgqbsz/RdvPIOUUZ3Pj+uUZpn4bDbowXl7ey9HG
         oi+vZTxFeYnlErv8YZQg/zGw6FTlFA336f5vz1uinbUwkwApbjXU1uOk4XE+2j4c8afz
         DPz3CI8qhrI3hr4X3UiVIuxwVjs1w7+OWxYK0TKQxv0yEq1oIbo19J0vtNpItbBgRB63
         wg8kSg2u1B6NcWOjn7lYl2Y8gYwe1N1t5kXLP3lgQflXwRBEc7R6LbWYhkNybTgC64Cx
         PcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NiB0gYJtVh4XqjFzKHUq7rr/qTHV5TRjAy5y8PoqEnI=;
        b=l7BZB7NZN9O84zCGeOAz+1Gxxo5pdR/WhrthTiK6TvCVL50sj4d7OxEptURTCBK4xy
         WpzNb0H+nmleWXLtBpFT9uYm2jpqdd1wpm+fKQfBQi9hCIulsD7V3ZmWMXMiq2T5TeSQ
         MS38DvYDKhjL3QeZP8HXom2Ro3M5g3XBf+lvoNrRh7rdpzNrnK8/0yoWO1hNLXU4+BTo
         DsbgcOetJ6d7PW8zrncTChBrXUydUdH3KnV8fBJ0mvdDz63q3wSAKAeDkUWM7VXj3csQ
         Ywun4PezoHZAhUANkVZl/funk0UhB0i/Wf1/YAo2TW9lLRLQvQO0a5abIsMEye4AAatH
         DhSw==
X-Gm-Message-State: APjAAAUENv5+wxVVz6LZPLFlF6QIT4dDArBLiZNS5XQoWvhpzBxNYa6g
        cIz/5HhFO0r37clKIh7ERHLq2BwX
X-Google-Smtp-Source: APXvYqwi6eF1HbMfOHzP0n/iQiZYv9cLCnZ+Pg9W9uXA4CqI3Cw8JlFnSw+8Lq4fN66Ha2MvlyRmow==
X-Received: by 2002:a1c:4d08:: with SMTP id o8mr5074259wmh.86.1582056970073;
        Tue, 18 Feb 2020 12:16:10 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id u14sm7213382wrm.51.2020.02.18.12.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:09 -0800 (PST)
Subject: [PATCH net-next v2 02/13] r8169: use new helper tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <76384f13-f51e-2fd2-a84b-70c07a485b29@gmail.com>
Date:   Tue, 18 Feb 2020 20:58:14 +0100
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

Simplify the code by using the new helper tcp_v6_gso_csum_prep.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 26 ++---------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5a9143b50..8442b8767 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4108,29 +4108,6 @@ static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp, struct sk_buff *skb)
 	return skb->len < ETH_ZLEN && tp->mac_version == RTL_GIGA_MAC_VER_34;
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
 static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
 {
 	u32 mss = skb_shinfo(skb)->gso_size;
@@ -4163,9 +4140,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 			break;
 
 		case htons(ETH_P_IPV6):
-			if (msdn_giant_send_check(skb))
+			if (skb_cow_head(skb, 0))
 				return false;
 
+			tcp_v6_gso_csum_prep(skb);
 			opts[0] |= TD1_GTSENV6;
 			break;
 
-- 
2.25.1


