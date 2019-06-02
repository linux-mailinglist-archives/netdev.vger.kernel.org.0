Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A27324E8
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfFBVNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:13:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56237 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfFBVNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:13:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id 16so4777880wmg.5
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IEJlP2IFNv1AEVXTSPVIlSUf+kHI7zpH9o/BzpeSxJM=;
        b=U+y/b4kHzbfcwdTjy2LW7aBsRaGQrkPOtqKpwA822+ueyMPdGRNXg8XCA6LH2t5+7o
         PM3gBBVr8WWt8IeXy3eTKuPV3YjbLcAwzHJKwYTnHAFIskoZgeitQ2TLVTuwcAb3RzeD
         iwLxPKay682V2P6v2XHT887TRbcoyD70hNd5ZQKuaaWKoMBk4nzf0wMXY7yYwFnm3o9k
         h/CACO+3Z0K4blriiS4Cf/DjsgDHDXH1lP0La13AvaTdlQH1TmEE3FAWV65FvG+/CBuF
         fMlftTkKOnP0GbmO+HDiu1JzS2SofEhYC39jYYGnsmANilWW2LSgKKDnN6cOypdf1ogc
         /n5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IEJlP2IFNv1AEVXTSPVIlSUf+kHI7zpH9o/BzpeSxJM=;
        b=RIyx80rbvuA9PzWDfIxiIJW0kn26ZMnA4Va6mYCYWctSpYEChxlHvX00NH6VrzlaAA
         RmxeyRinvNLGFTeJsXIAw/5UcIRacMK9iZbtQ4wKN28g2b1lJjgcm2DJTyLPQt2jSZd9
         /dgbH17X+fzlF6m7iRqeq/CtsrJylnQmckbwZoVRR5rlPxkE7+DuD5ljF1GPI7HU7dB7
         1ZyE7YIEODh9//ZtTUgAJYuzAxA3qDTK4CUJI3zvsv4Z1/3gVBM+tFCjetfZNWETMhYd
         1ngCxXIDZl3z1yPF5UOFLPXPpEZ4O93JqjSoxoTM5eQrugwN71sMeRg462frQ5z9KT0Z
         cc4w==
X-Gm-Message-State: APjAAAV4x1+CHhvZREbUSVaC99+mI70SaCt1IbLW5MMDVbz0nASIM+LE
        mlBkjAa/VFnp1iXh3+C02sI=
X-Google-Smtp-Source: APXvYqyNqjYUNh7V8r+FzA3t7R4Myl+Meia6aW1OulgfGMaViRRH1l9YmlzAryPtTxmXVWDXUB3zjA==
X-Received: by 2002:a1c:65c3:: with SMTP id z186mr52651wmb.116.1559509985930;
        Sun, 02 Jun 2019 14:13:05 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id q11sm9548193wmc.15.2019.06.02.14.12.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:12:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 05/11] net: dsa: sja1105: Make room for P/Q/R/S FDB operations
Date:   Mon,  3 Jun 2019 00:11:57 +0300
Message-Id: <20190602211203.17773-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602211203.17773-1-olteanv@gmail.com>
References: <20190602211203.17773-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA callbacks were written with the E/T (first generation) in mind,
which is quite different.

For P/Q/R/S completely new implementations need to be provided, which
are held as function pointers in the priv->info structure.  We are
taking a slightly roundabout way for this (a function from
sja1105_main.c reads a structure defined in sja1105_spi.c that
points to a function defined in sja1105_main.c), but it is what it is.

The FDB dump callback works for both families, hence no function pointer
for that.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h             | 15 ++++-
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  2 +-
 drivers/net/dsa/sja1105/sja1105_main.c        | 56 ++++++++++++++-----
 drivers/net/dsa/sja1105/sja1105_spi.c         | 12 ++++
 4 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index b043bfc408f2..f55e95d1b731 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -55,6 +55,11 @@ struct sja1105_info {
 	const struct sja1105_regs *regs;
 	int (*reset_cmd)(const void *ctx, const void *data);
 	int (*setup_rgmii_delay)(const void *ctx, int port);
+	/* Prototypes from include/net/dsa.h */
+	int (*fdb_add_cmd)(struct dsa_switch *ds, int port,
+			   const unsigned char *addr, u16 vid);
+	int (*fdb_del_cmd)(struct dsa_switch *ds, int port,
+			   const unsigned char *addr, u16 vid);
 	const char *name;
 };
 
@@ -142,7 +147,15 @@ int sja1105_dynamic_config_write(struct sja1105_private *priv,
 				 enum sja1105_blk_idx blk_idx,
 				 int index, void *entry, bool keep);
 
-u8 sja1105_fdb_hash(struct sja1105_private *priv, const u8 *addr, u16 vid);
+u8 sja1105et_fdb_hash(struct sja1105_private *priv, const u8 *addr, u16 vid);
+int sja1105et_fdb_add(struct dsa_switch *ds, int port,
+		      const unsigned char *addr, u16 vid);
+int sja1105et_fdb_del(struct dsa_switch *ds, int port,
+		      const unsigned char *addr, u16 vid);
+int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
+			const unsigned char *addr, u16 vid);
+int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
+			const unsigned char *addr, u16 vid);
 
 /* Common implementations for the static and dynamic configs */
 size_t sja1105_l2_forwarding_entry_packing(void *buf, void *entry_ptr,
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 7e7efc2e8ee4..3a8b0d0ab330 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -552,7 +552,7 @@ static u8 sja1105_crc8_add(u8 crc, u8 byte, u8 poly)
  * is also received as argument in the Koopman notation that the switch
  * hardware stores it in.
  */
-u8 sja1105_fdb_hash(struct sja1105_private *priv, const u8 *addr, u16 vid)
+u8 sja1105et_fdb_hash(struct sja1105_private *priv, const u8 *addr, u16 vid)
 {
 	struct sja1105_l2_lookup_params_entry *l2_lookup_params =
 		priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS].entries;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index cfdefd9f1905..c78d2def52f1 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -786,10 +786,10 @@ static inline int sja1105et_fdb_index(int bin, int way)
 	return bin * SJA1105ET_FDB_BIN_SIZE + way;
 }
 
