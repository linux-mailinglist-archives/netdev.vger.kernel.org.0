Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886B327FAED
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbgJAH7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730695AbgJAH7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:59:50 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3A1C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:59:50 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNtVE-00ESbW-Bo; Thu, 01 Oct 2020 09:59:48 +0200
Message-ID: <591d18f08b82a84c5dc19b110962dabc598c479d.camel@sipsolutions.net>
Subject: Re: [RFC net-next 9/9] genetlink: allow dumping command-specific
 policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, jiri@resnulli.us, mkubecek@suse.cz,
        dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 09:59:47 +0200
In-Reply-To: <20201001000518.685243-10-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
         <20201001000518.685243-10-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 17:05 -0700, Jakub Kicinski wrote:
> Right now CTRL_CMD_GETPOLICY can only dump the family-wide
> policy. Support dumping policy of a specific op.

So, hmm.

Yeah, I guess this is fine, but you could end up having to do a lot of
dumps, and with e.g. ethtool you'd end up with a lot of duplicate data
too, since it's structured as


common_policy = { ... }

cmd1_policy = {
	[CMD1_COMMON] = NLA_NESTED_POLICY(common_policy),
	...
};

cmd2_policy = {
	[CMD2_COMMON] = NLA_NESTED_POLICY(common_policy),
	...
};

etc.


So you end up dumping per command (and in practice, since they can be
different, you now *have to* unless you know out-of-band that there are
no per-command policies).


Even if I don't have a good idea now on how to avoid the duplication, it
might be nicer to have a (flag) attribute here for "CTRL_ATTR_ALL_OPS"?

johannes

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/uapi/linux/genetlink.h |  1 +
>  net/netlink/genetlink.c        | 23 +++++++++++++++++++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/genetlink.h b/include/uapi/linux/genetlink.h
> index 9c0636ec2286..7dbe2d5d7d46 100644
> --- a/include/uapi/linux/genetlink.h
> +++ b/include/uapi/linux/genetlink.h
> @@ -64,6 +64,7 @@ enum {
>  	CTRL_ATTR_OPS,
>  	CTRL_ATTR_MCAST_GROUPS,
>  	CTRL_ATTR_POLICY,
> +	CTRL_ATTR_OP,
>  	__CTRL_ATTR_MAX,
>  };
>  
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index f2833e9165c7..12e9f323af35 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1113,12 +1113,14 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
>  struct ctrl_dump_policy_ctx {
>  	unsigned long state;
>  	unsigned int fam_id;
> +	u8 cmd;
>  };
>  
>  static const struct nla_policy ctrl_policy_policy[] = {
>  	[CTRL_ATTR_FAMILY_ID]	= { .type = NLA_U16 },
>  	[CTRL_ATTR_FAMILY_NAME]	= { .type = NLA_NUL_STRING,
>  				    .len = GENL_NAMSIZ - 1 },
> +	[CTRL_ATTR_OP]		= { .type = NLA_U8 },
>  };
>  
>  static int ctrl_dumppolicy_start(struct netlink_callback *cb)
> @@ -1127,6 +1129,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
>  	struct ctrl_dump_policy_ctx *ctx = (void *)cb->args;
>  	struct nlattr **tb = info->attrs;
>  	const struct genl_family *rt;
> +	struct genl_ops op;
> +	int err;
>  
>  	if (!tb[CTRL_ATTR_FAMILY_ID] && !tb[CTRL_ATTR_FAMILY_NAME])
>  		return -EINVAL;
> @@ -1145,10 +1149,23 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
>  	if (!rt)
>  		return -ENOENT;
>  
> -	if (!rt->policy)
> +	if (tb[CTRL_ATTR_OP]) {
> +		ctx->cmd = nla_get_u8(tb[CTRL_ATTR_OP]);
> +
> +		err = genl_get_cmd(ctx->cmd, rt, &op);
> +		if (err) {
> +			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
> +			return err;
> +		}
> +	} else {
> +		op.policy = rt->policy;
> +		op.maxattr = rt->maxattr;
> +	}
> +
> +	if (!op.policy)
>  		return -ENODATA;
>  
> -	return netlink_policy_dump_start(rt->policy, rt->maxattr, &ctx->state);
> +	return netlink_policy_dump_start(op.policy, op.maxattr, &ctx->state);
>  }
>  
>  static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
> @@ -1167,6 +1184,8 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
>  
>  		if (nla_put_u16(skb, CTRL_ATTR_FAMILY_ID, ctx->fam_id))
>  			goto nla_put_failure;
> +		if (ctx->cmd && nla_put_u8(skb, CTRL_ATTR_OP, ctx->cmd))
> +			goto nla_put_failure;
>  
>  		nest = nla_nest_start(skb, CTRL_ATTR_POLICY);
>  		if (!nest)

