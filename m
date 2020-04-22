Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AEB1B49BD
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgDVQJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:09:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50274 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726916AbgDVQJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kqBDZxyv+p4tnRDx47VhVN4eaUx6SEuYjswzoXoZJHQ=;
        b=aL2Z9uBPFQbBUbRt1U4KOzJuAYXq98LmGBwICC6z7xIuJK3remras4rrTGqOIh4fy7v/lw
        xAj2Nag4knWz/SX1yEk7/kXyX+CXe988nPt10JyFnLRkrrbVhJgqNfmxLqTyz8RhL2rLZN
        KUDDpqUqFLd/DVu0UG4dHhaCKyXkuJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-6p5HSEK8Ogu5QzElRLXnVQ-1; Wed, 22 Apr 2020 12:09:03 -0400
X-MC-Unique: 6p5HSEK8Ogu5QzElRLXnVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE30C8017FD;
        Wed, 22 Apr 2020 16:09:00 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 848FD5C553;
        Wed, 22 Apr 2020 16:08:58 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id A074A30000272;
        Wed, 22 Apr 2020 18:08:57 +0200 (CEST)
Subject: [PATCH net-next 19/33] tun: add XDP frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jason Wang <jasowang@redhat.com>,
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
Date:   Wed, 22 Apr 2020 18:08:57 +0200
Message-ID: <158757173758.1370371.17195673814740376146.stgit@firesoul>
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

The tun driver have two code paths for running XDP (bpf_prog_run_xdp).
In both cases 'buflen' contains enough tailroom for skb_shared_info.

Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/tun.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 44889eba1dbc..c54f967e2c66 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1671,6 +1671,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
 		xdp.rxq = &tfile->xdp_rxq;
+		xdp.frame_sz = buflen;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		if (act == XDP_REDIRECT || act == XDP_TX) {
@@ -2411,6 +2412,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 		}
 		xdp_set_data_meta_invalid(xdp);
 		xdp->rxq = &tfile->xdp_rxq;
+		xdp->frame_sz = buflen;
 
 		act = bpf_prog_run_xdp(xdp_prog, xdp);
 		err = tun_xdp_act(tun, xdp_prog, xdp, act);


