Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46C833CFC6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhCPIYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:24:16 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:33511 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbhCPIYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615883041; x=1647419041;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=qMpz63WgelY7FYysAHLUWBGwT7/Pv9Z9Q/OBQ3wkXBg=;
  b=r5Ul2uIhj186CiRqhKvH4yc/zVEcSSs4QAqX+EPhxgmzHr+glbVOAWi7
   S0zzacStsgz5uDAQb70VqPj208alaAaTWV1YyyKV3+I5gzSBnlB6pKhBE
   s4Wv50ohIovgTE1EL9OWhT3ySKOT+TSEd6JY9VdmgL+D36wNvOWHS4xp0
   E=;
X-IronPort-AV: E=Sophos;i="5.81,251,1610409600"; 
   d="scan'208";a="97681414"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 16 Mar 2021 08:23:53 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id CBB293221E5;
        Tue, 16 Mar 2021 08:23:51 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.162.68) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 16 Mar 2021 08:23:41 +0000
References: <20210309171014.2200020-1-shayagr@amazon.com>
 <20210309171014.2200020-2-shayagr@amazon.com>
 <67d3cf28-b1fd-ce51-5011-96ddd783dc71@gmail.com>
 <YEgpL4xYSa7/r38v@lunn.ch>
 <2d02f09799f90c2c948c9156e2d81b0e1adedc27.camel@kernel.org>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Matteo Croce <mcroce@microsoft.com>,
        David Miller <davem@davemloft.net>,
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
In-Reply-To: <2d02f09799f90c2c948c9156e2d81b0e1adedc27.camel@kernel.org>
Date:   Tue, 16 Mar 2021 10:23:29 +0200
Message-ID: <pj41zla6r3ld6m.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.68]
X-ClientProxiedBy: EX13D31UWC004.ant.amazon.com (10.43.162.27) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Saeed Mahameed <saeed@kernel.org> writes:

> On Wed, 2021-03-10 at 03:04 +0100, Andrew Lunn wrote:
>> On Tue, Mar 09, 2021 at 06:57:06PM +0100, Eric Dumazet wrote:
>> > 
>> > 
>> > On 3/9/21 6:10 PM, Shay Agroskin wrote:
>> > > The page cache holds pages we allocated in the past during 
>> > > napi
>> > > cycle,
>> > > and tracks their availability status using page ref count.
>> > > 
>> > > The cache can hold up to 2048 pages. Upon allocating a 
>> > > page, we
>
> 2048 per core ? IMHO this is too much ! ideally you want twice 
> the napi
> budget.
>
> you are trying to mitigate against TCP/L4 delays/congestion but 
> this is
> very prone to DNS attacks, if your memory allocators are under 
> stress,
> you shouldn't be hogging own pages and worsen the situation.

First of all, thank you for taking a look in this patchset.

We are trying to mitigate a simultaneous access to a shared 
resource, the buddy allocator.
When using local caches, I reduce the number of accesses to this 
shared resource by about 90%, thus
avoiding this contention.

I might not understand you correctly, but this patch doesn't try 
to mitigate network peaks. I agree that we're hogging quite a lot 
of system's resources, I'll run some tests with smaller cache size 
(e.g. 2x napi badget) and see if it mitigates the problem we have

>
>> > > check
>> > > whether the next entry in the cache contains an unused 
>> > > page, and
>> > > if so
>> > > fetch it. If the next page is already used by another 
>> > > entity or
>> > > if it
>> > > belongs to a different NUMA core than the napi routine, we
>> > > allocate a
>> > > page in the regular way (page from a different NUMA core is
>> > > replaced by
>> > > the newly allocated page).
>> > > 
>> > > This system can help us reduce the contention between 
>> > > different
>> > > cores
>> > > when allocating page since every cache is unique to a 
>> > > queue.
>> > 
>> > For reference, many drivers already use a similar strategy.
>> 
>> Hi Eric
>> 
>> So rather than yet another implementation, should we push for a
>> generic implementation which any driver can use?
>> 
>
> We already have it:
> https://www.kernel.org/doc/html/latest/networking/page_pool.html

Yup the original page pool implementation didn't suit our needs 
since we never got to free the pages using its specialized 
function for non-XDP traffic.

>
> also please checkout this fresh page pool extension, SKB buffer
> recycling RFC, might be useful for the use cases ena are 
> interested in
>
> https://patchwork.kernel.org/project/netdevbpf/patch/20210311194256.53706-4-mcroce@linux.microsoft.com/

Gone over the code and ran some tests with this patchset. On first 
look it seems like it does allow us to mitigate the problem this 
patchset solves. I'll run
more tests with it and report on this thread my conclusions.

Thanks a lot for pointing it out (:

Shay
