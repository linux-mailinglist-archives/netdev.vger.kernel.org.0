Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D67C1BF679
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgD3LU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:20:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37890 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726677AbgD3LUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:20:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588245654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CHDOVjSPM///ywYV+a0GV0bCIm/WsbFSrNndedJb8xA=;
        b=I4QZNlxsKEpOvhFdeLA9QsLeMBkPzVYS8/LS8OnkI5wkVAVyX31YTmsctmKcUDYtuwFWWf
        PiBqEsPgOuP18uMYufAT9cWcgGBgberx8jSsQvqr/RFzhdDQa5jUGB9f7X0DPHIUiYJdq5
        130PvbaNSgM+e2C7nKFYzqnEumkygG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-fkxBXaq6MeKchwdixuOcQw-1; Thu, 30 Apr 2020 07:20:51 -0400
X-MC-Unique: fkxBXaq6MeKchwdixuOcQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF5D71899520;
        Thu, 30 Apr 2020 11:20:48 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C800767641;
        Thu, 30 Apr 2020 11:20:42 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id C1FF8324DB2C0;
        Thu, 30 Apr 2020 13:20:41 +0200 (CEST)
Subject: [PATCH net-next v2 04/33] mvneta: add XDP frame size to driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     thomas.petazzoni@bootlin.com,
        Lorenzo Bianconi <lorenzo@kernel.org>,
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
Date:   Thu, 30 Apr 2020 13:20:41 +0200
Message-ID: <158824564171.2172139.3559237147160461915.stgit@firesoul>
In-Reply-To: <158824557985.2172139.4173570969543904434.stgit@firesoul>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This marvell driver mvneta uses PAGE_SIZE frames, which makes it
really easy to convert.  Driver updates rxq and now frame_sz
once per NAPI call.

This driver takes advantage of page_pool PP_FLAG_DMA_SYNC_DEV that
can help reduce the number of cache-lines that need to be flushed
when doing DMA sync for_device. Due to xdp_adjust_tail can grow the
area accessible to the by the CPU (can possibly write into), then max
sync length *after* bpf_prog_run_xdp() needs to be taken into account.

For XDP_TX action the driver is smart and does DMA-sync. When growing
tail this is still safe, because page_pool have DMA-mapped the entire
page size.

Cc: thomas.petazzoni@bootlin.com
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/marvell/mvneta.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 51889770958d..37947949345c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2148,12 +2148,17 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	       struct bpf_prog *prog, struct xdp_buff *xdp,
 	       struct mvneta_stats *stats)
 {
-	unsigned int len;
+	unsigned int len, sync;
+	struct page *page;
 	u32 ret, act;
 
 	len = xdp->data_end - xdp->data_hard_start - pp->rx_offset_correction;
 	act = bpf_prog_run_xdp(prog, xdp);
 
+	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
+	sync = xdp->data_end - xdp->data_hard_start - pp->rx_offset_correction;
+	sync = max(sync, len);
+
 	switch (act) {
 	case XDP_PASS:
 		stats->xdp_pass++;
@@ -2164,9 +2169,8 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		err = xdp_do_redirect(pp->dev, xdp, prog);
 		if (unlikely(err)) {
 			ret = MVNETA_XDP_DROPPED;
-			page_pool_put_page(rxq->page_pool,
-					   virt_to_head_page(xdp->data), len,
-					   true);
+			page = virt_to_head_page(xdp->data);
+			page_pool_put_page(rxq->page_pool, page, sync, true);
 		} else {
 			ret = MVNETA_XDP_REDIR;
 			stats->xdp_redirect++;
@@ -2175,10 +2179,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	}
 	case XDP_TX:
 		ret = mvneta_xdp_xmit_back(pp, xdp);
-		if (ret != MVNETA_XDP_TX)
-			page_pool_put_page(rxq->page_pool,
-					   virt_to_head_page(xdp->data), len,
-					   true);
+		if (ret != MVNETA_XDP_TX) {
+			page = virt_to_head_page(xdp->data);
+			page_pool_put_page(rxq->page_pool, page, sync, true);
+		}
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
@@ -2187,8 +2191,8 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		trace_xdp_exception(pp->dev, prog, act);
 		/* fall through */
 	case XDP_DROP:
-		page_pool_put_page(rxq->page_pool,
-				   virt_to_head_page(xdp->data), len, true);
+		page = virt_to_head_page(xdp->data);
+		page_pool_put_page(rxq->page_pool, page, sync, true);
 		ret = MVNETA_XDP_DROPPED;
 		stats->xdp_drop++;
 		break;
@@ -2320,6 +2324,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(pp->xdp_prog);
 	xdp_buf.rxq = &rxq->xdp_rxq;
+	xdp_buf.frame_sz = PAGE_SIZE;
 
 	/* Fairness NAPI loop */
 	while (rx_proc < budget && rx_proc < rx_todo) {


