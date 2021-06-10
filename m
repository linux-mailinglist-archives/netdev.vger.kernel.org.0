Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2B93A2D93
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 15:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhFJOAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:00:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:43320 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJOAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:00:10 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lrLCF-000C2N-56; Thu, 10 Jun 2021 15:58:11 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lrLCE-000Ql1-Rf; Thu, 10 Jun 2021 15:58:10 +0200
Subject: Re: [PATCH bpf-next v1 00/10] bpfilter
To:     Dmitrii Banshchikov <me@ubique.spb.ru>, Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, davem@davemloft.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
References: <20210603101425.560384-1-me@ubique.spb.ru>
 <4dd3feeb-8b4a-0bdb-683e-c5c5643b1195@fb.com>
 <20210610133655.d25say2ialzhtdhq@amnesia>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c105ba9d-3081-971e-393c-a8cbe73f35e4@iogearbox.net>
Date:   Thu, 10 Jun 2021 15:58:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210610133655.d25say2ialzhtdhq@amnesia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26197/Thu Jun 10 13:10:09 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/21 3:36 PM, Dmitrii Banshchikov wrote:
> On Wed, Jun 09, 2021 at 05:50:13PM -0700, Yonghong Song wrote:
>> On 6/3/21 3:14 AM, Dmitrii Banshchikov wrote:
>>> The patchset is based on the patches from David S. Miller [1] and
>>> Daniel Borkmann [2].
>>>
>>> The main goal of the patchset is to prepare bpfilter for
>>> iptables' configuration blob parsing and code generation.
>>>
>>> The patchset introduces data structures and code for matches,
>>> targets, rules and tables.
>>>
>>> The current version misses handling of counters. Postpone its
>>> implementation until the code generation phase as it's not clear
>>> yet how to better handle them.
>>>
>>> Beside that there is no support of net namespaces at all.
>>>
>>> In the next iteration basic code generation shall be introduced.
>>>
>>> The rough plan for the code generation.
>>>
>>> It seems reasonable to assume that the first rules should cover
>>> most of the packet flow.  This is why they are critical from the
>>> performance point of view.  At the same time number of user
>>> defined rules might be pretty large. Also there is a limit on
>>> size and complexity of a BPF program introduced by the verifier.
>>>
>>> There are two approaches how to handle iptables' rules in
>>> generated BPF programs.
>>>
>>> The first approach is to generate a BPF program that is an
>>> equivalent to a set of rules on a rule by rule basis. This
>>> approach should give the best performance. The drawback is the
>>> limitation from the verifier on size and complexity of BPF
>>> program.
>>>
>>> The second approach is to use an internal representation of rules
>>> stored in a BPF map and use bpf_for_each_map_elem() helper to
>>> iterate over them. In this case the helper's callback is a BPF
>>> function that is able to process any valid rule.
>>>
>>> Combination of the two approaches should give most of the
>>> benefits - a heuristic should help to select a small subset of
>>> the rules for code generation on a rule by rule basis. All other
>>> rules are cold and it should be possible to store them in an
>>> internal form in a BPF map. The rules will be handled by
>>> bpf_for_each_map_elem().  This should remove the limit on the
>>> number of supported rules.
>>
>> Agree. A bpf program inlines some hot rule handling and put
>> the rest in for_each_map_elem() sounds reasonable to me.

Sounds reasonable. You mentioned in the next iteration that you are
planning to include basic code generation. Would be good to have that
as part of an initial merge included, maybe along with some form of
documentation for users on what is expected to already work with the
current state of the code (& potentially stating goals/non-goals) of
this work. Thanks Dmitrii!

>>> During development it was useful to use statically linked
>>> sanitizers in bpfilter usermode helper. Also it is possible to
>>> use fuzzers but it's not clear if it is worth adding them to the
>>> test infrastructure - because there are no other fuzzers under
>>> tools/testing/selftests currently.
>>>
>>> Patch 1 adds definitions of the used types.
>>> Patch 2 adds logging to bpfilter.
>>> Patch 3 adds bpfilter header to tools
>>> Patch 4 adds an associative map.
>>> Patches 5/6/7/8 add code for matches, targets, rules and table.
>>> Patch 9 handles hooked setsockopt(2) calls.
>>> Patch 10 uses prepared code in main().
>>>
>>> Here is an example:
>>> % dmesg  | tail -n 2
>>> [   23.636102] bpfilter: Loaded bpfilter_umh pid 181
>>> [   23.658529] bpfilter: started
>>> % /usr/sbin/iptables-legacy -L -n
>>
>> So this /usr/sbin/iptables-legacy is your iptables variant to
>> translate iptable command lines to BPFILTER_IPT_SO_*,
>> right? It could be good to provide a pointer to the source
>> or binary so people can give a try.
>>
>> I am not an expert in iptables. Reading codes, I kind of
>> can grasp the high-level ideas of the patch, but probably
>> Alexei or Daniel can review some details whether the
>> design is sufficient to be an iptable replacement.
> 
> The goal of a complete iptables replacement is too ambigious for
> the moment - because existings hooks and helpers don't cover all
> required functionality.
> 
> A more achievable goal is to have something simple that could
> replace a significant part of use cases for filter table.
> 
> Having something simple that would work as a stateless firewall
> and provide some performance benefits is a good start. For more
> complex scenarios there is a safe fallback to the existing
> implementation.
> 
>>> Chain INPUT (policy ACCEPT)
>>> target     prot opt source               destination
>>>
>>> Chain FORWARD (policy ACCEPT)
>>> target     prot opt source               destination
>>>
>> [...]
> 

