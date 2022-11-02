Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1B161570C
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 02:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiKBBfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 21:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKBBfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 21:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11981409E;
        Tue,  1 Nov 2022 18:35:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5357D6179D;
        Wed,  2 Nov 2022 01:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D6AC433D6;
        Wed,  2 Nov 2022 01:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667352950;
        bh=FF8QHuSjxvOryJkhng34kc857KZgEPhuHFTpmH+0b94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LFtVlHEoHqplTdWXgbtJ3seWBlKVRPeTYbaWgYrTUK4DaGFR8LnJek/xLV/eOBJQl
         byDsNllzrEC9H42JhzBDrulogxavUVAuXrt4CuXKNBEzahyVGogeWYjIJ7Oc4TU4Qr
         IEimBCCXzbDILokyblt/yqIQpZatZ0mnZT2DLMuU=
Date:   Wed, 2 Nov 2022 02:36:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <chris.paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix
 IRQ storm on global FIFO receive
Message-ID: <Y2HJq/MLElPiN+Hb@kroah.com>
References: <20221031090420.589386-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031090420.589386-1-biju.das.jz@bp.renesas.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 09:04:20AM +0000, Biju Das wrote:
> commit 702de2c21eed04c67cefaaedc248ef16e5f6b293 upstream.
> 
> We are seeing an IRQ storm on the global receive IRQ line under heavy
> CAN bus load conditions with both CAN channels enabled.
> 
> Conditions:
> 
> The global receive IRQ line is shared between can0 and can1, either of
> the channels can trigger interrupt while the other channel's IRQ line
> is disabled (RFIE).
> 
> When global a receive IRQ interrupt occurs, we mask the interrupt in
> the IRQ handler. Clearing and unmasking of the interrupt is happening
> in rx_poll(). There is a race condition where rx_poll() unmasks the
> interrupt, but the next IRQ handler does not mask the IRQ due to
> NAPIF_STATE_MISSED flag (e.g.: can0 RX FIFO interrupt is disabled and
> can1 is triggering RX interrupt, the delay in rx_poll() processing
> results in setting NAPIF_STATE_MISSED flag) leading to an IRQ storm.
> 
> This patch fixes the issue by checking IRQ active and enabled before
> handling the IRQ on a particular channel.
> 
> Fixes: dd3bd23eb438 ("can: rcar_canfd: Add Renesas R-Car CAN FD driver")
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Link: https://lore.kernel.org/all/20221025155657.1426948-2-biju.das.jz@bp.renesas.com
> Cc: stable@vger.kernel.org # 4.9.x
> [mkl: adjust commit message]
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> [biju: removed gpriv from RCANFD_RFCC_RFIE macro]
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> Resending to 4.9 with confilcts[1] fixed
> [1] https://lore.kernel.org/stable/OS0PR01MB59226F2443DFCE7C5D73778786379@OS0PR01MB5922.jpnprd01.prod.outlook.com/T/#t
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

All now queued up, thanks.

greg k-h
