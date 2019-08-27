Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF4B9E644
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbfH0LA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:00:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51768 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbfH0LA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 07:00:26 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190827110024euoutp01d823862a92166efe6e2b5bc3d8dac37c~_wot3bNxC1939819398euoutp017
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 11:00:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190827110024euoutp01d823862a92166efe6e2b5bc3d8dac37c~_wot3bNxC1939819398euoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566903624;
        bh=mZQrfwhPHo3NNvmZXOp7eUyIiEKfr48SNN3n8hLi20s=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=MQPOPzoSwiqo8epcJfJTgayzaHOXnIo0fCbECFw4KGJVq9GPEebyFCjjxC6ZEZbqK
         WlhTu0ZXhvD6ZJarbW+LzEJtnjeGldElpaa+GzhqVxC8Lq3Wy+JOJsojVy6vbCMP78
         rhKMQ0ylxPwBl+Tyh6BdC7nQavGGEAfWdtpFL8hQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190827110023eucas1p13a98e6aba2d9c5192b0baebb6ad6a07c~_wos0ywpT0632306323eucas1p1o;
        Tue, 27 Aug 2019 11:00:23 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 9B.5A.04469.74D056D5; Tue, 27
        Aug 2019 12:00:23 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190827110022eucas1p299082bbbb45e872d01614b987645e9f8~_wor0LpWZ1514215142eucas1p2b;
        Tue, 27 Aug 2019 11:00:22 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190827110022eusmtrp2831ff897664c6d9c12353d5c2db9f88e~_worl2gWH0382403824eusmtrp2u;
        Tue, 27 Aug 2019 11:00:22 +0000 (GMT)
X-AuditID: cbfec7f2-569ff70000001175-4b-5d650d47abeb
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 1E.7A.04166.64D056D5; Tue, 27
        Aug 2019 12:00:22 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190827110020eusmtip1dc26f30686fd5fdc55497109932c965a~_woqb88Ke0349703497eusmtip1P;
        Tue, 27 Aug 2019 11:00:20 +0000 (GMT)
Subject: Re: [PATCH net v3] ixgbe: fix double clean of tx descriptors with
 xdp
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Eelco Chaudron <echaudro@redhat.com>,
        William Tu <u9012063@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <3d93da21-0198-2fff-fbbf-3c02c5155f25@samsung.com>
