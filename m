Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC821C0733
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgD3UAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3UAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:00:12 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAE0C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:10 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x4so3408831wmj.1
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sZWt42IkXoz6fTpATIpmdrNPAwDi2KVKj/U0sinlL94=;
        b=MLNzvrIRQwt/p9gj08eYztMwIbYhgWjxybkBIxiD9Fz5GE+oWqhVGlAQKwrSydVhLH
         nYe0oBXpk9CGoTce7E0biIz+B8V/DJKqmyRDs3vwjtTX05fNI7x3e6VtioYVTFSZiCMG
         Dcwfp/k1qX9W/cKQyErQDLsM3AFdAYeMxjwfkbfLZKoWg98YlNGXoN2t78Xakir/Lw6O
         ubivY+A0Wtk6eoXWm2syVEoPRDe19Vu43Yh8BIknA7x92NKbA5q/Fn8snPo34UEp9Vqo
         EldjdJk1d6nKN/B/It2UPJBwucd3/efL4MqkVtsKUVBOv25U4TxbLNP0Q0kwdxGvrMx+
         aPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sZWt42IkXoz6fTpATIpmdrNPAwDi2KVKj/U0sinlL94=;
        b=f5hAKjMkpAJeXkrSlB7uo4+bxCIWRlsHK/XQN/i1IthCwsMwOIIvLZLckhfVlqH9Ik
         LpsQraGKSU8bsUBvBH5CuRKrEC2xw1zSeKS0qymLZUXJXw73zd7ExUCzJgeQzJECKeho
         842zjc+UvF15CXhEQNE2sPDNqyHBG9eBxttZfMA/f9CRAAPdVLBvNpKWEA8+7Kb7WTkZ
         Lx8h6aQgAjSKFNFKfou43woG4kzXK2HPbKYWD6Pggm5oWTU9lWtABtY8ArKZ/5B5hCbE
         f1ooBIGV068nVA9cmR72XOdaYsYFxx6T/iUy2FQZpBqFn9mqvUkTsg7XYyGgjvq/gmne
         OC4g==
X-Gm-Message-State: AGi0PubaOjAqLiAlLmKovwy8Rq/VcKWZzjb7ecrszMHJLYYWvjwZKotb
        CUYRmccoxWZBy+tmq6wiyyUgtHgS
X-Google-Smtp-Source: APiQypL2jdtcFM5ZCUdbMlERajuXYAxFfgwBrWK3NAMzCcypjNWoC2I+Cg94xKf9nJHMeu/t1JQrqw==
X-Received: by 2002:a1c:7706:: with SMTP id t6mr281396wmi.110.1588276809307;
        Thu, 30 Apr 2020 13:00:09 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f0e:e300:b04f:e17d:bb1a:140e? (p200300EA8F0EE300B04FE17DBB1A140E.dip0.t-ipconnect.de. [2003:ea:8f0e:e300:b04f:e17d:bb1a:140e])
        by smtp.googlemail.com with ESMTPSA id b191sm1000574wmd.39.2020.04.30.13.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 13:00:08 -0700 (PDT)
Subject: [PATCH net-next 2/7] r8169: merge scale for tx and rx irq coalescing
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Message-ID: <47a27f86-23c8-7328-9329-39797f166013@gmail.com>
Date:   Thu, 30 Apr 2020 21:56:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rx and tx scale are the same always. Simplify the code by using one
scale for rx and tx only.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 65 +++++++++--------------
 1 file changed, 25 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 726f4057a..1fddc5a5e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1768,41 +1768,29 @@ static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
  * 1 1                     160us           81.92us         1.31ms
  */
 
-/* rx/tx scale factors for one particular CPlusCmd[0:1] value */
-struct rtl_coalesce_scale {
-	/* Rx / Tx */
-	u32 nsecs[2];
-};
-
 /* rx/tx scale factors for all CPlusCmd[0:1] cases */
 struct rtl_coalesce_info {
 	u32 speed;
-	struct rtl_coalesce_scale scalev[4];	/* each CPlusCmd[0:1] case */
+	u32 scale_nsecs[4];
 };
 
-/* produce (r,t) pairs with each being in series of *1, *8, *8*2, *8*2*2 */
-#define rxtx_x1822(r, t) {		\
-	{{(r),		(t)}},		\
-	{{(r)*8,	(t)*8}},	\
-	{{(r)*8*2,	(t)*8*2}},	\
-	{{(r)*8*2*2,	(t)*8*2*2}},	\
-}
+/* produce array with base delay *1, *8, *8*2, *8*2*2 */
+#define COALESCE_DELAY(d) { (d), 8 * (d), 16 * (d), 32 * (d) }
+
 static const struct rtl_coalesce_info rtl_coalesce_info_8169[] = {
-	/* speed	delays:     rx00   tx00	*/
-	{ SPEED_10,	rxtx_x1822(40960, 40960)	},
-	{ SPEED_100,	rxtx_x1822( 2560,  2560)	},
-	{ SPEED_1000,	rxtx_x1822(  320,   320)	},
+	{ SPEED_10,	COALESCE_DELAY(40960) },
+	{ SPEED_100,	COALESCE_DELAY(2560) },
+	{ SPEED_1000,	COALESCE_DELAY(320) },
 	{ 0 },
 };
 
 static const struct rtl_coalesce_info rtl_coalesce_info_8168_8136[] = {
-	/* speed	delays:     rx00   tx00	*/
-	{ SPEED_10,	rxtx_x1822(40960, 40960)	},
-	{ SPEED_100,	rxtx_x1822( 2560,  2560)	},
-	{ SPEED_1000,	rxtx_x1822( 5000,  5000)	},
+	{ SPEED_10,	COALESCE_DELAY(40960) },
+	{ SPEED_100,	COALESCE_DELAY(2560) },
+	{ SPEED_1000,	COALESCE_DELAY(5000) },
 	{ 0 },
 };
