Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FBB342FD0
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhCTWPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhCTWOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:14:39 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68429C061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:14:35 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o16so12744862wrn.0
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ZlwqF73Tp4vDjk2Gq5Qcw8XYNIuYNh/t2rwTXqugl8A=;
        b=TA7+90Hp+yDP4EdtquYzwIN4MDX3CJVLSbGocPoa1bDrf0oLsyvcAIZYOM+fp1mw73
         sQGcI9QyvFrw6WpASE8s0rGRWQl9vVJSjBzhrvzZlOu34jMg0pSqEz57eWSU+eK0f756
         RyzuUU1dplz7LijHQVwGz1ymmHHHNfjvW1I81GWNNLUN9DL5lBbBcMCTnINV+9XWJ/EW
         0r5pF/AuVFVFJJf/x3v3q6ium6aDT2vtcH9VpF8+4xPkg1YPLyFhu7n0uy2/V03dZDBp
         yCS3C3I0i823ZhaYdWejRtSENUHssS+Pvf6f8ADNqlxqg0zBczQRdtmYGZaG+0M0Lbo+
         kwEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ZlwqF73Tp4vDjk2Gq5Qcw8XYNIuYNh/t2rwTXqugl8A=;
        b=uJrEAQy5KHIOCMF/M+wCB4iRP7AAwgMUUlJID1+FgUeT/983ALq1Pjm8a54C+qheQ7
         yQ41dPViyGScXQNUm7sfhxUxEipB0api0peHCz1LF6atg4cKlN8yeGqeLtZgfQFKFMit
         vpc0l18+Ac9CEo10LinpSkf6Q/QvpvayHo+tCxTt5XgcjPrNJjujRK+r8YTFp9J46QJn
         O7PRSG2vJ85lOEGlELPRN/SUNPNJpszwJyrDRXM3exgyDPA6CBLX2pGEPRAMfskjA4sT
         Drp6Bmr6aNUasOCYwng3g41yOwvBDczWBd7mS2xRjTuJKotp6Y6D9vJheY7dnyY1JCoW
         W5vg==
X-Gm-Message-State: AOAM5321jzZCQU7L51NWpu+R3d5/Br83Feyz+OY3cID35ZTJiDg7Fgqz
        gmqoziAAH+XnfPVizkvRyPYFOKUufLbkHg==
X-Google-Smtp-Source: ABdhPJzh0zziyPftccQUqSdYJj+4undbTdgJBeF6tOLPn9JMzxGYlRpZ7xeZf4HtIUp4FcGqzKrPpg==
X-Received: by 2002:adf:e791:: with SMTP id n17mr10825496wrm.322.1616278473913;
        Sat, 20 Mar 2021 15:14:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:1195:d87b:55ef:276? (p200300ea8f1fbb001195d87b55ef0276.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:1195:d87b:55ef:276])
        by smtp.googlemail.com with ESMTPSA id o2sm11665983wmc.23.2021.03.20.15.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 15:14:33 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: add support for ethtool get_ringparam
Message-ID: <f9734a16-ebca-8cab-a5f8-fa5642a1c8ee@gmail.com>
Date:   Sat, 20 Mar 2021 23:14:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the ethtool get_ringparam operation.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0d7001303..7a8bb7e83 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1901,6 +1901,15 @@ static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 	return ret;
 }
 
+static void rtl8169_get_ringparam(struct net_device *dev,
+				  struct ethtool_ringparam *data)
+{
+	data->rx_max_pending = NUM_RX_DESC;
+	data->rx_pending = NUM_RX_DESC;
+	data->tx_max_pending = NUM_TX_DESC;
+	data->tx_pending = NUM_TX_DESC;
+}
+
 static const struct ethtool_ops rtl8169_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -1921,6 +1930,7 @@ static const struct ethtool_ops rtl8169_ethtool_ops = {
 	.set_eee		= rtl8169_set_eee,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+	.get_ringparam		= rtl8169_get_ringparam,
 };
 
 static void rtl_enable_eee(struct rtl8169_private *tp)
-- 
2.31.0

