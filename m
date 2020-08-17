Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22BF2467F7
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgHQOIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728399AbgHQOIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 10:08:42 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC64C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 07:08:42 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o13so8193936pgf.0
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 07:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2guplUoAobBsWjvm+iNRIs9oT/4Rd9pg3s28+oMYvSM=;
        b=ax9+DvucjijpH8CqhnSpmrlCr1wNb9QcO1doj/SfB2DOAQBTdqA3PZmsj9/WwfPc9N
         ISKpZPtwfL3Bi/yEvmRuRjceqQzUQS7+GykHop7hImZKOmafyeuoXj+Y08jS2yDtRe7+
         MmVMaoyMrSiYnoF4qwPVOKXm5k7lI9y4fpo9ByOh8K9KJFq7/+xXrE5T5vi7dMH54ZHw
         RqUGuWfxX2I6s2poZyHr4nZ7123QM+GWmdpkjsXNkpx/stq8Rgov+z4MRiNVl6BO11T4
         hUxrNCGysoDdpTcUc91yvkqjp9XKqDjtsq4lASJfKNPCQQSfrdwCarxe4szdnCkVrocN
         Y7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2guplUoAobBsWjvm+iNRIs9oT/4Rd9pg3s28+oMYvSM=;
        b=na0OMTzg8J2OBhf6I2oR2e5YQZ1u9Gi3Hw1/KLoUpPRZWORaoi478NOHRz9l1SBSSR
         FLfceCTJ0L+b/hck9hUlSS17IB7MQM0W3n0X3ecusMO9CLncKUiCI/1bWwqV9DV6/Lk2
         3JVUoMMmzZOhwmiX9xT4wcU+48KCKfRVf0z0HwkFvP5pBzyXM1/xMGJMVgIGrQEXX/5E
         PZYu27xu0orlTW5D3CBKJLCQJGVAXjLlfq7DosBkTGm+v+F07hPDppaaqi9htt79wzQA
         BHDpgzF2+K3BcAAu7pmsZl4mXQsztPYOWhO0l1CWCxZZOCDLFcJQO7R3p8bQgg1cw+5i
         qQsQ==
X-Gm-Message-State: AOAM533KsO2sGzqZYj6sQg1R7S3dOLo6SmdPEMxxUCNU9SY7egTnqd0D
        KSJt3RoLqm9MJa9y3eCYyAP/rD3adwBQuSEb7vY=
X-Google-Smtp-Source: ABdhPJyy3fpYBSMLFgsnQaEQuycxoGcki0T1lQr341Lu9ixTvh124cfuL6B0l533fXN0i2VM3xV4j1XpJJ5pwWFw1Dw=
X-Received: by 2002:a63:d612:: with SMTP id q18mr10149228pgg.292.1597673321776;
 Mon, 17 Aug 2020 07:08:41 -0700 (PDT)
MIME-Version: 1.0
References: <1595253183-14935-1-git-send-email-magnus.karlsson@intel.com> <851cef2d-173d-859e-f2d5-5949a4fe2619@iogearbox.net>
In-Reply-To: <851cef2d-173d-859e-f2d5-5949a4fe2619@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 17 Aug 2020 16:08:27 +0200
Message-ID: <CAJ8uoz1Jze=buK4K9DRd7yzF7+fSSC3UbDfOOJPrrHC8GbOy9g@mail.gmail.com>
Subject: Re: [PATCH bpf v3] xsk: do not discard packet when QUEUE_STATE_FROZEN
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

On Tue, Jul 21, 2020 at 10:46 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/20/20 3:53 PM, Magnus Karlsson wrote:
> > In the skb Tx path, transmission of a packet is performed with
> > dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> > routines, it returns NETDEV_TX_BUSY signifying that it was not
> > possible to send the packet now, please try later. Unfortunately, the
> > xsk transmit code discarded the packet and returned EBUSY to the
> > application. Fix this unnecessary packet loss, by not discarding the
> > packet in the Tx ring and return EAGAIN. As EAGAIN is returned to the
> > application, it can then retry the send operation and the packet will
> > finally be sent as we will likely not be in the QUEUE_STATE_FROZEN
> > state anymore. So EAGAIN tells the application that the packet was not
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
> > v1->v3:
> > * Hinder dev_direct_xmit() from freeing and completing the packet to
> >    user space by manipulating the skb->users count as suggested by
> >    Daniel Borkmann.
> > ---
> >   net/xdp/xsk.c | 15 ++++++++++++++-
> >   1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 3700266..9e95c85 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -375,10 +375,23 @@ static int xsk_generic_xmit(struct sock *sk)
> >               skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
> >               skb->destructor = xsk_destruct_skb;
> >
> > +             /* Hinder dev_direct_xmit from freeing the packet and
> > +              * therefore completing it in the destructor
> > +              */
> > +             refcount_inc(&skb->users);
> >               err = dev_direct_xmit(skb, xs->queue_id);
> > +             if  (err == NETDEV_TX_BUSY) {
> > +                     /* QUEUE_STATE_FROZEN, tell app to retry the send */
> > +                     skb->destructor = NULL;
> > +                     kfree_skb(skb);
> > +                     err = -EAGAIN;
> > +                     goto out;
> > +             }
> > +
> >               xskq_cons_release(xs->tx);
> > +             kfree_skb(skb);
>
> What happens if this was properly 'consumed'. If you call kfree_skb() for these pkts,
> then doesn't this confuse perf drop monitor with false positives?

I have been on extended vacation, so sorry for the delay. The
trace_kfree_skb() is after the recounting check in kfree_skb. That
would mean that all "consumption"/freeing is moved to the code in this
patch. So if an skb was consumed/freed in dev_direct_xmit before this
patch, that same skb would show as consumed/freed in the
xsk_generic_xmit code instead with this patch. Do not see how we can
change that using this approach with refcounting, or do you have an
idea?

Another idea would be to just modify dev_direct_xmit() along the lines
that I originally suggested. But that would mean a small change to
AF_PACKET too as well as a driver that uses it for testing. So more
intrusive than the above, but the perf drop monitor would record it in
the correct place. Happy for suggestions on how to proceed.

Thanks: Magnus

> >               /* Ignore NET_XMIT_CN as packet might have been sent */
> > -             if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
> > +             if (err == NET_XMIT_DROP) {
> >                       /* SKB completed but not sent */
> >                       err = -EBUSY;
> >                       goto out;
> >
>
