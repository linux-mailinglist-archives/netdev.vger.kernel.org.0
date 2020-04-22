Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8961B49A6
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgDVQIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:08:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30554 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726928AbgDVQIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:08:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZzzjCBq9WyI3Bb6b0nAFkEUdPjhrJ6l3Fs8nfiWFreM=;
        b=X+LYxmOyXGd/uq9hkPRae1weuoIDKnLuqXi3P4Svw5gzy9QSzougwbc2XXTLEN4LNoNk0e
        /8mtBqoSTqDc2W12r3dFer+2a/mArw+2PD9MqFAcCI78OQpL4kHuMUo+eKgxOAnvjNmI9D
        B4LKB4QRQ8Ng5td06KjyCX2vQHZEGpA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-VXFCodS9NfO1G-hRFQdmZA-1; Wed, 22 Apr 2020 12:08:05 -0400
X-MC-Unique: VXFCodS9NfO1G-hRFQdmZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 326F613FC;
        Wed, 22 Apr 2020 16:08:03 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91C666084C;
        Wed, 22 Apr 2020 16:08:02 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B826130000272;
        Wed, 22 Apr 2020 18:08:01 +0200 (CEST)
Subject: [PATCH net-next 08/33] xdp: cpumap redirect use frame_sz and increase
 skb_tailroom
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
Date:   Wed, 22 Apr 2020 18:08:01 +0200
Message-ID: <158757168168.1370371.11510167625755235041.stgit@firesoul>
In-Reply-To: <158757160439.1370371.13213378122947426220.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Knowing the memory size backing the packet/xdp_frame data area, and
knowing it already have reserved room for skb_shared_info, simplifies
using build_skb significantly.

With this change we no-longer lie about the SKB truesize, but more
importantly a significant larger skb_tailroom is now provided, e.g. when
drivers uses a full PAGE_SIZE. This extra tailroom (in linear area) can be
used by the network stack when coalescing SKBs (e.g. in skb_try_coalesce,
see TCP cases where tcp_queue_rcv() can 'eat' skb).

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 kernel/bpf/cpumap.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 70f71b154fa5..9c777ac4d4bd 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -162,25 +162,10 @@ static struct sk_buff *cpu_map_build_skb(struct bpf_cpu_map_entry *rcpu,
 	/* Part of headroom was reserved to xdpf */
 	hard_start_headroom = sizeof(struct xdp_frame) +  xdpf->headroom;
 
-	/* build_skb need to place skb_shared_info after SKB end, and
-	 * also want to know the memory "truesize".  Thus, need to
-	 * know the memory frame size backing xdp_buff.
-	 *
-	 * XDP was designed to have PAGE_SIZE frames, but this
-	 * assumption is not longer true with ixgbe and i40e.  It
-	 * would be preferred to set frame_size to 2048 or 4096
-	 * depending on the driver.
-	 *   frame_size = 2048;
-	 *   frame_len  = frame_size - sizeof(*xdp_frame);
-	 *
-	 * Instead, with info avail, skb_shared_info in placed after
-	 * packet len.  This, unfortunately fakes the truesize.
-	 * Another disadvantage of this approach, the skb_shared_info
-	 * is not at a fixed memory location, with mixed length
-	 * packets, which is bad for cache-line hotness.
+	/* Memory size backing xdp_frame data already have reserved
+	 * room for build_skb to place skb_shared_info in tailroom.
 	 */
-	frame_size = SKB_DATA_ALIGN(xdpf->len + hard_start_headroom) +
-		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	frame_size = xdpf->frame_sz;
 
 	pkt_data_start = xdpf->data - hard_start_headroom;
 	skb = build_skb_around(skb, pkt_data_start, frame_size);


