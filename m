Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF8963B8AA
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbiK2DSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbiK2DSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:18:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578F2286C1;
        Mon, 28 Nov 2022 19:18:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0461FB8110F;
        Tue, 29 Nov 2022 03:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30721C433C1;
        Tue, 29 Nov 2022 03:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669691909;
        bh=MMYaUJnNIhZwUrQoRSepO+ImmUXzeufv93AYTDMROUU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kKSZ/SfLFHTYbdH8x1JN9JVW/ROT3OtbzN5/KvDZoRwYwUfj+fF1j2337TkXqay5R
         Rt7riDXvTG/Dvn8PtWC21xD1wlubEAn+mBS959ialK/YU8X0EAv5sWTVPKBmZjEkbS
         XmaCx6v3vfytmX2HvfpOsAEMnfewUc4DKCBmeanDCRqm6xXN6bx6OOfTrFJF8ICXq8
         4cVuPdQ4S3jrn0+XQZyrPg7rbZ5L13la00RwDIGtFH2CwtJMpNMpnJc1OuS2OasHKX
         ZYYFts7Ut6JwpyQEnxwBRAGIoLEeeNlecp5xMDIp/w5s0wifmzImGmtSmNYWQE8aUb
         cAMPsP9E4U18w==
Date:   Mon, 28 Nov 2022 19:18:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <f.fainelli@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Arnd Bergmann" <arnd@arndb.de>
Cc:     YueHaibing <yuehaibing@huawei.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <arnd@arndb.de>,
        <naresh.kamboju@linaro.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency
 for BCMGENET under ARCH_BCM2835
Message-ID: <20221128191828.169197be@kernel.org>
In-Reply-To: <20221125115003.30308-1-yuehaibing@huawei.com>
References: <20221125115003.30308-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Nov 2022 19:50:03 +0800 YueHaibing wrote:
> commit 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig") fixes the build
> that contain 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> and enable BCMGENET=y but PTP_1588_CLOCK_OPTIONAL=m, which otherwise
> leads to a link failure. However this may trigger a runtime failure.
> 
> Fix the original issue by propagating the PTP_1588_CLOCK_OPTIONAL dependency
> of BROADCOM_PHY down to BCMGENET.
> 
> Fixes: 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig")
> Fixes: 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/broadcom/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
> index 55dfdb34e37b..f4ca0c6c0f51 100644
> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -71,13 +71,14 @@ config BCM63XX_ENET
>  config BCMGENET
>  	tristate "Broadcom GENET internal MAC support"
>  	depends on HAS_IOMEM
> +	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
>  	select MII
>  	select PHYLIB
>  	select FIXED_PHY
>  	select BCM7XXX_PHY
>  	select MDIO_BCM_UNIMAC
>  	select DIMLIB
> -	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
> +	select BROADCOM_PHY if ARCH_BCM2835
>  	help
>  	  This driver supports the built-in Ethernet MACs found in the
>  	  Broadcom BCM7xxx Set Top Box family chipset.

What's the code path that leads to the failure? I want to double check
that the driver is handling the PTP registration return codes correctly.
IIUC this is a source of misunderstandings in the PTP API.

Richard, here's the original report:
https://lore.kernel.org/all/CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com/
