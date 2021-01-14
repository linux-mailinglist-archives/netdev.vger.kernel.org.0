Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3068F2F5A3C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 06:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbhANFR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 00:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbhANFR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 00:17:28 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74043C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 21:16:48 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id e22so8925940iom.5
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 21:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GN/lIgLiz/Nwfn1FGWnSqF2D2iklsfPFICyYr8pSMbE=;
        b=AqLjyJXzt/ERV2iixGOzOCMXYoCFup4kopj0YjqQz4bL5gnDiUi1iIj41YeRBmdvEo
         7C+tZoGU5yI/HtQAGZlsldPSmzktedgTtE1erOuiCrJmv21luDUqVLPSKIY4dNLIJrSs
         BYTSfMmicUEPVCh5X4kdzzkfszy1J/LHULLdXq2Fu4pDIXRn3PAsyinPWqBod0nNOrn9
         WVnyJlsGTyOsh7W6qQND+4SLUJ36/2bF7mKt4HgQfaWDAxar5PsspXZrMEqT105xBaB1
         3nEQqMCIqi7bZaH8AyFM/cLoo0s02IerDUZVCBsjXJkcxGQF/bioMkIcVutbLpUakG53
         vKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GN/lIgLiz/Nwfn1FGWnSqF2D2iklsfPFICyYr8pSMbE=;
        b=Rl6G98Gp4Sfv/MO5BH4uM1xAQajGcOivyTdKUkkZEersSGc2xl5ftDicIlQgM1FWac
         R4Bec6TYhChfK/kHnmW3+ZRY05TugjdjrRGjXZJGv6DFYOLUzGopu9HhGBoD2nx8JzV0
         qPw6z9+0Q1VWC1sn0zyQrZfap7xDcKebDoNlB3Yxf73kLAVhrfIfFW225eeqdc1BB4hs
         E6qJiQLmc6snWYiUY7/bLBeVKTQqGXEEd1RtjEBKi+4O6LvW9wrz0W22WarUc2Sg/gLt
         SODQo8Ezt65VX1cVMeDXBTzhwlRzj1Dahh8Wk533L48n0bEvtjTeQZpSZA3pKHNYPZXl
         iWZw==
X-Gm-Message-State: AOAM532pNwIQqSLp8z3nXbc5B/Llb4MuPIPsmuWIm//d5npX2EpcT26f
        zxRS/BQ3DlFR02n7a5+leHoXjVIGv36hK3N5cOhA5Q==
X-Google-Smtp-Source: ABdhPJyMp0JEFoq5k+TkLelgaF1BOTh+SGyM9IyQgrfNL96P2F0UUTVBmhi2BquXwcDTmsk1AJBVrc8gF37HbDJBjXk=
X-Received: by 2002:a05:6602:2f89:: with SMTP id u9mr3790721iow.99.1610601407508;
 Wed, 13 Jan 2021 21:16:47 -0800 (PST)
MIME-Version: 1.0
References: <20210113161819.1155526-1-eric.dumazet@gmail.com> <b0c5b2164e90492c99752584070510d7@AcuMS.aculab.com>
In-Reply-To: <b0c5b2164e90492c99752584070510d7@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 14 Jan 2021 06:16:35 +0100
Message-ID: <CANn89iKS-J8BzMd+_PmFV67C+3hPx-C0saY0yFMdDWfHPwazHQ@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 11:23 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 13 January 2021 16:18
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Both virtio net and napi_get_frags() allocate skbs
> > with a very small skb->head
> >
> > While using page fragments instead of a kmalloc backed skb->head might give
> > a small performance improvement in some cases, there is a huge risk of
> > under estimating memory usage.
>
> There is (or was last time I looked) also a problem with
> some of the USB ethernet drivers.
>
> IIRC one of the ASXnnnnnn (???) USB3 ones allocates 64k skb to pass
> to the USB stack and then just lies about skb->truesize when passing
> them into the network stack.

You sure ? I think I have fixed this at some point

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=a9e0aca4b37885b5599e52211f098bd7f565e749

> The USB hardware will merge TCP receives and put multiple ethernet
> packets into a single USB message.
> But single frames can end up in very big kernel memory buffers.
>

Yeah, this is a known problem.

Since 2009 I have sent numerous patches addressing truesize issues,
your help will be welcomed especially if you own the hardware and test
the patches.

