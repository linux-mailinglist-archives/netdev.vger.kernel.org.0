Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F055A178351
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgCCTrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:47:08 -0500
Received: from www62.your-server.de ([213.133.104.62]:52452 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgCCTrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 14:47:08 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9DVI-0008SY-5W; Tue, 03 Mar 2020 20:46:56 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9DVH-000JrL-Pf; Tue, 03 Mar 2020 20:46:55 +0100
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb
 linearization
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Luigi Rizzo <lrizzo@google.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>, hawk@kernel.org,
        "Jubran, Samih" <sameehj@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ast@kernel.org,
        bpf@vger.kernel.org
References: <20200228105435.75298-1-lrizzo@google.com>
 <20200228110043.2771fddb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTSfd80pZroxtqZDsTeEz4FaronC=pdgjeaBBfYqqi5HiyQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3c27d9c0-eb17-b20f-2d10-01f3bdf8c0d6@iogearbox.net>
Date:   Tue, 3 Mar 2020 20:46:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTSfd80pZroxtqZDsTeEz4FaronC=pdgjeaBBfYqqi5HiyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25740/Tue Mar  3 13:12:16 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/29/20 12:53 AM, Willem de Bruijn wrote:
> On Fri, Feb 28, 2020 at 2:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> On Fri, 28 Feb 2020 02:54:35 -0800 Luigi Rizzo wrote:
>>> Add a netdevice flag to control skb linearization in generic xdp mode.
>>>
>>> The attribute can be modified through
>>>        /sys/class/net/<DEVICE>/xdpgeneric_linearize
>>> The default is 1 (on)
>>>
>>> Motivation: xdp expects linear skbs with some minimum headroom, and
>>> generic xdp calls skb_linearize() if needed. The linearization is
>>> expensive, and may be unnecessary e.g. when the xdp program does
>>> not need access to the whole payload.
>>> This sysfs entry allows users to opt out of linearization on a
>>> per-device basis (linearization is still performed on cloned skbs).
>>>
>>> On a kernel instrumented to grab timestamps around the linearization
>>> code in netif_receive_generic_xdp, and heavy netperf traffic with 1500b
>>> mtu, I see the following times (nanoseconds/pkt)
>>>
>>> The receiver generally sees larger packets so the difference is more
>>> significant.
>>>
>>> ns/pkt                   RECEIVER                 SENDER
>>>
>>>                      p50     p90     p99       p50   p90    p99
>>>
>>> LINEARIZATION:    600ns  1090ns  4900ns     149ns 249ns  460ns
>>> NO LINEARIZATION:  40ns    59ns    90ns      40ns  50ns  100ns
>>>
>>> v1 --> v2 : added Documentation
>>> v2 --> v3 : adjusted for skb_cloned
>>> v3 --> v4 : renamed to xdpgeneric_linearize, documentation
>>>
>>> Signed-off-by: Luigi Rizzo <lrizzo@google.com>
>>
>> Just load your program in cls_bpf. No extensions or knobs needed.
>>
>> Making xdpgeneric-only extensions without touching native XDP makes
>> no sense to me. Is this part of some greater vision?
> 
> Yes, native xdp has the same issue when handling packets that exceed a
> page (4K+ MTU) or otherwise consist of multiple segments. The issue is
> just more acute in generic xdp. But agreed that both need to be solved
> together.
> 
> Many programs need only access to the header. There currently is not a
> way to express this, or for xdp to convey that the buffer covers only
> part of the packet.

Right, my only question I had earlier was that when users ship their
application with /sys/class/net/<DEVICE>/xdpgeneric_linearize turned off,
how would they know how much of the data is actually pulled in? Afaik,
some drivers might only have a linear section that covers the eth header
and that is it. What should the BPF prog do in such case? Drop the skb
since it does not have the rest of the data to e.g. make a XDP_PASS
decision or fallback to tc/BPF altogether? I hinted earlier, one way to
make this more graceful is to add a skb pointer inside e.g. struct
xdp_rxq_info and then enable an bpf_skb_pull_data()-like helper e.g. as:

BPF_CALL_2(bpf_xdp_pull_data, struct xdp_buff *, xdp, u32, len)
{
         struct sk_buff *skb = xdp->rxq->skb;

         return skb ? bpf_try_make_writable(skb, len ? :
                                            skb_headlen(skb)) : -ENOTSUPP;
}

Thus, when the data/data_end test fails in generic XDP, the user can
call e.g. bpf_xdp_pull_data(xdp, 64) to make sure we pull in as much as
is needed w/o full linearization and once done the data/data_end can be
repeated to proceed. Native XDP will leave xdp->rxq->skb as NULL, but
later we could perhaps reuse the same bpf_xdp_pull_data() helper for
native with skb-less backing. Thoughts?

Thanks,
Daniel
