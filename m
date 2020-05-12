Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE491CFC0B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730947AbgELRVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730482AbgELRUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:20:55 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1529C061A0C;
        Tue, 12 May 2020 10:20:54 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g12so24385856wmh.3;
        Tue, 12 May 2020 10:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iiP/NdqlDNsJNXKAwVqaX/NC9+Am15VBEy6Yp+gGXjw=;
        b=KxkyxvjvzSeXBYDIF9zNGtYab8KbOsGn1XCA/EbSRrbJDFvaiVRRa/W0EBEH27sqJN
         VA9ab0sT9IB4cNqjgnbMzV45EIoumJ59Dx0VQtOubu4eZf4z2sSXj3l7zXGx5sNPTss5
         PWioe9KEcScjTwM7H4ScTJbd41kopfYP4qJA1t1s+tjg7BG6oFO8DLP3ne1a2aO4xMD7
         kFYvamMy2dGf1Tcrffz1zoRfBHAIZNjD9jBT8RgNFoyiwU9D8jlZ8bgagV2PGzIG2Rk5
         Y6/4U33aNFFVeVVzpgHIBifiM/QaC2LMNQcZPPBjZtqfqg0+pYfEqjqRutRfk8m4xFy7
         W1mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iiP/NdqlDNsJNXKAwVqaX/NC9+Am15VBEy6Yp+gGXjw=;
        b=qlQ/BYCCFEuPL89Nlrg3NcEjyX3eFhdMTkjL0E6fGL4odkC9djrqni3W17W+XJu0Pp
         1rMVV4N3YbW1Iy0ljyBaorc0hiILauBpi6H/vanvZNQcPhBy+IXmt4EAlZnxrM/eu0e1
         DLSBOkHLmV45z0yQUsa9j0LUORT4StgtWvJXGcss6QXX+fpHmDLkxFWNnv2Y4ytLN0JA
         nHCdrP9WZbhUc7+//7qt0HVfmZxiq2iDo/pBKmH+y2WwFnuPbiF2GDi93ahJa5t71t7b
         p2H+HvtSDd2fjUImsSQ8nOrzAnMV3qX9M7HE9kAOABcXtBifL9jLE55znIL7I9o5UEiK
         PyIA==
X-Gm-Message-State: AGi0PuabAK8NRwC8BCqWWI158HN/ZJ2NMDHi0njDPk1TC8BPt/6k85YH
        OeRiLBlm8jRaw/UmHIqD48Q=
X-Google-Smtp-Source: APiQypK9WdUwWQ+wZ03AxX/CJjJEeOwTKFq17ycO10c2OY+LXxmyNWkV+cflq98MNOxF1wo5rpGFbg==
X-Received: by 2002:a1c:96c7:: with SMTP id y190mr7236722wmd.69.1589304053459;
        Tue, 12 May 2020 10:20:53 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id a15sm23999743wrw.56.2020.05.12.10.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:20:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 08/15] net: dsa: sja1105: prepare tagger for handling DSA tags and VLAN simultaneously
Date:   Tue, 12 May 2020 20:20:32 +0300
Message-Id: <20200512172039.14136-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512172039.14136-1-olteanv@gmail.com>
References: <20200512172039.14136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In VLAN-unaware mode, sja1105 uses VLAN tags with a custom TPID of
0xdadb. While in the yet-to-be introduced best_effort_vlan_filtering
mode, it needs to work with normal VLAN TPID values.

A complication arises when we must transmit a VLAN-tagged packet to the
switch when it's in VLAN-aware mode. We need to construct a packet with
2 VLAN tags, and the switch will use the outer header for routing and
pop it on egress. But sadly, here the 2 hardware generations don't
behave the same:

- E/T switches won't pop an ETH_P_8021AD tag on egress, it seems
  (packets will remain double-tagged).
- P/Q/R/S switches will drop a packet with 2 ETH_P_8021Q tags (it looks
  like it tries to prevent VLAN hopping).

But looks like the reverse is also true:

- E/T switches have no problem popping the outer tag from packets with
  2 ETH_P_8021Q tags.
- P/Q/R/S will have no problem popping a single tag even if that is
  ETH_P_8021AD.

So it is clear that if we want the hardware to work with dsa_8021q
tagging in VLAN-aware mode, we need to send different TPIDs depending on
revision. Keep that information in priv->info->qinq_tpid.

