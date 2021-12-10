Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377EE470B93
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 21:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343867AbhLJUOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:14:47 -0500
Received: from www62.your-server.de ([213.133.104.62]:46130 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbhLJUOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 15:14:46 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mvmES-000CYR-OS; Fri, 10 Dec 2021 21:11:04 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mvmES-000J1c-BV; Fri, 10 Dec 2021 21:11:04 +0100
Subject: Re: [net v5 2/3] net: sched: add check tc_skip_classify in sch egress
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
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
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <368e82ef-24be-06c7-2111-8a21cd558100@iogearbox.net>
Date:   Fri, 10 Dec 2021 21:11:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAMDZJNUyOELOcf0dtxktCTRKv1sUrp5Z17mW+4so7tt6DFnJsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26379/Fri Dec 10 10:26:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/21 8:54 PM, Tonghao Zhang wrote:
> On Sat, Dec 11, 2021 at 1:46 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>> On Sat, Dec 11, 2021 at 1:37 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>>> On Sat, Dec 11, 2021 at 12:43 AM John Fastabend
>>> <john.fastabend@gmail.com> wrote:
>>>> xiangxia.m.yue@ wrote:
>>>>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>>>>
>>>>> Try to resolve the issues as below:
>>>>> * We look up and then check tc_skip_classify flag in net
>>>>>    sched layer, even though skb don't want to be classified.
>>>>>    That case may consume a lot of cpu cycles. This patch
>>>>>    is useful when there are a lot of filters with different
>>>>>    prio. There is ~5 prio in in production, ~1% improvement.
>>>>>
>>>>>    Rules as below:
>>>>>    $ for id in $(seq 1 5); do
>>>>>    $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
>>>>>    $ done
>>>>>
>>>>> * bpf_redirect may be invoked in egress path. If we don't
>>>>>    check the flags and then return immediately, the packets
>>>>>    will loopback.
>>>>
>>>> This would be the naive case right? Meaning the BPF program is
>>>> doing a redirect without any logic or is buggy?
>>>>
>>>> Can you map out how this happens for me, I'm not fully sure I
>>>> understand the exact concern. Is it possible for BPF programs
>>>> that used to see packets no longer see the packet as expected?
>>>>
>>>> Is this the path you are talking about?
>>> Hi John
>>> Tx ethx -> __dev_queue_xmit -> sch_handle_egress
>>> ->  execute BPF program on ethx with bpf_redirect(ifb0) ->
>>> -> ifb_xmit -> ifb_ri_tasklet -> dev_queue_xmit -> __dev_queue_xmit
>>> the packets loopbacks, that means bpf_redirect doesn't work with ifb
>>> netdev, right ?
>>> so in sch_handle_egress, I add the check skb_skip_tc_classify().

But why would you do that? Usage like this is just broken by design..
If you need to loop anything back to RX, just use bpf_redirect() with
BPF_F_INGRESS? What is the concrete/actual rationale for ifb here?
