Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A375614817
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiKALA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiKALAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:00:23 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4BE18E01;
        Tue,  1 Nov 2022 04:00:21 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VThdbr7_1667300417;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VThdbr7_1667300417)
          by smtp.aliyun-inc.com;
          Tue, 01 Nov 2022 19:00:19 +0800
Date:   Tue, 1 Nov 2022 19:00:14 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, kgraul@linux.ibm.com, wenjia@linux.ibm.com,
        jaka@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, guvenc@linux.ibm.com
Subject: Re: [PATCH] net/smc: Fix possible leaked pernet namespace in
 smc_init()
Message-ID: <Y2D8PvHrKtpjTdJ1@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20221101093722.127223-1-chenzhongjin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101093722.127223-1-chenzhongjin@huawei.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 05:37:22PM +0800, Chen Zhongjin wrote:
> In smc_init(), register_pernet_subsys(&smc_net_stat_ops) is called
> without any error handling.
> If it fails, registering of &smc_net_ops won't be reverted.
> And if smc_nl_init() fails, &smc_net_stat_ops itself won't be reverted.
> 
> This leaves wild ops in subsystem linkedlist and when another module
> tries to call register_pernet_operations() it triggers page fault:
> 
> BUG: unable to handle page fault for address: fffffbfff81b964c
> RIP: 0010:register_pernet_operations+0x1b9/0x5f0
> Call Trace:
>   <TASK>
>   register_pernet_subsys+0x29/0x40
>   ebtables_init+0x58/0x1000 [ebtables]
>   ...
> 
> Fixes: 194730a9beb5 ("net/smc: Make SMC statistics network namespace aware")
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>

This patch looks good to me. 

The subject of this patch should be in net, the prefix tag is missed.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  net/smc/af_smc.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 3ccbf3c201cd..e12d4fa5aece 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -3380,14 +3380,14 @@ static int __init smc_init(void)
>  
>  	rc = register_pernet_subsys(&smc_net_stat_ops);
>  	if (rc)
> -		return rc;
> +		goto out_pernet_subsys;
>  
>  	smc_ism_init();
>  	smc_clc_init();
>  
>  	rc = smc_nl_init();
>  	if (rc)
> -		goto out_pernet_subsys;
> +		goto out_pernet_subsys_stat;
>  
>  	rc = smc_pnet_init();
>  	if (rc)
> @@ -3480,6 +3480,8 @@ static int __init smc_init(void)
>  	smc_pnet_exit();
>  out_nl:
>  	smc_nl_exit();
> +out_pernet_subsys_stat:
> +	unregister_pernet_subsys(&smc_net_stat_ops);
>  out_pernet_subsys:
>  	unregister_pernet_subsys(&smc_net_ops);
>  
> -- 
> 2.17.1
