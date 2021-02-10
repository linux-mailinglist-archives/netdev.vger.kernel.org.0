Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A0D316BAC
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhBJQtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:49:18 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:34623 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbhBJQsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:48:42 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6474522FB3;
        Wed, 10 Feb 2021 17:47:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612975676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=taQ9ZDXzhRhp/CcYP3gEH20xljinVs76d11A1gR7cew=;
        b=X51IBq6MjkTgRAu2HK7S4uFyCiNhixgtuHtzN99mNdXcDajwB4jWOS0F9oL3TXPp6NL94M
        bibb5KyNtdfg7CHes7KtsCc7aRF1Ez8F33zIQzCzQFrOfS8KchxBYJsizuG8YFUBqpkuC5
        P8Ai0XFDBkDde6umC9L+nWXSW4l5/Eg=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 0/9] net: phy: icplus: cleanups and new features
Date:   Wed, 10 Feb 2021 17:47:37 +0100
Message-Id: <20210210164746.26336-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanup the PHY drivers for IPplus devices and add PHY counters and MDIX
support for the IP101A/G.

Patch 5 adds a model detection based on the behavior of the PHY.
Unfortunately, the IP101A shares the PHY ID with the IP101G. But the latter
provides more features. Try to detect the newer model by accessing the page
selection register. If it is writeable, it is assumed, that it is a IP101G.

With this detection in place, we can now access registers >= 16 in a
correct way on the IP101G; that is by first selecting the correct page.
This might previouly worked, because no one ever set another active page
before booting linux.

The last two patches add the new features.

Michael Walle (9):
  net: phy: icplus: use PHY_ID_MATCH_MODEL() macro
  net: phy: icplus: use PHY_ID_MATCH_EXACT() for IP101A/G
  net: phy: icplus: drop address operator for functions
  net: phy: icplus: use the .soft_reset() of the phy-core
  net: phy: icplus: split IP101A/G driver
  net: phy: icplus: don't set APS_EN bit on IP101G
  net: phy: icplus: fix paged register access
  net: phy: icplus: add PHY counter for IP101G
  net: phy: icplus: add MDI/MDIX support for IP101A/G

 drivers/net/phy/icplus.c | 378 ++++++++++++++++++++++++++++++++-------
 1 file changed, 318 insertions(+), 60 deletions(-)

-- 
2.20.1

