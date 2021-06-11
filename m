Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411253A490A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhFKTD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhFKTDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:03:51 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38008C0613A3
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:01:53 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id c10so5988651eja.11
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Aip/AX3Z7mmMRiROj37ZahxfgAUnXlNjk7feKeF1PTM=;
        b=M2xUxtDnOZUM+wX8JvedHt7NwVnuiT2jVBk51bbIkI0CnL7UBC7szoyuv4Gx2W/9AU
         +G0nTO26x2xwAnc+/CfBWrzuZSZvhJXQihSHMt+T9zGYkb+IzbmtEz9AYIe1lrvnkifu
         RyrjiUDstB1LLBo9aeEkL3K1Em7UXU4DSzLu+r5fIYVWnbzylDS1FDpa5GWQfWk0KiWk
         vv1v3Q/IR0PK/B7lbvWlz42RO2/69KdbZKLsFHUowXfsBQmjdVG928gvdT0j3pGXxdwG
         0o/FgdcibjmjZxe/m+thKgnYJslsWtlqqJpQrNzahpYaprazej55VX7OvlB7pCM1wu47
         2npA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Aip/AX3Z7mmMRiROj37ZahxfgAUnXlNjk7feKeF1PTM=;
        b=JXgUrzG7Kcw7OlpJd+yjTbppR5GTvSX3CN7mrm8boeDykMRdH58JwGP3S7Q5O1nIR5
         P8NxBLxcRPS8hvWlCgy32w6HEf2fanPSekCOlZotuz3qRsa34uYHU6BNm2db6mybg5Md
         zisd/9Pqk+UCsXz3+EngH19206Z/SLxMQnIldr4Re29auoN3tNV2mzqaTiS6p/uXHDVo
         AO92rpZ54EfSjhTGamSlGtWpR1wSxwCOaE62NfmuOdtIh9WbufN1jwG6s6OglLYjoyKU
         +HNnIIrGaDBgE3VEa3bP8r6EhzXK1xdlhrgRU7t1sof/5juYteIL4Avw6o8/jA16Gl0X
         xlOw==
X-Gm-Message-State: AOAM531tNUoxAtN8UF0Q37ZJm2uYQtyaiS5sEZ5m2a4g+SMF2nY12pUR
        P7fyLDbKNLaiNi6YSRnYlJU=
X-Google-Smtp-Source: ABdhPJyz1NsjklAk7i44VLAw79gOndfUQGDkL3oW/mNP9Uhc7deIoTC0J9UI1VzPt2CUa21tboWKvA==
X-Received: by 2002:a17:907:d9e:: with SMTP id go30mr5010461ejc.279.1623438111636;
        Fri, 11 Jun 2021 12:01:51 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c19sm2922016edw.10.2021.06.11.12.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:01:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 08/10] net: dsa: add support for the SJA1110 native tagging protocol
Date:   Fri, 11 Jun 2021 22:01:29 +0300
Message-Id: <20210611190131.2362911-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611190131.2362911-1-olteanv@gmail.com>
References: <20210611190131.2362911-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1110 has improved a few things compared to SJA1105:

- To send a control packet from the host port with SJA1105, one needed
  to program a one-shot "management route" over SPI. This is no longer
  true with SJA1110, you can actually send "in-band control extensions"
  in the packets sent by DSA, these are in fact DSA tags which contain
  the destination port and switch ID.

- When receiving a control packet from the switch with SJA1105, the
  source port and switch ID were written in bytes 3 and 4 of the
  destination MAC address of the frame (which was a very poor shot at a
  DSA header). If the control packet also had an RX timestamp, that
  timestamp was sent in an actual follow-up packet, so there were
  reordering concerns on multi-core/multi-queue DSA masters, where the
  metadata frame with the RX timestamp might get processed before the
  actual packet to which that timestamp belonged (there is no way to
  pair a packet to its timestamp other than the order in which they were
  received). On SJA1110, this is no longer true, control packets have
  the source port, switch ID and timestamp all in the DSA tags.

