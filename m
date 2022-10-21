Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158B4607A1B
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiJUPIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiJUPIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:08:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FC826103;
        Fri, 21 Oct 2022 08:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GOAGy8/6xEfh0KekibQjm9pbCbT1mmXCmKJqDE3M+nU=; b=Zfe9ZmaGlXLOWHC+DwN0yNa/XH
        fAL/I3Z4TCUwg0WZe0TpNZJJ1y8gRnSX4SPYhbjTezVmWNgI/N6VnKMPGjQ5ILgDUkVkX559yxY9u
        3XNCpoQjU1cALZLH+fhwahtxWptUFQ+GXayvt3GpAJTrQWqXaEzLCy5LijSBE5Wyroo6CTOzJ6dmM
        3NMg93OBMoRMUfMdHtZeUuSp0iRyvVqTRmxOMxMiKsrKNz+3etVLyAmNisF5jDxwDdi6KmWnpr9xA
        5IzvMnB4t98ZenN6G0Y3aVDibxFKQV2Lm4vvWTteaMuOvv/hakF/jwtlNjVYHlEV+3nLh8M/kC9Fb
        miAL2j7A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34868)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oltdQ-0000Ln-2P; Fri, 21 Oct 2022 16:08:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oltdN-0004FO-Ne; Fri, 21 Oct 2022 16:08:29 +0100
Date:   Fri, 21 Oct 2022 16:08:29 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH net-next v2 0/7] net: sfp: improve high power module
 implementation
Message-ID: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

v2: update sff.sfp.yaml with Rob's feedback

 Documentation/devicetree/bindings/net/sff,sfp.yaml |  3 +-
 drivers/net/phy/sfp.c                              | 85 +++++++++++-----------
 include/linux/sfp.h                                |  2 +
 3 files changed, 48 insertions(+), 42 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
