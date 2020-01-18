Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02231141504
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 01:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgARACI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 19:02:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:25971 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730232AbgARACH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 19:02:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 16:02:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,332,1574150400"; 
   d="scan'208";a="426168942"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jan 2020 16:02:03 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Po Liu <po.liu@nxp.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens\@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison\@lohutok.net" <allison@lohutok.net>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1\@gmail.com" <hkallweit1@gmail.com>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "andrew\@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli\@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean\@analog.com" <alexandru.ardelean@analog.com>,
        "jiri\@mellanox.com" <jiri@mellanox.com>,
        "ayal\@mellanox.com" <ayal@mellanox.com>,
        "pablo\@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "simon.horman\@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
In-Reply-To: <20191127094517.6255-1-Po.Liu@nxp.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
Date:   Fri, 17 Jan 2020 16:03:07 -0800
Message-ID: <87v9p93a2s.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Po Liu <po.liu@nxp.com> writes:

> IEEE Std 802.1Qbu standard defined the frame preemption of port
> traffic classes. This patch introduce a method to set traffic
> classes preemption. Add a parameter 'preemption' in struct
> ethtool_link_settings. The value will be translated to a binary,
> each bit represent a traffic class. Bit "1" means preemptable
> traffic class. Bit "0" means express traffic class.  MSB represent
> high number traffic class.

I think that we should keep the concept of 'traffic classes' outside of
ethtool. Ethtool should only care about queues (or similar concepts).
And unless I am missing something here, what you mean by 'traffic class'
here is really a hardware queue.

>
> If hardware support the frame preemption, driver could set the
> ethernet device with hw_features and features with NETIF_F_PREEMPTION
> when initializing the port driver.
>
> User can check the feature 'tx-preemption' by command 'ethtool -k
> devname'. If hareware set preemption feature. The property would
> be a fixed value 'on' if hardware support the frame preemption.
> Feature would show a fixed value 'off' if hardware don't support
> the frame preemption.
>
> Command 'ethtool devname' and 'ethtool -s devname preemption N'
> would show/set which traffic classes are frame preemptable.
>
> Port driver would implement the frame preemption in the function
> get_link_ksettings() and set_link_ksettings() in the struct ethtool_ops.
>
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> ---
>  include/linux/netdev_features.h | 5 ++++-
>  include/uapi/linux/ethtool.h    | 5 ++++-
>  net/core/ethtool.c              | 1 +
>  3 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 4b19c544c59a..299750a8b414 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -80,6 +80,7 @@ enum {
>  
>  	NETIF_F_GRO_HW_BIT,		/* Hardware Generic receive offload */
>  	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
> +	NETIF_F_HW_PREEMPTION_BIT,	/* Hardware TC frame preemption */
>  
>  	/*
>  	 * Add your fresh new feature above and remember to update
> @@ -150,6 +151,7 @@ enum {
>  #define NETIF_F_GSO_UDP_L4	__NETIF_F(GSO_UDP_L4)
>  #define NETIF_F_HW_TLS_TX	__NETIF_F(HW_TLS_TX)
>  #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
> +#define NETIF_F_PREEMPTION	__NETIF_F(HW_PREEMPTION)
>  
>  /* Finds the next feature with the highest number of the range of start till 0.
>   */
> @@ -175,7 +177,8 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
>  /* Features valid for ethtool to change */
>  /* = all defined minus driver/device-class-related */
>  #define NETIF_F_NEVER_CHANGE	(NETIF_F_VLAN_CHALLENGED | \
> -				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
> +				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL | \
> +				 NETIF_F_PREEMPTION)
>  
>  /* remember that ((t)1 << t_BITS) is undefined in C99 */
>  #define NETIF_F_ETHTOOL_BITS	((__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) | \
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index d4591792f0b4..12ffb34afbfa 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1776,6 +1776,8 @@ enum ethtool_reset_flags {
>  };
>  #define ETH_RESET_SHARED_SHIFT	16
>  
> +/* Disable preemtion. */
> +#define PREEMPTION_DISABLE     0x0
>  
>  /**
>   * struct ethtool_link_settings - link control and status
> @@ -1886,7 +1888,8 @@ struct ethtool_link_settings {
>  	__s8	link_mode_masks_nwords;
>  	__u8	transceiver;
>  	__u8	reserved1[3];
> -	__u32	reserved[7];
> +	__u32	preemption;
> +	__u32	reserved[6];
>  	__u32	link_mode_masks[0];
>  	/* layout of link_mode_masks fields:
>  	 * __u32 map_supported[link_mode_masks_nwords];
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index cd9bc67381b2..6ffcd8a602b8 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -111,6 +111,7 @@ static const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN]
>  	[NETIF_F_HW_TLS_RECORD_BIT] =	"tls-hw-record",
>  	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
>  	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
> +	[NETIF_F_HW_PREEMPTION_BIT] =	 "tx-preemption",
>  };
>  
>  static const char
> -- 
> 2.17.1
