Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34199647AAF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLIAUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiLIAUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:20:35 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1544792333;
        Thu,  8 Dec 2022 16:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670545235; x=1702081235;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=dHem1ATkLRYFiJxaz4bVCi5xygpgc/hx55Rdz+UP1DU=;
  b=H721B5y02yrbRqBJGCo+h1hZ+wRB7WarWTNx7Vws7B9mvK28Qj9xym2W
   Q0MzRYRU1ZkjZivxpzyeFm02x6BaCm5hvJOJq3l6fGe8pHX0JteBmN4pl
   GzTiPBkjhVUwOLSBs0jK+JOGWr/YTUZd1hiyq0EVvAfcVsthihoROq8Cv
   s3mGGJDGnSgWZyCLTkMurn+0xCP7lGY2HNiXns2RjhN/BdlMVYGcikT5J
   qYb1lEIb/9MTkWhe8ZvVu8a91udj6zNKFW8SgUFxuUM675eYM1kVQ2JcC
   zqbA4J+aMjkFlsa2/D+LUAwDC+KkdNxOn+ljSfnkPgk0EewrQvmE0nRJu
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="304983424"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="304983424"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 16:20:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="710696748"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="710696748"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.107.194]) ([10.212.107.194])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 16:20:33 -0800
Message-ID: <b3bb2916-0b08-e7a7-f744-21469e32e080@intel.com>
Date:   Thu, 8 Dec 2022 17:20:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH v2] ntb_netdev: Use dev_kfree_skb_any() in interrupt
 context
Content-Language: en-US
To:     epilmore@gigaio.com, netdev@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        ntb@lists.linux.dev, allenbh@gmail.com, jdmason@kudzu.us
References: <20221209000659.8318-1-epilmore@gigaio.com>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20221209000659.8318-1-epilmore@gigaio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/2022 5:06 PM, epilmore@gigaio.com wrote:
> From: Eric Pilmore <epilmore@gigaio.com>
> 
> TX/RX callback handlers (ntb_netdev_tx_handler(),
> ntb_netdev_rx_handler()) can be called in interrupt
> context via the DMA framework when the respective
> DMA operations have completed. As such, any calls
> by these routines to free skb's, should use the
> interrupt context safe dev_kfree_skb_any() function.
> 
> Previously, these callback handlers would call the
> interrupt unsafe version of dev_kfree_skb(). This has
> not presented an issue on Intel IOAT DMA engines as
> that driver utilizes tasklets rather than a hard
> interrupt handler, like the AMD PTDMA DMA driver.
> On AMD systems, a kernel WARNING message is
> encountered, which is being issued from
> skb_release_head_state() due to in_hardirq()
> being true.
> 
> Besides the user visible WARNING from the kernel,
> the other symptom of this bug was that TCP/IP performance
> across the ntb_netdev interface was very poor, i.e.
> approximately an order of magnitude below what was
> expected. With the repair to use dev_kfree_skb_any(),
> kernel WARNINGs from skb_release_head_state() ceased
> and TCP/IP performance, as measured by iperf, was on
> par with expected results, approximately 20 Gb/s on
> AMD Milan based server. Note that this performance
> is comparable with Intel based servers.
> 
> Fixes: 765ccc7bc3d91 ("ntb_netdev: correct skb leak")
> Fixes: 548c237c0a997 ("net: Add support for NTB virtual ethernet device")
> Signed-off-by: Eric Pilmore <epilmore@gigaio.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

As an FYI for future. Typically you would add the patch revision change 
log under the "---" line just as an FYI for reviewers on what you've 
changed and who suggested the change.

> ---

i.e.

v2:
- Use dev_kfree_skb_any() instead of dev_kfree_skb_irq(). (DaveJ)


>   drivers/net/ntb_netdev.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
> index 80bdc07f2cd3..59250b7accfb 100644
> --- a/drivers/net/ntb_netdev.c
> +++ b/drivers/net/ntb_netdev.c
> @@ -137,7 +137,7 @@ static void ntb_netdev_rx_handler(struct ntb_transport_qp *qp, void *qp_data,
>   enqueue_again:
>   	rc = ntb_transport_rx_enqueue(qp, skb, skb->data, ndev->mtu + ETH_HLEN);
>   	if (rc) {
> -		dev_kfree_skb(skb);
> +		dev_kfree_skb_any(skb);
>   		ndev->stats.rx_errors++;
>   		ndev->stats.rx_fifo_errors++;
>   	}
> @@ -192,7 +192,7 @@ static void ntb_netdev_tx_handler(struct ntb_transport_qp *qp, void *qp_data,
>   		ndev->stats.tx_aborted_errors++;
>   	}
>   
> -	dev_kfree_skb(skb);
> +	dev_kfree_skb_any(skb);
>   
>   	if (ntb_transport_tx_free_entry(dev->qp) >= tx_start) {
>   		/* Make sure anybody stopping the queue after this sees the new