-static int sja1105_is_fdb_entry_in_bin(struct sja1105_private *priv, int bin,
-				       const u8 *addr, u16 vid,
-				       struct sja1105_l2_lookup_entry *match,
-				       int *last_unused)
+static int sja1105et_is_fdb_entry_in_bin(struct sja1105_private *priv, int bin,
+					 const u8 *addr, u16 vid,
+					 struct sja1105_l2_lookup_entry *match,
+					 int *last_unused)
 {
 	int way;
 
@@ -818,8 +818,8 @@ static int sja1105_is_fdb_entry_in_bin(struct sja1105_private *priv, int bin,
 	return -1;
 }
 
-static int sja1105_fdb_add(struct dsa_switch *ds, int port,
-			   const unsigned char *addr, u16 vid)
+int sja1105et_fdb_add(struct dsa_switch *ds, int port,
+		      const unsigned char *addr, u16 vid)
 {
 	struct sja1105_l2_lookup_entry l2_lookup = {0};
 	struct sja1105_private *priv = ds->priv;
@@ -827,10 +827,10 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 	int last_unused = -1;
 	int bin, way;
 
-	bin = sja1105_fdb_hash(priv, addr, vid);
+	bin = sja1105et_fdb_hash(priv, addr, vid);
 
-	way = sja1105_is_fdb_entry_in_bin(priv, bin, addr, vid,
-					  &l2_lookup, &last_unused);
+	way = sja1105et_is_fdb_entry_in_bin(priv, bin, addr, vid,
+					    &l2_lookup, &last_unused);
 	if (way >= 0) {
 		/* We have an FDB entry. Is our port in the destination
 		 * mask? If yes, we need to do nothing. If not, we need
@@ -874,17 +874,17 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 					    true);
 }
 
-static int sja1105_fdb_del(struct dsa_switch *ds, int port,
-			   const unsigned char *addr, u16 vid)
+int sja1105et_fdb_del(struct dsa_switch *ds, int port,
+		      const unsigned char *addr, u16 vid)
 {
 	struct sja1105_l2_lookup_entry l2_lookup = {0};
 	struct sja1105_private *priv = ds->priv;
 	int index, bin, way;
 	bool keep;
 
-	bin = sja1105_fdb_hash(priv, addr, vid);
-	way = sja1105_is_fdb_entry_in_bin(priv, bin, addr, vid,
-					  &l2_lookup, NULL);
+	bin = sja1105et_fdb_hash(priv, addr, vid);
+	way = sja1105et_is_fdb_entry_in_bin(priv, bin, addr, vid,
+					    &l2_lookup, NULL);
 	if (way < 0)
 		return 0;
 	index = sja1105et_fdb_index(bin, way);
@@ -905,6 +905,34 @@ static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 					    index, &l2_lookup, keep);
 }
 
+int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
+			const unsigned char *addr, u16 vid)
+{
+	return -EOPNOTSUPP;
+}
+
+int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
+			const unsigned char *addr, u16 vid)
+{
+	return -EOPNOTSUPP;
+}
+
+static int sja1105_fdb_add(struct dsa_switch *ds, int port,
+			   const unsigned char *addr, u16 vid)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	return priv->info->fdb_add_cmd(ds, port, addr, vid);
+}
+
+static int sja1105_fdb_del(struct dsa_switch *ds, int port,
+			   const unsigned char *addr, u16 vid)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	return priv->info->fdb_del_cmd(ds, port, addr, vid);
+}
+
 static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 			    dsa_fdb_dump_cb_t *cb, void *data)
 {
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 2eb70b8acfc3..b1344ed1697f 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -541,6 +541,8 @@ struct sja1105_info sja1105e_info = {
 	.static_ops		= sja1105e_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
 	.reset_cmd		= sja1105et_reset_cmd,
+	.fdb_add_cmd		= sja1105et_fdb_add,
+	.fdb_del_cmd		= sja1105et_fdb_del,
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105E",
 };
@@ -550,6 +552,8 @@ struct sja1105_info sja1105t_info = {
 	.static_ops		= sja1105t_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
 	.reset_cmd		= sja1105et_reset_cmd,
+	.fdb_add_cmd		= sja1105et_fdb_add,
+	.fdb_del_cmd		= sja1105et_fdb_del,
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105T",
 };
@@ -559,6 +563,8 @@ struct sja1105_info sja1105p_info = {
 	.static_ops		= sja1105p_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
+	.fdb_add_cmd		= sja1105pqrs_fdb_add,
+	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105P",
 };
@@ -568,6 +574,8 @@ struct sja1105_info sja1105q_info = {
 	.static_ops		= sja1105q_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
+	.fdb_add_cmd		= sja1105pqrs_fdb_add,
+	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105Q",
 };
@@ -577,6 +585,8 @@ struct sja1105_info sja1105r_info = {
 	.static_ops		= sja1105r_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
+	.fdb_add_cmd		= sja1105pqrs_fdb_add,
+	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105R",
 };
@@ -587,5 +597,7 @@ struct sja1105_info sja1105s_info = {
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.regs			= &sja1105pqrs_regs,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
+	.fdb_add_cmd		= sja1105pqrs_fdb_add,
+	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.name			= "SJA1105S",
 };
-- 
2.17.1

