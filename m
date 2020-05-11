Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE281CDC1B
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbgEKNyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730376AbgEKNyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:54:02 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4582CC061A0E;
        Mon, 11 May 2020 06:54:02 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id v12so11038396wrp.12;
        Mon, 11 May 2020 06:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=37VuIdSF6ws8neo/QewGjTnFSwoGBP3okPKmSGqlN+o=;
        b=LTByzCkSiUY04lRDye1+wYH/Tm7TQCWtawIU0K5+X+kOip0wNS2ssqH6H5kzt5GVHH
         uDOVhvsZwt5LPPxLTTI5PrMBfkdM9uRE249YoiNm2nORPX+KNV1W0onHSIz23wdShm5i
         1Ba0eI8gZ9YOKpXwcJYwuij8qHvzsWC0bzMXV5p2LKvqGE4D+x2SKsJc4o56fTp7F8hu
         q78XdLkJfUge/YlNU3HcndnbM7aXxMs9MCuPSJsYJcxvLg7gnnh2IgngBG3Md6WAaLG3
         Bvbo82XVpqWnvDFQkc6oni3WMe16v6Acpp8fnhuysIBWStiz50G0LhRZIkNCwLvtKfrs
         mHgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=37VuIdSF6ws8neo/QewGjTnFSwoGBP3okPKmSGqlN+o=;
        b=IpfOHMFIbf3MYkfu2Hrx7b0TMhLPLBB8gbqRdEQdpDkas1hu/iG8kNk9pAn21dXyim
         6tNaX5Jfsa2BFwc2XM2YV0n6X1LslNK3y8IKZjTcwBpEJxU8EZL52DKtX8creg0u26Bz
         uDmdOkPU31fWp6Sns6BgKAUcv8dJfseKD2/gpREoE/gz/RqNYx1dN/HEO5IGJ9K714Kl
         ABkUTclKg3EoJv5koI15p5ohLAtANYHXuz8+gYVk3yS7xC5zCQj/uHp1u7Y/VIA279en
         TrhwUGOAssLNo9+tdpJ8itveNstxx86Dr2cAzWMtnE3RxWI3jzLbe6R3A71DETqCdBnL
         ucNw==
X-Gm-Message-State: AGi0PubNnsyTBtyBYQSadj0c90v6XwfwXMxeJDObqpxgRbXpnK2LTODl
        e+RRjyTk0GK4OhigUjYLxQM=
X-Google-Smtp-Source: APiQypKSJzhoG00vqM0L0vcbmh038WkU8gnPFdxvvLXsTXPDdIg1FkCrZURcRF5mWNIaxvmd/Ae6Pg==
X-Received: by 2002:adf:ed82:: with SMTP id c2mr20147149wro.255.1589205241025;
        Mon, 11 May 2020 06:54:01 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 2sm17596413wre.25.2020.05.11.06.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 06:54:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 13/15] net: dsa: sja1105: implement a common frame memory partitioning function
