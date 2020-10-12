Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F323A28BCAD
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 17:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390310AbgJLPo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 11:44:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:59066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390282AbgJLPo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 11:44:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0BFB0AECD;
        Mon, 12 Oct 2020 15:44:56 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id BF39F603A2; Mon, 12 Oct 2020 17:44:55 +0200 (CEST)
Date:   Mon, 12 Oct 2020 17:44:55 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH ethtool-next v2 5/6] netlink: use policy dumping to check
 if stats flag is supported
Message-ID: <20201012154455.tq65ttu6mrpoocyj@lion.mk-sys.cz>
References: <20201006150425.2631432-1-kuba@kernel.org>
 <20201006150425.2631432-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="crrciydtoqbtar5b"
Content-Disposition: inline
In-Reply-To: <20201006150425.2631432-6-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--crrciydtoqbtar5b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 06, 2020 at 08:04:24AM -0700, Jakub Kicinski wrote:
> Older kernels don't support statistics, to avoid retries
> make use of netlink policy dumps to figure out which
> flags kernel actually supports.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
[...]
> +static int family_policy_cb(const struct nlmsghdr *nlhdr, void *data)
> +{
> +	const struct nlattr *tba[NL_POLICY_TYPE_ATTR_MAX + 1] =3D {};
> +	DECLARE_ATTR_TB_INFO(tba);
> +	const struct nlattr *tb[CTRL_ATTR_MAX + 1] =3D {};
> +	DECLARE_ATTR_TB_INFO(tb);
> +	const struct nlattr *policy_attr, *attr_attr, *attr;
> +	struct ethtool_op_policy_query_ctx *ctx =3D data;

I would rather use a different name for this variable as "ctx" is used
for struct cmd_context everywhere else.

> +	unsigned int attr_idx, policy_idx;
> +	int ret;

[...]
> +static int get_flags_policy(struct nl_context *nlctx, struct nl_socket *=
nlsk,
> +			    unsigned int nlcmd, unsigned int hdrattr)
> +{
> +	struct nl_msg_buff *msgbuff =3D &nlsk->msgbuff;
> +	struct ethtool_op_policy_query_ctx ctx;

Same here.

> +	int ret;
> +
> +	memset(&ctx, 0, sizeof(ctx));
> +	ctx.nlctx =3D nlctx;
> +	ctx.op =3D nlcmd;
> +	ctx.op_hdr_attr =3D hdrattr;
> +
> +	ret =3D __msg_init(msgbuff, GENL_ID_CTRL, CTRL_CMD_GETPOLICY,
> +			 NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP, 1);
> +	if (ret < 0)
> +		return ret;
> +	ret =3D -EMSGSIZE;
> +	if (ethnla_put_u16(msgbuff, CTRL_ATTR_FAMILY_ID, nlctx->ethnl_fam))
> +		return ret;
> +	if (ethnla_put_u32(msgbuff, CTRL_ATTR_OP, nlcmd))
> +		return ret;
> +
> +	nlsock_sendmsg(nlsk, NULL);
> +	nlsock_process_reply(nlsk, family_policy_cb, &ctx);
> +
> +	ret =3D ctx.flag_mask;
> +	return ret;
> +}

The return value is assigned either a negative error code or a u32 flag
mask. If we run this code on a kernel supporting 32 flags, flag in bit
31 would collide with sign and successfully retrieved flag mask would be
interpreted as an error by caller.

Other than this, the series looks good to me.

Michal

--crrciydtoqbtar5b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl+EefEACgkQ538sG/LR
dpW9Awf/XThGsLRIzuo73CeZ9Lu5P7XMydf+XHLb7RiDsOOuDEgoAXYbTxobelYr
WkcgvddcVnos2tO9Gm2BgB8lmUOYXmov6GlpGDIu0tWEBffIfE9WeLS/0PNbIq/i
6Jy85ITzvFzs+Ud9rXTvU/wza+xtxLgx+82vnvGu4K6u7q+5DS9NXNhzqnpGOtJf
xNL5ahOYAW2LbIgqCt+JvTCjJTXoYS1cjJxVfNiFnvXz5imR7UbUU2Y8uzYXnaoj
Bk5zWvpJODZNk1IdeglCmTgWe3EO2HfCnPrQaHfLQzS/En3a+gxo7h8Z/di6LW1x
zV3aKHRhun6hxo5cMl4U6QDAH8aY/A==
=AY8N
-----END PGP SIGNATURE-----

--crrciydtoqbtar5b--
