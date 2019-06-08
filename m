Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA81639F87
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfFHMFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:49 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:42558 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbfFHMFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:47 -0400
Received: by mail-wr1-f41.google.com with SMTP id x17so4637896wrl.9;
        Sat, 08 Jun 2019 05:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RqGelyK1/lMLDmfvKP1//Va+AuX1P/6wHtXNUHUXRnk=;
        b=aTWI+H3cb7CoODUU7DWTMKwmAS/79v68oVaNoX8ldQhhOpYS4zpkhfk3+iZCPp4L7S
         hYc3c12XjTP24KqRz0GAZUQXCx/KWD7HWV7sLQHmVOl+Ne8XaiNeNOGwNcPQ2eUpDbyG
         NAlIIkbL7tSlZKkNaXS9OfXPorwJOkWnEmFAe5OyE5IuL7ypLQ/ryqCBN56cNRlElP8g
         uAhJuD4wRzHA06MNdBGpSglOQb+MJZx5JaH1ZKDXjR2Gj75KODNbq8p940LFmJpWJlH1
         yGEQ1CzwZdmLGia//eDremIzwNa733BV4y4rC40EX9rX+P7v9ALey5pcY77fLMDm0R1Q
         X9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RqGelyK1/lMLDmfvKP1//Va+AuX1P/6wHtXNUHUXRnk=;
        b=gvKi1meBloRp+5h98NJbumF5C9dNkPOWK6HacTjJKL7lGF8kTEzuuVldQ5qMPr1ynR
         R4hUfUpiWWMsVHeTieeGTW66SotJTs4KO7pz+twudJfjOEe7Wm+BdEMoA84gfKvy4wvE
         fnypzRgcavtdhYXcRuIY2cUjEuVg3zRrXFeGcDdWYelmw+3C8+S851tNTTJrYdTAi+Ms
         Ueq47fx3Dr1PBAfITqnICS52YGl6wPHDAPX3WvcVsSFatPLyVi1BWNibqzKZ1zddt/nT
         73op+Pj8VAdAk1A09VSw99FZoe9MpJCcSBm1fcTRW/Xja9YKJW7H8sjz+r/4TBVtPD6P
         3uCQ==
X-Gm-Message-State: APjAAAUap/+QG4zzv+EtCA8lvDNoAksDxf/+RP4vOrwQiXnHU+7jZEEX
        Emh2hfhbpsqB26Y4pfErIg0=
X-Google-Smtp-Source: APXvYqyuURbMqJrykJRPiFZTi+jBxVieS9GTAjLNrzUfnat/ypsz/QJpnKaDRmZUhFCJynzfpBc+Qg==
X-Received: by 2002:adf:de8b:: with SMTP id w11mr13435344wrl.134.1559995545016;
        Sat, 08 Jun 2019 05:05:45 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 09/17] net: dsa: sja1105: Add logic for TX timestamping
Date:   Sat,  8 Jun 2019 15:04:35 +0300
Message-Id: <20190608120443.21889-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On TX, timestamping is performed synchronously from the
port_deferred_xmit worker thread.
In management routes, the switch is requested to take egress timestamps
(again partial), which are reconstructed and appended to a clone of the
skb that was just sent.  The cloning is done by DSA and we retrieve the
pointer from the structure that DSA keeps in skb->cb.
Then these clones are enqueued to the socket's error queue for
application-level processing.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v4:

Added a bunch of EXPORT_SYMBOL_GPL.

Changes in v3:

Split from previous 09/10 patch (no functional changes).

Changes in v2:

