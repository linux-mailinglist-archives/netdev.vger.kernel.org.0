Return-Path: <netdev+bounces-9179-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66CAD727C69
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:12:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1C4B280A75
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF49BA4A;
	Thu,  8 Jun 2023 10:12:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0B23B3FA;
	Thu,  8 Jun 2023 10:12:14 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE7A1FFA;
	Thu,  8 Jun 2023 03:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=mn0c6YfNQgX4beATwOeEFwcFfDb6oK79cq8wtqokvSA=; b=eZRDApbA+aRBY4zHNAaEJm9Oet
	dnkMd4cB1Gb8hr4ZXc6UMXsr/1S57c3B/xe37jSz7Qoku6pkDWSItrV/XciiQwfPvJcCxB38Z3S57
	QmhVMnXH8sqnFHrmFaXS9M2wOwE7mTVZ+knfeK8UZOM40mhCDTzxYVql2kG2W8JuK/9hhzfEwBiOp
	eNIdopV0CHRSe1LwmIGkAtRZP/i2uH2jUQfPAM4awKJXD0/nEtZIWMXRRbCjqpxPTwuwRBJBSenYg
	YCXn99Vgjy40lE7D5PPblGMrJag/1MrJcHuvpcdIH43bWbvtvQlyls8XChbSWMPwo+qaMGRBTyZCB
	hTUni7yw==;
Received: from sslproxy04.your-server.de ([78.46.152.42])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q7CcZ-000NcV-MT; Thu, 08 Jun 2023 12:12:00 +0200
Received: from [178.197.248.31] (helo=linux.home)
	by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1q7CcZ-00013f-2l; Thu, 08 Jun 2023 12:11:59 +0200
Subject: Re: [PATCH bpf-next v2 2/7] bpf: Add fd-based tcx multi-prog infra
 with link support
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 razor@blackwall.org, sdf@google.com, john.fastabend@gmail.com,
 kuba@kernel.org, dxu@dxuuu.xyz, joe@cilium.io, toke@kernel.org,
 davem@davemloft.net, bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20230607192625.22641-1-daniel@iogearbox.net>
 <20230607192625.22641-3-daniel@iogearbox.net>
 <CAM0EoMm25tdjxp+7Mq4fowGfCJzFRhbThHhaO7T_46vNJ9y-NQ@mail.gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fe2e13a6-1fb6-c160-1d6f-31c09264911b@iogearbox.net>
Date: Thu, 8 Jun 2023 12:11:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAM0EoMm25tdjxp+7Mq4fowGfCJzFRhbThHhaO7T_46vNJ9y-NQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26933/Thu Jun  8 09:26:06 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jamal,

On 6/8/23 3:25 AM, Jamal Hadi Salim wrote:
[...]
> A general question (which i think i asked last time as well): who
> decides what comes after/before what prog in this setup? And would
> that same entity not have been able to make the same decision using tc
> priorities?

Back in the first version of the series I initially coded up this option
that the tc_run() would basically be a fake 'bpf_prog' and it would have,
say, fixed prio 1000. It would get executed via tcx_run() when iterating
via bpf_mprog_foreach_prog() where bpf_prog_run() is called, and then users
could pick for native BPF prio before or after that. But then the feedback
was that sticking to prio is a bad user experience which led to the
development of what is in patch 1 of this series (see the details there).

> The idea of protecting programs from being unloaded is very welcome
> but feels would have made sense to be a separate patchset (we have
> good need for it). Would it be possible to use that feature in tc and
> xdp?
BPF links are supported for XDP today, just tc BPF is one of the few
remainders where it is not the case, hence the work of this series. What
XDP lacks today however is multi-prog support. With the bpf_mprog concept
that could be addressed with that common/uniform api (and Andrii expressed
interest in integrating this also for cgroup progs), so yes, various hook
points/program types could benefit from it.

>> +struct tcx_entry {
>> +       struct bpf_mprog_bundle         bundle;
>> +       struct mini_Qdisc __rcu         *miniq;
>> +};
>> +
> 
> Can you please move miniq to the front? From where i sit this looks:
> struct tcx_entry {
>          struct bpf_mprog_bundle    bundle
> __attribute__((__aligned__(64))); /*     0  3264 */
> 
>          /* XXX last struct has 36 bytes of padding */
> 
>          /* --- cacheline 51 boundary (3264 bytes) --- */
>          struct mini_Qdisc *        miniq;                /*  3264     8 */
> 
>          /* size: 3328, cachelines: 52, members: 2 */
>          /* padding: 56 */
>          /* paddings: 1, sum paddings: 36 */
>          /* forced alignments: 1 */
> } __attribute__((__aligned__(64)));
> 
> That is a _lot_ of cachelines - at the expense of the status quo
> clsact/ingress qdiscs which access miniq.

Ah yes, I'll fix this up.

Thanks,
Daniel

