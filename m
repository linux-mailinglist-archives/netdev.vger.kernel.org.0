Return-Path: <netdev+bounces-2369-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 258D370189F
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 19:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FF791C20B6C
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 17:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2DC37474;
	Sat, 13 May 2023 17:47:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39014C6B
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 17:47:44 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB801FE2
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 10:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=iiHFxtfODHM+cFnnw5ezgfTUUbQH9Wf/XgZfqjupX7U=; b=h2s2lyzh1GROoJvB072wmOMDn8
	njQS4T7HI2u35fW/c0x1od8USN8PaeMTPhL1UB8AXnMQ/bzDR9ga1YBw+51UCH2LtoRt1Em0ifTMH
	vKz9DL/MqM7bNHNa/TiMvmchBOUoCYsZowF5NMo4UqmA7+AEoKn8BDGjr/bxFckeGx8s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pxtLD-00ClVc-Sv; Sat, 13 May 2023 19:47:35 +0200
Date: Sat, 13 May 2023 19:47:35 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC net-next 7/9] net: pcs: xpcs: correct pause resolution
Message-ID: <f1b8d851-1e01-4719-aa2e-4b628838a515@lunn.ch>
References: <ZF52z7PqH2HLrWEU@shell.armlinux.org.uk>
 <E1pxWYJ-002QsU-IT@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pxWYJ-002QsU-IT@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 06:27:35PM +0100, Russell King (Oracle) wrote:
> xpcs was indicating symmetric pause should be enabled regardless of
> the advertisements by either party. Fix this to use
> linkmode_resolve_pause() now that we're no longer obliterating the
> link partner's advertisement by logically anding it with our own.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/pcs/pcs-xpcs.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index 43115d04c01a..beed799a69a7 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -538,11 +538,20 @@ static void xpcs_resolve_lpa_c73(struct dw_xpcs *xpcs,
>  				 struct phylink_link_state *state)
>  {
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(res);
> +	bool tx_pause, rx_pause;
>  
>  	/* Calculate the union of the advertising masks */
>  	linkmode_and(res, state->lp_advertising, state->advertising);
>  
> -	state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
> +	/* Resolve pause modes */
> +	linkmode_resolve_pause(state->advertising, state->lp_advertising,
> +			       &tx_pause, &rx_pause);
> +
> +	if (tx_pause)
> +		state->pause |= MLO_PAUSE_TX;
> +	if (rx_pause)
> +		state->pause |= MLO_PAUSE_RX;
> +

Hi Russell

I must be missing something. Why not use phylink_resolve_an_pause()?

	Andrew

