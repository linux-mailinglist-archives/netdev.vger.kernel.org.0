Return-Path: <netdev+bounces-11926-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F3B7354B8
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2187A1C209DD
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 618A1D2FA;
	Mon, 19 Jun 2023 10:57:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4790ED2F1;
	Mon, 19 Jun 2023 10:57:47 +0000 (UTC)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570531BFE;
	Mon, 19 Jun 2023 03:57:45 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VlVOwN7_1687172261;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VlVOwN7_1687172261)
          by smtp.aliyun-inc.com;
          Mon, 19 Jun 2023 18:57:42 +0800
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
Subject: [PATCH net-next 2/4] virtio-net: reprobe csum related fields for skb passed by XDP
Date: Mon, 19 Jun 2023 18:57:36 +0800
Message-Id: <20230619105738.117733-3-hengqi@linux.alibaba.com>
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

Currently, the VIRTIO_NET_F_GUEST_CSUM (corresponds to NETIF_F_RXCSUM
for netdev) feature of the virtio-net driver conflicts with the loading
of XDP, which is caused by the problem described in [1][2], that is,
XDP may cause errors in partial csumed-related fields which can lead
to packet dropping.

In addition, when communicating between vm and vm on the same host, the
receiving side vm will receive packets marked as
VIRTIO_NET_HDR_F_NEEDS_CSUM, but after these packets are processed by
XDP, the VIRTIO_NET_HDR_F_NEEDS_CSUM and skb CHECKSUM_PARTIAL flags will
be cleared, causing the packet dropping.

This patch introduces a helper function, which will try to solve the
above problems in the subsequent patch.

[1] commit 18ba58e1c234 ("virtio-net: fail XDP set if guest csum is negotiated")
[2] commit e59ff2c49ae1 ("virtio-net: disable guest csum during XDP set")

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 36cae78f6311..07b4801d689c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1663,6 +1663,44 @@ static int virtnet_flow_dissect_udp_tcp(struct virtnet_info *vi, struct sk_buff
 	return 0;
 }
 
+static int virtnet_set_csum_after_xdp(struct virtnet_info *vi,
+				      struct sk_buff *skb,
+				      __u8 flags)
+{
+	int err;
+
+	/* When XDP program is loaded, for example, the vm-vm scenario
+	 * on the same host, packets marked as VIRTIO_NET_HDR_F_NEEDS_CSUM
+	 * will travel. Although these packets are safe from the point of
+	 * view of the vm, to avoid modification by XDP and successful
+	 * forwarding in the upper layer, we re-probe the necessary checksum
+	 * related information: skb->csum_{start, offset}, pseudo-header csum.
+	 *
+	 * This benefits us:
+	 * 1. XDP can be loaded when there's _F_GUEST_CSUM.
+	 * 2. The device verifies the checksum of packets , especially
+	 *    benefiting for large packets.
+	 * 3. In the same-host vm-vm scenario, packets marked as
+	 *    VIRTIO_NET_HDR_F_NEEDS_CSUM are no longer dropped after being
+	 *    processed by XDP.
+	 */
+	if (flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
+		err = virtnet_flow_dissect_udp_tcp(vi, skb);
+		if (err < 0)
+			return -EINVAL;
+
+		skb->ip_summed = CHECKSUM_PARTIAL;
+	} else if (flags && VIRTIO_NET_HDR_F_DATA_VALID) {
+		/* We want to benefit from this: XDP guarantees that packets marked
+		 * as VIRTIO_NET_HDR_F_DATA_VALID still have correct csum after they
+		 * are processed.
+		 */
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	}
+
+	return 0;
+}
+
 static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 			void *buf, unsigned int len, void **ctx,
 			unsigned int *xdp_xmit,
-- 
2.19.1.6.gb485710b


