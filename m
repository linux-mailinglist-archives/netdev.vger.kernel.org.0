Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE604EC997
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348732AbiC3QUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244332AbiC3QUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:20:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AA853A42;
        Wed, 30 Mar 2022 09:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zJc1eRl6ZX+PM21DacLO5ggbRDvPjgeskpQKRLM6e4Q=; b=1EvFv5zDp3n/RX7SilfA0V0qBB
        Tq32mcmzQ+bNGZxbko8QqqdjPl7UKORNlqg7AXd++8Dj0A+0m6nE54aH7Cue1NxpCL5faUcsDXMhG
        a4FSbV+dIJjduBMkW/q+OtiGxi4fF4k5Svh7oGkUcJtDnSe2qsAZILl0hJkdq8D+Q5Tq2pDs4w9l5
        eCL/rf7Fqici8IuOB2oskUX+k47Bd+EtUA1zF5r1UJmzTs7TCxvpt0tktjF12clbFDr11imV0rb0Y
        dL0I/7W4IL38ww/SvEF8Vu94C6rJW4iWqt0YQsEFTaBwcXFal0zdStiILWS1rDE0HVnvywZkRFZEx
        JLBwZDCg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58014)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZb26-0003RH-Hd; Wed, 30 Mar 2022 17:18:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZb24-0006kx-Bv; Wed, 30 Mar 2022 17:18:52 +0100
Date:   Wed, 30 Mar 2022 17:18:52 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 2/5] net: phy: support indirect c45 access
 in get_phy_c45_ids()
Message-ID: <YkSC7CJ4OEFH69yU@shell.armlinux.org.uk>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-3-michael@walle.cc>
 <Yjt3hHWt0mW6er8/@lunn.ch>
 <43227d27d938fad8a2441363d175106e@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43227d27d938fad8a2441363d175106e@walle.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 11:14:11PM +0100, Michael Walle wrote:
> I actually had that. But mmd_phy_indirect() doesn't check
> the return code and neither does the __phy_write_mmd() it
> actually deliberatly sets "ret = 0". So I wasn't sure. If you
> are fine with a changed code flow in the error case, then sure.
> I.e. mmd_phy_indirect() always (try to) do three accesses; with
> error checks it might end after the first. If you are fine
> with the error checks, should __phy_write_mmd() also check the
> last mdiobus_write()?

The reason for that goes back to
commit a59a4d1921664da63d801ba477950114c71c88c9
    phy: add the EEE support and the way to access to the MMD registers.

and to maintain compatibility with that; if we start checking for
errors now, we might trigger a kernel regression sadly.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
