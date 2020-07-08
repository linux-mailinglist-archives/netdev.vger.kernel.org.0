Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183A721937A
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgGHWc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:32:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:53450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgGHWc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 18:32:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1C4A4ABE2;
        Wed,  8 Jul 2020 22:32:25 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4DAE060567; Thu,  9 Jul 2020 00:32:24 +0200 (CEST)
Date:   Thu, 9 Jul 2020 00:32:24 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com
Subject: Re: [PATCH net-next 4/9] ethtool: add tunnel info interface
Message-ID: <20200708223224.rpaye4arndlz6c7h@lion.mk-sys.cz>
References: <20200707212434.3244001-1-kuba@kernel.org>
 <20200707212434.3244001-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707212434.3244001-5-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 02:24:29PM -0700, Jakub Kicinski wrote:
> Add an interface to report offloaded UDP ports via ethtool netlink.
> 
> Now that core takes care of tracking which UDP tunnel ports the NICs
> are aware of we can quite easily export this information out to
> user space.
> 
> The responsibility of writing the netlink dumps is split between
> ethtool code and udp_tunnel_nic.c - since udp_tunnel module may
> not always be loaded, yet we should always report the capabilities
> of the NIC.
> 
> $ ethtool --show-tunnels eth0
> Tunnel information for eth0:
>   UDP port table 0:
>     Size: 4
>     Types: vxlan
>     No entries
>   UDP port table 1:
>     Size: 4
>     Types: geneve, vxlan-gpe
>     Entries (1):
>         port 1230, vxlan-gpe
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/ethtool-netlink.rst |  33 +++
>  include/net/udp_tunnel.h                     |  21 ++
>  include/uapi/linux/ethtool.h                 |   2 +
>  include/uapi/linux/ethtool_netlink.h         |  55 ++++
>  net/ethtool/Makefile                         |   3 +-
>  net/ethtool/common.c                         |   9 +
>  net/ethtool/common.h                         |   1 +
>  net/ethtool/netlink.c                        |  12 +
>  net/ethtool/netlink.h                        |   4 +
>  net/ethtool/strset.c                         |   5 +
>  net/ethtool/tunnels.c                        | 261 +++++++++++++++++++
>  net/ipv4/udp_tunnel_nic.c                    |  69 +++++
>  12 files changed, 474 insertions(+), 1 deletion(-)
>  create mode 100644 net/ethtool/tunnels.c
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 396390f4936b..6a9265401d31 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -1230,6 +1230,39 @@ used to report the amplitude of the reflection for a given pair.
>   | | | ``ETHTOOL_A_CABLE_AMPLITUDE_mV``        | s16    | Reflection amplitude |
>   +-+-+-----------------------------------------+--------+----------------------+
>  
> +TUNNEL_INFO
> +===========
> +
> +Gets information about the tunnel state NIC is aware of.
> +
> +Request contents:
> +
> +  =====================================  ======  ==========================
> +  ``ETHTOOL_A_TUNNEL_INFO_HEADER``       nested  request header
> +  =====================================  ======  ==========================
> +
> +Kernel response contents:
> +
> + +---------------------------------------------+--------+---------------------+
> + | ``ETHTOOL_A_TUNNEL_INFO_HEADER``            | nested | reply header        |
> + +---------------------------------------------+--------+---------------------+
> + | ``ETHTOOL_A_TUNNEL_INFO_UDP_PORTS``         | nested | all UDP port tables |
> + +-+-------------------------------------------+--------+---------------------+
> + | | ``ETHTOOL_A_TUNNEL_UDP_TABLE``            | nested | one UDP port table  |
> + +-+-+-----------------------------------------+--------+---------------------+
> + | | | ``ETHTOOL_A_TUNNEL_UDP_TABLE_SIZE``     | u32    | max size of the     |
> + | | |                                         |        | table               |
> + +-+-+-----------------------------------------+--------+---------------------+
> + | | | ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES``    | u32    | bitmask of tunnel   |
> + | | |                                         |        | types table can hold|

In the code below, this is a bitset, not u32.

> + +-+-+-----------------------------------------+--------+---------------------+
> + | | | ``ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY``    | nested | offloaded UDP port  |
> + +-+-+-+---------------------------------------+--------+---------------------+
> + | | | | ``ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT``   | be16   | UDP port            |
> + +-+-+-+---------------------------------------+--------+---------------------+
> + | | | | ``ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE``   | u32    | tunnel type         |
> + +-+-+-+---------------------------------------+--------+---------------------+
> +
>  Request translation
>  ===================
>  
[...]
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index d1413538ef30..0495314ce20b 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
[...]
> @@ -556,6 +557,60 @@ enum {
>  	ETHTOOL_A_CABLE_TEST_TDR_NTF_MAX = __ETHTOOL_A_CABLE_TEST_TDR_NTF_CNT - 1
>  };
>  
> +/* TUNNEL INFO */
> +
> +enum {
> +	ETHTOOL_A_TUNNEL_INFO_UNSPEC,
> +	ETHTOOL_A_TUNNEL_INFO_HEADER,			/* nest - _A_HEADER_* */
> +
> +	ETHTOOL_A_TUNNEL_INFO_UDP_PORTS,		/* nest - _UDP_TABLE */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_TUNNEL_INFO_CNT,
> +	ETHTOOL_A_TUNNEL_INFO_MAX = (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)
> +};

nit: other requests with nested attributes have the enums ordered "from
inside out", i.e. nested attributes before the nest containing them.

