Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADDB324EC
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfFBVPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:15:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36225 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfFBVPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:15:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so6926680wrs.3
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=E74MMGf2KBXbo4P0ocVGsRMk5ZgBipC1AALJcdJysiQ=;
        b=WLNdAuva3yg5aOZaxQpW3f0c4XszUtlO66QeI9NLmj7/1LOm5/oGJQXjhwMxoyRAtC
         G7jKr58bnZRvC6cuZhintpIcffo+dxFiCYgTQp4006mwAkK3kWrjXk/rSWLxuYmXRO74
         b9PlryYWZ8rzJXuuH3QH+ix9PZnrMSMxqg+PBz/zxuvKFGNsbrqpuSuwiL6oAboyPhSo
         2RKOy6e0kOyv6Smm27m6gs022kdD1vVDfmMR7ZHzw9ShNe8TIglF/cP69XRokV4aSsOl
         ZwXEr7yn0PtVzXZaSu7jsuqMGR60e9AqFC+8KYIr4RyfIWIGCzyGcIX7RDV6h0YGVEBl
         MzvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=E74MMGf2KBXbo4P0ocVGsRMk5ZgBipC1AALJcdJysiQ=;
        b=LpxXh6XeQQvo+xJ8BmqhPkPeEI/VoCKQ81zunQmFbFAZGa9QnEN656pnJy/8cc/caH
         ypbFyg4BJAh9P+DGKKtZll7cXSGi6fO3C6GHOePwz2LD7/bwkAdhHKOBJibMKCwL7/u+
         0ozL7izVNUCZtCvcf3BHk2sYH9dd0rmIBJRr2OhDwQPEcf/rAK/47yX8ZShFYBic6unX
         zGbQhRkVxHEyxTYYx5sac7SzTYwbuTrCk4ixQgtiXV/grBh4LNlc7qzMx/Jze5sfVfPb
         lMNl6/PbcZNGJdkFNfT0mTNi22HGK2qwNXLIgeueH6iewOj2LUODCT3liQ2nq1Qh69YO
         ApVg==
X-Gm-Message-State: APjAAAVIvpb3Jptb7Ah9wpyeRNURsGfJMozzi0/7LGi9jweVig9SDWsO
        RTQE8a7Ux4GqAhip8QVKVFQ=
X-Google-Smtp-Source: APXvYqwRf05/zg9PiZ0PXUprLA5TgEdh3HGC83xC/BWcFhpLyAHXkKgiaAYJhmif8slhmCCBfLFy6w==
X-Received: by 2002:a5d:4089:: with SMTP id o9mr8277896wrp.6.1559510148034;
        Sun, 02 Jun 2019 14:15:48 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id s11sm9520534wro.17.2019.06.02.14.15.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:15:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 09/11] net: dsa: sja1105: Add FDB operations for P/Q/R/S series
Date:   Mon,  3 Jun 2019 00:15:45 +0300
Message-Id: <20190602211545.18967-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for manipulating the L2 forwarding database (dump,
add, delete) for the second generation of NXP SJA1105 switches.

At the moment only FDB entries installed statically through 'bridge fdb'
are visible in the dump callback - the dynamically learned ones are
still under investigation.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  5 ++
 drivers/net/dsa/sja1105/sja1105_main.c | 89 +++++++++++++++++++++++++-
 2 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index f55e95d1b731..61d00682de60 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -147,6 +147,11 @@ int sja1105_dynamic_config_write(struct sja1105_private *priv,
 				 enum sja1105_blk_idx blk_idx,
 				 int index, void *entry, bool keep);
 
+enum sja1105_iotag {
+	SJA1105_C_TAG = 0, /* Inner VLAN header */
+	SJA1105_S_TAG = 1, /* Outer VLAN header */
+};
+
 u8 sja1105et_fdb_hash(struct sja1105_private *priv, const u8 *addr, u16 vid);
 int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 		      const unsigned char *addr, u16 vid);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f9bbc780f835..46e2cc7b9ddc 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -210,6 +210,8 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 		.maxage = SJA1105_AGEING_TIME_MS(300000),
 		/* All entries within a FDB bin are available for learning */
 		.dyn_tbsz = SJA1105ET_FDB_BIN_SIZE,
