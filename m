Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E715B0C26
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiIGSGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiIGSGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:06:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F1FC04F4;
        Wed,  7 Sep 2022 11:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8PtQ4Fkejr4eJpoCDQbF8C/kbVNVUFlTeC1eJX0hAeY=; b=SkVuvezfgAOGNcPIoMvzxq8zGw
        0rYUrmEIcV//huhoPWbvObDTEsYuhP27HkJQXYY0e7Gq+avcj1ACElVJkEU56xvmnyC2OiCzrtUDd
        RK/ubwehnwVrmlsHbsptd6VEW+18GUqbeh8RPKjB09xWvWBFb30Z09OBMJcB5XdWehgEAy+4l8h+S
        a+JHBzIO4s1s300Zwo+rDygdjxU5jC6HIEDEE8g1I70d5/7+sLNCgTGSgp0hxtHBQHyv9Or/lLQNi
        2RWZK3TShuZnmMMHF5nPVCT9p9+rbqMt8z/QvHsOYKGxbJyjN2BAdWhChb8wEl6cBwtA2+uorrRAp
        lSeF1a5A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34192)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oVzRY-0005iO-UC; Wed, 07 Sep 2022 19:06:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oVzRY-0001I9-8U; Wed, 07 Sep 2022 19:06:32 +0100
Date:   Wed, 7 Sep 2022 19:06:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v5 5/8] net: phylink: Adjust link settings based
 on rate adaptation
Message-ID: <YxjdqMjtw8Rr9eKe@shell.armlinux.org.uk>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-6-sean.anderson@seco.com>
 <YxhuMjZsBb7wCBFy@shell.armlinux.org.uk>
 <f2c15d18-23c0-463e-775e-f99e42cd4a69@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2c15d18-23c0-463e-775e-f99e42cd4a69@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 01:01:49PM -0400, Sean Anderson wrote:
> > >   	if (pl->pcs && pl->pcs->ops->pcs_link_up)
> > >   		pl->pcs->ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
> > > -					 pl->cur_interface,
> > > -					 link_state.speed, link_state.duplex);
> > > +					  pl->cur_interface, speed, duplex);
> > 
> > It seems you have one extra unnecessary space here - not sure how
> > that occurred as it isn't in my original patch.
> > 
> 
> This corrects a spacing issue in the existing code.

Okay, I agree.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
