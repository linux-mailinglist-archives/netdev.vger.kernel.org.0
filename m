Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D80C276405
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIWWpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:45:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:42202 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgIWWpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 18:45:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D698BAB9F;
        Wed, 23 Sep 2020 22:45:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 0ABDE60320; Thu, 24 Sep 2020 00:45:10 +0200 (CEST)
Date:   Thu, 24 Sep 2020 00:45:10 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool-next 5/5] pause: add support for dumping
 statistics
Message-ID: <20200923224510.h3kpgczd6wkpoitp@lion.mk-sys.cz>
References: <20200915235259.457050-1-kuba@kernel.org>
 <20200915235259.457050-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915235259.457050-6-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 04:52:59PM -0700, Jakub Kicinski wrote:
> Add support for requesting pause frame stats from the kernel.
> 
>  # ./ethtool -I -a eth0
> Pause parameters for eth0:
> Autonegotiate:	on
> RX:		on
> TX:		on
> Statistics:
>   tx_pause_frames: 1
>   rx_pause_frames: 1
> 
>  # ./ethtool -I --json -a eth0
> [ {
>         "ifname": "eth0",
>         "autonegotiate": true,
>         "rx": true,
>         "tx": true,
>         "statistics": {
>             "tx_pause_frames": 1,
>             "rx_pause_frames": 1
>         }
>     } ]
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  netlink/pause.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 65 insertions(+), 1 deletion(-)
> 
> diff --git a/netlink/pause.c b/netlink/pause.c
> index 30ecdccb15eb..f9dec9fe887a 100644
> --- a/netlink/pause.c
> +++ b/netlink/pause.c
> @@ -5,6 +5,7 @@
>   */
>  
>  #include <errno.h>
> +#include <inttypes.h>
>  #include <string.h>
>  #include <stdio.h>
>  
> @@ -110,6 +111,62 @@ static int show_pause_autoneg_status(struct nl_context *nlctx)
>  	return ret;
>  }
>  
> +static int show_pause_stats(const struct nlattr *nest)
> +{
> +	const struct nlattr *tb[ETHTOOL_A_PAUSE_STAT_MAX + 1] = {};
> +	DECLARE_ATTR_TB_INFO(tb);
> +	static const struct {
> +		unsigned int attr;
> +		char *name;
> +	} stats[] = {
> +		{ ETHTOOL_A_PAUSE_STAT_TX_FRAMES, "tx_pause_frames" },
> +		{ ETHTOOL_A_PAUSE_STAT_RX_FRAMES, "rx_pause_frames" },
> +	};
> +	bool header = false;
> +	unsigned int i;
> +	size_t n;
> +	int ret;
> +
> +	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
> +	if (ret < 0)
> +		return ret;
> +
> +	open_json_object("statistics");
> +	for (i = 0; i < ARRAY_SIZE(stats); i++) {
> +		char fmt[32];
> +
> +		if (!tb[stats[i].attr])
> +			continue;
> +
> +		if (!header && !is_json_context()) {
> +			printf("Statistics:\n");
> +			header = true;
> +		}
> +
> +		if (mnl_attr_validate(tb[stats[i].attr], MNL_TYPE_U64)) {
> +			fprintf(stderr, "malformed netlink message (statistic)\n");
> +			goto err_close_stats;
> +		}
> +
> +		n = snprintf(fmt, sizeof(fmt), "  %s: %%" PRId64 "\n",
> +			     stats[i].name);

The stats are unsigned so the format should be PRIu64 here.

> +		if (n >= sizeof(fmt)) {
> +			fprintf(stderr, "internal error - malformed label\n");
> +			goto err_close_stats;
> +		}
> +
> +		print_u64(PRINT_ANY, stats[i].name, fmt,
> +			  mnl_attr_get_u64(tb[stats[i].attr]));
> +	}
> +	close_json_object();
> +
> +	return 0;
> +
> +err_close_stats:
> +	close_json_object();
> +	return -1;
> +}
> +
>  int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>  {
>  	const struct nlattr *tb[ETHTOOL_A_PAUSE_MAX + 1] = {};
> @@ -147,6 +204,11 @@ int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>  		if (ret < 0)
>  			goto err_close_dev;
>  	}
> +	if (tb[ETHTOOL_A_PAUSE_STATS]) {
> +		ret = show_pause_stats(tb[ETHTOOL_A_PAUSE_STATS]);
> +		if (ret < 0)
> +			goto err_close_dev;
> +	}
>  	if (!silent)
>  		print_nl();
>  
> @@ -163,6 +225,7 @@ int nl_gpause(struct cmd_context *ctx)
>  {
>  	struct nl_context *nlctx = ctx->nlctx;
>  	struct nl_socket *nlsk = nlctx->ethnl_socket;
> +	u32 flags;
>  	int ret;
>  
>  	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PAUSE_GET, true))
> @@ -173,8 +236,9 @@ int nl_gpause(struct cmd_context *ctx)
>  		return 1;
>  	}
>  
> +	flags = nlctx->ctx->show_stats ? ETHTOOL_FLAG_STATS : 0;
>  	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_PAUSE_GET,
> -				      ETHTOOL_A_PAUSE_HEADER, 0);
> +				      ETHTOOL_A_PAUSE_HEADER, flags);
>  	if (ret < 0)
>  		return ret;
>  

When the stats are supported by kernel but not provided by a device,
the request will succeed and usual output without stats will be shown.
However, when stats are requested on a pre-5.10 kernel not recognizing
ETHTOOL_FLAG_STATS, the request will fail:

    mike@lion:~/work/git/ethtool> ./ethtool --debug 0x10 -I -a eth0
    netlink error: unrecognized request flags
    netlink error: Operation not supported
    offending message and attribute:
        ETHTOOL_MSG_PAUSE_GET
            ETHTOOL_A_PAUSE_HEADER
                ETHTOOL_A_HEADER_DEV_NAME = "eth0"
    ===>        ETHTOOL_A_HEADER_FLAGS = 0x00000004

We should probably repeat the request with flags=0 in this case but that
would require keeping the offset of ETHTOOL_A_HEADER_FLAGS attribute and
checking for -EOPNOTSUPP with this offset in nlsock_process_ack().

Michal
