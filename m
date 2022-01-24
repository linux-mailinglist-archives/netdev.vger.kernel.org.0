Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0033499627
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 22:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443919AbiAXU7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 15:59:34 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:23591 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442619AbiAXUzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 15:55:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1643057699; x=1674593699;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=nHiNLCkgEf9z5Kqzg4eastfyk3dGxgQ262HjhHcEk5Q=;
  b=CGOgA295K8VEuVh85zh/u4tl9FHeiPBo1PowaZKtgwnVv8DlqSyKHYZI
   L+18X652n+CO+Mcs6gPxHt++zl5oqpu74OG+8oBu8DLY62zJ8xEvFCiFP
   FwLjucUnzOwRJGFbgqv1A/y9C+nJnDydoBGmqkJaA+WJ19M63FTkVRx18
   g=;
X-IronPort-AV: E=Sophos;i="5.88,313,1635206400"; 
   d="scan'208";a="57694596"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 24 Jan 2022 20:50:55 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com (Postfix) with ESMTPS id E7B30A275E;
        Mon, 24 Jan 2022 20:50:54 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.160.209) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Mon, 24 Jan 2022 20:50:47 +0000
References: <20220123115623.94843-1-42.hyeyoo@gmail.com>
 <f835cbb3-a028-1daf-c038-516dd47ce47c@gmail.com>
 <5cca8bdd-bed0-f26a-6c96-d18947d3a50b@gmail.com>
User-agent: mu4e 1.7.5; emacs 28.0.50
From:   Shay Agroskin <shayagr@amazon.com>
To:     Julian Wiedmann <jwiedmann.dev@gmail.com>
CC:     Hyeonggon Yoo <42.hyeyoo@gmail.com>, <netdev@vger.kernel.org>,
        "Arthur Kiyanovski" <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        "Noam Dagan" <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Sameeh Jubran <sameehj@amazon.com>,
        "Wei Yongjun" <weiyongjun1@huawei.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ena: Do not waste napi skb cache
Date:   Mon, 24 Jan 2022 22:50:05 +0200
In-Reply-To: <5cca8bdd-bed0-f26a-6c96-d18947d3a50b@gmail.com>
Message-ID: <pj41zlmtjk7t9a.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.209]
X-ClientProxiedBy: EX13D16UWB003.ant.amazon.com (10.43.161.194) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Julian Wiedmann <jwiedmann.dev@gmail.com> writes:

> On 24.01.22 10:57, Julian Wiedmann wrote:
>> On 23.01.22 13:56, Hyeonggon Yoo wrote:
>>> By profiling, discovered that ena device driver allocates skb 
>>> by
>>> build_skb() and frees by napi_skb_cache_put(). Because the 
>>> driver
>>> does not use napi skb cache in allocation path, napi skb cache 
>>> is
>>> periodically filled and flushed. This is waste of napi skb 
>>> cache.
>>>
>>> As ena_alloc_skb() is called only in napi, Use 
>>> napi_build_skb()
>>> instead of build_skb() to when allocating skb.
>>>
>>> This patch was tested on aws a1.metal instance.
>>>
>>> Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
>>> ---
>>>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
>>> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>> index c72f0c7ff4aa..2c67fb1703c5 100644
>>> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>> @@ -1407,7 +1407,7 @@ static struct sk_buff 
>>> *ena_alloc_skb(struct ena_ring *rx_ring, void *first_frag)
>>>  		skb = netdev_alloc_skb_ip_align(rx_ring->netdev,
>>>  						rx_ring->rx_copybreak);
>> 
>> To keep things consistent, this should then also be 
>> napi_alloc_skb().
>> 
>
> And on closer look, this copybreak path also looks buggy. If 
> rx_copybreak
> gets reduced _while_ receiving a frame, the allocated skb can 
> end up too
> small to take all the data.
>
> @ ena maintainers: can you please fix this?
>

Updating the copybreak value is done through ena_ethtool.c 
(ena_set_tunable()) which updates `adapter->rx_copybreak`.
The adapter->rx_copybreak value is "propagated back" to the ring 
local attributes (rx_ring->rx_copybreak) only after an interface 
toggle which stops the napi routine first.

Unless I'm missing something here I don't think the bug you're 
describing exists.

I agree that the netdev_alloc_skb_ip_align() can become 
napi_alloc_skb(). Hyeonggon Yoo, can you please apply this change 
as well to this patch?

Thanks,
Shay


>>>  	else
>>> -		skb = build_skb(first_frag, ENA_PAGE_SIZE);
>>> +		skb = napi_build_skb(first_frag, ENA_PAGE_SIZE);
>>>  
>>>  	if (unlikely(!skb)) {
>>>  		ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail, 
>>>  1,
>> 
