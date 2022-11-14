Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5E162843C
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbiKNPkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbiKNPkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:40:31 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2D2F26
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 07:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668440430; x=1699976430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FI/AEQFSDzEBU/ME5JDUg5H5Y/geHBhuTgQkJ63HkcA=;
  b=H4ehAKDSpNYbo5o2lyMi/xV7bevYvdpYSl5BeOJ5LGYVHtunL9pEfmp7
   vVXE7ctsfaqVjy1upxWPOrDyX+6jKTduOxGx9iwFxkFQzmp2PsOuP78Ab
   Kak4Id6tVC1IzFwqaMESEbHgsW7jZgvkTqxxUoWKsiZkXUhTlrREOnYdk
   mqDjaaIcl+675xlUB9kzyz1dwsnIE0UNgxL8E0vLVntvjUrGHDDuVh+ii
   g89k8Dd7kOkeEiZU8HemoPAehZwt0e0BgYYhhXBZ2heLREKcELlzEZ4vd
   GQv80PJEX8ezIh3cf3zR6tEjFVwDfcnOsVaDiTmEA93Egx7v02l7egIR9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="312005350"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="312005350"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 07:40:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="813300518"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="813300518"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 14 Nov 2022 07:39:59 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AEFdvmu030339;
        Mon, 14 Nov 2022 15:39:58 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 2/5] net: txgbe: Initialize service task
Date:   Mon, 14 Nov 2022 16:39:55 +0100
Message-Id: <20221114153955.703649-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108111907.48599-3-mengyuanlou@net-swift.com>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com> <20221108111907.48599-3-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mengyuan Lou <mengyuanlou@net-swift.com>
Date: Tue,  8 Nov 2022 19:19:04 +0800

> From: Jiawen Wu <jiawenwu@trustnetic.com>
> 
> Setup work queue, and initialize service task to process the following
> tasks.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---

[...]

> @@ -468,6 +524,7 @@ static int txgbe_probe(struct pci_dev *pdev,
>  	}
>  
>  	netdev->netdev_ops = &txgbe_netdev_ops;
> +	netdev->watchdog_timeo = 5 * HZ;

Default value is 5 sec already[0], why...

>  
>  	/* setup the private structure */
>  	err = txgbe_sw_init(adapter);
> @@ -518,6 +575,11 @@ static int txgbe_probe(struct pci_dev *pdev,
>  	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
>  	txgbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);

[...]

> +static int __init txgbe_init_module(void)
> +{
> +	int ret;
> +
> +	txgbe_wq = create_singlethread_workqueue(txgbe_driver_name);
> +	if (!txgbe_wq) {
> +		pr_err("%s: Failed to create workqueue\n", txgbe_driver_name);
> +		return -ENOMEM;
> +	}
> +
> +	ret = pci_register_driver(&txgbe_driver);
> +	return ret;
> +}
> +
> +module_init(txgbe_init_module);

I think no empty lines in between the function and module/initcall
init/exit declaration is preferred.

> +
> +/**
> + * txgbe_exit_module - Driver Exit Cleanup Routine
> + *
> + * txgbe_exit_module is called just before the driver is removed
> + * from memory.
> + **/
> +static void __exit txgbe_exit_module(void)
> +{
> +	pci_unregister_driver(&txgbe_driver);
> +	destroy_workqueue(txgbe_wq);
> +}
> +
> +module_exit(txgbe_exit_module);

^

>  
>  MODULE_DEVICE_TABLE(pci, txgbe_pci_tbl);
>  MODULE_AUTHOR("Beijing WangXun Technology Co., Ltd, <software@trustnetic.com>");
> -- 
> 2.38.1

[0] https://elixir.bootlin.com/linux/v6.1-rc5/source/net/sched/sch_generic.c#L547

Thanks,
Olek
