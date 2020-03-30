Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6334198097
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgC3QKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:10:08 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37838 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730153AbgC3QKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:10:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id w10so22440943wrm.4
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 09:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4p/FuKYQc7vZhNMiSuFBV3E0MOwLFjQSDsjh0BwAatc=;
        b=hoSQ41CaNLHQnZZ9tjQoCCNkJ+hUl3R6eCbUaBQr8kzZyaoe9gjXOoae5anfM3IKdY
         53OjGYNyyKDDmJ9OD2pW3f6Eu2de/IuJ/zmUW3KwfnQaaXu2LXWkyeFWUlmWHS4oh2jH
         Zt//xFLf0GERK03vUqrFzaeF2U//gSe1y4/wbyy9JcxxCXX3LYETIpJBfP0QAO6xb1NI
         u4BrbsFEPuccDST/j9fl7iemXz6krS+33vGv8rxrXSFuam/Ol1t7n4xoRcQ0AtUttukX
         1WLBP01d2L6Dp8cjHln+22fogjAbMS+Bh3TUOe5DQF4FS9SSCVwl9qfZzBYkbE1e2t7d
         qIGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4p/FuKYQc7vZhNMiSuFBV3E0MOwLFjQSDsjh0BwAatc=;
        b=ZHezEB36qY+Z0+QUBRpzT+Tr6a3GRkMl35LUQpk2u9aMeOmDpsbtKGD629cAwj5mYm
         IOMrARbNPFZHQU1JRhY+omfNtBqjAi5pnj8j2lL3Iy3+fq+1nODZM5rbrAICQVcPvobq
         WhB8BnfRsLsgHEwb/0HAhmaX4LkYuDacriYekBsutCKTBYp8aybvUdj8jJ4FaENbx65l
         ++2yUSs6WakP6BnVPJF0jLmXrO79wl/XmsSZjluGyWCVVFVSTDYNEtNZzyf3aAdCmYp9
         36dj1SQCC5uCGHhbMEGa7I6BPcXSEFaEWrxOXa3OddrJZIiiynL1KxelJBst0qafwDTI
         ipfA==
X-Gm-Message-State: ANhLgQ0QCPozfqdUhqxsW1zeC4+BnIPg11rV5fxB4QjA8/js0LZCCPdL
        djnv2LRwn39hKRTd+sEVzSI4VcCOYk/b9PPNU9U=
X-Google-Smtp-Source: ADFU+vs9vtYAqVmua0YKGsYJZGbJKErNly+DDLyZLnS4JH+iiFpE/f6c+UZWVSL7Tw4UChIzmzUNyCsjBDHqFxj56M4=
X-Received: by 2002:a5d:5447:: with SMTP id w7mr15480169wrv.299.1585584606828;
 Mon, 30 Mar 2020 09:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
 <20200330082929.GG13121@gauss3.secunet.de>
In-Reply-To: <20200330082929.GG13121@gauss3.secunet.de>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 31 Mar 2020 00:13:34 +0800
Message-ID: <CADvbK_egz4aYOHa2+FPL6V+vXcfRGst6zEiUxqskpHc3fOk-oA@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix a skb extensions leak
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 4:29 PM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Thu, Mar 26, 2020 at 05:06:25PM +0800, Xin Long wrote:
> > On udp rx path udp_rcv_segment() may do segment where the frag skbs
> > will get the header copied from the head skb in skb_segment_list()
> > by calling __copy_skb_header(), which could overwrite the frag skbs'
> > extensions by __skb_ext_copy() and cause a leak.
> >
> > This issue was found after loading esp_offload where a sec path ext
> > is set in the skb.
> >
> > On udp tx gso path, it works well as the frag skbs' extensions are
> > not set. So this issue should be fixed on udp's rx path only and
> > release the frag skbs' extensions before going to do segment.
>
> Are you sure that this affects only the RX path? What if such
> a packet is forwarded? Also, I think TCP has the same problem.
You're right, just confirm it exists on the forwarded path.
__copy_skb_header() is also called by skb_segment(), but
I don't have tests to reproduce it on other protocols like TCP.

>
> >
> > Reported-by: Xiumei Mu <xmu@redhat.com>
> > Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/net/udp.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index e55d5f7..7bf0ca5 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -486,6 +486,10 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
> >       if (skb->pkt_type == PACKET_LOOPBACK)
> >               skb->ip_summed = CHECKSUM_PARTIAL;
> >
> > +     if (skb_has_frag_list(skb) && skb_has_extensions(skb))
> > +             skb_walk_frags(skb, segs)
> > +                     skb_ext_put(segs);
>
> If a skb in the fraglist has a secpath, it is still valid.
> So maybe instead of dropping it here and assign the one
> from the head skb, we could just keep the secpath. But
> I don't know about other extensions. I've CCed Florian,
> he might know a bit more about other extensions. Also,
> it might be good to check if the extensions of the GRO
> packets are all the same before merging.
>
Not sure if we can improve __copy_skb_header() or add
a new function to copy these members ONLY when nskb's
are not set.
