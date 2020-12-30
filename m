Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B9E2E7AA4
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 16:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgL3Ps6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 10:48:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgL3Ps5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 10:48:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17F5F20575;
        Wed, 30 Dec 2020 15:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609343297;
        bh=YHufGG3AokDDJwfj0LlgBm3yCGwwV8pRMkMk3RZ2ZaE=;
        h=From:To:Cc:Subject:Date:From;
        b=oW8bFMQ97MBYUdhc0v4/ZygYifaGdHEJuWC97puhXx+qcn7QVPwroGwPyDK6f5Nb5
         wFnrAuNDDly7Fcgu8HdeiNzGb1yoD/rXS65eyJUlXkQ5pxMn0grhmbSwfLxRCNRHa7
         ql8qDJfPLpB8OoHHc7D5hlKgxyT2DzCp7aDdFrgUaqddPAvBFs5JKuy00Nb159oOUK
         Ydx+/abEZQ5KNFsk4qdU2dOwdrdZxLHdtECLSAy8L0WdP8UnBSlFywBOBzIfmRzSdd
         n9pbFqTPf1ntT0E+GACRCvQ9Btd7UeC6cr0vL/geT8//7kbFXICiKJgM9EWzWhCtqr
         9yjUhSNI5QHsQ==
Received: by pali.im (Postfix)
        id 9EA319F8; Wed, 30 Dec 2020 16:48:14 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] net: sfp: add support for GPON RTL8672/RTL9601C and Ubiquiti U-Fiber
Date:   Wed, 30 Dec 2020 16:47:51 +0100
Message-Id: <20201230154755.14746-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add generic workaround for reading EEPROM content from
broken GPON SFP modules based on Realtek RTL8672/RTL9601C chips and add
another workarounds for GPON SFP module Ubiquiti U-Fiber Instant.

GPON SFP modules based on Realtek RTL8672/RTL9601C chips do not have a
real EEPROM but rather EEPROM emulator which is broken and needs special
hack for reading its content.

SFP module detection is done based on EEPROM content. But we obviously
cannot read EEPROM correctly if we do not know what type of connected
SFP module... And to have this chicken and egg problem more complicated,
GPON vendors generally put garbage into their EEPROM content so even
with knowing EEPROM content we do not know what kind of broken SFP is
connected... Workaround for Realtek RTL8672/RTL9601C based modules is
therefore done based on broken EEPROM reading characteristic.

This patch series also available in my git branch sfp-rtl8672:
https://git.kernel.org/pub/scm/linux/kernel/git/pali/linux.git/log/?h=sfp-rtl8672

Pali Rohár (4):
  net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
  net: sfp: allow to use also SFP modules which are detected as SFF
  net: sfp: assume that LOS is not implemented if both LOS normal and
    inverted is set
  net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant

 drivers/net/phy/sfp-bus.c |  15 +++++
 drivers/net/phy/sfp.c     | 117 ++++++++++++++++++++++----------------
 2 files changed, 83 insertions(+), 49 deletions(-)

-- 
2.20.1

