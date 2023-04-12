Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E338F6DED38
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjDLIGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjDLIGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:06:37 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024E95BB5;
        Wed, 12 Apr 2023 01:06:34 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F28BBFF812;
        Wed, 12 Apr 2023 08:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681286793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6sMvKzPXUQPaUNOAoXoB+ksyWApeu4V++9ieBbSNplg=;
        b=AIVwknBRq8FtcBddorKYDhaPsak6w1IVgxAE9xHvkAPQVErV8RYUDd6KxSE5Er7tT0vBOu
        Dr/zOZLwchd2skzKssKhhMzHtlpL5oBblK2V12mCHU6oe9I1HtLDHGB4/vBMJcOfGauOna
        /7B10RZPn3M+Nv+lOMkBQenM38zYKP5VBOJbbXyfvi5jYNYCDg8fX026aIiocQYbGAn6AX
        W+pGpnyr7cl1G6D2ikFwuDuOKEEbDerKgYAsUJma5XImsB7RJSV06/wDsp9Te9xu7VxRnf
        PwnvgufuGi3mvEukHNtihQcLj7fNZdeUqMZFl3gCWlhgmzNt+LDl5THknAdB0A==
Date:   Wed, 12 Apr 2023 10:06:27 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     davem@davemloft.net,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32 @ st-md-mailman . stormreply . com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "alexis . lothore @ bootlin . com" <alexis.lothore@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net] net: phylink: check for SFP bus presence in
 phylink_expects_phy
Message-ID: <20230412100627.1daab691@pc-288.home>
In-Reply-To: <ZDZi+fs13A8JJFOs@shell.armlinux.org.uk>
References: <20230412074850.41260-1-maxime.chevallier@bootlin.com>
        <ZDZi+fs13A8JJFOs@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Wed, 12 Apr 2023 08:51:21 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Wed, Apr 12, 2023 at 09:48:50AM +0200, Maxime Chevallier wrote:
> > When an SFP bus is present, we don't expect a PHY to be attached
> > directly from the MAC driver, it will be handled by phylink at SFP
> > attach time.  
> 
> If we have a SFP, then phylink should be configured for in-band mode.
> Maybe fix the firmware description instead?
> 

The DT used on that platform has the following configuration :

[...]
&gmac1 {
  status = "okay";
  phy-mode = "sgmii";
  managed = "in-band-status";
  sfp = <&sfp>;
[...]
}

Here phylink_expects_phy() returns true because although we use
in-band management, the link mode is set to sgmii, and
phylink_expects_phy() checks if we are in in-band mode AND 802.3z.

As we have an SFP and the link mode will be changed according to the
module we plug-in, there should be no problem switching phy-mode to
"1000BaseX", so I'm perfectly fine with this solution.

However, is it semantically correct to use sgmii here ? If so, it may be
a bit counter-intuitive to have to set the mode to 1000BaseX just so
that the phylink_expects_phy() check passes ?

Thanks for the quick reply,

Maxime
