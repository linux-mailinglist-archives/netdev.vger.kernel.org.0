Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A465419ED
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 23:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378290AbiFGV1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 17:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379397AbiFGVZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 17:25:33 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B62228713;
        Tue,  7 Jun 2022 12:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1654628511; x=1686164511;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=pniHEHRrB59YTtTNBTHlm1oMkttAh1nN6oBL1H5yKWM=;
  b=ANVUJX2nD5MBjE4xE8mXlELzhYCcWe/+Jjk6Fn2gQX00oNSvIIJlolKa
   tVCbgKKGTkwO9bX1MTdvsYvgG2skpgojt3B9HwlKWco+VxO9zz7BSj3DT
   rBt20It5InNCsLFmj91Vo9HOkGE5fVr0veBOhmgCifeK6q6FGRdyKjOsL
   4=;
X-IronPort-AV: E=Sophos;i="5.91,284,1647302400"; 
   d="scan'208";a="200518085"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 07 Jun 2022 19:01:36 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id 9C7E4A2532;
        Tue,  7 Jun 2022 19:01:33 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.160.26) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 7 Jun 2022 19:01:27 +0000
References: <20220607122831.32738-1-xiaohuizhang@ruc.edu.cn>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sameeh Jubran <sameehj@amazon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] net: ena_netdev: fix resource leak
Date:   Tue, 7 Jun 2022 21:57:43 +0300
In-Reply-To: <20220607122831.32738-1-xiaohuizhang@ruc.edu.cn>
Message-ID: <pj41zly1y8pabi.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D32UWB003.ant.amazon.com (10.43.161.220) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
X-Spam-Status: No, score=-13.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Xiaohui Zhang <xiaohuizhang@ruc.edu.cn> writes:

> Similar to the handling of u132_hcd_init in commit f276e002793c
> ("usb: u132-hcd: fix resource leak"), we thought a patch might 
> be
> needed here as well.
>
> If platform_driver_register fails, cleanup the allocated 
> resource
> gracefully.
>
> Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 6a356a6cee15..c0624ee8d867 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -4545,13 +4545,17 @@ static struct pci_driver ena_pci_driver 
> = {
>  
>  static int __init ena_init(void)
>  {
> +	int retval;
>  	ena_wq = create_singlethread_workqueue(DRV_MODULE_NAME);
>  	if (!ena_wq) {
>  		pr_err("Failed to create workqueue\n");
>  		return -ENOMEM;
>  	}
> +	retval = pci_register_driver(&ena_pci_driver);
> +	if (retval)
> +		destroy_workqueue(ena_wq);
>  
> -	return pci_register_driver(&ena_pci_driver);
> +	return retval;
>  }
>  
>  static void __exit ena_cleanup(void)

Hi,
thanks a lot for this patch. I made a few small changes in it to 
make it more consistent with the rest of driver's code
(sorry don't really know how to insert an inline diff)

thanks,
Shay

---
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 6a356a6cee15..be8d3c26c9bb 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4545,13 +4545,19 @@ static struct pci_driver ena_pci_driver = 
{
 
 static int __init ena_init(void)
 {
+	int rc;
+
 	ena_wq = create_singlethread_workqueue(DRV_MODULE_NAME);
 	if (!ena_wq) {
 		pr_err("Failed to create workqueue\n");
 		return -ENOMEM;
 	}
 
-	return pci_register_driver(&ena_pci_driver);
+	rc = pci_register_driver(&ena_pci_driver);
+	if (rc)
+		destroy_workqueue(ena_wq);
+
+	return rc;
 }
 
 static void __exit ena_cleanup(void)


