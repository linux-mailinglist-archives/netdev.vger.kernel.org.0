Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5691909E0
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 10:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgCXJpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 05:45:50 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51477 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgCXJpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 05:45:49 -0400
Received: by mail-wm1-f67.google.com with SMTP id c187so2433281wme.1
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 02:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=a+BNklpOtTOp7ecROiHd+OUh4xwRFL5eAV+QAM019Lw=;
        b=oTYTUXkWejV7nhT4x2gmk+3slK2ii+zR1IhhMCI2mG4aozg8aq/lFZwqzhIykaXqrZ
         jFYQdeQlr4nTgD15dsn/yTZ05dpCWS+wEUaoGGVaw+ApIKTVYDSsY+gJlfoydDiXcP4A
         +epDt+Z1+89CkrlqAKa053w2s65Lg9E0KgIYtMyD+e1jwexI8B7VDIhjOFL4MyNmHJrD
         AA6LYIjO4quxYVq7rpQ8g9DH39hJR5Dvz2M4s9yuTIjciBb0N2bADVtYhKEeoh9DSv+u
         zwxWlWU1Gy9rzPGjMEuEBRAwFXHVIfs2m/VkIzrZ26cdIwgvvCqzjPTSB2cszN3BZMYv
         ofVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=a+BNklpOtTOp7ecROiHd+OUh4xwRFL5eAV+QAM019Lw=;
        b=YDE/PWNbqT15vnYxKOcMuZLU95EIsFlEJIRUKEa11jGicNEdpYF+7907/C71Hh0Glw
         DQUY9CoH4puV6S4WK9/Fe+DHFTcDRdN2U/Qdy8Ujbvsk7WSv02Or9L6l+WCBCFJ6pgLp
         QbmNPXZxSNwV5ZXyN4cXj7mbZ+ASIO3z0jpGGTSoezwbd+6fwrF+YCFMoesqJNrSymTN
         /02lc1WyUayJ6GXxNraJ3xHIa77wlSggYvmPdYK37sYsznGxBH5WyllPQy5Xnnm+fhuh
         SqcH8ciMr6U4DHbIksoa+ifYXmPMO0mZchzaamMB1voGVMm0w+r+lpDosuRv2jWBlP5d
         6SnA==
X-Gm-Message-State: ANhLgQ3d+281aEqjojwgTCdkDjQ5sj0LCOrVI4ewpqklI7BKny733hl4
        gPYyqrYOoXUUHbSQaEvqIFI=
X-Google-Smtp-Source: ADFU+vu9vr5NHvcIzbDTfrdiAzSGiWnl3QyjcQSRRHOEm1Hem5a+xNkGMbtEZpKwkxVKyRKTMfvpLg==
X-Received: by 2002:a1c:4645:: with SMTP id t66mr4706548wma.6.1585043148139;
        Tue, 24 Mar 2020 02:45:48 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id q8sm3398818wmj.22.2020.03.24.02.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 02:45:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: [PATCH net] net: dsa: tag_8021q: replace dsa_8021q_remove_header with __skb_vlan_pop
Date:   Tue, 24 Mar 2020 11:45:34 +0200
Message-Id: <20200324094534.29769-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Not only did this wheel did not need reinventing, but there is also
an issue with it: It doesn't remove the VLAN header in a way that
preserves the L2 payload checksum when that is being provided by the DSA
master hw.  It should recalculate checksum both for the push, before
removing the header, and for the pull afterwards. But the current
implementation is quite dizzying, with pulls followed immediately
afterwards by pushes, the memmove is done before the push, etc.  This
makes a DSA master with RX checksumming offload to print stack traces
with the infamous 'hw csum failure' message.

So remove the dsa_8021q_remove_header function and replace it with
something that actually works with inet checksumming.

Fixes: d461933638ae ("net: dsa: tag_8021q: Create helper function for removing VLAN header")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/dsa/8021q.h |  7 -------
 net/dsa/tag_8021q.c       | 43 ---------------------------------------
 net/dsa/tag_sja1105.c     | 19 ++++++++---------
 3 files changed, 9 insertions(+), 60 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 0aa803c451a3..c620d9139c28 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -28,8 +28,6 @@ int dsa_8021q_rx_switch_id(u16 vid);
 
 int dsa_8021q_rx_source_port(u16 vid);
 
-struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb);
-
 #else
 
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
@@ -64,11 +62,6 @@ int dsa_8021q_rx_source_port(u16 vid)
 	return 0;
 }
 
-struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
-{
-	return NULL;
-}
-
 #endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q) */
 
 #endif /* _NET_DSA_8021Q_H */
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 2fb6c26294b5..b97ad93d1c1a 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -298,47 +298,4 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_xmit);
 
-/* In the DSA packet_type handler, skb->data points in the middle of the VLAN
- * tag, after tpid and before tci. This is because so far, ETH_HLEN
- * (DMAC, SMAC, EtherType) bytes were pulled.
- * There are 2 bytes of VLAN tag left in skb->data, and upper
- * layers expect the 'real' EtherType to be consumed as well.
- * Coincidentally, a VLAN header is also of the same size as
- * the number of bytes that need to be pulled.
- *
- * skb_mac_header                                      skb->data
- * |                                                       |
- * v                                                       v
- * |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
- * +-----------------------+-----------------------+-------+-------+-------+
- * |    Destination MAC    |      Source MAC       |  TPID |  TCI  | EType |
- * +-----------------------+-----------------------+-------+-------+-------+
- * ^                                               |               |
- * |<--VLAN_HLEN-->to                              <---VLAN_HLEN--->
- * from            |
- *       >>>>>>>   v
- *       >>>>>>>   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
- *       >>>>>>>   +-----------------------+-----------------------+-------+
- *       >>>>>>>   |    Destination MAC    |      Source MAC       | EType |
- *                 +-----------------------+-----------------------+-------+
- *                 ^                                                       ^
- * (now part of    |                                                       |
- *  skb->head)     skb_mac_header                                  skb->data
- */
-struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
-{
-	u8 *from = skb_mac_header(skb);
-	u8 *dest = from + VLAN_HLEN;
-
-	memmove(dest, from, ETH_HLEN - VLAN_HLEN);
-	skb_pull(skb, VLAN_HLEN);
-	skb_push(skb, ETH_HLEN);
-	skb_reset_mac_header(skb);
-	skb_reset_mac_len(skb);
-	skb_pull_rcsum(skb, ETH_HLEN);
-
-	return skb;
-}
-EXPORT_SYMBOL_GPL(dsa_8021q_remove_header);
-
 MODULE_LICENSE("GPL v2");
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 5366ea430349..d553bf36bd41 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -250,14 +250,14 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 {
 	struct sja1105_meta meta = {0};
 	int source_port, switch_id;
-	struct vlan_ethhdr *hdr;
+	struct ethhdr *hdr;
 	u16 tpid, vid, tci;
 	bool is_link_local;
 	bool is_tagged;
 	bool is_meta;
 
-	hdr = vlan_eth_hdr(skb);
-	tpid = ntohs(hdr->h_vlan_proto);
+	hdr = eth_hdr(skb);
+	tpid = ntohs(hdr->h_proto);
 	is_tagged = (tpid == ETH_P_SJA1105);
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
@@ -266,7 +266,12 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	if (is_tagged) {
 		/* Normal traffic path. */
-		tci = ntohs(hdr->h_vlan_TCI);
+		skb_push_rcsum(skb, ETH_HLEN);
+		__skb_vlan_pop(skb, &tci);
+		skb_pull_rcsum(skb, ETH_HLEN);
+		skb_reset_network_header(skb);
+		skb_reset_transport_header(skb);
+
 		vid = tci & VLAN_VID_MASK;
 		source_port = dsa_8021q_rx_source_port(vid);
 		switch_id = dsa_8021q_rx_switch_id(vid);
@@ -295,12 +300,6 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	/* Delete/overwrite fake VLAN header, DSA expects to not find
-	 * it there, see dsa_switch_rcv: skb_push(skb, ETH_HLEN).
-	 */
-	if (is_tagged)
-		skb = dsa_8021q_remove_header(skb);
-
 	return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
 					      is_meta);
 }
-- 
2.17.1

