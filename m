Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AED62CEE9A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 14:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgLDNGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 08:06:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:52785 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgLDNGM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 08:06:12 -0500
IronPort-SDR: cqcmwSStINo7nOZqKehMKtEt3hH/xpyWnaX1nRGDqQrri9y7hoIfxynyqHo/e3dBWPW7OCXDeM
 /1R7pfi/RMUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9824"; a="173467664"
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="173467664"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2020 05:05:28 -0800
IronPort-SDR: eLtuUEtRC1V1rKDQhjwIouP6ZxI2XS1UKt02TKcc9y/o9yaaxHUQKStydFRwvW+eaWW8OOVywt
 eO7ulXw2KywQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="374338973"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Dec 2020 05:05:24 -0800
Date:   Fri, 4 Dec 2020 13:57:16 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     alardam@gmail.com
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        andrii.nakryiko@gmail.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org, toke@redhat.com,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
Message-ID: <20201204125716.GB23696@ranger.igk.intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204102901.109709-2-marekx.majtyka@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 11:28:57AM +0100, alardam@gmail.com wrote:
> From: Marek Majtyka <marekx.majtyka@intel.com>
> 
> Implement support for checking what kind of xdp functionality a netdev
> supports. Previously, there was no way to do this other than to try
> to create an AF_XDP socket on the interface or load an XDP program and see
> if it worked. This commit changes this by adding a new variable which
> describes all xdp supported functions on pretty detailed level:
>  - aborted
>  - drop
>  - pass
>  - tx
>  - redirect
>  - zero copy
>  - hardware offload.
> 
> Zerocopy mode requires that redirect xdp operation is implemented
> in a driver and the driver supports also zero copy mode.
> Full mode requires that all xdp operation are implemented in the driver.
> Basic mode is just full mode without redirect operation.
> 
> Initially, these new flags are disabled for all drivers by default.
> 
> Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
> ---
>  .../networking/netdev-xdp-properties.rst      | 42 ++++++++
>  include/linux/netdevice.h                     |  2 +
>  include/linux/xdp_properties.h                | 53 +++++++++++
>  include/net/xdp.h                             | 95 +++++++++++++++++++
>  include/net/xdp_sock_drv.h                    | 10 ++
>  include/uapi/linux/ethtool.h                  |  1 +
>  include/uapi/linux/xdp_properties.h           | 32 +++++++
>  net/ethtool/common.c                          | 11 +++
>  net/ethtool/common.h                          |  4 +
>  net/ethtool/strset.c                          |  5 +
>  10 files changed, 255 insertions(+)
>  create mode 100644 Documentation/networking/netdev-xdp-properties.rst
>  create mode 100644 include/linux/xdp_properties.h
>  create mode 100644 include/uapi/linux/xdp_properties.h
> 
> diff --git a/Documentation/networking/netdev-xdp-properties.rst b/Documentation/networking/netdev-xdp-properties.rst
> new file mode 100644
> index 000000000000..4a434a1c512b
> --- /dev/null
> +++ b/Documentation/networking/netdev-xdp-properties.rst
> @@ -0,0 +1,42 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=====================
> +Netdev XDP properties
> +=====================
> +
> + * XDP PROPERTIES FLAGS
> +
> +Following netdev xdp properties flags can be retrieve over netlink ethtool
> +interface the same way as netdev feature flags. These properties flags are
> +read only and cannot be change in the runtime.
> +
> +
> +*  XDP_ABORTED
> +
> +This property informs if netdev supports xdp aborted action.
> +
> +*  XDP_DROP
> +
> +This property informs if netdev supports xdp drop action.
> +
> +*  XDP_PASS
> +
> +This property informs if netdev supports xdp pass action.
> +
> +*  XDP_TX
> +
> +This property informs if netdev supports xdp tx action.
> +
> +*  XDP_REDIRECT
> +
> +This property informs if netdev supports xdp redirect action.
> +It assumes the all beforehand mentioned flags are enabled.
> +
> +*  XDP_ZEROCOPY
> +
> +This property informs if netdev driver supports xdp zero copy.
> +It assumes the all beforehand mentioned flags are enabled.
> +
> +*  XDP_HW_OFFLOAD
> +
> +This property informs if netdev driver supports xdp hw oflloading.
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 52d1cc2bd8a7..2544c7f0e1b7 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -43,6 +43,7 @@
>  #include <net/xdp.h>
>  
>  #include <linux/netdev_features.h>
> +#include <linux/xdp_properties.h>
>  #include <linux/neighbour.h>
>  #include <uapi/linux/netdevice.h>
>  #include <uapi/linux/if_bonding.h>
> @@ -2171,6 +2172,7 @@ struct net_device {
>  
>  	/* protected by rtnl_lock */
>  	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
> +	xdp_properties_t	xdp_properties;
>  };
>  #define to_net_dev(d) container_of(d, struct net_device, dev)
>  
> diff --git a/include/linux/xdp_properties.h b/include/linux/xdp_properties.h
> new file mode 100644
> index 000000000000..c72c9bcc50de
> --- /dev/null
> +++ b/include/linux/xdp_properties.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Network device xdp properties.
> + */
> +#ifndef _LINUX_XDP_PROPERTIES_H
> +#define _LINUX_XDP_PROPERTIES_H
> +
> +#include <linux/types.h>
> +#include <linux/bitops.h>
> +#include <asm/byteorder.h>
> +
> +typedef u64 xdp_properties_t;
> +
> +enum {
> +	XDP_F_ABORTED_BIT,
> +	XDP_F_DROP_BIT,
> +	XDP_F_PASS_BIT,
> +	XDP_F_TX_BIT,
> +	XDP_F_REDIRECT_BIT,
> +	XDP_F_ZEROCOPY_BIT,
> +	XDP_F_HW_OFFLOAD_BIT,
> +
> +	/*
> +	 * Add your fresh new property above and remember to update
> +	 * xdp_properties_strings [] in net/core/ethtool.c and maybe
> +	 * some xdp_properties mask #defines below. Please also describe it
> +	 * in Documentation/networking/xdp_properties.rst.
> +	 */
> +
> +	/**/XDP_PROPERTIES_COUNT
> +};
> +
> +#define __XDP_F_BIT(bit)	((xdp_properties_t)1 << (bit))
> +#define __XDP_F(name)		__XDP_F_BIT(XDP_F_##name##_BIT)
> +
> +#define XDP_F_ABORTED		__XDP_F(ABORTED)
> +#define XDP_F_DROP		__XDP_F(DROP)
> +#define XDP_F_PASS		__XDP_F(PASS)
> +#define XDP_F_TX		__XDP_F(TX)
> +#define XDP_F_REDIRECT		__XDP_F(REDIRECT)
> +#define XDP_F_ZEROCOPY		__XDP_F(ZEROCOPY)
> +#define XDP_F_HW_OFFLOAD	__XDP_F(HW_OFFLOAD)
> +
> +#define XDP_F_BASIC		(XDP_F_ABORTED |	\
> +				 XDP_F_DROP |		\
> +				 XDP_F_PASS |		\
> +				 XDP_F_TX)
> +
> +#define XDP_F_FULL		(XDP_F_BASIC | XDP_F_REDIRECT)
> +
> +#define XDP_F_FULL_ZC		(XDP_F_FULL | XDP_F_ZEROCOPY)

