Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550822FC1AC
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390355AbhASU4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:56:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391385AbhASU4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:56:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2615206EC;
        Tue, 19 Jan 2021 20:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611089705;
        bh=WsJPl0LENyM732Oy+DV/4TTqxaQKklWL/vLDOAZ1pRc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z9CVgJoiqBT62V23S0GHafVhOFq02ACYE8RKtG7M64wBaXfbRcydUpaxGUVj7VXVS
         YrNOD2GHB16Hr1z2j1R3cwQCiIyeJEQhF4MSuviKX5ezpNBjDyyrEHUR9TtSMomkBx
         cn7Jtyao7v6owRBQyQZp9UzkP6+Ti6TwjNRmy9/7FklbURBnRkyShd0+g2uT8W+f2I
         hH0Tq249CNtoTM5yUwsd7aMFaiUqKGWQkIpKuENQaTCrN9JYN41Cm/P0ZtEA2bM4yX
         3E0yc2OR0k1xRa7YXbcMpEdNTudqzruk6VZA0LAk1ScrTQsOHa9Cl8XKEUzpSB/Edq
         7J2jB3QX2BQEQ==
Date:   Tue, 19 Jan 2021 12:55:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/3] nexthop: Use a dedicated policy for
 nh_valid_get_del_req()
Message-ID: <20210119125504.0b306d97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ec93d227609126c98805e52ba3821b71f8bb338d.1610978306.git.petrm@nvidia.org>
References: <cover.1610978306.git.petrm@nvidia.org>
        <ec93d227609126c98805e52ba3821b71f8bb338d.1610978306.git.petrm@nvidia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 15:05:23 +0100 Petr Machata wrote:
> This function uses the global nexthop policy only to then bounce all
> arguments except for NHA_ID. Instead, just create a new policy that
> only includes the one allowed attribute.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index e53e43aef785..d5d88f7c5c11 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -36,6 +36,10 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
>  	[NHA_FDB]		= { .type = NLA_FLAG },
>  };
>  
> +static const struct nla_policy rtm_nh_policy_get[NHA_MAX + 1] = {

This is an unnecessary waste of memory if you ask me.

NHA_ID is 1, so we're creating an array of 10 extra NULL elements.

Can you leave the size to the compiler and use ARRAY_SIZE() below?

> +	[NHA_ID]		= { .type = NLA_U32 },
> +};
> +
>  static bool nexthop_notifiers_is_empty(struct net *net)
>  {
>  	return !net->nexthop.notifier_chain.head;
> @@ -1843,27 +1847,14 @@ static int nh_valid_get_del_req(struct nlmsghdr *nlh, u32 *id,
>  {
>  	struct nhmsg *nhm = nlmsg_data(nlh);
>  	struct nlattr *tb[NHA_MAX + 1];
> -	int err, i;
> +	int err;
>  
> -	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
> +	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy_get,
>  			  extack);
>  	if (err < 0)
>  		return err;
>  
>  	err = -EINVAL;
> -	for (i = 0; i < __NHA_MAX; ++i) {
> -		if (!tb[i])
> -			continue;
> -
> -		switch (i) {
> -		case NHA_ID:
> -			break;
> -		default:
> -			NL_SET_ERR_MSG_ATTR(extack, tb[i],
> -					    "Unexpected attribute in request");
> -			goto out;
> -		}
> -	}
>  	if (nhm->nh_protocol || nhm->resvd || nhm->nh_scope || nhm->nh_flags) {
>  		NL_SET_ERR_MSG(extack, "Invalid values in header");
>  		goto out;

