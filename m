Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637B11CE54A
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731648AbgEKUVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731643AbgEKUVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:21:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F408DC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:21:04 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id v12so12585562wrp.12
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cdsx2WX8yPPEU5dLItXwoTRbVwB3nAkT886pyVghIII=;
        b=V/6yYWVmoreYze+lQHnIekVB6+Jf31c+H9aXVOTC491a1Urz2NUOp4IlYPJ/wXFLFt
         z29ILAj6VjZD/HZx1G4e90SM9B7zk7pCUIglz29hamQPnGemfQV7ab2j9DtNLq56KjV8
         i4ri3IptprulPGeqqQrUWZNgpYmDXDXzWPfpR9l1ivrgiM00uBFbRhhmfbNL9lxzdpSE
         KM4UFjTtSdfScN7mwn9jw/xmWszyH0y2UoGRAtpMFHWybl0E6Nv14Jtb0Csmk1uyitUj
         FRkcPpJI55jG/xcU5/qHWc0r/OS1zZEC9ynGen41OQieimQ2SJ6hBgceuTxk8Rp4tAqa
         teBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cdsx2WX8yPPEU5dLItXwoTRbVwB3nAkT886pyVghIII=;
        b=BKOk76ZKnfsBhG8KvNQdba5ECTb+ttS9mZWkbF7AuQICp8HpzfKza/AO3wmPOW8mh8
         PBQQ92EavhkkddUg6X1RTMHnVgQ3jPfHfO/dNHLwF63oS2tQuoLUL33uFTjRXDxpsuhC
         CKPBjkoNtdCSniebKBJfPDwpKDEC3iHdmmo7yP2Vderg9lFK9R/Yszt4pn215hhNFWiC
         Bqkl2/dvBeayYNLl0p2AxmQFhcUDZwTGhlpHLH1ZLSBk2bjqSqm8MMCpDIztvSto4+aU
         MoE60aebNpfIDQ48zBNiD0jtAF/4ODEYilJ/DHeRkHPU0EGp1/V0e3BL2oN12VYcJgPt
         PBwQ==
X-Gm-Message-State: AGi0PubhPCOBZnOwUepWv6tQM5qfHftEmlTSprahMj0zprfuC76p2wdq
        UJyxNtZyrTcBfZ3lzaFbME15O6Pu
X-Google-Smtp-Source: APiQypIERmIpkuX4G5Vwiza2PrBQ7D/faMDvrxV24H4jv2MQij0h3f3FkYP6MqD7nf2mMzbRRisLJg==
X-Received: by 2002:adf:f8c1:: with SMTP id f1mr20629589wrq.171.1589228463712;
        Mon, 11 May 2020 13:21:03 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 77sm19811305wrc.6.2020.05.11.13.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:21:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: dsa: implement and use a generic procedure for the flow dissector
Date:   Mon, 11 May 2020 23:20:46 +0300
Message-Id: <20200511202046.20515-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511202046.20515-1-olteanv@gmail.com>
References: <20200511202046.20515-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For all DSA formats that don't use tail tags, it looks like behind the
obscure number crunching they're all doing the same thing: locating the
real EtherType behind the DSA tag. Nonetheless, this is not immediately
obvious, so create a generic helper for those DSA taggers that put the
header before the EtherType.

Another assumption for the generic function is that the DSA tags are of
equal length on RX and on TX. Prior to the previous patch, this was not
true for ocelot and for gswip. The problem was resolved for ocelot, but
for gswip it still remains, so that hasn't been converted.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h    | 22 ++++++++++++++++++++++
 net/dsa/tag_ar9331.c  |  9 +++++++++
 net/dsa/tag_brcm.c    |  5 +++--
 net/dsa/tag_dsa.c     |  4 ++--
 net/dsa/tag_edsa.c    |  4 ++--
 net/dsa/tag_lan9303.c |  9 +++++++++
 net/dsa/tag_mtk.c     |  3 +--
 net/dsa/tag_ocelot.c  |  9 +++++++++
 net/dsa/tag_qca.c     |  3 +--
 net/dsa/tag_sja1105.c | 13 +++++++++++++
 10 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a1a0ae242012..cad276ff28d1 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -195,6 +195,28 @@ dsa_slave_to_master(const struct net_device *dev)
 	return dp->cpu_dp->master;
 }
 
