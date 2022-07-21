Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214F557CEDE
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiGUP1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGUP1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:27:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880A27A51E;
        Thu, 21 Jul 2022 08:27:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B2CDB82580;
        Thu, 21 Jul 2022 15:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9D0C3411E;
        Thu, 21 Jul 2022 15:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658417228;
        bh=gyyq7f1WtZrYIwLvvzePgmh+epDrnTTQoVWF0WkxftI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r6IhG9Tmbt7l6uYKEmkZQptbROulaI1Wc2H9VuNo9M0BB7ST55kCP49u3AKt2e/XC
         WE/Txcx8jU1zBWlVKL+U2FVfG3OYD9VXi+V/1p5nQ/+Nuthnnh9pw6F2DfD4OrkJWp
         UWdHIeA6mp45w/aYjvtWLdel1Baf16p51A32pYD4a+B/NymSY7PfwswuQalC436+zW
         5KbPiXkFHI3QsNEg677Byxyw1zLrz5trrZ8qP+g+WRaeCcWyT15TvUUbJ4nLEasOXW
         ctlfAUNFdE6bENIPl/2uqJ9vpQCbwWQBL4orNsq2nT1ijOn+P20GorFVU6OTnwpooE
         gSA36rxQgi1/Q==
Date:   Thu, 21 Jul 2022 08:27:06 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        llvm@lists.linux.dev
Subject: Re: [PATCH net-next 18/29] can: pch_can: do not report txerr and
 rxerr during bus-off
Message-ID: <YtlwSpoeT+nhmhVn@dev-arch.thelio-3990X>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
 <20220720081034.3277385-19-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720081034.3277385-19-mkl@pengutronix.de>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 10:10:23AM +0200, Marc Kleine-Budde wrote:
> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> 
> During bus off, the error count is greater than 255 and can not fit in
> a u8.
> 
> Fixes: 0c78ab76a05c ("pch_can: Add setting TEC/REC statistics processing")
> Link: https://lore.kernel.org/all/20220719143550.3681-2-mailhol.vincent@wanadoo.fr
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/net/can/pch_can.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index fde3ac516d26..497ef77340ea 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -496,6 +496,9 @@ static void pch_can_error(struct net_device *ndev, u32 status)
>  		cf->can_id |= CAN_ERR_BUSOFF;
>  		priv->can.can_stats.bus_off++;
>  		can_bus_off(ndev);
> +	} else {
> +		cf->data[6] = errc & PCH_TEC;
> +		cf->data[7] = (errc & PCH_REC) >> 8;
>  	}
>  
>  	errc = ioread32(&priv->regs->errc);
> @@ -556,9 +559,6 @@ static void pch_can_error(struct net_device *ndev, u32 status)
>  		break;
>  	}
>  
> -	cf->data[6] = errc & PCH_TEC;
> -	cf->data[7] = (errc & PCH_REC) >> 8;
> -
>  	priv->can.state = state;
>  	netif_receive_skb(skb);
>  }
> -- 
> 2.35.1
> 
> 
> 

Apologies if this has been reported already, I didn't see anything on
the mailing lists.

This commit is now in -next as commit 3a5c7e4611dd ("can: pch_can: do
not report txerr and rxerr during bus-off"), where it causes the
following clang warning:

  ../drivers/net/can/pch_can.c:501:17: error: variable 'errc' is uninitialized when used here [-Werror,-Wuninitialized]
                  cf->data[6] = errc & PCH_TEC;
                                ^~~~
  ../drivers/net/can/pch_can.c:484:10: note: initialize the variable 'errc' to silence this warning
          u32 errc, lec;
                  ^
                   = 0
  1 error generated.

errc is initialized underneath this now, should it be hoisted or is
there another fix?

Cheers,
Nathan
