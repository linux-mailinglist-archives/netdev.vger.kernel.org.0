Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2678835E7E4
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 22:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbhDMU7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 16:59:15 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:59156 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232384AbhDMU7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 16:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding;
        bh=mgAretnIroX4eSjdE/I0qmhIN5UwcipFxlDQmSZMIr4=;
        b=KMu1XsZWszr9DpTmttTMMIfL2stkV0KcYzKR3mXrW7ACwSb081gT/ht4ivsNvyWubRX8gnW7sdaa2
         3RU04gqAISCfvl5AMMfY+y0nHMEyIo1HEQORuxi2f9oIxrBqgcR+bDWNtMlIjEDl9J2vdg38gFM5Jq
         ToJnRpGJfiLCGvcKGSeDdT2pkUIAXy7rhvy4dFTIvcOvchoXx+LsL/mAOBuSCExrnFNdpiq07RNBr6
         Xkh98aI3WeRY9nCJWtIPJ/4a2/B2soLnOFBMoeIEGeEVPrV/yaI3yVcMUbzAP+Z3O1amqSbbc8+Q4/
         ewesZbY/B0la0NGsNSq88iVdiy1cRIQ==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([178.70.223.189])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 13 Apr 2021 23:58:34 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, system@metrotek.ru,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/3] net: phy: marvell-88x2222: a couple of improvements
Date:   Tue, 13 Apr 2021 23:54:49 +0300
Message-Id: <cover.1618347034.git.i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First, there are some SFP modules that only uses RX_LOS for link
indication. Add check that link is operational before actual read of
line-side status.

Second, it is invalid to set 10G speed without autonegotiation,
according to phy_ethtool_ksettings_set(). Implement switching between
10GBase-R and 1000Base-X/SGMII if autonegotiation can't complete but
there is signal in line.

Changelog:
  v1 -> v2:
    * make checking that link is operational more friendly for
      trancievers without SFP cages.
    * split swapping 1G/10G modes into non-functional and functional
      commits for the sake of easier review.

Ivan Bornyakov (3):
  net: phy: marvell-88x2222: check that link is operational
  net: phy: marvell-88x2222: move read_status after config_aneg
  net: phy: marvell-88x2222: swap 1G/10G modes on autoneg

 drivers/net/phy/marvell-88x2222.c | 314 ++++++++++++++++++++----------
 1 file changed, 209 insertions(+), 105 deletions(-)

-- 
2.26.3


