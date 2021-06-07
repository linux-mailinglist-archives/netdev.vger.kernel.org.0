Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6702F39D890
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 11:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhFGJXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 05:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhFGJXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 05:23:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDA6C061766;
        Mon,  7 Jun 2021 02:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Agga5W3RV+Q845HFQCq/AGFYgszYt9H13vWhRIwVD8g=; b=Guc4lcrFvFrMfRY4qa013BS93
        XytBl518zllAM6lNB/ix34vQT7CJWfnUgI4MMGZNxSePQ3nt8anB/enQjGq5m3IfynYSL2F6WFuJA
        5rKxULJlO5uNXUHK0ChFfUU9/qz2tOplHbojPj1JOVGOb9uE74T6UJOTxg84KoAbncoaIL5bTu9BK
        /lcsqcT9PQBjNU0TzHDIGAvP6/uBb/0S3LwV5h+wEVcoNQ5UKSyrbeop/8oP2t4+RY1+R1X2FljLn
        WYjXb37iWUXoPXR1MSxiLr7AEKaZVaQcwUX/FM+ltbAkwK464McDjhch+xGC/76TOwpCkR1XuC1BO
        h3M2CANSw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44780)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lqBRx-0000DQ-0G; Mon, 07 Jun 2021 10:21:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lqBRw-0005nY-6D; Mon, 07 Jun 2021 10:21:36 +0100
Date:   Mon, 7 Jun 2021 10:21:36 +0100
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
Subject: Re: [PATCH net-next v3 04/10] net: sparx5: add port module support
Message-ID: <20210607092136.GA22278@shell.armlinux.org.uk>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
 <20210604085600.3014532-5-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604085600.3014532-5-steen.hegelund@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 10:55:54AM +0200, Steen Hegelund wrote:
> This add configuration of the Sparx5 port module instances.
> 
> Sparx5 has in total 65 logical ports (denoted D0 to D64) and 33
> physical SerDes connections (S0 to S32).  The 65th port (D64) is fixed
> allocated to SerDes0 (S0). The remaining 64 ports can in various
> multiplexing scenarios be connected to the remaining 32 SerDes using
> QSGMII, or USGMII or USXGMII extenders. 32 of the ports can have a 1:1
> mapping to the 32 SerDes.
> 
> Some additional ports (D65 to D69) are internal to the device and do not
> connect to port modules or SerDes macros. For example, internal ports are
> used for frame injection and extraction to the CPU queues.
> 
> The 65 logical ports are split up into the following blocks.
> 
> - 13 x 5G ports (D0-D11, D64)
> - 32 x 2G5 ports (D16-D47)
> - 12 x 10G ports (D12-D15, D48-D55)
> - 8 x 25G ports (D56-D63)
> 
> Each logical port supports different line speeds, and depending on the
> speeds supported, different port modules (MAC+PCS) are needed. A port
> supporting 5 Gbps, 10 Gbps, or 25 Gbps as maximum line speed, will have a
> DEV5G, DEV10G, or DEV25G module to support the 5 Gbps, 10 Gbps (incl 5
> Gbps), or 25 Gbps (including 10 Gbps and 5 Gbps) speeds. As well as, it
> will have a shadow DEV2G5 port module to support the lower speeds
> (10/100/1000/2500Mbps). When a port needs to operate at lower speed and the
> shadow DEV2G5 needs to be connected to its corresponding SerDes
> 
> Not all interface modes are supported in this series, but will be added at
> a later stage.

It looks to me like the phylink code in your patch series is based on
an older version of phylink and hasn't been updated for the split PCS
support - you seem to be munging the PCS parts in with the MAC
callbacks. If so, please update to the modern way of dealing with this.

If that isn't the case, please explain why you are not using the split
PCS support.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