The per-port tagger structure will hold an xmit_tpid value that depends
not only upon the qinq_tpid, but also upon the VLAN awareness state
itself (in case we must transmit using 0xdadb).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
Provide an implementation of sja1105_can_use_vlan_as_tags as part of the
tagger and not as part of the switch driver. So we have to look at the
skb only, and not at the VLAN awareness state.

Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105.h      |  6 +++++
 drivers/net/dsa/sja1105/sja1105_main.c | 10 ++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c  |  6 +++++
 include/linux/dsa/sja1105.h            |  1 +
 net/dsa/tag_sja1105.c                  | 32 +++++++++++++++++---------
 5 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index c80f1999c694..a019ffae38f1 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -87,6 +87,12 @@ struct sja1105_info {
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
+	/* Both E/T and P/Q/R/S have quirks when it comes to popping the S-Tag
+	 * from double-tagged frames. E/T will pop it only when it's equal to
+	 * TPID from the General Parameters Table, while P/Q/R/S will only
+	 * pop it when it's equal to TPID2.
+	 */
+	u16 qinq_tpid;
 	int (*reset_cmd)(struct dsa_switch *ds);
 	int (*setup_rgmii_delay)(const void *ctx, int port);
 	/* Prototypes from include/net/dsa.h */
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 7b9c3db98e1d..b7e4a85caade 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2153,6 +2153,15 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 		tpid2 = ETH_P_SJA1105;
 	}
 
+	for (port = 0; port < ds->num_ports; port++) {
+		struct sja1105_port *sp = &priv->ports[port];
+
+		if (enabled)
+			sp->xmit_tpid = priv->info->qinq_tpid;
+		else
+			sp->xmit_tpid = ETH_P_SJA1105;
+	}
+
 	if (!enabled)
 		state = SJA1105_VLAN_UNAWARE;
 	else
@@ -2866,6 +2875,7 @@ static int sja1105_probe(struct spi_device *spi)
 			goto out;
 		}
 		skb_queue_head_init(&sp->xmit_queue);
+		sp->xmit_tpid = ETH_P_SJA1105;
 	}
 
 	return 0;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 0be75c49e6c3..a0dacae803cc 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -512,6 +512,7 @@ struct sja1105_info sja1105e_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105e_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
+	.qinq_tpid		= ETH_P_8021Q,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
 	.reset_cmd		= sja1105et_reset_cmd,
@@ -526,6 +527,7 @@ struct sja1105_info sja1105t_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105t_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
+	.qinq_tpid		= ETH_P_8021Q,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
 	.reset_cmd		= sja1105et_reset_cmd,
@@ -540,6 +542,7 @@ struct sja1105_info sja1105p_info = {
 	.part_no		= SJA1105P_PART_NO,
 	.static_ops		= sja1105p_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
@@ -555,6 +558,7 @@ struct sja1105_info sja1105q_info = {
 	.part_no		= SJA1105Q_PART_NO,
 	.static_ops		= sja1105q_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
@@ -570,6 +574,7 @@ struct sja1105_info sja1105r_info = {
 	.part_no		= SJA1105R_PART_NO,
 	.static_ops		= sja1105r_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
+	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
@@ -586,6 +591,7 @@ struct sja1105_info sja1105s_info = {
 	.static_ops		= sja1105s_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.regs			= &sja1105pqrs_regs,
+	.qinq_tpid		= ETH_P_8021AD,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index fa5735c353cd..f821d08b1b5f 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -59,6 +59,7 @@ struct sja1105_port {
 	struct sja1105_tagger_data *data;
 	struct dsa_port *dp;
 	bool hwts_tx_en;
+	u16 xmit_tpid;
 };
 
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index d553bf36bd41..adeffd3b515a 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -69,12 +69,25 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
 	return true;
 }
 
+static bool sja1105_can_use_vlan_as_tags(const struct sk_buff *skb)
+{
+	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
+
+	if (hdr->h_vlan_proto == ntohs(ETH_P_SJA1105))
+		return true;
+
+	if (hdr->h_vlan_proto != ntohs(ETH_P_8021Q))
+		return false;
+
+	return vid_is_dsa_8021q(ntohs(hdr->h_vlan_TCI) & VLAN_VID_MASK);
+}
+
 /* This is the first time the tagger sees the frame on RX.
  * Figure out if we can decode it.
  */
 static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
 {
-	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr))
+	if (sja1105_can_use_vlan_as_tags(skb))
 		return true;
 	if (sja1105_is_link_local(skb))
 		return true;
@@ -96,6 +109,11 @@ static struct sk_buff *sja1105_defer_xmit(struct sja1105_port *sp,
 	return NULL;
 }
 
+static u16 sja1105_xmit_tpid(struct sja1105_port *sp)
+{
+	return sp->xmit_tpid;
+}
+
 static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
@@ -111,15 +129,7 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	if (unlikely(sja1105_is_link_local(skb)))
 		return sja1105_defer_xmit(dp->priv, skb);
 
-	/* If we are under a vlan_filtering bridge, IP termination on
-	 * switch ports based on 802.1Q tags is simply too brittle to
-	 * be passable. So just defer to the dsa_slave_notag_xmit
-	 * implementation.
-	 */
-	if (dsa_port_is_vlan_filtering(dp))
-		return skb;
-
-	return dsa_8021q_xmit(skb, netdev, ETH_P_SJA1105,
+	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp->priv),
 			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
 }
 
@@ -258,7 +268,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	hdr = eth_hdr(skb);
 	tpid = ntohs(hdr->h_proto);
-	is_tagged = (tpid == ETH_P_SJA1105);
+	is_tagged = (tpid == ETH_P_SJA1105 || tpid == ETH_P_8021Q);
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
 
-- 
2.17.1

