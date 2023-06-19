Return-Path: <netdev+bounces-11925-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E0B7354A8
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5237280FBB
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C9AC8E8;
	Mon, 19 Jun 2023 10:57:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0242CC8E3;
	Mon, 19 Jun 2023 10:57:46 +0000 (UTC)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD6A173A;
	Mon, 19 Jun 2023 03:57:44 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VlVN0ua_1687172259;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VlVN0ua_1687172259)
          by smtp.aliyun-inc.com;
          Mon, 19 Jun 2023 18:57:40 +0800
From: Heng Qi <hengqi@linux.alibaba.com>
To: netdev@vger.kernel.org,
	bpf@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net-next 1/4] virtio-net: a helper for probing the pseudo-header checksum
Date: Mon, 19 Jun 2023 18:57:35 +0800
Message-Id: <20230619105738.117733-2-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230619105738.117733-1-hengqi@linux.alibaba.com>
References: <20230619105738.117733-1-hengqi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This helper parses UDP/TCP and calculates the pseudo-header checksum
for virtio-net.

virtio-net currently does not support insertion/deletion of VLANs nor
SCTP checksum offloading.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 95 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5a7f7a76b920..36cae78f6311 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1568,6 +1568,101 @@ static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
 	skb_set_hash(skb, __le32_to_cpu(hdr_hash->hash_value), rss_hash_type);
 }
 
+static int virtnet_flow_dissect_udp_tcp(struct virtnet_info *vi, struct sk_buff *skb)
+{
+	struct net_device *dev = vi->dev;
+	struct flow_keys_basic keys;
+	struct udphdr *uh;
+	struct tcphdr *th;
+	int len, offset;
+
+	/* The flow dissector needs this information. */
+	skb->dev = dev;
+	skb_reset_mac_header(skb);
+	skb->protocol = dev_parse_header_protocol(skb);
+	/* virtio-net does not need to resolve VLAN. */
+	skb_set_network_header(skb, ETH_HLEN);
+	if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
+					      NULL, 0, 0, 0, 0))
+		return -EINVAL;
+
+	/* 1. Pseudo-header checksum calculation requires:
+	 *    (1) saddr/daddr (2) IP_PROTO (3) length of transport payload
+	 * 2. We don't parse SCTP because virtio-net currently doesn't
+	 *    support CRC offloading for SCTP.
+	 */
+	if (keys.basic.n_proto == htons(ETH_P_IP)) {
+		struct iphdr *iph;
+
+		/* Flow dissector has verified that there is an IP header. */
+		iph = ip_hdr(skb);
+		if (iph->version != 4 || !pskb_may_pull(skb, iph->ihl * 4))
+			return -EINVAL;
+
+		skb->transport_header = skb->mac_header + keys.control.thoff;
+		offset = skb_transport_offset(skb);
+		len = skb->len - offset;
+		if (keys.basic.ip_proto == IPPROTO_UDP) {
+			if (!pskb_may_pull(skb, offset + sizeof(struct udphdr)))
+				return -EINVAL;
+
+			uh = udp_hdr(skb);
+			skb->csum_offset = offsetof(struct udphdr, check);
+			/* Although uh->len is already the 3rd parameter for the calculation
+			 * of the pseudo-header checksum, we have already calculated the
+			 * length of the transport layer, so use 'len' here directly.
+			 */
+			uh->check = ~csum_tcpudp_magic(iph->saddr, iph->daddr, len,
+					IPPROTO_UDP, 0);
+		} else if (keys.basic.ip_proto == IPPROTO_TCP) {
+			if (!pskb_may_pull(skb, offset + sizeof(struct tcphdr)))
+				return -EINVAL;
+
+			th = tcp_hdr(skb);
+			skb->csum_offset = offsetof(struct tcphdr, check);
+			th->check = ~csum_tcpudp_magic(iph->saddr, iph->daddr, len,
+					IPPROTO_TCP, 0);
+		} /* virtio-net doesn't support checksums for SCTP hw offloading.*/
+	} else if (keys.basic.n_proto == htons(ETH_P_IPV6)) {
+		struct ipv6hdr *ip6h;
+
+		ip6h = ipv6_hdr(skb);
+		if (ip6h->version != 6)
+			return -EINVAL;
+
+		/* We have skipped the possible extension headers for IPv6.
+		 * If there is a Routing Header, the tx's check value is calculated by
+		 * final_dst, and that value is the rx's daddr.
+		 */
+		skb->transport_header = skb->mac_header + keys.control.thoff;
+		offset = skb_transport_offset(skb);
+		len = skb->len - offset;
+		if (keys.basic.ip_proto == IPPROTO_UDP) {
+			if (!pskb_may_pull(skb, offset + sizeof(struct udphdr)))
+				return -EINVAL;
+
+			uh = udp_hdr(skb);
+			skb->csum_offset = offsetof(struct udphdr, check);
+			uh->check = ~csum_ipv6_magic((const struct in6_addr *)&ip6h->saddr,
+					(const struct in6_addr *)&ip6h->daddr,
+					len, IPPROTO_UDP, 0);
+		} else if (keys.basic.ip_proto == IPPROTO_TCP) {
+			if (!pskb_may_pull(skb, offset + sizeof(struct tcphdr)))
+				return -EINVAL;
+
+			th = tcp_hdr(skb);
+			skb->csum_offset = offsetof(struct tcphdr, check);
+			th->check = ~csum_ipv6_magic((const struct in6_addr *)&ip6h->saddr,
+					(const struct in6_addr *)&ip6h->daddr,
+					len, IPPROTO_TCP, 0);
+		}
+	}
+
+	skb->csum_start = skb->transport_header;
+
+	return 0;
+}
+
 static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 			void *buf, unsigned int len, void **ctx,
 			unsigned int *xdp_xmit,
-- 
2.19.1.6.gb485710b


