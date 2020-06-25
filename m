Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75A520A743
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 23:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405705AbgFYVMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 17:12:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:40834 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405670AbgFYVMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 17:12:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E47D3ACA7;
        Thu, 25 Jun 2020 21:12:27 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 00CFC60460; Thu, 25 Jun 2020 23:12:27 +0200 (CEST)
Date:   Thu, 25 Jun 2020 23:12:27 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool v3 1/6] Add cable test support
Message-ID: <20200625211227.hvo3a5kbmsymzkz6@lion.mk-sys.cz>
References: <20200625192446.535754-1-andrew@lunn.ch>
 <20200625192446.535754-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625192446.535754-2-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 09:24:41PM +0200, Andrew Lunn wrote:
> Add support for starting a cable test, and report the results.
> 
> This code does not follow the usual patterns because of the way the
> kernel reports the results of the cable test. It can take a number of
> seconds for cable testing to occur. So the action request messages is
> immediately acknowledges, and the test is then performed asynchronous.
> Once the test has completed, the results are returned as a
> notification.
> 
> This means the command starts as usual. It then monitors multicast
> messages until it receives the results.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
[...]
> --- /dev/null
> +++ b/netlink/cable_test.c
> @@ -0,0 +1,257 @@
> +/*
> + * cable_test.c - netlink implementation of cable test command
> + *
> + * Implementation of ethtool <dev> --cable-test

This should be "ethtool --cable-test <dev>", I believe.

> + */
> +
> +#include <errno.h>
> +#include <string.h>
> +#include <stdio.h>
> +
> +#include "../internal.h"
> +#include "../common.h"
> +#include "netlink.h"
> +
> +static bool breakout;

I would prefer to avoid global state variables to prevent possible
reentrancy issues in the future. First, monitor will almost certainly
have to process events from multiple sockets (ethtool netlink, devlink,
rtnetlink) and I'm still not sure which implementation to use. Second,
there is an idea (perhaps too ambitious) of transforming part of the
code into a library which could be used not only by ethtool but also by
other tools.

nl_context::cmd_private can be used for this purpose (there is an
example in nl_sfeatures() and related code).

[...]
> +static char *nl_pair2txt(uint8_t pair)
> +{
> +	switch (pair) {
> +	case ETHTOOL_A_CABLE_PAIR_A:
> +		return "Pair A";
> +	case ETHTOOL_A_CABLE_PAIR_B:
> +		return "Pair B";
> +	case ETHTOOL_A_CABLE_PAIR_C:
> +		return "Pair C";
> +	case ETHTOOL_A_CABLE_PAIR_D:
> +		return "Pair D";
> +	default:
> +		return "Unexpected pair";
> +	}
> +}
> +
> +static int nl_cable_test_ntf_attr(struct nlattr *evattr)
> +{
> +	unsigned int cm;
> +	uint16_t code;
> +	uint8_t pair;
> +	int ret;
> +
> +	switch (mnl_attr_get_type(evattr)) {
> +	case ETHTOOL_A_CABLE_NEST_RESULT:
> +		ret = nl_get_cable_test_result(evattr, &pair, &code);
> +		if (ret < 0)
> +			return ret;
> +
> +		printf("Pair: %s, result: %s\n", nl_pair2txt(pair),
> +		       nl_code2txt(code));

AFAICS this will produce output like "Pair: Pair A, ..." which looks
a bit strange, is it intended? (The same below).

> +		break;
> +
> +	case ETHTOOL_A_CABLE_NEST_FAULT_LENGTH:
> +		ret = nl_get_cable_test_fault_length(evattr, &pair, &cm);
> +		if (ret < 0)
> +			return ret;
> +
> +		printf("Pair: %s, fault length: %0.2fm\n",
> +		       nl_pair2txt(pair), (float)cm / 100);
> +		break;
> +	}
> +	return 0;
> +}
[...]
> +/* Receive the broadcasted messages until we get the cable test
> + * results
> + */
> +static int nl_cable_test_process_results(struct cmd_context *ctx)
> +{
> +        struct nl_context *nlctx = ctx->nlctx;
> +	struct nl_socket *nlsk = nlctx->ethnl_socket;
> +	int err;
> +
> +        nlctx->is_monitor = true;
> +        nlsk->port = 0;
> +	nlsk->seq = 0;

Some of the lines above have wrong indentation (and some more in
nl_cable_test()).

Michal
