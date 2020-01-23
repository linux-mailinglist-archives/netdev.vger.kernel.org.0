Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD313147338
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgAWVhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:37:04 -0500
Received: from www62.your-server.de ([213.133.104.62]:39254 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWVhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 16:37:03 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuk9o-0002Qk-5H; Thu, 23 Jan 2020 22:36:56 +0100
Received: from [178.197.248.20] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuk9n-000Vf4-TC; Thu, 23 Jan 2020 22:36:55 +0100
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb
 linearization
To:     Luigi Rizzo <lrizzo@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
References: <20200122203253.20652-1-lrizzo@google.com>
 <875zh2bis0.fsf@toke.dk> <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net>
 <87blqui1zu.fsf@toke.dk>
 <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com>
 <875zh2hx20.fsf@toke.dk>
 <CAMOZA0JSZ2iDBk4NOUyNLVE_KmRzYHyEBmQWF+etnpcp=fe0kQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b22e86ef-e4dd-14a3-fb1b-477d9e61fefa@iogearbox.net>
Date:   Thu, 23 Jan 2020 22:36:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAMOZA0JSZ2iDBk4NOUyNLVE_KmRzYHyEBmQWF+etnpcp=fe0kQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25704/Thu Jan 23 12:37:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 7:06 PM, Luigi Rizzo wrote:
> On Thu, Jan 23, 2020 at 10:01 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> Luigi Rizzo <lrizzo@google.com> writes:
>>> On Thu, Jan 23, 2020 at 8:14 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>>>> On 1/23/20 10:53 AM, Toke Høiland-Jørgensen wrote:
>>>>>> Luigi Rizzo <lrizzo@google.com> writes:
>>>>>>
>>>>>>> Add a netdevice flag to control skb linearization in generic xdp mode.
>>>>>>> Among the various mechanism to control the flag, the sysfs
>>>>>>> interface seems sufficiently simple and self-contained.
>>>>>>> The attribute can be modified through
>>>>>>>      /sys/class/net/<DEVICE>/xdp_linearize
>>>>>>> The default is 1 (on)
>>>>>
>>>>> Needs documentation in Documentation/ABI/testing/sysfs-class-net.
>>>>>
>>>>>> Erm, won't turning off linearization break the XDP program's ability to
>>>>>> do direct packet access?
>>>>>
>>>>> Yes, in the worst case you only have eth header pulled into linear
>>>>> section. :/
>>>>
>>>> In which case an eBPF program could read/write out of bounds since the
>>>> verifier only verifies checks against xdp->data_end. Right?
>>>
>>> Why out of bounds? Without linearization we construct xdp_buff as follows:
>>>
>>> mac_len = skb->data - skb_mac_header(skb);
>>> hlen = skb_headlen(skb) + mac_len;
>>> xdp->data = skb->data - mac_len;
>>> xdp->data_end = xdp->data + hlen;
>>> xdp->data_hard_start = skb->data - skb_headroom(skb);
>>>
>>> so we shouldn't go out of bounds.
>>
>> Hmm, right, as long as it's guaranteed that the bit up to hlen is
>> already linear; is it? :)
> 
> honest question: that would be skb->len - skb->data_len, isn't that
> the linear part by definition ?

Yep, that's the linear part by definition. Generic XDP with ->data/->data_end is in
this aspect no different from tc/BPF where we operate on skb context. Only linear part
can be covered from skb (unless you pull in more via helper for the latter).

Thanks,
Daniel
