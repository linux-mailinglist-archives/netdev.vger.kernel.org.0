Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51FD3A8D2F
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 02:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhFPAIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 20:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhFPAIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 20:08:52 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B4AC061760
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 17:06:46 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id g38so330532ybi.12
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 17:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RQexx5LVkdV318CpG6zh5NCoav3ETAxxXPd9ZBLUp9Q=;
        b=jUVMyv2PJWfPrfyK60UVEzoaE2yU5B2+8MltwiJB5ociJHywWyDQ7Y/Q6+OonN+jQu
         IzizuRLlGXJ1mMCiir7m566oGGUhRmWxomJ78Gu13gAhDxIRVBXyDQINqAFIj/1PMEtC
         maDuFrfNgKLO+G9KOHHIbXzv4A5XVCgHogDgSP7aRO1yVI9+HUN7/sfQG5FXwgJOPAh1
         fkqsIlpmx8IhIrZjF9bhDy5n+MmgNmAnhPJ8ijJHQZBnKr2evRUwQ903a0Cphn0aYWnb
         ntXuUWJlmNbZPry2m9lxbgMtYe1wOk9lfkjzRzYBJbVVutTwLmtzYp5XBGtNPUmmhoOz
         QkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RQexx5LVkdV318CpG6zh5NCoav3ETAxxXPd9ZBLUp9Q=;
        b=X/YbtlG67qbn8/0hW3+e17Skdff0QG5annikoF+2jDsZH77Qc0uaAIGSYWB4BY7Mns
         w+8v7QzznrwlnqogkwQ2g1UjY26uTkOTdoFKR7L1PdSbmTxnWSotyD433cwg3g5jVyzP
         LitaPPizMqBIwpj/fO0Pug1lloHHIq4FoZNel7hIZXOjUjSwBo1y572Vsivq+2Q90umA
         0wqXzG4r9LhO/n/lPkqSIIXs5PJKd3m7auiGVDyiNJ3f5z/SxaDoCNhRkHdwN3MXTeIo
         LWTUUDuancgScws8UqOAl9mA5THguITzZomhllV0sOa/bgFGoHGqzlSk4y/RQH//BwvZ
         dUoA==
X-Gm-Message-State: AOAM5318ha6WE7WhKRGibnXHEyj3JLjAUERwYkNYlmmPdOLpP81sgBak
        G0YZXDbMvaW6103u5hZCEnxhL5A5wgpBfrigmmc9sA==
X-Google-Smtp-Source: ABdhPJwIeBTt8YkUUq6aAs8WyPGOurwN/6Cy9gCuhSUbkFV6y4AqXk0ICje16nCtEFQ4CNVYbU3LBRGzQ1XEX0i/9gA=
X-Received: by 2002:a25:be44:: with SMTP id d4mr2378362ybm.497.1623802004787;
 Tue, 15 Jun 2021 17:06:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210604015238.2422145-1-zenczykowski@gmail.com>
 <20210604015238.2422145-2-zenczykowski@gmail.com> <CANP3RGc8PmPOjTGkDmbjzEVBezcQuNMcg17qpJx2aLU9juM_5w@mail.gmail.com>
 <80bb7f49-4b69-169a-a540-f2a46551ef7c@iogearbox.net>
In-Reply-To: <80bb7f49-4b69-169a-a540-f2a46551ef7c@iogearbox.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 15 Jun 2021 17:06:32 -0700
Message-ID: <CANP3RGfjLikQ6dg=YpBU0OeHvyv7JOki7CyOUS9modaXAi-9vQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: do not change gso_size during bpf_skb_change_proto()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> (a) I've long had a bug assigned to myself to debug a super rare kernel
> >> crash on Android Pixel phones which can (per stacktrace) be traced back
> >> to bpf clat ipv6 to ipv4 protocol conversion causing some sort of ugly
> >> failure much later on during transmit deep in the GSO engine, AFAICT
> >> precisely because of this change to gso_size, though I've never been able
> >> to manually reproduce it.
> >> I believe it may be related to the particular network offload support
> >> of attached usb ethernet dongle being used for tethering off of an
> >> IPv6-only cellular connection.  The reason might be we end up with more
> >> segments than max permitted, or with a gso packet with only one segment...
> >> (either way we break some assumption and hit a BUG_ON)
>
> Do you happen to have some more debug data from there, e.g. which bug_on
> is hit? Do you have some pointers to the driver code where you suspect
> this could cause an issue?

