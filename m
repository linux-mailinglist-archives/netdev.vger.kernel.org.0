Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0722647339
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiLHPg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiLHPgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:36:11 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F591F2EE;
        Thu,  8 Dec 2022 07:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670513711; x=1702049711;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=tx6WgOOXVLV5hrV1QwuXZAr3B29JWv8/BeADXXKDTck=;
  b=dRhyirQyWt23uSSGMCegry6skCJklVhP/lrr1D0eocUUWZkpHCrmdb8v
   99AdAucRp13IyJXNk5tb25FyOAjeS4ZFCBy2SrEV7aKt24RXLti9WiQ13
   4H8ep7QDIe/l2Alej+KuckhoIhVjReF8+DzgQ12ZFIb/RBjgv4NrwyvLX
   YiA8oxtdwraTXN54gw5lLNAFoF9I4fbEns39mY1b/1bRSomXR/hJ6CwrL
   95eQK4P07nLljvtcaKgRKllvbh4iDFHe9LJtUBvoUjxzkwitvySJQj9bI
   aJftQzg3dO5wJEBTqIDyQzo1umM4frA/WROOmzp6e/YLNDtz8W5j30Pe5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="317206948"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="317206948"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 07:35:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="624745533"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="624745533"
Received: from rganeshm-mobl.amr.corp.intel.com (HELO [10.212.107.194]) ([10.212.107.194])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 07:35:09 -0800
Message-ID: <dfd8dd16-64ed-33ef-7dd3-5c501ce99cff@intel.com>
Date:   Thu, 8 Dec 2022 08:35:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH] ntb_netdev: Use dev_kfree_skb_irq() in interrupt context
Content-Language: en-US
To:     epilmore@gigaio.com, netdev@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        ntb@lists.linux.dev, allenbh@gmail.com, jdmason@kudzu.us
References: <63914879.CJDc0NszG7y0lmQT%epilmore@gigaio.com>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <63914879.CJDc0NszG7y0lmQT%epilmore@gigaio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/2022 7:14 PM, epilmore@gigaio.com wrote:
> From: Eric Pilmore <epilmore@gigaio.com>
> 
> TX/RX callback handlers (ntb_netdev_tx_handler(),
> ntb_netdev_rx_handler()) can be called in interrupt
> context via the DMA framework when the respective
> DMA operations have completed. As such, any calls
> by these routines to free skb's, should use the
> interrupt context safe dev_kfree_skb_irq() function.
> 
> Previously, these callback handlers would call the
> interrupt unsafe version of dev_kfree_skb(). Although
> this does not seem to present an issue when the
> underlying DMA engine being utilized is Intel IOAT,
> a kernel WARNING message was being encountered when
> PTDMA DMA engine was utilized on AMD platforms. The
> WARNING was being issued from skb_release_head_state()
> due to in_hardirq() being true.
> 
> Besides the user visible WARNING from the kernel,
> the other symptom of this bug was that TCP/IP performance
> across the ntb_netdev interface was very poor, i.e.
> approximately an order of magnitude below what was
> expected. With the repair to use dev_kfree_skb_irq(),
> kernel WARNINGs from skb_release_head_state() ceased
> and TCP/IP performance, as measured by iperf, was on
> par with expected results, approximately 20 Gb/s on
> AMD Milan based server. Note that this performance
> is comparable with Intel based servers.
> 
> Fixes: 765ccc7bc3d91 ("ntb_netdev: correct skb leak")
> Fixes: 548c237c0a997 ("net: Add support for NTB virtual ethernet device")
> Signed-off-by: Eric Pilmore <epilmore@gigaio.com>

Hi Eric,

Thanks for submitting this. I think the reason is ptdma runs everything 
in the hard interrupt handler while ioatdma runs interrupt handling in a 
tasklet. I just took a look at the function definitions in netdevice.h, 
and I think the call you want to use is dev_kfree_skb_any(). It handles 
being freed depending on the context for you.

> ---
>   drivers/net/ntb_netdev.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
> index 80bdc07..283e23c 100644
> --- a/drivers/net/ntb_netdev.c
> +++ b/drivers/net/ntb_netdev.c
> @@ -137,7 +137,7 @@ static void ntb_netdev_rx_handler(struct ntb_transport_qp *qp, void *qp_data,
>   enqueue_again:
>   	rc = ntb_transport_rx_enqueue(qp, skb, skb->data, ndev->mtu + ETH_HLEN);
>   	if (rc) {
> -		dev_kfree_skb(skb);
> +		dev_kfree_skb_irq(skb);
>   		ndev->stats.rx_errors++;
>   		ndev->stats.rx_fifo_errors++;
>   	}
> @@ -192,7 +192,7 @@ static void ntb_netdev_tx_handler(struct ntb_transport_qp *qp, void *qp_data,
>   		ndev->stats.tx_aborted_errors++;
>   	}
>   
> -	dev_kfree_skb(skb);
> +	dev_kfree_skb_irq(skb);
>   
>   	if (ntb_transport_tx_free_entry(dev->qp) >= tx_start) {
>   		/* Make sure anybody stopping the queue after this sees the new
