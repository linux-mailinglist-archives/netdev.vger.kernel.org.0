Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BE64CE30F
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 06:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiCEFco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 00:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiCEFco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 00:32:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27922A27A;
        Fri,  4 Mar 2022 21:31:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAB4FB80B20;
        Sat,  5 Mar 2022 05:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200F3C004E1;
        Sat,  5 Mar 2022 05:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646458312;
        bh=n+KrOR0e9syfz6ibDE/Ey1MXq0W3+mErBIN4+fGFpyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HaSmKT+S7JHcYT/HEH6sOwVsPAewidB6nzGuukB7CS3EXvIuwb8OvHq+cruvq6kPX
         RMSqZeeXo7gnt3mmQCXcral/1u8+7ZbEI938Qp8VDSciu69RlAic5blVnPO1G47nnW
         iwMEe88CWd6ZIcuDSsjSha2LCW5Xwc9WIRGDJDl/LoNKwsk6texZNl/fqgbBwsDaiM
         xsefLwXCbECZdsVnSFD8SGFSD9JGdre5WdwM4aRkFik3YJcYhbvt5Hk3lZrR9ojt4C
         nrAVULkJWgDHAffWy6ofzKDlmesrdUw5euMfjvSqrDRL6dHJlwb0jpGlm7x8HEX8Kp
         +zHyZirFy3htw==
Date:   Fri, 4 Mar 2022 21:31:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: fix compile warning for smc_sysctl
Message-ID: <20220304213151.04ecbe8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220303084006.54313-1-dust.li@linux.alibaba.com>
References: <20220303084006.54313-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Mar 2022 16:40:06 +0800 Dust Li wrote:
> kernel test robot reports multiple warning for smc_sysctl:
> 
>   In file included from net/smc/smc_sysctl.c:17:
> >> net/smc/smc_sysctl.h:23:5: warning: no previous prototype \  
> 	for function 'smc_sysctl_init' [-Wmissing-prototypes]
>   int smc_sysctl_init(void)
>        ^
> and
>   >> WARNING: modpost: vmlinux.o(.text+0x12ced2d): Section mismatch \  
>   in reference from the function smc_sysctl_exit() to the variable
>   .init.data:smc_sysctl_ops
>   The function smc_sysctl_exit() references
>   the variable __initdata smc_sysctl_ops.
>   This is often because smc_sysctl_exit lacks a __initdata
>   annotation or the annotation of smc_sysctl_ops is wrong.
> 
> and
>   net/smc/smc_sysctl.c: In function 'smc_sysctl_init_net':
>   net/smc/smc_sysctl.c:47:17: error: 'struct netns_smc' has no member named 'smc_hdr'
>      47 |         net->smc.smc_hdr = register_net_sysctl(net, "net/smc", table);
> 
> Since we don't need global sysctl initialization. To make things
> clean and simple, remove the global pernet_operations and
> smc_sysctl_{init|exit}. Call smc_sysctl_net_{init|exit} directly
> from smc_net_{init|exit}.
> 
> Also initialized sysctl_autocorking_size if CONFIG_SYSCTL it not
> set, this makes sure SMC autocorking is enabled by default if
> CONFIG_SYSCTL is not set.

I think that makes sense, one nit below.

> -static __net_init int smc_sysctl_init_net(struct net *net)
> +int smc_sysctl_net_init(struct net *net)
>  {
>  	struct ctl_table *table;
>  
> @@ -59,22 +59,7 @@ static __net_init int smc_sysctl_init_net(struct net *net)
>  	return -ENOMEM;
>  }
>  
> -static __net_exit void smc_sysctl_exit_net(struct net *net)
> +void smc_sysctl_net_exit(struct net *net)
>  {
>  	unregister_net_sysctl_table(net->smc.smc_hdr);
>  }

> +int smc_sysctl_net_init(struct net *net);
> +void smc_sysctl_net_exit(struct net *net);

I believe these functions can become / remain __net_init and __net_exit,
since all the callers are also marked as such.

>  #else
>  
> -int smc_sysctl_init(void)
> +static inline int smc_sysctl_net_init(struct net *net)
>  {
> +	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
>  	return 0;
>  }
>  
> -void smc_sysctl_exit(void) { }
> +static inline void smc_sysctl_net_exit(struct net *net) { }

Doesn't matter for static inlines.

>  #endif /* CONFIG_SYSCTL */
>  

