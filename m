Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D33A1C0731
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgD3UAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3UAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:00:10 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6580C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:09 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 188so3403637wmc.2
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=exoUBmUOUk51sdbUmJ/JC6+r2vGsM+WSWc94/gi6cqw=;
        b=qtRpRvrmSokDPPglhVSgRF4KGv4awk/s/gcVLsEG8a8CG+0pw2ho+digQVPN51p7Dy
         SC5394c9pg/fzytiQNTpYx+UDRXtfiAAL9V3aTy8K1rcRnHGuqF/7y6S7YKovNj8TjwX
         2gTBp8G9TRDndhbBrtvmpdMEy0MUQwMuGPRKxT9/ZE7SUVn3Y7naTNUpNjM8CCOwde8x
         rGEkim9+2nbY6gF95GmTIRPtaRJX83Uz6n9k3y/BSNRCl3USZchiC6492M3rVXxi6ihJ
         G41U2ccgyVlzPGdWJLQ37p/+MxtIEt0DkzP4yE9WGRY2t17VjAX0tH+SWZREqet+lG3c
         72Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=exoUBmUOUk51sdbUmJ/JC6+r2vGsM+WSWc94/gi6cqw=;
        b=Y9vdD12aveQbEXSs5s0qPxt6Git2vx3ir8VGsI4oYyBybJhWaYYOP04gKCdGc/0VXR
         czyR85ZMZhChsY+wqmh5rbeuQRWBFFfJfuUzZAxVjEInLRJATxcc7zZZTWKg5mL85VW5
         +7yOyKXaqIE1wykyxv1PxhxaN9wEZ7qbBwMGEc4Z0AwTBlEvbdte/1W5dmk1S52Ey91o
         hzMO2oxAsP0OmBe0ezlmMOfnGZqA6zcoZc60JDzEGo2ipcwUZ5BpxS1x7gsBynxeqlns
         d+R2E7mEonFPWafojZuC5R2mp5z8kdDIw14Aite3OHDM2VkGic8Pjl85J55zjwTTcr43
         8vHQ==
X-Gm-Message-State: AGi0PuZn78kOykjhuEkPNwo3RiyQeE4CZx4bUwW6ibVqc90k7fLsTc0w
        XTZpYiViO+XQ3VhWRAz1HGlOXS4h
X-Google-Smtp-Source: APiQypI/TAkD2D9djm4nPryO5CsyZ89nYKJLMs8n64y9QszlY+3KfeZD/JII740bMFxC5ILJaR5puw==
X-Received: by 2002:a1c:2e07:: with SMTP id u7mr290570wmu.74.1588276808393;
        Thu, 30 Apr 2020 13:00:08 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f0e:e300:b04f:e17d:bb1a:140e? (p200300EA8F0EE300B04FE17DBB1A140E.dip0.t-ipconnect.de. [2003:ea:8f0e:e300:b04f:e17d:bb1a:140e])
        by smtp.googlemail.com with ESMTPSA id r3sm1104080wrx.72.2020.04.30.13.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 13:00:08 -0700 (PDT)
Subject: [PATCH net-next 1/7] r8169: don't pass net_device to irq coalescing
 sub-functions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Message-ID: <89a48173-088d-33b1-4346-d2b39903f113@gmail.com>
Date:   Thu, 30 Apr 2020 21:55:36 +0200
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

The net_device argument is just used to get a struct rtl8169_private
pointer via netdev_priv(). Therefore pass the struct rtl8169_private
pointer directly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7aea37455..726f4057a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1805,9 +1805,9 @@ static const struct rtl_coalesce_info rtl_coalesce_info_8168_8136[] = {
 #undef rxtx_x1822
 
 /* get rx/tx scale vector corresponding to current speed */
-static const struct rtl_coalesce_info *rtl_coalesce_info(struct net_device *dev)
+static const struct rtl_coalesce_info *
+rtl_coalesce_info(struct rtl8169_private *tp)
 {
-	struct rtl8169_private *tp = netdev_priv(dev);
 	const struct rtl_coalesce_info *ci;
 
 	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
@@ -1844,7 +1844,7 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	memset(ec, 0, sizeof(*ec));
 
 	/* get rx/tx scale corresponding to current speed and CPlusCmd[0:1] */
-	ci = rtl_coalesce_info(dev);
+	ci = rtl_coalesce_info(tp);
 	if (IS_ERR(ci))
 		return PTR_ERR(ci);
 
@@ -1874,12 +1874,12 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 
 /* choose appropriate scale factor and CPlusCmd[0:1] for (speed, nsec) */
 static const struct rtl_coalesce_scale *rtl_coalesce_choose_scale(
-			struct net_device *dev, u32 nsec, u16 *cp01)
+			struct rtl8169_private *tp, u32 nsec, u16 *cp01)
 {
 	const struct rtl_coalesce_info *ci;
 	u16 i;
 
-	ci = rtl_coalesce_info(dev);
+	ci = rtl_coalesce_info(tp);
 	if (IS_ERR(ci))
 		return ERR_CAST(ci);
 
@@ -1912,7 +1912,7 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	if (rtl_is_8125(tp))
 		return -EOPNOTSUPP;
 
-	scale = rtl_coalesce_choose_scale(dev,
+	scale = rtl_coalesce_choose_scale(tp,
 			max(p[0].usecs, p[1].usecs) * 1000, &cp01);
 	if (IS_ERR(scale))
 		return PTR_ERR(scale);
-- 
2.26.2


