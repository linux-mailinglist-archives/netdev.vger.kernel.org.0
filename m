Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D0F221B83
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgGPEn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgGPEn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:43:28 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB90C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:43:27 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id b77so2296918vsd.8
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N7a4guMlCO2EYx8RCRVOVcAZ+5T9NCs+hZCZ6UdU2j0=;
        b=cMp5PM2i/9Bdsie6eN2jYLJAGVo8tdq9scOCWtqkdX8ICBJx4zFxYoOZExL9B6i0kE
         6E4tk+2FlFvDLAcPVXSKIEY600RNujf22T2g1vGpH0Yb/lUrSmVDvGwoJHS9CSqDeTr2
         DzA8Nwj7G29jEnsY2dPZt0ygY1Pqvt3MADcYBnhDlUI2mcnalPvg0/xwDyybdiVAzyed
         9JJnrJAyFmuvhE2cWP2u+bfa13JPnm970y0T6cvEIcOhZdRUOHzHehzNiCdvgiLZiKZI
         s+WqkZGuCLbpfzwg9EfmI38cmnEs7RyR1F5mVw9hQ+B2myg/ze8y+Bd/eqfZxpFyXCar
         j9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N7a4guMlCO2EYx8RCRVOVcAZ+5T9NCs+hZCZ6UdU2j0=;
        b=ST5D66O16mvMsVE4qWNVaBjjvI/bTrmSNrMbqWNYTEkxgu1qfOMgRx+fHQNamZ5whd
         18hJS5zraUoMIrcmDonzrpXgdJ/Nb7rDydLtImSnPVvSRHn7Gy3c0IeHtKC7GlJZFhmh
         74Gs3UhuZZXUp8R5tOhyXAaN5n1dDZGXDWLwA/C1OTZPjvJ6f0X1EBQzkt1Akizu6lEE
         EnHN0VhU7jjsk6QOz/q27odHstxLzSxfZQxXli3DdB724eOtKG3S/aswib5yNwoixtN/
         T73rakdOTtLoatVyUb1cW4evfoFCp7d/E79OAH+ZKaq4kttp11ULh0/2UKMEtBkAT3lw
         1aQw==
X-Gm-Message-State: AOAM533gzpJnymSBdO+43zWPOUzW6uipDqd1+HEJC9lcmsK78V0QLiPw
        LCL1f8aIRBflqb1OZUvY8U4Bqoz0gbYD0VB5ajonrXVyWG5+kQ==
X-Google-Smtp-Source: ABdhPJwQjjIw23evLmY0UYiKdzMtiHJ7uLBcy8FlNWe+de7Srka2Ji7lM6IMigp1MryXCwzkQ8sMqxm4s6nCJkxed+E=
X-Received: by 2002:a67:ed59:: with SMTP id m25mr1872194vsp.218.1594874606851;
 Wed, 15 Jul 2020 21:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <1594363554-4076-1-git-send-email-magnus.karlsson@intel.com>
 <3e42533f-fb6e-d6fa-af48-cb7f5c70890b@iogearbox.net> <CAJ8uoz3WhJkqN2=D+VP+ikvY2_WTRx7Pcuihr_8qJiYh0DUtog@mail.gmail.com>
 <a6bee4f6-10a9-abbd-1b90-bf4a7c82dacc@iogearbox.net>
