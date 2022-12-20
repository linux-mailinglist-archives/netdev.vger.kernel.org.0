Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7627652377
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 16:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiLTPKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 10:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLTPKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 10:10:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD88301;
        Tue, 20 Dec 2022 07:10:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFF1A614AE;
        Tue, 20 Dec 2022 15:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ED6C433D2;
        Tue, 20 Dec 2022 15:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671549033;
        bh=MnSUn++QuKMw7l2ujm9/FRvrB65xWP0qsHEyLbhYtWU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MPH4tkYl4WoZvpgX6HOcoeqj7Vuil+JozuFFEEUko0cOsINtzcrOt1wmTR1p6ZOcQ
         wwpknn1G15WEFA2wu99Zj7Bib4E3D5pztbar0m+HixMN19Rg95UKyGEZQnwxJY+un4
         URTuAzkwj6+FJ8ccSi2A0j5sGVOqAFM6szdKM4fjNcgMwzNK6SvqReZRQ5IEeLqOjg
         sXUODwX67a4B1FiPA0k/juUlJ+zm+tSiBz7PBwsY7tEeaZEBstbn62XxaNqUD4TGtZ
         juCybEBSEeYbl9ejnrRHwesbE4SzNwSNx/p3z5LBhjb9/TJx/WdGbLzw8GTW6ZihXi
         1BQ/pxOUtfYzw==
Message-ID: <bf56c3aa-85df-734d-f419-835a35e66e03@kernel.org>
Date:   Tue, 20 Dec 2022 08:10:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Jon Maxwell <jmaxwell37@gmail.com>, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221218234801.579114-1-jmaxwell37@gmail.com>
 <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/22 5:35 AM, Paolo Abeni wrote:
> On Mon, 2022-12-19 at 10:48 +1100, Jon Maxwell wrote:
>> Sending Ipv6 packets in a loop via a raw socket triggers an issue where a 
>> route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly 
>> consumes the Ipv6 max_size threshold which defaults to 4096 resulting in 
>> these warnings:
>>
>> [1]   99.187805] dst_alloc: 7728 callbacks suppressed
>> [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
>> .
>> .
>> [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> 
> If I read correctly, the maximum number of dst that the raw socket can
> use this way is limited by the number of packets it allows via the
> sndbuf limit, right?
> 
> Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
> ipvs, seg6?
> 
> @DavidA: why do we need to create RTF_CACHE clones for KNOWN_NH flows?
> 
> Thanks,
> 
> Paolo
> 

If I recall the details correctly: that sysctl limit was added back when
ipv6 routes were managed as dst_entries and there was a desire to allow
an admin to limit the memory consumed. At this point in time, IPv6 is
more inline with IPv4 - a separate struct for fib entries from dst
entries. That "Route cache is full" message is now out of date since
this is dst_entries which have a gc mechanism.

IPv4 does not limit the number of dst_entries that can be allocated
(ip_rt_max_size is the sysctl variable behind the ipv4 version of
max_size and it is a no-op). IPv6 can probably do the same here?

I do not believe the suggested flag is the right change.
