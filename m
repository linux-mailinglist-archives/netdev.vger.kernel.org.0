Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5045741F9
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbiGNDjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiGNDjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:39:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8557F13FA1;
        Wed, 13 Jul 2022 20:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E43561E3A;
        Thu, 14 Jul 2022 03:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA429C34114;
        Thu, 14 Jul 2022 03:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657769952;
        bh=zopjln99q1rxFvM6ak58aizazSshf28UHBqgM18CFvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O17AZt/AeHkPn061iiEgqkpCxr/6kBkYFumRDxFpzpRDC0oakyZZ3XRGmfmEY6Ei9
         3ywnUmTLEXIsHlVvHMGqzUgTIpER87EFYeXOUR4n/d6QlwlK/L0Qmk8IRQ32aEqWdO
         +TRWuSukauk6OJIVXPhjRbYzN8zLn+pXZ1FOgs/Md9SffssjYPWH+RzvTOOR3XEm+K
         7vnP1QnI8vnpRqzgkdhK1tFUJDN0trTKm+UI85RlhJTRLnmpf6th0iuPXZsZGNsfNr
         KrJuGiYy2WyUx3ImBk01c8POD00qj2MivZaDPDLEOrZHOJZ1icPv4DjGAl3WhPv/OR
         ppqEbKU1SP4kA==
Date:   Wed, 13 Jul 2022 20:39:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     David Miller <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <macpaul.lin@mediatek.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH net v4 3/3] net: stmmac: fix unbalanced ptp clock issue
 in suspend/resume flow
Message-ID: <20220713203910.74d36732@kernel.org>
In-Reply-To: <20220713101002.10970-4-biao.huang@mediatek.com>
References: <20220713101002.10970-1-biao.huang@mediatek.com>
        <20220713101002.10970-4-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 18:10:02 +0800 Biao Huang wrote:
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 197fac587ad5..c230b8b9aab1 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -839,14 +839,6 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
>  	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
>  		return -EOPNOTSUPP;
>  
> -	ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
> -	if (ret < 0) {
> -		netdev_warn(priv->dev,
> -			    "failed to enable PTP reference clock: %pe\n",
> -			    ERR_PTR(ret));
> -		return ret;
> -	}
> -
>  	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
>  	priv->systime_flags = systime_flags;
>  


drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:837:6: warning: unused variable 'ret' [-Wunused-variable]
        int ret;
            ^
