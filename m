Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05679539010
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 13:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiEaLus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 07:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiEaLuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 07:50:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16359809E;
        Tue, 31 May 2022 04:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EaX3DGUPmHHCP5bGL2k/AhkjGQklNLSjDKLEp7C+0Go=; b=anR5n6PAL/h5Aqw7nUNlUXMZ24
        SejeHE5cl1VljKLimUmyGRznnSgZZ8D0hU3397nRGumAc4jWiziLvrS8W4wJcIWP510glOYTqlBuO
        As5QW8KPgoti56A7eZ5g5ki+Elg2HuQUeq+cV5GViFbEBCnNpwC6CNTiIwU+nBsjtWGUqgE37BY+5
        7r+L0vZwrlD2PQsaaYirCaZ+LHG1E2A4ZWWQer10P/58q9OMlYSCWDoenEpcyGLlcY64T5Uip10Zg
        DyD0636qWCYbQWJUlXMrBLRYK9tGzCxN2bWoITzCTKZFq1VynB5EXGpelOMtIhBUo5MlBrGUjPLIf
        lmeGADeg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60900)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nw0OQ-0004te-MQ; Tue, 31 May 2022 12:50:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nw0OM-0002Ma-Pg; Tue, 31 May 2022 12:50:30 +0100
Date:   Tue, 31 May 2022 12:50:30 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vladimir.oltean@nxp.com,
        grygorii.strashko@ti.com, vigneshr@ti.com, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 2/3] net: ethernet: ti: am65-cpsw: Add support for QSGMII
 mode
Message-ID: <YpYBBp8Io116bBwM@shell.armlinux.org.uk>
References: <20220531113058.23708-1-s-vadapalli@ti.com>
 <20220531113058.23708-3-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531113058.23708-3-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 05:00:57PM +0530, Siddharth Vadapalli wrote:
>  static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
>  				      const struct phylink_link_state *state)
>  {
> -	/* Currently not used */
> +	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
> +							  phylink_config);
> +	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
> +
> +	if (state->interface == PHY_INTERFACE_MODE_QSGMII)
> +		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
> +		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);

What about writing this register when the interface mode isn't QSGMII?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
