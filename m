Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005E6374C0B
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 01:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhEEXns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 19:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhEEXnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 19:43:47 -0400
Received: from warlock.wand.net.nz (warlock.cms.waikato.ac.nz [IPv6:2001:df0:4:4000::250:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD55C061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 16:42:50 -0700 (PDT)
Received: from [209.85.215.174] (helo=mail-pg1-f174.google.com)
        by warlock.wand.net.nz with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.84_2)
        (envelope-from <rsanger@wand.net.nz>)
        id 1leRAG-0003sS-3p
        for netdev@vger.kernel.org; Thu, 06 May 2021 11:42:48 +1200
Received: by mail-pg1-f174.google.com with SMTP id z16so3268972pga.1
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 16:42:45 -0700 (PDT)
X-Gm-Message-State: AOAM531iOywyzWi2hvSJRH6kxsuOK9qK3GqJLAWZKh4sW+mti4atmMrm
        1PYVqgm2siFK7B2w48ekho8VFCsPGIcwN9rcOwI=
X-Google-Smtp-Source: ABdhPJy4MvTNMuXU+UUa3VoS149tRJM+1zQySOn3oYFvOJ/4cIiaS0ktUaXxkuJ89eHEBR5RwXbH/xO1ZpwtH1Cm99I=
X-Received: by 2002:a65:41c6:: with SMTP id b6mr9946107pgq.135.1620188958428;
 Tue, 04 May 2021 21:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <1620085579-5646-1-git-send-email-rsanger@wand.net.nz>
 <CA+FuTSeDTYMZzT3n3tfm9KPCRx_ObWU-HaU4JxZCSCm_8sf2XA@mail.gmail.com>
 <CAN6QFNzj9+Y3W2eYTpHzVVjy_sYN+9d_Sa99HgQ0KgKyNmpeNw@mail.gmail.com> <CA+FuTSfE9wW55BbYRWNE1=XYAjG7gKVLLLbfAvB-4F+dL=8gHA@mail.gmail.com>
In-Reply-To: <CA+FuTSfE9wW55BbYRWNE1=XYAjG7gKVLLLbfAvB-4F+dL=8gHA@mail.gmail.com>
From:   Richard Sanger <rsanger@wand.net.nz>
Date:   Wed, 5 May 2021 16:29:06 +1200
X-Gmail-Original-Message-ID: <CAN6QFNw9xx0F35RNxDJS-4xbYu4SdU=XND=_dqCkGJgdNj5Hqw@mail.gmail.com>
Message-ID: <CAN6QFNw9xx0F35RNxDJS-4xbYu4SdU=XND=_dqCkGJgdNj5Hqw@mail.gmail.com>
Subject: Re: [PATCH] net: packetmmap: fix only tx timestamp on request
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Received-SPF: softfail client-ip=209.85.215.174; envelope-from=rsanger@wand.net.nz; helo=mail-pg1-f174.google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 5, 2021 at 2:45 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, May 3, 2021 at 9:22 PM Richard Sanger <rsanger@wand.net.nz> wrote:
> >
> > Hi Willem,
> >
> > This is to match up with the documented behaviour; see the timestamping section
> > at the bottom of
> > https://www.kernel.org/doc/html/latest/networking/packet_mmap.html
[ ... ]
>
> Then this would need a
>
> Fixes: b9c32fb27170 ("packet: if hw/sw ts enabled in rx/tx ring,
> report which ts we got")

ack, I will resubmit the patch with that as the summary line of the commit
message.

> I don't fully follow the commit message in that patch for why enabling
> this unconditionally on Tx is safe:
>
[...]
>
> But I think the point is that tx packets are not timestamped unless
> skb_shinfo(skb)->tx_flags holds a timestamp request. Such as for
> the software timestamps that veth can now generate:
>

I came to the same understanding, tx timestamping should be disabled unless
the code calls setsockopt SOL_SOCKET/SO_TIMESTAMPING.

> "
> static inline void skb_tx_timestamp(struct sk_buff *skb)
> {
>         skb_clone_tx_timestamp(skb);
>         if (skb_shinfo(skb)->tx_flags & SKBTX_SW_TSTAMP)
>                 skb_tstamp_tx(skb, NULL);
> }
> "
>
> So unless this packet socket has SOF_TIMESTAMPING_TX_SOFTWARE
> configured, no timestamps should be recorded for its packets, as tx flag
> SKBTX_SW_TSTAMP is not set.

You are right, that check is working correctly, I'm mistaken on the trigger of
this behaviour. It doesn't appear related to aa4e689ed1
(veth: add software timestamping). In fact, this bug is present in Linux 4.19
the version before that patch was added, and likely earlier versions too.

I've just verified using printk() that after the call to skb_tx_timestamp(skb)
in veth_xmit() skb->tstamp == 0 as expected.

However, when skb_tx_timestamp() is called within the packetmmap code path
skb->tstamp holds a valid time.

> > This patch corrects the behaviour for the tx path. But, doesn't change the
> > behaviour on the rx path. The rx path still includes a timestamp (hence
> > the patch always sets the SOF_TIMESTAMPING_SOFTWARE flag on rx).
>
> Right, this patch suppresses reporting of any recorded timestamps. But
> the system should already be suppressing recording of these
> timestamps.
>
> Assuming you discovered this with a real application: does it call
> setsockopt SOL_SOCKET/SO_TIMESTAMPING at all?
>

Yes, I can confirm my code does not setsockopt SO_TIMESTAMPING
Here is the filtered output of strace

# strace ./test-live -c 1 ring:veth0 2>&1  | grep sock
socket(AF_PACKET, SOCK_RAW, htons(0 /* ETH_P_??? */)) = 3
setsockopt(3, SOL_PACKET, PACKET_VERSION, [1], 4) = 0
setsockopt(3, SOL_PACKET, PACKET_TX_RING, {tp_block_size=1048576,
tp_block_nr=1, tp_frame_size=4096, tp_frame_nr=256}, 16) = 0
socket(AF_UNIX, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 4

> It's safe to suppress on the reporting side as extra precaution against
> spuriously timestamped packets. I just want to understand how these
> timestamps are even recorded in the first place.
>

Agreed, if this isn't expected behaviour, how skb->tstamp is getting filled
with a timestamp remains a mystery to me. I'll report back if I find the
source.

> Small nit wrt the patch: the comment "/* always timestamp; prefer an
> existing software timestamp */" states what the code does, but more
> interesting would be why.

Absolutely, I'll replace it with something along the lines of
/* always timestamp; prefer an existing software timestamp taken closer to
   the time of capture */
