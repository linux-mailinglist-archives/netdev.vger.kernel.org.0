Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A30E627A1B
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbiKNKLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235602AbiKNKJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:09:49 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE405222
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668420572; x=1699956572;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=axc3D3bZPFmnRLJO4FT0eRxK8fWtxr5ll8XU/X6j9oM=;
  b=mqFf8fZzHyEUCoeUYHP21j6UG+F2mhbUEOLZGjNkiYXYs8QhXRaEvsUe
   xG4o/av+pbH/8A08mjafN7oUm31/WD1n5TxcwUrEoLQLxtwQ+6xkXNAVb
   iltZrVSx2aa56mlkYpncNbYgioz6BX2XZ7s6O+bpEj9W7AEDiPdMrdw5R
   3yhOcHgHY072Z7M25FQR+WA6U+gobCiSNMxZ/G2BdYzWBkzjXDbhIMXgL
   IjiZN7TQDkvWOIYTMSX/C1AmWCMzCsO1qFg/eBk3gwPxMIFjuubwPzHIT
   eVQqwz9ffkvicrla1NLetpT8ol+s4+HiG7N0rWmJzg6VaEaigPyqr30FM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="299450233"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="299450233"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 02:09:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="744079009"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="744079009"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 14 Nov 2022 02:09:25 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id E1C4F32E; Mon, 14 Nov 2022 12:09:49 +0200 (EET)
Date:   Mon, 14 Nov 2022 12:09:49 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     michael.jamet@intel.com, YehezkelShB@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andriy.shevchenko@linux.intel.com,
        amir.jer.levy@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: thunderbolt: Fix error handling in tbnet_init()
Message-ID: <Y3IT7aiOOe2b3Qhy@black.fi.intel.com>
References: <20221114081936.35804-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114081936.35804-1-yuancan@huawei.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Nov 14, 2022 at 08:19:36AM +0000, Yuan Can wrote:
> A problem about insmod thunderbolt-net failed is triggered with following
> log given while lsmod does not show thunderbolt_net:
> 
>  insmod: ERROR: could not insert module thunderbolt-net.ko: File exists
> 
> The reason is that tbnet_init() returns tb_register_service_driver()
> directly without checking its return value, if tb_register_service_driver()
> failed, it returns without removing property directory, resulting the
> property directory can never be created later.
> 
>  tbnet_init()
>    tb_register_property_dir() # register property directory
>    tb_register_service_driver()
>      driver_register()
>        bus_add_driver()
>          priv = kzalloc(...) # OOM happened
>    # return without remove property directory
> 
> Fix by remove property directory when tb_register_service_driver() returns
> error.
> 
> Fixes: e69b6c02b4c3 ("net: Add support for networking over Thunderbolt cable")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/thunderbolt.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
> index 83fcaeb2ac5e..fe6a9881cc75 100644
> --- a/drivers/net/thunderbolt.c
> +++ b/drivers/net/thunderbolt.c
> @@ -1396,7 +1396,14 @@ static int __init tbnet_init(void)
>  		return ret;
>  	}
>  
> -	return tb_register_service_driver(&tbnet_driver);
> +	ret = tb_register_service_driver(&tbnet_driver);
> +	if (ret) {
> +		tb_unregister_property_dir("network", tbnet_dir);
> +		tb_property_free_dir(tbnet_dir);
> +		return ret;
> +	}
> +
> +	return 0;

Okay but I suggest that you make it like:

	ret = tb_register_property_dir("network", tbnet_dir);
	if (ret)
		goto err_free_dir;

	ret = tb_register_service_driver(&tbnet_driver);
	if (ret)
		goto err_unregister;

	return 0;

err_unregister:
	tb_unregister_property_dir("network", tbnet_dir);
err_free_dir:
	tb_property_free_dir(tbnet_dir);

	return ret;

}
