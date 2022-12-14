Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E2364C437
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 08:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237507AbiLNHHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 02:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237317AbiLNHH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 02:07:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FED8BE3;
        Tue, 13 Dec 2022 23:07:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2F4DB816AF;
        Wed, 14 Dec 2022 07:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B6EC433AC;
        Wed, 14 Dec 2022 07:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671001640;
        bh=2EspeQucKNOEhN1s7DW737BdyxnDy/6W3lznMW2ULfc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C/f4v+7h7YiCnTgaNFCr2mffZ9159g/9HwOQYpBLRRYrxq0y9TDzQzJhaaWJQ7RWb
         hBZn2s5ChrWk3GyXs+SwrRJZ4WqRLR/c2SLqNoSeCcyEd5UlCf7zETC91oTKEFxbWP
         Bu5uV3lSsIF39GuGwfokS/OuYNwZa9If7Sh2lQPjbuoYoaGF8XS7od0fLBJLeKEIp8
         j+W34N5qrZvWpguWApeNOPBcSSja6+lKjU39db33X1e2md3zwDZ+CZ+NFRwjExfbE6
         wQNWUlgsiZub4rWLIUGdbGmPcxtJ8a4HsQ85IguCPUlPxjajLrfxbBAGXFpg17zBlf
         e/zXjExdwCACA==
Date:   Wed, 14 Dec 2022 09:07:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Masaru Nagai <masaru.nagai.vx@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH net-next] ravb: Fix "failed to switch device to config
 mode" message during unbind
Message-ID: <Y5l2Ix2W8yPLycIB@unreal>
References: <20221213095938.1280861-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213095938.1280861-1-biju.das.jz@bp.renesas.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 09:59:38AM +0000, Biju Das wrote:
> This patch fixes the error "ravb 11c20000.ethernet eth0: failed to switch
> device to config mode" during unbind.
> 
> We are doing register access after pm_runtime_put_sync().
> 
> We usually do cleanup in reverse order of init. Currently in
> remove(), the "pm_runtime_put_sync" is not in reverse order.
> 
> Probe
> 	reset_control_deassert(rstc);
> 	pm_runtime_enable(&pdev->dev);
> 	pm_runtime_get_sync(&pdev->dev);
> 
> remove
> 	pm_runtime_put_sync(&pdev->dev);
> 	unregister_netdev(ndev);
> 	..
> 	ravb_mdio_release(priv);
> 	pm_runtime_disable(&pdev->dev);
> 
> Consider the call to unregister_netdev()
> unregister_netdev->unregister_netdevice_queue->rollback_registered_many
> that calls the below functions which access the registers after
> pm_runtime_put_sync()
>  1) ravb_get_stats
>  2) ravb_close
> 
> Fixes: a0d2f20650e8 ("Renesas Ethernet AVB PTP clock driver")

I don't know how you came to this fixes line, but the more correct one
is c156633f1353 ("Renesas Ethernet AVB driver proper")

Ant the title should need to be "PATCH net".

When you resend the patch, feel free to add my tag.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
