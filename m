Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2D3523473
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243931AbiEKNjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237276AbiEKNjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:39:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D541B7921
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 06:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xmALSnUT+h5R99s7899/L5KuToWhGctHNaIbwW7d828=; b=WXIdwufY0N4vQheQKqNkqfWokA
        4bwW8CwHRMXXqADRbwWiTnuN+usPTxDDCBP8wEu0OIRmlRAuFBbgwI/yMYHsH0I5BRkdlDYSWlE3l
        aX3YZKcsnoUVBnL/RzTTwky0TBHUQuTYooM0UfaLID1AzC4TBE6RnviZeFACXLAMDaDQFpcDY52Ah
        mAbCLCD8HfHQkdsKgfc7gl29/iwf4hqlchgvwZz7zygSRPW9bjYfsY8pQ2cM+dMJg3D13FsqivqLC
        jL04/+edQr2SEGIFrSZJf00iJJnm4ypZWUCTg1/htwRg1SNBBFOLdsx+Q6yH1UJnMjH940Nbcd9V8
        6a2JxPbw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60684)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nomYo-0006sj-CG; Wed, 11 May 2022 14:39:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nomYl-00079z-GQ; Wed, 11 May 2022 14:39:23 +0100
Date:   Wed, 11 May 2022 14:39:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Josua Mayer <josua@solid-run.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Message-ID: <Ynu8ixB5cm3zy6Yx@shell.armlinux.org.uk>
References: <20220509122938.14651-1-josua@solid-run.com>
 <Ynk5UPWkuoXeqfJj@shell.armlinux.org.uk>
 <bc461bd4-e123-212d-42a5-2da2efb7235a@solid-run.com>
 <20220511132221.pkvi3g7agjm2xuph@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511132221.pkvi3g7agjm2xuph@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 01:22:22PM +0000, Ioana Ciornei wrote:
> On Tue, May 10, 2022 at 12:44:41PM +0300, Josua Mayer wrote:
> 
> > One issue is that the interfaces don't have stable names. It purely depends
> > on probe order,
> > which is controlled by sending commands to the networking coprocessor.
> > 
> > We actually get asked this question sometimes how to have stable device
> > names, and so far the answer has been systemd services with explicit sleep
> > to force the order.
> > But this is a different topic.
> > 
> 
> Stable names can be achieved using some udev rules based on the OF node.
> For example, I am using the following rules on a Clearfog CX LX2:
> 
> [root@clearfog-cx-lx2 ~] # cat /etc/udev/rules.d/70-persistent-net.rules
> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="fsl_dpaa2_eth", ENV{OF_FULLNAME}=="/soc/fsl-mc@80c000000/dpmacs/ethernet@7", NAME="eth7"
> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="fsl_dpaa2_eth", ENV{OF_FULLNAME}=="/soc/fsl-mc@80c000000/dpmacs/ethernet@8", NAME="eth8"
> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="fsl_dpaa2_eth", ENV{OF_FULLNAME}=="/soc/fsl-mc@80c000000/dpmacs/ethernet@9", NAME="eth9"
> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="fsl_dpaa2_eth", ENV{OF_FULLNAME}=="/soc/fsl-mc@80c000000/dpmacs/ethernet@a", NAME="eth10"
> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="fsl_dpaa2_eth", ENV{OF_FULLNAME}=="/soc/fsl-mc@80c000000/dpmacs/ethernet@11", NAME="eth17"

Or by using systemd - for example, on the Armada 38x Clearfog platform,
I use:

/etc/systemd/network/01-ded.link:
[Match]
Path=platform-f1070000.ethernet
[Link]
MACAddressPolicy=none
Name=eno0

/etc/systemd/network/02-sw.link:
[Match]
Path=platform-f1030000.ethernet
[Link]
MACAddressPolicy=none
Name=eno1

/etc/systemd/network/03-sfp.link:
[Match]
Path=platform-f1034000.ethernet
[Link]
MACAddressPolicy=none
Name=eno2

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
