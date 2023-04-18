Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985C96E65F4
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 15:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjDRNbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 09:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjDRNbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 09:31:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A001545C
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 06:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681824655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s+Y/+d2DHAvX2dx/BnZZeyLeqZ6PrSxKqotJvAsNqb8=;
        b=Z+gAD5mQW0wA8E296qvxBuZoDJy+tVjVXct/0fpz6Q24rn6JN2UJ2rmZuNTKbUYCJpv6oF
        JsM4X8XCzvBwrQS1tmh0ZRg7tk7YpVc9cFxF6/7ob71HqgreOpbdoQUJcBOYpUjWFkBQOa
        GeTZ5Sg03esmi5BYAUUUvfahZkyTY7Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-M3qm-VqHPhe-2EZbfBelfg-1; Tue, 18 Apr 2023 09:30:49 -0400
X-MC-Unique: M3qm-VqHPhe-2EZbfBelfg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCAD93850546;
        Tue, 18 Apr 2023 13:30:48 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7708F40C6E70;
        Tue, 18 Apr 2023 13:30:48 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id CCEBD307372E8;
        Tue, 18 Apr 2023 15:30:47 +0200 (CEST)
Subject: [PATCH bpf-next V2 2/5] igc: add igc_xdp_buff wrapper for xdp_buff in
 driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, yoong.siang.song@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net
Date:   Tue, 18 Apr 2023 15:30:47 +0200
Message-ID: <168182464779.616355.3761989884165609387.stgit@firesoul>
In-Reply-To: <168182460362.616355.14591423386485175723.stgit@firesoul>
References: <168182460362.616355.14591423386485175723.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver specific metadata data for XDP-hints kfuncs are propagated via tail
extending the struct xdp_buff with a locally scoped driver struct.

Zero-Copy AF_XDP/XSK does similar tricks via struct xdp_buff_xsk. This
xdp_buff_xsk struct contains a CB area (24 bytes) that can be used for
extending the locally scoped driver into. The XSK_CHECK_PRIV_TYPE define
catch size violations build time.

The changes needed for AF_XDP zero-copy in igc_clean_rx_irq_zc()
is done in next patch, because the member rx_desc isn't available
at this point.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |    5 +++++
 drivers/net/ethernet/intel/igc/igc_main.c |   16 +++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index f7f9e217e7b4..76a5115aefc8 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -499,6 +499,11 @@ struct igc_rx_buffer {
 	};
 };
 
+/* context wrapper around xdp_buff to provide access to descriptor metadata */
+struct igc_xdp_buff {
+	struct xdp_buff xdp;
+};
+
 struct igc_q_vector {
 	struct igc_adapter *adapter;    /* backlink */
 	void __iomem *itr_register;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index bfa9768d447f..6a4c7cd706bd 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2236,6 +2236,8 @@ static bool igc_alloc_rx_buffers_zc(struct igc_ring *ring, u16 count)
 	if (!count)
 		return ok;
 
+	XSK_CHECK_PRIV_TYPE(struct igc_xdp_buff);
+
 	desc = IGC_RX_DESC(ring, i);
 	bi = &ring->rx_buffer_info[i];
 	i -= ring->count;
@@ -2520,8 +2522,8 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		union igc_adv_rx_desc *rx_desc;
 		struct igc_rx_buffer *rx_buffer;
 		unsigned int size, truesize;
+		struct igc_xdp_buff ctx;
 		ktime_t timestamp = 0;
-		struct xdp_buff xdp;
 		int pkt_offset = 0;
 		void *pktbuf;
 
@@ -2555,13 +2557,13 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		}
 
 		if (!skb) {
-			xdp_init_buff(&xdp, truesize, &rx_ring->xdp_rxq);
-			xdp_prepare_buff(&xdp, pktbuf - igc_rx_offset(rx_ring),
+			xdp_init_buff(&ctx.xdp, truesize, &rx_ring->xdp_rxq);
+			xdp_prepare_buff(&ctx.xdp, pktbuf - igc_rx_offset(rx_ring),
 					 igc_rx_offset(rx_ring) + pkt_offset,
 					 size, true);
-			xdp_buff_clear_frags_flag(&xdp);
+			xdp_buff_clear_frags_flag(&ctx.xdp);
 
-			skb = igc_xdp_run_prog(adapter, &xdp);
+			skb = igc_xdp_run_prog(adapter, &ctx.xdp);
 		}
 
 		if (IS_ERR(skb)) {
@@ -2583,9 +2585,9 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		} else if (skb)
 			igc_add_rx_frag(rx_ring, rx_buffer, skb, size);
 		else if (ring_uses_build_skb(rx_ring))
-			skb = igc_build_skb(rx_ring, rx_buffer, &xdp);
+			skb = igc_build_skb(rx_ring, rx_buffer, &ctx.xdp);
 		else
-			skb = igc_construct_skb(rx_ring, rx_buffer, &xdp,
+			skb = igc_construct_skb(rx_ring, rx_buffer, &ctx.xdp,
 						timestamp);
 
 		/* exit if we failed to retrieve a buffer */


