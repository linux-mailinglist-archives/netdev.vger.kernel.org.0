Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0181667D3E3
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 19:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjAZSPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 13:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjAZSPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 13:15:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086585DC0E;
        Thu, 26 Jan 2023 10:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B00CAB81EC9;
        Thu, 26 Jan 2023 18:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD544C433A1;
        Thu, 26 Jan 2023 18:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674756903;
        bh=NfMkiO3rsVBgR+/QmdshzudVaBYlO4yif5qAQ2HfEmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UXZtF79pvHKb5+cujlUko+BBbV/xe3IfNkdYriqlv8ZbjECfw7V1AvIou28YqrrRL
         bwhOUeXfH5+p7sQ2mrSfm+pH7JJLe32YCbh77z5I18dtf8XbseXlkz6myss5/2xbNk
         q6YHUzDAdH2N8qPhMtljO7/zhel0++OTwhyOKzTRF2MmJeUuw7BGjoLO6k5VhAXrjj
         ta5axXUfmtKqLeAtKM0D2KRlz02UgYLN2K/SzIs/KQwbKgkrMzKVCH1FbDF8WuLhNX
         UbQ7mfvX9uEgulLebdKwFPc2JUY6TFRGyxuqxlFq29eImoEj2E8EcRsd2f/DCwfysb
         S9FutvrfLcJKw==
Date:   Thu, 26 Jan 2023 20:14:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-gpio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wiznet: convert to GPIO descriptors
Message-ID: <Y9LDIvWiG9gSl9f2@unreal>
References: <20230126135454.3556647-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126135454.3556647-1-arnd@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 02:54:12PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The w5100/w5300 drivers only support probing with old platform data in
> MMIO mode, or probing with DT in SPI mode. There are no users of this
> platform data in tree, and from the git history it appears that the only
> users of MMIO mode were on the (since removed) blackfin architecture.
> 
> Remove the platform data option, as it's unlikely to still be needed, and
> change the internal operation to GPIO descriptors, making the behavior
> the same for SPI and MMIO mode. The other data in the platform_data
> structure is the MAC address, so make that also handled the same for both.
> 
> It would probably be possible to just remove the MMIO mode driver
> completely, but it seems fine otherwise, and fixing it to use the modern
> interface seems easy enough.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  .../devicetree/bindings/net/wiznet,w5x00.txt  |  4 +-
>  drivers/net/ethernet/wiznet/w5100-spi.c       | 21 ++-----
>  drivers/net/ethernet/wiznet/w5100.c           | 57 ++++++++++---------
>  drivers/net/ethernet/wiznet/w5100.h           |  3 +-
>  drivers/net/ethernet/wiznet/w5300.c           | 52 ++++++++++-------
>  include/linux/platform_data/wiznet.h          | 23 --------
>  6 files changed, 70 insertions(+), 90 deletions(-)
>  delete mode 100644 include/linux/platform_data/wiznet.h

<...>

>  #include "w5100.h"
>  
> @@ -139,6 +139,12 @@ MODULE_LICENSE("GPL");
>  #define W5500_RX_MEM_START	0x30000
>  #define W5500_RX_MEM_SIZE	0x04000
>  
> +#ifndef CONFIG_WIZNET_BUS_SHIFT
> +#define CONFIG_WIZNET_BUS_SHIFT 0
> +#endif

I don't see any define of CONFIG_WIZNET_BUS_SHIFT in the code, so it looks
like it always zero and can be removed.

Thanks
