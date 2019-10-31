Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D485BEBA4B
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfJaXUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:20:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:48376 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfJaXUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:20:22 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQJji-0007kI-Hs; Fri, 01 Nov 2019 00:20:14 +0100
Received: from [178.197.249.38] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQJji-000VvT-Aw; Fri, 01 Nov 2019 00:20:14 +0100
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: replace prog_raw_tp+btf_id with
 prog_tracing
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20191030223212.953010-1-ast@kernel.org>
 <20191030223212.953010-2-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5ef95166-dace-28be-8274-a9343900025e@iogearbox.net>
Date:   Fri, 1 Nov 2019 00:20:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191030223212.953010-2-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25619/Thu Oct 31 09:55:29 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/19 11:32 PM, Alexei Starovoitov wrote:
> The bpf program type raw_tp together with 'expected_attach_type'
> was the most appropriate api to indicate BTF-enabled raw_tp programs.
> But during development it became apparent that 'expected_attach_type'
> cannot be used and new 'attach_btf_id' field had to be introduced.
> Which means that the information is duplicated in two fields where
> one of them is ignored.
> Clean it up by introducing new program type where both
> 'expected_attach_type' and 'attach_btf_id' fields have
> specific meaning.

Hm, just for my understanding, the expected_attach_type is unused for
tracing so far. Are you aware of anyone (bcc / bpftrace / etc) leaving
uninitialized garbage in there? Just seems confusing that we have all
the different tracing prog types and now adding yet another one as
BPF_RPOG_TYPE_TRACING which will act as umbrella one and again have
different attach types some of which probably resemble existing tracing
prog types again (kprobes / kretprobes for example). Sounds like this
new type would implicitly deprecate all the existing types (sort of as
we're replacing them with new sub-types)?

True that k[ret]probe expects pt_regs whereas BTF enabled program context
will be the same as raw_tp as well, but couldn't this logic be hidden in
the kernel e.g. via attach_btf_id as well since this is an opt-in? Could
the fentry/fexit be described through attach_btf_id as well?

> In the future 'expected_attach_type' will be extended
> with other attach points that have similar semantics to raw_tp.
> This patch is replacing BTF-enabled BPF_PROG_TYPE_RAW_TRACEPOINT with
> prog_type = BPF_RPOG_TYPE_TRACING
> expected_attach_type = BPF_TRACE_RAW_TP
> attach_btf_id = btf_id of raw tracepoint inside the kernel
> Future patches will add
> expected_attach_type = BPF_TRACE_FENTRY or BPF_TRACE_FEXIT
> where programs have the same input context and the same helpers,
> but different attach points.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Thanks,
Daniel
