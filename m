Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B823B3A780D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 09:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhFOHiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 03:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhFOHiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 03:38:08 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EDCC0617AF
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:36:03 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id f84so19213785ybg.0
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FiHlyLuUa3tZCav6PYZXXh3LRDHbc9dbclb37lqJuto=;
        b=Lj091RFix2zPvpogz5p5LdebddNeJdjYhl7ike3heeve0IV+zr8FbvMfa5boUhBvEn
         8Qohw188DvTIWj4YwES6CQDgWN0sjfaGD7khAw9mneew6Nw7ZxI46rxNEZ9NS8Yaf8WM
         JSBXF2f1QT/0aaGmZLdg+VC2jqY4H4ObDhNT5MYtYDZjsRsDDMbKd+gCtylEtvv9YW1E
         cd/W6r0h5fWQchAhXH+Mf9n3tKmVL36oOXP/Sv/5+3+5dHIY7MT0Uv/YH9YjfgKi5ZK0
         0WOlUUgPef88x0WTH5FP1teaX/lm+cKHTqXAbpM19uUqZhAuZXKfGkeulLqxW+btnu+z
         aUQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FiHlyLuUa3tZCav6PYZXXh3LRDHbc9dbclb37lqJuto=;
        b=e6jvo90Gypjr+4D461OJZ8BUb1r033zU3vZZcWNkRcaP6ThTa6NF/M5CuueMsrXWDw
         TbL9fuqauabyysVZ3Bz9afSOvBcdC9st3icyHzq+yBkvAoC76wq3p66lAq6KprtI3Pe6
         I3WS+x1cU3GHQuNDZdYuG1KcuvUIhhC4h6j0dgCZVot/5EVLaESTqby/RCIvHgvTq05c
         xgXNchbkto7fAcL/ICQJPMsOw2bgn1lNBInP3CTRzqV1U5RHS8glO3eCIl2oDB3L1HIi
         Mhb74aiZK4pkzNPEUcCCnSs5kZoIPhQeDGzCaN2YsrOw6IHlb9pnvsFd+bsTzGXy5l8J
         wKpw==
X-Gm-Message-State: AOAM530249X3GE9JjLS3LObxjdb7X+J3qYtqhUtEbgailPV7jzX1JWb5
        Rz6FwxqyY24kv9mjghKVmU8S5mdnl0LZ4EEts/mP/A==
X-Google-Smtp-Source: ABdhPJzdGFQxWe21ANRSmXBVitacBxnIOPRm3MIDlYfUzjRXfQG5wsicrDB8szqBrZNCFfB3zfTRQ1PXAtmq1DMVEGo=
X-Received: by 2002:a25:bb84:: with SMTP id y4mr28981183ybg.450.1623742562323;
 Tue, 15 Jun 2021 00:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210604015238.2422145-1-zenczykowski@gmail.com> <20210604015238.2422145-2-zenczykowski@gmail.com>
