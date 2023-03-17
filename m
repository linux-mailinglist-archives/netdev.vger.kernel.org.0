Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CB56BF349
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjCQU6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCQU6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:58:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7359B6590;
        Fri, 17 Mar 2023 13:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dZeWiRhjX2jTc6AkO+17VmA9bj/Bj3rR/73GUR3OEW4=; b=IO/VVsx2D9PvqNqMwcSg/mPkeh
        vu5KPNie2nPo1nelTEi4mumhG1/k4XJkbVPXA3NgUGhz6aq+sNHwzq4mHHnuoUwgRjZY7L+eSSpkz
        iDGfAmwREQTpsVT41OjhnF0s95Xbzxlm594QPFtyTSttqZO+GIutg1AIKAUjJYdBLtKHrGZfg4LQX
        FX/jreGLqVFpgdeBeMKmQkT748OA5ELDA1vu4x0SE63krhv35+Q09L93VzTXK5FnSj6t2oV0tB4YM
        St7NZC4tkYCNht4tfHkS3CU/oHtBWUhwAi0mRFrofWJEKBs/uvJxTN3URflAFRPktjDXAWBWBhbTD
        S+qo3zIQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56108)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pdH94-0003TX-At; Fri, 17 Mar 2023 20:57:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pdH92-0003mq-JK; Fri, 17 Mar 2023 20:57:48 +0000
Date:   Fri, 17 Mar 2023 20:57:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v2 1/2] net: stmmac: fix PHY handle parsing
Message-ID: <ZBTUTD6RL22pdlmq@shell.armlinux.org.uk>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
 <20230314070208.3703963-2-michael.wei.hong.sit@intel.com>
 <10aff941-e18a-4d77-974b-1760529988a6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10aff941-e18a-4d77-974b-1760529988a6@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 08:56:19PM +0100, Andrew Lunn wrote:
> On Tue, Mar 14, 2023 at 03:02:07PM +0800, Michael Sit Wei Hong wrote:
> > phylink_fwnode_phy_connect returns 0 when set to MLO_AN_INBAND.
> > This causes the PHY handle parsing to skip and the PHY will not be attached
> > to the MAC.
> 
> Please could you expand the commit message because i'm having trouble
> following this.
> 
> phylink_fwnode_phy_connect() says:
> 
> 	/* Fixed links and 802.3z are handled without needing a PHY */
> 	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
> 	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
> 	     phy_interface_mode_is_8023z(pl->link_interface)))
> 		return 0;
> 
> So your first statement is not true. It should be MLO_AN_INBAND
> and phy_interface_mode_is_8023z.
> 
> > Add additional check for PHY handle parsing when set to MLO_AN_INBAND.
> 
> Looking at the patch, there is no reference to MLO_AN_INBAND, or
> managed = "in-band-status";

That's the pesky "xpcs_an_inband" which ends up as phylink's
"ovr_an_inband"... I'm sure these are random renames of stuff to make
sure that people struggle to follow the code.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