Date:   Tue, 27 Aug 2019 14:00:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826154042.00004bfc@gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsWy7djP87ruvKmxBpuXsVn8n3ubxeLLz9vs
        Fn/aNjBafD5ynM1i8cJvzBZzzrewWNy58pPN4kr7T3aL/7d+s1oce9HCZnFi831Gi8u75rBZ
        zD8/md1ixaET7BbHFohZXL/E4yDgsWXlTSaPnbPusnss3vOSyaPrxiVmj02rOtk8TjaXekzv
        fsjs8X7fVTaPvi2rGD0+b5IL4IrisklJzcksSy3St0vgyvj69AFzwVLlil8Hz7E2MO6V6WLk
        5JAQMJE4+fcfC4gtJLCCUeLzucAuRi4g+wujRNuLbnYI5zOjxP1bu1lgOnofToRKLGeU6D/8
        jQ3C+Qjk3N3OCFIlLBAgca3nJ1iHiIClxJ+VX8E6mAVWskicmwDSwcnBJqAjcWr1EbAGXgE7
        if6115hBbBYBVYnrkyezg9iiAhESnx4cZoWoEZQ4OfMJ2FBOAQOJpRf+gsWZBcQlmr6shLLl
        Jba/ncMMskxCYCqHxImvG6HudpFomnCLEcIWlnh1fAs7hC0j8X/nfCYIu17ifstLRojmDkaJ
        6Yf+QSXsJba8PgfUwAG0QVNi/S59iLCjxM325UwgYQkBPokbbwUhbuCTmLRtOjNEmFeio00I
        olpF4vfB5cwQtpTEzXef2ScwKs1C8tksJN/MQvLNLIS9CxhZVjGKp5YW56anFhvmpZbrFSfm
        Fpfmpesl5+duYgSmwtP/jn/awfj1UtIhRgEORiUeXokzybFCrIllxZW5hxglOJiVRHhz9BNj
        hXhTEiurUovy44tKc1KLDzFKc7AoifNWMzyIFhJITyxJzU5NLUgtgskycXBKNTAarTvwWlWo
        wuYVh2juKWPV3/WG5z+e4j7Ac+KPuMrc5/4xMy/6NGlHfv+5yqM9K//K13SfkMm7K6f/eRR2
        r7JyzzV5RfsArWfOkhtagvepri9Nnr91zi2LaN2ZmpHaplNvcvGbuWllufb3vVwk4fhw89dD
        E73Eymwi7T7xeTBf1OleIpoWfECJpTgj0VCLuag4EQDfNKXlgQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e/4XV033tRYg/MLWSz+z73NYvHl5212
        iz9tGxgtPh85zmaxeOE3Zos551tYLO5c+clmcaX9J7vF/1u/WS2OvWhhszix+T6jxeVdc9gs
        5p+fzG6x4tAJdotjC8Qsrl/icRDw2LLyJpPHzll32T0W73nJ5NF14xKzx6ZVnWweJ5tLPaZ3
        P2T2eL/vKptH35ZVjB6fN8kFcEXp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZ
        Kunb2aSk5mSWpRbp2yXoZXx9+oC5YKlyxa+D51gbGPfKdDFyckgImEj0PpzI3sXIxSEksJRR
        4tfhC2wQCSmJH78usELYwhJ/rnWxQRS9Z5Q4/Rikg5NDWMBP4tfjEywgtoiApcSflV/BJjEL
        rGaRuLj7BhNEx1ZGiad3l4J1sAnoSJxafYQRxOYVsJPoX3uNGcRmEVCVuD55MliNqECExOEd
        s6BqBCVOznwCtoFTwEBi6YW/YCcxC6hL/Jl3iRnCFpdo+rISKi4vsf3tHOYJjEKzkLTPQtIy
        C0nLLCQtCxhZVjGKpJYW56bnFhvqFSfmFpfmpesl5+duYgTG/7ZjPzfvYLy0MfgQowAHoxIP
        r8SZ5Fgh1sSy4srcQ4wSHMxKIrw5+omxQrwpiZVVqUX58UWlOanFhxhNgZ6byCwlmpwPTE15
        JfGGpobmFpaG5sbmxmYWSuK8HQIHY4QE0hNLUrNTUwtSi2D6mDg4pRoYNbkusP92mzu1/uuv
        7I2Z34wZWv1zLopM3/DyhDHjTM24Ez43JDSE/wt2CX3bbWOVe5djpWn6Rpkq9fZdvRYRctX8
        DayzK3Zc+2rr+q2l8DGX0nWBAIEbmy85lM40kt90RLSb9RDXwv983EanUwu1ni8u/Fm1Lsnz
        79Fc4ZOyQavv38rcWfBeiaU4I9FQi7moOBEAQYoIwxUDAAA=
X-CMS-MailID: 20190827110022eucas1p299082bbbb45e872d01614b987645e9f8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190822171243eucas1p12213f2239d6c36be515dade41ed7470b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190822171243eucas1p12213f2239d6c36be515dade41ed7470b
References: <CGME20190822171243eucas1p12213f2239d6c36be515dade41ed7470b@eucas1p1.samsung.com>
        <20190822171237.20798-1-i.maximets@samsung.com>
        <20190826154042.00004bfc@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.08.2019 16:40, Maciej Fijalkowski wrote:
