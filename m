Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310DE471E3C
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 23:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhLLWdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 17:33:55 -0500
Received: from mail.wizzup.org ([95.217.97.174]:43916 "EHLO wizzup.org"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229838AbhLLWdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 17:33:54 -0500
X-Greylist: delayed 1568 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2021 17:33:53 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wizzup.org;
        s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Gn4QbhSu65M62ejQy1QWEFPPz4XhpZovxB+9NzFOVPg=; b=WGqbeFK/mVGaOu/ZeUQ1V5TL9P
        RlFS34A21RMnTkWUk6pPDz81A52v3XSpqX2Ge6Pv7c7JHwa3uqa73l9TmHg0CA20mGlm2El1SnIOK
        oHJUegfwF+O8JJE2cSODHOybM3B4vz+LwNgkTvITKlKSaVeLAW93ZfE/Gw0aAiM3Jdp2Rh2Lyz1R4
        BXYzmVudcCYuyWkxrxGhDL9yjQzaRnFTX+fdhJ2Hbl+uccyUF83R612QMtC2G3qlKigmuulufq3zg
        0eJXmGhjVqnYwlJd/kk2+onMsfSRJJharJlLm3/znLyLtpZ8lyN26jt6g6HYycG2HM5kx/dkUPPWt
        lQd+rf9g==;
Received: from [45.83.235.159] (helo=gentoo-x13.fritz.box)
        by wizzup.org with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <merlijn@wizzup.org>)
        id 1mwX0H-0001dD-U8; Sun, 12 Dec 2021 22:07:34 +0000
From:   Merlijn Wajer <merlijn@wizzup.org>
To:     merlijn@wizzup.org
Cc:     Paul Fertser <fercerpav@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wl1251: specify max. IE length
Date:   Sun, 12 Dec 2021 23:13:08 +0100
Message-Id: <20211212221310.5453-1-merlijn@wizzup.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fix is similar to commit 77c91295ea53 ("wil6210: specify max. IE
length").  Without the max IE length set, wpa_supplicant cannot operate
using the nl80211 interface.

This patch is a workaround - the number 512 is taken from the wlcore
driver, but note that per Paul Fertser:

    there's no correct number because the driver will ignore the data
    passed in extra IEs.

Suggested-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: Merlijn Wajer <merlijn@wizzup.org>
---
 drivers/net/wireless/ti/wl1251/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 136a0d3b23c9..a25a6143e65f 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1520,6 +1520,12 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 					 BIT(NL80211_IFTYPE_ADHOC);
 	wl->hw->wiphy->max_scan_ssids = 1;
+
+	/* We set max_scan_ie_len to a random value to make wpa_supplicant scans not
+	 * fail, as the driver will the ignore the extra passed IEs anyway
+	 */
+	wl->hw->wiphy->max_scan_ie_len = 512;
+
 	wl->hw->wiphy->bands[NL80211_BAND_2GHZ] = &wl1251_band_2ghz;
 
 	wl->hw->queues = 4;
-- 
2.32.0

