Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D01B4771F4
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbhLPMhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:37:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:40434 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234165AbhLPMhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:37:20 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mxq0c-000Dwp-Py; Thu, 16 Dec 2021 13:37:18 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mxq0c-000Rga-CL; Thu, 16 Dec 2021 13:37:18 +0100
Subject: Re: [net v5 2/3] net: sched: add check tc_skip_classify in sch egress
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
 <20211208145459.9590-3-xiangxia.m.yue@gmail.com>
 <61b383c6373ca_1f50e20816@john.notmuch>
 <CAMDZJNV3-y5jkUAJJ--10PcicKpGMwKS_3gG9O7srjomO3begw@mail.gmail.com>
 <CAMDZJNXL5qSfFv54A=RrMwHe8DOv48EfrypHb1FFSUFu36-9DQ@mail.gmail.com>
 <CAMDZJNUyOELOcf0dtxktCTRKv1sUrp5Z17mW+4so7tt6DFnJsw@mail.gmail.com>
 <368e82ef-24be-06c7-2111-8a21cd558100@iogearbox.net>
 <CAMDZJNXY249r_SBuSjCwkAf-xGF98-5EPN41d23Jix0fTawZTw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1ba06b2f-6c78-cec1-4ba4-98494a402d0e@iogearbox.net>
Date:   Thu, 16 Dec 2021 13:37:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAMDZJNXY249r_SBuSjCwkAf-xGF98-5EPN41d23Jix0fTawZTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26389/Thu Dec 16 07:02:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/21 1:37 AM, Tonghao Zhang wrote:
> On Sat, Dec 11, 2021 at 4:11 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 12/10/21 8:54 PM, Tonghao Zhang wrote:
>>> On Sat, Dec 11, 2021 at 1:46 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>>>> On Sat, Dec 11, 2021 at 1:37 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>>>>> On Sat, Dec 11, 2021 at 12:43 AM John Fastabend
>>>>> <john.fastabend@gmail.com> wrote:
>>>>>> xiangxia.m.yue@ wrote:
[...]
>>>>> Hi John
>>>>> Tx ethx -> __dev_queue_xmit -> sch_handle_egress
>>>>> ->  execute BPF program on ethx with bpf_redirect(ifb0) ->
>>>>> -> ifb_xmit -> ifb_ri_tasklet -> dev_queue_xmit -> __dev_queue_xmit
>>>>> the packets loopbacks, that means bpf_redirect doesn't work with ifb
>>>>> netdev, right ?
>>>>> so in sch_handle_egress, I add the check skb_skip_tc_classify().
>>
>> But why would you do that? Usage like this is just broken by design..
> As I understand, we can redirect packets to a target device either at
> ingress or at *egress
> 
> The commit ID: 3896d655f4d491c67d669a15f275a39f713410f8
> Allow eBPF programs attached to classifier/actions to call
> bpf_clone_redirect(skb, ifindex, flags) helper which will mirror or
> redirect the packet by dynamic ifindex selection from within the
> program to a target device either at ingress or at egress. Can be used
> for various scenarios, for example, to load balance skbs into veths,
> split parts of the traffic to local taps, etc.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=3896d655f4d491c67d669a15f275a39f713410f8
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=27b29f63058d26c6c1742f1993338280d5a41dc6
> 
> But at egress the bpf_redirect doesn't work with ifb.
>> If you need to loop anything back to RX, just use bpf_redirect() with
> Not use it to loop packets back. the flags of bpf_redirect is 0. for example:
> 
> tc filter add dev veth1 \
> egress bpf direct-action obj test_bpf_redirect_ifb.o sec redirect_ifb
> https://patchwork.kernel.org/project/netdevbpf/patch/20211208145459.9590-4-xiangxia.m.yue@gmail.com/
>> BPF_F_INGRESS? What is the concrete/actual rationale for ifb here?
> We load balance the packets to different ifb netdevices at egress. On
> ifb, we install filters, rate limit police,

I guess this part here is what I don't quite follow. Could you walk me through
the packet flow in this case? So you go from bpf@tc-egress@phys-dev to do the
redirect to bpf@tc-egress@ifb, and then again to bpf@tc-egress@phys-dev (same
dev or different one I presume)? Why not doing the load-balancing, applying the
policy, and doing the rate-limiting (e.g. EDT with sch_fq) directly at the initial
bpf@tc-egress@phys-dev location given bpf is perfectly capable to do all of it
there w/o the extra detour & overhead through ifb? The issue I see here is adding
extra overhead to support such a narrow case that nobody else is using and that
can be achieved already with existing infra as I understood it; the justification
right now to add the extra checks to the critical fast path is very thin..

Thanks,
Daniel
