Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB481E4F6B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 22:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgE0Ui7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 16:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgE0Ui6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 16:38:58 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E16BC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 13:38:58 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id e10so21420441edq.0
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 13:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9PRR3lPbV4TrVAHv+Fg5HHrSVkycHj5QtZ9k3Lik7g=;
        b=jO/Y7XJmHwkZfI2TreEuKSijMMywFoDm/7ACanzV4Zhj3NSIKi4oWsdEXGktEJ1m4C
         QuekQn5ibyR0VtC0rnNGFmncvKQ1u735H+8nGWyOZPyQxgFLPnKhunl+NZvDV1TC9cKZ
         +s/BW48umBz7esAR8WGxZt74767SZTji3vUIa50dQYERZ45/lEgsY1w2JTqNwONQ/fj/
         aJSNBBlmCaF7yj1Xo4oc98p9VtuXBnlIThCLka6+g+h2O1HiDOLUUVEtv6FhAlH1Pvzq
         Luj60dyiTpB/6C0CXDp9/nQyhoqLoZ/NGngWG2PakI+I/Mg1V/3QPhFT9fUu4kAKy7Qo
         psSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9PRR3lPbV4TrVAHv+Fg5HHrSVkycHj5QtZ9k3Lik7g=;
        b=VAUM57r92CTJHoiZOwlZxMb7YHE3ZYGYEJuPrkGDbIU1rzAUdnefCnnTdWG+MBZ4nY
         iTF+gMoFMsx5hnk/xyBtT8mwp1umPySPYw1FW1Vs/bP2gKG/bzeGGMjKnz7Dk/IScR0x
         IcpJuWfDvic3GCzJa3YARS3a944qDO8Zsr9cyWxT4H6X1E6EIfY3R9Uarv1qj+pis0aj
         g1LsAFb4fkxQ26RJkXN2fevNFDEqPC/FGB1NpGDvRy8hoJAvsIabQaSmKdWPFlfVpghB
         TzJB8bQgrvjFr2Qh2doLkaz6vqW1UK6QOfFeQzKLVCsXb1puBJ8P8gHHijfwUUMg/5vJ
         oO+A==
X-Gm-Message-State: AOAM533aXU8zgis7FkyoNx+WqCVSw6bW1W9UqMI4FvFXXrTGognrpzPw
        rM9J0A93KtzOqpA9n7EKNGSV9Rlq
X-Google-Smtp-Source: ABdhPJz8onKoe+/zW+8PtTFg9Q7UDO8anceWVkDQ3M1TgDokN5EXNoHO4ahoyCmQvs4GGdcbUtr6Dg==
X-Received: by 2002:aa7:c6c6:: with SMTP id b6mr25315863eds.53.1590611936958;
        Wed, 27 May 2020 13:38:56 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id c4sm3586783ejz.104.2020.05.27.13.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 13:38:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org, vinicius.gomes@intel.com
Subject: [PATCH v2 net-next] net: dsa: sja1105: offload the Credit-Based Shaper qdisc
Date:   Wed, 27 May 2020 23:38:50 +0300
Message-Id: <20200527203850.1354202-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

SJA1105, being AVB/TSN switches, provide hardware assist for the
Credit-Based Shaper as described in the IEEE 8021Q-2018 document.

First generation has 10 shapers, freely assignable to any of the 4
external ports and 8 traffic classes, and second generation has 16
shapers.

We also need to provide a dummy implementation of mqprio qdisc offload,
since this seems to be necessary for shaping any traffic class other
than zero.

The Credit-Based Shaper tables are accessed through the dynamic
reconfiguration interface, so we have to restore them manually after a
switch reset. The tables are backed up by the static config only on
P/Q/R/S, and we don't want to add custom code only for that family,
since the procedure that is in place now works for both.

Tested with the following commands:

data_rate_kbps=67000
port_transmit_rate_kbps=1000000
idleslope=$data_rate_kbps
sendslope=$(($idleslope - $port_transmit_rate_kbps))
locredit=$((-0x80000000))
hicredit=$((0x7fffffff))
tc qdisc add dev swp2 root handle 1: mqprio hw 0 num_tc 8 \
        map 0 1 2 3 4 5 6 7 \
        queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7