None.

 drivers/net/dsa/sja1105/sja1105.h      |  10 +++
 drivers/net/dsa/sja1105/sja1105_main.c |  55 ++++++++++++-
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 106 +++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_ptp.h  |  17 ++++
 drivers/net/dsa/sja1105/sja1105_spi.c  |  14 ++++
 include/linux/dsa/sja1105.h            |   1 +
 6 files changed, 201 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 3c6296203c21..5a4f83a3417b 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -33,6 +33,7 @@ struct sja1105_regs {
 	u64 ptpclk;
 	u64 ptpclkrate;
 	u64 ptptsclk;
+	u64 ptpegr_ts[SJA1105_NUM_PORTS];
 	u64 pad_mii_tx[SJA1105_NUM_PORTS];
 	u64 cgu_idiv[SJA1105_NUM_PORTS];
 	u64 rgmii_pad_mii_tx[SJA1105_NUM_PORTS];
@@ -56,6 +57,15 @@ struct sja1105_info {
 	 * switch core and device_id)
 	 */
 	u64 part_no;
+	/* E/T and P/Q/R/S have partial timestamps of different sizes.
+	 * They must be reconstructed on both families anyway to get the full
+	 * 64-bit values back.
+	 */
+	int ptp_ts_bits;
+	/* Also SPI commands are of different sizes to retrieve
+	 * the egress timestamps.
+	 */
+	int ptpegr_ts_bytes;
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f897fdb12930..121ceccd8107 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1565,7 +1565,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 }
 
 static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
-			     struct sk_buff *skb)
+			     struct sk_buff *skb, bool takets)
 {
 	struct sja1105_mgmt_entry mgmt_route = {0};
 	struct sja1105_private *priv = ds->priv;
@@ -1578,6 +1578,8 @@ static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
 	mgmt_route.macaddr = ether_addr_to_u64(hdr->h_dest);
 	mgmt_route.destports = BIT(port);
 	mgmt_route.enfport = 1;
+	mgmt_route.tsreg = 0;
+	mgmt_route.takets = takets;
 
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MGMT_ROUTE,
 					  slot, &mgmt_route, true);
@@ -1629,7 +1631,11 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_port *sp = &priv->ports[port];
+	struct skb_shared_hwtstamps shwt = {0};
 	int slot = sp->mgmt_slot;
+	struct sk_buff *clone;
+	u64 now, ts;
+	int rc;
 
 	/* The tragic fact about the switch having 4x2 slots for installing
 	 * management routes is that all of them except one are actually
@@ -1647,8 +1653,36 @@ static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
 	 */
 	mutex_lock(&priv->mgmt_lock);
 
-	sja1105_mgmt_xmit(ds, port, slot, skb);
+	/* The clone, if there, was made by dsa_skb_tx_timestamp */
+	clone = DSA_SKB_CB(skb)->clone;
+
+	sja1105_mgmt_xmit(ds, port, slot, skb, !!clone);
+
+	if (!clone)
+		goto out;
+
+	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	mutex_lock(&priv->ptp_lock);
+
+	now = priv->tstamp_cc.read(&priv->tstamp_cc);
+
+	rc = sja1105_ptpegr_ts_poll(priv, slot, &ts);
+	if (rc < 0) {
+		dev_err(ds->dev, "xmit: timed out polling for tstamp\n");
+		kfree_skb(clone);
+		goto out_unlock_ptp;
+	}
+
+	ts = sja1105_tstamp_reconstruct(priv, now, ts);
+	ts = timecounter_cyc2time(&priv->tstamp_tc, ts);
 
+	shwt.hwtstamp = ns_to_ktime(ts);
+	skb_complete_tx_timestamp(clone, &shwt);
+
+out_unlock_ptp:
+	mutex_unlock(&priv->ptp_lock);
+out:
 	mutex_unlock(&priv->mgmt_lock);
 	return NETDEV_TX_OK;
 }
@@ -1677,6 +1711,22 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 	return sja1105_static_config_reload(priv);
 }
 
+/* Called from dsa_skb_tx_timestamp. This callback is just to make DSA clone
+ * the skb and have it available in DSA_SKB_CB in the .port_deferred_xmit
+ * callback, where we will timestamp it synchronously.
+ */
+bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *skb, unsigned int type)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_port *sp = &priv->ports[port];
+
+	if (!sp->hwts_tx_en)
+		return false;
+
+	return true;
+}
+
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
@@ -1701,6 +1751,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
 	.port_deferred_xmit	= sja1105_port_deferred_xmit,
