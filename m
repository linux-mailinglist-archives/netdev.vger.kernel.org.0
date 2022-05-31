Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E64053901E
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 13:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343985AbiEaLz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 07:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242862AbiEaLz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 07:55:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F30B3A1A4;
        Tue, 31 May 2022 04:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kUMBZgY8iX2iMdYNu+l03Qq//chFmyXyGt0+8brQTSk=; b=YNH32eHxS/BtFCzN1yaCjACuh0
        uddqn/a6Y22J0eGRE4v6jngNh+Q+KTupeG11aTjhkcCNjB51jVLnqntXy7qbZSjLio1B1hKgHfTMY
        L9WIBD2zhCIb+2Z2aIiLcJJrVvcULHstOdaqGOWpLLP0UWeP0BlaZBd3UGkYUAByQ+HQskb0WNTJO
        gfSg8ExNfv9zDGoFrRIiZR8y272r9qt4dUeo2AQV9nA8618XDtEFrxlGJ4f0yUJFSumUncpEOAxET
        CQl9OBSC9Rg71jq+QKhcuIoy/5FAeD8+U0qXjUCBBK+htLofqzlXpjGohv6om2+Xz2CMNSW6J2OPs
        rvK5XLOw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60902)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nw0T1-0004uB-Ks; Tue, 31 May 2022 12:55:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nw0T0-0002Mh-RY; Tue, 31 May 2022 12:55:18 +0100
Date:   Tue, 31 May 2022 12:55:18 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vladimir.oltean@nxp.com,
        grygorii.strashko@ti.com, vigneshr@ti.com, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 3/3] net: ethernet: ti: am65-cpsw: Move
 phy_set_mode_ext() to correct location
Message-ID: <YpYCJv2SIExL+VHs@shell.armlinux.org.uk>
References: <20220531113058.23708-1-s-vadapalli@ti.com>
 <20220531113058.23708-4-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531113058.23708-4-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 05:00:58PM +0530, Siddharth Vadapalli wrote:
> In TI's J7200 SoC CPSW5G ports, each of the 4 ports can be configured
> as a QSGMII main or QSGMII-SUB port. This configuration is performed
> by phy-gmii-sel driver on invoking the phy_set_mode_ext() function.
> 
> It is necessary for the QSGMII main port to be configured before any of
> the QSGMII-SUB interfaces are brought up. Currently, the QSGMII-SUB
> interfaces come up before the QSGMII main port is configured.
> 
> Fix this by moving the call to phy_set_mode_ext() from
> am65_cpsw_nuss_ndo_slave_open() to am65_cpsw_nuss_init_slave_ports(),
> thereby ensuring that the QSGMII main port is configured before any of
> the QSGMII-SUB ports are brought up.

This sounds like "if we're configured via port->slave.phy_if to be in
QSGMII mode, then the serdes PHY needs to be configured before any of
the QSGMII ports are used". Doesn't that mean that if
port->slave.phy_if is QSGMII, then the port _only_ supports QSGMII
mode, and conversely, the port doesn't support QSGMII unless firmware
said it could be.

So, doesn't that mean am65_cpsw_nuss_init_port_ndev() should indicate
only QSGMII, or only the RGMII modes, but never both together?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
