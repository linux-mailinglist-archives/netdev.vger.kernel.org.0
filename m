Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63ED8333C25
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhCJME4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbhCJMEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:47 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22894C061761
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:47 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id e19so38231348ejt.3
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DEAVvFDcDkzIv8+6LoQc58Y1go1M6iSGO4707+Npq+4=;
        b=E3/ymp0GVxMBCEHI8N5AZmKyR+6qAukat8UZlcgkOCHuWXTcM9I0dzTGDGgGAcWjJv
         QKNtwuEJiMJ4falBOTGoc81rGdOUlsP0L2yiydPPh1InuHWhzb46PHZ3K6ooYN2GHSG4
         8LkfJAEsV8QtAEdG28Bmj+StiYQmkzKWqJ02cgtx0b/o3HigUgCLBIwsBQUCKKEsmAJS
         oNKwpUNACcTpV9eFE3ez8ahBY25IkJibcGUKRpFfgAy7BaadkELue2bj9NsCH+g6NBTc
         qCOs0mLOzpCLTQMkco5bx210/RqPSGglUDRMhNazrdnGgx61gcLlBWc3XkRKyMwY+Swq
         Z8SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DEAVvFDcDkzIv8+6LoQc58Y1go1M6iSGO4707+Npq+4=;
        b=dRAEGzZT+15NzfYjnCN6E8DxW6uoVsnDdgRA+BZpeIlyEahc/shabOHqgXInnhaLGB
         w/u2xulP3MSVuCPlidRLgWrL17O0OR2NuGsXAqLNQFs8OWouc/vZsvuBS/AQdSYcnK6m
         eoGmbLfJD1oOyODwZVuApfBy94Bju76i8sNAl1ine1acLtQ+EPOYD9JVAJricQbUsCaX
         Bj5Jx2KVYMR9pQm6pLorJEGggr7lCzEZxEXHx5CLF7bQ1ORl50Yn8kKLJUpXh+guPRns
         V1z1guCkTZmeBXfR+BFyBA+jEZukvMyFt5I3Hd4jUveRh2VA7qRzpl/Baktq4mslem6F
         Peww==
X-Gm-Message-State: AOAM5317jXYDJqJBDLyrzRQ4XLB5PoRK8iFVROaUwC4BCNIauuhbK8YV
        cCA8tv57NesHLP49F2LLyZAUG0uQoOA=
X-Google-Smtp-Source: ABdhPJynt9QzUSj9vkFJj3pkT88W7owSe4iIAWvzVH1W2Ly0hi6wSMTUxNeMjwoL6tLZxJeEgGmW1A==
X-Received: by 2002:a17:906:607:: with SMTP id s7mr3190600ejb.495.1615377885937;
        Wed, 10 Mar 2021 04:04:45 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:45 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 05/12] net: enetc: squash clear_cbdr and free_cbdr into teardown_cbdr
Date:   Wed, 10 Mar 2021 14:03:44 +0200
Message-Id: <20210310120351.542292-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All call sites call enetc_clear_cbdr and enetc_free_cbdr one after
another, so let's combine the two functions into a single method named
enetc_teardown_cbdr which does both, and in the same order.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c      |  6 ++----
 drivers/net/ethernet/freescale/enetc/enetc.h      |  3 +--
 drivers/net/ethernet/freescale/enetc/enetc_cbdr.c | 11 ++++-------
 drivers/net/ethernet/freescale/enetc/enetc_pf.c   |  3 +--
 4 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index b1077a6e2b2b..a32283533408 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1078,8 +1078,7 @@ int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
 	return 0;
 
 err_alloc_cls:
-	enetc_clear_cbdr(&si->cbd_ring);
-	enetc_free_cbdr(&si->cbd_ring);
+	enetc_teardown_cbdr(&si->cbd_ring);
 
 	return err;
 }
@@ -1088,8 +1087,7 @@ void enetc_free_si_resources(struct enetc_ndev_priv *priv)
 {
 	struct enetc_si *si = priv->si;
 
-	enetc_clear_cbdr(&si->cbd_ring);
-	enetc_free_cbdr(&si->cbd_ring);
+	enetc_teardown_cbdr(&si->cbd_ring);
 
 	kfree(priv->cls_rules);
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 9d4dbeef61ac..19772be63a2c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -314,8 +314,7 @@ void enetc_set_ethtool_ops(struct net_device *ndev);
 /* control buffer descriptor ring (CBDR) */
 int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw,
 		     struct enetc_cbdr *cbdr);
-void enetc_free_cbdr(struct enetc_cbdr *cbdr);
-void enetc_clear_cbdr(struct enetc_cbdr *cbdr);
+void enetc_teardown_cbdr(struct enetc_cbdr *cbdr);
 int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 			    char *mac_addr, int si_map);
 int enetc_clear_mac_flt_entry(struct enetc_si *si, int index);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
index bb20a58e8830..bee453be2240 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -44,22 +44,19 @@ int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw,
 	return 0;
 }
 
-void enetc_free_cbdr(struct enetc_cbdr *cbdr)
+void enetc_teardown_cbdr(struct enetc_cbdr *cbdr)
 {
 	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
 
+	/* disable ring */
+	enetc_wr_reg(cbdr->mr, 0);
+
 	dma_free_coherent(cbdr->dma_dev, size, cbdr->bd_base,
 			  cbdr->bd_dma_base);
 	cbdr->bd_base = NULL;
 	cbdr->dma_dev = NULL;
 }
 
-void enetc_clear_cbdr(struct enetc_cbdr *cbdr)
-{
-	/* disable ring */
-	enetc_wr_reg(cbdr->mr, 0);
-}
-
 static void enetc_clean_cbdr(struct enetc_cbdr *ring)
 {
 	struct enetc_cbd *dest_cbd;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index f083d49d7772..4dd7199d5007 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1095,8 +1095,7 @@ static void enetc_init_unused_port(struct enetc_si *si)
 	enetc_init_port_rfs_memory(si);
 	enetc_init_port_rss_memory(si);
 
-	enetc_clear_cbdr(&si->cbd_ring);
-	enetc_free_cbdr(&si->cbd_ring);
+	enetc_teardown_cbdr(&si->cbd_ring);
 }
 
 static int enetc_pf_probe(struct pci_dev *pdev,
-- 
2.25.1

