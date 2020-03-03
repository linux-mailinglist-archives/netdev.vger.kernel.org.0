Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC14178314
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730831AbgCCTXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:23:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:47500 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCCTXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 14:23:36 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9D8c-0006J2-KR; Tue, 03 Mar 2020 20:23:30 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9D8c-0004eI-Ar; Tue, 03 Mar 2020 20:23:30 +0100
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
To:     Alexei Starovoitov <ast@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <20200228223948.360936-1-andriin@fb.com> <87mu8zt6a8.fsf@toke.dk>
 <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
 <87imjms8cm.fsf@toke.dk> <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
 <e9a4351a-4cf9-120a-1ae1-94a707a6217f@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
Date:   Tue, 3 Mar 2020 20:23:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e9a4351a-4cf9-120a-1ae1-94a707a6217f@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25740/Tue Mar  3 13:12:16 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 4:46 PM, Alexei Starovoitov wrote:
> On 3/3/20 12:12 AM, Daniel Borkmann wrote:
>>
>> I can see the motivation for this abstraction in particular for tracing, but given
>> the goal of bpf_link is to formalize and make the various program attachment types
>> more uniform, how is this going to solve e.g. the tc/BPF case? There is no guarantee
>> that while you create a link with the prog attached to cls_bpf that someone else is
>> going to replace that qdisc underneath you, and hence you end up with the same case
>> as if you would have only pinned the program itself (and not a link). So bpf_link
>> then gives a wrong impression that something is still attached and active while it
>> is not. What is the plan for these types?
> 
> TC is not easy to handle, right, but I don't see a 'wrong impression' part. The link will keep the program attached to qdisc. The admin
> may try to remove qdisc for netdev, but that's a separate issue.
> Same thing with xdp. The link will keep xdp program attached,
> but admin may do ifconfig down and no packets will be flowing.
> Similar with cgroups. The link will keep prog attached to a cgroup,
> but admin can still do rmdir and cgroup will be in 'dying' state.
> In case of tracing there is no intermediate entity between programs
> and the kernel. In case of networking there are layers.
> Netdevs, qdiscs, etc. May be dev_hold is a way to go.

Yep, right. I mean taking tracing use-case aside, in Cilium we attach to XDP, tc,
cgroups BPF and whatnot, and we can tear down the Cilium user space agent just
fine while packets keep flowing through the BPF progs, and a later restart will
just reattach them atomically, e.g. Cilium version upgrades are usually done this
way.

This decoupling works since the attach point is already holding the reference on
the program, and if needed user space can always retrieve what has been attached
there. So the surrounding object acts like the "bpf_link" already. I think we need
to figure out what semantics an actual bpf_link should have there. Given an admin
can change qdisc/netdev/etc underneath us, and hence cause implicit detachment, I
don't know whether it would make much sense to keep surrounding objects like filter,
qdisc or even netdev alive to work around it since there's a whole dependency chain,
like in case of filter instance, it would be kept alive, but surrounding qdisc may
be dropped.

Question is, if there are no good semantics and benefits over what can be done
today with existing infra (abstracted from user space via libbpf) for the remaining
program types, perhaps it makes sense to have the pinning tracing specific only
instead of generic abstraction which only ever works for a limited number?

Thanks,
Daniel
