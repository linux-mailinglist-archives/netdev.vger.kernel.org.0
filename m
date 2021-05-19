Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB8C388A0C
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 11:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344218AbhESJBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 05:01:42 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:43277 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237641AbhESJBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 05:01:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0UZO.g.-_1621414819;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UZO.g.-_1621414819)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 19 May 2021 17:00:19 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next] virtio-net: Refactor the code related to page_to_skb()
Date:   Wed, 19 May 2021 17:00:19 +0800
Message-Id: <20210519090019.1489-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to long-term development, the current code structure of
page_to_skb() and the semantic expression of variables are rather
chaotic, so it is necessary to reconstruct this piece of logic.

The code has been tested with the following test code.
Call test_merge and test_big to test "merge" and "big" modes
respectively.

================================= test.sh ========================
function test()
{
    flag=$1
    max=$2
    inc=$3
    if [ "x$max" == "x" ]
    then
        max=4096
    fi
    echo $max

    for s in $(seq 64 $inc $max)
    do
        echo >> log
        echo $flag :UDP_STREAM $s >> log
        netperf -H 192.168.122.202 -l 5 -t UDP_STREAM -- -m $s >> log
        echo $flag :UDP_STREAM $s $?
    done

    for s in $(seq 64 $inc $max)
    do
        echo >> log
        echo $flag :TCP_STREAM $s >> log
        netperf -H 192.168.122.202 -l 5 -t TCP_STREAM -- -m $s >> log
        echo $flag :TCP_STREAM $s $?
    done
}

function test_merge()
{
    XDP='no-xdp'

    ssh root@192.168.122.202 ip link set dev eth0 xdp off
    test $XDP

    XDP='xdp-pass'

    ssh root@192.168.122.202 ip link set dev eth0 xdp off
    ssh root@192.168.122.202 ip link set dev eth0 xdp object xdp.o sec xdp
    test $XDP

    XDP='xdp-meta'

    ssh root@192.168.122.202 ip link set dev eth0 xdp off
    ssh root@192.168.122.202 ip link set dev eth0 xdp object xdp_meta.o sec xdp_mark
    test $XDP
}

function test_big()
{
    # set host net dev mtu to 60000
    test "big" 5000
    test "big" 60000 10
}

ssh root@192.168.122.202 ./netserver
echo '' > log

test_merge # or test_big
================================== xdp.c =================================

SEC("xdp")
int _xdp(struct xdp_md *xdp)
{
        return XDP_PASS;
}

char _license[] SEC("license") = "GPL";

================================== xdp_meta.c =================================

static long (*bpf_xdp_adjust_meta)(struct xdp_md *xdp_md, int delta) = (void *) 54;

struct meta_info {
        __u32 mark;
} __attribute__((aligned(4)));

SEC("xdp_mark")
int _xdp_mark(struct xdp_md *ctx)
{
        struct meta_info *meta;
        void *data, *data_end;
        int ret;

        ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(*meta));
        if (ret < 0)
                return XDP_ABORTED;

        data = (void *)(unsigned long)ctx->data;

        /* Check data_meta have room for meta_info struct */
        meta = (void *)(unsigned long)ctx->data_meta;
        if ((void *)(meta + 1) > data)
                return XDP_ABORTED;

        meta->mark = 42;

        return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
===================================================================

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 309 +++++++++++++++++++++++----------------
 1 file changed, 185 insertions(+), 124 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7fda2ae4c40f..a117b3496653 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -249,6 +249,35 @@ struct padded_vnet_hdr {
 	char padding[4];
 };
 
+struct virtnet_page_info {
+	struct virtnet_info *vi;
+	struct receive_queue *rq;
+
+	/* this may be the head_page, buf not starts with this page */
+	struct page *page;
+
+	/* the allcated buf. this may point to the headroom */
+	char *buf;
+
+	/* the size of the buf */
+	unsigned int buf_size;
+
+	/* OUT. the offset of the remaining data in the page */
+	unsigned int offset;
+
+	char *virtnet_hdr;
+
+	/* packet data. generally point to eth header */
+	char *packet;
+
+	/* IN. packet len without virtnet hdr
+	 * OUT. the size of the remaining data
+	 */
+	unsigned int len;
+
+	unsigned int metasize;
+};
+
 static bool is_xdp_frame(void *ptr)
 {
 	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
@@ -357,6 +386,89 @@ static void skb_xmit_done(struct virtqueue *vq)
 		netif_wake_subqueue(vi->dev, vq2txq(vq));
 }
 