+		/* And the P/Q/R/S equivalent setting: */
+		.start_dynspc = 0,
 		/* 2^8 + 2^5 + 2^3 + 2^2 + 2^1 + 1 in Koopman notation */
 		.poly = 0x97,
 		/* This selects between Independent VLAN Learning (IVL) and
@@ -225,6 +227,13 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 		 * Maybe correlate with no_linklocal_learn from bridge driver?
 		 */
 		.no_mgmt_learn = true,
+		/* P/Q/R/S only */
+		.use_static = true,
+		/* Dynamically learned FDB entries can overwrite other (older)
+		 * dynamic FDB entries
+		 */
+		.owr_dyn = true,
+		.drpnolearn = true,
 	};
 
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
@@ -908,13 +917,89 @@ int sja1105et_fdb_del(struct dsa_switch *ds, int port,
 int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 			const unsigned char *addr, u16 vid)
 {
-	return -EOPNOTSUPP;
+	struct sja1105_l2_lookup_entry l2_lookup = {0};
+	struct sja1105_private *priv = ds->priv;
+	int rc, i;
+
+	/* Search for an existing entry in the FDB table */
+	l2_lookup.macaddr = ether_addr_to_u64(addr);
+	l2_lookup.vlanid = vid;
+	l2_lookup.iotag = SJA1105_S_TAG;
+	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
+	l2_lookup.mask_vlanid = VLAN_VID_MASK;
+	l2_lookup.mask_iotag = BIT(0);
+	l2_lookup.destports = BIT(port);
+
+	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
+					 SJA1105_SEARCH, &l2_lookup);
+	if (rc == 0) {
+		/* Found and this port is already in the entry's
+		 * port mask => job done
+		 */
+		if (l2_lookup.destports & BIT(port))
+			return 0;
+		/* l2_lookup.index is populated by the switch in case it
+		 * found something.
+		 */
+		l2_lookup.destports |= BIT(port);
+		goto skip_finding_an_index;
+	}
+
+	/* Not found, so try to find an unused spot in the FDB.
+	 * This is slightly inefficient because the strategy is knock-knock at
+	 * every possible position from 0 to 1023.
+	 */
+	for (i = 0; i < SJA1105_MAX_L2_LOOKUP_COUNT; i++) {
+		rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
+						 i, NULL);
+		if (rc < 0)
+			break;
+	}
+	if (i == SJA1105_MAX_L2_LOOKUP_COUNT) {
+		dev_err(ds->dev, "FDB is full, cannot add entry.\n");
+		return -EINVAL;
+	}
+	l2_lookup.index = i;
+
+skip_finding_an_index:
+	return sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+					    l2_lookup.index, &l2_lookup,
+					    true);
 }
 
 int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 			const unsigned char *addr, u16 vid)
 {
-	return -EOPNOTSUPP;
+	struct sja1105_l2_lookup_entry l2_lookup = {0};
+	struct sja1105_private *priv = ds->priv;
+	bool keep;
+	int rc;
+
+	l2_lookup.macaddr = ether_addr_to_u64(addr);
+	l2_lookup.vlanid = vid;
+	l2_lookup.iotag = SJA1105_S_TAG;
+	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
+	l2_lookup.mask_vlanid = VLAN_VID_MASK;
+	l2_lookup.mask_iotag = BIT(0);
+	l2_lookup.destports = BIT(port);
+
+	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
+					 SJA1105_SEARCH, &l2_lookup);
+	if (rc < 0)
+		return 0;
+
+	l2_lookup.destports &= ~BIT(port);
+
+	/* Decide whether we remove just this port from the FDB entry,
+	 * or if we remove it completely.
+	 */
+	if (l2_lookup.destports)
+		keep = true;
+	else
+		keep = false;
+
+	return sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+					    l2_lookup.index, &l2_lookup, keep);
 }
 
 static int sja1105_fdb_add(struct dsa_switch *ds, int port,
-- 
2.17.1