Yes, I found an old relevant stack trace in google bug 158835517.
This is from a blueline (Pixel 3 non-XL) running a 4.9.223 derived kernel.

[57742.623372] c0      0 ------------[ cut here ]------------
[57742.623451] c0      0 kernel BUG at net/core/skbuff.c:3290!
[57742.623473] c0      0 Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[57742.623500] Modules linked in: ftm5 heatmap videobuf2_vmalloc
videobuf2_memops snd_soc_sdm845 snd_soc_cs35l36 snd_soc_wcd_spi
snd_soc_wcd934x snd_soc_wcd9xxx wcd_dsp_glink wcd_core pinctrl_wcd
wlan(O)
[57742.623676] c0      0 CPU: 0 PID: 0 Comm: swapper/0 Tainted: G
     O    4.9.223-ga7ce4286ca2d-ab6546858 #0
[57742.623696] c0      0 Hardware name: Google Inc. MSM sdm845 B1 DVT1.1 (DT)
[57742.623727] c0      0 task: 0000000097327d34 task.stack: 00000000533bef44
[57742.623770] c0      0 PC is at skb_segment+0xeb8/0xf1c
[57742.623786] c0      0 LR is at skb_segment+0x998/0xf1c
...
[57742.625301] c0      0 1720: 0000000000000011 ffffffc13b8b1850
ffffff898aa2b530 ffffffc13b8b1770
[57742.625321] c0      0 [<000000008025a24e>] skb_segment+0xeb8/0xf1c
[57742.625348] c0      0 [<00000000f0dbe6cc>] tcp_gso_segment+0xdc/0x428
[57742.625376] c0      0 [<000000009ff681a5>] tcp6_gso_segment+0x60/0x17c
[57742.625391] c0      0 [<00000000ae27ff84>] ipv6_gso_segment+0x208/0x3d0
[57742.625413] c0      0 [<000000009ff20266>] skb_mac_gso_segment+0xcc/0x198
[57742.625430] c0      0 [<000000005f3e189b>] __skb_gso_segment+0xe0/0x198
[57742.625448] c0      0 [<000000002756bf90>] validate_xmit_skb+0x214/0x3ac
[57742.625473] c0      0 [<00000000d536666c>] sch_direct_xmit+0x8c/0x37c
[57742.625492] c0      0 [<000000006ae4cbff>] __qdisc_run+0x3e4/0x5d4
[57742.625512] c0      0 [<0000000040112c03>] __dev_queue_xmit+0x4d8/0xc9c
[57742.625538] c0      0 [<000000002adaadc6>] __bpf_redirect+0x148/0x2f8
[57742.625557] c0      0 [<00000000766573a7>] __dev_queue_xmit+0x830/0xc9c
[57742.625578] c0      0 [<000000006df3822d>] neigh_direct_output+0x1c/0x28
[57742.625607] c0      0 [<00000000bacb35cc>] ip_finish_output2+0x3ac/0x6cc
[57742.625628] c0      0 [<00000000e7f62131>] ip_finish_output+0x2e4/0x360
[57742.625643] c0      0 [<0000000079e638f1>] ip_output+0x19c/0x274
[57742.625666] c0      0 [<0000000092e42b8c>] NF_HOOK_THRESH+0x150/0x1cc
[57742.625685] c0      0 [<00000000b4e9c6f8>] ip_forward+0x468/0x510
[57742.625704] c0      0 [<00000000779cadd9>] ip_rcv_finish+0x228/0x3c0
[57742.625723] c0      0 [<000000006eee429d>] ip_rcv+0x3b8/0x53c
[57742.625740] c0      0 [<00000000eabf9034>]
__netif_receive_skb_core+0xb10/0xe68
[57742.625761] c0      0 [<000000009368ee55>]
netif_receive_skb_internal+0x1b4/0x26c
[57742.625775] c0      0 [<00000000afac19f3>] napi_gro_complete+0x5c/0x180
[57742.625795] c0      0 [<000000001a7429fd>] napi_complete_done+0x70/0x14c
[57742.625824] c0      0 [<000000000876f6ad>] r8152_poll+0x1138/0x14c8
[57742.625846] c0      0 [<000000006a1f8e3a>] napi_poll+0x8c/0x2f0
[57742.625868] c0      0 [<00000000128c5761>] net_rx_action+0xa8/0x2e8
[57742.625892] c0      0 [<00000000684eda45>] __do_softirq+0x23c/0x568
[57742.625921] c0      0 [<000000008094d781>] irq_exit+0x130/0x144
[57742.625949] c0      0 [<00000000c3de88cc>] __handle_domain_irq+0x108/0x16c
[57742.625963] c0      0 [<000000005c213a95>] gic_handle_irq.21048+0x124/0x19c
[57742.625979] c0      0 Exception stack(0xffffff898c003c20 to
0xffffff898c003d50)
[57742.625999] c0      0 3c20: ffffcb7ad1c65ff9 0000000000000000
0000000000000000 0000000000000001
[57742.626014] c0      0 3c40: 000034852e1f1c83 0000000000000000
0000000000300000 0000000000000000
[57742.626033] c0      0 3c60: 0000000000000000 00000000000039d0
0000000000000018 003529018eb90a43
[57742.626052] c0      0 3c80: 00000000341555ac 00000000019b7894
00000000c800ffff 0000000000000000
[57742.626070] c0      0 3ca0: 00000000000003fc 00000000ffffffff
ffffff898c004030 0000000000000002
[57742.626089] c0      0 3cc0: ffffffc12c4d2858 ffffffc12c4d2018
ffffff898c00f7f0 ffffff898c11f990
[57742.626107] c0      0 3ce0: 0000000000000001 00003484f804e64b
ffffff898adce668 ffffff898c460108
[57742.626126] c0      0 3d00: ffffff898c460000 ffffff898c003d90
ffffff898a547e1c ffffff898c003d50
[57742.626145] c0      0 3d20: ffffff898a547e58 00000000a0c00145
ffffff898c00f7f0 ffffffc12c4d2018
[57742.626159] c0      0 3d40: ffffffffffffffff 0000000000000002
[57742.626179] c0      0 [<00000000179ba2a9>] el1_irq+0xc4/0x13c
[57742.626205] c0      0 [<0000000052ad168a>] lpm_cpuidle_enter+0x5c0/0x670
[57742.626233] c0      0 [<00000000b8e10462>] cpuidle_enter_state+0x200/0x400
[57742.626260] c0      0 [<0000000048578bb9>] cpu_idle_loop+0x294/0x440
[57742.626276] c0      0 [<00000000fbf7777c>] cpu_idle_loop+0x0/0x440
[57742.626304] c0      0 [<0000000012a6efc3>] kernel_init+0x0/0x2a8
[57742.626333] c0      0 [<0000000034e25c8d>] start_kernel+0xe04/0xe0c
[57742.626350] c0      0 [<000000000861285f>] __primary_switched+0x6c/0x98
[57742.626375] c0      0 Code: a94f6ffc f85f8e5e 910503ff d65f03c0 (d4210000)
[57742.626419] c0      0 ---[ end trace 5245603348170006 ]---
[57742.727830] c0      0 Kernel panic - not syncing: Fatal exception
in interrupt

