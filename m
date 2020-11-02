Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDDD2A36D7
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgKBW6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:58:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:40382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgKBW6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:58:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A566DAC53;
        Mon,  2 Nov 2020 22:58:03 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 62012603A8; Mon,  2 Nov 2020 23:58:03 +0100 (CET)
Date:   Mon, 2 Nov 2020 23:58:03 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH ethtool] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Message-ID: <20201102225803.pcrqf6nhjlvmfxwt@lion.mk-sys.cz>
References: <20201102184036.866513-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102184036.866513-1-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 08:40:36PM +0200, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> With the ioctl interface, when autoneg is enabled, but without
> specifying speed, duplex or link modes, the advertised link modes are
> set to the supported link modes by the ethtool user space utility.
> 
> This does not happen when using the netlink interface. Fix this
> incompatibility problem by having ethtool query the supported link modes
> from the kernel and advertise all of them when only "autoneg on" is
> specified.
> 
> Before:
> 
> # ethtool -s eth0 advertise 0xC autoneg on
> # ethtool -s eth0 autoneg on
> # ethtool eth0
> Settings for eth0:
> 	Supported ports: [ TP ]
> 	Supported link modes:   10baseT/Half 10baseT/Full
> 	                        100baseT/Half 100baseT/Full
> 	                        1000baseT/Full
> 	Supported pause frame use: No
> 	Supports auto-negotiation: Yes
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  100baseT/Half 100baseT/Full
> 	Advertised pause frame use: No
> 	Advertised auto-negotiation: Yes
> 	Advertised FEC modes: Not reported
> 	Speed: 1000Mb/s
> 	Duplex: Full
> 	Auto-negotiation: on
> 	Port: Twisted Pair
> 	PHYAD: 0
> 	Transceiver: internal
> 	MDI-X: off (auto)
> 	Supports Wake-on: umbg
> 	Wake-on: d
>         Current message level: 0x00000007 (7)
>                                drv probe link
> 	Link detected: yes
> 
> After:
> 
> # ethtool -s eth0 advertise 0xC autoneg on
> # ethtool -s eth0 autoneg on
> # ethtool eth0
> Settings for eth0:
> 	Supported ports: [ TP ]
> 	Supported link modes:   10baseT/Half 10baseT/Full
> 	                        100baseT/Half 100baseT/Full
> 	                        1000baseT/Full
> 	Supported pause frame use: No
> 	Supports auto-negotiation: Yes
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  10baseT/Half 10baseT/Full
> 	                        100baseT/Half 100baseT/Full
> 	                        1000baseT/Full
> 	Advertised pause frame use: No
> 	Advertised auto-negotiation: Yes
> 	Advertised FEC modes: Not reported
> 	Speed: 1000Mb/s
> 	Duplex: Full
> 	Auto-negotiation: on
> 	Port: Twisted Pair
> 	PHYAD: 0
> 	Transceiver: internal
> 	MDI-X: on (auto)
> 	Supports Wake-on: umbg
> 	Wake-on: d
>         Current message level: 0x00000007 (7)
>                                drv probe link
> 	Link detected: yes
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> Michal / Jakub, let me know if you see a better way. Sending as RFC
> since I want to run it through regression first.
> ---
>  netlink/settings.c | 115 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 115 insertions(+)
> 
> diff --git a/netlink/settings.c b/netlink/settings.c
> index 41a2e5af1945..1f856b1b14d5 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -1110,6 +1110,113 @@ static const struct param_parser sset_params[] = {
>  	{}
>  };
>  
> +static bool sset_is_autoneg_only(const struct nl_context *nlctx)
> +{
> +	return nlctx->argc == 2 && !strcmp(nlctx->argp[0], "autoneg") &&
> +	       !strcmp(nlctx->argp[1], "on");
> +}

This would only return true if there is only "autoneg on" on command
line; the ioctl parser fills all supported modes whenever none of
"speed", "duplex" and "advertise" is present, even if there are other
parameters not related to advertised modes selection (e.g. "wol").

Doing this properly from command line would require us to duplicate the
parser here which would be very inconvenient and impractical w.r.t.
future extensions.

What would probably make more sense would be modifying nl_parse() not to
send the messages itself in PARSER_GROUP_MSG case but return them back
to caller (like it does in other cases when there is only one message).
Then we could check the ETHTOOL_MSG_LINKMODES_SET message (if there is
one) for presence of ETHTOOL_A_LINKMODES_AUTONEG,
ETHTOOL_A_LINKMODES_OURS, ETHTOOL_A_LINKMODES_SPEED and
ETHTOOL_A_LINKMODES_DUPLEX (and value of ETHTOOL_A_LINKMODES_AUTONEG)
and add ETHTOOL_A_LINKMODES_OURS if needed.

I'll prepare a proof of concept of such nl_parse() rework. Fortunately
this is the only subcommand using PARSER_GROUP_MSG so that there are no
other callers that would need adjusting.

