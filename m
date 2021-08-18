Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CEA3F0747
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbhHRPAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:00:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:7965 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238483AbhHRPAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 11:00:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="213215367"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="213215367"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 07:59:33 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="511225709"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 07:59:31 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mGN2L-00B8xL-L5; Wed, 18 Aug 2021 17:59:25 +0300
Date:   Wed, 18 Aug 2021 17:59:25 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        christophe.jaillet@wanadoo.fr, kaixuxia@tencent.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: mii: make mii_ethtool_gset() return void
Message-ID: <YR0gTWn4G0xkekxF@smile.fi.intel.com>
References: <7e8946ac52de91a963beb7fa0354a19a21c5cf73.1629296113.git.paskripkin@gmail.com>
 <94ec6d98ab2d9a937da8fba8d7b99805f72809aa.1629296113.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94ec6d98ab2d9a937da8fba8d7b99805f72809aa.1629296113.git.paskripkin@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 05:18:55PM +0300, Pavel Skripkin wrote:
> mii_ethtool_gset() does not return any errors. Since there is no users

there are

> of this function that rely on its return value, it can be
> made void.
> 
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Changes in v2:
> 	inverted the order of patches
> 
> ---
>  drivers/net/mii.c   | 5 +----
>  include/linux/mii.h | 2 +-
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/mii.c b/drivers/net/mii.c
> index 779c3a96dba7..3e7823267a3b 100644
> --- a/drivers/net/mii.c
> +++ b/drivers/net/mii.c
> @@ -50,9 +50,8 @@ static u32 mii_get_an(struct mii_if_info *mii, u16 addr)
>   * The @ecmd parameter is expected to have been cleared before calling
>   * mii_ethtool_gset().

>   *

This line should gone as well.

> - * Returns 0 for success, negative on error.
>   */
> -int mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd)
> +void mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd)
>  {
>  	struct net_device *dev = mii->dev;
>  	u16 bmcr, bmsr, ctrl1000 = 0, stat1000 = 0;
> @@ -131,8 +130,6 @@ int mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd)
>  	mii->full_duplex = ecmd->duplex;
>  
>  	/* ignore maxtxpkt, maxrxpkt for now */
> -
> -	return 0;
>  }
>  
>  /**
> diff --git a/include/linux/mii.h b/include/linux/mii.h
> index 219b93cad1dd..12ea29e04293 100644
> --- a/include/linux/mii.h
> +++ b/include/linux/mii.h
> @@ -32,7 +32,7 @@ struct mii_if_info {
>  
>  extern int mii_link_ok (struct mii_if_info *mii);
>  extern int mii_nway_restart (struct mii_if_info *mii);
> -extern int mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd);
> +extern void mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd);
>  extern void mii_ethtool_get_link_ksettings(
>  	struct mii_if_info *mii, struct ethtool_link_ksettings *cmd);
>  extern int mii_ethtool_sset(struct mii_if_info *mii, struct ethtool_cmd *ecmd);
> -- 
> 2.32.0
> 

-- 
With Best Regards,
Andy Shevchenko


