Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D438C61FE00
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiKGSz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbiKGSzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:55:37 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508BF25E96;
        Mon,  7 Nov 2022 10:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Qys05PG22fbxdWm5s8ByJ0wPdOueN+diTukAKqcYoqA=; b=FxYpLAUUzZ0MezR3P4pPCvkz2p
        /RYuPhe0ELtcVlsyntSnLU/zmxETClklGmsfqVpQIdY0+hM+lS07kJrd/7+XniM7QNEyUlKZGFC+N
        6wKJjv6SCdI4vdLSRQfStoVeLpLj4cpnvQk6E9QmauVKZ+Uy2JAPOi0HZU51jBVmFT+k=;
Received: from p200300daa72ee1007849d74f78949f6c.dip0.t-ipconnect.de ([2003:da:a72e:e100:7849:d74f:7894:9f6c] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1os7HF-000LCc-A1; Mon, 07 Nov 2022 19:55:21 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] net: dsa: tag_mtk: parse hwaccel VLAN tags
Date:   Mon,  7 Nov 2022 19:54:48 +0100
Message-Id: <20221107185452.90711-10-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221107185452.90711-1-nbd@nbd.name>
References: <20221107185452.90711-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pull the port information from the VLAN protocol ID field

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/dsa/tag_mtk.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 445d6113227f..0dfa2354f77d 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -73,13 +73,18 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(!pskb_may_pull(skb, MTK_HDR_LEN)))
 		return NULL;
 
-	phdr = dsa_etype_header_pos_rx(skb);
-	hdr = ntohs(*phdr);
+	if (skb_vlan_tag_present(skb)) {
+		hdr = ntohs(skb->vlan_proto);
+		__vlan_hwaccel_clear_tag(skb);
+	} else {
+		phdr = dsa_etype_header_pos_rx(skb);
+		hdr = ntohs(*phdr);
 
-	/* Remove MTK tag and recalculate checksum. */
-	skb_pull_rcsum(skb, MTK_HDR_LEN);
+		/* Remove MTK tag and recalculate checksum. */
+		skb_pull_rcsum(skb, MTK_HDR_LEN);
 
-	dsa_strip_etype_header(skb, MTK_HDR_LEN);
+		dsa_strip_etype_header(skb, MTK_HDR_LEN);
+	}
 
 	/* Get source port information */
 	port = (hdr & MTK_HDR_RECV_SOURCE_PORT_MASK);
@@ -93,11 +98,22 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
+static void mtk_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
+{
+	if (!skb_vlan_tag_present(skb))
+		return dsa_tag_generic_flow_dissect(skb, proto, offset);
+
+	*offset = 0;
+	*proto = ((__be16 *)skb->data)[-1];
+}
+
 static const struct dsa_device_ops mtk_netdev_ops = {
 	.name		= "mtk",
 	.proto		= DSA_TAG_PROTO_MTK,
 	.xmit		= mtk_tag_xmit,
 	.rcv		= mtk_tag_rcv,
+	.flow_dissect	= mtk_tag_flow_dissect,
 	.needed_headroom = MTK_HDR_LEN,
 };
 
-- 
2.38.1

