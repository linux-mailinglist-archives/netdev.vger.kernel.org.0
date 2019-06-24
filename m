Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6567651E0B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfFXWQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:16:09 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:33547 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfFXWQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 18:16:09 -0400
Received: by mail-ed1-f43.google.com with SMTP id i11so23987081edq.0
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 15:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yETplX9a9S6QCDUlAtzRBGEPw40CZOE8ZJJ8RviXy6Q=;
        b=p7kUsjpPPHX40hKDJ1GFskRe9VKYTkpb5x2DsnWM59fefoOlhoOkowNLQbHgi33+vd
         abPs/+C/LdL0N/j9H7yDy4fjq43l6otsGlPv6Ufair5wBtujmPDvw8ve81ndEfbZKpkq
         o3LZiyDQjL1QNN9nCRkA7/3IYcyx2eoVg1ZpEGgyDeoJjVd/3zyFtjQ3PWpTdZ7UoYhx
         f9AYn2XQrsiCubE5lkcNlf8J71WorLaz0mnGfFkvdZhzBjKxyTvYuvW4K42vZRv+r4s+
         62/ReCf71IWoZqYZ9d/VDp4qDpuLC6Hitq1qYQINghcG99oUQx+MUcIWncDnloVUdC8f
         V/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yETplX9a9S6QCDUlAtzRBGEPw40CZOE8ZJJ8RviXy6Q=;
        b=jvWJqsDfhBUkG/hqMwfgEey3UxevqIiZspAuP1o/yPUDncsQqKqKB7qQb1To2O0vHK
         z41/rQITHQi3IVRf2dQeeueIe956qMQFWBk85c8vGZQBIiTyjYG0ErC8CYAVNDdsBI8y
         c6qPq4ERNMwqd4ZsQxxVGZSuQo1j3B0U2Fh+lHo7Wc5by+r4tp82R4lrSTRUYpPYKZSl
         RYhy+rmFcvUjUBKwbTG0glIIRGyJC8+ePI/q2KS+Kzl+f9BxiqPHz8o5htrfzN+GvQ7I
         6QsI1d4lPLyJRIrPxquPfXHJWOYHNQj6GgAmjnfE7Lmd84N+bJM0goCqaqgbZt5lNEbf
         SYlg==
X-Gm-Message-State: APjAAAVk+2or1xSIlpAUV3U3sIokU7U/xU9/d3i7PfdA4w101FHuHg+T
        t2XqJbZ/5vhF14el6CbDw6gfNuCSD8tGm4Eksyc=
X-Google-Smtp-Source: APXvYqxSgaWEnLbTUdEasWNC1mKJbK8Q5xozxiDLy9s+4WUiCBtavAClLzntecwpN8cS263YYUQYdu10G5Wslr0ilio=
X-Received: by 2002:aa7:d30b:: with SMTP id p11mr128627200edq.23.1561414567087;
 Mon, 24 Jun 2019 15:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <20190624004604.25607-1-nhorman@tuxdriver.com>
 <CAF=yD-JE9DEbmh6hJEN=DEdc+SCz_5Lv74mngPBuv=4nNH=zxQ@mail.gmail.com> <20190624215142.GA8181@hmswarspite.think-freely.org>
In-Reply-To: <20190624215142.GA8181@hmswarspite.think-freely.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 24 Jun 2019 18:15:29 -0400
Message-ID: <CAF=yD-L2dgypSCTDwdEXa7EUYyWTcD_hLwW_kuUkk0tA_iggDw@mail.gmail.com>
Subject: Re: [PATCH v3 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +               if (need_wait && !packet_next_frame(po, &po->tx_ring, TP_STATUS_SEND_REQUEST)) {
> > > +                       po->wait_on_complete = 1;
> > > +                       timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
> >
> > This resets timeout on every loop. should only set above the loop once.
> >
> I explained exactly why I did that in the change log.  Its because I reuse the
> timeout variable to get the return value of the wait_for_complete call.
> Otherwise I need to add additional data to the stack, which I don't want to do.
> Sock_sndtimeo is an inline function and really doesn't add any overhead to this
> path, so I see no reason not to reuse the variable.

The issue isn't the reuse. It is that timeo is reset to sk_sndtimeo
each time. Whereas wait_for_common and its variants return the
number of jiffies left in case the loop needs to sleep again later.

Reading sock_sndtimeo once and passing it to wait_.. repeatedly is a
common pattern across the stack.

> > > @@ -2728,6 +2755,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > >                         err = net_xmit_errno(err);
> > >                         if (err && __packet_get_status(po, ph) ==
> > >                                    TP_STATUS_AVAILABLE) {
> > > +                               /* re-init completion queue to avoid subsequent fallthrough
> > > +                                * on a future thread calling wait_on_complete_interruptible_timeout
> > > +                                */
> > > +                               po->wait_on_complete = 0;
> >
> > If setting where sleeping, no need for resetting if a failure happens
> > between those blocks.
> >
> > > +                               init_completion(&po->skb_completion);
> >
> > no need to reinit between each use?
> >
> I explained exactly why I did this in the comment above.  We have to set
> wait_for_complete prior to calling transmit, so as to ensure that we call
> wait_for_completion before we exit the loop. However, in this error case, we
> exit the loop prior to calling wait_for_complete, so we need to reset the
> completion variable and the wait_for_complete flag.  Otherwise we will be in a
> case where, on the next entrace to this loop we will have a completion variable
> with completion->done > 0, meaning the next wait will be a fall through case,
> which we don't want.

By moving back to the point where schedule() is called, hopefully this
complexity automatically goes away. Same as my comment to the line
immediately above.

> > > @@ -2740,6 +2772,20 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > >                 }
> > >                 packet_increment_head(&po->tx_ring);
> > >                 len_sum += tp_len;
> > > +
> > > +               if (po->wait_on_complete) {
> > > +                       timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
> > > +                       po->wait_on_complete = 0;
> >
> > I was going to argue for clearing in tpacket_destruct_skb. But then we
> > would have to separate clear on timeout instead of signal, too.
> >
> >   po->wait_on_complete = 1;
> >   timeo = wait_for_completion...
> >   po->wait_on_complete = 0;
> >
> Also, we would have a race condition, since the destructor may be called from
> softirq context (the first cause of the bug I'm fixing here), and so if the
> packet is freed prior to us checking wait_for_complete in tpacket_snd, we will
> be in the above situation again, exiting the loop with a completion variable in
> an improper state.

Good point.

The common pattern is to clear in tpacket_destruct_skb. Then
we do need to handle the case where the wait is interrupted or
times out and reset it in those cases.

> > This is basically replacing a busy-wait with schedule() with sleeping
> > using wait_for_completion_interruptible_timeout. My main question is
> > does this really need to move control flow around and add
> > packet_next_frame? If not, especially for net, the shortest, simplest
> > change is preferable.
> >
> Its not replacing a busy wait at all, its replacing a non-blocking schedule with
> a blocking schedule (via completion queues).  As for control flow, Im not sure I
> why you are bound to the existing control flow, and given that we already have
> packet_previous_frame, I didn't see anything egregious about adding
> packet_next_frame as well, but since you've seen a way to eliminate it, I'm ok
> with it.

The benefit of keeping to the existing control flow is that that is a
smaller change, so easier to verify.

I understand the benefit of moving the wait outside the loop. Before
this report, I was not even aware of that behavior on !MSG_DONTWAIT,
because it is so co-located.

But moving it elsewhere in the loop does not have the same benefit,
imho. Either way, I think we better leave any such code improvements
to net-next and focus on the minimal , least risky, patch for net.
