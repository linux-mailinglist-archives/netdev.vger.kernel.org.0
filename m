Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4710139F90
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfFHMHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:07:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42678 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbfFHMFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:40 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so4637710wrl.9;
        Sat, 08 Jun 2019 05:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IwFX1gV3kv+DhvtDY/asckKndY+U8mEghXL4BdmiOno=;
        b=Fni6xVUitQBeOrtEbHh3G3mONCLuC5BPcivL6/sCuhd0o799Dmur7CihAvs6/EKjni
         XHC+f1JowFfLXDY1AVKBL4K9LhEJthB5vUpOiSYoby/n8deRC1eTcKDxY2tHuGMbJRBx
         yEbyyb+xNg/Kj8Ph0uTetPzalIHk4xkRhNYf3JxLDvzPtZ3S0mOkRkG2lZ7BlpnQdbkG
         fnZhoAG/G5T4R6BMNDiKHitk/fWlsG3hgpGEAckCICMov4/XvOqou6uW8FhD9E8tAWsu
         YJ8B/uJSwugqsXQM/8kPe/bdoL8ynY/tRDcsVrPLNn4VIl90JOnX7R89FHXnK4ZA5wIx
         v2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IwFX1gV3kv+DhvtDY/asckKndY+U8mEghXL4BdmiOno=;
        b=EmzPHKjxMayXhgBCKK9oAskXJs32kPEZK2K471nhhNuhSRYn+KF2ZkJzfYpm4KoLCr
         z/jyY4w6gSS8dRyjnmuKtaE8r7eS47wKi8OL1u0dXSwRylXq+jj+Em/IQXsklJd1qHfF
         J7MWq7iX+oBTbMaTwPHM+JzIKfX5FsQfjGmcZ1yE/X528Hut/TvSpUNgBKd2QQtTh6Lk
         3r/C24I76vyvkhtXsWF/3DpUtgL8RDqiUMZoILxCm7KiQu1l5B9KYnC1v5bUZwbw/L4G
         /Y3NblTN0BPDiyZluVAVteTrnDjTrfmP3UNt1yS+MrX6QIKNdukDVo/DOhbfgvIn3qEt
         nwqg==
X-Gm-Message-State: APjAAAUwiwnyBlEQfcxTXpa3v4rxHIVRtolIm/ntn4cDU9N/3FZYmQww
        TF6LouJxLjuveMaaczZ58nU=
X-Google-Smtp-Source: APXvYqwg5Qwg0itNhMKoXRPesYDSqNDum7Ze1yHWT4UfQEO8qU7rUZyf3Ts9tj2G7VfeV1PrQUXmaw==
X-Received: by 2002:adf:a509:: with SMTP id i9mr25281195wrb.269.1559995537626;
        Sat, 08 Jun 2019 05:05:37 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 03/17] net: dsa: tag_8021q: Create helper function for removing VLAN header
Date:   Sat,  8 Jun 2019 15:04:29 +0300
Message-Id: <20190608120443.21889-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes the existing implementation from tag_sja1105, which was
partially incorrect (it was not changing the MAC header offset, thereby
leaving it to point 4 bytes earlier than it should have).

This overwrites the VLAN tag by moving the Ethernet source and
destination MACs 4 bytes to the right. Then skb->data (assumed to be
pointing immediately after the EtherType) is temporarily pushed to the
beginning of the new Ethernet header, the new Ethernet header offset and
length are recorded, then skb->data is moved back to where it was.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v4:

Now includes the skb_pull from dsa_8021q_rcv which has been now removed.
The reason is that it is incorrect to do the skb_pull if the frame is
untagged, which was previously done anyway.

A bunch of extra things are now only done if we know for sure that the
frame is tagged, such as setting skb->priority.

Also added an ASCII image.

Changes in v3:

None.

Changes in v2:

Patch is new.

 include/linux/dsa/8021q.h | 16 +++++------
 net/dsa/tag_8021q.c       | 57 +++++++++++++++++++++++++--------------
 net/dsa/tag_sja1105.c     | 19 +++++++------
 3 files changed, 53 insertions(+), 39 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 3911e0586478..0aa803c451a3 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -20,9 +20,6 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci);
 
-struct sk_buff *dsa_8021q_rcv(struct sk_buff *skb, struct net_device *netdev,
-			      struct packet_type *pt, u16 *tpid, u16 *tci);
-
 u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
 
 u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port);
@@ -31,6 +28,8 @@ int dsa_8021q_rx_switch_id(u16 vid);
 
 int dsa_8021q_rx_source_port(u16 vid);
 
+struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb);
+
 #else
 
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
@@ -45,12 +44,6 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 	return NULL;
 }
 
-struct sk_buff *dsa_8021q_rcv(struct sk_buff *skb, struct net_device *netdev,
-			      struct packet_type *pt, u16 *tpid, u16 *tci)
-{
-	return NULL;
-}
-
 u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port)
 {
 	return 0;
@@ -71,6 +64,11 @@ int dsa_8021q_rx_source_port(u16 vid)
 	return 0;
 }
 
+struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
+{
+	return NULL;
+}
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q) */
 
 #endif /* _NET_DSA_8021Q_H */
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 65a35e976d7b..6ebbd799c4eb 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -235,31 +235,48 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_xmit);
 
-struct sk_buff *dsa_8021q_rcv(struct sk_buff *skb, struct net_device *netdev,
-			      struct packet_type *pt, u16 *tpid, u16 *tci)
+/* In the DSA packet_type handler, skb->data points in the middle of the VLAN
+ * tag, after tpid and before tci. This is because so far, ETH_HLEN
+ * (DMAC, SMAC, EtherType) bytes were pulled.
+ * There are 2 bytes of VLAN tag left in skb->data, and upper
+ * layers expect the 'real' EtherType to be consumed as well.
+ * Coincidentally, a VLAN header is also of the same size as
+ * the number of bytes that need to be pulled.
+ *
+ * skb_mac_header                                      skb->data
+ * |                                                       |
+ * v                                                       v
+ * |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
+ * +-----------------------+-----------------------+-------+-------+-------+
+ * |    Destination MAC    |      Source MAC       |  TPID |  TCI  | EType |
+ * +-----------------------+-----------------------+-------+-------+-------+
+ * ^                                               |               |
+ * |<--VLAN_HLEN-->to                              <---VLAN_HLEN--->
+ * from            |
+ *       >>>>>>>   v
+ *       >>>>>>>   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
+ *       >>>>>>>   +-----------------------+-----------------------+-------+
+ *       >>>>>>>   |    Destination MAC    |      Source MAC       | EType |
+ *                 +-----------------------+-----------------------+-------+
+ *                 ^                                                       ^
+ * (now part of    |                                                       |
+ *  skb->head)     skb_mac_header                                  skb->data
+ */
+struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
 {
-	struct vlan_ethhdr *tag;
-
-	if (unlikely(!pskb_may_pull(skb, VLAN_HLEN)))
-		return NULL;
+	u8 *from = skb_mac_header(skb);
+	u8 *dest = from + VLAN_HLEN;
 
-	tag = vlan_eth_hdr(skb);
-	*tpid = ntohs(tag->h_vlan_proto);
-	*tci = ntohs(tag->h_vlan_TCI);
-
-	/* skb->data points in the middle of the VLAN tag,
-	 * after tpid and before tci. This is because so far,
-	 * ETH_HLEN (DMAC, SMAC, EtherType) bytes were pulled.
-	 * There are 2 bytes of VLAN tag left in skb->data, and upper
-	 * layers expect the 'real' EtherType to be consumed as well.
-	 * Coincidentally, a VLAN header is also of the same size as
-	 * the number of bytes that need to be pulled.
-	 */
-	skb_pull_rcsum(skb, VLAN_HLEN);
+	memmove(dest, from, ETH_HLEN - VLAN_HLEN);
+	skb_pull(skb, VLAN_HLEN);
+	skb_push(skb, ETH_HLEN);
+	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
+	skb_pull_rcsum(skb, ETH_HLEN);
 
 	return skb;
 }
-EXPORT_SYMBOL_GPL(dsa_8021q_rcv);
+EXPORT_SYMBOL_GPL(dsa_8021q_remove_header);
 
 static const struct dsa_device_ops dsa_8021q_netdev_ops = {
 	.name		= "8021q",
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index d43737e6c3fb..77eeea004e92 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -66,17 +66,14 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
 {
-	struct ethhdr *hdr = eth_hdr(skb);
-	u64 source_port, switch_id;
-	struct sk_buff *nskb;
+	int source_port, switch_id;
+	struct vlan_ethhdr *hdr;
 	u16 tpid, vid, tci;
 	bool is_tagged;
 
-	nskb = dsa_8021q_rcv(skb, netdev, pt, &tpid, &tci);
-	is_tagged = (nskb && tpid == ETH_P_SJA1105);
-
-	skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
-	vid = tci & VLAN_VID_MASK;
+	hdr = vlan_eth_hdr(skb);
+	tpid = ntohs(hdr->h_vlan_proto);
+	is_tagged = (tpid == ETH_P_SJA1105);
 
 	skb->offload_fwd_mark = 1;
 
@@ -92,8 +89,11 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		hdr->h_dest[4] = 0;
 	} else {
 		/* Normal traffic path. */
+		tci = ntohs(hdr->h_vlan_TCI);
+		vid = tci & VLAN_VID_MASK;
 		source_port = dsa_8021q_rx_source_port(vid);
 		switch_id = dsa_8021q_rx_switch_id(vid);
+		skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 	}
 
 	skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
@@ -106,8 +106,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	 * it there, see dsa_switch_rcv: skb_push(skb, ETH_HLEN).
 	 */
 	if (is_tagged)
-		memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - VLAN_HLEN,
-			ETH_HLEN - VLAN_HLEN);
+		skb = dsa_8021q_remove_header(skb);
 
 	return skb;
 }
-- 
2.17.1