Seems like you're not making use of this flag? Next patch combines two
calls for XDP_F_FULL and XDP_F_ZEROCOPY, like:

xdp_set_full_properties(&netdev->xdp_properties);
xsk_set_zc_property(&netdev->xdp_properties);

So either drop the flag, or introduce xdp_set_full_zc_properties().

I was also thinking if it would make sense to align the naming here and
refer to these as 'xdp features', like netdevice.h tends to do, not 'xdp
properties'.

> +
> +#endif /* _LINUX_XDP_PROPERTIES_H */
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 700ad5db7f5d..a9fabc1282cf 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -7,6 +7,7 @@
>  #define __LINUX_NET_XDP_H__
>  
>  #include <linux/skbuff.h> /* skb_shared_info */
> +#include <linux/xdp_properties.h>
>  
>  /**
>   * DOC: XDP RX-queue information
> @@ -255,6 +256,100 @@ struct xdp_attachment_info {
>  	u32 flags;
>  };
>  
> +#if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
> +
> +static __always_inline void
> +xdp_set_aborted_property(xdp_properties_t *properties)
> +{
> +	*properties |= XDP_F_ABORTED;
> +}
> +
> +static __always_inline void
> +xdp_set_pass_property(xdp_properties_t *properties)
> +{
> +	*properties |= XDP_F_PASS;
> +}
> +
> +static __always_inline void
> +xdp_set_drop_property(xdp_properties_t *properties)
> +{
> +	*properties |= XDP_F_DROP;
> +}
> +
> +static __always_inline void
> +xdp_set_tx_property(xdp_properties_t *properties)
> +{
> +	*properties |= XDP_F_TX;
> +}
> +
> +static __always_inline void
> +xdp_set_redirect_property(xdp_properties_t *properties)
> +{
> +	*properties |= XDP_F_REDIRECT;
> +}
> +
> +static __always_inline void
> +xdp_set_hw_offload_property(xdp_properties_t *properties)
> +{
> +	*properties |= XDP_F_HW_OFFLOAD;
> +}
> +
> +static __always_inline void
> +xdp_set_basic_properties(xdp_properties_t *properties)
> +{
> +	*properties |= XDP_F_BASIC;
> +}
> +
> +static __always_inline void
> +xdp_set_full_properties(xdp_properties_t *properties)
> +{
> +	*properties |= XDP_F_FULL;
> +}
> +
> +#else
> +
> +static __always_inline void
> +xdp_set_aborted_property(xdp_properties_t *properties)
> +{
> +}
> +
> +static __always_inline void
> +xdp_set_pass_property(xdp_properties_t *properties)
> +{
> +}
> +
> +static __always_inline void
> +xdp_set_drop_property(xdp_properties_t *properties)
> +{
> +}
> +
> +static __always_inline void
> +xdp_set_tx_property(xdp_properties_t *properties)
> +{
> +}
> +
> +static __always_inline void
> +xdp_set_redirect_property(xdp_properties_t *properties)
> +{
> +}
> +
> +static __always_inline void
> +xdp_set_hw_offload_property(xdp_properties_t *properties)
> +{
> +}
> +
> +static __always_inline void
> +xdp_set_basic_properties(xdp_properties_t *properties)
> +{
> +}
> +
> +static __always_inline void
> +xdp_set_full_properties(xdp_properties_t *properties)
> +{
> +}
> +
> +#endif
> +
>  struct netdev_bpf;
>  bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
>  			     struct netdev_bpf *bpf);
> diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> index 4e295541e396..48a3b6d165c7 100644
> --- a/include/net/xdp_sock_drv.h
> +++ b/include/net/xdp_sock_drv.h
> @@ -8,6 +8,7 @@
>  
>  #include <net/xdp_sock.h>
>  #include <net/xsk_buff_pool.h>
> +#include <linux/xdp_properties.h>
>  
>  #ifdef CONFIG_XDP_SOCKETS
>  
> @@ -117,6 +118,11 @@ static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,
>  	xp_dma_sync_for_device(pool, dma, size);
>  }
>  
> +static inline void xsk_set_zc_property(xdp_properties_t *properties)
> +{
> +	*properties |= XDP_F_ZEROCOPY;
> +}
> +
>  #else
>  
>  static inline void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries)
> @@ -242,6 +248,10 @@ static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,
>  {
>  }
>  
> +static inline void xsk_set_zc_property(xdp_properties_t *properties)
> +{
> +}
> +
>  #endif /* CONFIG_XDP_SOCKETS */
>  
>  #endif /* _LINUX_XDP_SOCK_DRV_H */
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 9ca87bc73c44..dfcb0e2c98b2 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -688,6 +688,7 @@ enum ethtool_stringset {
>  	ETH_SS_TS_TX_TYPES,
>  	ETH_SS_TS_RX_FILTERS,
>  	ETH_SS_UDP_TUNNEL_TYPES,
> +	ETH_SS_XDP_PROPERTIES,
>  
>  	/* add new constants above here */
>  	ETH_SS_COUNT
> diff --git a/include/uapi/linux/xdp_properties.h b/include/uapi/linux/xdp_properties.h
> new file mode 100644
> index 000000000000..e85be03eb707
> --- /dev/null
> +++ b/include/uapi/linux/xdp_properties.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +
> +/*
> + * Copyright (c) 2020 Intel
> + */
> +
> +#ifndef __UAPI_LINUX_XDP_PROPERTIES__
> +#define __UAPI_LINUX_XDP_PROPERTIES__
> +
> +/* ETH_GSTRING_LEN define is needed. */
> +#include <linux/ethtool.h>
> +
> +#define XDP_PROPERTIES_ABORTED_STR	"xdp-aborted"
> +#define XDP_PROPERTIES_DROP_STR		"xdp-drop"
> +#define XDP_PROPERTIES_PASS_STR		"xdp-pass"
> +#define XDP_PROPERTIES_TX_STR		"xdp-tx"
> +#define XDP_PROPERTIES_REDIRECT_STR	"xdp-redirect"
> +#define XDP_PROPERTIES_ZEROCOPY_STR	"xdp-zerocopy"
> +#define XDP_PROPERTIES_HW_OFFLOAD_STR	"xdp-hw-offload"
> +
> +#define	DECLARE_XDP_PROPERTIES_TABLE(name)		\
> +	const char name[][ETH_GSTRING_LEN] = {		\
> +		XDP_PROPERTIES_ABORTED_STR,		\
> +		XDP_PROPERTIES_DROP_STR,		\
> +		XDP_PROPERTIES_PASS_STR,		\
> +		XDP_PROPERTIES_TX_STR,			\
> +		XDP_PROPERTIES_REDIRECT_STR,		\
> +		XDP_PROPERTIES_ZEROCOPY_STR,		\
> +		XDP_PROPERTIES_HW_OFFLOAD_STR,		\
> +	}
> +
> +#endif  /* __UAPI_LINUX_XDP_PROPERTIES__ */
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 24036e3055a1..8f15f96b8922 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -4,6 +4,7 @@
>  #include <linux/net_tstamp.h>
>  #include <linux/phy.h>
>  #include <linux/rtnetlink.h>
> +#include <uapi/linux/xdp_properties.h>
>  
>  #include "common.h"
>  
> @@ -283,6 +284,16 @@ const char udp_tunnel_type_names[][ETH_GSTRING_LEN] = {
>  static_assert(ARRAY_SIZE(udp_tunnel_type_names) ==
>  	      __ETHTOOL_UDP_TUNNEL_TYPE_CNT);
>  
> +const char xdp_properties_strings[XDP_PROPERTIES_COUNT][ETH_GSTRING_LEN] = {
> +	[XDP_F_ABORTED_BIT] =		XDP_PROPERTIES_ABORTED_STR,
> +	[XDP_F_DROP_BIT] =		XDP_PROPERTIES_DROP_STR,
> +	[XDP_F_PASS_BIT] =		XDP_PROPERTIES_PASS_STR,
> +	[XDP_F_TX_BIT] =		XDP_PROPERTIES_TX_STR,
> +	[XDP_F_REDIRECT_BIT] =		XDP_PROPERTIES_REDIRECT_STR,
> +	[XDP_F_ZEROCOPY_BIT] =		XDP_PROPERTIES_ZEROCOPY_STR,
> +	[XDP_F_HW_OFFLOAD_BIT] =	XDP_PROPERTIES_HW_OFFLOAD_STR,
> +};
> +
>  /* return false if legacy contained non-0 deprecated fields
>   * maxtxpkt/maxrxpkt. rest of ksettings always updated
>   */
> diff --git a/net/ethtool/common.h b/net/ethtool/common.h
> index 3d9251c95a8b..85a35f8781eb 100644
> --- a/net/ethtool/common.h
> +++ b/net/ethtool/common.h
> @@ -5,8 +5,10 @@
>  
>  #include <linux/netdevice.h>
>  #include <linux/ethtool.h>
> +#include <linux/xdp_properties.h>
>  
>  #define ETHTOOL_DEV_FEATURE_WORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 32)
> +#define ETHTOOL_XDP_PROPERTIES_WORDS	DIV_ROUND_UP(XDP_PROPERTIES_COUNT, 32)
>  
>  /* compose link mode index from speed, type and duplex */
>  #define ETHTOOL_LINK_MODE(speed, type, duplex) \
> @@ -22,6 +24,8 @@ extern const char
>  tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN];
>  extern const char
>  phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
> +extern const char
> +xdp_properties_strings[XDP_PROPERTIES_COUNT][ETH_GSTRING_LEN];
>  extern const char link_mode_names[][ETH_GSTRING_LEN];
>  extern const char netif_msg_class_names[][ETH_GSTRING_LEN];
>  extern const char wol_mode_names[][ETH_GSTRING_LEN];
> diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
> index 0baad0ce1832..684e751b31a9 100644
> --- a/net/ethtool/strset.c
> +++ b/net/ethtool/strset.c
> @@ -80,6 +80,11 @@ static const struct strset_info info_template[] = {
>  		.count		= __ETHTOOL_UDP_TUNNEL_TYPE_CNT,
>  		.strings	= udp_tunnel_type_names,
>  	},
> +	[ETH_SS_XDP_PROPERTIES] = {
> +		.per_dev	= false,
> +		.count		= ARRAY_SIZE(xdp_properties_strings),
> +		.strings	= xdp_properties_strings,
> +	},
>  };
>  
>  struct strset_req_info {
> -- 
> 2.27.0
> 
