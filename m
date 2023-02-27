Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE17A6A3972
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 04:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjB0DXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 22:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjB0DXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 22:23:08 -0500
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DBA9019;
        Sun, 26 Feb 2023 19:23:05 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VcVxEsG_1677468182;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VcVxEsG_1677468182)
          by smtp.aliyun-inc.com;
          Mon, 27 Feb 2023 11:23:02 +0800
Date:   Mon, 27 Feb 2023 11:22:58 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Kai <KaiShen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        chengyou@linux.alibaba.com, guangguan.wang@linux.alibaba.com
Subject: Re: [PATCH] Use percpu ref for wr tx reference
Message-ID: <Y/wiEuwq0Rg/RAPK@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20230224102306.5613-1-KaiShen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224102306.5613-1-KaiShen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 10:23:06AM +0000, Kai wrote:
> Hi all,
> The refcount wr_tx_refcnt may cause cache thrashing problems among
> cores and we can use percpu ref to mitigate this issue here. We
> gain some performance improvement with percpu ref here on our
> customized smc-r verion. Applying cache alignment may also mitigate
> this problem but it seem more reasonable to use percpu ref here.
> 
> Thanks.

Hi Kai,

Thanks for the patch. This is a great find. I am wondering that if you
have the performance data compared with previous version.

The patch format need to be improved:
- subject: [PATCH net-next] net/smc: Use ...
- commit message: Hi all and Thanks are not necessary.

Thanks
Tony Lu

> 
> Signed-off-by: Kai <KaiShen@linux.alibaba.com>
> ---
>  net/smc/smc_core.h |  5 ++++-
>  net/smc/smc_wr.c   | 18 ++++++++++++++++--
>  net/smc/smc_wr.h   |  5 ++---
>  3 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
> index 08b457c2d294..0705e33e2d68 100644
> --- a/net/smc/smc_core.h
> +++ b/net/smc/smc_core.h
> @@ -106,7 +106,10 @@ struct smc_link {
>  	unsigned long		*wr_tx_mask;	/* bit mask of used indexes */
>  	u32			wr_tx_cnt;	/* number of WR send buffers */
>  	wait_queue_head_t	wr_tx_wait;	/* wait for free WR send buf */
> -	atomic_t		wr_tx_refcnt;	/* tx refs to link */
> +	struct {
> +		struct percpu_ref	wr_tx_refs;
> +	} ____cacheline_aligned_in_smp;
> +	struct completion	ref_comp;
>  
>  	struct smc_wr_buf	*wr_rx_bufs;	/* WR recv payload buffers */
>  	struct ib_recv_wr	*wr_rx_ibs;	/* WR recv meta data */
> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> index b0678a417e09..dd923e76139f 100644
> --- a/net/smc/smc_wr.c
> +++ b/net/smc/smc_wr.c
> @@ -648,7 +648,8 @@ void smc_wr_free_link(struct smc_link *lnk)
>  
>  	smc_wr_tx_wait_no_pending_sends(lnk);
>  	wait_event(lnk->wr_reg_wait, (!atomic_read(&lnk->wr_reg_refcnt)));
> -	wait_event(lnk->wr_tx_wait, (!atomic_read(&lnk->wr_tx_refcnt)));
> +	percpu_ref_kill(&lnk->wr_tx_refs);
> +	wait_for_completion(&lnk->ref_comp);
>  
>  	if (lnk->wr_rx_dma_addr) {
>  		ib_dma_unmap_single(ibdev, lnk->wr_rx_dma_addr,
> @@ -847,6 +848,13 @@ void smc_wr_add_dev(struct smc_ib_device *smcibdev)
>  	tasklet_setup(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn);
>  }
>  
> +static void smcr_wr_tx_refs_free(struct percpu_ref *ref)
> +{
> +	struct smc_link *lnk = container_of(ref, struct smc_link, wr_tx_refs);
> +
> +	complete(&lnk->ref_comp);
> +}
> +
>  int smc_wr_create_link(struct smc_link *lnk)
>  {
>  	struct ib_device *ibdev = lnk->smcibdev->ibdev;
> @@ -890,7 +898,13 @@ int smc_wr_create_link(struct smc_link *lnk)
>  	smc_wr_init_sge(lnk);
>  	bitmap_zero(lnk->wr_tx_mask, SMC_WR_BUF_CNT);
>  	init_waitqueue_head(&lnk->wr_tx_wait);
> -	atomic_set(&lnk->wr_tx_refcnt, 0);
> +
> +	rc = percpu_ref_init(&lnk->wr_tx_refs, smcr_wr_tx_refs_free,
> +			     PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
> +	if (rc)
> +		goto dma_unmap;
> +	init_completion(&lnk->ref_comp);
> +
>  	init_waitqueue_head(&lnk->wr_reg_wait);
>  	atomic_set(&lnk->wr_reg_refcnt, 0);
>  	init_waitqueue_head(&lnk->wr_rx_empty_wait);
> diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
> index 45e9b894d3f8..f3008dda222a 100644
> --- a/net/smc/smc_wr.h
> +++ b/net/smc/smc_wr.h
> @@ -63,14 +63,13 @@ static inline bool smc_wr_tx_link_hold(struct smc_link *link)
>  {
>  	if (!smc_link_sendable(link))
>  		return false;
> -	atomic_inc(&link->wr_tx_refcnt);
> +	percpu_ref_get(&link->wr_tx_refs);
>  	return true;
>  }
>  
>  static inline void smc_wr_tx_link_put(struct smc_link *link)
>  {
> -	if (atomic_dec_and_test(&link->wr_tx_refcnt))
> -		wake_up_all(&link->wr_tx_wait);
> +	percpu_ref_put(&link->wr_tx_refs);
>  }
>  
>  static inline void smc_wr_drain_cq(struct smc_link *lnk)
> -- 
> 2.31.1
