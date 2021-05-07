Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD305376BD4
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 23:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhEGVdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 17:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhEGVdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 17:33:01 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34485C061574;
        Fri,  7 May 2021 14:32:01 -0700 (PDT)
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 7B67582E48;
        Fri,  7 May 2021 23:31:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1620423120;
        bh=815hQIYqpDnGWLrzjq8hdR44M8uRpKiO3IG15/CTeeY=;
        h=From:To:Cc:Subject:Date:From;
        b=cxsM8fRxnDXQkMEVexZJoJKbIWb9ksZ4yDTv9CpeWS0LPzAePgBtIMMUyGW5JQnk3
         CjqWuS26jg17hfj/O8sFPbq+0TNbe89oIltX3MLtoPnwa3q0n3EDBYCOnhXUM+zEu6
         B9CAkd3rHefTxij4nak1uva10HJvq6FLsEutBTtZuBdOwgz9/5Un0UYHrbzxhqkEM1
         eKoTgLZ4McFFGcaQY297GfUsa1KXNfLaxdd888E0zXmZs0K0CO7fZPT2zkuD3J/2nb
         imiqvJH2bxRjQqR7VQ8rb+Z1vAgCkDwQasqVB3a9lI+UAzk8XieuOBO+OK1X3Dzee5
         hNRwTAJtWek6Q==
From:   Marek Vasut <marex@denx.de>
To:     linux-wireless@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH] rsi: Add support for changing beacon interval
Date:   Fri,  7 May 2021 23:31:49 +0200
Message-Id: <20210507213149.140192-1-marex@denx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.4 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pick code for changing the beacon interval (e.g. using beacon_int in
hostap config) from the downstream RSI driver.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Karun Eagalapati <karun256@gmail.com>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 16025300cddb..d9f1e73293aa 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -837,6 +837,23 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 			common->cqm_info.rssi_hyst);
 	}
 
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		rsi_dbg(INFO_ZONE, "%s: Changed Beacon interval: %d\n",
+			__func__, bss_conf->beacon_int);
+		if (common->beacon_interval != bss->beacon_int) {
+			common->beacon_interval = bss->beacon_int;
+			if (vif->type == NL80211_IFTYPE_AP) {
+				struct vif_priv *vif_info = (struct vif_priv *)vif->drv_priv;
+
+				rsi_set_vap_capabilities(common, RSI_OPMODE_AP,
+							 vif->addr, vif_info->vap_id,
+							 VAP_UPDATE);
+			}
+		}
+		adapter->ps_info.listen_interval =
+			bss->beacon_int * adapter->ps_info.num_bcns_per_lis_int;
+	}
+
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) &&
 	    ((vif->type == NL80211_IFTYPE_AP) ||
 	     (vif->type == NL80211_IFTYPE_P2P_GO))) {
-- 
2.30.2

