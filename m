Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A45345148
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhCVVAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhCVU71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:59:27 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF569C061756
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:25 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id w3so23566268ejc.4
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZmzXoJ97o1M9rWc1MhfEHbfmJ0FXS8JjeCxK5uigeS4=;
        b=JFCqzcWc+m20O7pMwh4on0oejbHm5LGIVyI0lFjQDLYRPywD9LZCCW/7fEJ7pLUIWF
         pTPz8nGpMfRtCy5ie4Jz0YFtj/lWqj0sHLTzcTOTv8yz1H0pC2pcFEndXUvpGc520RPL
         2FirJm61Ti/vLNrsnbtyolH/8x25hfCaLrc2aykN2N7Ph5RTnbqG5hoqIqqRDlqlWCSA
         gUsQFFAWPGWhsYPUZwo1Uh5pvpDdKCFWV7dLytby3b2GKDEs5LJ5Uy0knpQYaEgWJDVd
         UmRBoSv7sIgmRL6HT0hmY/DXaWTd/mUGVv/suTGhTM3FHRMHnca6NTJv2fwZN1PwDWAj
         xajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZmzXoJ97o1M9rWc1MhfEHbfmJ0FXS8JjeCxK5uigeS4=;
        b=k5HjfDzXljUxEnyks+bOiU0+9ASTppmYGWd7mhw7V5COQ5H9EoUl7PU6SMUVaMS738
         cikeQOL7kDtgBpOHx+Tgz+6RVGSwTN3cbTLDf5o00yhXZuDgSZ2jGNzwHVmvaeb70lDn
         RnmO6yCSrcV4Cz6YHvd4D7asv1AdGer5t5rPYT922f+u6wZpagzs5sd9o+5dCBJuV2ea
         Mdv/wGzZUnfT2dhovM5/vfgcbFnHWzcXHk/OevH/m3FHvrle+aS383n0KmKrAzU8EzoB
         U/qSRFrQF6p/C7y3ezNJ8ew61akKlYkQWBeumL/AB/Nn5BBX/U/BqG4N4GABoRLbRIi8
         JQ7w==
X-Gm-Message-State: AOAM532k2Fo92aFMnSaZShEpFMu0erq5tUZ+frb40xNsOda2MGGVBYcg
        3Al4/JSQgIj221I0cZbnZco=
X-Google-Smtp-Source: ABdhPJy7jbW/NxPHx5fT/SbXbhBNqrb22BvsJQMu3wwijzwloDnQXpzb9F6Mso6dC/16+NOPbyPMpw==
X-Received: by 2002:a17:906:f283:: with SMTP id gu3mr1600603ejb.91.1616446764596;
        Mon, 22 Mar 2021 13:59:24 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v25sm11621074edr.18.2021.03.22.13.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:59:24 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/6] dpaa2-switch: refactor the egress flooding domain setup
Date:   Mon, 22 Mar 2021 22:58:55 +0200
Message-Id: <20210322205859.606704-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210322205859.606704-1-ciorneiioana@gmail.com>
References: <20210322205859.606704-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Extract the code that determines the list of egress flood interfaces for
a specific flood type into a new function -
dpaa2_switch_fdb_get_flood_cfg().

This will help us to not duplicate code when the broadcast and
unknown ucast/mcast flooding domains will be individually configurable.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 38 ++++++++++++-------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 5254eae5c86a..2db9cd78201d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -110,28 +110,41 @@ static u16 dpaa2_switch_port_set_fdb(struct ethsw_port_priv *port_priv,
 	return 0;
 }
 
-static int dpaa2_switch_fdb_set_egress_flood(struct ethsw_core *ethsw, u16 fdb_id)
+static void dpaa2_switch_fdb_get_flood_cfg(struct ethsw_core *ethsw, u16 fdb_id,
+					   enum dpsw_flood_type type,
+					   struct dpsw_egress_flood_cfg *cfg)
 {
-	struct dpsw_egress_flood_cfg flood_cfg;
 	int i = 0, j;
-	int err;
+
+	memset(cfg, 0, sizeof(*cfg));
 
 	/* Add all the DPAA2 switch ports found in the same bridging domain to
 	 * the egress flooding domain
 	 */
-	for (j = 0; j < ethsw->sw_attr.num_ifs; j++)
-		if (ethsw->ports[j] && ethsw->ports[j]->fdb->fdb_id == fdb_id)
-			flood_cfg.if_id[i++] = ethsw->ports[j]->idx;
+	for (j = 0; j < ethsw->sw_attr.num_ifs; j++) {
+		if (!ethsw->ports[j])
+			continue;
+		if (ethsw->ports[j]->fdb->fdb_id != fdb_id)
+			continue;
+
+		cfg->if_id[i++] = ethsw->ports[j]->idx;
+	}
 
 	/* Add the CTRL interface to the egress flooding domain */
-	flood_cfg.if_id[i++] = ethsw->sw_attr.num_ifs;
+	cfg->if_id[i++] = ethsw->sw_attr.num_ifs;
+
+	cfg->fdb_id = fdb_id;
+	cfg->flood_type = type;
+	cfg->num_ifs = i;
+}
 
-	/* Use the FDB of the first dpaa2 switch port added to the bridge */
-	flood_cfg.fdb_id = fdb_id;
+static int dpaa2_switch_fdb_set_egress_flood(struct ethsw_core *ethsw, u16 fdb_id)
+{
+	struct dpsw_egress_flood_cfg flood_cfg;
+	int err;
 
 	/* Setup broadcast flooding domain */
-	flood_cfg.flood_type = DPSW_BROADCAST;
-	flood_cfg.num_ifs = i;
+	dpaa2_switch_fdb_get_flood_cfg(ethsw, fdb_id, DPSW_BROADCAST, &flood_cfg);
 	err = dpsw_set_egress_flood(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				    &flood_cfg);
 	if (err) {
@@ -140,8 +153,7 @@ static int dpaa2_switch_fdb_set_egress_flood(struct ethsw_core *ethsw, u16 fdb_i
 	}
 
 	/* Setup unknown flooding domain */
-	flood_cfg.flood_type = DPSW_FLOODING;
-	flood_cfg.num_ifs = i;
+	dpaa2_switch_fdb_get_flood_cfg(ethsw, fdb_id, DPSW_FLOODING, &flood_cfg);
 	err = dpsw_set_egress_flood(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				    &flood_cfg);
 	if (err) {
-- 
2.30.0

