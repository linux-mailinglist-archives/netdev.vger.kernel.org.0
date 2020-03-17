Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C77188C21
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCQRau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:30:50 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52854 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726968AbgCQRas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:30:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zp+AQxs94EVnMCSzOQE9xni13biyNXHyfWNC7YYNhrc=;
        b=Pd4LwQ+nJpeK+ZggLUNnXAWDtP6yBfImsW9bWfsP6xASyxmDALvogY5bcaspBUvVtG5znY
        XGHWwPDMD1y1hOgI+VDVxQxtyxW+K6GGzL2DhukQPUsm6YHsnXoFhWe9G8b524G0cP/26y
        NyeEVPJvEvviRo558PE7rRpPpw7Qu1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-6NdTwgLpOoiXgJ9UM3wdQA-1; Tue, 17 Mar 2020 13:30:41 -0400
X-MC-Unique: 6NdTwgLpOoiXgJ9UM3wdQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49799801E67;
        Tue, 17 Mar 2020 17:30:20 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE7FC5C1BB;
        Tue, 17 Mar 2020 17:30:19 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E614630721A66;
        Tue, 17 Mar 2020 18:30:18 +0100 (CET)
Subject: [PATCH RFC v1 14/15] veth: xdp using frame_sz in veth driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Tue, 17 Mar 2020 18:30:18 +0100
Message-ID: <158446621887.702578.17234304084556809684.stgit@firesoul>
In-Reply-To: <158446612466.702578.2795159620575737080.stgit@firesoul>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/veth.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 8cdc4415fa70..be88625162cd 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -492,6 +492,8 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 					unsigned int *xdp_xmit,
 					struct veth_xdp_tx_bq *bq)
 {
+// hmm... do we really need to exclude sizeof(struct xdp_frame) ?
+// ... as bpf_xdp_adjust_head() already handle this.
 	void *hard_start = frame->data - frame->headroom;
 	void *head = hard_start - sizeof(struct xdp_frame);
 	int len = frame->len, delta = 0;
@@ -506,11 +508,12 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 		struct xdp_buff xdp;
 		u32 act;
 
-		xdp.data_hard_start = hard_start;
+		xdp.data_hard_start = hard_start; /* exclude xdp_frame area */
 		xdp.data = frame->data;
 		xdp.data_end = frame->data + frame->len;
 		xdp.data_meta = frame->data - frame->metasize;
 		xdp.rxq = &rq->xdp_rxq;
+		xdp.frame_sz = frame->frame_sz - sizeof(struct xdp_frame);
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
@@ -639,6 +642,11 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq, struct sk_buff *skb,
 	xdp.data_end = xdp.data + pktlen;
 	xdp.data_meta = xdp.data;
 	xdp.rxq = &rq->xdp_rxq;
+
+	/* SKB "head" area always have tailroom for skb_shared_info */
+	xdp.frame_sz = (void *)skb_end_pointer(skb) - xdp.data_hard_start;
+	xdp.frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 	orig_data = xdp.data;
 	orig_data_end = xdp.data_end;
 
@@ -678,6 +686,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq, struct sk_buff *skb,
 	}
 	rcu_read_unlock();
 
+	/* check if bpf_xdp_adjust_head was used */
 	delta = orig_data - xdp.data;
 	off = mac_len + delta;
 	if (off > 0)
@@ -685,9 +694,11 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq, struct sk_buff *skb,
 	else if (off < 0)
 		__skb_pull(skb, -off);
 	skb->mac_header -= delta;
+
+	/* check if bpf_xdp_adjust_tail was used */
 	off = xdp.data_end - orig_data_end;
 	if (off != 0)
-		__skb_put(skb, off);
+		__skb_put(skb, off); /* positive on grow, negative on shrink */
 	skb->protocol = eth_type_trans(skb, rq->dev);
 
 	metalen = xdp.data - xdp.data_meta;