In-Reply-To: <20210604015238.2422145-2-zenczykowski@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 15 Jun 2021 00:35:51 -0700
Message-ID: <CANP3RGc8PmPOjTGkDmbjzEVBezcQuNMcg17qpJx2aLU9juM_5w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: do not change gso_size during bpf_skb_change_proto()
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 6:52 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> This is technically a backwards incompatible change in behaviour,
> but I'm going to argue that it is very unlikely to break things,
> and likely to fix *far* more then it breaks.
>
> In no particular order, various reasons follow:
>
> (a) I've long had a bug assigned to myself to debug a super rare kernel
> crash on Android Pixel phones which can (per stacktrace) be traced back
> to bpf clat ipv6 to ipv4 protocol conversion causing some sort of ugly
> failure much later on during transmit deep in the GSO engine, AFAICT
> precisely because of this change to gso_size, though I've never been able
> to manually reproduce it.
> I believe it may be related to the particular network offload support
> of attached usb ethernet dongle being used for tethering off of an
> IPv6-only cellular connection.  The reason might be we end up with more
> segments than max permitted, or with a gso packet with only one segment..=
.
> (either way we break some assumption and hit a BUG_ON)
>
> (b) There is no check that the gso_size is > 20 when reducing it by 20,
> so we might end up with a negative (or underflowing) gso_size or
> a gso_size of 0.  This can't possibly be good.
> Indeed this is probably somehow exploitable (or at least can result
> in a kernel crash) by delivering crafted packets and perhaps triggering
> an infinite loop or a divide by zero...
> As a reminder: gso_size (mss) is related to mtu, but not directly
> derived from it: gso_size/mss may be significantly smaller then
> one would get by deriving from local mtu.  And on some nics (which
> do loose mtu checking on receive, it may even potentially be larger,
> for example my work pc with 1500 mtu can receive 1520 byte frames
> [and sometimes does due to bugs in a vendor plat46 implementation]).
> Indeed even just going from 21 to 1 is potentially problematic because
> it increases the number of segments by a factor of 21 (think DoS,
> or some other crash due to too many segments).
>
> (c) It's always safe to not increase the gso_size, because it doesn't
> result in the max packet size increasing.  So the skb_increase_gso_size()
> call was always unnecessary for correctness (and outright undesirable, se=
e
> later).  As such the only part which is potentially dangerous (ie. could
> cause backwards compatibility issues) is the removal of the
> skb_decrease_gso_size() call.
>
> (d) If the packets are ultimately destined to the local device, then
> there is absolutely no benefit to playing around with gso_size.
> It only matters if the packets will egress the device.  ie. we're
> either forwarding, or transmitting from the device.
>
> (e) This logic only triggers for packets which are GSO.  It does not
> trigger for skbs which are not GSO.  It will not convert a non-GSO mtu
> sized packet into a GSO packet (and you don't even know what the mtu is,
> so you can't even fix it).  As such your transmit path must *already* be
> able to handle an mtu 20 bytes larger then your receive path (for ipv4
> to ipv6 translation) - and indeed 28 bytes larger due to ipv4 fragments.
> Thus removing the skb_decrease_gso_size() call doesn't actually increase
> the size of the packets your transmit side must be able to handle.
> ie. to handle non-GSO max-mtu packets, the ipv4/ipv6 device/route mtus
> must already be set correctly.  Since for example with an ipv4 egress mtu
> of 1500, ipv4 to ipv6 translation will already build 1520 byte ipv6 frame=
s,
> so you need a 1520 byte device mtu.  This means if your ipv6 device's
> egress mtu is 1280, your ipv4 route must be 1260 (and actually 1252,
> because of the need to handle fragments).  This is to handle normal non-G=
SO
> packets.  Thus the reduction is simply not needed for GSO packets,
> because when they're correctly built, they will already be the right size=
.
>
> (f) TSO/GSO should be able to exactly undo GRO: the number of packets
> (TCP segments) should not be modified, so that TCP's mss counting works
> correctly (this matters for congestion control).
> If protocol conversion changes the gso_size, then the number of TCP segme=
nts
> may increase or decrease.  Packet loss after protocol conversion can resu=
lt
> in partial loss of mss segments that the sender sent.  How's the sending
> TCP stack going to react to receiving ACKs/SACKs in the middle of the
> segments it sent?
>
> (g) skb_{decrease,increase}_gso_size() are already no-ops for GSO_BY_FRAG=
S
> case (besides triggering WARN_ON_ONCE). This means you already cannot
> guarantee that gso_size (and thus resulting packet mtu) is changed.
> ie. you must assume it won't be changed.
>
> (h) changing gso_size is outright buggy for UDP GSO packets, where framin=
g
> matters (I believe that's also the case for SCTP, but it's already exclud=
ed
> by [g]).  So the only remaining case is TCP, which also doesn't want it
> (see [f]).
>
> (i) see also the reasoning on the previous attempt at fixing this
> (commit fa7b83bf3b156c767f3e4a25bbf3817b08f3ff8e) which shows
> that the current behaviour causes TCP packet loss:
>
>   In the forwarding path GRO -> BPF 6 to 4 -> GSO for TCP traffic, the
>   coalesced packet payload can be > MSS, but < MSS + 20.
>
>   bpf_skb_proto_6_to_4() will upgrade the MSS and it can be > the payload
>   length. After then tcp_gso_segment checks for the payload length if it
>   is <=3D MSS. The condition is causing the packet to be dropped.
>
>   tcp_gso_segment():
>     [...]
>     mss =3D skb_shinfo(skb)->gso_size;
>     if (unlikely(skb->len <=3D mss)) goto out;
>     [...]
>
> Thus changing the gso_size is simply a very bad idea.
> Increasing is unnecessary and buggy, and decreasing can go negative.
>
> Cc: Dongseok Yi <dseok.yi@samsung.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Willem de Bruijn <willemb@google.com>
> Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  net/core/filter.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 04848de3e058..953b6c31b803 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3263,8 +3263,6 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb=
)
>                         shinfo->gso_type |=3D  SKB_GSO_TCPV6;
>                 }
>
> -               /* Due to IPv6 header, MSS needs to be downgraded. */
> -               skb_decrease_gso_size(shinfo, len_diff);
>                 /* Header must be checked, and gso_segs recomputed. */
>                 shinfo->gso_type |=3D SKB_GSO_DODGY;
>                 shinfo->gso_segs =3D 0;
> @@ -3304,8 +3302,6 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb=
)
>                         shinfo->gso_type |=3D  SKB_GSO_TCPV4;
>                 }
>
> -               /* Due to IPv4 header, MSS can be upgraded. */
> -               skb_increase_gso_size(shinfo, len_diff);
>                 /* Header must be checked, and gso_segs recomputed. */
>                 shinfo->gso_type |=3D SKB_GSO_DODGY;
>                 shinfo->gso_segs =3D 0;
> --
> 2.32.0.rc1.229.g3e70b5a671-goog

This patch series (ie. this patch and the previous revert) seems to
have gotten no response, and we're running out of time, since it
reverts the newly added api.

Opinions?