- Timestamps from the switch were partial: to get a 64-bit timestamp as
  required by PTP stacks, one would need to take the partial 24-bit or
  32-bit timestamp from the packet, then read the current PTP time very
  quickly, and then patch in the high bits of the current PTP time into
  the captured partial timestamp, to reconstruct what the full 64-bit
  timestamp must have been. That is awful because packet processing is
  done in NAPI context, but reading the current PTP time is done over
  SPI and therefore needs sleepable context.

But it also aggravated a few things:

- Not only is there a DSA header in SJA1110, but there is a DSA trailer
  in fact, too. So DSA needs to be extended to support taggers which
  have both a header and a trailer. Very unconventional - my understanding
  is that the trailer exists because the timestamps couldn't be prepared
  in time for putting them in the header area.

- Like SJA1105, not all packets sent to the CPU have the DSA tag added
  to them, only control packets do:

  * the ones which match the destination MAC filters/traps in
    MAC_FLTRES1 and MAC_FLTRES0
  * the ones which match FDB entries which have TRAP or TAKETS bits set

  So we could in theory hack something up to request the switch to take
  timestamps for all packets that reach the CPU, and those would be
  DSA-tagged and contain the source port / switch ID by virtue of the
  fact that there needs to be a timestamp trailer provided. BUT:

- The SJA1110 does not parse its own DSA tags in a way that is useful
  for routing in cross-chip topologies, a la Marvell. And the sja1105
  driver already supports cross-chip bridging from the SJA1105 days.
  It does that by automatically setting up the DSA links as VLAN trunks
  which contain all the necessary tag_8021q RX VLANs that must be
  communicated between the switches that span the same bridge. So when
  using tag_8021q on sja1105, it is possible to have 2 switches with
  ports sw0p0, sw0p1, sw1p0, sw1p1, and 2 VLAN-unaware bridges br0 and
  br1, and br0 can take sw0p0 and sw1p0, and br1 can take sw0p1 and
  sw1p1, and forwarding will happen according to the expected rules of
  the Linux bridge.
  We like that, and we don't want that to go away, so as a matter of
  fact, the SJA1110 tagger still needs to support tag_8021q.

So the sja1110 tagger is a hybrid between tag_8021q for data packets,
and the native hardware support for control packets.

