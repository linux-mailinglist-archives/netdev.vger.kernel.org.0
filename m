Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388536458DB
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiLGLWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiLGLV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:21:57 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A922AE3E;
        Wed,  7 Dec 2022 03:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VKfIZ8jyySPsQarwiJ7nK7I1JiZjo0stjyrVyrUEEiY=; b=ZhnMlGppE0Bj+Bf18ja/bEy35G
        2A8MUJqRvy+tY7HbuwHBcfxmt/LEgqiFw8K55WXlTsrqwK/sFjKfYS/N4FjUNsBQ9si2KlMy8GjEk
        FloDj3tQYrxrbJUY2EGQQ61YTsh0kHvhS37N6tCzdO8hxMT6cjGussLnMeenCLejigoT4gDuDYWDT
        htwvDx3Set0wkyHUWmLxTtjdiAlKCtDCLZGLZVLdzs5KViFcpFe3Dj0OOBDfjmrQEW5PAkRrh/9pN
        gG6YzbpS5rYLcI67NzoxU8aDopIxBIkEYwZ6SWxHpHbIe4aGVjAs+4GjJXDhcNejUa01pMyRsX/3y
        Yp/5zClQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35612)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p2sUo-0000Za-T6; Wed, 07 Dec 2022 11:21:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p2sUl-0000gl-Uq; Wed, 07 Dec 2022 11:21:47 +0000
Date:   Wed, 7 Dec 2022 11:21:47 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>
Subject: [PATCH RFC 0/2] Add I2C fwnode lookup/get interfaces
Message-ID: <Y5B3S6KZTrYlIH8g@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This RFC series is not intended for the coming merge window, and we
will need to decide how to merge it as it is split across two
subsystems. These patches have been generated against the net-next,
since patch 2 depends on a recently merged patch in that tree.

Currently, the SFP code attempts to work out what kind of fwnode we
found when looking up the I2C bus for the SFP cage, converts the fwnode
to the appropriate firmware specific representation to then call the
appropriate I2C layer function. This is inefficient, since the device
model provides a way to locate items on a bus_type by fwnode.

In order to reduce this complexity, this series adds fwnode interfaces
to the I2C subsystem to allow I2C adapters to be looked up. I also
accidentally also converted the I2C clients to also be looked up, so
I've left that in patch 1 if people think that could be useful - if
not, I'll remove it.

We could also convert the of_* functions to be inline in i2c.h and
remove the stub of_* functions and exports.

Do we want these to live in i2c-core-fwnode.c ? I don't see a Kconfig
symbol that indicates whether we want fwnode support, and I know there
are people looking to use software nodes to lookup the SFP I2C bus
(which is why the manual firmware-specific code in sfp.c is a problem.)

Thanks!

 drivers/i2c/i2c-core-acpi.c | 13 +-------
 drivers/i2c/i2c-core-base.c | 72 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/i2c/i2c-core-of.c   | 51 ++------------------------------
 drivers/net/phy/sfp.c       | 13 +-------
 include/linux/i2c.h         |  9 ++++++
 5 files changed, 86 insertions(+), 72 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
