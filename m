Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C001E197E00
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgC3OLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:11:50 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:54842 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbgC3OLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 10:11:49 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jIv8l-0004In-78; Mon, 30 Mar 2020 16:11:47 +0200
Date:   Mon, 30 Mar 2020 16:11:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Florian Westphal <fw@strlen.de>, Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] udp: fix a skb extensions leak
Message-ID: <20200330141147.GC23604@breakpoint.cc>
References: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
 <20200330132759.GA31510@strlen.de>
 <20200330134531.GK13121@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330134531.GK13121@gauss3.secunet.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steffen Klassert <steffen.klassert@secunet.com> wrote:
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 621b4479fee1..7e29590482ce 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -3668,6 +3668,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> > 
> >                 skb_push(nskb, -skb_network_offset(nskb) + offset);
> > 
> > +               skb_release_head_state(nskb);
> >                  __copy_skb_header(nskb, skb);
> > 
> >                 skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
> > 
> > AFAICS we not only leak reference of extensions, but also skb->dst and skb->_nfct.
> 
> Would be nice if we would not need to drop the resources
> just to add them back again in the next line. But it is ok
> as a quick fix for the bug.

Yes, but are these the same resources?  AFAIU thats not the case, i.e.
the skb on fraglist can have different skb->{dst,extension,_nfct} data
than the skb head one, and we can't tell if that data is still valid
(rerouting for example).
