Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B750A21493B
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 01:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgGDX6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 19:58:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:33760 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbgGDX6S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Jul 2020 19:58:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5972CAB98;
        Sat,  4 Jul 2020 23:58:17 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id DB410604BB; Sun,  5 Jul 2020 01:58:16 +0200 (CEST)
Date:   Sun, 5 Jul 2020 01:58:16 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool v4 2/6] Add cable test TDR support
Message-ID: <20200704235816.yonztb7we3b2btdg@lion.mk-sys.cz>
References: <20200701010743.730606-1-andrew@lunn.ch>
 <20200701010743.730606-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701010743.730606-3-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 03:07:39AM +0200, Andrew Lunn wrote:
> Add support for accessing the cable test time domain reflectromatry
> data. Add a new command --cable-test-tdr, and support for dumping the
> data which is returned.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Looks good to me, only three minor issues:

> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -5487,6 +5487,14 @@ static const struct option args[] = {
>  		.nlfunc	= nl_cable_test,
>  		.help	= "Perform a cable test",
>  	},
> +	{
> +		.opts	= "--cable-test-tdr",
> +		.nlfunc	= nl_cable_test_tdr,
> +		.help	= "Print cable test time domain reflectrometery data",
> +		.xhelp	= "		[ first N ]\n"
> +			  "		[ last N ]\n"
> +			  "		[ step N ]\n"

The "pair" parameter is missing here.

> +	},
>  	{
>  		.opts	= "-h|--help",
>  		.no_dev	= true,
[...]
> diff --git a/netlink/monitor.c b/netlink/monitor.c
> index 1af11ee..280fd0b 100644
> --- a/netlink/monitor.c
> +++ b/netlink/monitor.c
> @@ -63,6 +63,10 @@ static struct {
>  		.cmd	= ETHTOOL_MSG_CABLE_TEST_NTF,
>  		.cb	= cable_test_ntf_cb,
>  	},
> +	{
> +		.cmd	= ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
> +		.cb	= cable_test_tdr_ntf_cb,
> +	},
>  };
>  

Please add also an entry to monitor_opts[] to allow filtering monitor
events.

[...]
> diff --git a/netlink/parser.c b/netlink/parser.c
> index bd3526f..67134f1 100644
> --- a/netlink/parser.c
> +++ b/netlink/parser.c
[...]
> @@ -211,6 +227,32 @@ int nl_parse_direct_u8(struct nl_context *nlctx, uint16_t type,
>  	return (type && ethnla_put_u8(msgbuff, type, val)) ? -EMSGSIZE : 0;
>  }
>  
> +/* Parser handler for float meters and convert it to cm. Generates
> + * NLA_U32 or fills an uint32_t.
> + */
> +int nl_parse_direct_m2cm(struct nl_context *nlctx, uint16_t type,
> +			 const void *data, struct nl_msg_buff *msgbuff,
> +			 void *dest)
> +{
> +	const char *arg = *nlctx->argp;
> +	float meters;
> +	uint32_t cm;
> +	int ret;
> +
> +	nlctx->argp++;
> +	nlctx->argc--;
> +	ret = parse_float(arg, &meters, 0, 150);
> +	if (ret < 0) {
> +		parser_err_invalid_value(nlctx, arg);
> +		return ret;
> +	}
> +
> +	cm = (uint32_t)(meters * 100);

When I tried to test the generated requests, I noticed that e.g. "20.3"
was sent as 2029 rather than 2030. It's unlikely to cause an actual
problem but we should probably use e.g.

	cm = (uint32_t)(meters * 100 + 0.5);

to prevent such rounding errors.

Michal

> +	if (dest)
> +		*(uint32_t *)dest = cm;
> +	return (type && ethnla_put_u32(msgbuff, type, cm)) ? -EMSGSIZE : 0;
> +}
> +
>  /* Parser handler for (tri-state) bool. Expects "name on|off", generates
>   * NLA_U8 which is 1 for "on" and 0 for "off".
>   */
