Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E9512D0CB
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfL3Odc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:33:32 -0500
Received: from mail.dlink.ru ([178.170.168.18]:42232 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727576AbfL3Oda (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:33:30 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 05BD91B20B7B; Mon, 30 Dec 2019 17:33:26 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 05BD91B20B7B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716407; bh=Erjvba4dIKrPISREjV3SM+2wcBTCz6oIK+5iwW6Xun4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=W9DiqZJ515jMwhKOig4girjPYcE4uMTlFxCaeERSRbste6vzrQDxtUSlDa8PpmCBh
         clMjplrv8rpBd4MatbcgS7tVbCQ5seWlVj+vfyXWG/PTL+efemYwc2uau4PMh+OSfp
         Oeu6BJjraKKEtpwG5m+q97Nr9IwiwbgYACDxQFP8=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 6FBF51B2180E;
        Mon, 30 Dec 2019 17:31:21 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 6FBF51B2180E
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 266F41B229D1;
        Mon, 30 Dec 2019 17:31:19 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:19 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 09/19] net: dsa: tag_gswip: split out common tag accessors
Date:   Mon, 30 Dec 2019 17:30:17 +0300
Message-Id: <20191230143028.27313-10-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...to reuse them in GRO callbacks.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_gswip.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index d37289540ef3..e7b36de27fd8 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -55,6 +55,16 @@
 /* Byte 7 */
 #define GSWIP_RX_SPPID(byte_7)		FIELD_GET(GENMASK(6, 4), byte_7)
 
+static inline int gswip_tag_source_port(const u8 *data)
+{
+	return GSWIP_RX_SPPID(*(data - ETH_HLEN + 7));
+}
+
+static inline __be16 gswip_tag_encap_proto(const u8 *data)
+{
+	return *(__be16 *)(data + 6);
+}
+
 static struct sk_buff *gswip_tag_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
@@ -85,7 +95,7 @@ static struct sk_buff *gswip_tag_rcv(struct sk_buff *skb,
 		return NULL;
 
 	/* Get source port information */
-	port = GSWIP_RX_SPPID(*(skb->data - ETH_HLEN + 7));
+	port = gswip_tag_source_port(skb->data);
 
 	skb->dev = dsa_master_find_slave(dev, 0, port);
 	if (!skb->dev)
@@ -101,7 +111,7 @@ static void gswip_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 				   int *offset)
 {
 	*offset = GSWIP_RX_HEADER_LEN;
-	*proto = *(__be16 *)(skb->data + 6);
+	*proto = gswip_tag_encap_proto(skb->data);
 }
 
 static const struct dsa_device_ops gswip_netdev_ops = {
-- 
2.24.1