+static struct sk_buff *virtnet_page_to_skb(struct virtnet_page_info *pinfo)
+{
+	int shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	struct virtio_net_hdr_mrg_rxbuf *hdr;
+	struct sk_buff *skb;
+	int tailroom, copy;
+
+	/* In the case of "big", tailroom may be negative, because len can be
+	 * greater than PAGE_SIZE.
+	 */
+	tailroom = pinfo->buf + pinfo->buf_size - (pinfo->packet + pinfo->len);
+
+	if (!NET_IP_ALIGN && tailroom >= shinfo_size) {
+		skb = build_skb(pinfo->buf, pinfo->buf_size);
+		if (unlikely(!skb))
+			return NULL;
+
+		skb_reserve(skb, pinfo->packet - pinfo->buf);
+		skb_put(skb, pinfo->len);
+
+		/* mark. page has been used. */
+		pinfo->page = NULL;
+	} else {
+		/* copy small data so we can reuse these pages for small data
+		 *
+		 * GOOD_COPY_LEN is used to save network headers, such as eth
+		 * header, ip header, tcp header. If you want to save metadata
+		 * information, we should apply for a larger space. Prevent the
+		 * network header cannot fit in the linear space.
+		 */
+		skb = napi_alloc_skb(&pinfo->rq->napi,
+				     pinfo->metasize + GOOD_COPY_LEN);
+		if (unlikely(!skb))
+			return NULL;
+
+		/* Copy all frame if it fits skb->head, otherwise
+		 * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
+		 */
+		if (pinfo->len <= GOOD_COPY_LEN)
+			copy = pinfo->len;
+		else
+			copy = ETH_HLEN;
+
+		skb_put_data(skb, pinfo->packet - pinfo->metasize,
+			     copy + pinfo->metasize);
+		__skb_pull(skb, pinfo->metasize);
+		pinfo->len -= copy;
+		pinfo->offset = pinfo->packet + copy -
+				(char *)page_address(pinfo->page);
+	}
+
+	if (pinfo->metasize)
+		skb_metadata_set(skb, pinfo->metasize);
+
+	if (pinfo->virtnet_hdr) {
+		hdr = skb_vnet_hdr(skb);
+		memcpy(hdr, pinfo->virtnet_hdr, pinfo->vi->hdr_len);
+	}
+
+	return skb;
+}
+
+static struct sk_buff *virtnet_merge_page_to_skb(struct virtnet_page_info *pinfo)
+{
+	struct sk_buff *skb;
+
+	skb = virtnet_page_to_skb(pinfo);
+	if (unlikely(!skb))
+		return NULL;
+
+	/* page has been used by build_skb() */
+	if (!pinfo->page)
+		return skb;
+
+	if (pinfo->len)
+		skb_add_rx_frag(skb, 0, pinfo->page, pinfo->offset, pinfo->len,
+				pinfo->buf_size);
+	else
+		put_page(pinfo->page);
+
+	return skb;
+}
+
 #define MRG_CTX_HEADER_SHIFT 22
 static void *mergeable_len_to_ctx(unsigned int truesize,
 				  unsigned int headroom)
@@ -375,86 +487,30 @@ static unsigned int mergeable_ctx_to_truesize(void *mrg_ctx)
 }
 
 /* Called from bottom half context */
