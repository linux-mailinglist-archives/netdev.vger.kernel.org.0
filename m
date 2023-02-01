Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7825B686DC8
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjBASTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjBASTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:19:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B29C7BE7F
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:19:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB62461901
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 18:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497E3C433D2;
        Wed,  1 Feb 2023 18:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675275584;
        bh=bIqbhkmAbN2p5NrwVAVOI6GdXj+9elvsIc+dmN8IT2w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KehwuUyhZiJiPw/tHAedvzYKfQemUyWNrBHy+x3WFAcy9soCAb5S5u0kTM0aK9YdQ
         iJ35rnjDvC8gHjUdGqlrKKZHyCqdb/IiixGvnTTxS7GxZhnWVTMqHwJlgGcV4hbqUR
         OKMCg7MMZoyDbxYkNCyuZudIxOGHsyAW2Wz5lnr/yHepa02Es9dz02s6393k6ebdge
         krR1U2WxMVCB9ZkV9Ndm3wX7dzEV2sXtl89hOh+mZMvN6/phin+AQqFPHYTOxZnOD6
         T4VPX6/9HtaHBNcDzaSqfk7n3Bv4Vz1FHaEpynYgb5/UuBUJCY8/jCvMz3buCv8068
         CywrzTEwvJGWQ==
Date:   Wed, 1 Feb 2023 10:19:42 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v4 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Message-ID: <Y9qtPtTMvZUWtRso@x130>
References: <20230201122605.1350664-1-vadfed@meta.com>
 <20230201122605.1350664-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230201122605.1350664-3-vadfed@meta.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01 Feb 04:26, Vadim Fedorenko wrote:
>Fifo indexes were not checked during pop operations and it leads to
>potential use-after-free when poping from empty queue. Such case was
>possible during re-sync action.
>
>There were out-of-order cqe spotted which lead to drain of the queue and
>use-after-free because of lack of fifo pointers check. Special check
>is added to avoid resync operation if SKB could not exist in the fifo
>because of OOO cqe (skb_id must be between consumer and producer index).
>
>Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
>Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
>---
> .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 23 ++++++++++++++-----
> .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  4 +++-
> 2 files changed, 20 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>index b72de2b520ec..5df726185192 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>@@ -86,7 +86,7 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
> 	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
> }
>
>-static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
>+static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
> 					     u16 skb_id, int budget)
> {
> 	struct skb_shared_hwtstamps hwts = {};
>@@ -94,14 +94,23 @@ static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
>
> 	ptpsq->cq_stats->resync_event++;
>
>-	while (skb_cc != skb_id) {
>-		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>+	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id) {

To avoid returning boolean and add more functionality to this function,
I prefer to put this check in mlx5e_ptp_handle_ts_cqe(), see below.

>+		mlx5_core_err_rl(ptpsq->txqsq.mdev, "out-of-order ptp cqe\n");

it's better to add a counter for this, eg: ptpsq->cq_stats->ooo_cqe_drop++;

>+		return false;
>+	}
>+
>+	while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
> 		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
> 		skb_tstamp_tx(skb, &hwts);
> 		ptpsq->cq_stats->resync_cqe++;
> 		napi_consume_skb(skb, budget);
> 		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
> 	}
>+
>+	if (!skb)
>+		return false;
>+
>+	return true;
> }
>
> static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>@@ -111,7 +120,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
> 	u16 skb_id = PTP_WQE_CTR2IDX(be16_to_cpu(cqe->wqe_counter));
> 	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
> 	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
>-	struct sk_buff *skb;
>+	struct sk_buff *skb = NULL;
> 	ktime_t hwtstamp;
>
> 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
>@@ -120,8 +129,10 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
> 		goto out;
> 	}
>
>-	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
>-		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);

you can check here:
	/* ignore ooo cqe as it was already handled by a previous resync */
	if (ooo_cqe(cqe))
		return; 

>+	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id) &&
>+	    !mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget)) {
>+		goto out;
>+	}
>
> 	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
> 	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>index d5afad368a69..e599b86d94b5 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>@@ -295,13 +295,15 @@ static inline
> void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
> {
> 	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
>-

redundant change.

> 	*skb_item = skb;
> }
>
> static inline
> struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
> {
>+	if (*fifo->pc == *fifo->cc)
>+		return NULL;
>+

I think this won't be necessary if you check for ooo early on
mlx5e_ptp_handle_ts_cqe() like i suggested above.

> 	return *mlx5e_skb_fifo_get(fifo, (*fifo->cc)++);
> }
>
>-- 
>2.30.2
>
