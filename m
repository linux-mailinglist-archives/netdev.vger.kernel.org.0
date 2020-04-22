Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7311B49BA
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgDVQJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:09:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30612 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726916AbgDVQJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Z0tKm1MdcSY7wLHzTmacDwetIASD7bgAj5sYZhWuq4=;
        b=FaG45alY3XxcvZoWnoSQhe+oCdtGITeZ1/QZIk8J5VI2bjdh3W7Ds4w4j5pOJGuhu5OTzQ
        WuWulZiURGXdXcLpGizVi5yAcvafMsaFRbKVWNm0C+MPjc/8HnIYPavM0FfDNu/HKjhOlN
        96gha4Pu0xU8WQnr6C4+8NSD3EDg0lM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-jjae7i0nNbepDtRObHvVqw-1; Wed, 22 Apr 2020 12:09:03 -0400
X-MC-Unique: jjae7i0nNbepDtRObHvVqw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 960672F61;
        Wed, 22 Apr 2020 16:08:58 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 591B54D751;
        Wed, 22 Apr 2020 16:08:48 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 78E9530631AB2;
        Wed, 22 Apr 2020 18:08:47 +0200 (CEST)
Subject: [PATCH net-next 17/33] net: thunderx: add XDP frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
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
Date:   Wed, 22 Apr 2020 18:08:47 +0200
Message-ID: <158757172742.1370371.1539130962660013123.stgit@firesoul>
In-Reply-To: <158757160439.1370371.13213378122947426220.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To help reviewers these are the defines related to RCV_FRAG_LEN

 #define DMA_BUFFER_LEN	1536 /* In multiples of 128bytes */
 #define RCV_FRAG_LEN	(SKB_DATA_ALIGN(DMA_BUFFER_LEN + NET_SKB_PAD) + \
			 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))

Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: Robert Richter <rrichter@marvell.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index b4b33368698f..2ba0ce115e63 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -552,6 +552,7 @@ static inline bool nicvf_xdp_rx(struct nicvf *nic, struct bpf_prog *prog,
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.data_end = xdp.data + len;
 	xdp.rxq = &rq->xdp_rxq;
+	xdp.frame_sz = RCV_FRAG_LEN + XDP_PACKET_HEADROOM;
 	orig_data = xdp.data;
 
 	rcu_read_lock();


