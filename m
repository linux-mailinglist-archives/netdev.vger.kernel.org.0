Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C051C0736
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgD3UAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3UAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:00:15 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7E6C035495
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:14 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id d17so8659854wrg.11
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cpFimzWoozjKsVij7lzXym35YHu+qrX0vnNJLs1+xuo=;
        b=LM5Tud46SkNmzVc8KdZzFc6PWtesgftXw66sprVSEGCWnrWSA2W3G0qaD47YMMUD0s
         gWqCKlMtdjP/hq7JifmwX+Y1gVYLwjjAsKjw4KdwkgcQ3QtV714mAfryKeOpF8j+Gm2C
         jZKOc5piRKRvPkzYhQirNB9oqT8tNJKMoblpALvJPuTUnN9j4aPvFX3s+uZTLRsi58kw
         RBLtbjIS7J+tcyAfVExKyDzm/p4gi51yCcluUPdy3gtEqeVVBDnBg/FbFwVCe2Xu8ECa
         Pm+27yUr6rdU58+JONU6+eXKl7pftDzHkSQ8LIvJrrsRZPdRLba06PsYsIxJvDEnsFX+
         QYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cpFimzWoozjKsVij7lzXym35YHu+qrX0vnNJLs1+xuo=;
        b=t8KDRAKo1Xpx/932x2pQrmz6cWB9MmbSaBjG2GTwKZPvpbOv8JML6kNPE0CVb4BFTi
         DC6ur2cXebae7/I3yWFY5urO/VGTPrV+UYrGM6LDa+TWJkNiV0/3O2Gboh6OtmwiAGsa
         1bPj0Vs8haf5i5sYxHPN3NJXnw4xhX6pwppwfLi8HdOsCTbBqCJ06g1vdwUHOQx24HA1
         zsYJjMcSIXlElat9x6AOd8GwB1m9uP1MrNYdzsN8jsrY/RUXGuKJFhbEdO3V1lWtau+8
         z4jfMlFgaDgkbEdMmzgiwbJC7Gr2UroAjdSCD/zLcircfe82QnLBSZ2rrw/51UbmK+28
         4ZAg==
X-Gm-Message-State: AGi0PualdSf7MRTwCfYEsKio4pbMeOV+KHd90EVfBsFkqIoGuvr4UICZ
        yjEAm/0n/gRrD2M6Ck2lBJOFNquz
X-Google-Smtp-Source: APiQypIC9cBkYm8gKHwQ/Ry25kK3slzhRO1RoBFaIQlILtjpgK8r4ekFlNQkXWoROB0nObsof8s+yA==
X-Received: by 2002:a5d:5652:: with SMTP id j18mr304679wrw.40.1588276813229;
        Thu, 30 Apr 2020 13:00:13 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f0e:e300:b04f:e17d:bb1a:140e? (p200300EA8F0EE300B04FE17DBB1A140E.dip0.t-ipconnect.de. [2003:ea:8f0e:e300:b04f:e17d:bb1a:140e])
        by smtp.googlemail.com with ESMTPSA id t17sm1062225wro.2.2020.04.30.13.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 13:00:12 -0700 (PDT)
Subject: [PATCH net-next 6/7] r8169: improve rtl_set_coalesce
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Message-ID: <476d8086-5c35-9238-84d0-7f44ed849ffc@gmail.com>
Date:   Thu, 30 Apr 2020 21:58:47 +0200
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