> +static int linkmodes_reply_adver_all_cb(const struct nlmsghdr *nlhdr,

                              ^^^^^ advert?

> +					void *data)
> +{
> +	const struct nlattr *bitset_tb[ETHTOOL_A_BITSET_MAX + 1] = {};
> +	const struct nlattr *tb[ETHTOOL_A_LINKMODES_MAX + 1] = {};
> +	DECLARE_ATTR_TB_INFO(bitset_tb);
> +	struct nl_context *nlctx = data;
> +	struct nl_msg_buff *msgbuff;
> +	DECLARE_ATTR_TB_INFO(tb);
> +	struct nl_socket *nlsk;
> +	struct nlattr *nest;
> +	int ret;
> +
> +	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
> +	if (ret < 0)
> +		return ret;
> +	if (!tb[ETHTOOL_A_LINKMODES_OURS])
> +		return -EINVAL;
> +
> +	ret = mnl_attr_parse_nested(tb[ETHTOOL_A_LINKMODES_OURS], attr_cb,
> +				    &bitset_tb_info);
> +	if (ret < 0)
> +		return ret;
> +	if (!bitset_tb[ETHTOOL_A_BITSET_SIZE] ||
> +	    !bitset_tb[ETHTOOL_A_BITSET_VALUE] ||
> +	    !bitset_tb[ETHTOOL_A_BITSET_MASK])
> +		return -EINVAL;
> +
> +	ret = netlink_init_ethnl2_socket(nlctx);
> +	if (ret < 0)
> +		return ret;
> +
> +	nlsk = nlctx->ethnl2_socket;
> +	msgbuff = &nlsk->msgbuff;
> +
> +	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_LINKMODES_SET,
> +		       NLM_F_REQUEST | NLM_F_ACK);
> +	if (ret < 0)
> +		return ret;
> +	if (ethnla_fill_header(msgbuff, ETHTOOL_A_LINKMODES_HEADER,
> +			       nlctx->devname, 0))
> +		return -EMSGSIZE;
> +
> +	if (ethnla_put_u8(msgbuff, ETHTOOL_A_LINKMODES_AUTONEG, AUTONEG_ENABLE))
> +		return -EMSGSIZE;
> +
> +	/* Use the size and mask from the reply and set the value to the mask,
> +	 * so that all supported link modes will be advertised.
> +	 */
> +	ret = -EMSGSIZE;
> +	nest = ethnla_nest_start(msgbuff, ETHTOOL_A_LINKMODES_OURS);
> +	if (!nest)
> +		return -EMSGSIZE;
> +
> +	if (ethnla_put_u32(msgbuff, ETHTOOL_A_BITSET_SIZE,
> +			   mnl_attr_get_u32(bitset_tb[ETHTOOL_A_BITSET_SIZE])))
> +		goto err;
> +
> +	if (ethnla_put(msgbuff, ETHTOOL_A_BITSET_VALUE,
> +		       mnl_attr_get_payload_len(bitset_tb[ETHTOOL_A_BITSET_MASK]),
> +		       mnl_attr_get_payload(bitset_tb[ETHTOOL_A_BITSET_MASK])))
> +		goto err;
> +
> +	if (ethnla_put(msgbuff, ETHTOOL_A_BITSET_MASK,
> +		       mnl_attr_get_payload_len(bitset_tb[ETHTOOL_A_BITSET_MASK]),
> +		       mnl_attr_get_payload(bitset_tb[ETHTOOL_A_BITSET_MASK])))
> +		goto err;
> +
> +	ethnla_nest_end(msgbuff, nest);

To fully replicate ioctl code behaviour, we should only set the bits
corresponding to "real" link modes, not "special" ones (e.g.
ETHTOOL_LINK_MODE_TP_BIT).

> +
> +	ret = nlsock_sendmsg(nlsk, NULL);
> +	if (ret < 0)
> +		return ret;
> +	ret = nlsock_process_reply(nlsk, nomsg_reply_cb, nlctx);
> +	if (ret < 0)
> +		return ret;
> +
> +	return MNL_CB_OK;
> +
> +err:
> +	ethnla_nest_cancel(msgbuff, nest);
> +	return ret;
> +}
> +
> +static int sset_adver_all(struct nl_context *nlctx)

                   ^^^^^ advert?

Michal

> +{
> +	struct nl_socket *nlsk = nlctx->ethnl_socket;
> +	int ret;
> +
> +	if (netlink_cmd_check(nlctx->ctx, ETHTOOL_MSG_LINKMODES_GET, false) ||
> +	    netlink_cmd_check(nlctx->ctx, ETHTOOL_MSG_LINKMODES_SET, false))
> +		return -EOPNOTSUPP;
> +
> +	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_LINKMODES_GET,
> +				      ETHTOOL_A_LINKMODES_HEADER,
> +				      ETHTOOL_FLAG_COMPACT_BITSETS);
> +	if (ret < 0)
> +		return ret;
> +	return nlsock_send_get_request(nlsk, linkmodes_reply_adver_all_cb);
> +}
> +
>  int nl_sset(struct cmd_context *ctx)
>  {
>  	struct nl_context *nlctx = ctx->nlctx;
> @@ -1120,6 +1227,14 @@ int nl_sset(struct cmd_context *ctx)
>  	nlctx->argc = ctx->argc;
>  	nlctx->devname = ctx->devname;
>  
> +	/* For compatibility reasons with ioctl-based ethtool, when "autoneg
> +	 * on" is specified without "advertise", "speed" and "duplex", we need
> +	 * to query the supported link modes from the kernel and advertise all
> +	 * of them.
> +	 */
> +	if (sset_is_autoneg_only(nlctx))
> +		return sset_adver_all(nlctx);
> +
>  	ret = nl_parser(nlctx, sset_params, NULL, PARSER_GROUP_MSG);
>  	if (ret < 0)
>  		return 1;
> -- 
> 2.26.2
> 
