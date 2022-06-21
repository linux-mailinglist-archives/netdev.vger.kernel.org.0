Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0175F552E5E
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 11:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348864AbiFUJcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 05:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348475AbiFUJcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 05:32:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BD913CF4
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7rn0FEztTcZeX3yVFikCDJPY96wnbpo2j7Mfp2KqOqQ=; b=Gb49gQChK+/ZSbohszMQ26XTqb
        Ouhniez6IMyfilpsygD6XLLEAyjIpIjIKQ1mlk3/+Ux3lrgCKCqlDFlMrOriBnlsYqxuPsPnhehZV
        tXEeFlMQ6KduqFlU8wBw+3wiYTzbJNqL3DTWhYvnmKa68V0FWIVhsJhoAnAwzSEN5xOjyVTl9J+Pa
        +8sIDga7XMAKbGMpcfhEWwKLU69ecOKYAZdAst6iMwdIAyG+emFqIpYFmbgOUA23J212IHBivexMq
        LH0mSr9Cs2f0UKD3OMZZ6FVbQWW4WJlys2WFPvff9x5MxmoYfLp9XHFjv92mHrg+IgAWCq1cbpjGN
        3TnMpVWA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32956)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o3aEj-00027w-4Q; Tue, 21 Jun 2022 10:31:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o3aEg-0005v2-My; Tue, 21 Jun 2022 10:31:50 +0100
Date:   Tue, 21 Jun 2022 10:31:50 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] net: dsa: mv88e6xxx: get rid of SPEED_MAX
Message-ID: <YrGQBssOvQBZiDS4@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series does two things:

1. it gets rid of mv88e6065_port_set_speed_duplex() which is completely
   unused (do we support this device? I couldn't find it in the tables
   in chip.c) This has a max speed of 200Mbps which we don't support.

2. get rid of the SPEED_MAX constant, which is used to configure a DSA
   or CPU port to their maximum speed during initialisation. We no
   longer need this as we can derive the maximum port speed from the
   mac_capabilities instead.

The reason for making this change is in preparation for phylink to be
used by DSA for CPU ports. This omission has come back to bite us with
the conversion of DSA drivers to phylink_pcs, since phylink_pcs won't
get used unless phylink is being used. Particularly with this driver,
it is very common for DT descriptions to omit the fixed-link details
which means "use maximum speed".

It will eventually be necessary to hoist the selection of "max speed"
into the DSA layer (trivial) and also have a way for the DSA driver
to tell the DSA layer which interface it should be using for these
ports.

 drivers/net/dsa/mv88e6xxx/chip.c | 39 +++++++++++++++++++++++++++++----------
 drivers/net/dsa/mv88e6xxx/chip.h |  3 +--
 drivers/net/dsa/mv88e6xxx/port.c | 36 ------------------------------------
 drivers/net/dsa/mv88e6xxx/port.h |  2 --
 4 files changed, 30 insertions(+), 50 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
