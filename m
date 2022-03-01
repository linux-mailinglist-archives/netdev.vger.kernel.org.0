Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410744C8911
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiCAKPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiCAKPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:15:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23508CDB1;
        Tue,  1 Mar 2022 02:14:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60EC16168B;
        Tue,  1 Mar 2022 10:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DF8C340EE;
        Tue,  1 Mar 2022 10:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646129659;
        bh=0ApaxExizHW9c7rec5pm0t6p9PGpcfEeEp2/dee59tM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NmL7A99DvkAswGQH4saINvmJktA9R5Od1PI53ms90OYKRgQ2Va1gr8Yn2lQjkyrp5
         CP2QrQcfbUAcBlFDXqEfuP/UyAfut5kvxvmgDuhCAlx/LW9oXJ9dU5PEcROeSbtXwf
         KzuUJaBURBJ4k5+TUvJQZFpJsknkiSTylydlhJhVxQTfHxP1Grf8EflDzPF/Gfo+KH
         w0yS+b5O7S7O362m/VCnQRGK37RGILKa91BUsBLxv1u9kIh7GMMD63MTmoNRdoeRbt
         yP3SvbPXTdlYzF+MXA0L/lhvw7nDg3nry1sqYqJGcRTdqlxPRyUtSIFfj0yNvHGUe6
         0hgCf9zBM8szA==
Date:   Tue, 1 Mar 2022 12:14:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 6/7] net/smc: don't req_notify until all CQEs
 drained
Message-ID: <Yh3x93sPCS+w/Eth@unreal>
References: <20220301094402.14992-1-dust.li@linux.alibaba.com>
 <20220301094402.14992-7-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301094402.14992-7-dust.li@linux.alibaba.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 05:44:01PM +0800, Dust Li wrote:
> When we are handling softirq workload, enable hardirq may
> again interrupt the current routine of softirq, and then
> try to raise softirq again. This only wastes CPU cycles
> and won't have any real gain.
> 
> Since IB_CQ_REPORT_MISSED_EVENTS already make sure if
> ib_req_notify_cq() returns 0, it is safe to wait for the
> next event, with no need to poll the CQ again in this case.
> 
> This patch disables hardirq during the processing of softirq,
> and re-arm the CQ after softirq is done. Somehow like NAPI.
> 
> Co-developed-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/smc/smc_wr.c | 49 +++++++++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
> 
> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> index 24be1d03fef9..34d616406d51 100644
> --- a/net/smc/smc_wr.c
> +++ b/net/smc/smc_wr.c
> @@ -137,25 +137,28 @@ static void smc_wr_tx_tasklet_fn(struct tasklet_struct *t)
>  {
>  	struct smc_ib_device *dev = from_tasklet(dev, t, send_tasklet);
>  	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
> -	int i = 0, rc;
> -	int polled = 0;
> +	int i, rc;
>  
>  again:
> -	polled++;
>  	do {
>  		memset(&wc, 0, sizeof(wc));
>  		rc = ib_poll_cq(dev->roce_cq_send, SMC_WR_MAX_POLL_CQE, wc);
> -		if (polled == 1) {
> -			ib_req_notify_cq(dev->roce_cq_send,
> -					 IB_CQ_NEXT_COMP |
> -					 IB_CQ_REPORT_MISSED_EVENTS);
> -		}
> -		if (!rc)
> -			break;
>  		for (i = 0; i < rc; i++)
>  			smc_wr_tx_process_cqe(&wc[i]);
> +		if (rc < SMC_WR_MAX_POLL_CQE)
> +			/* If < SMC_WR_MAX_POLL_CQE, the CQ should have been
> +			 * drained, no need to poll again. --Guangguan Wang

1. Please remove "--Guangguan Wang".
2. We already discussed that. SMC should be changed to use RDMA CQ pool API
drivers/infiniband/core/cq.c. 
ib_poll_handler() has much better implementation (tracing, IRQ rescheduling,
proper error handling) than this SMC variant.

Thanks

> +			 */
> +			break;
>  	} while (rc > 0);
> -	if (polled == 1)
> +
> +	/* IB_CQ_REPORT_MISSED_EVENTS make sure if ib_req_notify_cq() returns
> +	 * 0, it is safe to wait for the next event.
> +	 * Else we must poll the CQ again to make sure we won't miss any event
> +	 */
> +	if (ib_req_notify_cq(dev->roce_cq_send,
> +			     IB_CQ_NEXT_COMP |
> +			     IB_CQ_REPORT_MISSED_EVENTS))
>  		goto again;
>  }
>  
> @@ -478,24 +481,28 @@ static void smc_wr_rx_tasklet_fn(struct tasklet_struct *t)
>  {
>  	struct smc_ib_device *dev = from_tasklet(dev, t, recv_tasklet);
>  	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
> -	int polled = 0;
>  	int rc;
>  
>  again:
> -	polled++;
>  	do {
>  		memset(&wc, 0, sizeof(wc));
>  		rc = ib_poll_cq(dev->roce_cq_recv, SMC_WR_MAX_POLL_CQE, wc);
> -		if (polled == 1) {
> -			ib_req_notify_cq(dev->roce_cq_recv,
> -					 IB_CQ_SOLICITED_MASK
> -					 | IB_CQ_REPORT_MISSED_EVENTS);
> -		}
> -		if (!rc)
> +		if (rc > 0)
> +			smc_wr_rx_process_cqes(&wc[0], rc);
> +		if (rc < SMC_WR_MAX_POLL_CQE)
> +			/* If < SMC_WR_MAX_POLL_CQE, the CQ should have been
> +			 * drained, no need to poll again. --Guangguan Wang
> +			 */
>  			break;
> -		smc_wr_rx_process_cqes(&wc[0], rc);
>  	} while (rc > 0);
> -	if (polled == 1)
> +
> +	/* IB_CQ_REPORT_MISSED_EVENTS make sure if ib_req_notify_cq() returns
> +	 * 0, it is safe to wait for the next event.
> +	 * Else we must poll the CQ again to make sure we won't miss any event
> +	 */
> +	if (ib_req_notify_cq(dev->roce_cq_recv,
> +			     IB_CQ_SOLICITED_MASK |
> +			     IB_CQ_REPORT_MISSED_EVENTS))
>  		goto again;
>  }
>  
> -- 
> 2.19.1.3.ge56e4f7
> 
