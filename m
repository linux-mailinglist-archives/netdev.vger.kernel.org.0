Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9EC355840
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbfFYT7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:59:45 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35538 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726455AbfFYT7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:59:45 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hfrbT-0004Yx-2u; Tue, 25 Jun 2019 21:59:43 +0200
Date:   Tue, 25 Jun 2019 21:59:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: make skb_dst_force return false when dst was
 cleared
Message-ID: <20190625195943.44jvck5syvnzxb55@breakpoint.cc>
References: <20190625192209.6250-1-fw@strlen.de>
 <8483d4dc-1ef6-20b5-735f-8d78da579a28@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8483d4dc-1ef6-20b5-735f-8d78da579a28@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > -static inline void skb_dst_force(struct sk_buff *skb)
> > +static inline bool skb_dst_force(struct sk_buff *skb)
> >  {
> >  	if (skb_dst_is_noref(skb)) {
> >  		struct dst_entry *dst = skb_dst(skb);
> > @@ -313,7 +314,10 @@ static inline void skb_dst_force(struct sk_buff *skb)
> >  			dst = NULL;
> >  
> >  		skb->_skb_refdst = (unsigned long)dst;
> > +		return dst != NULL;
> >  	}
> > +
> > +	return true;
> 
> This will return true, even if skb has a NULL dst.

Yes, that was intentional -- it should return false to
let caller know that no reference could be obtained and
that the dst was invalidated as a result.

> Say if we have two skb_dst_force() calls for some reason
> on the same skb, only the first one will return false.

What would you suggest instead?

Alternative is something like

if (skb_dst(skb)) {
	skb_dst_force(skb);
	if (!skb_dst(skb)) {
		kfree_skb(skb);
		goto err;
	}
}

... i find this a bit ugly.
