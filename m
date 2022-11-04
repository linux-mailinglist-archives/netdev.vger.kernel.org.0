Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D7A61A20E
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKDUTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKDUS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:18:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4224B9AC;
        Fri,  4 Nov 2022 13:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9EmpCQn2JtXjzKJNAAzmFElq0JAsPIVY4uXrTBDtmsw=; b=pGh5Zl03PPKgjEz9Gyg0OcWmFf
        23h/4RmeBesW47/gaD9RbCmgQK5jr++OTAF+ninARnOs3oU1mhY4sonVW1QCuwbuw2905Of9c7gaV
        DahXcIuQjTnFP07MLnlF33ZErOHrE71L+gnQAJmXHaRIy6FhbI1soqbuciRNCwXJ2vGd6iHCbCgYk
        4AX7AefOgmB5ATR/dBPS4jKSXKIxlcEq3Ge9Yb6kfVNaqXmd44FQTuSBrR9brXbl/xH9xFAEdY6Qi
        ue75A0DQeSWbyJU0IPCo9ep8wyHV+mQG6DicSE96+yTeBL6N72+GdrQ13fcLz1XR+14OzJqrFH4sQ
        N7pUkqKg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35116)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1or39L-00084d-6R; Fri, 04 Nov 2022 20:18:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1or39E-0001A3-MM; Fri, 04 Nov 2022 20:18:40 +0000
Date:   Fri, 4 Nov 2022 20:18:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Florian Fainelli <f.fainelli@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>, corbet@lwn.net,
        hkallweit1@gmail.com, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, moshet@nvidia.com,
        linux@rempel-privat.de, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next v5] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <Y2VzoD5uwW64yYgD@shell.armlinux.org.uk>
References: <20221104190125.684910-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104190125.684910-1-kuba@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 12:01:25PM -0700, Jakub Kicinski wrote:
> The previous attempt to augment carrier_down (see Link)
> was not met with much enthusiasm so let's do the simple
> thing of exposing what some devices already maintain.
> Add a common ethtool statistic for link going down.
> Currently users have to maintain per-driver mapping
> to extract the right stat from the vendor-specific ethtool -S
> stats. carrier_down does not fit the bill because it counts
> a lot of software related false positives.
> 
> Add the statistic to the extended link state API to steer
> vendors towards implementing all of it.
> 
> Implement for bnxt and all Linux-controlled PHYs. mlx5 and (possibly)
> enic also have a counter for this but I leave the implementation
> to their maintainers.

Hi Jakub,

I guess we'll need phylink to support this as well, so phylink using
drivers can provide this statistic not only for phylib based PHYs, but
also for direct SFP connections as well.

Thinking about the complexities of copper SFPs that may contain a PHY,
it seems to me that the sensible implementation would be for phylink
to keep the counter and not use the phylib counter (as that PHY may
be re-plugged and thus the count can reset back to zero) which I
suspect userspace would not be prepared for.

Russell.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