The commit is 'a7ce4286ca2d LTS: Merge android-4.9-q (4.9.223) into
android-msm-pixel-4.9' and it is crashing at
https://android.googlesource.com/kernel/msm/+/a7ce4286ca2d640068055973938f69e3a069e67a/net/core/skbuff.c#3290

struct sk_buff *skb_segment(struct sk_buff *head_skb,
netdev_features_t features) {
  ...
  while (pos < offset + len) {
    if (i >= nfrags) {
      BUG_ON(skb_headlen(list_skb));  <-- crash

My bare bones initial analysis:

This looks like an ipv4/tcp upload from rx csum/gso capable ethernet
(realtek 8152 100mbps or 8153 gigabit) usb dongle hitting ipv4 nat +
forwarding to v4 tun clat device, and then tc egress bpf on that v4
tun device doing clat ipv4-to-ipv6 translation and bpf_redirect to v6
only cell interface (ethernet header less), then triggering a bug in
the kernel's software segmentation engine on transmit through the
cellular uplink (which is a T-Mobile ipv6 only cell network).  This is
on a blueline 4.9 kernel.

User confirmed - to paraphrase:

Home internet was down. I thought I would try using ethernet tethering
to power my whole home's internet. I plugged my Pixel 3 into the
included USB-A to USB-C adapter, into an Insignia NS-PU98635 [note:
https://www.insigniaproducts.com/pdp/NS-PU98635/3510527 ] into my Nest
Wifi router [note: presumably via an ethernet cable] then turned on
ethernet tethering. It seemed to work for a while, but then the phone
rebooted.

Carrier was Google Fi, presumably 'roaming' on T-Mobile, so ipv6-only
cellular network]

Internally, I already asked Willem and Eric about this, I'll quote
from the initial investigation in the bug.

Eric said (trimmed):
  skb_segment() is not yet able to segment something that GRO has
aggregated with a frag_list, if gso_size has to be changed.
  skb_segment() is not generic enough.
  I tried to fix this in the past:
https://lore.kernel.org/netdev/94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com/
  This was the patch Herbert came up 7 years ago.
  https://marc.info/?l=linux-netdev&m=138419594024851&w=2
  I believe my proposal was :
https://www.spinics.net/lists/netdev/msg255549.html

Willem said (slightly trimmed):
  I wonder if the fix as a result of that upstream discussion would
help here, too.
  Basically, it falls back onto non-sg copy based segmentation for some packets.
  I think so. Can you check whether your kernel has this 4.19 stable backport:

  net: gso: Fix skb_segment splat when splitting gso_size mangled skb
having linear-headed frag_list
  https://lore.kernel.org/patchwork/patch/1128590/

  The real solution is to not play gso_size games in
bpf_skb_proto_[46]_to_[64], of course.
  I should have added support for BPF_F_ADJ_ROOM_FIXED_GSO to those
functions when I introduced that.
  As you pointed out offline, even if we add it now, a missing flag causes
  runtime, not build time, failure and requires a workaround...

(back story: writing bpf code that works on all manner of kernels that
may or may not have all fixes/backports,
and may be as old as 4.9 is challenging.  Some things rely on multiple
versions of the bpf code, and using
the first one that successfully loads, other things depend on runtime
fallbacks, etc.  Here with the new flag,
we'd have to do something like bpf_skb_change_proto(FIXED_GSO), and if
that fails [presumably due to lack
of kernel patch] fall back to bpf_skb_change_proto(0).  With the
revert + this patch, it'll 'just' work.)

  One more thing, maybe you can trigger linearization of these skbs when
  they traverse an intermediary device, notably tun, by disabling with
  ethtool -K tx-scatter-gather-fraglist

  Then in validate_xmit_skb on transmit from that device it should hit
  the skb_need_linearize (?)  This is wild speculation..

  Oh 4.9. Also, the bpf_redirect means that that egress path is never
hit on the tun device of course.

  This is the 4.9 stable backport
  https://lore.kernel.org/stable/20190919214802.102848604@linuxfoundation.org/

To which my response was:
  commit 162a5a8c3aff15c449e6b38355cdf80ab4f77a5a
  net: gso: Fix skb_segment splat when splitting gso_size mangled skb
having linear-headed frag_list
git describe 162a5a8c3aff15c449e6b38355cdf80ab4f77a5a
v4.9.193-6-g162a5a8c3aff
So theoretically it's already in the tree...

And the discussion petered out roughly a year ago.
I've never found a way to trigger this on demand (via veth or otherwise)

> >> (b) There is no check that the gso_size is > 20 when reducing it by 20,
> >> so we might end up with a negative (or underflowing) gso_size or
> >> a gso_size of 0.  This can't possibly be good.
> >> Indeed this is probably somehow exploitable (or at least can result
> >> in a kernel crash) by delivering crafted packets and perhaps triggering
> >> an infinite loop or a divide by zero...
> >> As a reminder: gso_size (mss) is related to mtu, but not directly
> >> derived from it: gso_size/mss may be significantly smaller then
> >> one would get by deriving from local mtu.  And on some nics (which
> >> do loose mtu checking on receive, it may even potentially be larger,
> >> for example my work pc with 1500 mtu can receive 1520 byte frames
> >> [and sometimes does due to bugs in a vendor plat46 implementation]).
> >> Indeed even just going from 21 to 1 is potentially problematic because
> >> it increases the number of segments by a factor of 21 (think DoS,
> >> or some other crash due to too many segments).
>
> Do you have a reproducer for creating such small gso_size from stack, is
> this mainly from virtio_net side possible? If it's too small, perhaps the
> gso attributes should just be cleared from the skb generally instead of
> marking SKB_GSO_DODGY as we otherwise do?

I don't.  I tend to think it's not possible with the linux tcp stack,
but it should be possible - if annoying to do - with a raw socket.

You don't even need an established tcp connection, since gro will
happily aggregate packets for non existing flows.

So you simply need to send two consecutive ipv4/tcp segments with 20
byte tcp payload (ie. gso_size),
and gro should merge them, and then ipv4-to-ipv6 conversion should
result in a ipv6/tcp headers + 40 byte payload, yet 0-byte gso_size
packet, and it should crash.

I've checked the code and we later DIV_ROUND_UP by gso_size, which
should thus div by zero.

But I haven't ever actually tried to trigger it.

> The change you're reverting in patch 1/2 is only in net-next, but not in
> Linus tree, so there still is a large enough time window for at least the
> revert. That said, I presume what you mean here is to just revert the 1/2
> in bpf-next and the 2/2 fix targeted for bpf tree, no?

That would be ideal, yes.

> Few follow-up questions:
>
> 1) Could we then also cover the case of skb_is_gso(skb) && !skb_is_gso_tcp(skb)
>     that we currently reject with -ENOTSUPP, in other words all GSO cases?

I think so.  Somehow I missed this condition even being there.
If this patch series is accepted I'll follow up to remove that
(presumably in bpf-next though?)

> 2) Do we still need to mark SKB_GSO_DODGY and reset segs? I presume not anymore
>     after this change?

I'm uncertain.  It certainly seems safer to leave it?

One could argue that any gso packet modified by bpf write operations
should technically be SKB_GSO_DODGY...

After all, the user may fail to even put in a valid
ethernet/ipv4/ipv6(/tcp) header...

That said, that seems to be user error, so I think I'd be willing to
remove it, but I think that would belong in bpf-next rather than bpf.

> 3) skb_{decrease,increase}_gso_size() should probably just removed then.

Oh, interesting, are there no other users?  But again, that would seem
to be a bpf-next candidate I think?
But in general I would agree playing games with gso_size is just a bad
idea no matter what.

- Maciej
