Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BA43E1522
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241528AbhHEMzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:55:35 -0400
Received: from relay.sw.ru ([185.231.240.75]:46324 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232615AbhHEMzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:55:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=k7doBg0e3JXjBZq/zURAjt4EJ5ZAbtwrV59dNqCZYJA=; b=zEm0nOAsAaQ7PAk+4
        10tK5qsVpCEZi2uwaq6GIjMXzj95niq3fpstkC6W5zCcwKpUQHuOt7Sh/uO/bFfIQlki36J6O4MLr
        a4E3SeGJLE2fMRFcupv2UoRVXWxG73CTf21LwyKzvN4RG6YxrYR4WTK08WbzJoSni0j5y0/AXgm+o
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mBcu4-006UwH-E1; Thu, 05 Aug 2021 15:55:16 +0300
Subject: Re: [PATCH NET v3 5/7] vrf: use skb_expand_head in vrf_finish_output
To:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <15eba3b2-80e2-5547-8ad9-167d810ad7e3@virtuozzo.com>
 <cover.1627891754.git.vvs@virtuozzo.com>
 <e4ca1ef1-56f3-5bce-eec8-617e24bc7b1a@virtuozzo.com>
 <ccce7edb-54dd-e6bf-1e84-0ec320d8886c@linux.ibm.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <08c09fff-87f3-b29c-f681-88b031b0bb0d@virtuozzo.com>
Date:   Thu, 5 Aug 2021 15:55:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ccce7edb-54dd-e6bf-1e84-0ec320d8886c@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/21 2:55 PM, Julian Wiedmann wrote:
> On 02.08.21 11:52, Vasily Averin wrote:
>> Unlike skb_realloc_headroom, new helper skb_expand_head
>> does not allocate a new skb if possible.
>>
>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>> ---
>>  drivers/net/vrf.c | 21 +++++++--------------
>>  1 file changed, 7 insertions(+), 14 deletions(-)
>>
> 
> [...]
> 
>>  	/* Be paranoid, rather than too clever. */
>>  	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
>> -		struct sk_buff *skb2;
>> -
>> -		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
>> -		if (!skb2) {
>> -			ret = -ENOMEM;
>> -			goto err;
>> +		skb = skb_expand_head(skb, hh_len);
>> +		if (!skb) {
>> +			skb->dev->stats.tx_errors++;
>> +			return -ENOMEM;
> 
> Hello Vasily,
> 
> FYI, Coverity complains that we check skb != NULL here but then
> still dereference skb->dev:
> 
> 
> *** CID 1506214:  Null pointer dereferences  (FORWARD_NULL)
> /drivers/net/vrf.c: 867 in vrf_finish_output()
> 861     	nf_reset_ct(skb);
> 862     
> 863     	/* Be paranoid, rather than too clever. */
> 864     	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
> 865     		skb = skb_expand_head(skb, hh_len);
> 866     		if (!skb) {
>>>>     CID 1506214:  Null pointer dereferences  (FORWARD_NULL)
>>>>     Dereferencing null pointer "skb".
> 867     			skb->dev->stats.tx_errors++;
> 868     			return -ENOMEM;

My fault, I missed it.

Thank you,
	Vasily Averin
