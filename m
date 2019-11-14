Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2E3FC6EA
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKNNDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:03:38 -0500
Received: from www62.your-server.de ([213.133.104.62]:38100 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfKNNDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 08:03:38 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVEmd-0006sz-OM; Thu, 14 Nov 2019 14:03:35 +0100
Received: from [178.197.248.57] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVEmd-0005EX-Bw; Thu, 14 Nov 2019 14:03:35 +0100
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <thoiland@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
References: <20191113204737.31623-1-bjorn.topel@gmail.com>
 <20191113204737.31623-3-bjorn.topel@gmail.com> <87o8xeod0s.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7893c97d-3d3f-35cc-4ea0-ac34d3d84dbc@iogearbox.net>
Date:   Thu, 14 Nov 2019 14:03:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87o8xeod0s.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25633/Thu Nov 14 10:50:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/19 1:31 PM, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@gmail.com> writes:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> The BPF dispatcher builds on top of the BPF trampoline ideas;
>> Introduce bpf_arch_text_poke() and (re-)use the BPF JIT generate
>> code. The dispatcher builds a dispatch table for XDP programs, for
>> retpoline avoidance. The table is a simple binary search model, so
>> lookup is O(log n). Here, the dispatch table is limited to four
>> entries (for laziness reason -- only 1B relative jumps :-P). If the
>> dispatch table is full, it will fallback to the retpoline path.
> 
> So it's O(log n) with n == 4? Have you compared the performance of just
> doing four linear compare-and-jumps? Seems to me it may not be that big
> of a difference for such a small N?

Did you perform some microbenchmarks wrt search tree? Mainly wondering
since for code emission for switch/case statements, clang/gcc turns off
indirect calls entirely under retpoline, see [0] from back then.

>> An example: A module/driver allocates a dispatcher. The dispatcher is
>> shared for all netdevs. Each netdev allocate a slot in the dispatcher
>> and a BPF program. The netdev then uses the dispatcher to call the
>> correct program with a direct call (actually a tail-call).
> 
> Is it really accurate to call it a tail call? To me, that would imply
> that it increments the tail call limit counter and all that? Isn't this
> just a direct jump using the trampoline stuff?

Not meant in BPF context here, but more general [1].

(For actual BPF tail calls I have a series close to ready for getting
rid of most indirect calls which I'll post later today.)

Best,
Daniel

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9d57ef15cbe327fe54416dd194ee0ea66ae53a4
   [1] https://en.wikipedia.org/wiki/Tail_call