tc qdisc replace dev swp2 parent 1:1 cbs \
        idleslope $idleslope \
        sendslope $sendslope \
        hicredit $hicredit \
        locredit $locredit \
        offload 1

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- Removed bogus dummy mqprio hw offload.
- Made sure first-gen SJA1105E/T works properly (some bugs in
  sja1105et_cbs_entry_packing).

 drivers/net/dsa/sja1105/sja1105.h             |   2 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  76 +++++++++++++
 drivers/net/dsa/sja1105/sja1105_main.c        | 100 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c         |   6 ++
 .../net/dsa/sja1105/sja1105_static_config.h   |  15 +++
 5 files changed, 199 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 198d2a7d7f95..cb3c81a49fbc 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -84,6 +84,7 @@ struct sja1105_info {
 	 * the egress timestamps.
 	 */
 	int ptpegr_ts_bytes;
+	int num_cbs_shapers;
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
@@ -218,6 +219,7 @@ struct sja1105_private {
 	struct mutex mgmt_lock;
 	bool expect_dsa_8021q;
 	enum sja1105_vlan_state vlan_state;
+	struct sja1105_cbs_entry *cbs;
 	struct sja1105_tagger_data tagger_data;
 	struct sja1105_ptp_data ptp_data;
 	struct sja1105_tas_data tas_data;
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 2a8fbd7fdedc..7516f2ffdd4e 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -136,6 +136,12 @@
 #define SJA1105_SIZE_RETAGGING_DYN_CMD				\
 	(SJA1105_SIZE_DYN_CMD + SJA1105_SIZE_RETAGGING_ENTRY)
 
+#define SJA1105ET_SIZE_CBS_DYN_CMD				\
+	(SJA1105_SIZE_DYN_CMD + SJA1105ET_SIZE_CBS_ENTRY)
+
+#define SJA1105PQRS_SIZE_CBS_DYN_CMD				\
+	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_CBS_ENTRY)
+
 #define SJA1105_MAX_DYN_CMD_SIZE				\
 	SJA1105PQRS_SIZE_MAC_CONFIG_DYN_CMD
 
@@ -542,6 +548,60 @@ sja1105_retagging_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	sja1105_packing(p, &cmd->index,     5,  0, size, op);
 }
 
+static void sja1105et_cbs_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				      enum packing_op op)
+{
+	u8 *p = buf + SJA1105ET_SIZE_CBS_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid, 31, 31, size, op);
+	sja1105_packing(p, &cmd->index, 19, 16, size, op);
+}
+
+static size_t sja1105et_cbs_entry_packing(void *buf, void *entry_ptr,
+					  enum packing_op op)
+{
+	const size_t size = SJA1105ET_SIZE_CBS_ENTRY;
+	struct sja1105_cbs_entry *entry = entry_ptr;
+	u8 *cmd = buf + size;
+	u32 *p = buf;
+
+	sja1105_packing(cmd, &entry->port, 5, 3, SJA1105_SIZE_DYN_CMD, op);
+	sja1105_packing(cmd, &entry->prio, 2, 0, SJA1105_SIZE_DYN_CMD, op);
+	sja1105_packing(p + 3, &entry->credit_lo,  31, 0, size, op);
+	sja1105_packing(p + 2, &entry->credit_hi,  31, 0, size, op);
+	sja1105_packing(p + 1, &entry->send_slope, 31, 0, size, op);
+	sja1105_packing(p + 0, &entry->idle_slope, 31, 0, size, op);
+	return size;
+}
+
+static void sja1105pqrs_cbs_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+					enum packing_op op)
+{
+	u8 *p = buf + SJA1105PQRS_SIZE_CBS_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
+	sja1105_packing(p, &cmd->errors,  29, 29, size, op);
+	sja1105_packing(p, &cmd->index,    3,  0, size, op);
+}
+
+static size_t sja1105pqrs_cbs_entry_packing(void *buf, void *entry_ptr,
+					    enum packing_op op)
+{
+	const size_t size = SJA1105PQRS_SIZE_CBS_ENTRY;
+	struct sja1105_cbs_entry *entry = entry_ptr;
+
+	sja1105_packing(buf, &entry->port,      159, 157, size, op);
+	sja1105_packing(buf, &entry->prio,      156, 154, size, op);
+	sja1105_packing(buf, &entry->credit_lo, 153, 122, size, op);
+	sja1105_packing(buf, &entry->credit_hi, 121,  90, size, op);
+	sja1105_packing(buf, &entry->send_slope, 89,  58, size, op);
+	sja1105_packing(buf, &entry->idle_slope, 57,  26, size, op);
+	return size;
+}
+
 #define OP_READ		BIT(0)
 #define OP_WRITE	BIT(1)
 #define OP_DEL		BIT(2)
@@ -631,6 +691,14 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105_SIZE_RETAGGING_DYN_CMD,
 		.addr = 0x31,
 	},
