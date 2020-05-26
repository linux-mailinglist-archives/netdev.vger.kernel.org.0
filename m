Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2615D1BF68A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgD3LV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:21:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43087 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727030AbgD3LVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:21:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588245684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OK1sSHdRYCleU7f7Ak9moZ6zdgdzmS5QKK5sRzUD0/g=;
        b=AEvi+6I2ZakEEh1oiJUJcx2tz8Vf+apapLdJMBiBbJ4IhO+ePdIbgbwldHml0OaPueC9ni
        Y0gzjHdp3VtZje3MwSKJAGYBwU5Jrhd44/wMBZMxM/2l/5C3RSpchZOO40kwM1EMDSepZg
        YOEXWUDOYKvUFMj+JTadx4fiJvgQnVM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-5-wyTd39OJ2sIc-axtB2Zg-1; Thu, 30 Apr 2020 07:21:22 -0400
X-MC-Unique: 5-wyTd39OJ2sIc-axtB2Zg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C251A800D24;
        Thu, 30 Apr 2020 11:21:18 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4279B5D787;
        Thu, 30 Apr 2020 11:21:13 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 4EA1F324DB2C0;
        Thu, 30 Apr 2020 13:21:12 +0200 (CEST)
Subject: [PATCH net-next v2 10/33] veth: xdp using frame_sz in veth driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
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
Date:   Thu, 30 Apr 2020 13:21:12 +0200
Message-ID: <158824567224.2172139.7951075614147304981.stgit@firesoul>
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

The veth driver can run XDP in "native" mode in it's own NAPI
handler, and since commit 9fc8d518d9d5 ("veth: Handle xdp_frames in
xdp napi ring") packets can come in two forms either xdp_frame or
skb, calling respectively veth_xdp_rcv_one() or veth_xdp_rcv_skb().

For packets to arrive in xdp_frame format, they will have been
redirected from an XDP native driver. In case of XDP_PASS or no
XDP-prog attached, the veth driver will allocate and create an SKB.

The current code in veth_xdp_rcv_one() xdp_frame case, had to guess
the frame truesize of the incoming xdp_frame, when using
veth_build_skb(). With xdp_frame->frame_sz this is not longer
necessary.

Calculating the frame_sz in veth_xdp_rcv_skb() skb case, is done
similar to the XDP-generic handling code in net/core/dev.c.

Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>
Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 drivers/net/veth.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index d5691bb84448..b586d2fa5551 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -405,10 +405,6 @@ static struct sk_buff *veth_build_skb(void *head, in=
t headroom, int len,
 {
 	struct sk_buff *skb;
=20
-	if (!buflen) {
-		buflen =3D SKB_DATA_ALIGN(headroom + len) +
-			 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	}
 	skb =3D build_skb(head, buflen);
 	if (!skb)
 		return NULL;
@@ -583,6 +579,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_r=
q *rq,
 		xdp.data =3D frame->data;
 		xdp.data_end =3D frame->data + frame->len;
 		xdp.data_meta =3D frame->data - frame->metasize;
+		xdp.frame_sz =3D frame->frame_sz;
 		xdp.rxq =3D &rq->xdp_rxq;
=20
 		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -629,7 +626,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_r=
q *rq,
 	rcu_read_unlock();
=20
 	headroom =3D sizeof(struct xdp_frame) + frame->headroom - delta;
-	skb =3D veth_build_skb(hard_start, headroom, len, 0);
+	skb =3D veth_build_skb(hard_start, headroom, len, frame->frame_sz);
 	if (!skb) {
 		xdp_return_frame(frame);
 		stats->rx_drops++;
@@ -695,9 +692,8 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_r=
q *rq,
 			goto drop;
 		}
=20
-		nskb =3D veth_build_skb(head,
-				      VETH_XDP_HEADROOM + mac_len, skb->len,
-				      PAGE_SIZE);
+		nskb =3D veth_build_skb(head, VETH_XDP_HEADROOM + mac_len,
+				      skb->len, PAGE_SIZE);
 		if (!nskb) {
 			page_frag_free(head);
 			goto drop;
@@ -715,6 +711,11 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_=
rq *rq,
 	xdp.data_end =3D xdp.data + pktlen;
 	xdp.data_meta =3D xdp.data;
 	xdp.rxq =3D &rq->xdp_rxq;
+
+	/* SKB "head" area always have tailroom for skb_shared_info */
+	xdp.frame_sz =3D (void *)skb_end_pointer(skb) - xdp.data_hard_start;
+	xdp.frame_sz +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 	orig_data =3D xdp.data;
 	orig_data_end =3D xdp.data_end;
=20
@@ -758,6 +759,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_r=
q *rq,
 	}
 	rcu_read_unlock();
=20
+	/* check if bpf_xdp_adjust_head was used */
 	delta =3D orig_data - xdp.data;
 	off =3D mac_len + delta;
 	if (off > 0)
@@ -765,9 +767,11 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_=
rq *rq,
 	else if (off < 0)
 		__skb_pull(skb, -off);
 	skb->mac_header -=3D delta;
+
+	/* check if bpf_xdp_adjust_tail was used */
 	off =3D xdp.data_end - orig_data_end;
 	if (off !=3D 0)
-		__skb_put(skb, off);
+		__skb_put(skb, off); /* positive on grow, negative on shrink */
 	skb->protocol =3D eth_type_trans(skb, rq->dev);
=20
 	metalen =3D xdp.data - xdp.data_meta;