> +
> +enum {
> +	ETHTOOL_A_TUNNEL_UDP_UNSPEC,
> +
> +	ETHTOOL_A_TUNNEL_UDP_TABLE,			/* nest - _UDP_TABLE_* */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_TUNNEL_UDP_CNT,
> +	ETHTOOL_A_TUNNEL_UDP_MAX = (__ETHTOOL_A_TUNNEL_UDP_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_TUNNEL_UDP_TABLE_UNSPEC,
> +
> +	ETHTOOL_A_TUNNEL_UDP_TABLE_SIZE,		/* u32 */
> +	ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES,		/* u32 */

In the code below, this is a bitset, not u32.

> +	ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY,		/* nest - _UDP_ENTRY_* */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_TUNNEL_UDP_TABLE_CNT,
> +	ETHTOOL_A_TUNNEL_UDP_TABLE_MAX = (__ETHTOOL_A_TUNNEL_UDP_TABLE_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_TUNNEL_UDP_ENTRY_UNSPEC,
> +
> +	ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,		/* be16 */

Do we get some benefit from passing the port in network byte order? It
would be helpful if we expected userspace to copy it e.g. into struct
sockaddr_in but that doesn't seem to be the case.

> +	ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE,		/* u32 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_TUNNEL_UDP_ENTRY_CNT,
> +	ETHTOOL_A_TUNNEL_UDP_ENTRY_MAX = (__ETHTOOL_A_TUNNEL_UDP_ENTRY_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_UDP_TUNNEL_TYPE_VXLAN,
> +	ETHTOOL_UDP_TUNNEL_TYPE_GENEVE,
> +	ETHTOOL_UDP_TUNNEL_TYPE_VXLAN_GPE,
> +
> +	__ETHTOOL_UDP_TUNNEL_TYPE_BIT_CNT

nit: the "BIT" part looks inconsistent (like a leftover form an older
version where the constants were named differently).

> +};
> +
>  /* generic netlink info */
>  #define ETHTOOL_GENL_NAME "ethtool"
>  #define ETHTOOL_GENL_VERSION 1
[...]
> diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
> index 0eed4e4909ab..5d3f315d4781 100644
> --- a/net/ethtool/strset.c
> +++ b/net/ethtool/strset.c
> @@ -75,6 +75,11 @@ static const struct strset_info info_template[] = {
>  		.count		= __HWTSTAMP_FILTER_CNT,
>  		.strings	= ts_rx_filter_names,
>  	},
> +	[ETH_SS_UDP_TUNNEL_TYPES] = {
> +		.per_dev	= false,
> +		.count		= __ETHTOOL_A_TUNNEL_UDP_ENTRY_CNT,

This should be __ETHTOOL_UDP_TUNNEL_TYPE_BIT_CNT (number of strings in
the set, i.e. number of tunnel types).

> +		.strings	= udp_tunnel_type_names,
> +	},
>  };
>  
>  struct strset_req_info {
> diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
> new file mode 100644
> index 000000000000..e9e09ea08c6a
> --- /dev/null
> +++ b/net/ethtool/tunnels.c
> @@ -0,0 +1,261 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/ethtool_netlink.h>
> +#include <net/udp_tunnel.h>
> +
> +#include "bitset.h"
> +#include "common.h"
> +#include "netlink.h"
> +
> +static const struct nla_policy
> +ethtool_tunnel_info_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1] = {
> +	[ETHTOOL_A_TUNNEL_INFO_UNSPEC]		= { .type = NLA_REJECT },
> +	[ETHTOOL_A_TUNNEL_INFO_HEADER]		= { .type = NLA_NESTED },
> +};
> +
> +static_assert(ETHTOOL_UDP_TUNNEL_TYPE_VXLAN == ilog2(UDP_TUNNEL_TYPE_VXLAN));
> +static_assert(ETHTOOL_UDP_TUNNEL_TYPE_GENEVE == ilog2(UDP_TUNNEL_TYPE_GENEVE));
> +static_assert(ETHTOOL_UDP_TUNNEL_TYPE_VXLAN_GPE ==
> +	      ilog2(UDP_TUNNEL_TYPE_VXLAN_GPE));
> +
> +static ssize_t
> +ethnl_tunnel_info_reply_size(const struct ethnl_req_info *req_base,
> +			     struct netlink_ext_ack *extack)
> +{
> +	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
> +	const struct udp_tunnel_nic_info *info;
> +	unsigned int i;
> +	size_t size;
> +	int ret;
> +
> +	BUILD_BUG_ON(__ETHTOOL_UDP_TUNNEL_TYPE_BIT_CNT > 32);
> +
> +	info = req_base->dev->udp_tunnel_nic_info;
> +	if (!info) {
> +		NL_SET_ERR_MSG(extack,
> +			       "device does not report tunnel offload info");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	size =	nla_total_size(0); /* _INFO_UDP_PORTS */
> +
> +	for (i = 0; i < UDP_TUNNEL_NIC_MAX_TABLES; i++) {
> +		if (!info->tables[i].n_entries)
> +			return size;
> +
> +		size += nla_total_size(0); /* _UDP_TABLE */
> +		size +=	nla_total_size(sizeof(u32)); /* _UDP_TABLE_SIZE */
> +		ret = ethnl_bitset32_size(&info->tables[i].tunnel_types, NULL,
> +					  __ETHTOOL_UDP_TUNNEL_TYPE_BIT_CNT,
> +					  udp_tunnel_type_names, compact);
> +		if (ret < 0)
> +			return ret;
> +		size += ret;
> +
> +		size += udp_tunnel_nic_dump_size(req_base->dev, i);
> +	}
> +
> +	return size;
> +}

How big can the message get? Can we be sure the information for one
device will always fit into a reasonably sized message? Attribute
ETHTOOL_A_TUNNEL_INFO_UDP_PORTS is limited by 65535 bytes (attribute
size is u16), can we always fit into this size?

Michal
