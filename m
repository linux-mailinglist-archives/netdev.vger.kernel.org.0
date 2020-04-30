Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B2E1BF687
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgD3LVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:21:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33200 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727030AbgD3LVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:21:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588245672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m0EDYbK7T55GQjuN2LjAbsQb8j76gKWgN+FvVgdOORA=;
        b=MgGIEo57OpVj6i+uum6gcBTAifOofQ8pyDWx81wAIykw2I1/5lj5Zv+byzN+lC85YlYH2g
        USYTnHhgiGFSiR8amYdB8uXW5z0KZXUg9xdtnMkpzMFcoP3abOCR6B20XYxY5USMi9Cs+i
        tFqH/uAbnza99ct/rx0ZBwKUcrYE4kw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-WRxfC3gfN0qiJkSv-kdMOQ-1; Thu, 30 Apr 2020 07:21:11 -0400
X-MC-Unique: WRxfC3gfN0qiJkSv-kdMOQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E661107ACF2;
        Thu, 30 Apr 2020 11:21:08 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F3835D787;
        Thu, 30 Apr 2020 11:21:08 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 39E0D324DB2C1;
        Thu, 30 Apr 2020 13:21:07 +0200 (CEST)
Subject: [PATCH net-next v2 09/33] veth: adjust hard_start offset on redirect
 XDP frames
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Mao Wenan <maowenan@huawei.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Date:   Thu, 30 Apr 2020 13:21:07 +0200
Message-ID: <158824566716.2172139.13596105674207412185.stgit@firesoul>
In-Reply-To: <158824557985.2172139.4173570969543904434.stgit@firesoul>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When native XDP redirect into a veth device, the frame arrives in the
xdp_frame structure. It is then processed in veth_xdp_rcv_one(),
which can run a new XDP bpf_prog on the packet. Doing so requires
converting xdp_frame to xdp_buff, but the tricky part is that
xdp_frame memory area is located in the top (data_hard_start) memory
area that xdp_buff will point into.

The current code tried to protect the xdp_frame area, by assigning
xdp_buff.data_hard_start past this memory. This results in 32 bytes
less headroom to expand into via BPF-helper bpf_xdp_adjust_head().

This protect step is actually not needed, because BPF-helper
bpf_xdp_adjust_head() already reserve this area, and don't allow
BPF-prog to expand into it. Thus, it is safe to point data_hard_start
directly at xdp_frame memory area.

Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>
Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
Reported-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
 drivers/net/veth.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index aece0e5eec8c..d5691bb84448 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -564,13 +564,15 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth=
_rq *rq,
 					struct veth_stats *stats)
 {
 	void *hard_start =3D frame->data - frame->headroom;
-	void *head =3D hard_start - sizeof(struct xdp_frame);
 	int len =3D frame->len, delta =3D 0;
 	struct xdp_frame orig_frame;
 	struct bpf_prog *xdp_prog;
 	unsigned int headroom;
 	struct sk_buff *skb;
=20
+	/* bpf_xdp_adjust_head() assures BPF cannot access xdp_frame area */
+	hard_start -=3D sizeof(struct xdp_frame);
+
 	rcu_read_lock();
 	xdp_prog =3D rcu_dereference(rq->xdp_prog);
 	if (likely(xdp_prog)) {
@@ -592,7 +594,6 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_r=
q *rq,
 			break;
 		case XDP_TX:
 			orig_frame =3D *frame;
-			xdp.data_hard_start =3D head;
 			xdp.rxq->mem =3D frame->mem;
 			if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
 				trace_xdp_exception(rq->dev, xdp_prog, act);
@@ -605,7 +606,6 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_r=
q *rq,
 			goto xdp_xmit;
 		case XDP_REDIRECT:
 			orig_frame =3D *frame;
-			xdp.data_hard_start =3D head;
 			xdp.rxq->mem =3D frame->mem;
 			if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
 				frame =3D &orig_frame;
@@ -629,7 +629,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_r=
q *rq,
 	rcu_read_unlock();
=20
 	headroom =3D sizeof(struct xdp_frame) + frame->headroom - delta;
-	skb =3D veth_build_skb(head, headroom, len, 0);
+	skb =3D veth_build_skb(hard_start, headroom, len, 0);
 	if (!skb) {
 		xdp_return_frame(frame);
 		stats->rx_drops++;


