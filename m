Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BE121944E
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgGHXaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgGHXaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 19:30:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2081206F6;
        Wed,  8 Jul 2020 23:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594251051;
        bh=JSzDgpTQWKKKNOnsWMKdiSzIgbfKBWsjW+A35aN+mb0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zpWNQJ/KojJ42A3BucFL/iuk26eHLrQmpNqz1AfrovcoNtne6BmQwXwjs5o1KDJPS
         RDGft9VAY9J6TZN03/hb5YFl8CGRjshgajLj+gtItQSm5Bp95Jlz2dCRTwZJACQJB1
         uS05AyaT5ygrJBYgANk63rouOBkgOkRUFUrRwosw=
Date:   Wed, 8 Jul 2020 16:30:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com
Subject: Re: [PATCH net-next 4/9] ethtool: add tunnel info interface
Message-ID: <20200708163049.4414d7d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200708223224.rpaye4arndlz6c7h@lion.mk-sys.cz>
References: <20200707212434.3244001-1-kuba@kernel.org>
        <20200707212434.3244001-5-kuba@kernel.org>
        <20200708223224.rpaye4arndlz6c7h@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jul 2020 00:32:24 +0200 Michal Kubecek wrote:
> On Tue, Jul 07, 2020 at 02:24:29PM -0700, Jakub Kicinski wrote:
> > + +---------------------------------------------+--------+---------------------+
> > + | ``ETHTOOL_A_TUNNEL_INFO_HEADER``            | nested | reply header        |
> > + +---------------------------------------------+--------+---------------------+
> > + | ``ETHTOOL_A_TUNNEL_INFO_UDP_PORTS``         | nested | all UDP port tables |
> > + +-+-------------------------------------------+--------+---------------------+
> > + | | ``ETHTOOL_A_TUNNEL_UDP_TABLE``            | nested | one UDP port table  |
> > + +-+-+-----------------------------------------+--------+---------------------+
> > + | | | ``ETHTOOL_A_TUNNEL_UDP_TABLE_SIZE``     | u32    | max size of the     |
> > + | | |                                         |        | table               |
> > + +-+-+-----------------------------------------+--------+---------------------+
> > + | | | ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES``    | u32    | bitmask of tunnel   |
> > + | | |                                         |        | types table can hold|  
> 
> In the code below, this is a bitset, not u32.

I was going back and forth on the type. I'll update the doc to say
bitset, LMK if you prefer u32.

> > + +-+-+-----------------------------------------+--------+---------------------+
> > + | | | ``ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY``    | nested | offloaded UDP port  |
> > + +-+-+-+---------------------------------------+--------+---------------------+
> > + | | | | ``ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT``   | be16   | UDP port            |
> > + +-+-+-+---------------------------------------+--------+---------------------+
> > + | | | | ``ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE``   | u32    | tunnel type         |
> > + +-+-+-+---------------------------------------+--------+---------------------+

> > +enum {
> > +	ETHTOOL_A_TUNNEL_INFO_UNSPEC,
> > +	ETHTOOL_A_TUNNEL_INFO_HEADER,			/* nest - _A_HEADER_* */
> > +
> > +	ETHTOOL_A_TUNNEL_INFO_UDP_PORTS,		/* nest - _UDP_TABLE */
> > +
> > +	/* add new constants above here */
> > +	__ETHTOOL_A_TUNNEL_INFO_CNT,
> > +	ETHTOOL_A_TUNNEL_INFO_MAX = (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)
> > +};  
> 
> nit: other requests with nested attributes have the enums ordered "from
> inside out", i.e. nested attributes before the nest containing them.

I see! I'll reorder.

