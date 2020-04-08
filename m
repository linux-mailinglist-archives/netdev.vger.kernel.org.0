Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E271B1A2053
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgDHLwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:52:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727612AbgDHLw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:52:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7m0VP+3GoaqcZnjFpTelhpLeFTK9dkctJ3woHM9xJjk=;
        b=ed63PpnOvEvLtQhn3rhtdU66X440GJhX+xQq2eiYLI1EsjQtdnUrSLCoRAlEvdgV/VFgWL
        2vbGkUPO4UkolEj4Mr5rVpP3hRZ/m8OcIF1A9rjI1DKSk1omZplYri0kHEl8nH10kL086r
        XRjRVFRs6aoONJqx38FwtmwZK6ftSgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-gVcylBFoNd-0Uy2vFIKmlQ-1; Wed, 08 Apr 2020 07:52:24 -0400
X-MC-Unique: gVcylBFoNd-0Uy2vFIKmlQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FFF38017CE;
        Wed,  8 Apr 2020 11:52:22 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1CC17E303;
        Wed,  8 Apr 2020 11:52:16 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 036C1300020FB;
        Wed,  8 Apr 2020 13:52:16 +0200 (CEST)
Subject: [PATCH RFC v2 20/33] tun: add XDP frame size
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
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:52:15 +0200
Message-ID: <158634673594.707275.17901094732951523850.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 228fe449dc6d..8351bb287a05 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1671,6 +1671,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
 		xdp.rxq = &tfile->xdp_rxq;
+		xdp.frame_sz = buflen;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		if (act == XDP_REDIRECT || act == XDP_TX) {
@@ -2408,6 +2409,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 		}
 		xdp_set_data_meta_invalid(xdp);
 		xdp->rxq = &tfile->xdp_rxq;
+		xdp->frame_sz = buflen;
 
 		act = bpf_prog_run_xdp(xdp_prog, xdp);
 		err = tun_xdp_act(tun, xdp_prog, xdp, act);


