Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC9331541C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhBIQlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:41:46 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:39879 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbhBIQlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:41:39 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1131D22FB3;
        Tue,  9 Feb 2021 17:40:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612888857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bwWb+OJP6s00/2x+yYPwF424Xe+3mxuWhgXwV0dqEeg=;
        b=XvNWSE1pmTHlqhMPNTpc3/btm+CjL8A1I829knxyMKcInonPbtxbMYTp9oHqsyZn3yIby2
        E7/TqhS7wt09qkycQ2F5mAWfYzj/raXlqr3s6rsEss0Lpmhm8d0C4r2PThc/U/wIgNndbP
        ll+dchniVzC8Y3O1Rh4ZS2RostVgX/Q=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/9] net: phy: icplus: cleanups and new features
Date:   Tue,  9 Feb 2021 17:40:42 +0100
Message-Id: <20210209164051.18156-1-michael@walle.cc>
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
  net: phy: icplus: add IP101A/IP101G model detection
  net: phy: icplus: don't set APS_EN bit on IP101G
  net: phy: icplus: select page before writing control register
  net: phy: icplus: add PHY counter for IP101G
  net: phy: icplus: add MDI/MDIX support for IP101A/G

 drivers/net/phy/icplus.c | 328 ++++++++++++++++++++++++++++++++-------
 1 file changed, 272 insertions(+), 56 deletions(-)

-- 
2.20.1

