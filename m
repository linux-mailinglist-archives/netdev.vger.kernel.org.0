Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C410B3A490F
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhFKTEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhFKTEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:04:09 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFC6C061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:01:55 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id k25so6000091eja.9
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qGDP4Nzjobe8b0NyYKwYNId4CVzgcySv4zCO4kM091c=;
        b=Ap80vKStW3yluaTNs37E0RQ01YwZUQrG6X55TvxrhbB7jccCSvjNwi4rzJtq4nTswR
         BcvnZ7wjFeCYIkBAImFSKCo7U5v+Sr3PZEpzXH7aMkiEs6cIrFse09PF1eEV7tH57O0b
         eXtajrhHFj9GPeH1D+MzezSHQ1f1QpLXNXMqUuy6gyB1ehw7KqeZ2m+snKqL6xEjTOjH
         8ucpwr73X9JJr8ic87rkavz6ktbc9PgZwkJl02QB1p7rL4pNgQzwg4MtkkrBb+WJi9eX
         Q6bcABdqNwzX4c21tgNWrKdGamyG4qDWDrNO9+q/bXMQvqjhZxpitudUvFcZhCXB1zRe
         27sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qGDP4Nzjobe8b0NyYKwYNId4CVzgcySv4zCO4kM091c=;
        b=b9vM36ZLK+hjDnB7GcSH7zYAymVPKJxTnKhF8sjRXPtDQSLmXbvQ8TV9F/bW5s0a+/
         fKCZCz621hB96pEO95I+p3nRlN6l1J5swiejxWMGu4fxvlnrm73o8YKqt8F02ZTceqAr
         pJ3t5EM72Hxr1I6Ml7TJnsBQCgFx3HhxKN7SINCmRS1CFS76ortx39++BuDaFfdbZM3d
         39Cscy8rL/7mFhqfOWFK9/KdLVpEbxQ8K/+hl6a7UfXYXv0p5IBsutoKCY2gLoupeZoe
         nbl10BMCPZyaZvSpGbGVlmTC0Slkv4I2DPl0kR8Ys6AgDqun6I1bpEGtL8YMc5trdRJ1
         6dMw==
X-Gm-Message-State: AOAM531RpGnWjOO9Y4f8Egkbx9Imt5YWo3B0ebi9QF7Hl/zeRqrhQDJm
        Kt4scaBQn4FvCqAt0zOoMKYQi3t6Zc4=
X-Google-Smtp-Source: ABdhPJyv2/H11H6va++U7Gc5baKgP+PLOtIe962QsBRnhJCVt2TbQIKJ6a3tvzuQzUqdTSP/BkSsOQ==
X-Received: by 2002:a17:906:1796:: with SMTP id t22mr4848879eje.304.1623438113246;
        Fri, 11 Jun 2021 12:01:53 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c19sm2922016edw.10.2021.06.11.12.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:01:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 09/10] net: dsa: sja1105: add the RX timestamping procedure for SJA1110
Date:   Fri, 11 Jun 2021 22:01:30 +0300
Message-Id: <20210611190131.2362911-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611190131.2362911-1-olteanv@gmail.com>
References: <20210611190131.2362911-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is really easy, since the full RX timestamp is in the DSA trailer
and the tagger code transfers it to SJA1105_SKB_CB(skb)->tstamp, we just
need to move it to the skb shared info region. This is as opposed to
SJA1105, where the RX timestamp was received in a meta frame (so there
needed to be a state machine to pair the 2 packets) and the timestamp
was partial (so the packet, once matched with its timestamp, needed to
be added to an RX timestamping queue where the PTP aux worker would
reconstruct that timestamp).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: context change due to rebase
v1->v2: none

 drivers/net/dsa/sja1105/sja1105.h     |  1 +
 drivers/net/dsa/sja1105/sja1105_ptp.c | 26 +++++++++++++++++++++++---
 drivers/net/dsa/sja1105/sja1105_ptp.h |  6 ++++++
 drivers/net/dsa/sja1105/sja1105_spi.c | 10 ++++++++++
 4 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index a6d64b27e6a9..201bca282884 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -130,6 +130,7 @@ struct sja1105_info {
 			   const unsigned char *addr, u16 vid);
 	void (*ptp_cmd_packing)(u8 *buf, struct sja1105_ptp_cmd *cmd,
 				enum packing_op op);
+	bool (*rxtstamp)(struct dsa_switch *ds, int port, struct sk_buff *skb);
 	int (*clocking_setup)(struct sja1105_private *priv);
 	const char *name;
 	bool supports_mii[SJA1105_MAX_NUM_PORTS];
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index dea82f8a40c4..62fe05b4cb60 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -413,9 +413,7 @@ static long sja1105_rxtstamp_work(struct ptp_clock_info *ptp)
 	return -1;
 }
 
-/* Called from dsa_skb_defer_rx_timestamp */
-bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
-			   struct sk_buff *skb, unsigned int type)
+bool sja1105_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
@@ -431,6 +429,28 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
 	return true;
 }
 
+bool sja1110_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
+{
+	struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
+	u64 ts = SJA1105_SKB_CB(skb)->tstamp;
+
+	*shwt = (struct skb_shared_hwtstamps) {0};
+
+	shwt->hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(ts));
+
+	/* Don't defer */
+	return false;
+}
+
+/* Called from dsa_skb_defer_rx_timestamp */
+bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *skb, unsigned int type)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	return priv->info->rxtstamp(ds, port, skb);
+}
+
 /* Called from dsa_skb_tx_timestamp. This callback is just to clone
  * the skb and have it available in SJA1105_SKB_CB in the .port_deferred_xmit
  * callback, where we will timestamp it synchronously.
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 34f97f58a355..bf0c4f1dfed7 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -122,6 +122,9 @@ int __sja1105_ptp_adjtime(struct dsa_switch *ds, s64 delta);
 int sja1105_ptp_commit(struct dsa_switch *ds, struct sja1105_ptp_cmd *cmd,
 		       sja1105_spi_rw_mode_t rw);
 
+bool sja1105_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
+bool sja1110_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
+
 #else
 
 struct sja1105_ptp_cmd;
@@ -184,6 +187,9 @@ static inline int sja1105_ptp_commit(struct dsa_switch *ds,
 
 #define sja1105_hwtstamp_set NULL
 
+#define sja1105_rxtstamp NULL
+#define sja1110_rxtstamp NULL
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP) */
 
 #endif /* _SJA1105_PTP_H */
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 9156f4cc11f2..f7dd86271891 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -580,6 +580,7 @@ const struct sja1105_info sja1105e_info = {
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
 	.port_speed		= {
@@ -612,6 +613,7 @@ const struct sja1105_info sja1105t_info = {
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
 	.port_speed		= {
@@ -645,6 +647,7 @@ const struct sja1105_info sja1105p_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
 	.port_speed		= {
@@ -678,6 +681,7 @@ const struct sja1105_info sja1105q_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
 	.port_speed		= {
@@ -711,6 +715,7 @@ const struct sja1105_info sja1105r_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
 	.port_speed		= {
@@ -746,6 +751,7 @@ const struct sja1105_info sja1105s_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -781,6 +787,7 @@ const struct sja1105_info sja1110a_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -828,6 +835,7 @@ const struct sja1105_info sja1110b_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -875,6 +883,7 @@ const struct sja1105_info sja1110c_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -922,6 +931,7 @@ const struct sja1105_info sja1110d_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
-- 
2.25.1

