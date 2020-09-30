Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4295927F30C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgI3UNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgI3UNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:13:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AEFC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:13:14 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNiTM-00E39L-UK; Wed, 30 Sep 2020 22:13:09 +0200
Message-ID: <48868126b563b1602093f6210ed957d7ed880584.camel@sipsolutions.net>
Subject: Re: Genetlink per cmd policies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michal Kubecek <mkubecek@suse.cz>,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Date:   Wed, 30 Sep 2020 22:13:07 +0200
In-Reply-To: <20200930124612.32b53118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 12:46 -0700, Jakub Kicinski wrote:

> This builds (I think) - around 100 extra LoC:

Looks good to me, couple of comments below.

> +/**
> + * struct genl_light_ops - generic netlink operations (small version)
> + * @cmd: command identifier
> + * @internal_flags: flags used by the family
> + * @flags: flags
> + * @validate: validation flags from enum genl_validate_flags
> + * @doit: standard command callback
> + * @dumpit: callback for dumpers
> + *
> + * This is a cut-down version of struct genl_ops for users who don't need
> + * most of the ancillary infra and want to save space.
> + */
> +struct genl_light_ops {
> +	int	(*doit)(struct sk_buff *skb, struct genl_info *info);
> +	int	(*dumpit)(struct sk_buff *skb, struct netlink_callback *cb);

Even dumpit is pretty rare (e.g. 10 out of 107 in nl80211) - maybe
remove that even? It's a bit more juggling in nl80211 to actually use
it, but I'm certainly happy to do that myself.

> +static void genl_op_from_full(const struct genl_family *family,
> +			      unsigned int i, struct genl_ops *op)
> +{
> +	memcpy(op, &family->ops[i], sizeof(*op));

What's wrong with struct assignment? :)

	*op = family->ops[i];


> +	if (!op->maxattr)
> +		op->maxattr = family->maxattr;
> +	if (!op->policy)
> +		op->policy = family->policy;

That doesn't build as is, I think? Or did you have some other patch
below it?

>  static int genl_validate_ops(const struct genl_family *family)
>  {
[...]
> +	n_ops = genl_get_cmd_cnt(family);
>  	if (!n_ops)
>  		return 0;

Come to think of it, that check is kinda pointless, the loop won't run
if it's 0 and then we return 0 immediately anyway... whatever :)

>  	for (i = 0; i < n_ops; i++) {
> -		if (ops[i].dumpit == NULL && ops[i].doit == NULL)
> +		struct genl_ops op;
> +
> +		if (genl_get_cmd_by_index(i, family, &op))
>  			return -EINVAL;

Maybe WARN_ON() or something? It really ought to not be possible for
that to fail, since you're only iterating to n_ops, so you'd have to
have some consistency issues if that happens.

> -		for (j = i + 1; j < n_ops; j++)
> -			if (ops[i].cmd == ops[j].cmd)
> +		if (op.dumpit == NULL && op.doit == NULL)
> +			return -EINVAL;
> +		for (j = i + 1; j < n_ops; j++) {
> +			struct genl_ops op2;
> +
> +			if (genl_get_cmd_by_index(j, family, &op2))
>  				return -EINVAL;

same here

> +		for (i = 0; i < genl_get_cmd_cnt(family); i++) {
>  			struct nlattr *nest;
> -			const struct genl_ops *ops = &family->ops[i];
> -			u32 op_flags = ops->flags;
> +			struct genl_ops op;
> +			u32 op_flags;
> +
> +			if (genl_get_cmd_by_index(i, family, &op))
> +				goto nla_put_failure;

but actually, same here, so maybe it should just not even be able to
return an error but WARN_ON instead and clear the op, so you have
everything NULL in that case?

I don't really see a case where you'd have the index coming from
userspace and would have to protect against it being bad, or something?

johannes

