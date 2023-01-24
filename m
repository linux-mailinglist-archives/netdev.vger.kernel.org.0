Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1595678F38
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 05:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbjAXETW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 23:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbjAXETS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 23:19:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BCC30B03
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 20:19:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55FAAB80EF1
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7D5C433D2;
        Tue, 24 Jan 2023 04:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674533955;
        bh=L5Np3JSo1JcPNlA6vFnAjkemth6ROMdg19gUQ5fr9GM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jOqKm3XAFYxy2iY9HtP6hl2HedOeC+ha10MX+H24bhRVSrJkjNlC6DZuyRS/sbhx7
         AghlyDvoeDtkiqCYilE3IL5jtFZL7PZXYr02hqzRp7QJCerK6rXE5Tlg+QqE3n2Lu3
         IdyjpMA9PPXwkw0N83gaS6d1HDeYbfTj9NgPi3NXNO+CW56J32N5x9R8ewIgsNNp0f
         2wxCMLEiAfee56nuMcv4cN+9+8BzINWDQM9SQsqBECZKQKau0MaFtujWy2uzu0vBOC
         qmzZeKvNn+2HpXtYiLYp7jfX6Jc702j7gFDRUIq2pVL9zsi6W8UqIFMwNRkDB/xK5q
         hpKIj7LXHh4vA==
Date:   Mon, 23 Jan 2023 20:19:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vadim Fedorenko <vadfed@meta.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] mlx5: fix possible ptp queue fifo overflow
Message-ID: <20230123201912.42bc89fc@kernel.org>
In-Reply-To: <20230124000836.20523-2-vfedorenko@novek.ru>
References: <20230124000836.20523-1-vfedorenko@novek.ru>
        <20230124000836.20523-2-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Jan 2023 03:08:35 +0300 Vadim Fedorenko wrote:
> From: Vadim Fedorenko <vadfed@meta.com>
> 
> Fifo pointers are not checked for overflow and this could potentially
> lead to overflow and double free under heavy PTP traffic.
> 
> Also there were accidental OOO cqe which lead to absolutely broken fifo.
> Add checks to workaround OOO cqe and add counters to show the amount of
> such events.

May be worth adding a mention of the brokenness of the empty() check.
Comparing free running counters works well unless C promotes the types
to something wider than the counters themselves. So unsigned or u32
works, but comparing two u16s or u8s needs a explicit cast.

> -static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
> +static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
>  {
>  	struct skb_shared_hwtstamps hwts = {};
>  	struct sk_buff *skb;
>  
>  	ptpsq->cq_stats->resync_event++;
>  
> -	while (skb_cc != skb_id) {
> -		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
> +	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id) {

Are you sure this works for all cases?
Directly comparing indexes of a ring buffer seems dangerous.
We'd need to compare like this:

	(s16)(skb_cc - skb_id) < 0

> +		ptpsq->cq_stats->ooo_cqe++;
> +		return false;
> +	}

> @@ -128,7 +141,8 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>  	ptpsq->cq_stats->cqe++;
>  
>  out:
> -	napi_consume_skb(skb, budget);
> +	if (skb)
> +		napi_consume_skb(skb, budget);

I think napi_consume_skb() takes NULLs.
