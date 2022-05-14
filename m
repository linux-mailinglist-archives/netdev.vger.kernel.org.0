Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB6D526E83
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiENGDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 02:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiENGC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 02:02:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920EC3DDC8;
        Fri, 13 May 2022 23:02:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2AC57CE0016;
        Sat, 14 May 2022 06:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A30CC340EE;
        Sat, 14 May 2022 06:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652508174;
        bh=wfB+/wuC1y/EiPChFFWDf4KU+v7Xgi38qiJISd0bImo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jI3SAyZlIcP8a6KdcyY0kfLK9bMfgzDdz9T7f4rdCb99rYpxGwMxXxR3wIas18oPh
         x+OSIg7nr6d+XjUHc9X1Ed2Rebo2ulM+mgih5d9J+8WzOoLAWBZ01uKQiqXE5mVHWJ
         2xojd7Qvc+VU1TKXsPsniGaeS7H9RzRg5cKqoGNMYctyKl+IZYLBm1L+IF41D+gHzY
         xKiYmSkouaQyedJVbAZLc2P/FynN53WGfIcLiPp6zuR+UNO7DZng3kV6pmmXPmp5gq
         yGx6ywgVxGzo6fPJBhsDCKVUElXNPIciB9cwRnxd7wCFMXSs4wvrE7YrjQHyrOQSXc
         PVuWFmm+psstg==
Date:   Sat, 14 May 2022 09:02:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net/smc: send cdc msg inline if qp has
 sufficient inline space
Message-ID: <Yn9GB3QwHiY/vtdc@unreal>
References: <20220513071551.22065-1-guangguan.wang@linux.alibaba.com>
 <20220513071551.22065-2-guangguan.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513071551.22065-2-guangguan.wang@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:15:50PM +0800, Guangguan Wang wrote:
> As cdc msg's length is 44B, cdc msgs can be sent inline in
> most rdma devices, which can help reducing sending latency.
> 
> In my test environment, which are 2 VMs running on the same
> physical host and whose NICs(ConnectX-4Lx) are working on
> SR-IOV mode, qperf shows 0.4us-0.7us improvement in latency.
> 
> Test command:
> server: smc_run taskset -c 1 qperf
> client: smc_run taskset -c 1 qperf <server ip> -oo \
> 		msg_size:1:2K:*2 -t 30 -vu tcp_lat
> 
> The results shown below:
> msgsize     before       after
> 1B          11.9 us      11.2 us (-0.7 us)
> 2B          11.7 us      11.2 us (-0.5 us)
> 4B          11.7 us      11.3 us (-0.4 us)
> 8B          11.6 us      11.2 us (-0.4 us)
> 16B         11.7 us      11.3 us (-0.4 us)
> 32B         11.7 us      11.3 us (-0.4 us)
> 64B         11.7 us      11.2 us (-0.5 us)
> 128B        11.6 us      11.2 us (-0.4 us)
> 256B        11.8 us      11.2 us (-0.6 us)
> 512B        11.8 us      11.4 us (-0.4 us)
> 1KB         11.9 us      11.4 us (-0.5 us)
> 2KB         12.1 us      11.5 us (-0.6 us)
> 
> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> ---
>  net/smc/smc_ib.c | 1 +
>  net/smc/smc_wr.c | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
> index a3e2d3b89568..1dcce9e4f4ca 100644
> --- a/net/smc/smc_ib.c
> +++ b/net/smc/smc_ib.c
> @@ -671,6 +671,7 @@ int smc_ib_create_queue_pair(struct smc_link *lnk)
>  			.max_recv_wr = SMC_WR_BUF_CNT * 3,
>  			.max_send_sge = SMC_IB_MAX_SEND_SGE,
>  			.max_recv_sge = sges_per_buf,
> +			.max_inline_data = SMC_WR_TX_SIZE,
>  		},
>  		.sq_sig_type = IB_SIGNAL_REQ_WR,
>  		.qp_type = IB_QPT_RC,
> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> index 24be1d03fef9..8a2f9a561197 100644
> --- a/net/smc/smc_wr.c
> +++ b/net/smc/smc_wr.c
> @@ -554,10 +554,11 @@ void smc_wr_remember_qp_attr(struct smc_link *lnk)
>  static void smc_wr_init_sge(struct smc_link *lnk)
>  {
>  	int sges_per_buf = (lnk->lgr->smc_version == SMC_V2) ? 2 : 1;
> +	bool send_inline = (lnk->qp_attr.cap.max_inline_data >= SMC_WR_TX_SIZE);

When will it be false? You are creating QPs with max_inline_data == SMC_WR_TX_SIZE?

>  	u32 i;
>  
>  	for (i = 0; i < lnk->wr_tx_cnt; i++) {
> -		lnk->wr_tx_sges[i].addr =
> +		lnk->wr_tx_sges[i].addr = send_inline ? (u64)(&lnk->wr_tx_bufs[i]) :
>  			lnk->wr_tx_dma_addr + i * SMC_WR_BUF_SIZE;
>  		lnk->wr_tx_sges[i].length = SMC_WR_TX_SIZE;
>  		lnk->wr_tx_sges[i].lkey = lnk->roce_pd->local_dma_lkey;
> @@ -575,6 +576,8 @@ static void smc_wr_init_sge(struct smc_link *lnk)
>  		lnk->wr_tx_ibs[i].opcode = IB_WR_SEND;
>  		lnk->wr_tx_ibs[i].send_flags =
>  			IB_SEND_SIGNALED | IB_SEND_SOLICITED;
> +		if (send_inline)
> +			lnk->wr_tx_ibs[i].send_flags |= IB_SEND_INLINE;

If you try to transfer data == SMC_WR_TX_SIZE, you will get -ENOMEM error.
IB drivers check that length < qp->max_inline_data.

Thanks

>  		lnk->wr_tx_rdmas[i].wr_tx_rdma[0].wr.opcode = IB_WR_RDMA_WRITE;
>  		lnk->wr_tx_rdmas[i].wr_tx_rdma[1].wr.opcode = IB_WR_RDMA_WRITE;
>  		lnk->wr_tx_rdmas[i].wr_tx_rdma[0].wr.sg_list =
> -- 
> 2.24.3 (Apple Git-128)
> 
