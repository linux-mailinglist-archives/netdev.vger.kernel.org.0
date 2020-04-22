Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3551B49A3
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgDVQIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:08:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49338 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726901AbgDVQIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UQknPoSVqukI3wsb64kn3jV/Ue6U4R6uceCZMBugEHI=;
        b=RpXUzKtRGKxanfl39IcAYcYBSNWZGAGN2wKUSLS5RqOlXKQRxhXqa+CvQtJnf9+mGXdHKf
        5B65v8hKFxflCy4SOlSNlGXsPmOr6g7WfkXf7BdwHnu2iMbbe7oDbbvmbuRbAacOgY0FPZ
        AVXdzyCMnovpiwAvspVG9N9BZrEu5RM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-Fa9DoQb2MxuLIju7gd4V7Q-1; Wed, 22 Apr 2020 12:07:59 -0400
X-MC-Unique: Fa9DoQb2MxuLIju7gd4V7Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BC1F801503;
        Wed, 22 Apr 2020 16:07:57 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7115C1001920;
        Wed, 22 Apr 2020 16:07:52 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 91E3930000272;
        Wed, 22 Apr 2020 18:07:51 +0200 (CEST)
Subject: [PATCH net-next 06/33] net: XDP-generic determining XDP frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
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
Date:   Wed, 22 Apr 2020 18:07:51 +0200
Message-ID: <158757167152.1370371.9610663437543094071.stgit@firesoul>
In-Reply-To: <158757160439.1370371.13213378122947426220.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SKB "head" pointer points to the data area that contains
skb_shared_info, that can be found via skb_end_pointer(). Given
xdp->data_hard_start have been established (basically pointing to
skb->head), frame size is between skb_end_pointer() and data_hard_start,
plus the size reserved to skb_shared_info.

Change the bpf_xdp_adjust_tail offset adjust of skb->len, to be a positive
offset number on grow, and negative number on shrink.  As this seems more
natural when reading the code.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/dev.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index fb61522b1ce1..8d827d3e9f3b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4549,6 +4549,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
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
@@ -4572,14 +4577,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
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