git log --author dumazet --grep truesize --oneline --reverse
2b85a34e911bf483c27cfdd124aeb1605145dc80 net: No more expensive
sock_hold()/sock_put() on each tx
d361fd599a991ff6c1d522a599c635b35d61ef30 net: sock_free() optimizations
daebbca3ab41031666ee27f991b223d2bc0415e9 qlcnic: dont set skb->truesize
8df8fd27123054b02007361bd5483775db84b4a8 qlcnic: dont set skb->truesize
7e96dc7045bff8758804b047c0dfb6868f182500 netxen: dont set skb->truesize
3d13008e7345fa7a79d8f6438150dc15d6ba6e9d ip: fix truesize mismatch in
ip fragmentation
7a91b434e2bad554b709265db7603b1aa52dd92e net: update SOCK_MIN_RCVBUF
87fb4b7b533073eeeaed0b6bf7c2328995f6c075 net: more accurate skb truesize
bdb28a97f46b5307e6e9351de52a9dd03e711a2f be2net: fix truesize errors
a1f4e8bcbccf50cf1894c263af4d677d4f566533 bnx2: fix skb truesize underestimation
ed64b3cc11502f50e1401f12e33d021592800bca e1000: fix skb truesize underestimation
95b9c1dfb7b929f5f3b203ed95c28bdfd069d122 igb: fix skb truesize underestimation
98130646770db42cd14c44ba0d7f2d0eb8078820 ixgbe: fix skb truesize underestimation
98a045d7e4a59db0865a59eea2140fe36bc7c220 e1000e: fix skb truesize
underestimation
7ae60b3f3b297b7f04025c93f1cb2275c3a1dfcd sky2: fix skb truesize underestimation
5935f81c595897d213afcf756e3e41af7c704f0e ftgmac100: fix skb truesize
underestimation
5e6c355c47e75314fd2282d087616069d4093ecf vmxnet3: fix skb truesize
underestimation
e7e5a4033f765e2a37095cd0a73261c99840f77e niu: fix skb truesize underestimation
96cd8951684adaa5fd72952adef532d0b42f70e1 ftmac100: fix skb truesize
underestimation
9e903e085262ffbf1fc44a17ac06058aca03524a net: add skb frag size accessors
90278c9ffb8a92672d60a618a58a99e2370a98ac mlx4_en: fix skb truesize
underestimation
7b8b59617ead5acc6ff041a9ad2ea1fe7a58094f igbvf: fix truesize underestimation
924a4c7d2e962b4e6a8e9ab3aabfd2bb29e5ada9 myri10ge: fix truesize underestimation
e1ac50f64691de9a095ac5d73cb8ac73d3d17dba bnx2x: fix skb truesize underestimation
4b727361f0bc7ee7378298941066d8aa15023ffb virtio_net: fix truesize
underestimation
e52fcb2462ac484e6dd6e68869536609f0216938 bnx2x: uses build_skb() in receive path
dd2bc8e9c0685d8eaaaf06e65919e31d60478411 bnx2: switch to build_skb()
infrastructure
9205fd9ccab8ef51ad771c1917eed7b2f2225d45 tg3: switch to build_skb()
infrastructure
570e57bcbcc4df5581b1e9c806ab2b16e96ea7d3 atm: use SKB_TRUESIZE() in
atm_guess_pdu2truesize()
f07d960df33c5aef8f513efce0fd201f962f94a1 tcp: avoid frag allocation
for small frames
0fd7bac6b6157eed6cf0cb86a1e88ba29e57c033 net: relax rcvbuf limits
de8261c2fa364397ed872fad1244d75364689168 gro: fix truesize underestimation
19c6c8f58b5840fd4757233b4849f42687d2ef3a ppp: fix truesize underestimation
a9e0aca4b37885b5599e52211f098bd7f565e749 asix: asix_rx_fixup surgery
to reduce skb truesizes
c8628155ece363487b57d33441ea0359018c0fa7 tcp: reduce out_of_order memory use
50269e19ad990e79eeda101fc6df80cffd5d4831 net: add a truesize parameter
to skb_add_rx_frag()
21dcda6083a0573686acabca39b3f92ba032d333 f_phonet: fix skb truesize
underestimation
094b5855bf37eae4b297bc47bb5bc5454f1f6fab cdc-phonet: fix skb truesize
underestimation
da882c1f2ecadb0ed582628ec1585e36b137c0f0 tcp: sk_add_backlog() is too
agressive for TCP
1402d366019fedaa2b024f2bac06b7cc9a8782e1 tcp: introduce tcp_try_coalesce
d3836f21b0af5513ef55701dd3f50b8c42e44c7a net: allow skb->head to be a
page fragment
b49960a05e32121d29316cfdf653894b88ac9190 tcp: change tcp_adv_win_scale
and tcp_rmem[2]
ed90542b0ce5415050c6fbfca324bccaafa69f2f iwlwifi: fix skb truesize
underestimation
715dc1f342713816d1be1c37643a2c9e6ee181a7 net: Fix truesize accounting
in skb_gro_receive()
3cc4949269e01f39443d0fcfffb5bc6b47878d45 ipv4: use skb coalescing in
defragmentation
ec16439e173aaf56f62bd8e175e976fbd452497b ipv6: use skb coalescing in reassembly
313b037cf054ec908de92fb4c085403ffd7420d4 gianfar: fix potential
sk_wmem_alloc imbalance
b28ba72665356438e3a6e3be365c3c3071496840 IPoIB: fix skb truesize underestimatiom
9936a7bbe56df432838fef658aea6bcfdd994021 igb: reduce Rx header size
87c084a980325d877dc7e388b8f2f26d5d3b4d01 l2tp: dont play with skb->truesize
6ff50cd55545d922f5c62776fe1feb38a9846168 tcp: gso: do not generate out
of order packets
9eb5bf838d06aa6ddebe4aca6b5cedcf2eb53b86 net: sock: fix TCP_SKB_MIN_TRUESIZE
45fe142cefa864b685615bcb930159f6749c3667 iwl3945: better skb
management in rx path
4e4f1fc226816905c937f9b29dabe351075dfe0f tcp: properly increase
rcv_ssthresh for ofo packets
400dfd3ae899849b27d398ca7894e1b44430887f net: refactor sk_page_frag_refill()
0d08c42cf9a71530fef5ebcfe368f38f2dd0476f tcp: gso: fix truesize tracking
e33d0ba8047b049c9262fdb1fcafb93cb52ceceb net-gro: reset skb->truesize
in napi_reuse_skb()
b2532eb9abd88384aa586169b54a3e53574f29f8 tcp: fix ooo_okay setting vs
Small Queues
f2d9da1a8375cbe53df5b415d059429013a3a79f bna: fix skb->truesize underestimation
9878196578286c5ed494778ada01da094377a686 tcp: do not pace pure ack packets
0cef6a4c34b56a9a6894f2dad2fad4be789990e1 tcp: give prequeue mode some care
95b58430abe74f5e50970c57d27380bd5b8be324 fq_codel: add memory
limitation per queue
008830bc321c0fc22c0db8d5b0b56f854ed90a5c net_sched: fq_codel: cache
skb->truesize into skb->cb
c9c3321257e1b95be9b375f811fb250162af8d39 tcp: add tcp_add_backlog()
a297569fe00a8fae18547061d355c45ef191b483 net/udp: do not touch
skb->peeked unless really needed
c8c8b127091b758f5768f906bcdeeb88bc9951ca udp: under rx pressure, try
to condense skbs
c84d949057cab262b4d3110ead9a42a58c2958f7 udp: copy skb->truesize in
the first cache line
158f323b9868b59967ad96957c4ca388161be321 net: adjust skb->truesize in
pskb_expand_head()
48cac18ecf1de82f76259a54402c3adb7839ad01 ipv6: orphan skbs in reassembly unit
60c7f5ae5416a8491216bcccf6b3b3d842d69fa4 mlx4: removal of frag_sizes[]
b5a54d9a313645ec9607dc557b67d9325c28884c mlx4: use order-0 pages for RX
7162fb242cb8322beb558828fd26b33c3e9fc805 tcp: do not underestimate
skb->truesize in tcp_trim_head()
c21b48cc1bbf2f5af3ef54ada559f7fadf8b508b net: adjust skb->truesize in
___pskb_trim()
d1f496fd8f34a40458d0eda6be0655926559e546 bpf: restore skb->sk before
pskb_trim() call
f6ba8d33cfbb46df569972e64dbb5bb7e929bfd9 netem: fix skb_orphan_partial()
7ec318feeed10a64c0359ec4d10889cb4defa39a tcp: gso: avoid refcount_t
warning from tcp_gso_segment()
72cd43ba64fc172a443410ce01645895850844c8 tcp: free batches of packets
in tcp_prune_ofo_queue()
4672694bd4f1aebdab0ad763ae4716e89cb15221 ipv4: frags: handle possible
skb truesize change
50ce163a72d817a99e8974222dcf2886d5deb1ae tcp: tcp_grow_window() needs
to respect tcp_space()
d7cc399e1227e74e44f78847d9732a228b46cc91 tcp: properly reset
skb->truesize for tx recycling
24adbc1676af4e134e709ddc7f34cf2adc2131e4 tcp: fix SO_RCVLOWAT hangs
with fat skbs
