Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D13A5321BE
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 05:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiEXDvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 23:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbiEXDvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 23:51:42 -0400
Received: from mail.meizu.com (unknown [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD6114089;
        Mon, 23 May 2022 20:51:38 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 24 May
 2022 11:51:37 +0800
Received: from [172.16.137.70] (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Tue, 24 May
 2022 11:51:36 +0800
Message-ID: <43b269f3-2970-e75d-34d0-d738a8c1fb81@meizu.com>
Date:   Tue, 24 May 2022 11:51:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH V2] octeon_ep: Remove unnecessary cast
To:     Joe Perches <joe@perches.com>
CC:     <aayarekar@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <vburru@marvell.com>
References: <53b4a92efb83d893230f47ae9988282f3875b355.camel@perches.com>
 <1653362915-22831-1-git-send-email-baihaowen@meizu.com>
 <059725f837c8a869cc2358d2850f6776b05a9fe2.camel@perches.com>
From:   baihaowen <baihaowen@meizu.com>
In-Reply-To: <059725f837c8a869cc2358d2850f6776b05a9fe2.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/24 上午11:48, Joe Perches 写道:
> On Tue, 2022-05-24 at 11:28 +0800, Haowen Bai wrote:
>> ./drivers/net/ethernet/marvell/octeon_ep/octep_rx.c:161:18-40: WARNING:
>> casting value returned by memory allocation function to (struct
>> octep_rx_buffer *) is useless.
> []
>> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
> []
>> @@ -158,8 +158,7 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
>>  		goto desc_dma_alloc_err;
>>  	}
>>  
>> -	oq->buff_info = (struct octep_rx_buffer *)
>> -			vzalloc(oq->max_count * OCTEP_OQ_RECVBUF_SIZE);
>> +	oq->buff_info = vcalloc(oq->max_count, OCTEP_OQ_RECVBUF_SIZE);
> trivia:
>
> Perhaps better to remove the used once #define OCTEP_OQ_RECVBUF_SIZE
> and use the more obvious
>
> 	oq->buff_info = vcalloc(oq->max_count, sizeof(struct octep_rx_buffer));
>
> though I believe the vcalloc may be better as kvcalloc as max_count isn't
> particularly high and struct octep_rx_buffer is small.
>
> Maybe:
> ---
>  drivers/net/ethernet/marvell/octeon_ep/octep_rx.c | 8 ++++----
>  drivers/net/ethernet/marvell/octeon_ep/octep_rx.h | 2 --
>  2 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
> index d9ae0937d17a8..d6a0da61db449 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
> @@ -158,8 +158,8 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
>  		goto desc_dma_alloc_err;
>  	}
>  
> -	oq->buff_info = (struct octep_rx_buffer *)
> -			vzalloc(oq->max_count * OCTEP_OQ_RECVBUF_SIZE);
> +	oq->buff_info = kvcalloc(oq->max_count, sizeof(struct octep_rx_buffer),
> +				 GFP_KERNEL);
>  	if (unlikely(!oq->buff_info)) {
>  		dev_err(&oct->pdev->dev,
>  			"Failed to allocate buffer info for OQ-%d\n", q_no);
> @@ -176,7 +176,7 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
>  	return 0;
>  
>  oq_fill_buff_err:
> -	vfree(oq->buff_info);
> +	kvfree(oq->buff_info);
>  	oq->buff_info = NULL;
>  buf_list_err:
>  	dma_free_coherent(oq->dev, desc_ring_size,
> @@ -230,7 +230,7 @@ static int octep_free_oq(struct octep_oq *oq)
>  
>  	octep_oq_free_ring_buffers(oq);
>  
> -	vfree(oq->buff_info);
> +	kvfree(oq->buff_info);
>  
>  	if (oq->desc_ring)
>  		dma_free_coherent(oq->dev,
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
> index 782a24f27f3e0..34a32d95cd4b3 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
> @@ -67,8 +67,6 @@ struct octep_rx_buffer {
>  	u64 len;
>  };
>  
> -#define OCTEP_OQ_RECVBUF_SIZE    (sizeof(struct octep_rx_buffer))
> -
>  /* Output Queue statistics. Each output queue has four stats fields. */
>  struct octep_oq_stats {
>  	/* Number of packets received from the Device. */
>
>
Good work, thanks for suggestion.

-- 
Haowen Bai

suggestionSynonymsBetasuggestion (noun)idea(generic)thought(generic)suggestion (noun)propositionprofferproposal(generic)suggestion (noun)tracehintsmall indefinite quantity(generic)small indefinite amount(generic)Source: WordNetLanguageToolbasic