+/* All DSA tags that push the EtherType to the right (basically all except tail
+ * tags, which don't break dissection) can be treated the same from the
+ * perspective of the flow dissector.
+ *
+ * We need to return:
+ *  - offset: the (B - A) difference between:
+ *    A. the position of the real EtherType and
+ *    B. the current skb->data (aka ETH_HLEN bytes into the frame, aka 2 bytes
+ *       after the normal EtherType was supposed to be)
+ *    The offset in bytes is exactly equal to the tagger overhead (and half of
+ *    that, in __be16 shorts).
+ *
+ *  - proto: the value of the real EtherType.
+ */
+static inline void dsa_tag_generic_flow_dissect(const struct sk_buff *skb,
+						__be16 *proto, int *offset,
+						int tag_len)
+{
+	*offset = tag_len;
+	*proto = ((__be16 *)skb->data)[(tag_len / 2) - 1];
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index 55b00694cdba..9aaae107483b 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -83,12 +83,21 @@ static struct sk_buff *ar9331_tag_rcv(struct sk_buff *skb,
 	return skb;
 }
 
+static int ar9331_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+			       int *offset)
+{
+	dsa_tag_generic_flow_dissect(skb, proto, offset, AR9331_HDR_LEN);
+
+	return 0;
+}
+
 static const struct dsa_device_ops ar9331_netdev_ops = {
 	.name	= "ar9331",
 	.proto	= DSA_TAG_PROTO_AR9331,
 	.xmit	= ar9331_tag_xmit,
 	.rcv	= ar9331_tag_rcv,
 	.overhead = AR9331_HDR_LEN,
+	.flow_dissect = ar9331_flow_dissect,
 };
 
 MODULE_LICENSE("GPL v2");
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index cc8512b5f9e2..9c6c30649d13 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -160,9 +160,10 @@ static int brcm_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 	 * skb->data points 2 bytes before the actual Ethernet type field and
 	 * we have an offset of 4bytes between where skb->data and where the
 	 * payload starts.
+	 * So we can use the generic helper in both cases.
 	 */
-	*offset = BRCM_TAG_LEN;
-	*proto = ((__be16 *)skb->data)[1];
+	dsa_tag_generic_flow_dissect(skb, proto, offset, BRCM_TAG_LEN);
+
 	return 0;
 }
 #endif
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 7ddec9794477..09479ab9a325 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -145,8 +145,8 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 static int dsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 				int *offset)
 {
-	*offset = 4;
-	*proto = ((__be16 *)skb->data)[1];
+	dsa_tag_generic_flow_dissect(skb, proto, offset, DSA_HLEN);
+
 	return 0;
 }
 
diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index e8eaa804ccb9..af16910a06c0 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -164,8 +164,8 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 static int edsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 				 int *offset)
 {
-	*offset = 8;
-	*proto = ((__be16 *)skb->data)[3];
+	dsa_tag_generic_flow_dissect(skb, proto, offset, EDSA_HLEN);
+
 	return 0;
 }
 
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index eb0e7a32e53d..2ec1c9092bb2 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -128,12 +128,21 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
+static int lan9303_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				int *offset)
+{
+	dsa_tag_generic_flow_dissect(skb, proto, offset, LAN9303_TAG_LEN);
+
+	return 0;
+}
+
 static const struct dsa_device_ops lan9303_netdev_ops = {
 	.name = "lan9303",
 	.proto	= DSA_TAG_PROTO_LAN9303,
 	.xmit = lan9303_xmit,
 	.rcv = lan9303_rcv,
 	.overhead = LAN9303_TAG_LEN,
+	.flow_dissect = lan9303_flow_dissect,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index b5705cba8318..e6cf8f68dffc 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -92,8 +92,7 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 static int mtk_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 				int *offset)
 {
-	*offset = 4;
-	*proto = ((__be16 *)skb->data)[1];
+	dsa_tag_generic_flow_dissect(skb, proto, offset, MTK_HDR_LEN);
 
 	return 0;
 }
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 778a7f34f8ec..5a2de13b108f 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -238,12 +238,21 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	return skb;
 }
 
+static int ocelot_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+			       int *offset)
+{
+	dsa_tag_generic_flow_dissect(skb, proto, offset, OCELOT_TOTAL_TAG_LEN);
+
+	return 0;
+}
+
 static struct dsa_device_ops ocelot_netdev_ops = {
 	.name			= "ocelot",
 	.proto			= DSA_TAG_PROTO_OCELOT,
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
 	.overhead		= OCELOT_TOTAL_TAG_LEN,
+	.flow_dissect		= ocelot_flow_dissect,
 };
 
 MODULE_LICENSE("GPL v2");
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 70db7c909f74..43a5a4eebf16 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -90,8 +90,7 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 static int qca_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
                                 int *offset)
 {
-	*offset = QCA_HDR_LEN;
-	*proto = ((__be16 *)skb->data)[0];
+	dsa_tag_generic_flow_dissect(skb, proto, offset, QCA_HDR_LEN);
 
 	return 0;
 }
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index d553bf36bd41..55cc51a71b13 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -304,6 +304,18 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 					      is_meta);
 }
 
+static int sja1105_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				int *offset)
+{
+	/* No tag added for management frames, all ok */
+	if (unlikely(sja1105_is_link_local(skb)))
+		return 0;
+
+	dsa_tag_generic_flow_dissect(skb, proto, offset, VLAN_HLEN);
+
+	return 0;
+}
+
 static struct dsa_device_ops sja1105_netdev_ops = {
 	.name = "sja1105",
 	.proto = DSA_TAG_PROTO_SJA1105,
@@ -311,6 +323,7 @@ static struct dsa_device_ops sja1105_netdev_ops = {
 	.rcv = sja1105_rcv,
 	.filter = sja1105_filter,
 	.overhead = VLAN_HLEN,
+	.flow_dissect = sja1105_flow_dissect,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.17.1

