Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C396A5A19
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 14:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjB1Nnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 08:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB1Nnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 08:43:31 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841D325B9F;
        Tue, 28 Feb 2023 05:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=2YufEiSw26yUxGvxbvEcxh/qT0bL7Zfm+eeVmdJnJkM=; b=T/sgNzMZ8+UIner/PUcMgOg0r1
        zQFvgCVN9l9b9eWUqLPajIEg7GxjjPqq3otpSJRj9gin0diwflv6ia8ZCPL04YQABg2bdTernyi89
        ooFAaYDR6yXfIrMHL8UHBE18j8nG2rjqjGPvVxg0HTse1XpYp33aRiCrXUeN7LsRsnC8aF8IqhmOf
        Eh2TxqwlxGimqD8PkcJjOoKbHU9BUQtsMHE3NZ4XZD2QFMaU3McaXEIW8qApfUB5PnksxSSvwoZTs
        We2Y4z1gmxzeic23kKSYEQq1sgcrobW3UHb9fMAOmr4IwMr8NWA1U/LdljFfr92RsUSKXudXvL9nN
        IbGKeqSA==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pX0GN-000Dyo-8m; Tue, 28 Feb 2023 14:43:27 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pX0GN-000H1f-0N; Tue, 28 Feb 2023 14:43:27 +0100
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets in
 BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, quentin@isovalent.com
References: <cover.1677526810.git.dxu@dxuuu.xyz>
 <20230227230338.awdzw57e4uzh4u7n@MacBook-Pro-6.local>
 <20230228015712.clq6kyrsd7rrklbz@kashmir.localdomain>
 <CAADnVQ+a633QyZgkbXfRiT_WRbPgr5n8RN0w=ntEkBHUeqRcbw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fbf869c6-29ac-4dbe-dd1c-85c6c3c10670@iogearbox.net>
Date:   Tue, 28 Feb 2023 14:43:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+a633QyZgkbXfRiT_WRbPgr5n8RN0w=ntEkBHUeqRcbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26826/Tue Feb 28 09:32:16 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/23 5:56 AM, Alexei Starovoitov wrote:
> On Mon, Feb 27, 2023 at 5:57 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
>> On Mon, Feb 27, 2023 at 03:03:38PM -0800, Alexei Starovoitov wrote:
>>> On Mon, Feb 27, 2023 at 12:51:02PM -0700, Daniel Xu wrote:
>>>> === Context ===
>>>>
>>>> In the context of a middlebox, fragmented packets are tricky to handle.
>>>> The full 5-tuple of a packet is often only available in the first
>>>> fragment which makes enforcing consistent policy difficult. There are
>>>> really only two stateless options, neither of which are very nice:
>>>>
>>>> 1. Enforce policy on first fragment and accept all subsequent fragments.
>>>>     This works but may let in certain attacks or allow data exfiltration.
>>>>
>>>> 2. Enforce policy on first fragment and drop all subsequent fragments.
>>>>     This does not really work b/c some protocols may rely on
>>>>     fragmentation. For example, DNS may rely on oversized UDP packets for
>>>>     large responses.
>>>>
>>>> So stateful tracking is the only sane option. RFC 8900 [0] calls this
>>>> out as well in section 6.3:
>>>>
>>>>      Middleboxes [...] should process IP fragments in a manner that is
>>>>      consistent with [RFC0791] and [RFC8200]. In many cases, middleboxes
>>>>      must maintain state in order to achieve this goal.
>>>>
>>>> === BPF related bits ===
>>>>
>>>> However, when policy is enforced through BPF, the prog is run before the
>>>> kernel reassembles fragmented packets. This leaves BPF developers in a
>>>> awkward place: implement reassembly (possibly poorly) or use a stateless
>>>> method as described above.
>>>>
>>>> Fortunately, the kernel has robust support for fragmented IP packets.
>>>> This patchset wraps the existing defragmentation facilities in kfuncs so
>>>> that BPF progs running on middleboxes can reassemble fragmented packets
>>>> before applying policy.
>>>>
>>>> === Patchset details ===
>>>>
>>>> This patchset is (hopefully) relatively straightforward from BPF perspective.
>>>> One thing I'd like to call out is the skb_copy()ing of the prog skb. I
>>>> did this to maintain the invariant that the ctx remains valid after prog
>>>> has run. This is relevant b/c ip_defrag() and ip_check_defrag() may
>>>> consume the skb if the skb is a fragment.
>>>
>>> Instead of doing all that with extra skb copy can you hook bpf prog after
>>> the networking stack already handled ip defrag?
>>> What kind of middle box are you doing? Why does it have to run at TC layer?
>>
>> Unless I'm missing something, the only other relevant hooks would be
>> socket hooks, right?
>>
>> Unfortunately I don't think my use case can do that. We are running the
>> kernel as a router, so no sockets are involved.
> 
> Are you using bpf_fib_lookup and populating kernel routing
> table and doing everything on your own including neigh ?
> 
> Have you considered to skb redirect to another netdev that does ip defrag?
> Like macvlan does it under some conditions. This can be generalized.
> 
> Recently Florian proposed to allow calling bpf progs from all existing
> netfilter hooks.
> You can pretend to local deliver and hook in NF_INET_LOCAL_IN ?
> I feel it would be so much cleaner if stack does ip_defrag normally.
> The general issue of skb ownership between bpf prog and defrag logic
> isn't really solved with skb_copy. It's still an issue.

I do like this series and we would also use it for Cilium case, so +1 on the
tc BPF integration. Today we have in Cilium what Ed [0] hinted in his earlier
mail where we extract information from first fragment and store the meta data
in a BPF map for subsequent packets based on ipid [1], but limitations apply
e.g. service load-balancing won't work. Redirecting to a different device
or moving higher up the stack is cumbersome since we then need to go and
recirculate back into tc BPF layer where all the business logic is located and
handling the regular (non-fragmented) path, too. Wrt skb ownership, can you
elaborate what is a concrete issue exactly? Anything that comes to mind with
this approach that could crash the kernel?

   [0] https://lore.kernel.org/bpf/cf49a091-9b14-05b8-6a79-00e56f3019e1@gmail.com/
   [1] https://github.com/cilium/cilium/pull/10264
