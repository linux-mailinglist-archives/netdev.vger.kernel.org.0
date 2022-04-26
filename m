Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0900950FF37
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiDZNk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243111AbiDZNkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:40:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C194198F;
        Tue, 26 Apr 2022 06:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=l4h0Ov9OzmifR5jldxkma+y1tJv7QCkgxeL1WbcVp2I=; b=vGRJbhRGckl9QnEYvsb4P+RCnc
        cua3k6wPbIPbIu3JCsJ8VLa6meBL5p23ZHiDphp+sDc/ZuaEcKn9wMqiYtOVxS5NS5MbNnQfTC4iH
        iEsWZAc5fY0ReNehxoSgLoHaBmifIfYByjwW15JkwHWmfYrAB+6ETgQYXrk0C1/3grjk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njLN9-00HYfD-GM; Tue, 26 Apr 2022 15:36:55 +0200
Date:   Tue, 26 Apr 2022 15:36:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcel Ziswiler <marcel.ziswiler@toradex.com>
Cc:     "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "festevam@gmail.com" <festevam@gmail.com>
Subject: Re: net: stmmac: dwmac-imx: half duplex crash
Message-ID: <Ymf1dwrwHe0PS1Cq@lunn.ch>
References: <36ba455aad3e57c0c1f75cce4ee0f3da69e139a1.camel@toradex.com>
 <YmXIo6q8vVkL6zLp@lunn.ch>
 <5e51e11bbbf6ecd0ee23b4fd2edec98e6e7fbaa8.camel@toradex.com>
 <YmbFblFCrGFND+h/@lunn.ch>
 <8f8cdcf584c13faf8bcdc2abfdb62b09950ea652.camel@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f8cdcf584c13faf8bcdc2abfdb62b09950ea652.camel@toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Anyway, this is roughly there the check should go.
> 
> You mean it would need an additional check against advertising nothing?

I would check for a mode being requested which is not
supported. phydev->supported tells you what the MAC/PHY can actually
do. If there is a bit set which is not a member of that, return
EINVAL. I don't think the plumbing is there, but netlink ethtool
allows you to also return a text message via extack, so you could give
the user a bit more information, the link mode which is invalid.

> Well, we are gearing up on our automated testing infrastructure and asking my humble opinion on what exactly to
> test concerning the Ethernet subsystem I gave the brilliant suggestion to try each and every supported link
> mode (;-p). Which actually works just fine on every other hardware of ours just not the i.MX 8M Plus with the
> DWMAC IP (remember, even FEC MAC works). So for now this is not something a customer of ours has real trouble
> with but it raised some questions concerning whether or not and what exactly we do support...

So in practice, this should not happen. You don't advertise the half
modes, so you should never end up in a half mode. So it is not a
problem :-)

	Andrew
