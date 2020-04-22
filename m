Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF911B49AF
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgDVQIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:08:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45121 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726859AbgDVQIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kzYXaoPpPmWzZSp9Ai+CWn0TFU1orYZwW5qWCMekECU=;
        b=IF23WTudPcEsNNWw5LLItG8oCnO5jyNokxb05qPBa2gDNY6/GmVldBNfFFORtUgeC2cKha
        9e6XU94SXxtBTXrnLTDeIjUkMc/Fw36IiZGn/zdcbmBdPh7mogRytilFc7BjS0DqNknXx7
        LxTO/GWyliuaY8o0/+fgOUd6e0Htagg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-V1LXFK65Ma-cqbtOzPoEgg-1; Wed, 22 Apr 2020 12:08:34 -0400
X-MC-Unique: V1LXFK65Ma-cqbtOzPoEgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F25BD1085947;
        Wed, 22 Apr 2020 16:08:31 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D10755C3FA;
        Wed, 22 Apr 2020 16:08:17 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id F283330631A9B;
        Wed, 22 Apr 2020 18:08:16 +0200 (CEST)
Subject: [PATCH net-next 11/33] dpaa2-eth: add XDP frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Ioana Radulescu <ruxandra.radulescu@nxp.com>,
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
Date:   Wed, 22 Apr 2020 18:08:16 +0200
Message-ID: <158757169692.1370371.4639613056496511957.stgit@firesoul>
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

The dpaa2-eth driver reserve some headroom used for hardware and
software annotation area in RX/TX buffers. Thus, xdp.data_hard_start
doesn't start at page boundary.

When XDP is configured the area reserved via dpaa2_fd_get_offset(fd) is
448 bytes of which XDP have reserved 256 bytes. As frame_sz is
calculated as an offset from xdp_buff.data_hard_start, an adjust from
the full PAGE_SIZE == DPAA2_ETH_RX_BUF_RAW_SIZE.

When doing XDP_REDIRECT, the driver doesn't need this reserved headroom
any-longer and allows xdp_do_redirect() to use it. This is an advantage
for the drivers own ndo-xdp_xmit, as it uses part of this headroom for
itself.  Patch also adjust frame_sz in this case.

The driver cannot support XDP data_meta, because it uses the headroom
just before xdp.data for struct dpaa2_eth_swa (DPAA2_ETH_SWA_SIZE=64),
when transmitting the packet. When transmitting a xdp_frame in
dpaa2_eth_xdp_xmit_frame (call via ndo_xdp_xmit) is uses this area to
store a pointer to xdp_frame and dma_size, which is used in TX
completion (free_tx_fd) to return frame via xdp_return_frame().

Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index b6c46639aa4c..b5c0225942b5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -302,6 +302,9 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.rxq = &ch->xdp_rxq;
 
+	xdp.frame_sz = DPAA2_ETH_RX_BUF_RAW_SIZE -
+		(dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM);
+
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
 	/* xdp.data pointer may have changed */
@@ -337,7 +340,11 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
 		dma_unmap_page(priv->net_dev->dev.parent, addr,
 			       DPAA2_ETH_RX_BUF_SIZE, DMA_BIDIRECTIONAL);
 		ch->buf_count--;
+
+		/* Allow redirect use of full headroom */
 		xdp.data_hard_start = vaddr;
+		xdp.frame_sz = DPAA2_ETH_RX_BUF_RAW_SIZE;
+
 		err = xdp_do_redirect(priv->net_dev, &xdp, xdp_prog);
 		if (unlikely(err))
 			ch->stats.xdp_drop++;


