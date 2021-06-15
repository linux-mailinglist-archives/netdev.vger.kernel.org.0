Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563293A8BAA
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 00:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFOWTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 18:19:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:60930 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhFOWTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 18:19:04 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltHMc-000BhO-UF; Wed, 16 Jun 2021 00:16:54 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltHMc-000Bi3-II; Wed, 16 Jun 2021 00:16:54 +0200
Subject: Re: [PATCH bpf-next 2/2] bpf: do not change gso_size during
 bpf_skb_change_proto()
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Willem de Bruijn <willemb@google.com>, yhs@fb.com,
        kpsingh@kernel.org, andrii@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, songliubraving@fb.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>
References: <20210604015238.2422145-1-zenczykowski@gmail.com>
 <20210604015238.2422145-2-zenczykowski@gmail.com>
 <CANP3RGc8PmPOjTGkDmbjzEVBezcQuNMcg17qpJx2aLU9juM_5w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <80bb7f49-4b69-169a-a540-f2a46551ef7c@iogearbox.net>
Date:   Wed, 16 Jun 2021 00:16:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANP3RGc8PmPOjTGkDmbjzEVBezcQuNMcg17qpJx2aLU9juM_5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26202/Tue Jun 15 13:21:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/21 9:35 AM, Maciej Żenczykowski wrote:
> On Thu, Jun 3, 2021 at 6:52 PM Maciej Żenczykowski
> <zenczykowski@gmail.com> wrote:
>> From: Maciej Żenczykowski <maze@google.com>
>>
>> This is technically a backwards incompatible change in behaviour,
>> but I'm going to argue that it is very unlikely to break things,
>> and likely to fix *far* more then it breaks.
>>
>> In no particular order, various reasons follow:
>>
>> (a) I've long had a bug assigned to myself to debug a super rare kernel
>> crash on Android Pixel phones which can (per stacktrace) be traced back
>> to bpf clat ipv6 to ipv4 protocol conversion causing some sort of ugly
>> failure much later on during transmit deep in the GSO engine, AFAICT
>> precisely because of this change to gso_size, though I've never been able
>> to manually reproduce it.
>> I believe it may be related to the particular network offload support
>> of attached usb ethernet dongle being used for tethering off of an
>> IPv6-only cellular connection.  The reason might be we end up with more
>> segments than max permitted, or with a gso packet with only one segment...
>> (either way we break some assumption and hit a BUG_ON)

Do you happen to have some more debug data from there, e.g. which bug_on
is hit? Do you have some pointers to the driver code where you suspect
this could cause an issue?

>> (b) There is no check that the gso_size is > 20 when reducing it by 20,
>> so we might end up with a negative (or underflowing) gso_size or
>> a gso_size of 0.  This can't possibly be good.
>> Indeed this is probably somehow exploitable (or at least can result
>> in a kernel crash) by delivering crafted packets and perhaps triggering
>> an infinite loop or a divide by zero...
>> As a reminder: gso_size (mss) is related to mtu, but not directly
>> derived from it: gso_size/mss may be significantly smaller then
>> one would get by deriving from local mtu.  And on some nics (which
>> do loose mtu checking on receive, it may even potentially be larger,
>> for example my work pc with 1500 mtu can receive 1520 byte frames
>> [and sometimes does due to bugs in a vendor plat46 implementation]).
>> Indeed even just going from 21 to 1 is potentially problematic because
>> it increases the number of segments by a factor of 21 (think DoS,
>> or some other crash due to too many segments).

Do you have a reproducer for creating such small gso_size from stack, is
this mainly from virtio_net side possible? If it's too small, perhaps the
gso attributes should just be cleared from the skb generally instead of
marking SKB_GSO_DODGY as we otherwise do?

>> (c) It's always safe to not increase the gso_size, because it doesn't
>> result in the max packet size increasing.  So the skb_increase_gso_size()
>> call was always unnecessary for correctness (and outright undesirable, see
>> later).  As such the only part which is potentially dangerous (ie. could
>> cause backwards compatibility issues) is the removal of the
>> skb_decrease_gso_size() call.

Right.

>> (d) If the packets are ultimately destined to the local device, then
>> there is absolutely no benefit to playing around with gso_size.
>> It only matters if the packets will egress the device.  ie. we're
>> either forwarding, or transmitting from the device.

Yep, the issue is that we don't know this at the time of the helper call.

