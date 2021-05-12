Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74AF37EEA8
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346022AbhELWEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 18:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245108AbhELWCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 18:02:55 -0400
Received: from warlock.wand.net.nz (warlock.cms.waikato.ac.nz [IPv6:2001:df0:4:4000::250:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914ABC061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 15:01:42 -0700 (PDT)
Received: from [209.85.214.178] (helo=mail-pl1-f178.google.com)
        by warlock.wand.net.nz with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.84_2)
        (envelope-from <rsanger@wand.net.nz>)
        id 1lgwvE-0004ut-8K
        for netdev@vger.kernel.org; Thu, 13 May 2021 10:01:40 +1200
Received: by mail-pl1-f178.google.com with SMTP id t4so13282109plc.6
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 15:01:38 -0700 (PDT)
X-Gm-Message-State: AOAM531X0cQnCg8cvpNvLYJuyMzKgMiisBj9KYlJq/THVRHjPgB+naWq
        kHY7mjO1LksHlc8IQjamjdwzFXuiurtZZ76MCkU=
X-Google-Smtp-Source: ABdhPJzm3Rx8BxMxf1k/bwqMY/LRHTqG2ebtjqz37rlihCOpfQd6zGLCfRwjANNWgVkf1xpYRRwA7GNoZTE7hwj9qLc=
X-Received: by 2002:a17:902:b285:b029:ef:9419:b914 with SMTP id
 u5-20020a170902b285b02900ef9419b914mr1798079plr.59.1620856896544; Wed, 12 May
 2021 15:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <1620783082-28906-1-git-send-email-rsanger@wand.net.nz> <CA+FuTSdygqm6WM6NbDuiBn1MwSAezBkr+tez8E_bmZCk4HhihA@mail.gmail.com>
In-Reply-To: <CA+FuTSdygqm6WM6NbDuiBn1MwSAezBkr+tez8E_bmZCk4HhihA@mail.gmail.com>
From:   Richard Sanger <rsanger@wand.net.nz>
Date:   Thu, 13 May 2021 10:01:25 +1200
X-Gmail-Original-Message-ID: <CAN6QFNwPapm7Uio_jPYuCyttW5dMEGcACPUzRfNHyXt+mJhO=w@mail.gmail.com>
Message-ID: <CAN6QFNwPapm7Uio_jPYuCyttW5dMEGcACPUzRfNHyXt+mJhO=w@mail.gmail.com>
Subject: Re: [PATCH v2] net: packetmmap: fix only tx timestamp on request
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Received-SPF: softfail client-ip=209.85.214.178; envelope-from=rsanger@wand.net.nz; helo=mail-pl1-f178.google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 2:24 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, May 11, 2021 at 9:32 PM Richard Sanger <rsanger@wand.net.nz> wrote:
> >
> > The packetmmap tx ring should only return timestamps if requested via
> > setsockopt PACKET_TIMESTAMP, as documented. This allows compatibility
> > with non-timestamp aware user-space code which checks
> > tp_status == TP_STATUS_AVAILABLE; not expecting additional timestamp
> > flags to be set in tp_status.
> >
> > Fixes: b9c32fb27170 ("packet: if hw/sw ts enabled in rx/tx ring, report which ts we got")
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Signed-off-by: Richard Sanger <rsanger@wand.net.nz>
>
> Code LGTM.
>
> It would be good to capture more of the context: when these spurious
> timestamps can appear (network namespaces) and as of which commit (the
> one that changes orphaning). As is, I would not be able to understand
> the issue addressed from this commit message alone.
>
> Instead of adding context to the commit, you could also add a Link tag
> to the archived email thread, if you prefer.
>
> And perhaps: [PATCH net v3] net/packet: return software transmit
> timestamp only when requested
>

Ahh, looks like this patch has just been merged in.

For anyone looking for more details they are in this thread:
https://lore.kernel.org/netdev/1620085579-5646-1-git-send-email-rsanger@wand.net.nz/

>
> > ---
> >  net/packet/af_packet.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > index ba96db1..ae906eb 100644
> > --- a/net/packet/af_packet.c
> > +++ b/net/packet/af_packet.c
> > @@ -422,7 +422,8 @@ static __u32 tpacket_get_timestamp(struct sk_buff *skb, struct timespec64 *ts,
> >             ktime_to_timespec64_cond(shhwtstamps->hwtstamp, ts))
> >                 return TP_STATUS_TS_RAW_HARDWARE;
> >
> > -       if (ktime_to_timespec64_cond(skb->tstamp, ts))
> > +       if ((flags & SOF_TIMESTAMPING_SOFTWARE) &&
> > +           ktime_to_timespec64_cond(skb->tstamp, ts))
> >                 return TP_STATUS_TS_SOFTWARE;
> >
> >         return 0;
> > @@ -2340,7 +2341,12 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
> >
> >         skb_copy_bits(skb, 0, h.raw + macoff, snaplen);
> >
> > -       if (!(ts_status = tpacket_get_timestamp(skb, &ts, po->tp_tstamp)))
> > +       /* Always timestamp; prefer an existing software timestamp taken
> > +        * closer to the time of capture.
> > +        */
> > +       ts_status = tpacket_get_timestamp(skb, &ts,
> > +                                         po->tp_tstamp | SOF_TIMESTAMPING_SOFTWARE);
> > +       if (!ts_status)
> >                 ktime_get_real_ts64(&ts);
> >
> >         status |= ts_status;
> > --
> > 2.7.4
> >
