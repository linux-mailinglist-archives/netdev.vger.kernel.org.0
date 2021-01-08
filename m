Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC792EF0B8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 11:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbhAHKdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 05:33:22 -0500
Received: from www62.your-server.de ([213.133.104.62]:49554 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbhAHKdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 05:33:22 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kxp46-0005vi-Oe; Fri, 08 Jan 2021 11:32:18 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kxp46-000FM6-Dl; Fri, 08 Jan 2021 11:32:18 +0100
Subject: Re: [PATCH net v2] net: fix use-after-free when UDP GRO with shared
 fraglist
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Dongseok Yi <dseok.yi@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guillaume Nault <gnault@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Marco Elver <elver@google.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, namkyu78.kim@samsung.com
References: <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
 <CGME20210107005028epcas2p35dfa745fd92e31400024874f54243556@epcas2p3.samsung.com>
 <1609979953-181868-1-git-send-email-dseok.yi@samsung.com>
 <83a2b288-c0b2-ed98-9479-61e1cbe25519@iogearbox.net>
 <028b01d6e4e9$ddd5fd70$9981f850$@samsung.com>
 <c051bc98-6af2-f6ec-76d1-7feaa9da2436@iogearbox.net>
 <CAF=yD-KWByrahURXuUPm1WgwWS8M3StKDSFj0JzjU0qke9dCAg@mail.gmail.com>
 <3cce8f51-5474-fb75-c182-d90c4a1b4394@iogearbox.net>
 <CAF=yD-+bqps5PQLzuVtPgVAPDrk6ZjA0sk+gyj8JTd9BPYozWw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f03df7ae-cb1f-8775-2302-51785c0761c2@iogearbox.net>
Date:   Fri, 8 Jan 2021 11:32:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAF=yD-+bqps5PQLzuVtPgVAPDrk6ZjA0sk+gyj8JTd9BPYozWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26042/Thu Jan  7 13:37:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 3:44 PM, Willem de Bruijn wrote:
> On Thu, Jan 7, 2021 at 8:33 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 1/7/21 2:05 PM, Willem de Bruijn wrote:
>>> On Thu, Jan 7, 2021 at 7:52 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>> On 1/7/21 12:40 PM, Dongseok Yi wrote:
>>>>> On 2021-01-07 20:05, Daniel Borkmann wrote:
>>>>>> On 1/7/21 1:39 AM, Dongseok Yi wrote:
[...]
>>>>> PF_PACKET handles untouched fraglist. To modify the payload only
>>>>> for udp_rcv_segment, skb_unclone is necessary.
>>>>
>>>> I don't parse this last sentence here, please elaborate in more detail on why
>>>> it is necessary.
>>>>
>>>> For example, if tc layer would modify mark on the skb, then __copy_skb_header()
>>>> in skb_segment_list() will propagate it. If tc layer would modify payload, the
>>>> skb_ensure_writable() will take care of that internally and if needed pull in
>>>> parts from fraglist into linear section to make it private. The purpose of the
>>>> skb_clone() above iff shared is to make the struct itself private (to safely
>>>> modify its struct members). What am I missing?
>>>
>>> If tc writes, it will call skb_make_writable and thus pskb_expand_head
>>> to create a private linear section for the head_skb.
>>>
>>> skb_segment_list overwrites part of the skb linear section of each
>>> fragment itself. Even after skb_clone, the frag_skbs share their
>>> linear section with their clone in pf_packet, so we need a
>>> pskb_expand_head here, too.
>>
>> Ok, got it, thanks for the explanation. Would be great to have it in the v3 commit
>> log as well as that was more clear than the above. Too bad in that case (otoh
>> the pf_packet situation could be considered corner case ...); ether way, fix makes
>> sense then.
> 
> Thanks for double checking the tricky logic. Pf_packet + BPF is indeed
> a peculiar corner case. But there are perhaps more, like raw sockets,
> and other BPF hooks that can trigger an skb_make_writable.
> 
> Come to think of it, the no touching shared data rule is also violated
> without a BPF program? Then there is nothing in the frag_skbs
> themselves signifying that they are shared, but the head_skb is
> cloned, so its data may still not be modified.

The skb_ensure_writable() is used in plenty of places from bpf, ovs, netfilter
to core stack (e.g. vlan, mpls, icmp), but either way there should be nothing
wrong with that as it's making sure to pull the data into its linear section
before modification. Uncareful use of skb_store_bits() with offset into skb_frags
for example could defeat that, but I don't see any in-tree occurrence that would
be problematic at this point..

> This modification happens to be safe in practice, as the pf_packet
> clones don't access the bytes before skb->data where this path inserts
> headers. But still.
