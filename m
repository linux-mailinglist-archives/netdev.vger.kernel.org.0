Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3714E255D89
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 17:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgH1PMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 11:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbgH1PMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 11:12:30 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68818C061264;
        Fri, 28 Aug 2020 08:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=n2RN+rEjm+Zy1oHtyfmOVgisvgCHlCOJPis+fgHx5RA=; b=Ll4f1pNjTbdHJaZTNyzGh3KnmY
        0dgrp78B98fzYKZ7C+n0K1MotLAD09MiSKBYpU92JiIBfBoOgoswrqggoT5tjRpET1A/Ykihg7t9+
        uh9umYsxiTVyHhdCSns1js8xG8RtnOHS27xQMpOOTGg8CQKFRuUzldi6YbTFjSPCxKZQsmcdTAaiX
        qGtj2Ndii428RWtDA/6BeUkgB+P9F7bJxd3FLunrikSZsYh6ex+3xH5UU1AWeBAeZJryVpvF9gyXY
        BQpUHberGmiUSGWqiuTVDL6mVLemU9wMbK0GKgqLRtLtW5bD6ZQ0apFiiU3tJK3ptFzpTKzXUeQWk
        b2Ius9xg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBg3F-00010N-Rx; Fri, 28 Aug 2020 15:12:26 +0000
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Sven Joachim <svenjoac@gmx.de>, Brian Vazquez <brianvv@google.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20200729212721.1ee4eef8@canb.auug.org.au>
 <87ft8lwxes.fsf@turtle.gmx.de>
 <CAMzD94Rz4NYnhheS8SmuL14MNM4VGxOnAW-WZ9k1JEqrbwyrvw@mail.gmail.com>
 <87y2m7gq86.fsf@turtle.gmx.de> <87pn7gh3er.fsf@turtle.gmx.de>
 <CAMzD94Rkq1RTZJG5UsEz9VhaCBbvObD1azqU2gsJzZ6gPYcfag@mail.gmail.com>
 <878sdyn6xz.fsf@turtle.gmx.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <49315f94-1ae6-8280-1050-5fc0d1ead984@infradead.org>
Date:   Fri, 28 Aug 2020 08:12:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <878sdyn6xz.fsf@turtle.gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 8:09 AM, Sven Joachim wrote:
> On 2020-08-27 11:12 -0700, Brian Vazquez wrote:
> 
>> I've been trying to reproduce it with your config but I didn't
>> succeed. I also looked at the file after the preprocessor and it
>> looked good:
>>
>> ret = ({ __builtin_expect(!!(ops->match == fib6_rule_match), 1) ?
>> fib6_rule_match(rule, fl, flags) : ops->match(rule, fl, flags); })
> 
> However, in my configuration I have CONFIG_IPV6=m, and so
> fib6_rule_match is not available as a builtin.  I think that's why ld is
> complaining about the undefined reference.

Same here FWIW. CONFIG_IPV6=m.


