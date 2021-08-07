Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D683E33CD
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 08:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhHGGmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 02:42:03 -0400
Received: from relay.sw.ru ([185.231.240.75]:48474 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230297AbhHGGmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 02:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=Y0aAjMVRc2eMCd5br2aos6hJsJXTCYbOLMiB+Wn43ow=; b=mweOF5glY4Bj4Go5i
        Jm0sx5N4aSZowSnbwDmH49ln3HofW+0xGQyxHl8sMrlBphr9ILU1+h0OE3+scf81O9xYR4/nl73Xs
        cnveq2wTplnJ5r91kPqWq9202QD7CeKyuqvDU9C4mfB/KlYmMjd+Hm1PCDQM9CZqA0X5Q2rP8Hc+U
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mCG1b-006hh6-BY; Sat, 07 Aug 2021 09:41:39 +0300
Subject: Re: [PATCH NET] vrf: fix null pointer dereference in
 vrf_finish_output()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <20210806.111412.1329682129695306949.davem@davemloft.net>
 <5ba67c28-1056-e24d-cad3-4b7aaac01111@virtuozzo.com>
 <20210806154227.49ac089d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <11bb7d25-71e2-c49a-4754-8daa52150adb@virtuozzo.com>
Date:   Sat, 7 Aug 2021 09:41:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806154227.49ac089d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/21 1:42 AM, Jakub Kicinski wrote:
> On Fri, 6 Aug 2021 15:53:00 +0300 Vasily Averin wrote:
>> After 14ee70ca89e6 ("vrf: use skb_expand_head in vrf_finish_output")
>> skb->dev  is accessed after skb free.
>> Let's replace skb->dev by dev = skb_dst(skb)->dev:
>> vrf_finish_output() is only called from vrf_output(),
>> it set skb->dev to skb_dst(skb)->dev and calls POSTROUTING netfilter
>> hooks, where output device should not be changed.
>>
>> Fixes: 14ee70ca89e6 ("vrf: use skb_expand_head in vrf_finish_output")
>> Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> 
> Thanks for following up! I decided to pick a similar patch from Dan
> Carpenter [1] because the chunk quoted below is not really necessary.

I still think that my patch version is preferable.
It's better to use vrf_tx_error(dev, skb) because:
a) both rollbacks can use the same net device
b) probably using 'dev' allows to avoid an extra pointer dereference.

Originally, i.e. before fixed patch 14ee70ca89e6, rollback after failed header expand
called the save vrf_tx_error() call. This function does 2 things:  
- increments stats.tx_errors on specified network device
- frees provided skb.

Commit 14ee70ca89e6 replaced skb_realloc_headroom() by skb_expand_head() that frees skb inside,
So vrf_tx_error() call on rollback was replaced with direct increment of  stats.tx_errors.
We cannot use now original skb->dev so our fixup patches replaces it with dev variable already
used in this function.
Though, if we should use the same net device in both rollbacks. It's illogical for me
to change one place and do not change another one. 

If we follow to your decision -- it isn't a problem. skb->dev and skb should be identical.
Though 'skb->dev' does an extra dereference, while dev was used in function and probably
was saved to register.

Thank you,
	Vasily Averin

> [1] https://lore.kernel.org/kernel-janitors/20210806150435.GB15586@kili/
> 
>> @@ -883,7 +883,7 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
>>  	}
>>  
>>  	rcu_read_unlock_bh();
>> -	vrf_tx_error(skb->dev, skb);
>> +	vrf_tx_error(dev, skb);
>>  	return -EINVAL;
>>  }
>>  
> 

