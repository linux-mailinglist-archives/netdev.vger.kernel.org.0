Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE571C0732
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgD3UAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgD3UAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:00:12 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA025C035495
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:11 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x4so3408921wmj.1
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xvo/DuSaZQpJt2g7vaqUdpY2uxVUQGOwL/FCwSMnpbQ=;
        b=KdS+Dfp1cAALK2HTbVTQlldcrKM534D0ttOZTuD8Dms84GDVuwEW9QJL3usBZ3SPQY
         gbWVQwjruwFal/qLqmC7o24HS42BOw/rH46avztb6LmLatWrjo7rAEeXhoezxw6qV04N
         NBPabOmZet3IFjvqkNJjeV5aq7mx/VLDzu1p54K2qipp4qfPh6nqW6kjeV+n0jmXEDw+
         7bS7ZM+izZMAZJtot4IBDK52pYH6vBmCW+hIAe1rKljxnjhKXold3F2/mvX4rnUJNzX0
         AS0RVZzRochvjfjinP/MPggR/xa8EyuyOaNQL4JkdkHI55UQoSbvRhMcvJycptyzcaEu
         J+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xvo/DuSaZQpJt2g7vaqUdpY2uxVUQGOwL/FCwSMnpbQ=;
        b=eH7soXJ/fW/BMqjY1zX+w75FlLK9xJPthE4NLRT1My3/PoLB3JyEY0LPFMPhOZWY/a
         iAVZZfZY242nVzBgqNz56xKWDNc6ASnZPECgMV2kfRWZoy7aCgdqDMuSn0t0zu43o0YR
         PEjpb1hrDP8MtzCroVQDL6OA3QMwzcnkfIn725nQpBsPMkMT/Ni1ttQ4E4emNHqIsbhY
         IDK+TyTzMKcOlYrp3KoGKas6tYYeaIF+BNFMFj7fZy37cqZYHcOojQgqUsb5e2XEmtyl
         3fO+7+liSWKLrF+BFjhsZgeVywky2ki2UcEQRM/nvCPQ5MDh1LUyXHdS92EhhkKb0SHa
         g81A==
X-Gm-Message-State: AGi0PuY16EWca1NfogW0o7QlTm9/p4FZIha5fK23yIggcPf++2jLwqU0
        6dE/l4PCNK1vK3SSyKZqYdZ7knvz
X-Google-Smtp-Source: APiQypJ1paDewKuilIDKvY5tIfciIV2eFPC4m9QZKVqrCz3J69YANui4MdsHuLafLT6+oXbV3kbogQ==
X-Received: by 2002:a1c:4985:: with SMTP id w127mr282823wma.100.1588276810353;
        Thu, 30 Apr 2020 13:00:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f0e:e300:b04f:e17d:bb1a:140e? (p200300EA8F0EE300B04FE17DBB1A140E.dip0.t-ipconnect.de. [2003:ea:8f0e:e300:b04f:e17d:bb1a:140e])
        by smtp.googlemail.com with ESMTPSA id j11sm1047435wrr.62.2020.04.30.13.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 13:00:09 -0700 (PDT)
Subject: [PATCH net-next 3/7] r8169: improve rtl_get_coalesce
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Message-ID: <138e7b9f-0eaf-ee4d-135a-1ffad474ffca@gmail.com>
Date:   Thu, 30 Apr 2020 21:56:58 +0200
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

Use FIELD_GET() macro to make the code better readable. In addition
change the logic to round the time limit up, not down. Reason is that
a time limit <1us would be rounded to 0 currently, what would be
interpreted as "no time limit set".

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 46 ++++++++++-------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1fddc5a5e..d898e6f5f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
+#include <linux/bitfield.h>
 #include <linux/prefetch.h>
 #include <linux/ipv6.h>
 #include <net/ip6_checksum.h>
@@ -229,6 +230,11 @@ enum rtl_registers {
 	CPlusCmd	= 0xe0,
 	IntrMitigate	= 0xe2,
 
+#define RTL_COALESCE_TX_USECS	GENMASK(15, 12)
+#define RTL_COALESCE_TX_FRAMES	GENMASK(11, 8)
+#define RTL_COALESCE_RX_USECS	GENMASK(7, 4)
+#define RTL_COALESCE_RX_FRAMES	GENMASK(3, 0)
+
 #define RTL_COALESCE_MASK	0x0f
 #define RTL_COALESCE_SHIFT	4
 #define RTL_COALESCE_T_MAX	(RTL_COALESCE_MASK)
@@ -1815,16 +1821,8 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 	const struct rtl_coalesce_info *ci;
-	struct {
-		u32 *max_frames;
-		u32 *usecs;
-	} coal_settings [] = {
-		{ &ec->rx_max_coalesced_frames, &ec->rx_coalesce_usecs },
-		{ &ec->tx_max_coalesced_frames, &ec->tx_coalesce_usecs }
-	}, *p = coal_settings;
-	u32 scale;
-	int i;
-	u16 w;
+	u32 scale, c_us, c_fr;
+	u16 intrmit;
 
 	if (rtl_is_8125(tp))
 		return -EOPNOTSUPP;
@@ -1838,24 +1836,20 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 
 	scale = ci->scale_nsecs[tp->cp_cmd & INTT_MASK];
 
-	/* read IntrMitigate and adjust according to scale */
-	for (w = RTL_R16(tp, IntrMitigate); w; w >>= RTL_COALESCE_SHIFT, p++) {
-		*p->max_frames = (w & RTL_COALESCE_MASK) << 2;
-		w >>= RTL_COALESCE_SHIFT;
-		*p->usecs = w & RTL_COALESCE_MASK;
-	}
+	intrmit = RTL_R16(tp, IntrMitigate);
 
-	for (i = 0; i < 2; i++) {
-		p = coal_settings + i;
-		*p->usecs = (*p->usecs * scale) / 1000;
+	c_us = FIELD_GET(RTL_COALESCE_TX_USECS, intrmit);
+	ec->tx_coalesce_usecs = DIV_ROUND_UP(c_us * scale, 1000);
 
-		/*
-		 * ethtool_coalesce says it is illegal to set both usecs and
-		 * max_frames to 0.
-		 */
-		if (!*p->usecs && !*p->max_frames)
-			*p->max_frames = 1;
-	}
+	c_fr = FIELD_GET(RTL_COALESCE_TX_FRAMES, intrmit);
+	/* ethtool_coalesce states usecs and max_frames must not both be 0 */
+	ec->tx_max_coalesced_frames = (c_us || c_fr) ? c_fr * 4 : 1;
+
+	c_us = FIELD_GET(RTL_COALESCE_RX_USECS, intrmit);
+	ec->rx_coalesce_usecs = DIV_ROUND_UP(c_us * scale, 1000);
+
+	c_fr = FIELD_GET(RTL_COALESCE_RX_FRAMES, intrmit);
+	ec->rx_max_coalesced_frames = (c_us || c_fr) ? c_fr * 4 : 1;
 
 	return 0;
 }
-- 
2.26.2