> > +	ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY,		/* nest - _UDP_ENTRY_* */
> > +
> > +	/* add new constants above here */
> > +	__ETHTOOL_A_TUNNEL_UDP_TABLE_CNT,
> > +	ETHTOOL_A_TUNNEL_UDP_TABLE_MAX = (__ETHTOOL_A_TUNNEL_UDP_TABLE_CNT - 1)
> > +};
> > +
> > +enum {
> > +	ETHTOOL_A_TUNNEL_UDP_ENTRY_UNSPEC,
> > +
> > +	ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,		/* be16 */  
> 
> Do we get some benefit from passing the port in network byte order? It
> would be helpful if we expected userspace to copy it e.g. into struct
> sockaddr_in but that doesn't seem to be the case.

I was just following what I believe is a more common pattern. 
TC uses be16 AFAIK (flower, act_ct, tunnel), so do the tunnels
(IFLA_GENEVE_PORT, IFLA_VXLAN_PORT). And ethtool flow descriptions.
I can change, but IMHO that'd be more surprising than be16.

> > +	ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE,		/* u32 */
> > +
> > +	/* add new constants above here */
> > +	__ETHTOOL_A_TUNNEL_UDP_ENTRY_CNT,
> > +	ETHTOOL_A_TUNNEL_UDP_ENTRY_MAX = (__ETHTOOL_A_TUNNEL_UDP_ENTRY_CNT - 1)
> > +};
> > +
> > +enum {
> > +	ETHTOOL_UDP_TUNNEL_TYPE_VXLAN,
> > +	ETHTOOL_UDP_TUNNEL_TYPE_GENEVE,
> > +	ETHTOOL_UDP_TUNNEL_TYPE_VXLAN_GPE,
> > +
> > +	__ETHTOOL_UDP_TUNNEL_TYPE_BIT_CNT  
> 
> nit: the "BIT" part looks inconsistent (like a leftover form an older
> version where the constants were named differently).

Ah, thanks, missed in rename.

> > +};
> > +
> >  /* generic netlink info */
> >  #define ETHTOOL_GENL_NAME "ethtool"
> >  #define ETHTOOL_GENL_VERSION 1  
> [...]
> > diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
> > index 0eed4e4909ab..5d3f315d4781 100644
> > --- a/net/ethtool/strset.c
> > +++ b/net/ethtool/strset.c
> > @@ -75,6 +75,11 @@ static const struct strset_info info_template[] = {
> >  		.count		= __HWTSTAMP_FILTER_CNT,
> >  		.strings	= ts_rx_filter_names,
> >  	},
> > +	[ETH_SS_UDP_TUNNEL_TYPES] = {
> > +		.per_dev	= false,
> > +		.count		= __ETHTOOL_A_TUNNEL_UDP_ENTRY_CNT,  
> 
> This should be __ETHTOOL_UDP_TUNNEL_TYPE_BIT_CNT (number of strings in
> the set, i.e. number of tunnel types).

:o Ack

> > +		.strings	= udp_tunnel_type_names,
> > +	},
> >  };
> >  
> >  struct strset_req_info {
> > diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
> > new file mode 100644
> > index 000000000000..e9e09ea08c6a
> > --- /dev/null
> > +++ b/net/ethtool/tunnels.c
> > @@ -0,0 +1,261 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +#include <linux/ethtool_netlink.h>
> > +#include <net/udp_tunnel.h>
> > +
> > +#include "bitset.h"
> > +#include "common.h"
> > +#include "netlink.h"
> > +
> > +static const struct nla_policy
> > +ethtool_tunnel_info_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1] = {
> > +	[ETHTOOL_A_TUNNEL_INFO_UNSPEC]		= { .type = NLA_REJECT },
> > +	[ETHTOOL_A_TUNNEL_INFO_HEADER]		= { .type = NLA_NESTED },
> > +};
> > +
> > +static_assert(ETHTOOL_UDP_TUNNEL_TYPE_VXLAN == ilog2(UDP_TUNNEL_TYPE_VXLAN));
> > +static_assert(ETHTOOL_UDP_TUNNEL_TYPE_GENEVE == ilog2(UDP_TUNNEL_TYPE_GENEVE));
> > +static_assert(ETHTOOL_UDP_TUNNEL_TYPE_VXLAN_GPE ==
> > +	      ilog2(UDP_TUNNEL_TYPE_VXLAN_GPE));
> > +
> > +static ssize_t
> > +ethnl_tunnel_info_reply_size(const struct ethnl_req_info *req_base,
> > +			     struct netlink_ext_ack *extack)
> > +{
> > +	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
> > +	const struct udp_tunnel_nic_info *info;
> > +	unsigned int i;
> > +	size_t size;
> > +	int ret;
> > +
> > +	BUILD_BUG_ON(__ETHTOOL_UDP_TUNNEL_TYPE_BIT_CNT > 32);
> > +
> > +	info = req_base->dev->udp_tunnel_nic_info;
> > +	if (!info) {
> > +		NL_SET_ERR_MSG(extack,
> > +			       "device does not report tunnel offload info");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	size =	nla_total_size(0); /* _INFO_UDP_PORTS */
> > +
> > +	for (i = 0; i < UDP_TUNNEL_NIC_MAX_TABLES; i++) {
> > +		if (!info->tables[i].n_entries)
> > +			return size;
> > +
> > +		size += nla_total_size(0); /* _UDP_TABLE */
> > +		size +=	nla_total_size(sizeof(u32)); /* _UDP_TABLE_SIZE */
> > +		ret = ethnl_bitset32_size(&info->tables[i].tunnel_types, NULL,
> > +					  __ETHTOOL_UDP_TUNNEL_TYPE_BIT_CNT,
> > +					  udp_tunnel_type_names, compact);
> > +		if (ret < 0)
> > +			return ret;
> > +		size += ret;
> > +
> > +		size += udp_tunnel_nic_dump_size(req_base->dev, i);
> > +	}
> > +
> > +	return size;
> > +}  
> 
> How big can the message get? Can we be sure the information for one
> device will always fit into a reasonably sized message? Attribute
> ETHTOOL_A_TUNNEL_INFO_UDP_PORTS is limited by 65535 bytes (attribute
> size is u16), can we always fit into this size?

I don't think I've seen any driver with more than 2 tables 
or 16 entries total, and they don't seem to be growing in newer
HW (people tend to use standard ports).

188B + 16 * 20B = 508B - so we should be pretty safe with 64k.