-static struct sk_buff *page_to_skb(struct virtnet_info *vi,
-				   struct receive_queue *rq,
-				   struct page *page, unsigned int offset,
-				   unsigned int len, unsigned int truesize,
-				   bool hdr_valid, unsigned int metasize,
-				   unsigned int headroom)
+static struct sk_buff *virtnet_big_page_to_skb(struct virtnet_page_info *pinfo)
 {
+	unsigned int len, offset, truesize;
+	struct receive_queue *rq;
 	struct sk_buff *skb;
-	struct virtio_net_hdr_mrg_rxbuf *hdr;
-	unsigned int copy, hdr_len, hdr_padded_len;
-	struct page *page_to_free = NULL;
-	int tailroom, shinfo_size;
-	char *p, *hdr_p, *buf;
+	struct page *page;
 
-	p = page_address(page) + offset;
-	hdr_p = p;
+	/* save next page */
+	page = (struct page *)pinfo->page->private;
 
-	hdr_len = vi->hdr_len;
-	if (vi->mergeable_rx_bufs)
-		hdr_padded_len = sizeof(*hdr);
-	else
-		hdr_padded_len = sizeof(struct padded_vnet_hdr);
-
-	/* If headroom is not 0, there is an offset between the beginning of the
-	 * data and the allocated space, otherwise the data and the allocated
-	 * space are aligned.
-	 */
-	if (headroom) {
-		/* Buffers with headroom use PAGE_SIZE as alloc size,
-		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
-		 */
-		truesize = PAGE_SIZE;
-		tailroom = truesize - len - offset;
-		buf = page_address(page);
-	} else {
-		tailroom = truesize - len;
-		buf = p;
-	}
-
-	len -= hdr_len;
-	offset += hdr_padded_len;
-	p += hdr_padded_len;
-
-	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-
-	/* copy small packet so we can reuse these pages */
-	if (!NET_IP_ALIGN && len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
-		skb = build_skb(buf, truesize);
-		if (unlikely(!skb))
-			return NULL;
-
-		skb_reserve(skb, p - buf);
-		skb_put(skb, len);
-		goto ok;
-	}
-
-	/* copy small packet so we can reuse these pages for small data */
-	skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
+	skb = virtnet_page_to_skb(pinfo);
 	if (unlikely(!skb))
 		return NULL;
 
-	/* Copy all frame if it fits skb->head, otherwise
-	 * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
-	 */
-	if (len <= skb_tailroom(skb))
-		copy = len;
-	else
-		copy = ETH_HLEN + metasize;
-	skb_put_data(skb, p, copy);
+	rq = pinfo->rq;
 
-	len -= copy;
-	offset += copy;
+	/* page has been used by build_skb() */
+	if (!pinfo->page)
+		goto end;
 
-	if (vi->mergeable_rx_bufs) {
-		if (len)
-			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
-		else
-			page_to_free = page;
-		goto ok;
-	}
+	page     = pinfo->page;
+	len      = pinfo->len;
+	offset   = pinfo->offset;
+	truesize = pinfo->buf_size;
 
 	/*
 	 * Verify that we can indeed put this data into a skb.
@@ -477,23 +533,10 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 		offset = 0;
 	}
 
+end:
 	if (page)
 		give_pages(rq, page);
 
-ok:
-	/* hdr_valid means no XDP, so we can copy the vnet header */
-	if (hdr_valid) {
-		hdr = skb_vnet_hdr(skb);
-		memcpy(hdr, hdr_p, hdr_len);
-	}
-	if (page_to_free)
-		put_page(page_to_free);
-
-	if (metasize) {
-		__skb_pull(skb, metasize);
-		skb_metadata_set(skb, metasize);
-	}
-
 	return skb;
 }
 
