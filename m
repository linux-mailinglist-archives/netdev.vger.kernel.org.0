Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC551AF517
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgDRVLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRVLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:11:49 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E7AC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:48 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u127so5769913wmg.1
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cGy3WXZNRzpAaYYLHsrov2pyDQH/DpPaqhsPHoNPF3Y=;
        b=exEGxFSqsNspU7g0W48CRbX9lzDfDC9efOd4dNOCZMUPiWjTxu34s+tFD48ALbpsF0
         Wda0XHPFdYfxkzS+ZeBwoZrGg4tL9OUbmphW4ur4TmiZqszdSKQzpogDrormmEqv8hY1
         /XTYUW/uXAOCW/2aj17IcKqmW7HFytHzgGZpDXrwkO4aYWUyGbesktAEd/BXp7+T4+es
         y7i1dDu4Rpxz6TN53wQyI4T1pEecm2E3FDO8vUbaycbpWhzHTzmDLbqH+dYTTF7USZ9L
         qmYvudj65XWgvK0KIk8jZkGJ68YZuaoy6rCSeOeO8Z0npAq/b74iICpAKvCTWp5BDOJd
         8XRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cGy3WXZNRzpAaYYLHsrov2pyDQH/DpPaqhsPHoNPF3Y=;
        b=bVbW+SDpQr1Ka+s+W7FQLiXrCxwWb/HJwMf85Z33dFH9AbH2ivsVU76mTJTvLIm3d9
         28VEPUO1b3zPAVaBntr/w1s2IcsgxXKWyUY3OX2BirElUu4I/KqGF1vbxfBjgGO+rX8u
         9xsixQjTmlvx/+1hEHnhP+qXLJPHlT5IoHZynsEg8Gd8sGYDMCE4yMxczQ0CxXy2syQL
         j2XK9xaZkhDjcGQNkJQClvl6NCx4XTsGlcRIpA1Kl5AOegYRtOefrH8EeeXBtf4Lpodh
         s8e/oQiw/8Qhi2onMsVFtfJQOFVd94MQ3Ggetaf1NRiofDQYjA+202SdRJjEktajEjNu
         sK3Q==
X-Gm-Message-State: AGi0PuYKN9WdIVJe38XseMKMUq7BYyHNeQzlcMwaJr3tDndgtY6VaeDB
        8qSEDpP71LjyjmDHtQ9F+R6pXjHO
X-Google-Smtp-Source: APiQypJ2TYnZ+61V/n8HqOeZ8yjiBqgmDa8vvphWQXpJPnrHCO9wsSpO/h+/aQzP4lO7Y6R4tJxHVg==
X-Received: by 2002:a1c:bc09:: with SMTP id m9mr9355511wmf.145.1587244307516;
        Sat, 18 Apr 2020 14:11:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:939:e10c:14c5:fe9f? (p200300EA8F2960000939E10C14C5FE9F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:939:e10c:14c5:fe9f])
        by smtp.googlemail.com with ESMTPSA id j4sm32015567wrm.85.2020.04.18.14.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:11:47 -0700 (PDT)
Subject: [PATCH net-next 5/6] r8169: improve rtl8169_tso_csum_v2
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
Message-ID: <f3351d6e-2d47-119a-d899-79e3a5aac2c8@gmail.com>
Date:   Sat, 18 Apr 2020 23:10:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code and avoid the overhead of calling vlan_get_protocol().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e4bb6f36c..c7d9325f4 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4125,25 +4125,20 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 				struct sk_buff *skb, u32 *opts)
 {
 	u32 transport_offset = (u32)skb_transport_offset(skb);
-	u32 mss = skb_shinfo(skb)->gso_size;
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	u32 mss = shinfo->gso_size;
 
 	if (mss) {
-		switch (vlan_get_protocol(skb)) {
-		case htons(ETH_P_IP):
+		if (shinfo->gso_type & SKB_GSO_TCPV4) {
 			opts[0] |= TD1_GTSENV4;
-			break;
-
-		case htons(ETH_P_IPV6):
+		} else if (shinfo->gso_type & SKB_GSO_TCPV6) {
 			if (skb_cow_head(skb, 0))
 				return false;
 
 			tcp_v6_gso_csum_prep(skb);
 			opts[0] |= TD1_GTSENV6;
-			break;
-
-		default:
+		} else {
 			WARN_ON_ONCE(1);
-			break;
 		}
 
 		opts[0] |= transport_offset << GTTCPHO_SHIFT;
-- 
2.26.1


