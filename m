Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF8C4FB59
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 13:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFWLkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 07:40:32 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57513 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfFWLkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 07:40:32 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hf0rD-00081E-QE; Sun, 23 Jun 2019 07:40:29 -0400
Date:   Sun, 23 Jun 2019 07:40:21 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
Message-ID: <20190623114021.GB10908@hmswarspite.think-freely.org>
References: <20190619202533.4856-1-nhorman@tuxdriver.com>
 <20190622174154.14473-1-nhorman@tuxdriver.com>
 <CAF=yD-JC_r1vjitN1ccyvQ3DXiP9BNCwq9iiWU11cXznmhAY8Q@mail.gmail.com>
 <CAF=yD-+8NDiL0dxM+eOFyiwi1ZhCW29dW--+VeEkssUaJqedWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-+8NDiL0dxM+eOFyiwi1ZhCW29dW--+VeEkssUaJqedWg@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 22, 2019 at 10:21:31PM -0400, Willem de Bruijn wrote:
> > > -static void __packet_set_status(struct packet_sock *po, void *frame, int status)
> > > +static void __packet_set_status(struct packet_sock *po, void *frame, int status,
> > > +                               bool call_complete)
> > >  {
> > >         union tpacket_uhdr h;
> > >
> > > @@ -381,6 +382,8 @@ static void __packet_set_status(struct packet_sock *po, void *frame, int status)
> > >                 BUG();
> > >         }
> > >
> > > +       if (po->wait_on_complete && call_complete)
> > > +               complete(&po->skb_completion);
> >
> > This wake need not happen before the barrier. Only one caller of
> > __packet_set_status passes call_complete (tpacket_destruct_skb).
> > Moving this branch to the caller avoids a lot of code churn.
> >
> > Also, multiple packets may be released before the process is awoken.
> > The process will block until packet_read_pending drops to zero. Can
> > defer the wait_on_complete to that one instance.
> 
> Eh no. The point of having this sleep in the send loop is that
> additional slots may be released for transmission (flipped to
> TP_STATUS_SEND_REQUEST) from another thread while this thread is
> waiting.
> 
Thats incorrect.  The entirety of tpacket_snd is protected by a mutex. No other
thread can alter the state of the frames in the vector from the kernel send path
while this thread is waiting.

> Else, it would have been much simpler to move the wait below the send
> loop: send as many packets as possible, then wait for all of them
> having been released. Much clearer control flow.
> 
Thats (almost) what happens now.  The only difference is that with this
implementation, the waiting thread has the opportunity to see if userspace has
queued more frames for transmission during the wait period.  We could
potentially change that, but thats outside the scope of this fix.

> Where to set and clear the wait_on_complete boolean remains. Integer
> assignment is fragile, as the compiler and processor may optimize or
> move simple seemingly independent operations. As complete() takes a
> spinlock, avoiding that in the DONTWAIT case is worthwhile. But probably
> still preferable to set when beginning waiting and clear when calling
> complete.
We avoid any call to wait_for_complete or complete already, based on the gating
of the need_wait variable in tpacket_snd.  If the transmitting thread doesn't
set MSG_DONTWAIT in the flags of the msg structure, we will never set
wait_for_complete, and so we will never manipulate the completion queue.

Neil

> 
