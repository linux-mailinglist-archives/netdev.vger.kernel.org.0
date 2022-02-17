Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FE84B9CE8
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239085AbiBQKR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:17:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiBQKRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:17:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF181403C
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k36v3cyZ5MNpIiVDzpZ9eHcfAKkV3Ub4amGededqOjI=; b=iccG7UGiX/i5P44JT3ls1eSjMK
        vClDMr2GnuDhqderylZ5V8RECSavaqHiHzSEttdduWrkqddX3CEezXqPUUgzH4ttvlPNtPPl5Rt9t
        +T32645V5WQAYLLDyAz4zv8NSxNzD8ePrxGmwpkgrQkwVAJyhF3EWD/iynwuba+L34T7IV8pWMelk
        XYb2R/9GC0903CZlT6M+dDv7V7xuyXv2WXT0K/REyQhq1VT6FxkweBu4qcIaT9ftqps3qprgZwoGX
        0QH5DzbCWZKyoQIS+7VQrpnAVKQFjXptx6IWYinNwURLVZmdzPBVuyhC3vPjBDF3muRXH0f3ELU7S
        bZjhmLjw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57300)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nKdqU-0004nQ-MZ; Thu, 17 Feb 2022 10:17:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nKdqT-0000z3-7W; Thu, 17 Feb 2022 10:17:05 +0000
Date:   Thu, 17 Feb 2022 10:17:05 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 2/5] net: dsa: b53: populate
 supported_interfaces and mac_capabilities
Message-ID: <Yg4goY/jGmVfTrkv@shell.armlinux.org.uk>
References: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
 <E1nFdPN-006Wh6-LC@rmk-PC.armlinux.org.uk>
 <6c6c8a56-fb78-214b-ed85-999bb76680f7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c6c8a56-fb78-214b-ed85-999bb76680f7@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 11:51:49AM -0800, Florian Fainelli wrote:
> On 2/3/22 6:48 AM, Russell King (Oracle) wrote:
> > Populate the supported interfaces and MAC capabilities for the Broadcom
> > B53 DSA switches in preparation to using these for the generic
> > validation functionality.
> > 
> > The interface modes are derived from:
> > - b53_serdes_phylink_validate()
> > - SRAB mux configuration
> > 
> > NOTE: much of this conversion is a guess as the driver doesn't contain
> > sufficient information. I would appreciate a thorough review and
> > testing of this change before it is merged.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> This patch breaks with the following:
> 
> [    2.680318] b53-srab-switch 18036000.ethernet-switch sfp
> (uninitialized): failed to validate link configuration for in-band status
> [    2.692470] error creating PHYLINK: -22
> [    2.696441] b53-srab-switch 18036000.ethernet-switch sfp
> (uninitialized): error -22 setting up PHY for tree 0, switch 0, port 5
> 
> Adding more debug shows us the following:
> 
> [    2.804854] phylink_validate: unable to find a mode for 4
> 0000000,000001ff,0060004c
> [    2.812807] phylink_validate: unable to find a mode for 4
> 0000000,000001ff,0060004c
> [    2.820733] b53-srab-switch 18036000.ethernet-switch sfp
> (uninitialized): failed to validate link configuration for in-band status
> [    2.832868] error creating PHYLINK: -22
> 
> 4 = PHY_INTERFACE_MODE_SGMII and the config->supported_interfaces bitmap
> is printed. If we add this hunk, you entire patch set works again:
> 
> @@ -178,10 +180,14 @@ void b53_serdes_phylink_get_caps(struct b53_device
> *dev, int port,
>                 __set_bit(PHY_INTERFACE_MODE_1000BASEX,
>                           config->supported_interfaces);
>                 config->mac_capabilities |= MAC_1000FD;
> +               __set_bit(PHY_INTERFACE_MODE_SGMII,
> +                         config->supported_interfaces);
>                 break;
>         default:
>                 break;
>         }

Thanks, added, and I've updated the comment as well just above the first
line of the above hunk to be consistent with the code.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
