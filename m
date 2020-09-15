Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0793F26AB0C
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 19:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgIORrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 13:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgIORqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:46:47 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F008C06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 10:46:47 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so2345843pgm.11
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 10:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qfpq2MCHkCwTsmvWqbXjdyiMj7C28YiV5Nw+yHAuUhA=;
        b=vDC+Y7OGN5p9QZ/FseRX1g9GOmjqAnefJS4RxAr2jXvq2mEhXTUlOgSjhWclh+uuW3
         4U8j+E3on5PHJjzQ+dFRltrX8whgBYMA7pm+Mu2AXOvgoz0piNlqpFpHwsIeBRIShRNI
         xeoK6BXRB0bNimyQuDxSdlCbZ/e8/+vTztgFONm7Uqi7R6KZ65tAwwOIU1LSc92sMtGp
         JjnvH6mHXw9+OH8h39Una99TARedXRr7Lfi95PccnWs+nJIr4V4CK+KJlJWCsnDO2XZQ
         BaEbC8HGHEfj+8UwKPdhCgNxP9KqwE5N2vBpPUyuKUnxcPDbjFqOGJDsnzFwwrjKQaBM
         S7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qfpq2MCHkCwTsmvWqbXjdyiMj7C28YiV5Nw+yHAuUhA=;
        b=aZ8qVLS9cp7pp3tUqKRq7deazq0knMrFZzYtS8w4ZcwosDkf8sOwCDOwwCwMaHhlOh
         HixP+0OPVgwgstZo+GI2pORbVBnD/r456cvsFDb2O3xS3/uorZSjfh7+lQdBaLfKLHaU
         MavhM0xZmy1GSbjCEMoQbWvTFvjZN18NnTaDt3u+bpPSCkHeH08fxRMCgHO20ifuyTwv
         tTLQHiaQjml+pPieAcQNpJVJUWhqZVDsnF6k7gjdG4SH2UdMwGQA4LVR5TKMrArpQycv
         Wepi5YgmQ4yNShj2B+iO8huLHkgI8Pv/0VKVT8vFYmgrCI4SwNjGvqtXXZQiMD8UNA0m
         FZUg==
X-Gm-Message-State: AOAM530RDy9F0xoduYWyiXTRmDKtoumzaP4gloXIa9a3uq+M6uR/7LYH
        gdwFkbl8c+FCUXH/qEDf8P7h70clgqwYoaa0C/jrOB/7zGdYLA==
X-Google-Smtp-Source: ABdhPJzhwM4RXIY+K1jEK8fqcFv6rmgQr+12UGr2rdPIeco89ke+fRocWiGukVgjz4XevvomghOHwB5HI30JXnUl3cg=
X-Received: by 2002:a62:6845:0:b029:13e:dcd:75bd with SMTP id
 d66-20020a6268450000b029013e0dcd75bdmr18923082pfc.12.1600192006848; Tue, 15
 Sep 2020 10:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <1599828221-19364-1-git-send-email-magnus.karlsson@gmail.com> <6e58cde8-9e38-079a-589d-7b7a860ef61e@iogearbox.net>
In-Reply-To: <6e58cde8-9e38-079a-589d-7b7a860ef61e@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 15 Sep 2020 19:46:35 +0200
Message-ID: <CAJ8uoz2nYwGROzRwevT2X5U-XyGePrbJyM63iE1QZL=V-Y4pUg@mail.gmail.com>
Subject: Re: [PATCH bpf v4] xsk: do not discard packet when NETDEV_TX_BUSY
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
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

On Tue, Sep 15, 2020 at 5:49 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hey Magnus,
>
> On 9/11/20 2:43 PM, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > In the skb Tx path, transmission of a packet is performed with
> > dev_direct_xmit(). When NETDEV_TX_BUSY is set in the drivers, it
> > signifies that it was not possible to send the packet right now,
> > please try later. Unfortunately, the xsk transmit code discarded the
> > packet and returned EBUSY to the application. Fix this unnecessary
> > packet loss, by not discarding the packet in the Tx ring and return
> > EAGAIN. As EAGAIN is returned to the application, it can then retry
> > the send operation later and the packet will then likely be sent as
> > the driver will then likely have space/resources to send the packet.
> >
> > In summary, EAGAIN tells the application that the packet was not
> > discarded from the Tx ring and that it needs to call send()
> > again. EBUSY, on the other hand, signifies that the packet was not
> > sent and discarded from the Tx ring. The application needs to put the
> > packet on the Tx ring again if it wants it to be sent.
> >
> > Fixes: 35fcde7f8deb ("xsk: support for Tx")
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> > Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> > Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> > ---
> > v3->v4:
> > * Free the skb without triggering the drop trace when NETDEV_TX_BUSY
> > * Call consume_skb instead of kfree_skb when the packet has been
> >    sent successfully for correct tracing
> > * Use sock_wfree as destructor when NETDEV_TX_BUSY
> > v1->v3:
> > * Hinder dev_direct_xmit() from freeing and completing the packet to
> >    user space by manipulating the skb->users count as suggested by
> >    Daniel Borkmann.
> > ---
> >   net/xdp/xsk.c | 17 ++++++++++++++++-
> >   1 file changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index c323162..d32e39d 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -377,15 +377,30 @@ static int xsk_generic_xmit(struct sock *sk)
> >               skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
> >               skb->destructor = xsk_destruct_skb;
> >
> > +             /* Hinder dev_direct_xmit from freeing the packet and
> > +              * therefore completing it in the destructor
> > +              */
> > +             refcount_inc(&skb->users);
> >               err = dev_direct_xmit(skb, xs->queue_id);
> > +             if  (err == NETDEV_TX_BUSY) {
> > +                     /* Tell user-space to retry the send */
> > +                     skb->destructor = sock_wfree;
>
> I see, good catch, you need this one here as otherwise you leak wmem accounting
> given it's also part of xsk_destruct_skb() and we do free the prior allocated skb
> in this case.
>
> > +                     /* Free skb without triggering the perf drop trace */
> > +                     __kfree_skb(skb);
>
> As a minor nit, I would just use consume_skb(skb) here given this doesn't blindly
> ignore the skb_unref(). It's mostly about seeing where drops are happening so that
> tracepoint is set to kfree_skb() which is the more interesting one. Other than that
> looks good and ready to go. Thanks (& sorry for late reply)!

Thank you for reviewing this. I will spin a v5.

> > +                     err = -EAGAIN;
> > +                     goto out;
> > +             }
> > +
> >               xskq_cons_release(xs->tx);
> >               /* Ignore NET_XMIT_CN as packet might have been sent */
> > -             if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
> > +             if (err == NET_XMIT_DROP) {
> >                       /* SKB completed but not sent */
> > +                     kfree_skb(skb);
> >                       err = -EBUSY;
> >                       goto out;
> >               }
> >
> > +             consume_skb(skb);
> >               sent_frame = true;
> >       }
> >
> >
>