-#undef rxtx_x1822
+#undef COALESCE_DELAY
 
 /* get rx/tx scale vector corresponding to current speed */
 static const struct rtl_coalesce_info *
@@ -1827,7 +1815,6 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 	const struct rtl_coalesce_info *ci;
-	const struct rtl_coalesce_scale *scale;
 	struct {
 		u32 *max_frames;
 		u32 *usecs;
@@ -1835,6 +1822,7 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 		{ &ec->rx_max_coalesced_frames, &ec->rx_coalesce_usecs },
 		{ &ec->tx_max_coalesced_frames, &ec->tx_coalesce_usecs }
 	}, *p = coal_settings;
+	u32 scale;
 	int i;
 	u16 w;
 
@@ -1848,7 +1836,7 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	if (IS_ERR(ci))
 		return PTR_ERR(ci);
 
-	scale = &ci->scalev[tp->cp_cmd & INTT_MASK];
+	scale = ci->scale_nsecs[tp->cp_cmd & INTT_MASK];
 
 	/* read IntrMitigate and adjust according to scale */
 	for (w = RTL_R16(tp, IntrMitigate); w; w >>= RTL_COALESCE_SHIFT, p++) {
@@ -1859,7 +1847,7 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 
 	for (i = 0; i < 2; i++) {
 		p = coal_settings + i;
-		*p->usecs = (*p->usecs * scale->nsecs[i]) / 1000;
+		*p->usecs = (*p->usecs * scale) / 1000;
 
 		/*
 		 * ethtool_coalesce says it is illegal to set both usecs and
@@ -1873,32 +1861,29 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 }
 
 /* choose appropriate scale factor and CPlusCmd[0:1] for (speed, nsec) */
-static const struct rtl_coalesce_scale *rtl_coalesce_choose_scale(
-			struct rtl8169_private *tp, u32 nsec, u16 *cp01)
+static int rtl_coalesce_choose_scale(struct rtl8169_private *tp, u32 nsec,
+				     u16 *cp01)
 {
 	const struct rtl_coalesce_info *ci;
 	u16 i;
 
 	ci = rtl_coalesce_info(tp);
 	if (IS_ERR(ci))
-		return ERR_CAST(ci);
+		return PTR_ERR(ci);
 
 	for (i = 0; i < 4; i++) {
-		u32 rxtx_maxscale = max(ci->scalev[i].nsecs[0],
-					ci->scalev[i].nsecs[1]);
-		if (nsec <= rxtx_maxscale * RTL_COALESCE_T_MAX) {
+		if (nsec <= ci->scale_nsecs[i] * RTL_COALESCE_T_MAX) {
 			*cp01 = i;
-			return &ci->scalev[i];
+			return ci->scale_nsecs[i];
 		}
 	}
 
-	return ERR_PTR(-EINVAL);
+	return -EINVAL;
 }
 
 static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
-	const struct rtl_coalesce_scale *scale;
 	struct {
 		u32 frames;
 		u32 usecs;
@@ -1906,16 +1891,16 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 		{ ec->rx_max_coalesced_frames, ec->rx_coalesce_usecs },
 		{ ec->tx_max_coalesced_frames, ec->tx_coalesce_usecs }
 	}, *p = coal_settings;
-	u16 w = 0, cp01;
-	int i;
+	u16 w = 0, cp01 = 0;
+	int scale, i;
 
 	if (rtl_is_8125(tp))
 		return -EOPNOTSUPP;
 
 	scale = rtl_coalesce_choose_scale(tp,
 			max(p[0].usecs, p[1].usecs) * 1000, &cp01);
-	if (IS_ERR(scale))
-		return PTR_ERR(scale);
+	if (scale < 0)
+		return scale;
 
 	for (i = 0; i < 2; i++, p++) {
 		u32 units;
@@ -1936,7 +1921,7 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 			p->frames = 0;
 		}
 
-		units = p->usecs * 1000 / scale->nsecs[i];
+		units = p->usecs * 1000 / scale;
 		if (p->frames > RTL_COALESCE_FRAME_MAX || p->frames % 4)
 			return -EINVAL;
 
-- 
2.26.2


