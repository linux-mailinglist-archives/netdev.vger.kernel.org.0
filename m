Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DD12BBA62
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgKTXwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:52:20 -0500
Received: from static-71-183-126-102.nycmny.fios.verizon.net ([71.183.126.102]:58288
        "EHLO chicken.badula.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgKTXwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:52:19 -0500
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2020 18:52:19 EST
Received: from chicken.badula.org (localhost [127.0.0.1])
        by chicken.badula.org (8.14.4/8.14.4) with ESMTP id 0AKNgIfo024926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 20 Nov 2020 18:42:24 -0500
Received: (from defang@localhost)
        by chicken.badula.org (8.14.4/8.14.4/Submit) id 0AKNf4Pt024904;
        Fri, 20 Nov 2020 18:41:04 -0500
X-Authentication-Warning: chicken.badula.org: defang set sender to <ionut@badula.org> using -f
Received: from moisil.badula.org (pool-71-187-225-100.nwrknj.fios.verizon.net [71.187.225.100])
        by chicken.badula.org (envelope-sender <ionut@badula.org>) (MIMEDefang) with ESMTP id 0AKNf3lq024894; Fri, 20 Nov 2020 18:41:04 -0500
Subject: Re: [PATCH] net: adaptec: remove dead code in set_vlan_mode
To:     Jakub Kicinski <kuba@kernel.org>, xiakaixu1987@gmail.com
Cc:     leon@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <1605858600-7096-1-git-send-email-kaixuxia@tencent.com>
 <20201120151714.0cc2f00b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ion Badulescu <ionut@badula.org>
Message-ID: <fe835089-3499-0d70-304e-cc3d2e58a8d8@badula.org>
Date:   Fri, 20 Nov 2020 18:41:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20201120151714.0cc2f00b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on chicken.badula.org
X-Spam-Level: 
X-Spam-Language: en
X-Spam-Status: No, score=0.122 required=5 tests=AWL=0.639,BAYES_00=-1.9,KHOP_HELO_FCRDNS=0.399,NICE_REPLY_A=-0.001,PDS_RDNS_DYNAMIC_FP=0.001,RDNS_DYNAMIC=0.982,SPF_FAIL=0.001,URIBL_BLOCKED=0.001
X-Scanned-By: MIMEDefang 2.84 on 71.183.126.100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/20 6:17 PM, Jakub Kicinski wrote:
> On Fri, 20 Nov 2020 15:50:00 +0800 xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The body of the if statement can be executed only when the variable
>> vlan_count equals to 32, so the condition of the while statement can
>> not be true and the while statement is dead code. Remove it.
>>
>> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>   drivers/net/ethernet/adaptec/starfire.c | 9 ++-------
>>   1 file changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
>> index 555299737b51..ad27a9fa5e95 100644
>> --- a/drivers/net/ethernet/adaptec/starfire.c
>> +++ b/drivers/net/ethernet/adaptec/starfire.c
>> @@ -1754,14 +1754,9 @@ static u32 set_vlan_mode(struct netdev_private *np)
>>   		filter_addr += 16;
>>   		vlan_count++;
>>   	}
>> -	if (vlan_count == 32) {
>> +	if (vlan_count == 32)
>>   		ret |= PerfectFilterVlan;
>> -		while (vlan_count < 32) {
>> -			writew(0, filter_addr);
>> -			filter_addr += 16;
>> -			vlan_count++;
>> -		}
>> -	}
>> +
>>   	return ret;
>>   }
>>   #endif /* VLAN_SUPPORT */
> 
> This got broken back in 2011:
> 
> commit 5da96be53a16a62488316810d0c7c5d58ce3ee4f
> Author: Jiri Pirko <jpirko@redhat.com>
> Date:   Wed Jul 20 04:54:31 2011 +0000
> 
>      starfire: do vlan cleanup
>      
>      - unify vlan and nonvlan rx path
>      - kill np->vlgrp and netdev_vlan_rx_register
>      
>      Signed-off-by: Jiri Pirko <jpirko@redhat.com>
>      Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> The comparison to 32 was on a different variable before that change.
> 
> Ion, do you think anyone is still using this driver?
> 
> Maybe it's time we put it in the history book (by which I mean remove
> from the kernel).

Frankly, no, I don't know of any users, and that unfortunately includes 
myself. I still have two cards in my stash, but they're 64-bit PCI-X, so 
plugging them in would likely require taking a dremel to a 32-bit PCI 
slot to make it open-ended. (They do work in a 32-bit slot.)

Anyway, that filter code could use some fixing in other regards. So 
either we fix it properly (which I can submit a patch for), or clean it 
out for good.

-Ion
