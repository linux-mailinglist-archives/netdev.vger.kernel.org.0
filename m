Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA1E6BB66A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjCOOqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjCOOql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:46:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57A38FBEA
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RcLn+Lx31wzZJnZ/k4I59D1WZ4nRJxyNY/jYd2XJUQE=; b=A/3p1bkGjnN6bxTxKe5QVxE4FT
        3AgQC/KPRxkdVU1f+nX9fSqN5PN9S9pKW8OHi/RcDPY8p7ygSbCrazcWE14XUuHHwGVUcP/1hrHMQ
        Et/jAXOopIVQFP5zrNzinqk9wJEbQJf+djlrQ110VSwQZTKoMXk4O+NL6n4wdOn0xpcYVHsX1hL+j
        r01dX52Nes44aGu/dfv4A7588+J7ca4X5bU7xS1EwWzGSmkn0XlCo1gp28Krv+xxglz8XXQ8VlH5y
        9IvKtMM67b2jRSfUbtqN0gdXU7eCHZ41fJOhnTa8mvLz4E+ZZVZkSXc6lXs9dZETkp1Jpt+xm16z1
        Hcqjh0Cg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33502)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pcSOa-0007MG-CN; Wed, 15 Mar 2023 14:46:28 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pcSOW-0001Tj-QZ; Wed, 15 Mar 2023 14:46:24 +0000
Date:   Wed, 15 Mar 2023 14:46:24 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan McDowell <noodles@earth.li>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/2] Minor fixes for pcs_get_state() implementations
Message-ID: <ZBHaQDM+G/o/UW3i@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series contains a number fixes for minor issues with some
pcs_get_state() implementations, particualrly for the phylink
state->an_enabled member. As they are minor, I'm suggesting we
queue them in net-next as there is follow-on work for these, and
there is no urgency for them to be in -rc.

Just like phylib, state->advertising's Autoneg bit is a copy of
state->an_enabled, and thus it is my intention to remove
state->an_enabled from phylink to simplify things.

This series gets rid of state->an_enabled assignments or
reporting that should never have been there.

 drivers/net/pcs/pcs-lynx.c |  4 ++--
 drivers/net/pcs/pcs-xpcs.c | 13 ++-----------
 2 files changed, 4 insertions(+), 13 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
