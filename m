Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB38513E9E
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 00:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352948AbiD1Wnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 18:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352944AbiD1Wne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 18:43:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7121E692A1;
        Thu, 28 Apr 2022 15:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 247F1B82FE1;
        Thu, 28 Apr 2022 22:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9C8C385AD;
        Thu, 28 Apr 2022 22:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651185615;
        bh=wXxogfL874XcDPPyxkQBPeMveMhFBfE8bS1aLYuh9GY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jpbCawBL6V4AJTyN9/txG1j79d8EmUpVaVhRPiqbk0PE53D68QWRi2kw8ZRj57+RU
         o+OfxlbvZ7OuBoZLvBK2odjxQZBBzraEeyamVGnyAd4diF/BeR0OgNnXCCIQONUEEN
         fzX/odth6/PHdPe+phUrxxBFSJCrnKowm+xnVh/ZM/PuiOAwO6UdliGZ79O7ui9dLf
         4KDBio2ZuNqq+ltee7PbBh8ZXCg1RnDBWx81AIWeXRWot8XTV7VtlRQLu3hTLovMDV
         5UTvpwHs0ksgdlMf4MEEx1i3nu92OTGvAcY6m5IaYXeeVBsQTL72sK892xdwkE3CBe
         vs70ib3iW/dSg==
Date:   Thu, 28 Apr 2022 15:40:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianqun Xu <jay.xu@rock-chips.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ethernet: stmmac: fix for none child queue node
 for tx node
Message-ID: <20220428154014.590f6655@kernel.org>
In-Reply-To: <20220428010927.526310-1-jay.xu@rock-chips.com>
References: <20220428010927.526310-1-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 09:09:27 +0800 Jianqun Xu wrote:
> In case of nothing to be set for tx node result in no child queue node
> for the tx node, this patch init the queue to tx_queues_to_use instead
> of 0 to support dt file set no queue node for tx node.
> 
> Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>

Something needs to initialize the settings
(plat->tx_queues_cfg[queue].#) to the defaults, no? 
Just ignoring the error may not be enough.

Also has this ever worked? If you're trying to make the driver work for
DTs that never worked (and are arguably invalid) -- please change the
subject from "fix..." to "support...".

> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 2d8c095f3856..4f01a41c485c 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -279,7 +279,7 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
>  
>  		queue++;
>  	}
> -	if (queue != plat->tx_queues_to_use) {
> +	if (queue != plat->tx_queues_to_use && of_get_child_count(tx_node)) {
>  		ret = -EINVAL;
>  		dev_err(&pdev->dev, "Not all TX queues were configured\n");
>  		goto out;

