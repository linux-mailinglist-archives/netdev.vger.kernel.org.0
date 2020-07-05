Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B51321502A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgGEWWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEWWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:22:53 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBC7C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:22:53 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j20so499624pfe.5
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 15:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nIuslshQBFkT4KmdiGVND2nrnL8+wSE4fLK75St+0rE=;
        b=A958GdRVEbzOLl6hPbDKDkprvotSX6KWix43+btiZCIoUcD5xkIkY1H/6kSXSBwakg
         Bbv0Xaj712EtgQKWJcInSF87ifbq8gVOo4jKNvY+qp06p+PEwIfOU3BW9JcTIyTmVAM1
         KDWV5ejXwwEl/UfQxjWfA+Pv2s65lPf/ic+nk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nIuslshQBFkT4KmdiGVND2nrnL8+wSE4fLK75St+0rE=;
        b=hutO2aJZ3+d5A8QnAu2FZb9FSn3NBv5tYp1wh83GMDU7Tmy3LiJ9PDq60t/eo8j6rX
         kcBVd5gamCz3A6iSyy3pL6vOj0xyQB1n5C8yDbdbzubQvJnMJzTDfizUpY+nGyb9owHG
         SX2Fxp0jrULZuB/PB1L4LFsHa03V2uNq1tKzpFCCb1RAfXcd92h3Wl+m9ES3M+DXmndJ
         etmOAgteRPXlWMc7AcEDb4IIrtU8MG6RqC4WqhpZs2AzAOP4HrSfEsWktr+cPlZ2APuB
         18VL+0JWIh5bAt6bd1U3cipflmW1NcvV/hnL9sbLsVZGoIukU1qve5w2Aeq4k8ABKXrZ
         QWDQ==
X-Gm-Message-State: AOAM530UQ1crZDQdEOn9Lap6neQ78oZ+tpt2uvz9ag8Y0hH1CfcJngU8
        Y3TD3c83Ndjw7HqN1PkIzH5U+g==
X-Google-Smtp-Source: ABdhPJzpGGUFLYpNZ1WJUcEAEkMX+OIxVl+Ny/TPl92Zf6KO333J+g5mx5BdGJa031CqPZDWf5xpzg==
X-Received: by 2002:a63:725c:: with SMTP id c28mr36829451pgn.156.1593987772544;
        Sun, 05 Jul 2020 15:22:52 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i184sm16843251pfc.73.2020.07.05.15.22.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jul 2020 15:22:52 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v3 6/8] bnxt_en: Implement ethtool -X to set indirection table.
Date:   Sun,  5 Jul 2020 18:22:10 -0400
Message-Id: <1593987732-1336-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
References: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the new infrastructure in place, we can now support the setting of
the indirection table from ethtool.

When changing channels, in a rare case that firmware cannot reserve the
rings that were promised, the RSS map will revert to default.

v3: Add warning messages when firmware cannot reserve the requested RX
    rings, and when the RSS table entries have to change to default.

v2: When changing channels, if the RSS table size changes and RSS map
    is non-default, return error.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 13 +++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 37 +++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6c90a94..23f2c96 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6061,6 +6061,16 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 		rx = rx_rings << 1;
 	cp = sh ? max_t(int, tx, rx_rings) : tx + rx_rings;
 	bp->tx_nr_rings = tx;
+
+	/* Reset the RSS indir table if we cannot reserve all the RX rings */
+	if (rx_rings != bp->rx_nr_rings) {
+		netdev_warn(bp->dev, "Able to reserve only %d out of %d requested RX rings\n",
+			    rx_rings, bp->rx_nr_rings);
+		if (bp->dev->priv_flags & IFF_RXFH_CONFIGURED) {
+			netdev_warn(bp->dev, "RSS table entries reverting to default\n");
+			bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;
+		}
+	}
 	bp->rx_nr_rings = rx_rings;
 	bp->cp_nr_rings = cp;
 
@@ -8265,7 +8275,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
 			rc = bnxt_init_int_mode(bp);
 		bnxt_ulp_irq_restart(bp, rc);
 	}
-	bnxt_set_dflt_rss_indir_tbl(bp);
+	if (!netif_is_rxfh_configured(bp->dev))
+		bnxt_set_dflt_rss_indir_tbl(bp);
 
 	if (rc) {
 		netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 8bc4a7f..54b64fb 100644
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
@@ -1313,6 +1320,35 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
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
@@ -3619,6 +3655,7 @@ void bnxt_ethtool_free(struct bnxt *bp)
 	.get_rxfh_indir_size    = bnxt_get_rxfh_indir_size,
 	.get_rxfh_key_size      = bnxt_get_rxfh_key_size,
 	.get_rxfh               = bnxt_get_rxfh,
+	.set_rxfh		= bnxt_set_rxfh,
 	.flash_device		= bnxt_flash_device,
 	.get_eeprom_len         = bnxt_get_eeprom_len,
 	.get_eeprom             = bnxt_get_eeprom,
-- 
1.8.3.1