> On Thu, 22 Aug 2019 20:12:37 +0300
> Ilya Maximets <i.maximets@samsung.com> wrote:
> 
>> Tx code doesn't clear the descriptors' status after cleaning.
>> So, if the budget is larger than number of used elems in a ring, some
>> descriptors will be accounted twice and xsk_umem_complete_tx will move
>> prod_tail far beyond the prod_head breaking the completion queue ring.
>>
>> Fix that by limiting the number of descriptors to clean by the number
>> of used descriptors in the tx ring.
>>
>> 'ixgbe_clean_xdp_tx_irq()' function refactored to look more like
>> 'ixgbe_xsk_clean_tx_ring()' since we're allowed to directly use
>> 'next_to_clean' and 'next_to_use' indexes.
>>
>> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>> ---
>>
>> Version 3:
>>   * Reverted some refactoring made for v2.
>>   * Eliminated 'budget' for tx clean.
>>   * prefetch returned.
>>
>> Version 2:
>>   * 'ixgbe_clean_xdp_tx_irq()' refactored to look more like
>>     'ixgbe_xsk_clean_tx_ring()'.
>>
>>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 29 ++++++++------------
>>  1 file changed, 11 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> index 6b609553329f..a3b6d8c89127 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> @@ -633,19 +633,17 @@ static void ixgbe_clean_xdp_tx_buffer(struct ixgbe_ring *tx_ring,
>>  bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
>>  			    struct ixgbe_ring *tx_ring, int napi_budget)
> 
> While you're at it, can you please as well remove the 'napi_budget' argument?
> It wasn't used at all even before your patch.

As you mentioned, this is not related to current patch and this patch doesn't
touch these particular lines of code.  So, I think it's better to make a
separate patch for this if you think it's needed.

> 
> I'm jumping late in, but I was really wondering and hesitated with taking
> part in discussion since the v1 of this patch - can you elaborate why simply
> clearing the DD bit wasn't sufficient?

Clearing the DD bit will end up driver and hardware writing to close memory
locations at the same time leading to cache trashing and poor performance.

Anyway additional write is unnecessary, because we know exactly which descriptors
we need to check.

Best regards, Ilya Maximets.

> 
> Maciej
> 
>>  {
>> +	u16 ntc = tx_ring->next_to_clean, ntu = tx_ring->next_to_use;
>>  	unsigned int total_packets = 0, total_bytes = 0;
>> -	u32 i = tx_ring->next_to_clean, xsk_frames = 0;
>> -	unsigned int budget = q_vector->tx.work_limit;
>>  	struct xdp_umem *umem = tx_ring->xsk_umem;
>>  	union ixgbe_adv_tx_desc *tx_desc;
>>  	struct ixgbe_tx_buffer *tx_bi;
>> -	bool xmit_done;
>> +	u32 xsk_frames = 0;
>>  
>> -	tx_bi = &tx_ring->tx_buffer_info[i];
>> -	tx_desc = IXGBE_TX_DESC(tx_ring, i);
>> -	i -= tx_ring->count;
>> +	tx_bi = &tx_ring->tx_buffer_info[ntc];
>> +	tx_desc = IXGBE_TX_DESC(tx_ring, ntc);
>>  
>> -	do {
>> +	while (ntc != ntu) {
>>  		if (!(tx_desc->wb.status & cpu_to_le32(IXGBE_TXD_STAT_DD)))
>>  			break;
>>  
>> @@ -661,22 +659,18 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
>>  
>>  		tx_bi++;
>>  		tx_desc++;
>> -		i++;
>> -		if (unlikely(!i)) {
>> -			i -= tx_ring->count;
>> +		ntc++;
>> +		if (unlikely(ntc == tx_ring->count)) {
>> +			ntc = 0;
>>  			tx_bi = tx_ring->tx_buffer_info;
>>  			tx_desc = IXGBE_TX_DESC(tx_ring, 0);
>>  		}
>>  
>>  		/* issue prefetch for next Tx descriptor */
>>  		prefetch(tx_desc);
>> +	}
>>  
>> -		/* update budget accounting */
>> -		budget--;
>> -	} while (likely(budget));
>> -
>> -	i += tx_ring->count;
>> -	tx_ring->next_to_clean = i;
>> +	tx_ring->next_to_clean = ntc;
>>  
>>  	u64_stats_update_begin(&tx_ring->syncp);
>>  	tx_ring->stats.bytes += total_bytes;
>> @@ -688,8 +682,7 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
>>  	if (xsk_frames)
>>  		xsk_umem_complete_tx(umem, xsk_frames);
>>  
>> -	xmit_done = ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
>> -	return budget > 0 && xmit_done;
>> +	return ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
>>  }
>>  
>>  int ixgbe_xsk_async_xmit(struct net_device *dev, u32 qid)
> 
> 
> 
