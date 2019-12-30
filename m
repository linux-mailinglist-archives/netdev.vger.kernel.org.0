Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E8A12D0BF
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfL3Ocn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:32:43 -0500
Received: from fd.dlink.ru ([178.170.168.18]:41168 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbfL3Ocd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:32:33 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id C21351B20B5F; Mon, 30 Dec 2019 17:32:30 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru C21351B20B5F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716350; bh=n2vYVzB39mJzBIUNOizuSzaLB2BB0ciDP2ax+76PUW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=jA3gEr2vjc7p0oigjAAeDuVdtxeVxX75vrLu9Dada3K7I9vZfK6wf5pvxKMFf7HHR
         p3LFKgwXFlB+NnQz6phxK63YzEi5lO27AjBSnemdxjkj3ljxGzxuHMuRiYK1xxMq4C
         eo60/8UgEF8Nim2FOCxr8mbg+QzyAY/1OdZS5o8Q=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 113301B20B5F;
        Mon, 30 Dec 2019 17:31:13 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 113301B20B5F
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id E5D7D1B229D0;
        Mon, 30 Dec 2019 17:31:10 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:10 +0300 (MSK)
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
Subject: [PATCH RFC net-next 05/19] net: dsa: tag_ar9331: add GRO callbacks
Date:   Mon, 30 Dec 2019 17:30:13 +0300
Message-Id: <20191230143028.27313-6-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add GRO callbacks to the AR9331 tagger so GRO layer can now process
such frames.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_ar9331.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index c22c1b515e02..99cc7fd92d8e 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -100,12 +100,89 @@ static void ar9331_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 	*proto = ar9331_tag_encap_proto(skb->data);
 }
 
+static struct sk_buff *ar9331_tag_gro_receive(struct list_head *head,
+					      struct sk_buff *skb)
+{
+	const struct packet_offload *ptype;
+	struct sk_buff *p, *pp = NULL;
+	u32 data_off, data_end;
+	const u8 *data;
+	int flush = 1;
+
+	data_off = skb_gro_offset(skb);
+	data_end = data_off + AR9331_HDR_LEN;
+
+	data = skb_gro_header_fast(skb, data_off);
+	if (skb_gro_header_hard(skb, data_end)) {
+		data = skb_gro_header_slow(skb, data_end, data_off);
+		if (unlikely(!data))
+			goto out;
+	}
+
+	/* Data that is to the left from the current position is already
+	 * pulled to the head
+	 */
+	if (unlikely(!ar9331_tag_sanity_check(skb->data + data_off)))
+		goto out;
+
+	rcu_read_lock();
+
+	ptype = gro_find_receive_by_type(ar9331_tag_encap_proto(data));
+	if (!ptype)
+		goto out_unlock;
+
+	flush = 0;
+
+	list_for_each_entry(p, head, list) {
+		if (!NAPI_GRO_CB(p)->same_flow)
+			continue;
+
+		if (ar9331_tag_source_port(skb->data + data_off) ^
+		    ar9331_tag_source_port(p->data + data_off))
+			NAPI_GRO_CB(p)->same_flow = 0;
+	}
+
+	skb_gro_pull(skb, AR9331_HDR_LEN);
+	skb_gro_postpull_rcsum(skb, data, AR9331_HDR_LEN);
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
+static int ar9331_tag_gro_complete(struct sk_buff *skb, int nhoff)
+{
+	const struct packet_offload *ptype;
+	int err = -ENOENT;
+	__be16 proto;
+
+	proto = ar9331_tag_encap_proto(skb->data + nhoff);
+	nhoff += AR9331_HDR_LEN;
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
 static const struct dsa_device_ops ar9331_netdev_ops = {
 	.name		= "ar9331",
 	.proto		= DSA_TAG_PROTO_AR9331,
 	.xmit		= ar9331_tag_xmit,
 	.rcv		= ar9331_tag_rcv,
 	.flow_dissect	= ar9331_tag_flow_dissect,
+	.gro_receive	= ar9331_tag_gro_receive,
+	.gro_complete	= ar9331_tag_gro_complete,
 	.overhead	= AR9331_HDR_LEN,
 };
 
-- 
2.24.1

