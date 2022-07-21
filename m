Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E629157D2F5
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiGUSE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGUSEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:04:25 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4FC8C582;
        Thu, 21 Jul 2022 11:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=J2VYcnATE1BBYfEr73NA4avIPlTGJ+FZMlH1oDYhLQI=; b=dzZpi4nV2ExLsdHmq8UvuDYhlg
        Ul/KxgZO/Fmp45GWa6h7nebQAPZjEtmA6g8y023qaHnt7ng+UnDcbcoZ+OazVEStbL42TlPf+413x
        GQVoBZdV6JepIZ6d+FULIvc66iMOy5mkcclcpc7jwSof/MCocBa+5OXYWVMxITLzNvNquiVAlBxF9
        Uixwxk0isujSUvK0FbtN2qI3yTurzEF3mb+FZlLhk6hkcA1vFhPpPgLTEitiLZIts5fXbYLRZlvtj
        jCRKfe8FaLc3kBKVcdbZV9QznCZpMYMBra8avkj7iJWC6Ezwn8LN9ddf/F3bjTp6oV0yJATgBRFiJ
        Gthu6Dlw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33486)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oEaX5-0005on-WB; Thu, 21 Jul 2022 19:04:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oEaX3-00052g-SX; Thu, 21 Jul 2022 19:04:17 +0100
Date:   Thu, 21 Jul 2022 19:04:17 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 08/11] net: phylink: Adjust advertisement based on
 rate adaptation
Message-ID: <YtmVIXYKpCJ2GEwK@shell.armlinux.org.uk>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-9-sean.anderson@seco.com>
 <Ytep4isHcwFM7Ctc@shell.armlinux.org.uk>
 <3844f2a6-90fb-354e-ce88-0e9ff0a10475@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3844f2a6-90fb-354e-ce88-0e9ff0a10475@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 12:55:16PM -0400, Sean Anderson wrote:
> On 7/20/22 3:08 AM, Russell King (Oracle) wrote:
> > On Tue, Jul 19, 2022 at 07:49:58PM -0400, Sean Anderson wrote:
> >> @@ -482,7 +529,39 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
> >>  		break;
> >>  	}
> >>  
> >> -	return caps & mac_capabilities;
> >> +	switch (rate_adaptation) {
> >> +	case RATE_ADAPT_NONE:
> >> +		break;
> >> +	case RATE_ADAPT_PAUSE: {
> >> +		/* The MAC must support asymmetric pause towards the local
> >> +		 * device for this. We could allow just symmetric pause, but
> >> +		 * then we might have to renegotiate if the link partner
> >> +		 * doesn't support pause.
> > 
> > Why do we need to renegotiate, and what would this achieve? The link
> > partner isn't going to say "oh yes I do support pause after all",
> > and in any case this function is working out what the capabilities
> > of the system is prior to bringing anything up.
> > 
> > All that we need to know here is whether the MAC supports receiving
> > pause frames from the PHY - if it doesn't, then the MAC is
> > incompatible with the PHY using rate adaption.
> 
> AIUI, MAC_SYM_PAUSE and MAC_ASYM_PAUSE correspond to the PAUSE and
> ASM_DIR bits used in autonegotiation. For reference, Table 28B-2 from
> 802.3 is:
> 
> PAUSE (A5) ASM_DIR (A6) Capability
> ========== ============ ================================================
>          0            0 No PAUSE
>          0            1 Asymmetric PAUSE toward link partner
>          1            0 Symmetric PAUSE
> 	 1            1 Both Symmetric PAUSE and Asymmetric PAUSE toward
>                         local device
> 
> These correspond to the following valid values for MLO_PAUSE:
> 
> MAC_SYM_PAUSE MAC_ASYM_PAUSE Valid pause modes
> ============= ============== ==============================
>             0              0 MLO_PAUSE_NONE
>             0              1 MLO_PAUSE_NONE, MLO_PAUSE_TX
>             1              0 MLO_PAUSE_NONE, MLO_PAUSE_TXRX
> 	    1              1 MLO_PAUSE_NONE, MLO_PAUSE_RX,
>                              MLO_PAUSE_TXRX
> 
> In order to support pause-based rate adaptation, we need MLO_PAUSE_RX to
> be valid. This rules out the top two rows. In the bottom mode, we can
> enable MLO_PAUSE_RX without MLO_PAUSE_TX. Whatever our link partner
> supports, we can still enable it. For the third row, however, we can
> only enable MLO_PAUSE_RX if we also enable MLO_PAUSE_TX. This can be a
> problem if the link partner does not support pause frames (or the user
> has disabled MLO_PAUSE_AN and MLO_PAUSE_TX). So if we were to enable
> advertisement of pause-based, rate-adapted modes when only MAC_SYM_PAUSE
> was present, then we might end up in a situation where we'd have to
> renegotiate without those modes in order to get a valid link state. I
> don't want to have to implement that, so for now we only advertise
> pause-based, rate-adapted modes if we support MLO_PAUSE_RX without
> MLO_PAUSE_TX.

Ah, I see. Yes, I agree that we shouldn't do that, and only allow rate
adaption in pause mode to be used if we can enable RX pause without TX
pause on our local MAC.

> > Have you checked the PHY documentation to see what the behaviour is
> > in rate adaption mode with pause frames and it negotiates HD on the
> > media side? Does it handle the HD issue internally?
> 
> It's not documented. This is just conservative. Presumably, there exists
> (or could exist) a duplex-adapting phy, but I don't know if I have one.

I guess it would depend on the structure of the PHY - whether the PHY
is structured similar to a two port switch internally, having a MAC
facing the host and another MAC facing the media side. (I believe this
is exactly how the MACSEC versions of the 88x3310 are structured.)

If you don't have that kind of structure, then I would guess that doing
duplex adaption could be problematical.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
