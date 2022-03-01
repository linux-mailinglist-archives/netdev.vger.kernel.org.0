Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953664C8259
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 05:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiCAEbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 23:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiCAEby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 23:31:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE9C657B3
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 20:31:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5298960BA5
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 04:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43714C340EE;
        Tue,  1 Mar 2022 04:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646109072;
        bh=h1DjHBGwWr6sBlOOTP1xk7l1fqdTPDSSRL+2sbtoUiw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nfUTsqGw0XfwxeJGlqSizE6UAgLJ2RuJf7vpr7nc+A8KlIVmzkxaRrZ2UGF6FtRoy
         NsQmqnqZeQFpj1vmEU1THu+ugnn82Gyj9YY4JqI/q72mEzRB5QfATmP20/XxZj2zZN
         qYwvZB+CbfNZtkaoIgiDsYalhRZuYMy/KbGBi9/h0BH1WE3MQa7hU2oPJZQybWaJ+Y
         rsMx08GDcf8bVIxCiZEVP3XwAqwGUYOSZHORkIQ9H0rYZwmsqbSUisqNq2R8UYNdLc
         wtXUuVaZ8RijC9emKznAfrBE7Yte2v7hbUz18uiV9MPNUi9dCUJD7+k2aGafobN/fZ
         Zn8bfGz5Ys+Aw==
Message-ID: <faca5750-911d-151f-d5fa-7a8ed3b43b08@kernel.org>
Date:   Mon, 28 Feb 2022 21:31:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH net] ipv4: fix route lookups when handling ICMP redirects
 and PMTU updates
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <cffd245430d10fa2a14c32d1c768eef7cfeb8963.1646068241.git.gnault@redhat.com>
 <922b4932-fcd5-d362-4679-6689046560c7@kernel.org>
 <20220228205440.GA24680@debian.home>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220228205440.GA24680@debian.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/22 1:54 PM, Guillaume Nault wrote:
> On Mon, Feb 28, 2022 at 10:31:58AM -0700, David Ahern wrote:
>> On 2/28/22 10:16 AM, Guillaume Nault wrote:
>>> Fixes: d3a25c980fc2 ("ipv4: Fix nexthop exception hash computation.")
>>
>> That does not seem related to tos in the flow struct at all.
> 
> Ouch, copy/paste mistake.
> I meant 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions."), which is
> the next commit with 'git log -- net/ipv4/route.c'.
> Really sorry :/, and thanks a lot for catching that!
> 
>>> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
>>> index f33ad1f383b6..d5d058de3664 100644
>>> --- a/net/ipv4/route.c
>>> +++ b/net/ipv4/route.c
>>> @@ -499,6 +499,15 @@ void __ip_select_ident(struct net *net, struct iphdr *iph, int segs)
>>>  }
>>>  EXPORT_SYMBOL(__ip_select_ident);
>>>  
>>> +static void ip_rt_fix_tos(struct flowi4 *fl4)
>>
>> make this a static inline in include/net/flow.h and update
>> flowi4_init_output and flowi4_update_output to use it. That should cover
>> a few of the cases below leaving just  ...
> 
> Hum, I didn't think about this option, but it looks risky to me. As I
> put it in note 1, ip_route_output_key_hash() unconditionally sets
> ->flowi4_scope, assuming it can infer the scope from the RTO_ONLINK bit
> of ->flowi4_tos. If we santise these fields in flowi4_init_output()
> (and flowi4_update_output()), then ip_route_output_key_hash() would
> sometimes work on already santised values and sometimes not. So it
> wouldn't know if it should initialise ->flowi4_scope.
> 
> We could decide to let ip_route_output_key_hash() initialise
> ->flowi4_scope only when the RTO_ONLINK bit is set, which
> guarantees that we don't have sanitised values. But before that, we'd
> need to audit all other callers, to verify that they correctly
> initialise the ->flowi4_scope with RT_SCOPE_UNIVERSE, since
> ip_route_output_key_hash() isn't going do it for them anymore.
> I'll audit all these callers, but that should be something for
> net-next.

I'm not following the response. You are moving the tos logic from
ip_route_output_key_hash to a helper and calling the new helper for
other fib lookups. My suggestion was to correctly set / fixup the tos
and scope when flowi4 is initialized (reducing the number of places the
fixup is needed) and recognizing below that ip_route_output_key_hash
still needs the call to the new ip_rt_fix_tos.


> 
>>> @@ -2613,9 +2625,7 @@ struct rtable *ip_route_output_key_hash(struct net *net, struct flowi4 *fl4,
>>>  	struct rtable *rth;
>>>  
>>>  	fl4->flowi4_iif = LOOPBACK_IFINDEX;
>>> -	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
>>> -	fl4->flowi4_scope = ((tos & RTO_ONLINK) ?
>>> -			 RT_SCOPE_LINK : RT_SCOPE_UNIVERSE);
>>> +	ip_rt_fix_tos(fl4);
>>
>> ... this one to call the new helper.
> 
> BTW, here's a bit more about the context around this patch.
> I found the problem while working on removing the use of RTO_ONLINK, so
> that ->flowi4_tos could be converted to dscp_t.
> 
> The objective is to modify callers so that they'd set ->flowi4_scope
> directly, instead using RTO_ONLINK to mark their intention (and that's
> why I said I'd have to audit them anyway).
> 
> Once that will be done, ip_rt_fix_tos() won't have to touch the scope
> anymore. And once ->flowi4_tos will be converted to dscp_t, we'll can
> remove that function entirely since dscp_t ensures ECN bits are cleared
> (IPTOS_RT_MASK also ensures that high order bits are cleared too, but
> that's redundant with the RT_TOS() calls already done by callers, and
> which somewhat aren't really desirable anyway).
> 



