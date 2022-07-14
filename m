Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFD5574DA6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238762AbiGNMcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 08:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239105AbiGNMcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 08:32:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0056E3CBCE;
        Thu, 14 Jul 2022 05:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CSm2gLf4QcOqQlzgrJqL/4ORE9QT/t9M29vo0z4hgk4=; b=0GXELlLUnCCO9kXFpy1+MwJ7J0
        Dz6QP7w4ncBpRiGBEJlBDtAWU9aywNwObKeofzSfJjk+JYzzoPslYhCYSnBaKvKpJf6ucwaW+G1fC
        Ml9uY6ENoO5yfYlnKdCDsQymYrAYOCOZDvncWSZ+cR5ffla44Y8umY0nfqi2SWUZ/f2y/DbI6QepN
        02N2yZwy2S3ts1dBMX8m5zEHf3K1aBWZuJicB/QNvSDwaB69KXivWNldnJH5/cr6csCYPZjwj9M3u
        H49T9Yv2+GFVWcIRxARh7Mp1sXSU2eyh/d1tLMsCGc/wwt53trDIgi+Y1GQsJ5bY1a6yqkD57NJhl
        zUDwgPUg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33334)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oBy0k-0005li-H5; Thu, 14 Jul 2022 13:32:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oBy0h-0006bb-VK; Thu, 14 Jul 2022 13:32:03 +0100
Date:   Thu, 14 Jul 2022 13:32:03 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jaz@semihalf.com,
        tn@semihalf.com
Subject: Re: [net-next: PATCH] net: dsa: mv88e6xxx: fix speed setting for
 CPU/DSA ports
Message-ID: <YtAMw7Sp06Kiv9PK@shell.armlinux.org.uk>
References: <20220714010021.1786616-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714010021.1786616-1-mw@semihalf.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 03:00:21AM +0200, Marcin Wojtas wrote:
> Commit 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX setting")
> stopped relying on SPEED_MAX constant and hardcoded speed settings
> for the switch ports and rely on phylink configuration.
> 
> It turned out, however, that when the relevant code is called,
> the mac_capabilites of CPU/DSA port remain unset.
> mv88e6xxx_setup_port() is called via mv88e6xxx_setup() in
> dsa_tree_setup_switches(), which precedes setting the caps in
> phylink_get_caps down in the chain of dsa_tree_setup_ports().
> 
> As a result the mac_capabilites are 0 and the default speed for CPU/DSA
> port is 10M at the start. To fix that execute phylink_get_caps() callback
> which fills port's mac_capabilities before they are processed.
> 
> Fixes: 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX setting")
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>

Please don't merge this - the plan is to submit the RFC series I sent on
Wednesday which deletes this code, and I'd rather not re-spin the series
and go through the testing again because someone else changed the code.

Marcin - please can you test with my RFC series, which can be found at:

https://lore.kernel.org/all/Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk/

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