+	[BLK_IDX_CBS] = {
+		.entry_packing = sja1105et_cbs_entry_packing,
+		.cmd_packing = sja1105et_cbs_cmd_packing,
+		.max_entry_count = SJA1105ET_MAX_CBS_COUNT,
+		.access = OP_WRITE,
+		.packed_size = SJA1105ET_SIZE_CBS_DYN_CMD,
+		.addr = 0x2c,
+	},
 	[BLK_IDX_XMII_PARAMS] = {0},
 };
 
@@ -725,6 +793,14 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105_SIZE_RETAGGING_DYN_CMD,
 		.addr = 0x38,
 	},
+	[BLK_IDX_CBS] = {
+		.entry_packing = sja1105pqrs_cbs_entry_packing,
+		.cmd_packing = sja1105pqrs_cbs_cmd_packing,
+		.max_entry_count = SJA1105PQRS_MAX_CBS_COUNT,
+		.access = OP_WRITE,
+		.packed_size = SJA1105PQRS_SIZE_CBS_DYN_CMD,
+		.addr = 0x32,
+	},
 	[BLK_IDX_XMII_PARAMS] = {0},
 };
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index a41b27e593d0..ab3935d5c4d5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1633,6 +1633,92 @@ static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
 	sja1105_bridge_member(ds, port, br, false);
 }
 
+#define BYTES_PER_KBIT (1000LL / 8)
+
+static int sja1105_find_unused_cbs_shaper(struct sja1105_private *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->info->num_cbs_shapers; i++)
+		if (!priv->cbs[i].idle_slope && !priv->cbs[i].send_slope)
+			return i;
+
+	return -1;
+}
+
+static int sja1105_delete_cbs_shaper(struct sja1105_private *priv, int port,
+				     int prio)
+{
+	int i;
+
+	for (i = 0; i < priv->info->num_cbs_shapers; i++) {
+		struct sja1105_cbs_entry *cbs = &priv->cbs[i];
+
+		if (cbs->port == port && cbs->prio == prio) {
+			memset(cbs, 0, sizeof(*cbs));
+			return sja1105_dynamic_config_write(priv, BLK_IDX_CBS,
+							    i, cbs, true);
+		}
+	}
+
+	return 0;
+}
+
+static int sja1105_setup_tc_cbs(struct dsa_switch *ds, int port,
+				struct tc_cbs_qopt_offload *offload)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_cbs_entry *cbs;
+	int index;
+
+	if (!offload->enable)
+		return sja1105_delete_cbs_shaper(priv, port, offload->queue);
+
+	index = sja1105_find_unused_cbs_shaper(priv);
+	if (index < 0)
+		return -ENOSPC;
+
+	cbs = &priv->cbs[index];
+	cbs->port = port;
+	cbs->prio = offload->queue;
+	/* locredit and sendslope are negative by definition. In hardware,
+	 * positive values must be provided, and the negative sign is implicit.
+	 */
+	cbs->credit_hi = offload->hicredit;
+	cbs->credit_lo = abs(offload->locredit);
+	/* User space is in kbits/sec, hardware in bytes/sec */
+	cbs->idle_slope = offload->idleslope * BYTES_PER_KBIT;
+	cbs->send_slope = abs(offload->sendslope * BYTES_PER_KBIT);
+	/* Convert the negative values from 64-bit 2's complement
+	 * to 32-bit 2's complement (for the case of 0x80000000 whose
+	 * negative is still negative).
+	 */
+	cbs->credit_lo &= GENMASK_ULL(31, 0);
+	cbs->send_slope &= GENMASK_ULL(31, 0);
+
+	return sja1105_dynamic_config_write(priv, BLK_IDX_CBS, index, cbs,
+					    true);
+}
+
+static int sja1105_reload_cbs(struct sja1105_private *priv)
+{
+	int rc = 0, i;
+
+	for (i = 0; i < priv->info->num_cbs_shapers; i++) {
+		struct sja1105_cbs_entry *cbs = &priv->cbs[i];
+
+		if (!cbs->idle_slope && !cbs->send_slope)
+			continue;
+
+		rc = sja1105_dynamic_config_write(priv, BLK_IDX_CBS, i, cbs,
+						  true);
+		if (rc)
+			break;
+	}
+
+	return rc;
+}
+
 static const char * const sja1105_reset_reasons[] = {
 	[SJA1105_VLAN_FILTERING] = "VLAN filtering",
 	[SJA1105_RX_HWTSTAMPING] = "RX timestamping",
@@ -1747,6 +1833,10 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 			sja1105_sgmii_pcs_force_speed(priv, speed);
 		}
 	}
