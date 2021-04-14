Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D9235ED32
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 08:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349280AbhDNGYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 02:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346418AbhDNGX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 02:23:57 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84646C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 23:23:32 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id m9so5937427wrx.3
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 23:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YMkgQAoJZkeqxQkBQi6l8eHQRyPWm7jx0J+axLwE8wA=;
        b=OXxYOamjOd+k3DukkHuu1qW0mwcA2MzEpsAUfjZjUqDv91NiTchjlM2jZv+N+khaDx
         o5MJ4EI6BEZsz4NgdsHltBzrhJsrmNkGJ0X5ZLzYt/GMUPfKJ6rnazRevrwe47m8p85A
         V+MEc+3TlU6M+Rn7dg8ZKorQUZPJrItEM0d7RLU88QUn9avxB+WL1eD5sbzbHQZJaWVT
         luohYHZpKjBgL08NsEFU2OMNGoIWUXWYmiiLndpDOmQtAapF3tUbxZBBko9/3iiMocDf
         LQAMSKZFWl2My0/Q2YYepx/RTOjeVdbGWo+yXJMdZdnSm72e+5a18XktHT1QWtjbwqiW
         IRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YMkgQAoJZkeqxQkBQi6l8eHQRyPWm7jx0J+axLwE8wA=;
        b=tfyuL/7A+cEiEnF20u1j3C+UbmjjRjuExZNs6mg5Cz4z67gDglysl+wEUaStjdmLGu
         Geq/aXUc++et7kwyAb64JW85HBKUb1f17hacZ9jelwQhSaIKDqkID0QOdnWVyhmxph4o
         oylGHMv5dg+ebikHySdDNWtfFBQ3VGXl5KI9VB+0Rl35o1nh97dfYVjTinJp/eGERQT3
         AeHklBm1qMuDeolb0Zl9TvMQJGz/oaN8cDgasrJkSwckMauaFSKVhlmOKZT9Bu5TztNy
         ajr+faDyL3I86ZHXvDXg5tzrzqRyLLYN6wYWrjWUQZDT7aNZzkcwNw8rbzD9nU7/2gq5
         5o0Q==
X-Gm-Message-State: AOAM533N1T3mNPXICZpleUkWarwxIW8N0cbPlhZQF10sxw4KfAFxZnw4
        8fob9qBuBTeBicFWkalYKeGuL7JoBNA11Q==
X-Google-Smtp-Source: ABdhPJwicWeI9QErjUpNvRbJC1b/W8uLJM8IYh+GolLhg2XPTvsSzDrr7m5+y3SOqTq9CPxPmi/wBg==
X-Received: by 2002:a5d:69ca:: with SMTP id s10mr24334573wrw.78.1618381410999;
        Tue, 13 Apr 2021 23:23:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:c95a:c5e7:2490:ebe3? (p200300ea8f384600c95ac5e72490ebe3.dip0.t-ipconnect.de. [2003:ea:8f38:4600:c95a:c5e7:2490:ebe3])
        by smtp.googlemail.com with ESMTPSA id e33sm4061003wmp.43.2021.04.13.23.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 23:23:30 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: add support for pause ethtool ops
Message-ID: <0e0f42d5-d67e-52bb-20d2-d35c0866338a@gmail.com>
Date:   Wed, 14 Apr 2021 08:23:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the [g|s]et_pauseparam ethtool ops. It considers
that the chip doesn't support pause frame use in jumbo mode.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 28 +++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index eb6da93ac..1b48084f2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1910,6 +1910,32 @@ static void rtl8169_get_ringparam(struct net_device *dev,
 	data->tx_pending = NUM_TX_DESC;
 }
 
+static void rtl8169_get_pauseparam(struct net_device *dev,
+				   struct ethtool_pauseparam *data)
+{
+	struct rtl8169_private *tp = netdev_priv(dev);
+	bool tx_pause, rx_pause;
+
+	phy_get_pause(tp->phydev, &tx_pause, &rx_pause);
+
+	data->autoneg = tp->phydev->autoneg;
+	data->tx_pause = tx_pause ? 1 : 0;
+	data->rx_pause = rx_pause ? 1 : 0;
+}
+
+static int rtl8169_set_pauseparam(struct net_device *dev,
+				  struct ethtool_pauseparam *data)
+{
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	if (dev->mtu > ETH_DATA_LEN)
+		return -EOPNOTSUPP;
+
+	phy_set_asym_pause(tp->phydev, data->rx_pause, data->tx_pause);
+
+	return 0;
+}
+
 static const struct ethtool_ops rtl8169_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -1931,6 +1957,8 @@ static const struct ethtool_ops rtl8169_ethtool_ops = {
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 	.get_ringparam		= rtl8169_get_ringparam,
+	.get_pauseparam		= rtl8169_get_pauseparam,
+	.set_pauseparam		= rtl8169_set_pauseparam,
 };
 
 static void rtl_enable_eee(struct rtl8169_private *tp)
-- 
2.31.1