@@ -654,17 +697,17 @@ static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
  */
 static struct page *xdp_linearize_page(struct receive_queue *rq,
 				       u16 *num_buf,
-				       struct page *p,
-				       int offset,
+				       void *buf,
 				       int page_off,
 				       unsigned int *len)
 {
 	struct page *page = alloc_page(GFP_ATOMIC);
+	struct page *p;
 
 	if (!page)
 		return NULL;
 
-	memcpy(page_address(page) + page_off, page_address(p) + offset, *len);
+	memcpy(page_address(page) + page_off, buf, *len);
 	page_off += *len;
 
 	while (--*num_buf) {
@@ -739,18 +782,18 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			goto err_xdp;
 
 		if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
-			int offset = buf - page_address(page) + header_offset;
 			unsigned int tlen = len + vi->hdr_len;
 			u16 num_buf = 1;
 
+			buf += header_offset;
+
 			xdp_headroom = virtnet_get_headroom(vi);
 			header_offset = VIRTNET_RX_PAD + xdp_headroom;
 			headroom = vi->hdr_len + header_offset;
 			buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
 				 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-			xdp_page = xdp_linearize_page(rq, &num_buf, page,
-						      offset, header_offset,
-						      &tlen);
+			xdp_page = xdp_linearize_page(rq, &num_buf, buf,
+						      header_offset, &tlen);
 			if (!xdp_page)
 				goto err_xdp;
 
@@ -842,9 +885,21 @@ static struct sk_buff *receive_big(struct net_device *dev,
 				   unsigned int len,
 				   struct virtnet_rq_stats *stats)
 {
+	struct virtnet_page_info pinfo;
 	struct page *page = buf;
-	struct sk_buff *skb =
-		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0, 0);
+	struct sk_buff *skb;
+
+	pinfo.rq          = rq;
+	pinfo.vi          = vi;
+	pinfo.page        = page;
+	pinfo.buf         = page_address(page);
+	pinfo.buf_size    = PAGE_SIZE;
+	pinfo.virtnet_hdr = pinfo.buf;
+	pinfo.packet      = pinfo.virtnet_hdr + sizeof(struct padded_vnet_hdr);
+	pinfo.len         = len - vi->hdr_len;
+	pinfo.metasize    = 0;
+
+	skb = virtnet_big_page_to_skb(&pinfo);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -870,12 +925,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
 	u16 num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
 	struct page *page = virt_to_head_page(buf);
-	int offset = buf - page_address(page);
 	struct sk_buff *head_skb, *curr_skb;
+	struct virtnet_page_info pinfo;
 	struct bpf_prog *xdp_prog;
 	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
-	unsigned int metasize = 0;
 	unsigned int frame_sz;
 	int err;
 
@@ -887,8 +941,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	if (xdp_prog) {
 		struct xdp_frame *xdpf;
 		struct page *xdp_page;
+		void *hard_start;
 		struct xdp_buff xdp;
-		void *data;
 		u32 act;
 
 		/* Transient failure which in theory could occur if
@@ -912,54 +966,47 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		if (unlikely(num_buf > 1 ||
 			     headroom < virtnet_get_headroom(vi))) {
 			/* linearize data for XDP */
-			xdp_page = xdp_linearize_page(rq, &num_buf,
-						      page, offset,
+			xdp_page = xdp_linearize_page(rq, &num_buf, buf,
 						      VIRTIO_XDP_HEADROOM,
 						      &len);
 			frame_sz = PAGE_SIZE;
 
 			if (!xdp_page)
 				goto err_xdp;
-			offset = VIRTIO_XDP_HEADROOM;
+
+			hard_start = page_address(xdp_page) + vi->hdr_len;
 		} else {
 			xdp_page = page;
+			hard_start = buf + vi->hdr_len - VIRTIO_XDP_HEADROOM;
 		}
 
 		/* Allow consuming headroom but reserve enough space to push
 		 * the descriptor on if we get an XDP_TX return code.
 		 */
-		data = page_address(xdp_page) + offset;
 		xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_rxq);
-		xdp_prepare_buff(&xdp, data - VIRTIO_XDP_HEADROOM + vi->hdr_len,
-				 VIRTIO_XDP_HEADROOM, len - vi->hdr_len, true);
+		xdp_prepare_buff(&xdp, hard_start, VIRTIO_XDP_HEADROOM,
+				 len - vi->hdr_len, true);
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
 
 		switch (act) {
 		case XDP_PASS:
-			metasize = xdp.data - xdp.data_meta;
-
-			/* recalculate offset to account for any header
-			 * adjustments and minus the metasize to copy the
-			 * metadata in page_to_skb(). Note other cases do not
-			 * build an skb and avoid using offset
-			 */
-			offset = xdp.data - page_address(xdp_page) -
-				 vi->hdr_len - metasize;
-
-			/* recalculate len if xdp.data, xdp.data_end or
-			 * xdp.data_meta were adjusted
-			 */
-			len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
+			pinfo.rq          = rq;
+			pinfo.vi          = vi;
+			pinfo.page        = xdp_page;
+			pinfo.buf         = xdp.data_hard_start - vi->hdr_len;
+			pinfo.buf_size    = PAGE_SIZE;
+			pinfo.virtnet_hdr = NULL;
+			pinfo.packet      = xdp.data;
+			pinfo.len         = xdp.data_end - xdp.data;
+			pinfo.metasize    = xdp.data - xdp.data_meta;
 			/* We can only create skb based on xdp_page. */
 			if (unlikely(xdp_page != page)) {
 				rcu_read_unlock();
 				put_page(page);
-				head_skb = page_to_skb(vi, rq, xdp_page, offset,
-						       len, PAGE_SIZE, false,
-						       metasize, headroom);
-				return head_skb;
+
+				return virtnet_merge_page_to_skb(&pinfo);
 			}
 			break;
 		case XDP_TX:
@@ -1005,8 +1052,22 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 				__free_pages(xdp_page, 0);
 			goto err_xdp;
 		}
+		rcu_read_unlock();
+
+		/* pinfo has been filled inside XDP_PASS */
+	} else {
+		rcu_read_unlock();
+
+		pinfo.rq          = rq;
+		pinfo.vi          = vi;
+		pinfo.page        = page;
+		pinfo.buf         = buf - headroom;
+		pinfo.buf_size    = headroom ? PAGE_SIZE : truesize;
+		pinfo.virtnet_hdr = buf;
+		pinfo.packet      = buf + sizeof(*hdr);
+		pinfo.len         = len - sizeof(*hdr);
+		pinfo.metasize    = 0;
 	}
-	rcu_read_unlock();
 
 	if (unlikely(len > truesize)) {
 		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
@@ -1015,14 +1076,14 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
-			       metasize, headroom);
+	head_skb = virtnet_merge_page_to_skb(&pinfo);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
 		goto err_skb;
 	while (--num_buf) {
 		int num_skb_frags;
+		int offset;
 
 		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
 		if (unlikely(!buf)) {
-- 
2.31.0