On RX, packets have a 13-byte trailer if they contain an RX timestamp.
That trailer is padded in such a way that its byte 8 (the start of the
"residence time" field - not parsed by Linux because we don't care) is
aligned on a 16 byte boundary. So the padding has a variable length
between 0 and 15 bytes. The DSA header contains the offset of the
beginning of the padding relative to the beginning of the frame (and the
end of the padding is obviously the end of the packet minus 13 bytes,
the length of the trailer). So we discard it.

Packets which don't have a trailer contain the source port and switch ID
information in the header (they are "trap-to-host" packets). Packets
which have a trailer contain the source port and switch ID in the trailer.

On TX, the destination port mask and switch ID is always in the trailer,
so we always need to say in the header that a trailer is present.

The header needs a custom EtherType and this was chosen as 0xdadc, after
0xdada which is for Marvell and 0xdadb which is for VLANs in
VLAN-unaware mode on SJA1105 (and SJA1110 in fact too).

Because we use tag_8021q in concert with the native tagging protocol,
control packets will have 2 DSA tags.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: none

 drivers/net/dsa/sja1105/sja1105.h             |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c        |   6 +-
 drivers/net/dsa/sja1105/sja1105_spi.c         |  10 +
 .../net/dsa/sja1105/sja1105_static_config.c   |   1 +
 .../net/dsa/sja1105/sja1105_static_config.h   |   1 +
 include/linux/dsa/sja1105.h                   |   1 +
 include/net/dsa.h                             |   2 +
 net/dsa/tag_sja1105.c                         | 221 +++++++++++++++++-
 8 files changed, 240 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 4d192331754c..a6d64b27e6a9 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -110,6 +110,7 @@ struct sja1105_info {
 	int max_frame_mem;
 	int num_ports;
 	bool multiple_cascade_ports;
+	enum dsa_tag_protocol tag_proto;
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 850bbc793369..6e2cfbf605ef 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -667,6 +667,8 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.tpid2 = ETH_P_SJA1105,
 		/* Enable the TTEthernet engine on SJA1110 */
 		.tte_en = true,
+		/* Set up the EtherType for control packets on SJA1110 */
+		.header_type = ETH_P_SJA1110,
 	};
 	struct sja1105_general_params_entry *general_params;
 	struct dsa_switch *ds = priv->ds;
@@ -2174,7 +2176,9 @@ static enum dsa_tag_protocol
 sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 			 enum dsa_tag_protocol mp)
 {
-	return DSA_TAG_PROTO_SJA1105;
+	struct sja1105_private *priv = ds->priv;
+
+	return priv->info->tag_proto;
 }
 
 static int sja1105_find_free_subvlan(u16 *subvlan_map, bool pvid)
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index e6c2a37aa617..9156f4cc11f2 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -569,6 +569,7 @@ const struct sja1105_info sja1105e_info = {
 	.static_ops		= sja1105e_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
 	.qinq_tpid		= ETH_P_8021Q,
+	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= false,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
@@ -600,6 +601,7 @@ const struct sja1105_info sja1105t_info = {
 	.static_ops		= sja1105t_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
 	.qinq_tpid		= ETH_P_8021Q,
+	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= false,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
@@ -631,6 +633,7 @@ const struct sja1105_info sja1105p_info = {
 	.static_ops		= sja1105p_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.qinq_tpid		= ETH_P_8021AD,
+	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
@@ -663,6 +666,7 @@ const struct sja1105_info sja1105q_info = {
 	.static_ops		= sja1105q_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.qinq_tpid		= ETH_P_8021AD,
+	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
@@ -695,6 +699,7 @@ const struct sja1105_info sja1105r_info = {
 	.static_ops		= sja1105r_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.qinq_tpid		= ETH_P_8021AD,
+	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
@@ -729,6 +734,7 @@ const struct sja1105_info sja1105s_info = {
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.regs			= &sja1105pqrs_regs,
 	.qinq_tpid		= ETH_P_8021AD,
+	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
@@ -762,6 +768,7 @@ const struct sja1105_info sja1110a_info = {
 	.dyn_ops		= sja1110_dyn_ops,
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
+	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
@@ -808,6 +815,7 @@ const struct sja1105_info sja1110b_info = {
 	.dyn_ops		= sja1110_dyn_ops,
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
+	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
@@ -854,6 +862,7 @@ const struct sja1105_info sja1110c_info = {
 	.dyn_ops		= sja1110_dyn_ops,
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
+	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
@@ -900,6 +909,7 @@ const struct sja1105_info sja1110d_info = {
 	.dyn_ops		= sja1110_dyn_ops,
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
+	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index eda571819d45..1491b72008f3 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -212,6 +212,7 @@ size_t sja1110_general_params_entry_packing(void *buf, void *entry_ptr,
 	sja1105_packing(buf, &entry->egrmirrdei,   110, 110, size, op);
 	sja1105_packing(buf, &entry->replay_port,  109, 106, size, op);
 	sja1105_packing(buf, &entry->tdmaconfigidx, 70,  67, size, op);
+	sja1105_packing(buf, &entry->header_type,   64,  49, size, op);
 	sja1105_packing(buf, &entry->tte_en,        16,  16, size, op);
 	return size;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 9bef51791bff..bce0f5c03d0b 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -217,6 +217,7 @@ struct sja1105_general_params_entry {
 	/* SJA1110 only */
 	u64 tte_en;
 	u64 tdmaconfigidx;
+	u64 header_type;
 };
 
 struct sja1105_schedule_entry_points_entry {
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 865a548a6ef2..b02cf7b515ae 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -14,6 +14,7 @@
 
 #define ETH_P_SJA1105				ETH_P_DSA_8021Q
 #define ETH_P_SJA1105_META			0x0008
+#define ETH_P_SJA1110				0xdadc
 
 /* IEEE 802.3 Annex 57A: Slow Protocols PDUs (01:80:C2:xx:xx:xx) */
 #define SJA1105_LINKLOCAL_FILTER_A		0x0180C2000000ull
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0a10f6fffc3d..289d68e82da0 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -50,6 +50,7 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
 #define DSA_TAG_PROTO_SEVILLE_VALUE		21
 #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
+#define DSA_TAG_PROTO_SJA1110_VALUE		23
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -75,6 +76,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
 	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
 	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
+	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
 };
 
 struct packet_type;
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 11f555dd9566..37e1d64e07c6 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -7,6 +7,47 @@
 #include <linux/packing.h>
 #include "dsa_priv.h"
 
+/* Is this a TX or an RX header? */
+#define SJA1110_HEADER_HOST_TO_SWITCH		BIT(15)
+
+/* RX header */
+#define SJA1110_RX_HEADER_IS_METADATA		BIT(14)
+#define SJA1110_RX_HEADER_HOST_ONLY		BIT(13)
+#define SJA1110_RX_HEADER_HAS_TRAILER		BIT(12)
+
+/* Trap-to-host format (no trailer present) */
+#define SJA1110_RX_HEADER_SRC_PORT(x)		(((x) & GENMASK(7, 4)) >> 4)
+#define SJA1110_RX_HEADER_SWITCH_ID(x)		((x) & GENMASK(3, 0))
+
+/* Timestamp format (trailer present) */
+#define SJA1110_RX_HEADER_TRAILER_POS(x)	((x) & GENMASK(11, 0))
+
+#define SJA1110_RX_TRAILER_SWITCH_ID(x)		(((x) & GENMASK(7, 4)) >> 4)
+#define SJA1110_RX_TRAILER_SRC_PORT(x)		((x) & GENMASK(3, 0))
+
+/* TX header */
+#define SJA1110_TX_HEADER_UPDATE_TC		BIT(14)
+#define SJA1110_TX_HEADER_TAKE_TS		BIT(13)
+#define SJA1110_TX_HEADER_TAKE_TS_CASC		BIT(12)
+#define SJA1110_TX_HEADER_HAS_TRAILER		BIT(11)
+
+/* Only valid if SJA1110_TX_HEADER_HAS_TRAILER is false */
+#define SJA1110_TX_HEADER_PRIO(x)		(((x) << 7) & GENMASK(10, 7))
+#define SJA1110_TX_HEADER_TSTAMP_ID(x)		((x) & GENMASK(7, 0))
+
+/* Only valid if SJA1110_TX_HEADER_HAS_TRAILER is true */
+#define SJA1110_TX_HEADER_TRAILER_POS(x)	((x) & GENMASK(10, 0))
+
+#define SJA1110_TX_TRAILER_TSTAMP_ID(x)		(((x) << 24) & GENMASK(31, 24))
+#define SJA1110_TX_TRAILER_PRIO(x)		(((x) << 21) & GENMASK(23, 21))
+#define SJA1110_TX_TRAILER_SWITCHID(x)		(((x) << 12) & GENMASK(15, 12))
+#define SJA1110_TX_TRAILER_DESTPORTS(x)		(((x) << 1) & GENMASK(11, 1))
+
+#define SJA1110_HEADER_LEN			4
+#define SJA1110_RX_TRAILER_LEN			13
+#define SJA1110_TX_TRAILER_LEN			4
+#define SJA1110_MAX_PADDING_LEN			15
+
 /* Similar to is_link_local_ether_addr(hdr->h_dest) but also covers PTP */
 static inline bool sja1105_is_link_local(const struct sk_buff *skb)
 {
@@ -140,6 +181,50 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
 }
 
+static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
+				    struct net_device *netdev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(netdev);
+	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	struct ethhdr *eth_hdr;
+	__be32 *tx_trailer;
+	__be16 *tx_header;
+	int trailer_pos;
+
+	/* Transmitting control packets is done using in-band control
+	 * extensions, while data packets are transmitted using
+	 * tag_8021q TX VLANs.
+	 */
+	if (likely(!sja1105_is_link_local(skb)))
+		return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp->priv),
+				     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
+
+	skb_push(skb, SJA1110_HEADER_LEN);
+
+	/* Move Ethernet header to the left, making space for DSA tag */
+	memmove(skb->data, skb->data + SJA1110_HEADER_LEN, 2 * ETH_ALEN);
+
+	trailer_pos = skb->len;
+
+	/* On TX, skb->data points to skb_mac_header(skb) */
+	eth_hdr = (struct ethhdr *)skb->data;
+	tx_header = (__be16 *)(eth_hdr + 1);
+	tx_trailer = skb_put(skb, SJA1110_TX_TRAILER_LEN);
+
+	eth_hdr->h_proto = htons(ETH_P_SJA1110);
+
+	*tx_header = htons(SJA1110_HEADER_HOST_TO_SWITCH |
+			   SJA1110_TX_HEADER_HAS_TRAILER |
+			   SJA1110_TX_HEADER_TRAILER_POS(trailer_pos));
+	*tx_trailer = cpu_to_be32(SJA1110_TX_TRAILER_PRIO(pcp) |
+				  SJA1110_TX_TRAILER_SWITCHID(dp->ds->index) |
+				  SJA1110_TX_TRAILER_DESTPORTS(BIT(dp->index)));
+
+	return skb;
+}
+
 static void sja1105_transfer_meta(struct sk_buff *skb,
 				  const struct sja1105_meta *meta)
 {
@@ -283,6 +368,11 @@ static bool sja1105_skb_has_tag_8021q(const struct sk_buff *skb)
 	       skb_vlan_tag_present(skb);
 }
 
+static bool sja1110_skb_has_inband_control_extension(const struct sk_buff *skb)
+{
+	return ntohs(eth_hdr(skb)->h_proto) == ETH_P_SJA1110;
+}
+
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
@@ -333,6 +423,98 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 					      is_meta);
 }
 
+static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
+							    int *source_port,
+							    int *switch_id)
+{
+	u16 rx_header;
+
+	if (unlikely(!pskb_may_pull(skb, SJA1110_HEADER_LEN)))
+		return NULL;
+
+	/* skb->data points to skb_mac_header(skb) + ETH_HLEN, which is exactly
+	 * what we need because the caller has checked the EtherType (which is
+	 * located 2 bytes back) and we just need a pointer to the header that
+	 * comes afterwards.
+	 */
+	rx_header = ntohs(*(__be16 *)skb->data);
+
+	/* Timestamp frame, we have a trailer */
+	if (rx_header & SJA1110_RX_HEADER_HAS_TRAILER) {
+		int start_of_padding = SJA1110_RX_HEADER_TRAILER_POS(rx_header);
+		u8 *rx_trailer = skb_tail_pointer(skb) - SJA1110_RX_TRAILER_LEN;
+		u64 *tstamp = &SJA1105_SKB_CB(skb)->tstamp;
+		u8 last_byte = rx_trailer[12];
+
+		/* The timestamp is unaligned, so we need to use packing()
+		 * to get it
+		 */
+		packing(rx_trailer, tstamp, 63, 0, 8, UNPACK, 0);
+
+		*source_port = SJA1110_RX_TRAILER_SRC_PORT(last_byte);
+		*switch_id = SJA1110_RX_TRAILER_SWITCH_ID(last_byte);
+
+		/* skb->len counts from skb->data, while start_of_padding
+		 * counts from the destination MAC address. Right now skb->data
+		 * is still as set by the DSA master, so to trim away the
+		 * padding and trailer we need to account for the fact that
+		 * skb->data points to skb_mac_header(skb) + ETH_HLEN.
+		 */
+		pskb_trim_rcsum(skb, start_of_padding - ETH_HLEN);
+	/* Trap-to-host frame, no timestamp trailer */
+	} else {
+		*source_port = SJA1110_RX_HEADER_SRC_PORT(rx_header);
+		*switch_id = SJA1110_RX_HEADER_SWITCH_ID(rx_header);
+	}
+
+	/* Advance skb->data past the DSA header */
+	skb_pull_rcsum(skb, SJA1110_HEADER_LEN);
+
+	/* Remove the DSA header */
+	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - SJA1110_HEADER_LEN,
+		2 * ETH_ALEN);
+
+	/* With skb->data in its final place, update the MAC header
+	 * so that eth_hdr() continues to works properly.
+	 */
+	skb_set_mac_header(skb, -ETH_HLEN);
+
+	return skb;
+}
+
+static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
+				   struct net_device *netdev,
+				   struct packet_type *pt)
+{
+	int source_port = -1, switch_id = -1, subvlan = 0;
+
+	skb->offload_fwd_mark = 1;
+
+	if (sja1110_skb_has_inband_control_extension(skb)) {
+		skb = sja1110_rcv_inband_control_extension(skb, &source_port,
+							   &switch_id);
+		if (!skb)
+			return NULL;
+	}
+
+	/* Packets with in-band control extensions might still have RX VLANs */
+	if (likely(sja1105_skb_has_tag_8021q(skb)))
+		dsa_8021q_rcv(skb, &source_port, &switch_id, &subvlan);
+
+	skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
+	if (!skb->dev) {
+		netdev_warn(netdev,
+			    "Couldn't decode source port %d and switch id %d\n",
+			    source_port, switch_id);
+		return NULL;
+	}
+
+	if (subvlan)
+		sja1105_decode_subvlan(skb, subvlan);
+
+	return skb;
+}
+
 static void sja1105_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 				 int *offset)
 {
@@ -343,6 +525,20 @@ static void sja1105_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 	dsa_tag_generic_flow_dissect(skb, proto, offset);
 }
 
+static void sja1110_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
+{
+	/* Management frames have 2 DSA tags on RX, so the needed_headroom we
+	 * declared is fine for the generic dissector adjustment procedure.
+	 */
+	if (unlikely(sja1105_is_link_local(skb)))
+		return dsa_tag_generic_flow_dissect(skb, proto, offset);
+
+	/* For the rest, there is a single DSA tag, the tag_8021q one */
+	*offset = VLAN_HLEN;
+	*proto = ((__be16 *)skb->data)[(VLAN_HLEN / 2) - 1];
+}
+
 static const struct dsa_device_ops sja1105_netdev_ops = {
 	.name = "sja1105",
 	.proto = DSA_TAG_PROTO_SJA1105,
@@ -354,7 +550,28 @@ static const struct dsa_device_ops sja1105_netdev_ops = {
 	.promisc_on_master = true,
 };
 
-MODULE_LICENSE("GPL v2");
+DSA_TAG_DRIVER(sja1105_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_SJA1105);
 
-module_dsa_tag_driver(sja1105_netdev_ops);
+static const struct dsa_device_ops sja1110_netdev_ops = {
+	.name = "sja1110",
+	.proto = DSA_TAG_PROTO_SJA1110,
+	.xmit = sja1110_xmit,
+	.rcv = sja1110_rcv,
+	.filter = sja1105_filter,
+	.flow_dissect = sja1110_flow_dissect,
+	.needed_headroom = SJA1110_HEADER_LEN + VLAN_HLEN,
+	.needed_tailroom = SJA1110_RX_TRAILER_LEN + SJA1110_MAX_PADDING_LEN,
+};
+
+DSA_TAG_DRIVER(sja1110_netdev_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_SJA1110);
+
+static struct dsa_tag_driver *sja1105_tag_driver_array[] = {
+	&DSA_TAG_DRIVER_NAME(sja1105_netdev_ops),
+	&DSA_TAG_DRIVER_NAME(sja1110_netdev_ops),
+};
+
+module_dsa_tag_drivers(sja1105_tag_driver_array);
+
+MODULE_LICENSE("GPL v2");
-- 
2.25.1

