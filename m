Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CF96282DA
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 15:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbiKNOjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 09:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237035AbiKNOjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 09:39:14 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D355420987
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 06:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668436746; x=1699972746;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zB1hTUwgSXLIWjuTk8oe7pnul1/iQ6fIM8QyKbR8qyc=;
  b=DdVkAPLWeBXIoMqsLnQVRKf4EGbCmBvSYaYOwPnJ+ASJQkeJlRf7J6U5
   ldOyddx0pdlZPOaUqMJteqIBj3vBfHR9vuiyw5mUV0judIezsgFe3gsyN
   DOKrlg5JiZWAcslJP/21vZzEuNhQj1HC8YJ7esuO/gBvVf8gjkqPfwib7
   /eBF6g37YwFmkl+2EFp7CHBqpI8/KOLX3fBkwhrV9AEofTKS6pCbhmx+Y
   lyyTnwdvdxMJ8JM/IbBVZuitxpY6DaufuIG7GZk+jiz+f97eyijOPPcTG
   nA2AU2KNje4XZZV9ojwUzRz9RxWPkHu+fcwk/a7azUCuV7bNMmXVE2yBC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="398271852"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="398271852"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 06:39:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="727545539"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="727545539"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Nov 2022 06:39:03 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id CE31732E; Mon, 14 Nov 2022 16:39:27 +0200 (EET)
Date:   Mon, 14 Nov 2022 16:39:27 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     michael.jamet@intel.com, YehezkelShB@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andriy.shevchenko@linux.intel.com,
        amir.jer.levy@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: thunderbolt: Fix error handling in tbnet_init()
Message-ID: <Y3JTH8cuZVt5zJkj@black.fi.intel.com>
References: <20221114142225.74124-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114142225.74124-1-yuancan@huawei.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 02:22:25PM +0000, Yuan Can wrote:
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

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
