Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B923153E3
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhBIQ3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbhBIQ3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:29:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D3EC061574;
        Tue,  9 Feb 2021 08:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4Q76uyk/WNLu+okIwMR533vp5djZ2HubZsZ+BU+VNzg=; b=Vq8qRAo+nBrkQ36LQMq0Z3WnL
        mpwmoMltr9YufXCh0iC19LIpUopu4ukW9Cd16yKRcoKO+xs1toycZuNtDaI37CJW0BEJcF+5rrulK
        BaHBlPhZeqhhFR7wcmHvxiTGggsibheV9hUq+RSRATx9puYe+qpGsLLRODH8deLrlPvIp3Vdmed+d
        e0rSDY8Fat5u8s98M4DMHF0Ab3qMQtCJA0YPjMd5yHur7CaI93pK4HAevW58XMoFMpD/U3J3e0+Tm
        n0MTxRdH75MZ+s8Up6shcY1lc/gKpam0exQ7Q7nue2V0AgKY3NAweHUHuxrUtm8ZhTV4znLpZQBgV
        dRxenOULA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41248)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l9Vsp-0003dp-0w; Tue, 09 Feb 2021 16:28:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l9Vsm-0004Ct-2h; Tue, 09 Feb 2021 16:28:56 +0000
Date:   Tue, 9 Feb 2021 16:28:56 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 net-next 15/15] net: mvpp2: add TX FC firmware check
Message-ID: <20210209162855.GQ1463@shell.armlinux.org.uk>
References: <1612860151-12275-1-git-send-email-stefanc@marvell.com>
 <1612860151-12275-16-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612860151-12275-16-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 10:42:31AM +0200, stefanc@marvell.com wrote:
>  	if (priv->global_tx_fc && priv->hw_version != MVPP21) {
> -		val = mvpp2_cm3_read(priv, MSS_FC_COM_REG);
> -		val |= FLOW_CONTROL_ENABLE_BIT;
> -		mvpp2_cm3_write(priv, MSS_FC_COM_REG, val);
> +		err = mvpp2_enable_global_fc(priv);
> +		if (err) {
> +			dev_warn(&pdev->dev, "CM3 firmware not running, version should be higher than 18.09 ");
> +			dev_warn(&pdev->dev, "and chip revision B0\n");
> +			dev_warn(&pdev->dev, "Flow control not supported\n");

I would much rather this was:

			dev_warn(&pdev->dev, "Minimum of CM3 firmware 18.09 and chip revision B0 required for flow control\n");

rather than trying to split it across several kernel messages.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
