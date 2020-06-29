Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D679D20DFF9
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388962AbgF2Uli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731669AbgF2TOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:06 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B53C08EB2C
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:35:02 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 67so3396233pfg.5
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lg5+Qly5xCsGHQ4zYMdpsrbtEPEiVigWHxunw7gO2fY=;
        b=gkfLGDi0FG4ME+E/CtG+iDjUbyXtmGJyMoDvouHycRwpYZ4pePkNSNGJnBVMhd4Ewu
         iOm6+CsJidYCnV1ftdBZ8dka9H6ntjOiqyM+w/3xQOMP0Rib4FEYk5McaNolNecdlbjV
         As4LFnb/plkf8QgbMXyCbovc60WDCbJVquJ48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lg5+Qly5xCsGHQ4zYMdpsrbtEPEiVigWHxunw7gO2fY=;
        b=nopMZIIm7KvuNGbnG+Mi8uHFZfZLWl1ZhzEQOVHTrxXzkiTuuUskIr9PulAn7bl6Qg
         ZfX3kJnPeGpKsZXSdQ2A1jZA1H4xzNtQaPn8oQAMhps8w4DhX7H0DSvXzHT7nnRrK/U9
         JOR0jrQl2lAG4PQwh67GgP4h3Em3O2OuauppPH/K/M7Z5KIUEY4L8PU33tJ65TdAiD5H
         nS4lJFFjnHcfPfjhoTE8AQv8y+2MKpP8jDTkxuCx6xyGlLWb6aEUnYA68k0rqYPe4L57
         Y6bj8g7jW+NVqPnhZ+10JykIlW1IeoLfUp4DpMLXf9OiOuVp5UR2mm/2S4ILROULa9L6
         b+Ig==
X-Gm-Message-State: AOAM533etWNYOhMz7MxZqnLyRr3QlOVi6pA5hYbwnhXTnzi34xcKJWW3
        MFxVOqg+Pb5AilVyathecgduTwfTAEA=
X-Google-Smtp-Source: ABdhPJxxH0AgBYRWnOPwb5CSqhS3g5bagcizuqoYW+Zm0blSFL7xM283NamH5BUDicQfzYIya8U8cg==
X-Received: by 2002:a65:644d:: with SMTP id s13mr9173277pgv.103.1593412501808;
        Sun, 28 Jun 2020 23:35:01 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i125sm28058416pgd.21.2020.06.28.23.34.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jun 2020 23:35:01 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 6/8] bnxt_en: Implement ethtool -X to set indirection table.
Date:   Mon, 29 Jun 2020 02:34:22 -0400
Message-Id: <1593412464-503-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the new infrastructure in place, we can now support the setting of
the indirection table from ethtool.

The user-configured indirection table will need to be reset to default
if we are unable to reserve the requested number of RX rings or if the
RSS table size changes.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  7 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 34 +++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 87d37dc..eb7f2d4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6063,6 +6063,10 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 		rx = rx_rings << 1;
 	cp = sh ? max_t(int, tx, rx_rings) : tx + rx_rings;
 	bp->tx_nr_rings = tx;
+
+	/* Reset the RSS indirection if we cannot reserve all the RX rings */
+	if (rx_rings != bp->rx_nr_rings)
+		bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;
 	bp->rx_nr_rings = rx_rings;
 	bp->cp_nr_rings = cp;
 
@@ -8267,7 +8271,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
 			rc = bnxt_init_int_mode(bp);
 		bnxt_ulp_irq_restart(bp, rc);
 	}
-	bnxt_set_dflt_rss_indir_tbl(bp);
+	if (!netif_is_rxfh_configured(bp->dev))
+		bnxt_set_dflt_rss_indir_tbl(bp);
 
 	if (rc) {
 		netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 46f3978..ae10ebd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -926,6 +926,10 @@ static int bnxt_set_channels(struct net_device *dev,
 		return rc;
 	}
 
+	if (bnxt_get_nr_rss_ctxs(bp, req_rx_rings) !=
+	    bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings))
+		bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;
+
 	if (netif_running(dev)) {
 		if (BNXT_PF(bp)) {
 			/* TODO CHIMP_FW: Send message to all VF's
@@ -1315,6 +1319,35 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
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
@@ -3621,6 +3654,7 @@ void bnxt_ethtool_free(struct bnxt *bp)
 	.get_rxfh_indir_size    = bnxt_get_rxfh_indir_size,
 	.get_rxfh_key_size      = bnxt_get_rxfh_key_size,
 	.get_rxfh               = bnxt_get_rxfh,
+	.set_rxfh		= bnxt_set_rxfh,
 	.flash_device		= bnxt_flash_device,
 	.get_eeprom_len         = bnxt_get_eeprom_len,
 	.get_eeprom             = bnxt_get_eeprom,
-- 
1.8.3.1

