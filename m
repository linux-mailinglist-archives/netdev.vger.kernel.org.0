Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A09E10D0A6
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 04:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfK2DcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 22:32:10 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:50913 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbfK2DcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Nov 2019 22:32:10 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 261fdee4;
        Fri, 29 Nov 2019 02:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=QnhIEK3n2PL2veutrTDB1byHOuI=; b=XWR//nI
        pUhfZoUNt+GgvwJFxvAY0gNHPOXOUsdaCoQPsZX7gInLGeIkZDSlga06X6SnEFWp
        GYJxTuWwbiLsN8bMhbiftR3C+4WDJUebO2e33TpH/7fKUmAS1K57ulmd5k/GWaHh
        zA2rAcofYYiaSSgGdlGpaUV01mZQtEZhyiv7xhvMfsXqrtRd14FaIllBmyyGzYTq
        eWcuIGkWvO1laLhLfNoB2KDaA+nKokoyl4MdkccjUnP4Vqe9wmwC3J7ANaLRZinn
        7jbxT8/M318CcQq6g5/VV328oJac7dNU0RAwO71ghpCdfvHw15StHblWVRWQiwn4
        gxUMZKPbxvkHpSA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 44972ea7 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 29 Nov 2019 02:38:04 +0000 (UTC)
Date:   Fri, 29 Nov 2019 04:32:05 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1] net: WireGuard secure network tunnel
Message-ID: <20191129033205.GA67257@zx2c4.com>
References: <20191127112643.441509-1-Jason@zx2c4.com>
 <20191128.133023.1503723038764717212.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191128.133023.1503723038764717212.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Dave,

On Thu, Nov 28, 2019 at 01:30:23PM -0800, David Miller wrote:
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Date: Wed, 27 Nov 2019 12:26:43 +0100
> 
> > +	do {
> > +		next = skb->next;
> 
> I've been trying desperately to remove all direct references to the SKB list
> implementation details so that we can convert it over to list_head.  This
> means no direct references to skb->next nor skb->prev.
> 
> Please rearrange this using appropriate helpers and abstractions from skbuff.h

I'm not a huge fan of doing manual skb surgery either. The annoying
thing here is that skb_gso_segment returns a list of skbs that's
terminated by the last one's next pointer being NULL. I assume it's this
way so that the GSO code doesn't have to pass a head around. I went to
see what other drivers are doing to deal with the return value of
skb_gso_segment, and found that every place without fail does pretty
much the same thing as me, whether it's wifi drivers, ethernet drivers,
qdiscs, ipsec, etc. Here's (one of) IPsec's usage, for example:

	segs = skb_gso_segment(skb, 0);
	kfree_skb(skb);
	if (IS_ERR(segs))
		return PTR_ERR(segs);
	if (segs == NULL)
		return -EINVAL;

	do {
		struct sk_buff *nskb = segs->next;
		int err;

		skb_mark_not_on_list(segs);
		err = xfrm_output2(net, sk, segs);

		if (unlikely(err)) {
			kfree_skb_list(nskb);
			return err;
		}

		segs = nskb;
	} while (segs);

Given that so much code does the same skb surgery, this seems like it
would be a good opportunity for actually adding the right helper /
abstraction around this. If that sounds good to you, I'll send a commit
adding something like the below, along with fixing up a couple of the
more straight-forward existing places to use the new helper:

#define skb_walk_null_list_safe(first, skb, next)                          \
        for (skb = first, next = skb->next; skb;                           \
             skb = next, next = skb ? skb->next : NULL)

Does this sound good to you? If so, would you like this as lead-up
commits to WireGuard, or just a new independent series all together?

Regards,
Jason
