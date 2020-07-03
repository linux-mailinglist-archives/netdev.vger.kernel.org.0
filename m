Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26ABF2134D7
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 09:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgGCHUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 03:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgGCHUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 03:20:13 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B579FC08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 00:20:12 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so31509888wrw.12
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 00:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xpickymCvrcS1VNWl0Vurjl2Zpm2/MrjqJFv7jyj8/o=;
        b=HLreoTSkJGhOTYA0vXYqth9L35ulf1ptxEQNrfJCGzkrqOCI72COPZtS41YJBJuDLB
         RRUYbwtxk6ziqWRA72Jsri86jx5lUYXLtGu7krQemaTq8jqolVXHVkJklVwhdmTOCuFs
         bk0OaZdY7tQZngCsuEhUBKiUYka082dmLHgy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xpickymCvrcS1VNWl0Vurjl2Zpm2/MrjqJFv7jyj8/o=;
        b=b0nHqg5k1hkcQjcQsC04jCUsqlRQPEZyzhBRbXrRJVYstcmVvPsatt1fu6sJzgAoSj
         Bmk0MdPNyM7brs3obPLiYRI9Atl4KrEKjseVBtWk9mTW/O4UTr/p8cmTHoF+QbcO4EfF
         Gdiwn5fDu/Ia7uXwxcTTZe8VkRzQ7XTPDQbfIQZyfPJfH2SWrnizCocDTe6JUx16RY+i
         kuSlpAoXmFy3Fz5eB8i1BIC5XimyMvxS75DP3Z/7HfqgYZKt8A08+PKAXLO4rVLWTFI0
         Rs0aVppXRCunlpdUeHaePIq6QvN4UQH3W+FCKQSL3lO1i88lpY+OTOD4fxp6Lbe7YZkD
         OuSA==
X-Gm-Message-State: AOAM533sQj8jPDpiC3YJOw72abnwvQIRLY29+wtWRVFgJo6LLDgSs7SO
        ThA83wMixcLnisiKAce7DIPvBw==
X-Google-Smtp-Source: ABdhPJxsy+NfpLBcI3ghj9jeGFQr1aLbObCGdPUXwYgSpeopsm83PrFE/nPafDGtVT9Pq35eVgvbzw==
X-Received: by 2002:adf:8091:: with SMTP id 17mr23318903wrl.13.1593760811373;
        Fri, 03 Jul 2020 00:20:11 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a22sm12529564wmj.9.2020.07.03.00.20.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 00:20:10 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 6/8] bnxt_en: Implement ethtool -X to set indirection table.
Date:   Fri,  3 Jul 2020 03:19:45 -0400
Message-Id: <1593760787-31695-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the new infrastructure in place, we can now support the setting of
the indirection table from ethtool.

When changing channels, in a rare case that firmware cannot reserve the
rings that were promised, the RSS map will revert to default.

v2: When changing channels, if the RSS table size changes and RSS map
    is non-default, return error.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  7 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 37 +++++++++++++++++++++++
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6c90a94..0edb692 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6061,6 +6061,10 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 		rx = rx_rings << 1;
 	cp = sh ? max_t(int, tx, rx_rings) : tx + rx_rings;
 	bp->tx_nr_rings = tx;
+
+	/* Reset the RSS indirection if we cannot reserve all the RX rings */
+	if (rx_rings != bp->rx_nr_rings)
+		bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;
 	bp->rx_nr_rings = rx_rings;
 	bp->cp_nr_rings = cp;
 
@@ -8265,7 +8269,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
 			rc = bnxt_init_int_mode(bp);
 		bnxt_ulp_irq_restart(bp, rc);
 	}
-	bnxt_set_dflt_rss_indir_tbl(bp);
+	if (!netif_is_rxfh_configured(bp->dev))
+		bnxt_set_dflt_rss_indir_tbl(bp);
 
 	if (rc) {
 		netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 46f3978..9098818 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -926,6 +926,13 @@ static int bnxt_set_channels(struct net_device *dev,
 		return rc;
 	}
 
+	if (bnxt_get_nr_rss_ctxs(bp, req_rx_rings) !=
+	    bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings) &&
+	    (dev->priv_flags & IFF_RXFH_CONFIGURED)) {
+		netdev_warn(dev, "RSS table size change required, RSS table entries must be default to proceed\n");
+		return -EINVAL;
+	}
+
 	if (netif_running(dev)) {
 		if (BNXT_PF(bp)) {
 			/* TODO CHIMP_FW: Send message to all VF's
@@ -1315,6 +1322,35 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 	return 0;
 }
 
+static int bnxt_set_rxfh(struct net_device *dev, const u32 *indir,
+			 const u8 *key, const u8 hfunc)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	int rc = 0;
+
+	if (hfunc && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
+	if (key)
+		return -EOPNOTSUPP;
+
+	if (indir) {
+		u32 i, pad, tbl_size = bnxt_get_rxfh_indir_size(dev);
+
+		for (i = 0; i < tbl_size; i++)
+			bp->rss_indir_tbl[i] = indir[i];
+		pad = bp->rss_indir_tbl_entries - tbl_size;
+		if (pad)
+			memset(&bp->rss_indir_tbl[i], 0, pad * sizeof(u16));
+	}
+
+	if (netif_running(bp->dev)) {
+		bnxt_close_nic(bp, false, false);
+		rc = bnxt_open_nic(bp, false, false);
+	}
+	return rc;
+}
+
 static void bnxt_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
@@ -3621,6 +3657,7 @@ void bnxt_ethtool_free(struct bnxt *bp)
 	.get_rxfh_indir_size    = bnxt_get_rxfh_indir_size,
 	.get_rxfh_key_size      = bnxt_get_rxfh_key_size,
 	.get_rxfh               = bnxt_get_rxfh,
+	.set_rxfh		= bnxt_set_rxfh,
 	.flash_device		= bnxt_flash_device,
 	.get_eeprom_len         = bnxt_get_eeprom_len,
 	.get_eeprom             = bnxt_get_eeprom,
-- 
1.8.3.1

