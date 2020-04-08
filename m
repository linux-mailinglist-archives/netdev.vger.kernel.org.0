Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB521A2035
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgDHLvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:51:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37520 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728635AbgDHLvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jXba+XtT9T2e7WXxZq/751Lokp2fv24Zljt1exxIEiA=;
        b=iUHqdr9/fe/glcLCsP8VG2ekoQSJlYb+Zoafgm9TjWdLLA7hh3t5Q+JCcz+qtpMPI9K0qv
        kkx5GPso9jRYl2GeiUaKpFLImaXlfSg9mR2XvX4Rd8H1x+7Tq6RuPULP9lSIJOrqVoFn44
        GgO0xkpHxdC6wA/FV6/pCrEPlVjgN1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-M3zlFnoCOwiOG7UGCw3A4A-1; Wed, 08 Apr 2020 07:51:15 -0400
X-MC-Unique: M3zlFnoCOwiOG7UGCw3A4A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87855801F8A;
        Wed,  8 Apr 2020 11:51:12 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C04AF60BFB;
        Wed,  8 Apr 2020 11:51:05 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id D04CE300020FB;
        Wed,  8 Apr 2020 13:51:04 +0200 (CEST)
Subject: [PATCH RFC v2 06/33] net: XDP-generic determining XDP frame size
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
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:51:04 +0200
Message-ID: <158634666478.707275.4768222424893157119.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index 9c9e763bfe0e..899920c3a78f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4548,6 +4548,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
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
@@ -4571,14 +4576,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
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


