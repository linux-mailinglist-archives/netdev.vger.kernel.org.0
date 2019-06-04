Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547CE34E64
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbfFDRI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:08:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40921 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbfFDRIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:19 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so172860wmj.5;
        Tue, 04 Jun 2019 10:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uMf7XQ/a8B+6hrSaBSiwz7L6hlwe6nFKczenEE3MaVs=;
        b=sBOBNqwzGLfz2yPB/3xYTYvjAL7Uh+6erPkl1wsYMq0Il9to1Iut0wD1/8HuPkxpPP
         EDH1ycpwlcBPjs1/tILOhcZkCFUcF/yw/dKXOCWB/q22fs9NsgBdCBzUs3vBRb0i6FzR
         QR1Zn/iF1pVcVdPpCYsuYfWF3NxVNEXDOvJrE0qvqfBUbhMWJKJFqJUwxxcLHiNAbed9
         NezuiH3PjsKbGJck5SmbmPBewV7V0pFs8FkHeVQlE88m9dm7uqKAnFfxVADJNU3VIs3s
         yAC0cM8+YN1kXni2zRzck7Sx6NerSXoP/9ZQsp7ja90b1u7XiUNpawMUR2YZSeEHTdcL
         OaXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uMf7XQ/a8B+6hrSaBSiwz7L6hlwe6nFKczenEE3MaVs=;
        b=ZpJ8FVYmdGs69WTLrG9WQ+XwIy2nkw7PDAcHct3CHIAa2pWpwbcg8Gv0T6wITyCACH
         pNXeL4kJsCZfy7T3Ko/mlcBNSJ+rXWBvxn9sA4WCdPtsZsIAyA9o9ajx9J79UkGOZDPd
         W6p2YL6jdBHp4GOZvY33bLyrT/Psw/Sc8ToSZ+vV0CO4T4/0BnHHX+G0mI/aDVssu41k
         WSHGPwQK6uRjxb/6kkvBtjawFevneCqA9dB/RhdzdWLiEavblHoAlbDWwbYnwDBvP06e
         FXKEf+Gxq5VwNdp3yijFZ3VhJ4u72d9xuxqjvZTnl2c2TqWbT07j5/wGlwKjlgtLlQwj
         l5qQ==
X-Gm-Message-State: APjAAAVZnBECbrFM/xfcNfbb+WNpAECK6Y0E+Ubf7gO7iYOWioNAvflm
        5bFpNmwBqX3zf93qLmLEwhE=
X-Google-Smtp-Source: APXvYqyJX/gkcnxqtxiCVX79Y5DXCMWLKyAOTf/vI26qAPG5ODDapitbolJDTbE5SUKHFnE9O15vTg==
X-Received: by 2002:a1c:f610:: with SMTP id w16mr18028325wmc.37.1559668097796;
        Tue, 04 Jun 2019 10:08:17 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 13/17] net: dsa: sja1105: Receive and decode meta frames
Date:   Tue,  4 Jun 2019 20:07:52 +0300
Message-Id: <20190604170756.14338-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support in the tagger for understanding the source port and
switch id of meta frames.  Their timestamp is also extracted but not
used yet - this needs to be done in a state machine that modifies the
previously received timestampable frame - will be added in a follow-up
patch.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:

Split from previous 09/10 patch (no functional changes).

Changes in v2:

None.

 net/dsa/tag_sja1105.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 9ff7cfa6ea20..6ec9a32dda62 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -7,6 +7,36 @@
 #include <linux/packing.h>
 #include "dsa_priv.h"
 
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
@@ -28,6 +58,8 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
  */
 static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
 {
+	if (sja1105_is_meta_frame(skb))
+		return true;
 	if (sja1105_is_link_local(skb))
 		return true;
 	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr))
@@ -66,13 +98,18 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
 {
+	struct sja1105_meta meta = {0};
 	int source_port, switch_id;
 	struct sk_buff *nskb;
 	u16 tpid, vid, tci;
+	bool is_link_local;
 	bool is_tagged;
+	bool is_meta;
 
 	nskb = dsa_8021q_rcv(skb, netdev, pt, &tpid, &tci);
 	is_tagged = (nskb && tpid == ETH_P_SJA1105);
+	is_link_local = sja1105_is_link_local(skb);
+	is_meta = sja1105_is_meta_frame(skb);
 
 	skb->offload_fwd_mark = 1;
 
@@ -82,7 +119,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		source_port = dsa_8021q_rx_source_port(vid);
 		switch_id = dsa_8021q_rx_switch_id(vid);
 		skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
-	} else if (sja1105_is_link_local(skb)) {
+	} else if (is_link_local) {
 		struct ethhdr *hdr = eth_hdr(skb);
 
 		/* Management traffic path. Switch embeds the switch ID and
@@ -94,6 +131,10 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
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