> Changing the configuration to CONFIG_IPV6=y helps, FWIW.
> 
>> Note that fib4_rule_match doesn't appear as the
>> CONFIG_IP_MULTIPLE_TABLES is not there.
>>
>> Could you share more details on how you're compiling it and what
>> compiler you're using??
> 
> Tried with both gcc 9 and gcc 10 under Debian unstable, binutils 2.35.
> I usually use "make bindebpkg", but just running "make" is sufficient to
> reproduce the problem, as it happens when linking vmlinux.
> 
> Cheers,
>        Sven
> 
> 
>> On Mon, Aug 24, 2020 at 1:08 AM Sven Joachim <svenjoac@gmx.de> wrote:
>>>
>>> On 2020-08-22 08:16 +0200, Sven Joachim wrote:
>>>
>>>> On 2020-08-21 09:23 -0700, Brian Vazquez wrote:
>>>>
>>>>> Hi Sven,
>>>>>
>>>>> Sorry for the late reply, did you still see this after:
>>>>> https://patchwork.ozlabs.org/project/netdev/patch/20200803131948.41736-1-yuehaibing@huawei.com/
>>>>> ??
>>>>
>>>> That patch is apparently already in 5.9-rc1 as commit 80fbbb1672e7, so
>>>> yes I'm still seeing it.
>>>
>>> Still present in 5.9-rc2 as of today, I have attached my .config for
>>> reference.  Note that I have CONFIG_IPV6_MULTIPLE_TABLES=y, but
>>> CONFIG_IP_MULTIPLE_TABLES is not mentioned at all there.
>>>
>>> To build the kernel, I have now deselected IPV6_MULTIPLE_TABLES.  Not
>>> sure why this was enabled in my .config which has grown organically over
>>> many years.
>>>
>>> Cheers,
>>>        Sven
>>>
>>>
>>>>> On Mon, Aug 17, 2020 at 12:21 AM Sven Joachim <svenjoac@gmx.de> wrote:
>>>>>
>>>>>> On 2020-07-29 21:27 +1000, Stephen Rothwell wrote:
>>>>>>
>>>>>>> Hi all,
>>>>>>>
>>>>>>> After merging the net-next tree, today's linux-next build (i386
>>>>>> defconfig)
>>>>>>> failed like this:
>>>>>>>
>>>>>>> x86_64-linux-gnu-ld: net/core/fib_rules.o: in function
>>>>>> `fib_rules_lookup':
>>>>>>> fib_rules.c:(.text+0x5c6): undefined reference to `fib6_rule_match'
>>>>>>> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x5d8): undefined reference to
>>>>>> `fib6_rule_match'
>>>>>>> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x64d): undefined reference to
>>>>>> `fib6_rule_action'
>>>>>>> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x662): undefined reference to
>>>>>> `fib6_rule_action'
>>>>>>> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x67a): undefined reference to
>>>>>> `fib6_rule_suppress'
>>>>>>> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x68d): undefined reference to
>>>>>> `fib6_rule_suppress'
>>>>>>
>>>>>> FWIW, I saw these errors in 5.9-rc1 today, so the fix in commit
>>>>>> 41d707b7332f ("fib: fix fib_rules_ops indirect calls wrappers") was
>>>>>> apparently not sufficient.
>>>>>>
>>>>>> ,----
>>>>>> | $ grep IPV6 .config
>>>>>> | CONFIG_IPV6=m
>>>>>> | # CONFIG_IPV6_ROUTER_PREF is not set
>>>>>> | # CONFIG_IPV6_OPTIMISTIC_DAD is not set
>>>>>> | # CONFIG_IPV6_MIP6 is not set
>>>>>> | # CONFIG_IPV6_ILA is not set
>>>>>> | # CONFIG_IPV6_VTI is not set
>>>>>> | CONFIG_IPV6_SIT=m
>>>>>> | # CONFIG_IPV6_SIT_6RD is not set
>>>>>> | CONFIG_IPV6_NDISC_NODETYPE=y
>>>>>> | CONFIG_IPV6_TUNNEL=m
>>>>>> | CONFIG_IPV6_MULTIPLE_TABLES=y
>>>>>> | # CONFIG_IPV6_SUBTREES is not set
>>>>>> | # CONFIG_IPV6_MROUTE is not set
>>>>>> | # CONFIG_IPV6_SEG6_LWTUNNEL is not set
>>>>>> | # CONFIG_IPV6_SEG6_HMAC is not set
>>>>>> | # CONFIG_IPV6_RPL_LWTUNNEL is not set
>>>>>> | # CONFIG_NF_SOCKET_IPV6 is not set
>>>>>> | # CONFIG_NF_TPROXY_IPV6 is not set
>>>>>> | # CONFIG_NF_DUP_IPV6 is not set
>>>>>> | # CONFIG_NF_REJECT_IPV6 is not set
>>>>>> | # CONFIG_NF_LOG_IPV6 is not set
>>>>>> | CONFIG_NF_DEFRAG_IPV6=m
>>>>>> `----
>>>>>>
>>>>>>> Caused by commit
>>>>>>>
>>>>>>>   b9aaec8f0be5 ("fib: use indirect call wrappers in the most common
>>>>>> fib_rules_ops")
>>>>>>>
>>>>>>> # CONFIG_IPV6_MULTIPLE_TABLES is not set
>>>>>>>
>>>>>>> I have reverted that commit for today.
>>>>>>
>>>>>> Cheers,
>>>>>>        Sven


-- 
~Randy

