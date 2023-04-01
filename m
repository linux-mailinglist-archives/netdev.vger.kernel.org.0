Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1C86D2E43
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbjDAE6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjDAE6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:58:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED712EC76
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 21:58:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A53E60917
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 04:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA93C433D2;
        Sat,  1 Apr 2023 04:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680325098;
        bh=M7NRHgeY9YLXr0tbXa8gzPSJWRgkntHKUQrTaY89fR8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GkSp7WfnFZqe6RFdyi1EpCwdsQoGTaK5STvuHcwCzA7s3Q1fL7Jkc85TPoHcM5tp6
         wzyNTG3cey+KwCmZx5k0CxDvqVLi0ZSBtfIyM+m4lBGbzqxEf0vssAPm04JznywGXs
         8X4RNSdU8+ppCDOPLh491CWy3o5XSQfAhw0sV2USjyN95ruHOMqbNSZbzif1i0fiU9
         guhn9O3tlmfOdCdTs7OSmNsbYUdX1n1D41ce5nxsTHKarUptpT6DBJwWT9NcK/5f62
         fab7lcVQVK0tiKzGaImFZX8R7SMxQR+YxdhwOfUq5wiB7NZFJO/wfx5YDwrkwNaQE6
         WjuatBkdD2nZw==
Date:   Fri, 31 Mar 2023 21:58:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, imx@lists.linux.dev
Subject: Re: [PATCH v4 1/2] net: stmmac: add support for platform specific
 reset
Message-ID: <20230331215816.32d5aa35@kernel.org>
In-Reply-To: <20230331212250.103017-1-shenwei.wang@nxp.com>
References: <20230331212250.103017-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 16:22:49 -0500 Shenwei Wang wrote:
> diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
> index 16a7421715cb..47a68f506c10 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
> @@ -214,8 +214,6 @@ struct stmmac_dma_ops {
>  	int (*enable_tbs)(void __iomem *ioaddr, bool en, u32 chan);
>  };
> 
> -#define stmmac_reset(__priv, __args...) \
> -	stmmac_do_callback(__priv, dma, reset, __args)
>  #define stmmac_dma_init(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, dma, init, __args)
>  #define stmmac_init_chan(__priv, __args...) \
> @@ -640,6 +638,7 @@ extern const struct stmmac_mmc_ops dwxgmac_mmc_ops;
>  #define GMAC_VERSION		0x00000020	/* GMAC CORE Version */
>  #define GMAC4_VERSION		0x00000110	/* GMAC4+ CORE Version */
> 
> +int stmmac_reset(struct stmmac_priv *priv, void *ioaddr);

sparse reports missing annotation, I think it's this line.
It should have a __iomem tag. Try building with C=1
Also please take a look at:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

>  int stmmac_hwif_init(struct stmmac_priv *priv);