+	.port_txtstamp		= sja1105_port_txtstamp,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 47313a6ec932..01ecc8fb1b30 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -113,6 +113,112 @@ int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
 }
 EXPORT_SYMBOL_GPL(sja1105pqrs_ptp_cmd);
 
+/* The switch returns partial timestamps (24 bits for SJA1105 E/T, which wrap
+ * around in 0.135 seconds, and 32 bits for P/Q/R/S, wrapping around in 34.35
+ * seconds).
+ *
+ * This receives the RX or TX MAC timestamps, provided by hardware as
+ * the lower bits of the cycle counter, sampled at the time the timestamp was
+ * collected.
+ *
+ * To reconstruct into a full 64-bit-wide timestamp, the cycle counter is
+ * read and the high-order bits are filled in.
+ *
+ * Must be called within one wraparound period of the partial timestamp since
+ * it was generated by the MAC.
+ */
+u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv, u64 now,
+			       u64 ts_partial)
+{
+	u64 partial_tstamp_mask = CYCLECOUNTER_MASK(priv->info->ptp_ts_bits);
+	u64 ts_reconstructed;
+
+	ts_reconstructed = (now & ~partial_tstamp_mask) | ts_partial;
+
+	/* Check lower bits of current cycle counter against the timestamp.
+	 * If the current cycle counter is lower than the partial timestamp,
+	 * then wraparound surely occurred and must be accounted for.
+	 */
+	if ((now & partial_tstamp_mask) <= ts_partial)
+		ts_reconstructed -= (partial_tstamp_mask + 1);
+
+	return ts_reconstructed;
+}
+EXPORT_SYMBOL_GPL(sja1105_tstamp_reconstruct);
+
+/* Reads the SPI interface for an egress timestamp generated by the switch
+ * for frames sent using management routes.
+ *
+ * SJA1105 E/T layout of the 4-byte SPI payload:
+ *
+ * 31    23    15    7     0
+ * |     |     |     |     |
+ * +-----+-----+-----+     ^
+ *          ^              |
+ *          |              |
+ *  24-bit timestamp   Update bit
+ *
+ *
+ * SJA1105 P/Q/R/S layout of the 8-byte SPI payload:
+ *
+ * 31    23    15    7     0     63    55    47    39    32
+ * |     |     |     |     |     |     |     |     |     |
+ *                         ^     +-----+-----+-----+-----+
+ *                         |                 ^
+ *                         |                 |
+ *                    Update bit    32-bit timestamp
+ *
+ * Notice that the update bit is in the same place.
+ * To have common code for E/T and P/Q/R/S for reading the timestamp,
+ * we need to juggle with the offset and the bit indices.
+ */
+int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	int tstamp_bit_start, tstamp_bit_end;
+	int timeout = 10;
+	u8 packed_buf[8];
+	u64 update;
+	int rc;
+
+	do {
+		rc = sja1105_spi_send_packed_buf(priv, SPI_READ,
+						 regs->ptpegr_ts[port],
+						 packed_buf,
+						 priv->info->ptpegr_ts_bytes);
+		if (rc < 0)
+			return rc;
+
+		sja1105_unpack(packed_buf, &update, 0, 0,
+			       priv->info->ptpegr_ts_bytes);
+		if (update)
+			break;
+
+		usleep_range(10, 50);
+	} while (--timeout);
+
+	if (!timeout)
+		return -ETIMEDOUT;
+
+	/* Point the end bit to the second 32-bit word on P/Q/R/S,
+	 * no-op on E/T.
+	 */
+	tstamp_bit_end = (priv->info->ptpegr_ts_bytes - 4) * 8;
+	/* Shift the 24-bit timestamp on E/T to be collected from 31:8.
+	 * No-op on P/Q/R/S.
+	 */
+	tstamp_bit_end += 32 - priv->info->ptp_ts_bits;
+	tstamp_bit_start = tstamp_bit_end + priv->info->ptp_ts_bits - 1;
+
+	*ts = 0;
+
+	sja1105_unpack(packed_buf, ts, tstamp_bit_start, tstamp_bit_end,
+		       priv->info->ptpegr_ts_bytes);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sja1105_ptpegr_ts_poll);
+
 int sja1105_ptp_reset(struct sja1105_private *priv)
 {
 	struct dsa_switch *ds = priv->ds;
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 137ffbb0a233..af456b0a4d27 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -10,6 +10,8 @@ int sja1105_ptp_clock_register(struct sja1105_private *priv);
 
 void sja1105_ptp_clock_unregister(struct sja1105_private *priv);
 
+int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts);
+
 int sja1105et_ptp_cmd(const void *ctx, const void *data);
 
 int sja1105pqrs_ptp_cmd(const void *ctx, const void *data);