>> (e) This logic only triggers for packets which are GSO.  It does not
>> trigger for skbs which are not GSO.  It will not convert a non-GSO mtu
>> sized packet into a GSO packet (and you don't even know what the mtu is,
>> so you can't even fix it).  As such your transmit path must *already* be
>> able to handle an mtu 20 bytes larger then your receive path (for ipv4
>> to ipv6 translation) - and indeed 28 bytes larger due to ipv4 fragments.
>> Thus removing the skb_decrease_gso_size() call doesn't actually increase
>> the size of the packets your transmit side must be able to handle.
>> ie. to handle non-GSO max-mtu packets, the ipv4/ipv6 device/route mtus
>> must already be set correctly.  Since for example with an ipv4 egress mtu
>> of 1500, ipv4 to ipv6 translation will already build 1520 byte ipv6 frames,
>> so you need a 1520 byte device mtu.  This means if your ipv6 device's
>> egress mtu is 1280, your ipv4 route must be 1260 (and actually 1252,
>> because of the need to handle fragments).  This is to handle normal non-GSO
>> packets.  Thus the reduction is simply not needed for GSO packets,
>> because when they're correctly built, they will already be the right size.

Makes sense to me.

>> (f) TSO/GSO should be able to exactly undo GRO: the number of packets
>> (TCP segments) should not be modified, so that TCP's mss counting works
>> correctly (this matters for congestion control).
>> If protocol conversion changes the gso_size, then the number of TCP segments
>> may increase or decrease.  Packet loss after protocol conversion can result
>> in partial loss of mss segments that the sender sent.  How's the sending
>> TCP stack going to react to receiving ACKs/SACKs in the middle of the
>> segments it sent?
>>
>> (g) skb_{decrease,increase}_gso_size() are already no-ops for GSO_BY_FRAGS
>> case (besides triggering WARN_ON_ONCE). This means you already cannot
>> guarantee that gso_size (and thus resulting packet mtu) is changed.
>> ie. you must assume it won't be changed.
>>
>> (h) changing gso_size is outright buggy for UDP GSO packets, where framing
>> matters (I believe that's also the case for SCTP, but it's already excluded
>> by [g]).  So the only remaining case is TCP, which also doesn't want it
>> (see [f]).
>>
>> (i) see also the reasoning on the previous attempt at fixing this
>> (commit fa7b83bf3b156c767f3e4a25bbf3817b08f3ff8e) which shows
>> that the current behaviour causes TCP packet loss:
>>
>>    In the forwarding path GRO -> BPF 6 to 4 -> GSO for TCP traffic, the
>>    coalesced packet payload can be > MSS, but < MSS + 20.
>>
>>    bpf_skb_proto_6_to_4() will upgrade the MSS and it can be > the payload
>>    length. After then tcp_gso_segment checks for the payload length if it
>>    is <= MSS. The condition is causing the packet to be dropped.
>>
>>    tcp_gso_segment():
>>      [...]
>>      mss = skb_shinfo(skb)->gso_size;
>>      if (unlikely(skb->len <= mss)) goto out;
>>      [...]
>>
>> Thus changing the gso_size is simply a very bad idea.
>> Increasing is unnecessary and buggy, and decreasing can go negative.
>>
>> Cc: Dongseok Yi <dseok.yi@samsung.com>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Willem de Bruijn <willemb@google.com>
>> Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
>> Signed-off-by: Maciej Żenczykowski <maze@google.com>
>> ---
>>   net/core/filter.c | 4 ----
>>   1 file changed, 4 deletions(-)
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 04848de3e058..953b6c31b803 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3263,8 +3263,6 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
>>                          shinfo->gso_type |=  SKB_GSO_TCPV6;
>>                  }
>>
>> -               /* Due to IPv6 header, MSS needs to be downgraded. */
>> -               skb_decrease_gso_size(shinfo, len_diff);
>>                  /* Header must be checked, and gso_segs recomputed. */
>>                  shinfo->gso_type |= SKB_GSO_DODGY;
>>                  shinfo->gso_segs = 0;
>> @@ -3304,8 +3302,6 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
>>                          shinfo->gso_type |=  SKB_GSO_TCPV4;
>>                  }
>>
>> -               /* Due to IPv4 header, MSS can be upgraded. */
>> -               skb_increase_gso_size(shinfo, len_diff);
>>                  /* Header must be checked, and gso_segs recomputed. */
>>                  shinfo->gso_type |= SKB_GSO_DODGY;
>>                  shinfo->gso_segs = 0;
>> --
>> 2.32.0.rc1.229.g3e70b5a671-goog
> 
> This patch series (ie. this patch and the previous revert) seems to
> have gotten no response, and we're running out of time, since it
> reverts the newly added api.

The change you're reverting in patch 1/2 is only in net-next, but not in
Linus tree, so there still is a large enough time window for at least the
revert. That said, I presume what you mean here is to just revert the 1/2
in bpf-next and the 2/2 fix targeted for bpf tree, no?

Few follow-up questions:

1) Could we then also cover the case of skb_is_gso(skb) && !skb_is_gso_tcp(skb)
    that we currently reject with -ENOTSUPP, in other words all GSO cases?

2) Do we still need to mark SKB_GSO_DODGY and reset segs? I presume not anymore
    after this change?

3) skb_{decrease,increase}_gso_size() should probably just removed then.

Thanks,
Daniel
