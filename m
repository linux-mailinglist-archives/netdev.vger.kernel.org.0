Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BA129374B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 10:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390127AbgJTI73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 04:59:29 -0400
Received: from www62.your-server.de ([213.133.104.62]:49560 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390070AbgJTI72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 04:59:28 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUnUG-0003KR-TG; Tue, 20 Oct 2020 10:59:20 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUnUG-000766-NF; Tue, 20 Oct 2020 10:59:20 +0200
Subject: Re: [PATCH bpf 1/2] bpf_redirect_neigh: Support supplying the nexthop
 as a helper parameter
To:     David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160312349392.7917.6673239142315191801.stgit@toke.dk>
 <160312349501.7917.13131363910387009253.stgit@toke.dk>
 <3785e450-313f-c6f0-2742-716c10b6f8a4@iogearbox.net>
 <e4188697-4467-61fe-72c4-cc387ea9a727@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dd953598-c897-e4f5-39e5-43f62bd15431@iogearbox.net>
Date:   Tue, 20 Oct 2020 10:59:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e4188697-4467-61fe-72c4-cc387ea9a727@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25962/Mon Oct 19 15:57:02 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 5:12 AM, David Ahern wrote:
> On 10/19/20 12:23 PM, Daniel Borkmann wrote:
>> Looks good to me, thanks! I'll wait till David gets a chance as well to
>> review.
>> One thing that would have made sense to me (probably worth a v2) is to
>> keep the
>> fib lookup flag you had back then, meaning sth like BPF_FIB_SKIP_NEIGH
>> which
>> would then return a BPF_FIB_LKUP_RET_NO_NEIGH before doing the neigh
>> lookup inside
>> the bpf_ipv{4,6}_fib_lookup() so that programs can just unconditionally
>> use the
>> combination of bpf_fib_lookup(skb, [...], BPF_FIB_SKIP_NEIGH) with the
>> bpf_redirect_neigh([...]) extension in that case and not do this
>> bpf_redirect()
>> vs bpf_redirect_neigh() dance as you have in the selftest in patch 2/2.
> 
> That puts the overhead on bpf_ipv{4,6}_fib_lookup. The existiong helpers
> return BPF_FIB_LKUP_RET_NO_NEIGH which is the key to the bpf program to
> call the bpf_redirect_neigh - making the program deal with the overhead
> as needed on failures.

But if I know there's high chance anyway that __ipv*_neigh_lookup_noref*()
is failing for bpf_ipv{4,6}_fib_lookup() why even paying the price of the
hash table lookup in there? Simple test to skip and return early would be
much cheaper, and branch predictor should work it out just fine given that
setting is pretty much static anyway; I'm not sure I'm seeing why this would
be much of a concern..
