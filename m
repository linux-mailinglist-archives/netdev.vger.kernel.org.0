Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2DE27F182
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgI3SmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:42:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:45440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgI3SmM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 14:42:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B0A9EAD03;
        Wed, 30 Sep 2020 18:42:10 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5C28E60787; Wed, 30 Sep 2020 20:42:10 +0200 (CEST)
Date:   Wed, 30 Sep 2020 20:42:10 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: Genetlink per cmd policies
Message-ID: <20200930184210.ojlgmak6slr62aql@lion.mk-sys.cz>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
 <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
 <20200930094455.668b6bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 08:36:24PM +0200, Johannes Berg wrote:
> On Wed, 2020-09-30 at 09:44 -0700, Jakub Kicinski wrote:
> 
> > I started with a get_policy() callback, but I didn't like it much.
> > Static data is much more pleasant for a client of the API IMHO.
> 
> Yeah, true.
> 
> > What do you think about "ops light"? Insufficiently flexible?
> 
> TBH, I'm not really sure how you'd do it?
> 
> Admittedly, it _would_ be nice to reduce struct genl_ops further, I
> could imagine, assuming that doit is far more common than anything else,
> perhaps something like
> 
> diff --git a/include/net/genetlink.h b/include/net/genetlink.h
> index b9eb92f3fe86..a5abab50673c 100644
> --- a/include/net/genetlink.h
> +++ b/include/net/genetlink.h
> @@ -125,23 +125,34 @@ genl_dumpit_info(struct netlink_callback *cb)
>  	return cb->data;
>  }
>  
> +/**
> + * struct genl_ops_ext - full generic netlink operations
> + * @start: start callback for dumps
> + * @dumpit: callback for dumpers
> + * @done: completion callback for dumps
> + * @policy: policy if different from the family policy
> + * @maxattr: max attr for the policy
> + */
> +struct genl_ops_ext {
> +	int (*start)(struct netlink_callback *cb);
> +	int (*dumpit)(struct sk_buff *skb,
> +		      struct netlink_callback *cb);
> +	int (*done)(struct netlink_callback *cb);
> +	const struct nla_policy *policy;
> +	unsigned int maxattr;
> +};
> +
>  /**
>   * struct genl_ops - generic netlink operations
>   * @cmd: command identifier
>   * @internal_flags: flags used by the family
>   * @flags: flags
>   * @doit: standard command callback
> - * @start: start callback for dumps
> - * @dumpit: callback for dumpers
> - * @done: completion callback for dumps
>   */
>  struct genl_ops {
>  	int		       (*doit)(struct sk_buff *skb,
>  				       struct genl_info *info);
> -	int		       (*start)(struct netlink_callback *cb);
> -	int		       (*dumpit)(struct sk_buff *skb,
> -					 struct netlink_callback *cb);
> -	int		       (*done)(struct netlink_callback *cb);
> +	struct genl_ops_ext	*extops;
>  	u8			cmd;
>  	u8			internal_flags;
>  	u8			flags;
> 
> ... 
> 
> or perhaps even
> 
> diff --git a/include/net/genetlink.h b/include/net/genetlink.h
> index b9eb92f3fe86..9be3fc051400 100644
> --- a/include/net/genetlink.h
> +++ b/include/net/genetlink.h
> @@ -125,29 +125,45 @@ genl_dumpit_info(struct netlink_callback *cb)
>  	return cb->data;
>  }
>  
> +/**
> + * struct genl_ops_ext - full generic netlink operations
> + * @start: start callback for dumps
> + * @dumpit: callback for dumpers
> + * @done: completion callback for dumps
> + * @doit: standard command callback
> + * @policy: policy if different from the family policy
> + * @maxattr: max attr for the policy
> + */
> +struct genl_ops_ext {
> +	int (*start)(struct netlink_callback *cb);
> +	int (*dumpit)(struct sk_buff *skb, struct netlink_callback *cb);
> +	int (*done)(struct netlink_callback *cb);
> +	int (*doit)(struct sk_buff *skb, struct genl_info *info);
> +	const struct nla_policy *policy;
> +	unsigned int maxattr;
> +};
> +
>  /**
>   * struct genl_ops - generic netlink operations
>   * @cmd: command identifier
>   * @internal_flags: flags used by the family
>   * @flags: flags
>   * @doit: standard command callback
> - * @start: start callback for dumps
> - * @dumpit: callback for dumpers
> - * @done: completion callback for dumps
> + * @extops: extended ops if needed, must use GENL_EXTOPS()
>   */
>  struct genl_ops {
> -	int		       (*doit)(struct sk_buff *skb,
> -				       struct genl_info *info);
> -	int		       (*start)(struct netlink_callback *cb);
> -	int		       (*dumpit)(struct sk_buff *skb,
> -					 struct netlink_callback *cb);
> -	int		       (*done)(struct netlink_callback *cb);
> +	union {
> +		int (*doit)(struct sk_buff *skb, struct genl_info *info);
> +		struct genl_ops_ext *extops;
> +	};
>  	u8			cmd;
>  	u8			internal_flags;
>  	u8			flags;
>  	u8			validate;
>  };
>  
> +#define GENL_EXT_OPS(ptr) ((struct genl_ops_ext *)((uintptr_t)(ptr) | 1))
> +
>  int genl_register_family(struct genl_family *family);
>  int genl_unregister_family(const struct genl_family *family);
>  void genl_notify(const struct genl_family *family, struct sk_buff *skb,
> 
> 
> 
> 
> But both sort of feel awkward, you have to declare another structure,
> and link it manually to the right place?
> 
> There isn't really a _good_ way to express such a thing easily in C?

Not really good either but how about embedding struct genl_ops as first
member of struct genl_ops_ext like we do with sockets?

Michal 
