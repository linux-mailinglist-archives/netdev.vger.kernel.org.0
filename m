Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C480117731
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 21:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfLIUPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 15:15:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43196 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfLIUPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 15:15:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=T5Yi+OIGx+pBIZwjkRO4oHqWr7IP5W/5NxupEGz/i88=; b=xCVk3hwrbtcEnyJTg9bOSB0nCf
        4GwmAlsCChLcd/z5Mt/hyrYYgkzMAgMZA3nG6ZP2rDF+DJEfKbTNt0RqPVZepesUfkABNzv/XNOGk
        mMfP4o7ovmEhoOMSGiqiY0el6h3nXz21GZjN4X2jwzmBIjVAavS8lXUTXG/acUwrXiGE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iePR1-0007ni-IQ; Mon, 09 Dec 2019 21:15:11 +0100
Date:   Mon, 9 Dec 2019 21:15:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] ethtool: provide link mode names as a
 string set
Message-ID: <20191209201511.GL9099@lunn.ch>
References: <cover.1575920565.git.mkubecek@suse.cz>
 <0c239334df943c3f5f4ca74a2509754e08eda9e3.1575920565.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c239334df943c3f5f4ca74a2509754e08eda9e3.1575920565.git.mkubecek@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 08:55:45PM +0100, Michal Kubecek wrote:
> Unlike e.g. netdev features, the ethtool ioctl interface requires link mode
> table to be in sync between kernel and userspace for userspace to be able
> to display and set all link modes supported by kernel. The way arbitrary
> length bitsets are implemented in netlink interface, this will be no longer
> needed.
> 
> To allow userspace to access all link modes running kernel supports, add
> table of ethernet link mode names and make it available as a string set to
> userspace GET_STRSET requests. Add build time check to make sure names
> are defined for all modes declared in enum ethtool_link_mode_bit_indices.

Hi Michal

Having a build time check is a good idea. However, i don't see it in
the code. Please could you point it out.
> 
> Once the string set is available, make it also accessible via ioctl.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> ---
>  include/linux/ethtool.h      |  4 ++
>  include/uapi/linux/ethtool.h |  2 +
>  net/ethtool/common.c         | 86 ++++++++++++++++++++++++++++++++++++
>  net/ethtool/common.h         |  2 +
>  net/ethtool/ioctl.c          |  5 +++
>  5 files changed, 99 insertions(+)
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 95991e4300bf..5caef65d93d6 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -102,6 +102,10 @@ static inline u32 ethtool_rxfh_indir_default(u32 index, u32 n_rx_rings)
>  #define __ETHTOOL_DECLARE_LINK_MODE_MASK(name)		\
>  	DECLARE_BITMAP(name, __ETHTOOL_LINK_MODE_MASK_NBITS)
>  
> +/* compose link mode index from speed, type and duplex */
> +#define ETHTOOL_LINK_MODE(speed, type, duplex) \
> +	ETHTOOL_LINK_MODE_ ## speed ## base ## type ## _ ## duplex ## _BIT
> +
>  /* drivers must ignore base.cmd and base.link_mode_masks_nwords
>   * fields, but they are allowed to overwrite them (will be ignored).
>   */
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index d4591792f0b4..f44155840b07 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -593,6 +593,7 @@ struct ethtool_pauseparam {
>   * @ETH_SS_RSS_HASH_FUNCS: RSS hush function names
>   * @ETH_SS_PHY_STATS: Statistic names, for use with %ETHTOOL_GPHYSTATS
>   * @ETH_SS_PHY_TUNABLES: PHY tunable names
> + * @ETH_SS_LINK_MODES: link mode names
>   */
>  enum ethtool_stringset {
>  	ETH_SS_TEST		= 0,
> @@ -604,6 +605,7 @@ enum ethtool_stringset {
>  	ETH_SS_TUNABLES,
>  	ETH_SS_PHY_STATS,
>  	ETH_SS_PHY_TUNABLES,
> +	ETH_SS_LINK_MODES,
>  };
>  
>  /**
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 220d6b539180..be1b26970eb1 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -83,3 +83,89 @@ phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
>  	[ETHTOOL_PHY_FAST_LINK_DOWN] = "phy-fast-link-down",
>  	[ETHTOOL_PHY_EDPD]	= "phy-energy-detect-power-down",
>  };
> +
> +#define __LINK_MODE_NAME(speed, type, duplex) \
> +	#speed "base" #type "/" #duplex
> +#define __DEFINE_LINK_MODE_NAME(speed, type, duplex) \
> +	[ETHTOOL_LINK_MODE(speed, type, duplex)] = \
> +	__LINK_MODE_NAME(speed, type, duplex)
> +#define __DEFINE_SPECIAL_MODE_NAME(_mode, _name) \
> +	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] = _name
> +
> +const char
> +link_mode_names[__ETHTOOL_LINK_MODE_MASK_NBITS][ETH_GSTRING_LEN] = {
> +	__DEFINE_LINK_MODE_NAME(10, T, Half),
> +	__DEFINE_LINK_MODE_NAME(10, T, Full),
> +	__DEFINE_LINK_MODE_NAME(100, T, Half),
> +	__DEFINE_LINK_MODE_NAME(100, T, Full),
> +	__DEFINE_LINK_MODE_NAME(1000, T, Half),
> +	__DEFINE_LINK_MODE_NAME(1000, T, Full),
> +	__DEFINE_SPECIAL_MODE_NAME(Autoneg, "Autoneg"),
> +	__DEFINE_SPECIAL_MODE_NAME(TP, "TP"),
> +	__DEFINE_SPECIAL_MODE_NAME(AUI, "AUI"),
> +	__DEFINE_SPECIAL_MODE_NAME(MII, "MII"),
> +	__DEFINE_SPECIAL_MODE_NAME(FIBRE, "FIBRE"),
> +	__DEFINE_SPECIAL_MODE_NAME(BNC, "BNC"),
> +	__DEFINE_LINK_MODE_NAME(10000, T, Full),
> +	__DEFINE_SPECIAL_MODE_NAME(Pause, "Pause"),
> +	__DEFINE_SPECIAL_MODE_NAME(Asym_Pause, "Asym_Pause"),
> +	__DEFINE_LINK_MODE_NAME(2500, X, Full),
> +	__DEFINE_SPECIAL_MODE_NAME(Backplane, "Backplane"),
> +	__DEFINE_LINK_MODE_NAME(1000, KX, Full),
> +	__DEFINE_LINK_MODE_NAME(10000, KX4, Full),
> +	__DEFINE_LINK_MODE_NAME(10000, KR, Full),
> +	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] = "10000baseR_FEC",

Would

__DEFINE_SPECIAL_MODE_NAME(10000baseR_FEC, 10000baseR_FEC),

work here?

     Andrew
