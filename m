Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5E3614BCB
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 14:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiKANbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiKANbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 09:31:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF97D15823;
        Tue,  1 Nov 2022 06:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 955B1B81D90;
        Tue,  1 Nov 2022 13:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E585DC433D6;
        Tue,  1 Nov 2022 13:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667309469;
        bh=3mnC+ohPX5eM5kabMfqS4VLYbl3w+VHP+O9hIGhQWPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2RPpq2L0tufs3QfJAzzsU11zpwK88plYUKNLqNLLPAiPFkhc2TzAUAGYVFZ0r83da
         yeK4H+Zzry0i9QdMHMiaUtQ3JvemxyKDjHj8cBTpEDRUpBksI41pT/JEOELPKfg0MR
         gL6A4INBEPxoGShGyaFGY9+6VbohijR6nPW9Al5w=
Date:   Tue, 1 Nov 2022 14:32:02 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix
 IRQ storm on global FIFO receive
Message-ID: <Y2Ef0hK4rTmAoEUs@kroah.com>
References: <20221031143317.938785-1-biju.das.jz@bp.renesas.com>
 <20221101074351.GA8310@amd>
 <OS0PR01MB59222BA2B1CAA6CDA9B4137486369@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <83d70f8f-419c-2eb9-5130-782750772868@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83d70f8f-419c-2eb9-5130-782750772868@gmail.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 07:36:20PM +0700, Bagas Sanjaya wrote:
> On 11/1/22 14:59, Biju Das wrote:
> >> I got 7 or so copies of this, with slightly different Cc: lines.
> > 
> > I followed option 1 mentioned in [1]
> > > [1] https://www.kernel.org/doc/html/v5.10/process/stable-kernel-rules.html
> > 
> > 
> >>
> >> AFAICT this is supposed to be stable kernel submission. In such case,
> >> I'd expect [PATCH 4.14, 4.19, 5.10] in the subject line, and original
> >> sign-off block from the mainline patch.
> > 
> > OK. Maybe [1] needs updating.
> 
> The documentation says (in this case the third option applies):
> 
> > Send the patch, after verifying that it follows the above rules, to> stable@vger.kernel.org. You must note the upstream commit ID in the
> > changelog of your submission, as well as the kernel version you wish
> > it to be applied to.
> 
> It doesn't specify how to mark desired target branch, unfortunately.

And that's fine, the submitter did the right thing here and gave me all
of the information that I need.  Please do not confuse people, there is
nothing wrong with the submission as-is.

thanks,

greg k-h
