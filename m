Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F0C696C7E
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 19:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbjBNSLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 13:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbjBNSLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 13:11:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EBD29E10;
        Tue, 14 Feb 2023 10:11:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C5B7617F0;
        Tue, 14 Feb 2023 18:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8318DC4339C;
        Tue, 14 Feb 2023 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676398265;
        bh=0YvCAxlpyNROkszxdbJ0lGQr86a47Mx9cf9NVJUbZ10=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cF3GoCSel42+FnVUkIxu5tPY0JJgZS4MhTBq7GriynIzD0xHeL1HNathc4ds+MWGd
         aOHrfsqBdq5Xu2iciJnNwEXnDguZwobPkjmX9NQBFLtM+N2vqISi7yd1BD9k6v+LI+
         e0pp8s4usrBSsx8eAkZbUATMnLXgXWLhf2ovM2FBLmsY4DUtbsnMBEZckLcI8FvJLV
         nCS2qvJl4rJjH2HX9/6gOgsg6W82yMnT94Z4k4F/H/Htp9AEfwso8uEuzmoFb0xj6S
         5PB+DJp+VebQ25I2ihXJoiaL+xa4jmWQBMCTUHSx4g8PtYGdLR2Vpt2E2aoqog5EO7
         ZKF9dOChHNN/g==
Message-ID: <c5e3cf7c-1a94-4929-5691-9ccb4c7a194b@kernel.org>
Date:   Tue, 14 Feb 2023 11:11:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net] ipv6: Add lwtunnel encap size of all siblings in
 nexthop calculation
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230214092933.3817533-1-luwei32@huawei.com>
 <d5f2c46c-cf68-3ec9-ec87-f6748ede1d1f@intel.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <d5f2c46c-cf68-3ec9-ec87-f6748ede1d1f@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/14/23 10:39 AM, Alexander Lobakin wrote:
>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>> index e74e0361fd92..a6983a13dd20 100644
>> --- a/net/ipv6/route.c
>> +++ b/net/ipv6/route.c
>> @@ -5540,16 +5540,17 @@ static size_t rt6_nlmsg_size(struct fib6_info *f6i)
>>  		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_nlmsg_size,
>>  					 &nexthop_len);
>>  	} else {
>> +		struct fib6_info *sibling, *next_sibling;
>>  		struct fib6_nh *nh = f6i->fib6_nh;
>>  
>>  		nexthop_len = 0;
>>  		if (f6i->fib6_nsiblings) {
>> -			nexthop_len = nla_total_size(0)	 /* RTA_MULTIPATH */
>> -				    + NLA_ALIGN(sizeof(struct rtnexthop))
>> -				    + nla_total_size(16) /* RTA_GATEWAY */
>> -				    + lwtunnel_get_encap_size(nh->fib_nh_lws);
>> +			rt6_nh_nlmsg_size(nh, &nexthop_len);
>>  
>> -			nexthop_len *= f6i->fib6_nsiblings;
>> +			list_for_each_entry_safe(sibling, next_sibling,
>> +						 &f6i->fib6_siblings, fib6_siblings) {
>> +				rt6_nh_nlmsg_size(sibling->fib6_nh, &nexthop_len);
>> +			}
> 
> Just a random nitpick that you shouldn't put braces {} around oneliners :D
> 

I believe there can be exceptions and braces make multiple lines like
that more readable.

