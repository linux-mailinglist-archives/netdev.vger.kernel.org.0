Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2642604794
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiJSNlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiJSNl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:41:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3A411D99E;
        Wed, 19 Oct 2022 06:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=INKpDetnPumeR9xcGYn4Jhz0i4x5931DH0k2SGuMQMs=; b=tVFE5Jqhq+7wUCbZPou4JcvHHi
        cWnHv/LLxipwnSe4vnKvWBk6fgFwD0hbNYxbSeoQUNLeQqLNIpIKxIO4P+fx8H3AJsrgRuXXgTjVC
        ZxdILqPkp/SIeusvtReoknUmrT0YpBRBbhNVINeQ5xd5GjjNbQ+xrbY1eJgLCw336A2KkyUjXsov2
        lm95pG5Hh0Hr1JyWGQ/++zx3cBd85PcwBGyDIxoLzuED86uVi5wfDkqexO+DG25PPcSR6NhloVrWX
        eL5IP4QepQbvZSQ2oznltmZvCGyhU9NAzBDJJJOAnOmT9fv5CWtmIR1c8+unDpjyUm81zJ9TR15zS
        gXkwOIYQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34804)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ol97O-0005ip-Nz; Wed, 19 Oct 2022 14:28:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ol97M-0002Be-Te; Wed, 19 Oct 2022 14:28:20 +0100
Date:   Wed, 19 Oct 2022 14:28:20 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH net-next 0/7] net: sfp: improve high power module
 implementation
Message-ID: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
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

This series aims to improve the power level switching between standard
level 1 and the higher power levels.

The first patch updates the DT binding documentation to include the
minimum and default of 1W, which is the base level that every SFP cage
must support. Hence, it makes sense to document this in the binding.

The second patch enforces a minimum of 1W when parsing the firmware
description, and optimises the code for that case; there's no need to
check for SFF8472 compliance since we will not need to touch the
A2h registers.

Patch 3 validates that the module supports SFF-8472 rev 10.2 before
checking for power level 2 - rev 10.2 is where support for power
levels was introduced, so if the module doesn't support this revision,
it doesn't support power levels. Setting the power level 2 declaration
bit is likely to be spurious.

Patch 4 does the same for power level 3, except this was introduced in
SFF-8472 rev 11.9. The revision code was never updated, so we use the
rev 11.4 to signify this.

Patch 5 cleans up the code - rather than using BIT(0), we now use a
properly named value for the power level select bit.

Patch 6 introduces a read-modify-write helper.

Patch 7 gets rid of the DM7052 hack (which sets a power level
declaration bit but is not compatible with SFF-8472 rev 10.2, and
the module does not implement the A2h I2C address.)

Series tested with my DM7052.

 Documentation/devicetree/bindings/net/sff,sfp.yaml |  2 +
 drivers/net/phy/sfp.c                              | 85 +++++++++++-----------
 include/linux/sfp.h                                |  2 +
 3 files changed, 48 insertions(+), 41 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