In-Reply-To: <a6bee4f6-10a9-abbd-1b90-bf4a7c82dacc@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 16 Jul 2020 06:43:18 +0200
Message-ID: <CAJ8uoz28bxEPYvZW_QPh1TagphKcB5knztE7sC1L+j1Y1eDrJg@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xsk: fix memory leak and packet loss in Tx skb path
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        A.Zema@falconvsystems.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 8:36 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/11/20 9:39 AM, Magnus Karlsson wrote:
> > On Sat, Jul 11, 2020 at 1:28 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On 7/10/20 8:45 AM, Magnus Karlsson wrote:
> >>> In the skb Tx path, transmission of a packet is performed with
> >>> dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> >>> routines, it returns NETDEV_TX_BUSY signifying that it was not
> >>> possible to send the packet now, please try later. Unfortunately, the
> >>> xsk transmit code discarded the packet, missed to free the skb, and
> >>> returned EBUSY to the application. Fix this memory leak and
> >>> unnecessary packet loss, by not discarding the packet in the Tx ring,
> >>> freeing the allocated skb, and return EAGAIN. As EAGAIN is returned to the
> >>> application, it can then retry the send operation and the packet will
> >>> finally be sent as we will likely not be in the QUEUE_STATE_FROZEN
> >>> state anymore. So EAGAIN tells the application that the packet was not
> >>> discarded from the Tx ring and that it needs to call send()
> >>> again. EBUSY, on the other hand, signifies that the packet was not
> >>> sent and discarded from the Tx ring. The application needs to put the
> >>> packet on the Tx ring again if it wants it to be sent.
> >>>
> >>> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> >>> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> >>> Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> >>> Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> >>> ---
> >>> The v1 of this patch was called "xsk: do not discard packet when
> >>> QUEUE_STATE_FROZEN".
> >>> ---
> >>>    net/xdp/xsk.c | 13 +++++++++++--
> >>>    1 file changed, 11 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> >>> index 3700266..5304250 100644
> >>> --- a/net/xdp/xsk.c
> >>> +++ b/net/xdp/xsk.c
> >>> @@ -376,13 +376,22 @@ static int xsk_generic_xmit(struct sock *sk)
> >>>                skb->destructor = xsk_destruct_skb;
> >>>
> >>>                err = dev_direct_xmit(skb, xs->queue_id);
> >>> -             xskq_cons_release(xs->tx);
> >>>                /* Ignore NET_XMIT_CN as packet might have been sent */
> >>> -             if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
> >>> +             if (err == NET_XMIT_DROP) {
> >>>                        /* SKB completed but not sent */
> >>> +                     xskq_cons_release(xs->tx);
> >>>                        err = -EBUSY;
> >>>                        goto out;
> >>> +             } else if  (err == NETDEV_TX_BUSY) {
> >>> +                     /* QUEUE_STATE_FROZEN, tell application to
> >>> +                      * retry sending the packet
> >>> +                      */
> >>> +                     skb->destructor = NULL;
> >>> +                     kfree_skb(skb);
> >>> +                     err = -EAGAIN;
> >>> +                     goto out;
> >>
> >> Hmm, I'm probably missing something or I should blame my current lack of coffee,
> >> but I'll ask anyway.. What is the relation here to the kfree_skb{,_list}() in
> >> dev_direct_xmit() when we have NETDEV_TX_BUSY condition? Wouldn't the patch above
> >> double-free with NETDEV_TX_BUSY?
> >
> > I think you are correct even without coffee :-). I misinterpreted the
> > following piece of code in dev_direct_xmit():
> >
> > if (!dev_xmit_complete(ret))
> >       kfree_skb(skb);
> >
> > If the skb was NOT consumed by the transmit, then it goes and frees
> > the skb. NETDEV_TX_BUSY as a return value will make
> > dev_xmit_complete() return false which triggers the freeing of the
> > skb. So if I now understand dev_direct_xmit() correctly, it will
> > always consume the skb, even when NETDEV_TX_BUSY is returned. And this
> > is what I would like to avoid. If the skb is freed, the destructor is
> > triggered and it will complete the packet to user-space, which is the
> > same thing as dropping it, which is what I want to avoid in the first
> > place since it is completely unnecessary.
> >
> > So what would be the best way to solve this? Prefer to share the code
> > with AF_PACKET if possible. Introduce a boolean function parameter to
> > indicate if it should be freed in this case? Other ideas? Here are the
> > users of dev_direct_xmit():
>
> Another option could be looking at pktgen which mangles skb->users to keep
> the skb alive.

Thanks. Will take a look at that and give it a try.

/Magnus

> Thanks,
> Daniel
