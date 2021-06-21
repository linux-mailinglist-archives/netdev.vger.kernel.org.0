Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FC53AEB61
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 16:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhFUOgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 10:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhFUOf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 10:35:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197C4C061574;
        Mon, 21 Jun 2021 07:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5QaQJhrlff70DLidq/ICZqB3tTQ+lIiyH5FQ4SHS5tw=; b=fzUkOvm1Tdr/8dWixqDSGLxI+
        5mVx/DfkJBrFFrq7DQSCMm19MYDwMW1FjG7TqMshyxpIbfp4aTVSNnQ+LGdbdNRKYBYNZ7jAjKLbH
        Lo/lAWze0JAWLVgeFI8KIE+//Skjv9nK2lGjmw7hpk1xVqGXVOsseIg2aMr0C5/KQxron45R/PLQ1
        UDL/f55FI53A6Dz8M30hdRldipG8dL82JwMdHmIOUK4ZmCBwYu9usmdpknW5dhcNFQNRIknq9ipwK
        Oo1gxnov8R2nCv06JQxBWu1uF/vCsXJmlUcBeBuCny52Li/0V9sYvrIXCjcjKLVHRyjSFLL63A1x8
        lbAiPKIVA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45228)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lvKzX-0004GG-OC; Mon, 21 Jun 2021 15:33:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lvKzW-0002y2-Ru; Mon, 21 Jun 2021 15:33:34 +0100
Date:   Mon, 21 Jun 2021 15:33:34 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Simon Horman <simon.horman@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v4 04/10] net: sparx5: add port module support
Message-ID: <20210621143334.GN22278@shell.armlinux.org.uk>
References: <20210615085034.1262457-1-steen.hegelund@microchip.com>
 <20210615085034.1262457-5-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615085034.1262457-5-steen.hegelund@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 15, 2021 at 10:50:28AM +0200, Steen Hegelund wrote:
> +static int sparx5_port_pcs_low_set(struct sparx5 *sparx5,
> +				   struct sparx5_port *port,
> +				   struct sparx5_port_config *conf)
> +{
> +	bool sgmii = false, inband_aneg = false;
> +	int err;
> +
> +	if (!port->conf.has_sfp) {
> +		sgmii = true; /* Phy is connnected to the MAC */
> +	} else {
> +		if (conf->portmode == PHY_INTERFACE_MODE_SGMII ||
> +		    conf->portmode == PHY_INTERFACE_MODE_QSGMII)
> +			inband_aneg = true; /* Cisco-SGMII in-band-aneg */
> +		else if (conf->portmode == PHY_INTERFACE_MODE_1000BASEX &&
> +			 conf->autoneg)
> +			inband_aneg = true; /* Clause-37 in-band-aneg */

I have to wonder why the presence of inband aneg depends on whether
there's a SFP or not... We don't do that kind of thing in other
drivers, so what is different here?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
