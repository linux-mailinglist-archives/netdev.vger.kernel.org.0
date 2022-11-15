Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969496297B9
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiKOLt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiKOLtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:49:21 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A766DDF46
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668512960; x=1700048960;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=wk2wXgUd+reX1zXuNQjF13aPuxZ3nMozIjKSkRGXt0o=;
  b=HBfgpe2ZH3uIgm032apELbdOIDV/ukp24mqFheyKzwWCfUWANVQHHB6g
   6PjKxtFcUL3jAgb3sEmk4bdjRIMtmZnvNpD0LFEqrBg1uO4Kr+UPrVk0p
   oryNU+0V27RpK2F9P7WRE9hHsxHc7wZFBhnOETxJFR4Vt1xuEITU/5B8u
   4=;
X-IronPort-AV: E=Sophos;i="5.96,165,1665446400"; 
   d="scan'208";a="266733617"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 11:49:17 +0000
Received: from EX13D26EUB004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com (Postfix) with ESMTPS id 1DF4382310;
        Tue, 15 Nov 2022 11:49:14 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX13D26EUB004.ant.amazon.com (10.43.166.137) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 15 Nov 2022 11:49:13 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.162.178) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.20; Tue, 15 Nov 2022 11:49:08 +0000
References: <20221114025659.124726-1-yuancan@huawei.com>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Yuan Can <yuancan@huawei.com>
CC:     <akiyano@amazon.com>, <darinzon@amazon.com>, <ndagan@amazon.com>,
        <saeedb@amazon.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <nkoler@amazon.com>,
        <wsa+renesas@sang-engineering.com>, <netanel@annapurnalabs.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: ena: Fix error handling in ena_init()
Date:   Tue, 15 Nov 2022 13:47:58 +0200
In-Reply-To: <20221114025659.124726-1-yuancan@huawei.com>
Message-ID: <pj41zlzgcs780g.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D47UWC002.ant.amazon.com (10.43.162.83) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Yuan Can <yuancan@huawei.com> writes:

> The ena_init() won't destroy workqueue created by
> create_singlethread_workqueue() when pci_register_driver() 
> failed.
> Call destroy_workqueue() when pci_register_driver() failed to 
> prevent the
> resource leak.
>
> Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic 
> Network Adapters (ENA)")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index d350eeec8bad..5a454b58498f 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -4543,13 +4543,19 @@ static struct pci_driver ena_pci_driver 
> = {
>  
>  static int __init ena_init(void)
>  {
> +	int ret;
> +
>  	ena_wq = create_singlethread_workqueue(DRV_MODULE_NAME);
>  	if (!ena_wq) {
>  		pr_err("Failed to create workqueue\n");
>  		return -ENOMEM;
>  	}
>  
> -	return pci_register_driver(&ena_pci_driver);
> +	ret = pci_register_driver(&ena_pci_driver);
> +	if (ret)
> +		destroy_workqueue(ena_wq);
> +
> +	return ret;
>  }
>  
>  static void __exit ena_cleanup(void)

Lgtm. Thanks for this fix.
Acked-by: Shay Agroskin <shayagr@amazon.com>
