Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC912D0CC
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfL3Oda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:33:30 -0500
Received: from mail.dlink.ru ([178.170.168.18]:42220 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727532AbfL3Od3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:33:29 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id A2EC81B219A8; Mon, 30 Dec 2019 17:33:26 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru A2EC81B219A8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716406; bh=q7IufE7HIiHvycVJgjMYvuW6fyhlbqwjI/W5rJkX8G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=HmP4J2AXWwflkQBqL9lkLwAxd51UAeaYBqYNSxsH051hQOWJcgVqveKItTvnJ3oaq
         2N1ctDN2jvAtQlLnRJKjcuI+KrO9KR0504lC2IJa9dLO8EoP/JF3WpCqFswJgOI58x
         Cw5umkRIQ5F2hCYLJkKfdiWdatn2cadohbeXCe4Y=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 5AEF91B20B7B;
        Mon, 30 Dec 2019 17:31:23 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 5AEF91B20B7B
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 3BD431B229CB;
        Mon, 30 Dec 2019 17:31:21 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:21 +0300 (MSK)
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
Subject: [PATCH RFC net-next 10/19] net: dsa: tag_gswip: add GRO callbacks
Date:   Mon, 30 Dec 2019 17:30:18 +0300
Message-Id: <20191230143028.27313-11-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...so that GRO layer can now correctly process GSWIP-tagged frames.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_gswip.c | 74 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index e7b36de27fd8..56e754bd434a 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -114,12 +114,86 @@ static void gswip_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 	*proto = gswip_tag_encap_proto(skb->data);
 }
 
+static struct sk_buff *gswip_tag_gro_receive(struct list_head *head,
+					     struct sk_buff *skb)
+{
+	const struct packet_offload *ptype;
+	struct sk_buff *p, *pp = NULL;
+	u32 data_off, data_end;
+	const u8 *data;
+	int flush = 1;
+
+	data_off = skb_gro_offset(skb);
+	data_end = data_off + GSWIP_RX_HEADER_LEN;
+
+	data = skb_gro_header_fast(skb, data_off);
+	if (skb_gro_header_hard(skb, data_end)) {
+		data = skb_gro_header_slow(skb, data_end, data_off);
+		if (unlikely(!data))
+			goto out;
+	}
+
+	rcu_read_lock();
+
+	ptype = gro_find_receive_by_type(gswip_tag_encap_proto(data));
+	if (!ptype)
+		goto out_unlock;
+
+	flush = 0;
+
+	list_for_each_entry(p, head, list) {
+		if (!NAPI_GRO_CB(p)->same_flow)
+			continue;
+
+		/* Data that is to the left to the current position is already
+		 * pulled to the head
+		 */
+		if (gswip_tag_source_port(skb->data + data_off) ^
+		    gswip_tag_source_port(p->data + data_off))
+			NAPI_GRO_CB(p)->same_flow = 0;
+	}
+
+	skb_gro_pull(skb, GSWIP_RX_HEADER_LEN);
+	skb_gro_postpull_rcsum(skb, data, GSWIP_RX_HEADER_LEN);
+
+	pp = call_gro_receive(ptype->callbacks.gro_receive, head, skb);
+
+out_unlock:
+	rcu_read_unlock();
+out:
+	skb_gro_flush_final(skb, pp, flush);
+
+	return pp;
+}
+
+static int gswip_tag_gro_complete(struct sk_buff *skb, int nhoff)
+{
+	const struct packet_offload *ptype;
+	int err = -ENOENT;
+	__be16 proto;
+
+	proto = gswip_tag_encap_proto(skb->data + nhoff);
+	nhoff += GSWIP_RX_HEADER_LEN;
+
+	rcu_read_lock();
+
+	ptype = gro_find_complete_by_type(proto);
+	if (ptype)
+		err = ptype->callbacks.gro_complete(skb, nhoff);
+
+	rcu_read_unlock();
+
+	return err;
+}
+
 static const struct dsa_device_ops gswip_netdev_ops = {
 	.name		= "gswip",
 	.proto		= DSA_TAG_PROTO_GSWIP,
 	.xmit		= gswip_tag_xmit,
 	.rcv		= gswip_tag_rcv,
 	.flow_dissect	= gswip_tag_flow_dissect,
+	.gro_receive	= gswip_tag_gro_receive,
+	.gro_complete	= gswip_tag_gro_complete,
 	.overhead	= GSWIP_RX_HEADER_LEN,
 };
 
-- 
2.24.1

