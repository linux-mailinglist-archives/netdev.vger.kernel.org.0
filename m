Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA32D25177E
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgHYLZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:25:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:56581 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgHYLZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 07:25:20 -0400
IronPort-SDR: NVF2vgF+sqcYsLaU1BZXAAd98usdRNGalMGOSjY/+WLo03nVVhN6heW1ri1XfX57hjdZSFYl/m
 TShPVB9w5V5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="136149607"
X-IronPort-AV: E=Sophos;i="5.76,352,1592895600"; 
   d="scan'208";a="136149607"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 04:25:19 -0700
IronPort-SDR: OfAcv590sw3tD8nubF5BemCsespb/1u/MEDinFPhmuXQuv3aSmj3zEV5oy1FZnPjGzV7RY6yKs
 yHQMfUm6FBlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,352,1592895600"; 
   d="scan'208";a="279954927"
Received: from zzombora-mobl1.ti.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.53.19])
  by fmsmga007.fm.intel.com with ESMTP; 25 Aug 2020 04:25:17 -0700
Subject: Re: [PATCH net 1/3] i40e: avoid premature Rx buffer reuse
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, piotr.raczynski@intel.com,
        maciej.machnikowski@intel.com, lirongqing@baidu.com
References: <20200825091629.12949-1-bjorn.topel@gmail.com>
 <20200825091629.12949-2-bjorn.topel@gmail.com>
 <20200825111336.GA38865@ranger.igk.intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <256ab09e-1cea-c8ab-9589-b0c5809bdea7@intel.com>
Date:   Tue, 25 Aug 2020 13:25:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200825111336.GA38865@ranger.igk.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-25 13:13, Maciej Fijalkowski wrote:
> On Tue, Aug 25, 2020 at 11:16:27AM +0200, Björn Töpel wrote:
[...]
>>   	struct i40e_rx_buffer *rx_buffer;
>>   
>>   	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
>> +	*rx_buffer_pgcnt = i40e_rx_buffer_page_count(rx_buffer);
> 
> What i previously meant was:
> 
> #if (PAGE_SIZE < 8192)
> 	*rx_buffer_pgcnt = page_count(rx_buffer->page);
> #endif
> 
> and see below
> 

Right...

>>   	prefetchw(rx_buffer->page);
>>   
>>   	/* we are reusing so sync this buffer for CPU use */
>> @@ -2112,9 +2124,10 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
>>    * either recycle the buffer or unmap it and free the associated resources.
>>    */
>>   static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
>> -			       struct i40e_rx_buffer *rx_buffer)
>> +			       struct i40e_rx_buffer *rx_buffer,
>> +			       int rx_buffer_pgcnt)
>>   {
>> -	if (i40e_can_reuse_rx_page(rx_buffer)) {
>> +	if (i40e_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
>>   		/* hand second half of page back to the ring */
>>   		i40e_reuse_rx_page(rx_ring, rx_buffer);
>>   	} else {
>> @@ -2319,6 +2332,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
>>   	unsigned int xdp_xmit = 0;
>>   	bool failure = false;
>>   	struct xdp_buff xdp;
>> +	int rx_buffer_pgcnt;
> 
> you could move scope this variable only for the
> 
> while (likely(total_rx_packets < (unsigned int)budget))
> 
> loop and init this to 0. then you could drop the helper function you've
> added. and BTW the page_count is not being used for big pages but i agree
> that it's better to have it set to 0.
>

...but isn't it a bit nasty with an output parameter that relies on the 
that the input was set to zero. I guess it's a matter of taste, but I 
find that more error prone.

Let me know if you have strong feelings about this, and I'll respin (but 
I rather not!).


Björn


>>   
>>   #if (PAGE_SIZE < 8192)
>>   	xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
>> @@ -2370,7 +2384,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
>>   			break;
>>   
>>   		i40e_trace(clean_rx_irq, rx_ring, rx_desc, skb);
>> -		rx_buffer = i40e_get_rx_buffer(rx_ring, size);
>> +		rx_buffer = i40e_get_rx_buffer(rx_ring, size, &rx_buffer_pgcnt);
>>   
>>   		/* retrieve a buffer from the ring */
>>   		if (!skb) {
>> @@ -2413,7 +2427,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
>>   			break;
>>   		}
>>   
>> -		i40e_put_rx_buffer(rx_ring, rx_buffer);
>> +		i40e_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
>>   		cleaned_count++;
>>   
>>   		if (i40e_is_non_eop(rx_ring, rx_desc, skb))
>> -- 
>> 2.25.1
>>
