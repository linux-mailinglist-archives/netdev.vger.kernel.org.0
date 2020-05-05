Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228671C4ED6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgEEHPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:15:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:57736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgEEHPV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:15:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 74986AFE6;
        Tue,  5 May 2020 07:15:21 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4C82E602B9; Tue,  5 May 2020 09:15:18 +0200 (CEST)
Date:   Tue, 5 May 2020 09:15:18 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 03/10] net: ethtool: netlink: Add support for
 triggering a cable test
Message-ID: <20200505071518.GG8237@lion.mk-sys.cz>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-4-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505001821.208534-4-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 02:18:14AM +0200, Andrew Lunn wrote:
> Add new ethtool netlink calls to trigger the starting of a PHY cable
> test.
> 
> Add Kconfig'ury to ETHTOOL_NETLINK so that PHYLIB is not a module when
> ETHTOOL_NETLINK is builtin, which would result in kernel linking errors.
> 
> v2:
> Remove unwanted white space change
> Remove ethnl_cable_test_act_ops and use doit handler
> Rename cable_test_set_policy cable_test_act_policy
> Remove ETHTOOL_MSG_CABLE_TEST_ACT_REPLY
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 567326491f80..72d53da2bea9 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -204,6 +204,7 @@ Userspace to kernel:
>    ``ETHTOOL_MSG_EEE_GET``               get EEE settings
>    ``ETHTOOL_MSG_EEE_SET``               set EEE settings
>    ``ETHTOOL_MSG_TSINFO_GET``		get timestamping info
> +  ``ETHTOOL_MSG_CABLE_TEST_ACT``        action start cable test
>    ===================================== ================================
>  
>  Kernel to userspace:
> @@ -235,6 +236,7 @@ Kernel to userspace:
>    ``ETHTOOL_MSG_EEE_GET_REPLY``         EEE settings
>    ``ETHTOOL_MSG_EEE_NTF``               EEE settings
>    ``ETHTOOL_MSG_TSINFO_GET_REPLY``	timestamping info
> +  ``ETHTOOL_MSG_CABLE_TEST_ACT_REPLY``  Cable test action result

This was dropped.

[...]
> diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
> new file mode 100644
> index 000000000000..6e5782a7da80
> --- /dev/null
> +++ b/net/ethtool/cabletest.c
> @@ -0,0 +1,61 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/phy.h>
> +#include "netlink.h"
> +#include "common.h"
> +#include "bitset.h"
> +
> +static const struct nla_policy
> +cable_test_get_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
> +	[ETHTOOL_A_CABLE_TEST_UNSPEC]		= { .type = NLA_REJECT },
> +	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
> +};

This policy is probably a leftover from the previous version. Also, you
don't need to include bitset.h

[...]
> diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
> index 81b8fa020bcb..03e65e2b9e3d 100644
> --- a/net/ethtool/netlink.h
> +++ b/net/ethtool/netlink.h
> @@ -345,6 +345,7 @@ extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
>  extern const struct ethnl_request_ops ethnl_pause_request_ops;
>  extern const struct ethnl_request_ops ethnl_eee_request_ops;
>  extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
> +extern const struct ethnl_request_ops ethnl_cable_test_act_ops;

This was also dropped.

Excepts for the cleanups suggested above,

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Michal
