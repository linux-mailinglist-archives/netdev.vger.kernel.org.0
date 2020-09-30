Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0AE27F388
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbgI3Urh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgI3Urg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 16:47:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCD762071E;
        Wed, 30 Sep 2020 20:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601498856;
        bh=rMng2b/nLJ/obgLnBrMp/3xOdCAP4ukWDYUtejWUQ9w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ms2/aTcbzTrmvsmu57b4LZefR2+ar5z69V/YTSKgTDL458UHRKCAPMc/BtPk/T707
         ic2hpih3CBraBoLyqm7FsPvQSijWzcDtzBRMvCbtT+7uSEKfgwDtja18B3c2NDSGoa
         NOe1Bdu5CQsYcVhYQvAy9Z3ndk+OAad25atgCR3M=
Date:   Wed, 30 Sep 2020 13:47:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michal Kubecek <mkubecek@suse.cz>,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: Genetlink per cmd policies
Message-ID: <20200930134734.27bba000@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <48868126b563b1602093f6210ed957d7ed880584.camel@sipsolutions.net>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
        <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
        <20200930094455.668b6bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
        <20200930120129.620a49f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <563a2334a42cc5f33089c2bff172d92e118575ea.camel@sipsolutions.net>
        <20200930121404.221033a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c161e922491c1a2330dcef6741a8cfa7f92999be.camel@sipsolutions.net>
        <20200930124612.32b53118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <48868126b563b1602093f6210ed957d7ed880584.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 22:13:07 +0200 Johannes Berg wrote:
> > +/**
> > + * struct genl_light_ops - generic netlink operations (small version)
> > + * @cmd: command identifier
> > + * @internal_flags: flags used by the family
> > + * @flags: flags
> > + * @validate: validation flags from enum genl_validate_flags
> > + * @doit: standard command callback
> > + * @dumpit: callback for dumpers
> > + *
> > + * This is a cut-down version of struct genl_ops for users who don't need
> > + * most of the ancillary infra and want to save space.
> > + */
> > +struct genl_light_ops {
> > +	int	(*doit)(struct sk_buff *skb, struct genl_info *info);
> > +	int	(*dumpit)(struct sk_buff *skb, struct netlink_callback *cb);  
> 
> Even dumpit is pretty rare (e.g. 10 out of 107 in nl80211) - maybe
> remove that even? It's a bit more juggling in nl80211 to actually use
> it, but I'm certainly happy to do that myself.

Hm. 16 / 44 for devlink if I'm counting right.

For nl80211 we'd go from:

 107 * 24 = 2471

to:

 97 * 16 + 10 * 48 = 2032

But for devlink we go from:

 44 * 24 = 1056
 
to

 16 * 16 + 28 * 48 = 1600

No strong feelings but I think the API is a little easier to grasp when
families with a global policy can use exclusively the "light" ops.

> > +static void genl_op_from_full(const struct genl_family *family,
> > +			      unsigned int i, struct genl_ops *op)
> > +{
> > +	memcpy(op, &family->ops[i], sizeof(*op));  
> 
> What's wrong with struct assignment? :)
> 
> 	*op = family->ops[i];

Code size :)

   text	   data	    bss	    dec	    hex
  22657	   3590	     64	  26311	   66c7	memcpy
  23103	   3590	     64	  26757	   6885	struct

> > +	if (!op->maxattr)
> > +		op->maxattr = family->maxattr;
> > +	if (!op->policy)
> > +		op->policy = family->policy;  
> 
> That doesn't build as is, I think? Or did you have some other patch
> below it?

Heh, right, I already have policy in ops in my tree.

I'll send a fuller RFC series by the end of the day.

> >  static int genl_validate_ops(const struct genl_family *family)
> >  {  
> [...]
> > +	n_ops = genl_get_cmd_cnt(family);
> >  	if (!n_ops)
> >  		return 0;  
> 
> Come to think of it, that check is kinda pointless, the loop won't run
> if it's 0 and then we return 0 immediately anyway... whatever :)

Good point :)

> >  	for (i = 0; i < n_ops; i++) {
> > -		if (ops[i].dumpit == NULL && ops[i].doit == NULL)
> > +		struct genl_ops op;
> > +
> > +		if (genl_get_cmd_by_index(i, family, &op))
> >  			return -EINVAL;  
> 
> Maybe WARN_ON() or something? It really ought to not be possible for
> that to fail, since you're only iterating to n_ops, so you'd have to
> have some consistency issues if that happens.
> 
> > -		for (j = i + 1; j < n_ops; j++)
> > -			if (ops[i].cmd == ops[j].cmd)
> > +		if (op.dumpit == NULL && op.doit == NULL)
> > +			return -EINVAL;
> > +		for (j = i + 1; j < n_ops; j++) {
> > +			struct genl_ops op2;
> > +
> > +			if (genl_get_cmd_by_index(j, family, &op2))
> >  				return -EINVAL;  
> 
> same here

Ack, will add it to the helper itself.

> > +		for (i = 0; i < genl_get_cmd_cnt(family); i++) {
> >  			struct nlattr *nest;
> > -			const struct genl_ops *ops = &family->ops[i];
> > -			u32 op_flags = ops->flags;
> > +			struct genl_ops op;
> > +			u32 op_flags;
> > +
> > +			if (genl_get_cmd_by_index(i, family, &op))
> > +				goto nla_put_failure;  
> 
> but actually, same here, so maybe it should just not even be able to
> return an error but WARN_ON instead and clear the op, so you have
> everything NULL in that case?
> 
> I don't really see a case where you'd have the index coming from
> userspace and would have to protect against it being bad, or something?

Yeah, this is entirely an internal error. I'll double check if cleared
out op doesn't break anything and make the helper void.
