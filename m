Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A501B67F574
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 08:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjA1HUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 02:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjA1HUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 02:20:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9A57E6C4;
        Fri, 27 Jan 2023 23:20:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C750C60A25;
        Sat, 28 Jan 2023 07:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C975FC433EF;
        Sat, 28 Jan 2023 07:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674890436;
        bh=HSM5+WHccH9bmMsZMOH7J0fLCjzl8QAwBswxLLCva8Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XjzKqu9BhG4LhxwImMSrK04c2BkLJkDIon4rxnks5ZNfvBRs/Wp1aHOoUbxny7Dc2
         JZqK51rQGybT4zlCnceFMKILV7hufhWXwmfZ+WPehr7txZdi+1DYW+9YkoWh5Fw/lT
         HrltlW76/yCmsW6H+sgKTmaKYCFxZgdnGQ1g9WA/o9UIKMkt7QycYXtrI0FwOsJUgl
         s22mzdVh+9V0yxk0r0dPuvSaikS/YnK27TEju4GcYonr0g5MtG78KfgqLptK2Cnglq
         QQSflOs9NDi5YA2dvuW1dB+mqllrLzXqDpJkCYykQ0naHq7olfafJ2jIV1xMVmZHyZ
         rKiHwv+bb0IKg==
Date:   Fri, 27 Jan 2023 23:20:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonas Suhr Christensen <jsc@umbraculum.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        esben@geanix.com
Subject: Re: [PATCH 1/2] net: ll_temac: fix DMA resources leak
Message-ID: <20230127232034.1da0f4e1@kernel.org>
In-Reply-To: <20230126101607.88407-1-jsc@umbraculum.org>
References: <20230126101607.88407-1-jsc@umbraculum.org>
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

On Thu, 26 Jan 2023 11:16:06 +0100 Jonas Suhr Christensen wrote:
> Add missing conversion of address when unmapping dma region causing
> unmapping to silently fail. At some point resulting in buffer
> overrun eg. when releasing device.

Could you add a Fixes tag pointing to the commit which introduced 
the bug? It will help the stable teams backport the patch.

When reposting please put [PATCH net v2] as the prefix (noting 
the target tree for the benefit of bots/CIs).

> Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>
> ---
>  drivers/net/ethernet/xilinx/ll_temac_main.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index 1066420d6a83..66c04027f230 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -300,6 +300,7 @@ static void temac_dma_bd_release(struct net_device *ndev)
>  {
>  	struct temac_local *lp = netdev_priv(ndev);
>  	int i;
> +	struct cdmac_bd *bd;

nit: we like variable declarations longest to shortest in networking
 so before the int i; pls

>  	/* Reset Local Link (DMA) */
>  	lp->dma_out(lp, DMA_CONTROL_REG, DMA_CONTROL_RST);

