Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928F52EA3A3
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 04:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbhAEDGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 22:06:10 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:22953 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbhAEDGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 22:06:10 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609815944; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=bjoryiW+9NnOdfV+ZJn29FIzHkjRqZqMc9JCrAl9AcE=;
 b=rCW4HY9haztd0ahEEkpYwlNC88mkOiDpdZRdrlBeDmViUEzk0Ex9r2s7X0Z7dvDjPKSIRLpQ
 yZ9/5682PLgi2U5UGAbvRXtPuhjCoCIofQM6fw94DHbURCKok/O0SOZSl1hRFix6Yr0IQKu5
 3B3LOtHmT+wf01DbOFFeeiZigSA=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5ff3d76ed3eb3c36b419d28d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Jan 2021 03:05:18
 GMT
Sender: stranche=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F2877C43462; Tue,  5 Jan 2021 03:05:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stranche)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 44563C433CA;
        Tue,  5 Jan 2021 03:05:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 04 Jan 2021 20:05:17 -0700
From:   stranche@codeaurora.org
To:     David Ahern <dsahern@gmail.com>
Cc:     Wei Wang <weiwan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
In-Reply-To: <839f0ad6-83c1-1df6-c34d-b844c52ba771@gmail.com>
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
 <56e72b72-685f-925d-db2d-d245c1557987@gmail.com>
 <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
 <307c2de1a2ddbdcd0a346c57da88b394@codeaurora.org>
 <CAEA6p_ArQdNp=hQCjrsnAo-Xy22d44b=2KdLp7zO7E7XDA4Fog@mail.gmail.com>
 <f10c733a-09f8-2c72-c333-41f9d53e1498@gmail.com>
 <6a314f7da0f41c899926d9e7ba996337@codeaurora.org>
 <839f0ad6-83c1-1df6-c34d-b844c52ba771@gmail.com>
Message-ID: <9f25d75823a73c6f0f556f0905f931d1@codeaurora.org>
X-Sender: stranche@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-11 09:10, David Ahern wrote:

>>>> Could we further distinguish between dst added to the uncached list 
>>>> by
>>>> icmp6_dst_alloc() and xfrm6_fill_dst(), and confirm which ones are 
>>>> the
>>>> ones leaking reference?
>>>> I suspect it would be the xfrm ones, but I think it is worth 
>>>> verifying.
>>>> 
>> 
>> After digging into the DST allocation/destroy a bit more, it seems 
>> that
>> there are some cases where the DST's refcount does not hit zero, 
>> causing
>> them to never be freed and release their references.
>> One case comes from here on the IPv6 packet output path (these DST
>> structs would hold references to both the inet6_dev and the netdevice)
>> ip6_pol_route_output+0x20/0x2c -> ip6_pol_route+0x1dc/0x34c ->
>> rt6_make_pcpu_route+0x18/0xf4 -> ip6_rt_pcpu_alloc+0xb4/0x19c
> 
> This is the normal data path, and this refers to a per-cpu dst cache.
> Delete the route and the cached entries get removed.
> 

After tracing all the DST entries created by the system, we've been able 
to see
that all unfreed DST entries belong to the same route on the system. One 
is the
main rt6_info struct it references and the rest are percpu copies of it.

>> 
>> We also see two DSTs where they are stored as the xdst->rt entry on 
>> the
>> XFRM path that do not get released. One is allocated by the same path 
>> as
>> above, and the other like this
>> xfrm6_esp_err+0x7c/0xd4 -> esp6_err+0xc8/0x100 ->
>> ip6_update_pmtu+0xc8/0x100 -> __ip6_rt_update_pmtu+0x248/0x434 ->
>> ip6_rt_cache_alloc+0xa0/0x1dc
> 
> This entry goes into an exception cache. I have lost track of kernel
> versions and features. Try listing the route cache to see these:  ip -6
> ro ls cache

Thanks for the tip here. We've further seen that the route that refers 
to these
unfreed DST is always a cached exception route. After tracing the routes 
as well,
we can see that the fib6_info struct for this route is never freed 
either, thus
preventing any of the DSTs associated with it from being cleaned up and 
releasing
their refcounts on the device. In fact, we can see that the fib6_info 
struct is no
longer present in the main fib6 tree after a period of time. The last 
time we're
able to see the pointer to the route in the tree is during a route 
replace
operation from userspace, but it seems that the fib6_info is not fully 
released.
In particular, the exception cache is not flushed out for the route 
during the
replace operation like it is during a standard fib6_del_route() call.

We're able to reproduce the refcount mismatch after some experimentation 
as well.
Essentially, it consists of
1) adding a default route (ip -6 route add dev XXX default)
2) forcing the creation of an exception route via manually injecting an 
ICMPv6
Packet Too Big into the device.
3) Replace the default route (ip -6 route change dev XXX default)
4) Delete the device. (ip link del XXX)

After adding a call to flush out the exception cache for the route, the 
mismatch
is no longer seen:
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 7a0c877..95e4310 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1215,6 +1215,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, 
struct fib6_info *rt,
                 }
                 nsiblings = iter->fib6_nsiblings;
                 iter->fib6_node = NULL;
+               rt6_flush_exceptions(iter);
                 fib6_purge_rt(iter, fn, info->nl_net);
                 if (rcu_access_pointer(fn->rr_ptr) == iter)
                         fn->rr_ptr = NULL;
