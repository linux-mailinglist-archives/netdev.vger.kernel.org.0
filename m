Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E041F21DDE4
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgGMQxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:53:21 -0400
Received: from smtp4.emailarray.com ([65.39.216.22]:34691 "EHLO
        smtp4.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMQxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:53:21 -0400
Received: (qmail 29801 invoked by uid 89); 13 Jul 2020 16:53:18 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 13 Jul 2020 16:53:18 -0000
Date:   Mon, 13 Jul 2020 09:53:15 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        A.Zema@falconvsystems.com
Subject: Re: [PATCH bpf v2] xsk: fix memory leak and packet loss in Tx skb
 path
Message-ID: <20200713165315.bmrvqmiiirtdixct@bsd-mbp>
References: <1594363554-4076-1-git-send-email-magnus.karlsson@intel.com>
 <3e42533f-fb6e-d6fa-af48-cb7f5c70890b@iogearbox.net>
 <CAJ8uoz3WhJkqN2=D+VP+ikvY2_WTRx7Pcuihr_8qJiYh0DUtog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz3WhJkqN2=D+VP+ikvY2_WTRx7Pcuihr_8qJiYh0DUtog@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 09:39:58AM +0200, Magnus Karlsson wrote:
> On Sat, Jul 11, 2020 at 1:28 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > Hi Magnus,
> >
> > On 7/10/20 8:45 AM, Magnus Karlsson wrote:
> > > In the skb Tx path, transmission of a packet is performed with
> > > dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> > > routines, it returns NETDEV_TX_BUSY signifying that it was not
> > > possible to send the packet now, please try later. Unfortunately, the
> > > xsk transmit code discarded the packet, missed to free the skb, and
> > > returned EBUSY to the application. Fix this memory leak and
> > > unnecessary packet loss, by not discarding the packet in the Tx ring,
> > > freeing the allocated skb, and return EAGAIN. As EAGAIN is returned to the
> > > application, it can then retry the send operation and the packet will
> > > finally be sent as we will likely not be in the QUEUE_STATE_FROZEN
> > > state anymore. So EAGAIN tells the application that the packet was not
> > > discarded from the Tx ring and that it needs to call send()
> > > again. EBUSY, on the other hand, signifies that the packet was not
> > > sent and discarded from the Tx ring. The application needs to put the
> > > packet on the Tx ring again if it wants it to be sent.
> > >
> > > Fixes: 35fcde7f8deb ("xsk: support for Tx")
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> > > Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> > > ---
> > > The v1 of this patch was called "xsk: do not discard packet when
> > > QUEUE_STATE_FROZEN".
> > > ---
> > >   net/xdp/xsk.c | 13 +++++++++++--
> > >   1 file changed, 11 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > index 3700266..5304250 100644
> > > --- a/net/xdp/xsk.c
> > > +++ b/net/xdp/xsk.c
> > > @@ -376,13 +376,22 @@ static int xsk_generic_xmit(struct sock *sk)
> > >               skb->destructor = xsk_destruct_skb;
> > >
> > >               err = dev_direct_xmit(skb, xs->queue_id);
> > > -             xskq_cons_release(xs->tx);
> > >               /* Ignore NET_XMIT_CN as packet might have been sent */
> > > -             if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
> > > +             if (err == NET_XMIT_DROP) {
> > >                       /* SKB completed but not sent */
> > > +                     xskq_cons_release(xs->tx);
> > >                       err = -EBUSY;
> > >                       goto out;
> > > +             } else if  (err == NETDEV_TX_BUSY) {
> > > +                     /* QUEUE_STATE_FROZEN, tell application to
> > > +                      * retry sending the packet
> > > +                      */
> > > +                     skb->destructor = NULL;
> > > +                     kfree_skb(skb);
> > > +                     err = -EAGAIN;
> > > +                     goto out;
> >
> > Hmm, I'm probably missing something or I should blame my current lack of coffee,
> > but I'll ask anyway.. What is the relation here to the kfree_skb{,_list}() in
> > dev_direct_xmit() when we have NETDEV_TX_BUSY condition? Wouldn't the patch above
> > double-free with NETDEV_TX_BUSY?
> 
> I think you are correct even without coffee :-). I misinterpreted the
> following piece of code in dev_direct_xmit():
> 
> if (!dev_xmit_complete(ret))
>      kfree_skb(skb);

I did look carefuly at this, but apparently forgot about the "!" part of
the conditional while looking at dev_xmit_complete() internals:

    return (NETDEV_TX_BUSY < NET_XMIT_MASK)
    return (0x10 < 0x0f)
    return false;
-- 
Jonathan
