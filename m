Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CB71E4F9F
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 22:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgE0Uwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 16:52:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53104 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgE0Uwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 16:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gKAXQgUdWQP/zL1P3eNew3G65B4gJ6Xt1zF4bmT1hDg=; b=WyvaIFrAsWiNdYbeeSXajmyKD6
        6I8uuI6yBuqgB3E3YJb/fM/ogGpVN6EhTp9s1KROW2q6RwLo9hFHGFaGz8E86tphPbfvG8p5+xnMf
        sGW6H/UMHw8y6QxnMjTQRLU/Qwgf3L6OJ4PFdtaTMogDnXyqRrvzHFcIlrmKLtm3N/6c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1je32D-003S61-VH; Wed, 27 May 2020 22:52:21 +0200
Date:   Wed, 27 May 2020 22:52:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Message-ID: <20200527205221.GA818296@lunn.ch>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
 <20200428154718.GA24923@lunn.ch>
 <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
 <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
 <20200429092616.7ug4kdgdltxowkcs@pengutronix.de>
 <CAMuHMdWf1f95ZcOLd=k1rd4WE98T1qh_3YsJteyDGtYm1m_Nfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWf1f95ZcOLd=k1rd4WE98T1qh_3YsJteyDGtYm1m_Nfg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You may wonder what's the difference between 3 and 4? It's not just the
> PHY driver that looks at phy-mode!
> drivers/net/ethernet/renesas/ravb_main.c:ravb_set_delay_mode() also
> does, and configures an additional TX clock delay of 1.8 ns if TXID is
> enabled.

Hi Geert

That sounds like a MAC bug. Either the MAC insert the delay, or the
PHY does. If the MAC decides it is going to insert the delay, it
should be masking what it passes to phylib so that the PHY does not
add a second delay.

This whole area of RGMII delays has a number of historical bugs, which
often counter act each other. So you fix one, and it break somewhere
else.

In this case, not allowing skews for plain RGMII is probably being too
strict. We probably should relax that constrain in this case, for this
PHY driver.

    Andrew