Date:   Mon, 11 May 2020 16:53:36 +0300
Message-Id: <20200511135338.20263-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511135338.20263-1-olteanv@gmail.com>
References: <20200511135338.20263-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are 2 different features that require some reserved frame memory
space: VLAN retagging and virtual links. Create a central function that
modifies the static config and ensures frame memory is never
overcommitted.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105.h             |  2 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 37 +++++++++++++++++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  1 +
 drivers/net/dsa/sja1105/sja1105_vl.c          | 20 +---------
 4 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 1ecdfd6be4c2..198d2a7d7f95 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -244,6 +244,8 @@ enum sja1105_reset_reason {
 int sja1105_static_config_reload(struct sja1105_private *priv,
 				 enum sja1105_reset_reason reason);
 
+void sja1105_frame_memory_partitioning(struct sja1105_private *priv);
+
 /* From sja1105_spi.c */
 int sja1105_xfer_buf(const struct sja1105_private *priv,
 		     sja1105_spi_rw_mode_t rw, u64 reg_addr,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 99139fcdc715..99b453d0d205 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -432,6 +432,41 @@ static int sja1105_init_l2_forwarding_params(struct sja1105_private *priv)
 	return 0;
 }
 
+void sja1105_frame_memory_partitioning(struct sja1105_private *priv)
+{
+	struct sja1105_l2_forwarding_params_entry *l2_fwd_params;
+	struct sja1105_vl_forwarding_params_entry *vl_fwd_params;
+	struct sja1105_table *table;
+	int max_mem;
+
+	/* VLAN retagging is implemented using a loopback port that consumes
+	 * frame buffers. That leaves less for us.
+	 */
+	if (priv->vlan_state == SJA1105_VLAN_BEST_EFFORT)
+		max_mem = SJA1105_MAX_FRAME_MEMORY_RETAGGING;
+	else
+		max_mem = SJA1105_MAX_FRAME_MEMORY;
+
+	table = &priv->static_config.tables[BLK_IDX_L2_FORWARDING_PARAMS];
+	l2_fwd_params = table->entries;
+	l2_fwd_params->part_spc[0] = max_mem;
+
+	/* If we have any critical-traffic virtual links, we need to reserve
+	 * some frame buffer memory for them. At the moment, hardcode the value
+	 * at 100 blocks of 128 bytes of memory each. This leaves 829 blocks
+	 * remaining for best-effort traffic. TODO: figure out a more flexible
+	 * way to perform the frame buffer partitioning.
+	 */
+	if (!priv->static_config.tables[BLK_IDX_VL_FORWARDING].entry_count)
+		return;
+
+	table = &priv->static_config.tables[BLK_IDX_VL_FORWARDING_PARAMS];
+	vl_fwd_params = table->entries;
+
+	l2_fwd_params->part_spc[0] -= SJA1105_VL_FRAME_MEMORY;
+	vl_fwd_params->partspc[0] = SJA1105_VL_FRAME_MEMORY;
+}
+
 static int sja1105_init_general_params(struct sja1105_private *priv)
 {
 	struct sja1105_general_params_entry default_general_params = {
@@ -2213,6 +2248,8 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	l2_lookup_params = table->entries;
 	l2_lookup_params->shared_learn = want_tagging;
 
+	sja1105_frame_memory_partitioning(priv);
+
 	rc = sja1105_static_config_reload(priv, SJA1105_VLAN_FILTERING);
 	if (rc)
 		dev_err(ds->dev, "Failed to change VLAN Ethertype\n");
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index d96044d86b11..5946847bb5b9 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -108,6 +108,7 @@ enum sja1105_blk_idx {
 
 #define SJA1105_MAX_FRAME_MEMORY			929
 #define SJA1105_MAX_FRAME_MEMORY_RETAGGING		910
+#define SJA1105_VL_FRAME_MEMORY				100
 
 #define SJA1105E_DEVICE_ID				0x9C00000Cull
 #define SJA1105T_DEVICE_ID				0x9E00030Eull
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index 312401995b54..f37611885376 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -5,7 +5,6 @@
 #include <linux/dsa/8021q.h>
 #include "sja1105.h"
 
-#define SJA1105_VL_FRAME_MEMORY			100
 #define SJA1105_SIZE_VL_STATUS			8
 
 /* The switch flow classification core implements TTEthernet, which 'thinks' in
@@ -141,8 +140,6 @@ static bool sja1105_vl_key_lower(struct sja1105_vl_lookup_entry *a,
 static int sja1105_init_virtual_links(struct sja1105_private *priv,
 				      struct netlink_ext_ack *extack)
 {
-	struct sja1105_l2_forwarding_params_entry *l2_fwd_params;
-	struct sja1105_vl_forwarding_params_entry *vl_fwd_params;
 	struct sja1105_vl_policing_entry *vl_policing;
 	struct sja1105_vl_forwarding_entry *vl_fwd;
 	struct sja1105_vl_lookup_entry *vl_lookup;
@@ -153,10 +150,6 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 	int max_sharindx = 0;
 	int i, j, k;
 
-	table = &priv->static_config.tables[BLK_IDX_L2_FORWARDING_PARAMS];
-	l2_fwd_params = table->entries;
-	l2_fwd_params->part_spc[0] = SJA1105_MAX_FRAME_MEMORY;
-
 	/* Figure out the dimensioning of the problem */
 	list_for_each_entry(rule, &priv->flow_block.rules, list) {
 		if (rule->type != SJA1105_RULE_VL)
@@ -308,17 +301,6 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 	if (!table->entries)
 		return -ENOMEM;
 	table->entry_count = 1;
-	vl_fwd_params = table->entries;
-
-	/* Reserve some frame buffer memory for the critical-traffic virtual
-	 * links (this needs to be done). At the moment, hardcode the value
-	 * at 100 blocks of 128 bytes of memory each. This leaves 829 blocks
-	 * remaining for best-effort traffic. TODO: figure out a more flexible
-	 * way to perform the frame buffer partitioning.
-	 */
-	l2_fwd_params->part_spc[0] = SJA1105_MAX_FRAME_MEMORY -
-				     SJA1105_VL_FRAME_MEMORY;
-	vl_fwd_params->partspc[0] = SJA1105_VL_FRAME_MEMORY;
 
 	for (i = 0; i < num_virtual_links; i++) {
 		unsigned long cookie = vl_lookup[i].flow_cookie;
@@ -342,6 +324,8 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 		}
 	}
 
+	sja1105_frame_memory_partitioning(priv);
+
 	return 0;
 }
 
-- 
2.17.1