Use FIELD_PREP() to make the code better readable, and avoid the loop.
No functional change intended.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++-------------
 1 file changed, 30 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index fe95c47e7..3fef1b254 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -235,10 +235,8 @@ enum rtl_registers {
 #define RTL_COALESCE_RX_USECS	GENMASK(7, 4)
 #define RTL_COALESCE_RX_FRAMES	GENMASK(3, 0)
 
-#define RTL_COALESCE_MASK	0x0f
-#define RTL_COALESCE_SHIFT	4
-#define RTL_COALESCE_T_MAX	(RTL_COALESCE_MASK)
-#define RTL_COALESCE_FRAME_MAX	(RTL_COALESCE_MASK << 2)
+#define RTL_COALESCE_T_MAX	0x0fU
+#define RTL_COALESCE_FRAME_MAX	(RTL_COALESCE_T_MAX * 4)
 
 	RxDescAddrLow	= 0xe4,
 	RxDescAddrHigh	= 0xe8,
@@ -1878,57 +1876,49 @@ static int rtl_coalesce_choose_scale(struct rtl8169_private *tp, u32 usec,
 static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
-	struct {
-		u32 frames;
-		u32 usecs;
-	} coal_settings [] = {
-		{ ec->rx_max_coalesced_frames, ec->rx_coalesce_usecs },
-		{ ec->tx_max_coalesced_frames, ec->tx_coalesce_usecs }
-	}, *p = coal_settings;
+	u32 tx_fr = ec->tx_max_coalesced_frames;
+	u32 rx_fr = ec->rx_max_coalesced_frames;
+	u32 coal_usec_max, units;
 	u16 w = 0, cp01 = 0;
-	u32 coal_usec_max;
-	int scale, i;
+	int scale;
 
 	if (rtl_is_8125(tp))
 		return -EOPNOTSUPP;
 
+	if (rx_fr > RTL_COALESCE_FRAME_MAX || tx_fr > RTL_COALESCE_FRAME_MAX)
+		return -ERANGE;
+
 	coal_usec_max = max(ec->rx_coalesce_usecs, ec->tx_coalesce_usecs);
 	scale = rtl_coalesce_choose_scale(tp, coal_usec_max, &cp01);
 	if (scale < 0)
 		return scale;
 
-	for (i = 0; i < 2; i++, p++) {
-		u32 units;
-
-		/*
-		 * accept max_frames=1 we returned in rtl_get_coalesce.
-		 * accept it not only when usecs=0 because of e.g. the following scenario:
-		 *
-		 * - both rx_usecs=0 & rx_frames=0 in hardware (no delay on RX)
-		 * - rtl_get_coalesce returns rx_usecs=0, rx_frames=1
-		 * - then user does `ethtool -C eth0 rx-usecs 100`
-		 *
-		 * since ethtool sends to kernel whole ethtool_coalesce
-		 * settings, if we want to ignore rx_frames then it has
-		 * to be set to 0.
-		 */
-		if (p->frames == 1) {
-			p->frames = 0;
-		}
+	/* Accept max_frames=1 we returned in rtl_get_coalesce. Accept it
+	 * not only when usecs=0 because of e.g. the following scenario:
+	 *
+	 * - both rx_usecs=0 & rx_frames=0 in hardware (no delay on RX)
+	 * - rtl_get_coalesce returns rx_usecs=0, rx_frames=1
+	 * - then user does `ethtool -C eth0 rx-usecs 100`
+	 *
+	 * Since ethtool sends to kernel whole ethtool_coalesce settings,
+	 * if we want to ignore rx_frames then it has to be set to 0.
+	 */
+	if (rx_fr == 1)
+		rx_fr = 0;
+	if (tx_fr == 1)
+		tx_fr = 0;
 
-		units = DIV_ROUND_UP(p->usecs * 1000, scale);
-		if (p->frames > RTL_COALESCE_FRAME_MAX)
-			return -ERANGE;
+	w |= FIELD_PREP(RTL_COALESCE_TX_FRAMES, DIV_ROUND_UP(tx_fr, 4));
+	w |= FIELD_PREP(RTL_COALESCE_RX_FRAMES, DIV_ROUND_UP(rx_fr, 4));
 
-		w <<= RTL_COALESCE_SHIFT;
-		w |= units;
-		w <<= RTL_COALESCE_SHIFT;
-		w |= DIV_ROUND_UP(p->frames, 4);
-	}
+	units = DIV_ROUND_UP(ec->tx_coalesce_usecs * 1000U, scale);
+	w |= FIELD_PREP(RTL_COALESCE_TX_USECS, units);
+	units = DIV_ROUND_UP(ec->rx_coalesce_usecs * 1000U, scale);
+	w |= FIELD_PREP(RTL_COALESCE_RX_USECS, units);
 
 	rtl_lock_work(tp);
 
-	RTL_W16(tp, IntrMitigate, swab16(w));
+	RTL_W16(tp, IntrMitigate, w);
 
 	tp->cp_cmd = (tp->cp_cmd & ~INTT_MASK) | cp01;
 	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
-- 
2.26.2


