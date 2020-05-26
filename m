Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689541BF67E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgD3LVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:21:06 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727080AbgD3LVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:21:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588245664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gnPvZV/dEMFMyaLIx220Mtoo9DjIOh+4KYKq8NpYOXI=;
        b=gIfTUe+ahBvPwqNIb07DH2hkKmTu0Bl/HGA4RR1Gy+isJj0kFIjfL5TApsdZZcFO3NTZUD
        TzTVU+0niZ2rJEjUEFKf6mgtukiYZ+hup4h+rLpgvKQRb1kFFl1t17v++1EHnK8RnN0Qo2
        9oj9cnvyTJFv/0tWCOA4KT1KTV85g0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-XmqwcZVxONuvKjYvHCSj2Q-1; Thu, 30 Apr 2020 07:21:00 -0400
X-MC-Unique: XmqwcZVxONuvKjYvHCSj2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FAEF800D24;
        Thu, 30 Apr 2020 11:20:58 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0181E5EDE3;
        Thu, 30 Apr 2020 11:20:53 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id EF856324DB2C0;
        Thu, 30 Apr 2020 13:20:51 +0200 (CEST)
Subject: [PATCH net-next v2 06/33] net: XDP-generic determining XDP frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
Date:   Thu, 30 Apr 2020 13:20:51 +0200
Message-ID: <158824565189.2172139.15984289372325616869.stgit@firesoul>
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

The SKB "head" pointer points to the data area that contains
skb_shared_info, that can be found via skb_end_pointer(). Given
xdp->data_hard_start have been established (basically pointing to
skb->head), frame size is between skb_end_pointer() and data_hard_start,
plus the size reserved to skb_shared_info.

Change the bpf_xdp_adjust_tail offset adjust of skb->len, to be a positiv=
e
offset number on grow, and negative number on shrink.  As this seems more
natural when reading the code.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
 net/core/dev.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index afff16849c26..b364e6f3a37a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4549,6 +4549,11 @@ static u32 netif_receive_generic_xdp(struct sk_buf=
f *skb,
 	xdp->data_meta =3D xdp->data;
 	xdp->data_end =3D xdp->data + hlen;
 	xdp->data_hard_start =3D skb->data - skb_headroom(skb);
+
+	/* SKB "head" area always have tailroom for skb_shared_info */
+	xdp->frame_sz  =3D (void *)skb_end_pointer(skb) - xdp->data_hard_start;
+	xdp->frame_sz +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 	orig_data_end =3D xdp->data_end;
 	orig_data =3D xdp->data;
 	eth =3D (struct ethhdr *)xdp->data;
@@ -4572,14 +4577,11 @@ static u32 netif_receive_generic_xdp(struct sk_bu=
ff *skb,
 		skb_reset_network_header(skb);
 	}
=20
-	/* check if bpf_xdp_adjust_tail was used. it can only "shrink"
-	 * pckt.
-	 */
-	off =3D orig_data_end - xdp->data_end;
+	/* check if bpf_xdp_adjust_tail was used */
+	off =3D xdp->data_end - orig_data_end;
 	if (off !=3D 0) {
 		skb_set_tail_pointer(skb, xdp->data_end - xdp->data);
-		skb->len -=3D off;
-
+		skb->len +=3D off; /* positive on grow, negative on shrink */
 	}
=20
 	/* check if XDP changed eth hdr such SKB needs update */


