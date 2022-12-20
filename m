Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57061652192
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiLTNcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLTNcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:32:54 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D745A1BE;
        Tue, 20 Dec 2022 05:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671543173; x=1703079173;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NoDHutZfIDRsf0ub0AOWtZ9DL1dRnfTbWJbUb3LNtiE=;
  b=EBqswi5XBW/bRJ/cGj2HhjTFVRW2BM54GOCAOsSuF6434HKynOJ02jR9
   bvjPe7JSNDNTIzH4M6F0M+m/GtTGlWkJT386jUmdXlux2Yg3lSnH0UkBh
   UHHHzWBb/h2dWeJrp9iZaQebcx7qh3h4bMf60ALqWaNnBhdPEuuQjbtOO
   e+6/avtlH7DOrZ/+Lf5iCGy51DeW9aWP2BQGXZAuvtdUuRu094Ag9ZyIF
   3tlrih0qlALD7X5+u2KoHtcjRYVBAHdWfrtzIIOP5py3rBX4iShCMhFMr
   uKcwX0ydTTRESs4wFeiLxM+6BuY8miXgFf8x7AdR0CekEzwQPLdmG1vSI
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="321515420"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="321515420"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 05:32:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644426367"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="644426367"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 05:32:49 -0800
Date:   Tue, 20 Dec 2022 14:32:41 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] qlcnic: prevent ->dcb use-after-free on
 qlcnic_dcb_enable() failure
Message-ID: <Y6G5eWWucdaJXmQu@localhost.localdomain>
References: <20221220125649.1637829-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220125649.1637829-1-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 03:56:49PM +0300, Daniil Tatianin wrote:
> adapter->dcb would get silently freed inside qlcnic_dcb_enable() in
> case qlcnic_dcb_attach() would return an error, which always happens
> under OOM conditions. This would lead to use-after-free because both
> of the existing callers invoke qlcnic_dcb_get_info() on the obtained
> pointer, which is potentially freed at that point.
> 
> Propagate errors from qlcnic_dcb_enable(), and instead free the dcb
> pointer at callsite.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>

Please add Fix tag and net as target (net-next is close till the end of
this year)

> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 9 ++++++++-
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h       | 5 ++---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      | 9 ++++++++-
>  3 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> index dbb800769cb6..465f149d94d4 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> @@ -2505,7 +2505,14 @@ int qlcnic_83xx_init(struct qlcnic_adapter *adapter)
>  		goto disable_mbx_intr;
>  
>  	qlcnic_83xx_clear_function_resources(adapter);
> -	qlcnic_dcb_enable(adapter->dcb);
> +
> +	err = qlcnic_dcb_enable(adapter->dcb);
> +	if (err) {
> +		qlcnic_clear_dcb_ops(adapter->dcb);
> +		adapter->dcb = NULL;
> +		goto disable_mbx_intr;
> +	}

Maybe I miss sth but it looks like there can be memory leak.
For example if error in attach happen after allocating of dcb->cfg.
Isn't it better to call qlcnic_dcb_free instead of qlcnic_clear_dcb_ops?

> +
>  	qlcnic_83xx_initialize_nic(adapter, 1);
>  	qlcnic_dcb_get_info(adapter->dcb);
>  
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
> index 7519773eaca6..e1460f9c38bf 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
> @@ -112,9 +112,8 @@ static inline void qlcnic_dcb_init_dcbnl_ops(struct qlcnic_dcb *dcb)
>  		dcb->ops->init_dcbnl_ops(dcb);
>  }
>  
> -static inline void qlcnic_dcb_enable(struct qlcnic_dcb *dcb)
> +static inline int qlcnic_dcb_enable(struct qlcnic_dcb *dcb)
>  {
> -	if (dcb && qlcnic_dcb_attach(dcb))
> -		qlcnic_clear_dcb_ops(dcb);
> +	return dcb ? qlcnic_dcb_attach(dcb) : 0;
>  }
>  #endif
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> index 28476b982bab..36ba15fc9776 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> @@ -2599,7 +2599,14 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  			 "Device does not support MSI interrupts\n");
>  
>  	if (qlcnic_82xx_check(adapter)) {
> -		qlcnic_dcb_enable(adapter->dcb);
> +		err = qlcnic_dcb_enable(adapter->dcb);
> +		if (err) {
> +			qlcnic_clear_dcb_ops(adapter->dcb);
> +			adapter->dcb = NULL;
> +			dev_err(&pdev->dev, "Failed to enable DCB\n");
> +			goto err_out_free_hw;
> +		}
> +
>  		qlcnic_dcb_get_info(adapter->dcb);
>  		err = qlcnic_setup_intr(adapter);
>  
> -- 
> 2.25.1
> 
