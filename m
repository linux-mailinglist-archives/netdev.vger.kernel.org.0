Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A705533CFD5
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhCPI12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:27:28 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:43254 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbhCPI1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:27:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615883238; x=1647419238;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=zjpungGTH797E0EsM/cIKxnB5P6nalPRskz9OyB9ezw=;
  b=uVqRAcqhu2IkAszkrIE8o217vOfSRi2XPGUrZfKGiErFuCYTyfdyTJ5s
   Czj8y4/DaHcl8/HqMO2W3PomWAA11JEZeWOGanYuN6xABwC9tUo6wkriD
   aq4ee4leUXgcaxOpGkpy8qlyDqOn8NMfiwLr7Z8/SFWd9i8763nk88hjb
   g=;
X-IronPort-AV: E=Sophos;i="5.81,251,1610409600"; 
   d="scan'208";a="94855560"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 16 Mar 2021 08:27:11 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 3664EA063A;
        Tue, 16 Mar 2021 08:27:08 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.162.213) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 16 Mar 2021 08:27:00 +0000
References: <20210309171014.2200020-1-shayagr@amazon.com>
 <20210309171014.2200020-2-shayagr@amazon.com>
 <67d3cf28-b1fd-ce51-5011-96ddd783dc71@gmail.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: Re: [RFC Patch v1 1/3] net: ena: implement local page cache (LPC)
 system
In-Reply-To: <67d3cf28-b1fd-ce51-5011-96ddd783dc71@gmail.com>
Date:   Tue, 16 Mar 2021 10:26:47 +0200
Message-ID: <pj41zl7dm7ld14.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.213]
X-ClientProxiedBy: EX13D19UWA001.ant.amazon.com (10.43.160.169) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Eric Dumazet <eric.dumazet@gmail.com> writes:

> On 3/9/21 6:10 PM, Shay Agroskin wrote:
>> The page cache holds pages we allocated in the past during napi 
>> cycle,
>> and tracks their availability status using page ref count.
>> 
>> The cache can hold up to 2048 pages. Upon allocating a page, we 
>> check
>> whether the next entry in the cache contains an unused page, 
>> and if so
>> fetch it. If the next page is already used by another entity or 
>> if it
>> belongs to a different NUMA core than the napi routine, we 
>> allocate a
>> page in the regular way (page from a different NUMA core is 
>> replaced by
>> the newly allocated page).
>> 
>> This system can help us reduce the contention between different 
>> cores
>> when allocating page since every cache is unique to a queue.
>
> For reference, many drivers already use a similar strategy.
>
>> +
>> +/* Fetch the cached page (mark the page as used and pass it to 
>> the caller).
>> + * If the page belongs to a different NUMA than the current 
>> one, free the cache
>> + * page and allocate another one instead.
>> + */
>> +static struct page *ena_fetch_cache_page(struct ena_ring 
>> *rx_ring,
>> +					 struct ena_page 
>> *ena_page,
>> +					 dma_addr_t *dma,
>> +					 int current_nid)
>> +{
>> +	/* Remove pages belonging to different node than 
>> current_nid from cache */
>> +	if (unlikely(page_to_nid(ena_page->page) != current_nid)) 
>> {
>> + 
>> ena_increase_stat(&rx_ring->rx_stats.lpc_wrong_numa, 1, 
>> &rx_ring->syncp);
>> +		ena_replace_cache_page(rx_ring, ena_page);
>> +	}
>> +
>> 
>
> And they use dev_page_is_reusable() instead of copy/pasting this 
> logic.
>
> As a bonus, they properly deal with pfmemalloc

Thanks for reviewing it, and sorry for the time it took me to 
reply, I wanted to test some of the suggestions given me here 
before replying.

Providing that this patchset would still be necessary for our 
driver after testing the patchset Saeed suggested, I will switch 
to using dev_page_is_reusable() instead of this expression.

Shay
