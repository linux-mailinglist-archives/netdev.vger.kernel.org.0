Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC2C39F7D
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfFHMFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56010 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbfFHMFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so4435748wmj.5;
        Sat, 08 Jun 2019 05:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sNV1+l2zrIEcZ9b9XPotZ33wf2y9YWNBvOFKHuhuCUc=;
        b=gdLj4P2JqCVgjni56Kx5VNdOB6SXOfqm3rRfAFobteka6wZTs6S6IrkHPbigv74luK
         kza1P91HGIrqlLVdky/N6PcM44dZDPz/LbrESdRpeLIb0ZsDyaQ0QlPR+K/dDIKzNDGk
         BUx943oP2CCCPT/ibn4PzAUsNFtPtLj8/MuTS3ba2NRGBWQ30/XbyYW8EVJr/LVO3ZAN
         Vv/jacc6l/I99PBZtwgwLpjzMGDZgz+R0JBTWSd+hz9xnLSK/NHHYree6tJS5Ys1BHL+
         M8lDVTQYsNnzdlay8u0eD42CFb7d1uClvEn4hAbHGHUnpL7bH3RWdNUPBIHrimHXe3e2
         WOfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sNV1+l2zrIEcZ9b9XPotZ33wf2y9YWNBvOFKHuhuCUc=;
        b=ZDMn4qaOeX85ymJegC86v9/NRn7y0R6EzEKTtacTnCokuwEsFIj+xoND4LALRZhEPp
         ocopjdaEhpUPdJTNEWh6ulnhQRkj1zCwVH9l8m8TQSnZ4B0V7Tik4G88VdtgC2ippl5Q
         G8sC3Le3z9Z5O7N+NOyIPii8Q59GON3GqNyNfLn/hBYaOGbaGCqZKeHuZFuQd16xx+uk
         6DYNA64q5zk3qX+crz0JLT7TZCMK+P+5Gj7kZH09DOjl3ZMmbpV4GAA5yXRvfSf46+hP
         hYL9UNgeE6dZrdLxZY6UnfgyzE4LPCV/LKfwR0ixHXielBGV9s73uZpZOEXcbILGL84D
         McxA==
X-Gm-Message-State: APjAAAWaV/Bqirw1hfqT8PlKd3QjQswFmI/vgBPWQKpPOUpZo9AL8XVB
        qUmhz41+JAvsst6U7cnf4ZE=
X-Google-Smtp-Source: APXvYqw8HCPM4wIiNHkMrZdmJW0AO4BZ2jdWzJGe7aN0vhIlPk4cIQvvnocPkFPTQMhuUji4RhpChw==
X-Received: by 2002:a1c:ca14:: with SMTP id a20mr1869833wmg.71.1559995549503;
        Sat, 08 Jun 2019 05:05:49 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 13/17] net: dsa: sja1105: Receive and decode meta frames
Date:   Sat,  8 Jun 2019 15:04:39 +0300
Message-Id: <20190608120443.21889-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support in the tagger for understanding the source port and
switch id of meta frames.  Their timestamp is also extracted but not
used yet - this needs to be done in a state machine that modifies the
previously received timestampable frame - will be added in a follow-up
patch.

Also take the opportunity to:
- Remove a comment in sja1105_filter made obsolete by e8d67fa5696e
  ("net: dsa: sja1105: Don't store frame type in skb->cb")
- Reorder the checks in sja1105_filter to optimize for the most likely
  scenario first: regular traffic.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v4:

See last paragraph from the commit message.

Changes in v3:

Split from previous 09/10 patch (no functional changes).

Changes in v2:

None.

 net/dsa/tag_sja1105.c | 44 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 094711ced5c0..5b51e96130c7 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -24,6 +24,36 @@ static inline bool sja1105_is_link_local(const struct sk_buff *skb)
 	return false;
 }
 
+struct sja1105_meta {
+	u64 tstamp;
+	u64 dmac_byte_4;
+	u64 dmac_byte_3;
+	u64 source_port;
+	u64 switch_id;
+};
+
+static void sja1105_meta_unpack(const struct sk_buff *skb,
+				struct sja1105_meta *meta)
+{
+	u8 *buf = skb_mac_header(skb) + ETH_HLEN;
+
+	/* UM10944.pdf section 4.2.17 AVB Parameters:
+	 * Structure of the meta-data follow-up frame.
+	 * It is in network byte order, so there are no quirks
+	 * while unpacking the meta frame.
+	 *
+	 * Also SJA1105 E/T only populates bits 23:0 of the timestamp
+	 * whereas P/Q/R/S does 32 bits. Since the structure is the
+	 * same and the E/T puts zeroes in the high-order byte, use
+	 * a unified unpacking command for both device series.
+	 */
+	packing(buf,     &meta->tstamp,     31, 0, 4, UNPACK, 0);
+	packing(buf + 4, &meta->dmac_byte_4, 7, 0, 1, UNPACK, 0);
+	packing(buf + 5, &meta->dmac_byte_3, 7, 0, 1, UNPACK, 0);
+	packing(buf + 6, &meta->source_port, 7, 0, 1, UNPACK, 0);
+	packing(buf + 7, &meta->switch_id,   7, 0, 1, UNPACK, 0);
+}
+
 static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
 {
 	const struct ethhdr *hdr = eth_hdr(skb);
@@ -40,14 +70,15 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
 }
 
 /* This is the first time the tagger sees the frame on RX.
- * Figure out if we can decode it, and if we can, annotate skb->cb with how we
- * plan to do that, so we don't need to check again in the rcv function.
+ * Figure out if we can decode it.
  */
 static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
 {
+	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr))
+		return true;
 	if (sja1105_is_link_local(skb))
 		return true;
-	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr))
+	if (sja1105_is_meta_frame(skb))
 		return true;
 	return false;
 }
@@ -83,16 +114,19 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
 {
+	struct sja1105_meta meta = {0};
 	int source_port, switch_id;
 	struct vlan_ethhdr *hdr;
 	u16 tpid, vid, tci;
 	bool is_link_local;
 	bool is_tagged;
+	bool is_meta;
 
 	hdr = vlan_eth_hdr(skb);
 	tpid = ntohs(hdr->h_vlan_proto);
 	is_tagged = (tpid == ETH_P_SJA1105);
 	is_link_local = sja1105_is_link_local(skb);
+	is_meta = sja1105_is_meta_frame(skb);
 
 	skb->offload_fwd_mark = 1;
 
@@ -113,6 +147,10 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		/* Clear the DMAC bytes that were mangled by the switch */
 		hdr->h_dest[3] = 0;
 		hdr->h_dest[4] = 0;
+	} else if (is_meta) {
+		sja1105_meta_unpack(skb, &meta);
+		source_port = meta.source_port;
+		switch_id = meta.switch_id;
 	} else {
 		return NULL;
 	}
-- 
2.17.1

