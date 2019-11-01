Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CC7EBB95
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 02:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbfKABDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 21:03:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:34162 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfKABDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 21:03:41 -0400
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQLLj-0007Mf-Bd; Fri, 01 Nov 2019 02:03:35 +0100
Received: from [178.197.249.38] (helo=pc-63.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQLLi-0005lR-Te; Fri, 01 Nov 2019 02:03:35 +0100
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: replace prog_raw_tp+btf_id with
 prog_tracing
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20191030223212.953010-1-ast@kernel.org>
 <20191030223212.953010-2-ast@kernel.org>
 <5ef95166-dace-28be-8274-a9343900025e@iogearbox.net>
 <20191031233642.xnqlz6qjfwzlmilt@ast-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <afe594ea-de2c-e796-8ae6-7c721ecfb6dd@iogearbox.net>
Date:   Fri, 1 Nov 2019 02:03:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191031233642.xnqlz6qjfwzlmilt@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25619/Thu Oct 31 09:55:29 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/19 12:36 AM, Alexei Starovoitov wrote:
> On Fri, Nov 01, 2019 at 12:20:13AM +0100, Daniel Borkmann wrote:
>> On 10/30/19 11:32 PM, Alexei Starovoitov wrote:
>>> The bpf program type raw_tp together with 'expected_attach_type'
>>> was the most appropriate api to indicate BTF-enabled raw_tp programs.
>>> But during development it became apparent that 'expected_attach_type'
>>> cannot be used and new 'attach_btf_id' field had to be introduced.
>>> Which means that the information is duplicated in two fields where
>>> one of them is ignored.
>>> Clean it up by introducing new program type where both
>>> 'expected_attach_type' and 'attach_btf_id' fields have
>>> specific meaning.
>>
>> Hm, just for my understanding, the expected_attach_type is unused for
>> tracing so far. Are you aware of anyone (bcc / bpftrace / etc) leaving
>> uninitialized garbage in there?
> 
> I'm not aware, but the risk is there. Better safe than sorry.
> If we need to revert in the future that would be massive.
> I'm already worried about new CHECK_ATTR check in raw_tp_open.
> Equally unlikely user space breakage, but that one is easy to revert
> whereas what you're proposing would mean revert everything.

Hmm, yeah, it's unfortunate that expected_attach_type is not enforced as
0. We sort of implicitly do for older kernels where expected_attach_type
is not known to it, but there is still non-zero risk given there seems
plenty of stuff in the wild on BPF tracing and not all might rely on libbpf.
Perhaps we should probably enforce it for all new program types, so we can
reuse it in future.

>> Just seems confusing that we have all
>> the different tracing prog types and now adding yet another one as
>> BPF_RPOG_TYPE_TRACING which will act as umbrella one and again have
>> different attach types some of which probably resemble existing tracing
>> prog types again (kprobes / kretprobes for example). Sounds like this
>> new type would implicitly deprecate all the existing types (sort of as
>> we're replacing them with new sub-types)?
> 
> All existing once are still supported and may grow its own helpers and what not.
> Having new prog type makes things grow independently much easier.
> I was thinking to call it BPF_PROG_TYPE_BTF_ENABLED or BPF_PROG_TYPE_GENERIC,
> since I suspect upcoming lsm and others will fit right in,
> but I think it's cleaner to define categories of bpf programs now
> instead of specific purpose types like we had in the past before BTF.

Yes, otherwise we likely would have BPF_PROG_TYPE_GENERIC as last one and
would keep defining sub-types. ;)

>> True that k[ret]probe expects pt_regs whereas BTF enabled program context
>> will be the same as raw_tp as well, but couldn't this logic be hidden in
>> the kernel e.g. via attach_btf_id as well since this is an opt-in? Could
>> the fentry/fexit be described through attach_btf_id as well?
> 
> That's what I tried first, but the code grows too ugly.
> Also for attaching fentry/fexit I'm adding new bpf_trace_open command
> similar to bpf_raw_tp_open, since existing kprobe attach style doesn't
> work at all. imo the code is much cleaner now.

Ok, fair enough that the fentry/fexit approach doesn't have too much in common
after all with plain kprobes. Applied then, thanks!
