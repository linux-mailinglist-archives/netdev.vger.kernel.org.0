Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5635C12D0BB
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfL3Ocn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:32:43 -0500
Received: from fd.dlink.ru ([178.170.168.18]:41150 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfL3Occ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:32:32 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id B21011B21931; Mon, 30 Dec 2019 17:32:29 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru B21011B21931
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716349; bh=4XferhwJ+noZjvLLF7PDu0hDkxQ/WpPucldtTtVh1Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=PykzXFtx1t2MEXrs0tIMdbOKfDad5VAkVNmSEhNoU7hTMF2ariiSNkR51nk8XGWBb
         0ZeUAY4mo7vwrsDQCGm883y4QMaTB0NYT2zZobEU/qz+SzStGtVlHXAl7n50YuPPAp
         JfGOKTdfb6MHZWruDWhCSvySdsn8LKsTWIu5FKc8=
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id C096F1B20954;
        Mon, 30 Dec 2019 17:31:41 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru C096F1B20954
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id D81481B229D0;
        Mon, 30 Dec 2019 17:31:39 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:39 +0300 (MSK)
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
Subject: [PATCH RFC net-next 19/19] net: dsa: tag_qca: add GRO callbacks
Date:   Mon, 30 Dec 2019 17:30:27 +0300
Message-Id: <20191230143028.27313-20-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...so that frames tagged with this CPU tag type can be correctly
processed by the GRO layer.
Misc: fix qca_netdev_ops structure identation.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_qca.c | 88 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 6 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index bee2788e034d..d0cb2299cbe9 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -106,13 +106,89 @@ static void qca_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 	*proto = qca_tag_encap_proto(skb->data);
 }
 
+static struct sk_buff *qca_tag_gro_receive(struct list_head *head,
+					   struct sk_buff *skb)
+{
+	const struct packet_offload *ptype;
+	struct sk_buff *p, *pp = NULL;
+	u32 data_off, data_end;
+	const u8 *data;
+	int flush = 1;
+
+	data_off = skb_gro_offset(skb);
+	data_end = data_off + QCA_HDR_LEN;
+
+	data = skb_gro_header_fast(skb, data_off);
+	if (skb_gro_header_hard(skb, data_end)) {
+		data = skb_gro_header_slow(skb, data_end, data_off);
+		if (unlikely(!data))
+			goto out;
+	}
+
+	/* Data that is to the left to the current position is already
+	 * pulled to the head
+	 */
+	if (unlikely(!qca_tag_sanity_check(skb->data + data_off)))
+		goto out;
+
+	rcu_read_lock();
+
+	ptype = gro_find_receive_by_type(qca_tag_encap_proto(data));
+	if (!ptype)
+		goto out_unlock;
+
+	flush = 0;
+
+	list_for_each_entry(p, head, list) {
+		if (!NAPI_GRO_CB(p)->same_flow)
+			continue;
+
+		if (qca_tag_source_port(skb->data + data_off) ^
+		    qca_tag_source_port(p->data + data_off))
+			NAPI_GRO_CB(p)->same_flow = 0;
+	}
+
+	skb_gro_pull(skb, QCA_HDR_LEN);
+	skb_gro_postpull_rcsum(skb, data, QCA_HDR_LEN);
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
+static int qca_tag_gro_complete(struct sk_buff *skb, int nhoff)
+{
+	const struct packet_offload *ptype;
+	int err = -ENOENT;
+	__be16 proto;
+
+	proto = qca_tag_encap_proto(skb->data + nhoff);
+
+	rcu_read_lock();
+
+	ptype = gro_find_complete_by_type(proto);
+	if (ptype)
+		err = ptype->callbacks.gro_complete(skb, nhoff + QCA_HDR_LEN);
+
+	rcu_read_unlock();
+
+	return err;
+}
+
 static const struct dsa_device_ops qca_netdev_ops = {
-	.name	= "qca",
-	.proto	= DSA_TAG_PROTO_QCA,
-	.xmit	= qca_tag_xmit,
-	.rcv	= qca_tag_rcv,
-	.flow_dissect = qca_tag_flow_dissect,
-	.overhead = QCA_HDR_LEN,
+	.name		= "qca",
+	.proto		= DSA_TAG_PROTO_QCA,
+	.xmit		= qca_tag_xmit,
+	.rcv		= qca_tag_rcv,
+	.flow_dissect	= qca_tag_flow_dissect,
+	.gro_receive	= qca_tag_gro_receive,
+	.gro_complete	= qca_tag_gro_complete,
+	.overhead	= QCA_HDR_LEN,
 };
 
 MODULE_LICENSE("GPL");
-- 
2.24.1

