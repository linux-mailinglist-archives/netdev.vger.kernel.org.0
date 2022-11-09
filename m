Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D046231F3
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiKISAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiKIR6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 12:58:23 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52E01F9CF
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 09:57:06 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2A9HuOgF707737;
        Wed, 9 Nov 2022 18:56:24 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2A9HuOgF707737
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1668016584;
        bh=brbVNNAKGbwDYeBxzCzZ2ecggd0EUWclTQ7o3cUqWzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fONWYb+2BaSPPZz3XH8xkJA4qwLxYTBVO0aj79vHNKdSqANEoKnHN7qOpYNBo6vot
         tFld2a9L7ufSpfpUEInlWOvytJqYcIeFjCcEAchrOJfV5YXo8WMkeb+yNlAE8Ho43u
         yN58aaVsBLtY7MLjQP9Xd9jlVwB2poo/p6fvnF2M=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2A9HuOtg707736;
        Wed, 9 Nov 2022 18:56:24 +0100
Date:   Wed, 9 Nov 2022 18:56:24 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mqaio@linux.alibaba.com,
        shaozhengchao@huawei.com, christophe.jaillet@wanadoo.fr,
        gustavoars@kernel.org, luobin9@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: hinic: Fix error handling in hinic_module_init()
Message-ID: <Y2vpyGB+iivl0L+K@electric-eye.fr.zoreil.com>
References: <20221109112315.125135-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109112315.125135-1-yuancan@huawei.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yuan Can <yuancan@huawei.com> :
[...]
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> index e1f54a2f28b2..b2fcd83d58fa 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> @@ -1474,8 +1474,17 @@ static struct pci_driver hinic_driver = {
>  
>  static int __init hinic_module_init(void)
>  {
> +	int ret;
> +
>  	hinic_dbg_register_debugfs(HINIC_DRV_NAME);
> -	return pci_register_driver(&hinic_driver);
> +
> +	ret = pci_register_driver(&hinic_driver);
> +	if (ret) {
> +		hinic_dbg_unregister_debugfs();
> +		return ret;
> +	}
> +
> +	return 0;
>  }

You can remove some fat:

	ret = pci_register_driver(&hinic_driver);
	if (ret)
		hinic_dbg_unregister_debugfs();

	return ret;

-- 
Ueimor
