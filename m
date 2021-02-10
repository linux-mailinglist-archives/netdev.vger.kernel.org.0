Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA823171FD
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhBJVJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbhBJVJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:09:01 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC104C061786;
        Wed, 10 Feb 2021 13:08:18 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7B4FF22FB3;
        Wed, 10 Feb 2021 22:08:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612991297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mZhBvp+WKL1GjGYg/cC0hhNjKILLfx3wgilGDLxX5RQ=;
        b=lfMfvfkvrZvNt3x2iDRGZtfgMAXVzTTzSOQZq1aCNOFmfpc3I4+wium9w+OOc08GCfOgz8
        BA0soO9uaTfaRIUcVLJH4BUFbwXNacJbl/bF7AL3Mtm+nz1NZlCZzKzlK092C4j9dp8VeP
        lJ8k+KcRFXnz9BdMH8BlW2OqKP/DDIA=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 0/9] net: phy: icplus: cleanups and new features
Date:   Wed, 10 Feb 2021 22:08:00 +0100
Message-Id: <20210210210809.30125-1-michael@walle.cc>
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
 1 file changed, 317 insertions(+), 61 deletions(-)

-- 
2.20.1

