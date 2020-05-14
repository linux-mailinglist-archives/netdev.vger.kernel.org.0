Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB461D2D43
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgENKtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:49:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58337 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726234AbgENKtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 06:49:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589453378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UPUt7qWo8v4gC2l9EmGH9dOhbo9QCHv4g1iCeXusygs=;
        b=GvuNIFHx20DvGK3MaBcLN/JQzd6NOpTnj/536joF3hwlztbSMp50gt6X74zTEipuYRh0RD
        VAJKg6sXrcYyCIcVXii7xx7DUyTi2SIhnST1/m7boIlbSt25XISa/e6344I/wEHO4NRE7A
        L4jfNX3tETs+xW0hzDULhFROKU3+H9U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-Bd8J5-ebNpaEIMHRbDP7eQ-1; Thu, 14 May 2020 06:49:34 -0400
X-MC-Unique: Bd8J5-ebNpaEIMHRbDP7eQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60ABAEC1A0;
        Thu, 14 May 2020 10:49:32 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 270E95D9CA;
        Thu, 14 May 2020 10:49:29 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 1D869300020FC;
        Thu, 14 May 2020 12:49:28 +0200 (CEST)
Subject: [PATCH net-next v4 06/33] net: XDP-generic determining XDP frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Thu, 14 May 2020 12:49:28 +0200
Message-ID: <158945336804.97035.7164852191163722056.stgit@firesoul>
In-Reply-To: <158945314698.97035.5286827951225578467.stgit@firesoul>
References: <158945314698.97035.5286827951225578467.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/core/dev.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4c91de39890a..f937a3ff668d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4617,6 +4617,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
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
@@ -4640,14 +4645,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
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


