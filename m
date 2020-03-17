Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AAC188C20
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgCQRar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:30:47 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:50688 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726738AbgCQRaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hRA3mLxIRW8RlSqNs1JzRim2qfbZVa1Otm7sdJNcWjU=;
        b=LYyA4C0BJp7dJo6Ov00kNMHL//39t/Nw+dYB2svPv6Vr91dGJyPah56gygeQhTDo1zyzqp
        9gFPkxG8GA17r+sNLIAuC4a9Y4VuwRUibJ6oWaA0DXuWBL5PW7Gsx5GWPz3m/AwpXTyREK
        JQpOUKaro8QaZcYTOaBcLjkl48Dwr5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-nkwSaraWPOS9d6OYjGG8vg-1; Tue, 17 Mar 2020 13:30:43 -0400
X-MC-Unique: nkwSaraWPOS9d6OYjGG8vg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6480B1085988;
        Tue, 17 Mar 2020 17:30:25 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06CD960BEE;
        Tue, 17 Mar 2020 17:30:25 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 0722930721A66;
        Tue, 17 Mar 2020 18:30:24 +0100 (CET)
Subject: [PATCH RFC v1 15/15] dpaa2-eth: add XDP frame size
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
Date:   Tue, 17 Mar 2020 18:30:24 +0100
Message-ID: <158446622395.702578.14405139445906785865.stgit@firesoul>
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

This is the full page size:
 #define DPAA2_ETH_RX_BUF_RAW_SIZE	PAGE_SIZE

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 7ff147e89426..8b03b38b33c9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -301,6 +301,7 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
 	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.rxq = &ch->xdp_rxq;
+	xdp.frame_sz = DPAA2_ETH_RX_BUF_RAW_SIZE;
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 


