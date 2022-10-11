Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B985FB180
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 13:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJKLcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 07:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiJKLcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 07:32:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625CC792F0;
        Tue, 11 Oct 2022 04:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F25286116E;
        Tue, 11 Oct 2022 11:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D68C433D6;
        Tue, 11 Oct 2022 11:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665487966;
        bh=jHgoGNfFEdR7bro3G8Yqq60c89YmeHBo+XU9xLDk1Oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jSVTiJlvgviGVCw4g9OOdnxgur5AcWPQASdUprUwzeJ/B1P4wUd42ZDjTN2PKDGLE
         OF/1XVdIncabHlKvNjyuHeyyDc2gasbCJz5e7dfMpRJ+V6EgJdeO7/G6aN0q7kos7U
         kd7/7dmqHeOpqC91D2GImHhq00l9fr3C70tpctnR3f3/9LFfy2K0cMn51+D6bQpdex
         clXG+JX9nkrmViM683CPYRYooG0nIrz3pd3jVOrzyt2RCqU+w8Zh0Y9dvqEpxzOtuF
         yEmCiQCfIXsOqng4xTCEz8bJrbclHL/2BHl6IiXOa9QRxRFGa9zfZiWn66Im1FGLuj
         HfEz6mzaB3AYQ==
Date:   Tue, 11 Oct 2022 14:32:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [RESEND PATCH net] net: phy: micrel: Fixes FIELD_GET assertion
Message-ID: <Y0VUWvJgBXVADpYD@unreal>
References: <20221011095437.12580-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011095437.12580-1-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 11, 2022 at 03:24:37PM +0530, Divya Koppera wrote:
> FIELD_GET() must only be used with a mask that is a compile-time
> constant. Mark the functions as __always_inline to avoid the problem.
> 
> Fixes: 21b688dabecb6a ("net: phy: micrel: Cable Diag feature for lan8814 phy")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 3757e069c486..54a17b576eac 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1838,7 +1838,7 @@ static int ksz886x_cable_test_start(struct phy_device *phydev)
>  	return phy_clear_bits(phydev, MII_BMCR, BMCR_ANENABLE | BMCR_SPEED100);
>  }
>  
> -static int ksz886x_cable_test_result_trans(u16 status, u16 mask)
> +static __always_inline int ksz886x_cable_test_result_trans(u16 status, u16 mask)

I don't think that this is valid workaround. You are adding inline
function to C-files.

Please find another solution. For example, adding new field_get function
to bitfield.h that accepts dynamic fields.

Thanks