@@ -17,6 +19,9 @@ int sja1105pqrs_ptp_cmd(const void *ctx, const void *data);
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *ts);
 
+u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv, u64 now,
+			       u64 ts_partial);
+
 int sja1105_ptp_reset(struct sja1105_private *priv);
 
 #else
@@ -31,6 +36,18 @@ static inline void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
 	return;
 }
 
+static inline int
+sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
+{
+	return 0;
+}
+
+static inline u64 sja1105_tstamp_reconstruct(struct sja1105_private *priv,
+					     u64 now, u64 ts_partial)
+{
+	return 0;
+}
+
 static inline int sja1105_ptp_reset(struct sja1105_private *priv)
 {
 	return 0;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index a0d08e6c22ff..d729a0f0b28e 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -514,6 +514,7 @@ static struct sja1105_regs sja1105et_regs = {
 	.rgmii_tx_clk = {0x100016, 0x10001D, 0x100024, 0x10002B, 0x100032},
 	.rmii_ref_clk = {0x100015, 0x10001C, 0x100023, 0x10002A, 0x100031},
 	.rmii_ext_tx_clk = {0x100018, 0x10001F, 0x100026, 0x10002D, 0x100034},
+	.ptpegr_ts = {0xC0, 0xC2, 0xC4, 0xC6, 0xC8},
 	.ptp_control = 0x17,
 	.ptpclk = 0x18, /* Spans 0x18 to 0x19 */
 	.ptpclkrate = 0x1A,
@@ -544,6 +545,7 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.rmii_ref_clk = {0x100015, 0x10001B, 0x100021, 0x100027, 0x10002D},
 	.rmii_ext_tx_clk = {0x100017, 0x10001D, 0x100023, 0x100029, 0x10002F},
 	.qlevel = {0x604, 0x614, 0x624, 0x634, 0x644},
+	.ptpegr_ts = {0xC0, 0xC4, 0xC8, 0xCC, 0xD0},
 	.ptp_control = 0x18,
 	.ptpclk = 0x19,
 	.ptpclkrate = 0x1B,
@@ -555,6 +557,8 @@ struct sja1105_info sja1105e_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105e_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
+	.ptp_ts_bits		= 24,
+	.ptpegr_ts_bytes	= 4,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
@@ -567,6 +571,8 @@ struct sja1105_info sja1105t_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105t_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
+	.ptp_ts_bits		= 24,
+	.ptpegr_ts_bytes	= 4,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
@@ -579,6 +585,8 @@ struct sja1105_info sja1105p_info = {
 	.part_no		= SJA1105P_PART_NO,
 	.static_ops		= sja1105p_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
@@ -591,6 +599,8 @@ struct sja1105_info sja1105q_info = {
 	.part_no		= SJA1105Q_PART_NO,
 	.static_ops		= sja1105q_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
@@ -603,6 +613,8 @@ struct sja1105_info sja1105r_info = {
 	.part_no		= SJA1105R_PART_NO,
 	.static_ops		= sja1105r_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
@@ -616,6 +628,8 @@ struct sja1105_info sja1105s_info = {
 	.static_ops		= sja1105s_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.regs			= &sja1105pqrs_regs,
+	.ptp_ts_bits		= 32,
+	.ptpegr_ts_bytes	= 8,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index e46e18c47d41..5a956f335022 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -22,6 +22,7 @@
 
 struct sja1105_port {
 	struct dsa_port *dp;
+	bool hwts_tx_en;
 	int mgmt_slot;
 };
 
-- 
2.17.1

