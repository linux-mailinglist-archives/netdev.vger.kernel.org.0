Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E827C674C18
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjATFXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjATFXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:23:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A85C518E1;
        Thu, 19 Jan 2023 21:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4924CB821CF;
        Thu, 19 Jan 2023 10:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52847C433D2;
        Thu, 19 Jan 2023 10:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674124051;
        bh=4UpahVsIChSSGcPJAw5CzomIyJAr7tVRZVCLTnoEETs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MPc1ipVoU9GPG3AcMlVCzrcTcc2acm276LL0pZeuiCnQn2saW1j83SVjGoXHCM/lK
         BeuCJ2Ar5AY2FGmWR4pMhQDKvPycwHAOd9cIHXnascJY/ZQF5FoVxTp/Zv6pjsd0pX
         4yYcFoFmQvwFVFGSj9ySR7vvbesXSXBMkNxWuZP8ej70zkJ0oEpHwn1iNiBBoUFxUQ
         8d6X06efp2qv0HwvkO3+wsWg60EyMDvnYpVkuuN0oarO8MhN9kwmIlsPhWurkZIpzG
         hUPAFwZBkk4szSb8Hv8+JuIz85yWuUaKmx5PkLJYoOUkGqP0HUd8R/YjvPrWzcebAO
         c9umiJqIeufiA==
Message-ID: <1739f5ba-6d73-cd2c-d088-39428fdb55a7@kernel.org>
Date:   Thu, 19 Jan 2023 12:27:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v3 0/2] Fix CPTS release action in am65-cpts
 driver
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux@armlinux.org.uk,
        pabeni@redhat.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vigneshr@ti.com, srk@ti.com
References: <20230118095439.114222-1-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230118095439.114222-1-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/01/2023 11:54, Siddharth Vadapalli wrote:
> Delete unreachable code in am65_cpsw_init_cpts() function, which was
> Reported-by: Leon Romanovsky <leon@kernel.org>
> at:
> https://lore.kernel.org/r/Y8aHwSnVK9+sAb24@unreal
> 
> Remove the devm action associated with am65_cpts_release() and invoke the
> function directly on the cleanup and exit paths.
> 
> Changes from v2:
> 1. Drop Reviewed-by tag from Roger Quadros.
> 2. Add cleanup patch for deleting unreachable error handling code in
>    am65_cpsw_init_cpts().
> 3. Drop am65_cpsw_cpts_cleanup() function and directly invoke
>    am65_cpts_release().
> 
> Changes from v1:
> 1. Fix the build issue when "CONFIG_TI_K3_AM65_CPTS" is not set. This
>    error was reported by kernel test robot <lkp@intel.com> at:
>    https://lore.kernel.org/r/202301142105.lt733Lt3-lkp@intel.com/
> 2. Collect Reviewed-by tag from Roger Quadros.
> 
> v2:
> https://lore.kernel.org/r/20230116044517.310461-1-s-vadapalli@ti.com/
> v1:
> https://lore.kernel.org/r/20230113104816.132815-1-s-vadapalli@ti.com/
> 
> Siddharth Vadapalli (2):
>   net: ethernet: ti: am65-cpsw: Delete unreachable error handling code
>   net: ethernet: ti: am65-cpsw/cpts: Fix CPTS release action
> 
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c |  7 ++-----
>  drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
>  drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
>  3 files changed, 12 insertions(+), 15 deletions(-)
> 

Reviewed-by: Roger Quadros <rogerq@kernel.org>
