Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9EB3801E3
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 04:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhENCZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 22:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhENCZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 22:25:28 -0400
Received: from mxout017.mail.hostpoint.ch (mxout017.mail.hostpoint.ch [IPv6:2a00:d70:0:e::317])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD734C061574;
        Thu, 13 May 2021 19:24:15 -0700 (PDT)
Received: from [10.0.2.45] (helo=asmtp012.mail.hostpoint.ch)
        by mxout017.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCK-0005TS-Li; Fri, 14 May 2021 04:05:04 +0200
Received: from [2a02:168:6182:1:4ea5:a8cc:a141:509c] (helo=ryzen2700.home.reto-schneider.ch)
        by asmtp012.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCK-000L6T-HT; Fri, 14 May 2021 04:05:04 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     Jes.Sorensen@gmail.com, linux-wireless@vger.kernel.org,
        pkshih@realtek.com
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, reto.schneider@husqvarnagroup.com,
        ccchiu77@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Chris Chiu <chiu@endlessos.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 6/7] rtl8xxxu: Fix the reported rx signal strength
Date:   Fri, 14 May 2021 04:04:41 +0200
Message-Id: <20210514020442.946-7-code@reto-schneider.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210514020442.946-1-code@reto-schneider.ch>
References: <a31d9500-73a3-f890-bebd-d0a4014f87da@reto-schneider.ch>
 <20210514020442.946-1-code@reto-schneider.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Chiu <chiu@endlessos.org>

In rtl8xxxx_rx_query_desc for each chip in rtlwifi family, the
rx_status->signal is always the status->recvsignalpower + 10.

We also observe the same thing in air capture that the RSSI is
always ~10dBm higher than reported from driver.

Add this 10dBm to avoid confusion.

(cherry picked from commit e1a4f83da577474dfa23e85483a83eb7fb707edc)
Signed-off-by: Reto Schneider <reto.schneider@husqvarnagroup.com>
---

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 0c997c360028..088e007e8bd0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5319,6 +5319,11 @@ static void rtl8xxxu_rx_parse_phystats(struct rtl8xxxu_priv *priv,
 		rx_status->signal =
 			(phy_stats->cck_sig_qual_ofdm_pwdb_all >> 1) - 110;
 	}
+
+	// refers to rtlxxxx_rx_query_desc of rtlwifi/rtlxxxx/trx.c
+	// needs to verify on RTL8723BU
+	if (priv->rtl_chip != RTL8723B && priv->rtl_chip != RTL8192E)
+		rx_status->signal += 10;
 }
 
 static void rtl8xxxu_free_rx_resources(struct rtl8xxxu_priv *priv)
-- 
2.29.2

