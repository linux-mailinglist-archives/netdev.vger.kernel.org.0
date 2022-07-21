Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360C857D099
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiGUQDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiGUQDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:03:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E0687C0B;
        Thu, 21 Jul 2022 09:03:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A42EB82566;
        Thu, 21 Jul 2022 16:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1A3C3411E;
        Thu, 21 Jul 2022 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658419381;
        bh=NGcKvDlZiQVEt7g5gg+TPc/xoOAhXGRajJKNtTaB18M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CcS59g+NCS4R5fkiq1Q4Qc5/cNUo7SbFA0dIfhcxVk0b+UF7v5W3NpMSJCnwWmlvH
         q+lRoptgEz4rEeNVemAez9No6WGLr2oqW7fXmkxwn5J3nd/5r4apotrcviFqK6ry9G
         mGywL+iI7149SDN7TqwZ0wRQ2KWwMehmHRRgVakfWNZ96LJlejCHoNovOgJmc2q4Bk
         XGheIy6zPRqHKwmBN+lJM49fuN/fQInRkmDiqhUt0xdKPx3a41jduuEw6qIzxIMcIQ
         xBnSmHpUiokest5Bp5Q1hAmgRSQ90bAlqkkzZ1X+bI+4MJYZlli6AIOAnVu6bqPa3g
         lx7rQATIhmMUA==
Date:   Thu, 21 Jul 2022 09:02:58 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Frank Jungclaus <frank.jungclaus@esd.eu>,
        Stefan =?iso-8859-1?Q?M=E4tje?= <Stefan.Maetje@esd.eu>
Subject: Re: [PATCH] can: pch_can: initialize errc before using it
Message-ID: <Ytl4suKQfH5sc+er@dev-arch.thelio-3990X>
References: <YtlwSpoeT+nhmhVn@dev-arch.thelio-3990X>
 <20220721160032.9348-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721160032.9348-1-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 01:00:32AM +0900, Vincent Mailhol wrote:
> After commit 3a5c7e4611dd, the variable errc is accessed before being
> initialized, c.f. below W=2 warning:
> 
> | In function 'pch_can_error',
> |     inlined from 'pch_can_poll' at drivers/net/can/pch_can.c:739:4:
> | drivers/net/can/pch_can.c:501:29: warning: 'errc' may be used uninitialized [-Wmaybe-uninitialized]
> |   501 |                 cf->data[6] = errc & PCH_TEC;
> |       |                             ^
> | drivers/net/can/pch_can.c: In function 'pch_can_poll':
> | drivers/net/can/pch_can.c:484:13: note: 'errc' was declared here
> |   484 |         u32 errc, lec;
> |       |             ^~~~
> 
> Moving errc initialization up solves this issue.
> 
> Fixes: 3a5c7e4611dd ("can: pch_can: do not report txerr and rxerr during bus-off")
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Heh, Marc just sent the same patch. Just in case this one gets picked up
instead:

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the quick response!

> ---
>  drivers/net/can/pch_can.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index 50f6719b3aa4..32804fed116c 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -489,6 +489,7 @@ static void pch_can_error(struct net_device *ndev, u32 status)
>  	if (!skb)
>  		return;
>  
> +	errc = ioread32(&priv->regs->errc);
>  	if (status & PCH_BUS_OFF) {
>  		pch_can_set_tx_all(priv, 0);
>  		pch_can_set_rx_all(priv, 0);
> @@ -502,7 +503,6 @@ static void pch_can_error(struct net_device *ndev, u32 status)
>  		cf->data[7] = (errc & PCH_REC) >> 8;
>  	}
>  
> -	errc = ioread32(&priv->regs->errc);
>  	/* Warning interrupt. */
>  	if (status & PCH_EWARN) {
>  		state = CAN_STATE_ERROR_WARNING;
> -- 
> 2.35.1
> 
