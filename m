Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068411A204D
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgDHLwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:52:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49166 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726964AbgDHLwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:52:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Z0tKm1MdcSY7wLHzTmacDwetIASD7bgAj5sYZhWuq4=;
        b=HgOIZ190qGN10CyRL/XK3NmJofwYuiTkFikX3pdFVA/SlfLCGcaQu4Xgg0gp/5PxdWphkb
        KB4xPRvJxCsXA0U7ckkc7Yf+WZEIgb+onQyJUlgelZUNUCE/sMvbGwoBgqzp6qnsf6c1b/
        XtdNsmUBsJHYVobsX7oYhXMFKP4/TuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-a-seBakZP8eQxrNPv6qMNw-1; Wed, 08 Apr 2020 07:52:09 -0400
X-MC-Unique: a-seBakZP8eQxrNPv6qMNw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FFC7107ACC9;
        Wed,  8 Apr 2020 11:52:07 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB3555DA60;
        Wed,  8 Apr 2020 11:52:06 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id CF9CE300020FB;
        Wed,  8 Apr 2020 13:52:05 +0200 (CEST)
Subject: [PATCH RFC v2 18/33] net: thunderx: add XDP frame size
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
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:52:05 +0200
Message-ID: <158634672578.707275.2156240580785362332.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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


