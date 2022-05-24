Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE25321C5
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 05:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiEXDyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 23:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiEXDyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 23:54:53 -0400
X-Greylist: delayed 377 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 May 2022 20:54:48 PDT
Received: from relay5.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944D619C39
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 20:54:48 -0700 (PDT)
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay12.hostedemail.com (Postfix) with ESMTP id 8940C12122F;
        Tue, 24 May 2022 03:48:26 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id 1286133;
        Tue, 24 May 2022 03:48:24 +0000 (UTC)
Message-ID: <059725f837c8a869cc2358d2850f6776b05a9fe2.camel@perches.com>
Subject: Re: [PATCH V2] octeon_ep: Remove unnecessary cast
From:   Joe Perches <joe@perches.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     aayarekar@marvell.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, vburru@marvell.com
Date:   Mon, 23 May 2022 20:48:23 -0700
In-Reply-To: <1653362915-22831-1-git-send-email-baihaowen@meizu.com>
References: <53b4a92efb83d893230f47ae9988282f3875b355.camel@perches.com>
         <1653362915-22831-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1286133
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        KHOP_HELO_FCRDNS,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: nbi59nttrgdusdhc88kjjkmud95f4jgs
X-Rspamd-Server: rspamout05
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+zKR9n5HX/Xvgk3N8wPQegGzzObIC9pgQ=
X-HE-Tag: 1653364104-300972
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-24 at 11:28 +0800, Haowen Bai wrote:
> ./drivers/net/ethernet/marvell/octeon_ep/octep_rx.c:161:18-40: WARNING:
> casting value returned by memory allocation function to (struct
> octep_rx_buffer *) is useless.
[]
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
[]
> @@ -158,8 +158,7 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
>  		goto desc_dma_alloc_err;
>  	}
>  
> -	oq->buff_info = (struct octep_rx_buffer *)
> -			vzalloc(oq->max_count * OCTEP_OQ_RECVBUF_SIZE);
> +	oq->buff_info = vcalloc(oq->max_count, OCTEP_OQ_RECVBUF_SIZE);

trivia:

Perhaps better to remove the used once #define OCTEP_OQ_RECVBUF_SIZE
and use the more obvious

	oq->buff_info = vcalloc(oq->max_count, sizeof(struct octep_rx_buffer));

though I believe the vcalloc may be better as kvcalloc as max_count isn't
particularly high and struct octep_rx_buffer is small.

Maybe:
---
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c | 8 ++++----
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.h | 2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
index d9ae0937d17a8..d6a0da61db449 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -158,8 +158,8 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
 		goto desc_dma_alloc_err;
 	}
 
-	oq->buff_info = (struct octep_rx_buffer *)
-			vzalloc(oq->max_count * OCTEP_OQ_RECVBUF_SIZE);
+	oq->buff_info = kvcalloc(oq->max_count, sizeof(struct octep_rx_buffer),
+				 GFP_KERNEL);
 	if (unlikely(!oq->buff_info)) {
 		dev_err(&oct->pdev->dev,
 			"Failed to allocate buffer info for OQ-%d\n", q_no);
@@ -176,7 +176,7 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
 	return 0;
 
 oq_fill_buff_err:
-	vfree(oq->buff_info);
+	kvfree(oq->buff_info);
 	oq->buff_info = NULL;
 buf_list_err:
 	dma_free_coherent(oq->dev, desc_ring_size,
@@ -230,7 +230,7 @@ static int octep_free_oq(struct octep_oq *oq)
 
 	octep_oq_free_ring_buffers(oq);
 
-	vfree(oq->buff_info);
+	kvfree(oq->buff_info);
 
 	if (oq->desc_ring)
 		dma_free_coherent(oq->dev,
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
index 782a24f27f3e0..34a32d95cd4b3 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
@@ -67,8 +67,6 @@ struct octep_rx_buffer {
 	u64 len;
 };
 
-#define OCTEP_OQ_RECVBUF_SIZE    (sizeof(struct octep_rx_buffer))
-
 /* Output Queue statistics. Each output queue has four stats fields. */
 struct octep_oq_stats {
 	/* Number of packets received from the Device. */


