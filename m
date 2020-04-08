Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CBF1A2031
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgDHLvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:51:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51316 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728635AbgDHLvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ENb/wgFyc7oQywaDTs35uBN70KlmITY0hWEaOb0LE0I=;
        b=eC8v/aXnHf/Lw875yrKzObzbsNPybOMmV11IE+vv6z43nH4CrjGkbRoxoJckbJ9qooZSVN
        3rGSr8ErHlPwmSRTcwHPkZv/Udd6/4QSsKhCFCCURvYDkz1rKve4qqTZbNaqQlW6UKFYnU
        MWn6dCGvRrZ1vN3HwbEDm/ubLd7wBmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-BT6cnCuFOcKb-Y7995uZOg-1; Wed, 08 Apr 2020 07:50:58 -0400
X-MC-Unique: BT6cnCuFOcKb-Y7995uZOg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5EC786A06A;
        Wed,  8 Apr 2020 11:50:55 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8508A5C29A;
        Wed,  8 Apr 2020 11:50:55 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id A8491300020FA;
        Wed,  8 Apr 2020 13:50:54 +0200 (CEST)
Subject: [PATCH RFC v2 04/33] mvneta: add XDP frame size to driver
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
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:50:54 +0200
Message-ID: <158634665461.707275.4537534298639462733.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Cc: thomas.petazzoni@bootlin.com
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/marvell/mvneta.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 5be61f73b6ab..612a6c273970 100644
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


