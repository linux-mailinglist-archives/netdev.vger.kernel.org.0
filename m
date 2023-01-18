Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3272B671B9A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjARML3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjARMKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:10:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D7E4391E;
        Wed, 18 Jan 2023 03:30:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B429B81C38;
        Wed, 18 Jan 2023 11:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B4EC433F1;
        Wed, 18 Jan 2023 11:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674041403;
        bh=AHP0LcYttnqUZ4+wG/53i7rfpAMEuP+Lz9vHvX11KZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y49XCDlG2rX3zfzVwQuJaNH+ERr6vrX9uln5ggGfcFklApsCqIfvJ2supnp5M7PgK
         A90P2AyUGb2eEaFQWgfxvcE/ioa8pPWCCaqvxB1iWfiM3jn5XX2o7cB7WLIhReJVpQ
         8m0Ry/xMnW+iUkiytRh300QFwYO0N1wtrx827D1QNnrxijBgKSZw/3m1zP8gkWBKkl
         yLsgaR4mZsu8mUYuYlI+dqQEChc8vy93/Z5SwXXdOb7TUkOx/t8d1hBuMqVkYjCpGr
         ofwkTCG+DMIheoBmTw9gQgNl7JRhSZGw/0oZM/95xBNwQpxlpf9LIKtYQOhqaA+DzQ
         6uVNmlHX1YdJA==
Date:   Wed, 18 Jan 2023 13:29:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, rogerq@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vigneshr@ti.com, srk@ti.com
Subject: Re: [PATCH net-next v3 2/2] net: ethernet: ti: am65-cpsw/cpts: Fix
 CPTS release action
Message-ID: <Y8fYNTXpkRkoLmnM@unreal>
References: <20230118095439.114222-1-s-vadapalli@ti.com>
 <20230118095439.114222-3-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118095439.114222-3-s-vadapalli@ti.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 03:24:39PM +0530, Siddharth Vadapalli wrote:
> The am65_cpts_release() function is registered as a devm_action in the
> am65_cpts_create() function in am65-cpts driver. When the am65-cpsw driver
> invokes am65_cpts_create(), am65_cpts_release() is added in the set of devm
> actions associated with the am65-cpsw driver's device.
> 
> In the event of probe failure or probe deferral, the platform_drv_probe()
> function invokes dev_pm_domain_detach() which powers off the CPSW and the
> CPSW's CPTS hardware, both of which share the same power domain. Since the
> am65_cpts_disable() function invoked by the am65_cpts_release() function
> attempts to reset the CPTS hardware by writing to its registers, the CPTS
> hardware is assumed to be powered on at this point. However, the hardware
> is powered off before the devm actions are executed.
> 
> Fix this by getting rid of the devm action for am65_cpts_release() and
> invoking it directly on the cleanup and exit paths.
> 
> Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c |  2 ++
>  drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
>  drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
>  3 files changed, 12 insertions(+), 10 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
