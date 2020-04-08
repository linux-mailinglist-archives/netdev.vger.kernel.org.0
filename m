Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E671A2058
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbgDHLwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:52:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25792 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728741AbgDHLwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:52:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OPOu3xqwQqyfpl6KXPjwSLkgQ1r4/m6u5lOgd9ZIdyM=;
        b=GHXqcpI135wMmkEpoDXujCDW5kQ3bbOWrPF+9hDik8H9CgKX3sIXFSVKN+trjbe9D22qoo
        786nc2OAYGfiNSC9bkWMEFSei/Hu/V5xWhFN4F4BdEANbuIF9bF0m4tcmdZifigFVbOyZm
        c29zutrCEc4rH4q5DqRfdlnjjnDcy/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-8O2XUNq-M6Gl5jnSvcdOLA-1; Wed, 08 Apr 2020 07:52:34 -0400
X-MC-Unique: 8O2XUNq-M6Gl5jnSvcdOLA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E7F9800D53;
        Wed,  8 Apr 2020 11:52:32 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10EB05C1BB;
        Wed,  8 Apr 2020 11:52:27 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 2BBAF300020FB;
        Wed,  8 Apr 2020 13:52:26 +0200 (CEST)
Subject: [PATCH RFC v2 22/33] virtio_net: add XDP frame size in two code paths
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:52:26 +0200
Message-ID: <158634674610.707275.9335118623425357911.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The virtio_net driver is running inside the guest-OS. There are two
XDP receive code-paths in virtio_net, namely receive_small() and
receive_mergeable(). The receive_big() function does not support XDP.

In receive_small() the frame size is available in buflen. The buffer
backing these frames are allocated in add_recvbuf_small() with same
size, except for the headroom, but tailroom have reserved room for
skb_shared_info. The headroom is encoded in ctx pointer as a value.

In receive_mergeable() the frame size is more dynamic. There are two
basic cases: (1) buffer size is based on a exponentially weighted
moving average (see DECLARE_EWMA) of packet length. Or (2) in case
virtnet_get_headroom() have any headroom then buffer size is
PAGE_SIZE. The ctx pointer is this time used for encoding two values;
the buffer len "truesize" and headroom. In case (1) if the rx buffer
size is underestimated, the packet will have been split over more
buffers (num_buf info in virtio_net_hdr_mrg_rxbuf placed in top of
buffer area). If that happens the XDP path does a xdp_linearize_page
operation.

Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/virtio_net.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 11f722460513..1df3676da185 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -689,6 +689,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		xdp.data_end = xdp.data + len;
 		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
+		xdp.frame_sz = buflen;
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
@@ -797,10 +798,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	int offset = buf - page_address(page);
 	struct sk_buff *head_skb, *curr_skb;
 	struct bpf_prog *xdp_prog;
-	unsigned int truesize;
+	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
-	int err;
 	unsigned int metasize = 0;
+	unsigned int frame_sz;
+	int err;
 
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
@@ -821,6 +823,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		if (unlikely(hdr->hdr.gso_type))
 			goto err_xdp;
 
+		/* Buffers with headroom use PAGE_SIZE as alloc size,
+		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
+		 */
+		frame_sz = headroom ? PAGE_SIZE : truesize;
+
 		/* This happens when rx buffer size is underestimated
 		 * or headroom is not enough because of the buffer
 		 * was refilled before XDP is set. This should only
@@ -834,6 +841,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 						      page, offset,
 						      VIRTIO_XDP_HEADROOM,
 						      &len);
+			frame_sz = PAGE_SIZE;
+
 			if (!xdp_page)
 				goto err_xdp;
 			offset = VIRTIO_XDP_HEADROOM;
@@ -850,6 +859,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		xdp.data_end = xdp.data + (len - vi->hdr_len);
 		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
+		xdp.frame_sz = frame_sz;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
@@ -924,7 +934,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	}
 	rcu_read_unlock();
 
-	truesize = mergeable_ctx_to_truesize(ctx);
 	if (unlikely(len > truesize)) {
 		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
 			 dev->name, len, (unsigned long)ctx);