+
+	rc = sja1105_reload_cbs(priv);
+	if (rc < 0)
+		goto out;
 out:
 	mutex_unlock(&priv->mgmt_lock);
 
@@ -3130,6 +3220,8 @@ static int sja1105_port_setup_tc(struct dsa_switch *ds, int port,
 	switch (type) {
 	case TC_SETUP_QDISC_TAPRIO:
 		return sja1105_setup_tc_taprio(ds, port, type_data);
+	case TC_SETUP_QDISC_CBS:
+		return sja1105_setup_tc_cbs(ds, port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -3407,6 +3499,14 @@ static int sja1105_probe(struct spi_device *spi)
 	if (rc)
 		return rc;
 
+	if (IS_ENABLED(CONFIG_NET_SCH_CBS)) {
+		priv->cbs = devm_kcalloc(dev, priv->info->num_cbs_shapers,
+					 sizeof(struct sja1105_cbs_entry),
+					 GFP_KERNEL);
+		if (!priv->cbs)
+			return -ENOMEM;
+	}
+
 	/* Connections between dsa_port and sja1105_port */
 	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
 		struct sja1105_port *sp = &priv->ports[port];
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index a0dacae803cc..bb52b9c841b2 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -515,6 +515,7 @@ struct sja1105_info sja1105e_info = {
 	.qinq_tpid		= ETH_P_8021Q,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
+	.num_cbs_shapers	= SJA1105ET_MAX_CBS_COUNT,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
@@ -530,6 +531,7 @@ struct sja1105_info sja1105t_info = {
 	.qinq_tpid		= ETH_P_8021Q,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
+	.num_cbs_shapers	= SJA1105ET_MAX_CBS_COUNT,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
@@ -545,6 +547,7 @@ struct sja1105_info sja1105p_info = {
 	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
@@ -561,6 +564,7 @@ struct sja1105_info sja1105q_info = {
 	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
@@ -577,6 +581,7 @@ struct sja1105_info sja1105r_info = {
 	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
@@ -594,6 +599,7 @@ struct sja1105_info sja1105s_info = {
 	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 5946847bb5b9..9b62b9b5549d 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -30,11 +30,13 @@
 #define SJA1105ET_SIZE_L2_LOOKUP_PARAMS_ENTRY		4
 #define SJA1105ET_SIZE_GENERAL_PARAMS_ENTRY		40
 #define SJA1105ET_SIZE_AVB_PARAMS_ENTRY			12
+#define SJA1105ET_SIZE_CBS_ENTRY			16
 #define SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY		20
 #define SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY		32
 #define SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_ENTRY		16
 #define SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY		44
 #define SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY		16
+#define SJA1105PQRS_SIZE_CBS_ENTRY			20
 
 /* UM10944.pdf Page 11, Table 2. Configuration Blocks */
 enum {
@@ -56,6 +58,7 @@ enum {
 	BLKID_AVB_PARAMS				= 0x10,
 	BLKID_GENERAL_PARAMS				= 0x11,
 	BLKID_RETAGGING					= 0x12,
+	BLKID_CBS					= 0x13,
 	BLKID_XMII_PARAMS				= 0x4E,
 };
 
@@ -78,6 +81,7 @@ enum sja1105_blk_idx {
 	BLK_IDX_AVB_PARAMS,
 	BLK_IDX_GENERAL_PARAMS,
 	BLK_IDX_RETAGGING,
+	BLK_IDX_CBS,
 	BLK_IDX_XMII_PARAMS,
 	BLK_IDX_MAX,
 	/* Fake block indices that are only valid for dynamic access */
@@ -105,6 +109,8 @@ enum sja1105_blk_idx {
 #define SJA1105_MAX_RETAGGING_COUNT			32
 #define SJA1105_MAX_XMII_PARAMS_COUNT			1
 #define SJA1105_MAX_AVB_PARAMS_COUNT			1
+#define SJA1105ET_MAX_CBS_COUNT				10
+#define SJA1105PQRS_MAX_CBS_COUNT			16
 
 #define SJA1105_MAX_FRAME_MEMORY			929
 #define SJA1105_MAX_FRAME_MEMORY_RETAGGING		910
@@ -289,6 +295,15 @@ struct sja1105_retagging_entry {
 	u64 destports;
 };
 
+struct sja1105_cbs_entry {
+	u64 port;
+	u64 prio;
+	u64 credit_hi;
+	u64 credit_lo;
+	u64 send_slope;
+	u64 idle_slope;
+};
+
 struct sja1105_xmii_params_entry {
 	u64 phy_mac[5];
 	u64 xmii_mode[5];
-- 
2.25.1

