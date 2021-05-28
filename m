Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E6439414B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 12:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhE1KpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 06:45:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:56136 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236445AbhE1KpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 06:45:21 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmZda-000470-4j; Fri, 28 May 2021 12:22:42 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmZdZ-000J69-Kk; Fri, 28 May 2021 12:22:41 +0200
Subject: Re: [PATCH bpf-next] xsk: support AF_PACKET
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Wang Hai <wanghai38@huawei.com>,
        Tanner Love <tannerlove@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <87im33grtt.fsf@toke.dk>
 <1622192521.5931044-1-xuanzhuo@linux.alibaba.com>
 <20210528115003.37840424@carbon>
 <CAJ8uoz2bhfsk4XX--cNB-gKczx0jZENB5kdthoWkuyxcOHQfjg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f90b1066-a962-ba38-a5b5-ac59a13d4dd1@iogearbox.net>
Date:   Fri, 28 May 2021 12:22:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz2bhfsk4XX--cNB-gKczx0jZENB5kdthoWkuyxcOHQfjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26183/Thu May 27 13:07:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 12:00 PM, Magnus Karlsson wrote:
> On Fri, May 28, 2021 at 11:52 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
>> On Fri, 28 May 2021 17:02:01 +0800
>> Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>>> On Fri, 28 May 2021 10:55:58 +0200, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>> Xuan Zhuo <xuanzhuo@linux.alibaba.com> writes:
>>>>
>>>>> In xsk mode, users cannot use AF_PACKET(tcpdump) to observe the current
>>>>> rx/tx data packets. This feature is very important in many cases. So
>>>>> this patch allows AF_PACKET to obtain xsk packages.
>>>>
>>>> You can use xdpdump to dump the packets from the XDP program before it
>>>> gets redirected into the XSK:
>>>> https://github.com/xdp-project/xdp-tools/tree/master/xdp-dump
>>>
>>> Wow, this is a good idea.
>>
>> Yes, it is rather cool (credit to Eelco).  Notice the extra info you
>> can capture from 'exit', like XDP return codes, if_index, rx_queue.
>>
>> The tool uses the perf ring-buffer to send/copy data to userspace.
>> This is actually surprisingly fast, but I still think AF_XDP will be
>> faster (but it usually 'steals' the packet).
>>
>> Another (crazy?) idea is to extend this (and xdpdump), is to leverage
>> Hangbin's recent XDP_REDIRECT extension e624d4ed4aa8 ("xdp: Extend
>> xdp_redirect_map with broadcast support").  We now have a
>> xdp_redirect_map flag BPF_F_BROADCAST, what if we create a
>> BPF_F_CLONE_PASS flag?
>>
>> The semantic meaning of BPF_F_CLONE_PASS flag is to copy/clone the
>> packet for the specified map target index (e.g AF_XDP map), but
>> afterwards it does like veth/cpumap and creates an SKB from the
>> xdp_frame (see __xdp_build_skb_from_frame()) and send to netstack.
>> (Feel free to kick me if this doesn't make any sense)
> 
> This would be a smooth way to implement clone support for AF_XDP. If
> we had this and someone added AF_XDP support to libpcap, we could both
> capture AF_XDP traffic with tcpdump (using this clone functionality in
> the XDP program) and speed up tcpdump for dumping traffic destined for
> regular sockets. Would that solve your use case Xuan? Note that I have
> not looked into the BPF_F_CLONE_PASS code, so do not know at this
> point what it would take to support this for XSKMAPs.

Recently also ended up with something similar for our XDP LB to record pcaps [0] ;)
My question is.. tcpdump doesn't really care where the packet data comes from,
so why not extending libpcap's Linux-related internals to either capture from
perf RB or BPF ringbuf rather than AF_PACKET sockets? Cloning is slow, and if
you need to end up creating an skb which is then cloned once again inside AF_PACKET
it's even worse. Just relying and reading out, say, perf RB you don't need any
clones at all.

Thanks,
Daniel

   [0] https://cilium.io/blog/2021/05/20/cilium-110#pcap
