Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEAA438BB5
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 21:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhJXTut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 15:50:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55968 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232131AbhJXTuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 15:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=rYg2qWhvx09O6eDb85PmGe0kFFIEfXkWkBNCMMvGCBI=; b=CkJQ4ffBSUgVdqS0+RBXbUNBhd
        wVonR4eLMS6IgXRLxbWervBg5E5CoI7cbP3DxDOkDxZkATLLjmiOVA/InwzCeyHa8dEdVESRoqbT0
        hP1Z1GUVlbkXdKTbasQhdFM7RTnAQ5k8ti49sBvc7K5weNG2xRQHeaQZPkzTnzrXMkWQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mejTf-00BacX-5L; Sun, 24 Oct 2021 21:48:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Walter.Stoll@duagon.com,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 0/4] ksettings_{get|set} lock fixes
Date:   Sun, 24 Oct 2021 21:48:01 +0200
Message-Id: <20211024194805.2762333-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Walter Stoll <Walter.Stoll@duagon.com> reported a race condition
between "ethtool -s eth0 speed 100 duplex full autoneg off" and phylib
reading the current status from the PHY. Both ksetting_get and
ksetting_set fail the take the phydev mutex, and as a result, there is
a small window of time where the phydev members are not self
consistent.

Patch 1 fixes phy_ethtool_ksettings_get by adding the needed lock.
Patches 2 and 3 move code around and perform to refactoring, to allow
patch 4 to fix phy_ethtool_ksettings_set by added the lock.

Thanks go to Walter for the detailed origional report, suggested fix,
and testing of the proposed patches.

Andrew Lunn (4):
  phy: phy_ethtool_ksettings_get: Lock the phy for consistency
  phy: phy_ethtool_ksettings_set: Move after phy_start_aneg
  phy: phy_start_aneg: Add an unlocked version
  phy: phy_ethtool_ksettings_set: Lock the PHY while changing settings

 drivers/net/phy/phy.c | 140 ++++++++++++++++++++++++------------------
 1 file changed, 81 insertions(+), 59 deletions(-)

-- 
2.33.0

