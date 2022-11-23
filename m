Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C811636562
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238790AbiKWQHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238796AbiKWQHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:07:35 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA1FE8D
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 08:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669219652; x=1700755652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fQM35OTEAIiCS50ddnwzJMep7eV4oVjmAscYHWaAsUA=;
  b=iIvE4h857K2vUTN1S5Ie7V8ScOB+eZX/4BCvdpKnm7AhfjKURmae8s9q
   nk7BSbWvMcRmm4A++KGsqz4UayHJPaqtJczQWyyjy/Z3/M1fzejGzZIoN
   fklT9iY8dfVAIyvP5Jmt1mJ5llBDl0irRXLuBC7aDtTUii6t+OaKv1gSy
   Jp5SxSuWXZX+Q2J6SEkwYAV1w5rx0UNUa0v34eGP2PW0hlPXZhUJnLs7/
   +FEp5kLV5iK2btUYEoCj5HspfjJpbZlAY+Cknku9AZXuUoHZM0s7S3gHx
   WGHA1mRdgY1qNtKKU2rHcF0b85TZ3qrOHyTfzdgyxVrXhh7o+N/ZfHkXV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297459379"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="297459379"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 08:07:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="705410681"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="705410681"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 23 Nov 2022 08:07:28 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANG7RWO003894;
        Wed, 23 Nov 2022 16:07:27 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2] net/ethtool/ioctl: ensure that we have phy ops before using them
Date:   Wed, 23 Nov 2022 17:06:42 +0100
Message-Id: <20221123160642.484567-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122072143.53841-1-d-tatianin@yandex-team.ru>
References: <20221122072143.53841-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniil Tatianin <d-tatianin@yandex-team.ru>
Date: Tue, 22 Nov 2022 10:21:43 +0300

> ops->get_ethtool_phy_stats was getting called in an else branch
> of ethtool_get_phy_stats() unconditionally without making sure
> it was actually present.
> 
> Refactor the checks to avoid unnecessary nesting and make them more
> readable. Add an extra WARN_ON_ONCE(1) to emit a warning when a driver
> declares that it has phy stats without a way to retrieve them.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> ---
>  net/ethtool/ioctl.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 57e7238a4136..04f9ba98b038 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -2100,23 +2100,28 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
>  
>  	stats.n_stats = n_stats;
>  
> -	if (n_stats) {
> -		data = vzalloc(array_size(n_stats, sizeof(u64)));
> -		if (!data)
> -			return -ENOMEM;
> +	if (!n_stats) {
> +		data = NULL;
> +		goto copy_back;
> +	}
>  
> -		if (phydev && !ops->get_ethtool_phy_stats &&
> -		    phy_ops && phy_ops->get_stats) {
> -			ret = phy_ops->get_stats(phydev, &stats, data);
> -			if (ret < 0)
> -				goto out;
> -		} else {
> -			ops->get_ethtool_phy_stats(dev, &stats, data);
> -		}
> +	data = vzalloc(array_size(n_stats, sizeof(u64)));
> +	if (!data)
> +		return -ENOMEM;
> +
> +	if (ops->get_ethtool_phy_stats) {
> +		ops->get_ethtool_phy_stats(dev, &stats, data);

I'd first check for the callback and only after allocate the array,
otherwise there's no optimization in here.
Also, I'd separate saving 1 level of indent from the functional
changes.

> +	} else if (phydev && phy_ops && phy_ops->get_stats) {
> +		ret = phy_ops->get_stats(phydev, &stats, data);
> +		if (ret < 0)
> +			goto out;
>  	} else {
> -		data = NULL;
> +		WARN_ON_ONCE(1);
> +		n_stats = 0;
> +		stats.n_stats = 0;
>  	}
>  
> +copy_back:
>  	ret = -EFAULT;
>  	if (copy_to_user(useraddr, &stats, sizeof(stats)))
>  		goto out;
> -- 
> 2.25.1

Thanks,
Olek
