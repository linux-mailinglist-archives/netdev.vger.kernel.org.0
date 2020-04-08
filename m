Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C3C1A204F
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgDHLwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:52:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55973 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726964AbgDHLwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:52:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YV5fiXJi7wD2YuC2mF2ej3iCw+o72u2RsOOOo78KEjw=;
        b=VfqTD+OzIchNtRGXCB5fhr7/eUX/2awuncfqsTrvUVi56wWOQgAvuK1ZBQ+OLC60qtx7ua
        b2T4RXOm/7DuyIW6Qte4QB4PWUvAs2qKM73yI52RgGXJDTwA9xukWiDWd7YoIm2VkbdAgs
        R3NMWGjpawbHRzK22M6bE3p5dGjguKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-uiHNqoK9OpSte7-1Swlv9w-1; Wed, 08 Apr 2020 07:52:19 -0400
X-MC-Unique: uiHNqoK9OpSte7-1Swlv9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 530861005510;
        Wed,  8 Apr 2020 11:52:17 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC936396;
        Wed,  8 Apr 2020 11:52:11 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E32DB300020FA;
        Wed,  8 Apr 2020 13:52:10 +0200 (CEST)
Subject: [PATCH RFC v2 19/33] nfp: add XDP frame size to netronome driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jakub Kicinski <kuba@kernel.org>,
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
Date:   Wed, 08 Apr 2020 13:52:10 +0200
Message-ID: <158634673086.707275.8905781490793267908.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netronome nfp driver already had a true_bufsz variable
that contains what was needed for xdp.frame_sz.

Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 9bfb3b077bc1..b9b8c30eab33 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1817,6 +1817,7 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(dp->xdp_prog);
 	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
+	xdp.frame_sz = true_bufsz;
 	xdp.rxq = &rx_ring->xdp_rxq;
 	tx_ring = r_vec->xdp_ring;
 


