Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB3456736
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfFZKyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:54:41 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32866 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfFZKyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:54:40 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hg5ZP-0005WW-TW; Wed, 26 Jun 2019 06:54:36 -0400
Date:   Wed, 26 Jun 2019 06:54:03 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
Message-ID: <20190626105403.GA31355@hmswarspite.think-freely.org>
References: <20190619202533.4856-1-nhorman@tuxdriver.com>
 <20190625215749.22840-1-nhorman@tuxdriver.com>
 <CAF=yD-+fCNGQyoRNAZngof3=_gGbHn9aSCQA_hNvFSsSZtZQxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-+fCNGQyoRNAZngof3=_gGbHn9aSCQA_hNvFSsSZtZQxA@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 06:30:08PM -0400, Willem de Bruijn wrote:
> > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > index a29d66da7394..a7ca6a003ebe 100644
> > --- a/net/packet/af_packet.c
> > +++ b/net/packet/af_packet.c
> > @@ -2401,6 +2401,9 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
> >
> >                 ts = __packet_set_timestamp(po, ph, skb);
> >                 __packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
> > +
> > +               if (!packet_read_pending(&po->tx_ring))
> > +                       complete(&po->skb_completion);
> >         }
> >
> >         sock_wfree(skb);
> > @@ -2585,7 +2588,7 @@ static int tpacket_parse_header(struct packet_sock *po, void *frame,
> >
> >  static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> >  {
> > -       struct sk_buff *skb;
> > +       struct sk_buff *skb = NULL;
> >         struct net_device *dev;
> >         struct virtio_net_hdr *vnet_hdr = NULL;
> >         struct sockcm_cookie sockc;
> > @@ -2600,6 +2603,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> >         int len_sum = 0;
> >         int status = TP_STATUS_AVAILABLE;
> >         int hlen, tlen, copylen = 0;
> > +       long timeo = 0;
> >
> >         mutex_lock(&po->pg_vec_lock);
> >
> > @@ -2646,12 +2650,21 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> >         if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
> >                 size_max = dev->mtu + reserve + VLAN_HLEN;
> >
> > +       reinit_completion(&po->skb_completion);
> > +
> >         do {
> >                 ph = packet_current_frame(po, &po->tx_ring,
> >                                           TP_STATUS_SEND_REQUEST);
> >                 if (unlikely(ph == NULL)) {
> > -                       if (need_wait && need_resched())
> > -                               schedule();
> > +                       if (need_wait && skb) {
> > +                               timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
> > +                               timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
> 
> This looks really nice.
> 
> But isn't it still susceptible to the race where tpacket_destruct_skb
> is called in between po->xmit and this
> wait_for_completion_interruptible_timeout?
> 
Thats not an issue, since the complete is only gated on packet_read_pending
reaching 0 in tpacket_destuct_skb.  Previously it was gated on my
wait_on_complete flag being non-zero, so we had to set that prior to calling
po->xmit, or the complete call might never get made, resulting in a hang.  Now,
we will always call complete, and the completion api allows for arbitrary
ordering of complete/wait_for_complete (since its internal done variable gets
incremented), making a call to wait_for_complete effectively a fall through if
complete gets called first.

There is an odd path here though.  If an application calls sendmsg on a packet
socket here with MSG_DONTWAIT set, then need_wait will be zero, and we will
eventually exit this loop without ever having called wait_for_complete, but
tpacket_destruct_skb will still have called complete when all the frames
complete transmission.  In and of itself, thats fine, but it leave the
completion structure in a state where its done variable will have been
incremented at least once (specifically it will be set to N, where N is the
number of frames transmitted during the call where MSG_DONTWAIT is set).  If the
application then calls sendmsg on this socket with MSG_DONTWAIT clear, we will
call wait_for_complete, but immediately return from it (due to the previously
made calls to complete).  I've corrected this however, but adding that call to
reinit_completion prior to the loop entry, so that we are always guaranteed to
have the completion variable set properly to wait for only the frames being sent
in this particular instance of the sendmsg call.

> The test for skb is shorthand for packet_read_pending  != 0, right?
> 
Sort of.  gating on skb guarantees for us that we have sent at least one frame
in this call to tpacket_snd.  If we didn't do that, then it would be possible
for an application to call sendmsg without setting any frames in the buffer to
TP_STATUS_SEND_REQUEST, which would cause us to wait for a completion without
having sent any frames, meaning we would block waiting for an event
(tpacket_destruct_skb), that will never happen.  The check for skb ensures that
tpacket_snd_skb will get called, and that we will get a wakeup from a call to
wait_for_complete.  It does suggest that packet_read_pending != 0, but thats not
guaranteed, because tpacket_destruct_skb may already have been called (see the
above explination regarding ordering of complete/wait_for_complete).

Neil
