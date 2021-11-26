Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DE645ECD1
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 12:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346034AbhKZLox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 06:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbhKZLmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 06:42:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E64C07E5E7;
        Fri, 26 Nov 2021 03:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LMb0rklF0FhVxidjDs0zJKE7sk6toKA4FBFMBdMwhPE=; b=ilVo3g6YYkO50ZXaIB1f0xNad1
        AR0bmIzUIzw6LdFMI5erbTHy91hEn0cP3ZvhXiS8OaZ2YuIXphuZdk6Am15JOc3Eo7M3iLokEygnd
        i8cQuAVsceiO0+K3tA2+hZCteRIsyL4IkqXI9W4vopo6zA+8KxBrbVHGlwv+eTXi72S3QZoB6eLxa
        ZNfM0BtXzI3lSAM1GT7gWLtx3xBBeHr05rXP/zywk8HQ7QuWC3ZttqBkxAqLSiqx3XiYbchhGg8lO
        MlJTjZrNXIrGWxANvOceOlUCLblw8NUVPKskyCXfNYZQAILlRtBvQ0gh21vd0l8Ha4P1JYerGuDt4
        ArlB/89Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55912)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mqZ1m-0002yu-7J; Fri, 26 Nov 2021 11:04:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mqZ1l-0003Da-Do; Fri, 26 Nov 2021 11:04:25 +0000
Date:   Fri, 26 Nov 2021 11:04:25 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, p.zabel@pengutronix.de,
        andrew@lunn.ch, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/6] net: lan966x: add port module support
Message-ID: <YaC/OT0f2JKBPMOb@shell.armlinux.org.uk>
References: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
 <20211126090540.3550913-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126090540.3550913-4-horatiu.vultur@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 10:05:37AM +0100, Horatiu Vultur wrote:
> This patch adds support for netdev and phylink in the switch. The
> injection + extraction is register based. This will be replaced with DMA
> accees.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

This looks mostly good now, thanks. There's one remaining issue:

> +int lan966x_port_pcs_set(struct lan966x_port *port,
> +			 struct lan966x_port_config *config)
> +{
> +	struct lan966x *lan966x = port->lan966x;
> +	bool inband_aneg = false;
> +	bool outband;
> +	int err;
> +
> +	lan966x_port_link_down(port);

This looks like something the MAC layer should be doing. Phylink won't
change the interface mode by just calling the PCS - it will do this
sequence, known as a major reconfiguration:

mac_link_down() (if the link was previously up)
mac_prepare()
mac_config()
if (pcs_config() > 0)
  pcs_an_restart()
mac_finish()

pcs_config() will also be called thusly:

if (pcs_config() > 0)
  pcs_an_restart()

to change the ethtool advertising mask which changes the inband advert
or the Autoneg bit, which has an effect only on your DEV_PCS1G_ANEG_CFG()
register, and this may be called with the link up or down.

Also, pcs_config() is supposed to return 0 if the inband advert has not
changed, or positive if it has (so pcs_an_restart() is called to cause
in-band negotiation to be restarted.)

Note also that pcs_an_restart() may  also be called when ethtool
requests negotiation restart when we're operating in 802.3z modes.

So, my question is - do you need to be so heavy weight with the call to
lan966x_port_link_down() to take everything down when pcs_config() is
called, and is it really in the right place through the sequence for
a major reconfiguration?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
