Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D6B188C19
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgCQRaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:30:25 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:35692 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbgCQRaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:30:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yx3RZws4yQG7gnfYNWis4eEV1lTKG+jOjgsTDqL0uy4=;
        b=Skadqx1jc+2X9yuon2bT0VmTNvyYo5G+gX/b+C7fSsHcKzovl7MgUvaKjhGhEf/s2cIS0I
        QqOeL1aSX2vTu5U0KgDX3bDG7FJ4QwzeJoi4kU+1nZgBYNylY56UakgnfWmgGrXmE5jCr5
        eppR6Tt+Gzm8VR3d+wsFw4nROhEfAo0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-XnU9gnxyNTaB9hxOwPbNGQ-1; Tue, 17 Mar 2020 13:30:10 -0400
X-MC-Unique: XnU9gnxyNTaB9hxOwPbNGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5C50802C86;
        Tue, 17 Mar 2020 17:29:59 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81B4860BEE;
        Tue, 17 Mar 2020 17:29:59 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 9288930721A66;
        Tue, 17 Mar 2020 18:29:58 +0100 (CET)
Subject: [PATCH RFC v1 10/15] net: XDP-generic determining XDP frame size
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
Date:   Tue, 17 Mar 2020 18:29:58 +0100
Message-ID: <158446619851.702578.5555301782398712923.stgit@firesoul>
In-Reply-To: <158446612466.702578.2795159620575737080.stgit@firesoul>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SKB "head" pointer points to the data area that contains
skb_shared_info, that can be found via skb_end_pointer(). Given
xdp->data_hard_start have been established (basically pointing to
skb->head), frame size is between skb_end_pointer() and data_hard_start,
plus the size reserved to skb_shared_info.

Change the bpf_xdp_adjust_tail fix up of skb->len, to be a positive
offset number on grow, and negative number on shrink.  As this seems more
natural when reading the code

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/dev.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9c941cd38b13..645e5c48a52f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4546,6 +4546,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	xdp->data_meta = xdp->data;
 	xdp->data_end = xdp->data + hlen;
 	xdp->data_hard_start = skb->data - skb_headroom(skb);
+
+	/* SKB "head" area always have tailroom for skb_shared_info */
+	xdp->frame_sz  = (void *)skb_end_pointer(skb) - xdp->data_hard_start;
+	xdp->frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 	orig_data_end = xdp->data_end;
 	orig_data = xdp->data;
 	eth = (struct ethhdr *)xdp->data;
@@ -4569,14 +4574,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 		skb_reset_network_header(skb);
 	}
 
-	/* check if bpf_xdp_adjust_tail was used. it can only "shrink"
-	 * pckt.
-	 */
-	off = orig_data_end - xdp->data_end;
+	/* check if bpf_xdp_adjust_tail was used */
+	off = xdp->data_end - orig_data_end;
 	if (off != 0) {
 		skb_set_tail_pointer(skb, xdp->data_end - xdp->data);
-		skb->len -= off;
-
+		skb->len += off; /* positive on grow, negative on shrink */
 	}
 
 	/* check if XDP changed eth hdr such SKB needs update */


