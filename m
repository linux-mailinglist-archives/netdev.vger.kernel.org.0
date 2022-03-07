Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DC84CEFAB
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbiCGCht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiCGChs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:37:48 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F405D5D5;
        Sun,  6 Mar 2022 18:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=fT3YTuEIdpCMq0kN8uaMgMNEB2+kXkR2yntZ+jQXnn8=; b=YqCZgEz9oXcQ06cO7z+n8rshI7
        SK4WzItYDSh7dlk+7PG14iCDosOOJ8jlpBru9WUm4g1tWXbf3tW1jFfwOncaS1BEqgSl9Gm4zAQ9n
        8xquov2wEtlzbByLSstXWa6c+/Rv36SkHgnAEAuSymwkUpBvXgrdPVKX5tU/a/tsAzfi8EASwo9zQ
        fgFiSEA1vbhuD7pX+4KfkTAvJwIXiu11YPPE4TbUd+IYkHLsm0pf4nUnNHp8lVxbJiAGFgjhimegD
        DY45RCQRpgP99EZ8FRe1RrpbuVvVrb/JPzQ1pTzqW4v8HNyBRxeWsd7REbi7b+/bxK5DGrmaKAA0D
        4lE0msPw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nR3Eo-00G3k8-Gl; Mon, 07 Mar 2022 02:36:43 +0000
Message-ID: <f0aec757-185b-8c78-8c39-dacb3520ce74@infradead.org>
Date:   Sun, 6 Mar 2022 18:36:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v3] net/smc: fix compile warning for smc_sysctl
Content-Language: en-US
To:     Dust Li <dust.li@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20220307015424.59154-1-dust.li@linux.alibaba.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220307015424.59154-1-dust.li@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/6/22 17:54, Dust Li wrote:
> kernel test robot reports multiple warning for smc_sysctl:

when SYSCTL is not enabled
(AFAIK)

>   In file included from net/smc/smc_sysctl.c:17:
>>> net/smc/smc_sysctl.h:23:5: warning: no previous prototype \
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
> set, this make sure SMC autocorking is enabled by default if
> CONFIG_SYSCTL is not set.
> 
> Fixes: 462791bbfa35 ("net/smc: add sysctl interface for SMC")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> 
> ---
> v3: 1. add __net_{init|exit} annotation for smc_sysctl_net_{init|exit}
>        sugguested by Jakub Kicinski
>     2. Remove static inline for smc_sysctl_net_{init|exit} if
>        CONFIG_SYSCTL not defined
> v2: 1. Removes pernet_operations and smc_sysctl_{init|exit}
>     2. Initialize sysctl_autocorking_size if CONFIG_SYSCTL not set
> ---
>  net/smc/Makefile     |  3 ++-
>  net/smc/af_smc.c     | 15 ++++++---------
>  net/smc/smc_sysctl.c | 19 ++-----------------
>  net/smc/smc_sysctl.h |  9 +++++----
>  4 files changed, 15 insertions(+), 31 deletions(-)

Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

thanks.

-- 
~Randy
