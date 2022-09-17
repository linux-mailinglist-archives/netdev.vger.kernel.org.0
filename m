Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581435BB8D6
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 16:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiIQOqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 10:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiIQOqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 10:46:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19E52F014;
        Sat, 17 Sep 2022 07:46:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C97D6006F;
        Sat, 17 Sep 2022 14:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFD9C433C1;
        Sat, 17 Sep 2022 14:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663426003;
        bh=u+m67parpHqotFkfVU46xVR6MwSlV6nkzN4kShHzyuo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=B7NRRggwnRPzoh2kMaOXW4U5PIPn7uji4s38Icx3pBiksgf0IyOrk04esegL7q2e7
         lXrDbYKisR3C5WfQKNH3Ed+Yq7F9/KMq9oTebjXHjlt8kbj2npBSNrgqpLp3j9cD6z
         wSK4MXrRFiKI9WplY06WkIMvZv4zS1TceHAWu+H/m5DcFsNGwH17DrY8ceLh0AvbRc
         NEn1VHRIGfvLGQOTJfejAls015MceCVUIuCiAKJ5XyIMLOZB2E6NWxSnK4J8+Wk2uW
         DmbB2G4E1LxUFSNArq7mjbjhlbpC+B3421i8JJK19H63N0nColVfu5XKXIjrwV48dD
         DoyitLf/yrVYA==
Message-ID: <b11141f6-95b7-883e-d924-b9b2699eb980@kernel.org>
Date:   Sat, 17 Sep 2022 08:46:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v1] net/ipv4/nexthop: check the return value of
 nexthop_find_by_id()
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Li Zhong <floridsleeves@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org
References: <20220917023020.3845137-1-floridsleeves@gmail.com>
 <9974177e-7067-aacd-1c53-7e82616f3c3f@blackwall.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <9974177e-7067-aacd-1c53-7e82616f3c3f@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/22 2:29 AM, Nikolay Aleksandrov wrote:
> On 17/09/2022 05:30, Li Zhong wrote:
>> Check the return value of nexthop_find_by_id(), which could be NULL on
>> when not found. So we check to avoid null pointer dereference.
>>
>> Signed-off-by: Li Zhong <floridsleeves@gmail.com>
>> ---
>>  net/ipv4/nexthop.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>> index 853a75a8fbaf..9f91bb78eed5 100644
>> --- a/net/ipv4/nexthop.c
>> +++ b/net/ipv4/nexthop.c
>> @@ -2445,6 +2445,10 @@ static struct nexthop *nexthop_create_group(struct net *net,
>>  		struct nh_info *nhi;
>>  
>>  		nhe = nexthop_find_by_id(net, entry[i].id);
>> +		if (!nhe) {
>> +			err = -EINVAL;
>> +			goto out_no_nh;
>> +		}
>>  		if (!nexthop_get(nhe)) {
>>  			err = -ENOENT;
>>  			goto out_no_nh;
> 
> These are validated in nh_check_attr_group() and should exist at this point.
> Since remove_nexthop() should run under rtnl I don't see a way for a nexthop
> to disappear after nh_check_attr_group() and before nexthop_create_group().
> 

exactly. That lookup can't fail because the ids have been validated and
all of this is under rtnl preventing nexthop removes.

