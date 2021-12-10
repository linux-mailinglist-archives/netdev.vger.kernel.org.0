Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E4D46FF1D
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 11:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239669AbhLJK4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 05:56:38 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:7358 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239216AbhLJK4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 05:56:35 -0500
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BA3c4A2022193;
        Fri, 10 Dec 2021 05:52:28 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3cucqewvc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 05:52:28 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 1BAAqQ5f021130
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Dec 2021 05:52:27 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Fri, 10 Dec
 2021 05:52:26 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 10 Dec 2021 05:52:25 -0500
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 1BAAqLrA008399;
        Fri, 10 Dec 2021 05:52:23 -0500
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v4 0/7] net: phy: adin1100: Add initial support for ADIN1100 industrial PHY
Date:   Fri, 10 Dec 2021 13:05:02 +0200
Message-ID: <20211210110509.20970-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: Ifl6QP-eF_RvOQmXd9KCkdJpZOpY4Z3u
X-Proofpoint-GUID: Ifl6QP-eF_RvOQmXd9KCkdJpZOpY4Z3u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=782 impostorscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
industrial Ethernet applications and is compliant with the IEEE 802.3cg
Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.

The ADIN1100 uses Auto-Negotiation capability in accordance
with IEEE 802.3 Clause 98, providing a mechanism for
exchanging information between PHYs to allow link partners to
agree to a common mode of operation.

The concluded operating mode is the transmit amplitude mode and
master/slave preference common across the two devices.

Both device and LP advertise their ability and request for
increased transmit at:
- BASE-T1 autonegotiation advertisement register [47:32]\
Clause 45.2.7.21 of Standard 802.3
- BIT(13) - 10BASE-T1L High Level Transmit Operating Mode Ability
- BIT(12) - 10BASE-T1L High Level Transmit Operating Mode Request

For 2.4 Vpp (high level transmit) operation, both devices need
to have the High Level Transmit Operating Mode Ability bit set,
and only one of them needs to have the High Level Transmit
Operating Mode Request bit set. Otherwise 1.0 Vpp transmit level
will be used.

Settings for eth1:
	Supported ports: [ TP	 MII ]
	Supported link modes:   10baseT1L/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT1L/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT1L/Full
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 10Mb/s
	Duplex: Full
	Auto-negotiation: on
	master-slave cfg: preferred slave
	master-slave status: slave
	Port: Twisted Pair
	PHYAD: 0
	Transceiver: external
	MDI-X: Unknown
	Link detected: yes
	SQI: 7/7

1. Add basic support for ADIN1100.

Alexandru Ardelean (1):
  net: phy: adin1100: Add initial support for ADIN1100 industrial PHY

1. Added 10baset-T1L link modes.

2. Added 10-BasetT1L registers.

3. Added Base-T1 auto-negotiation registers. For Base-T1 these
registers decide master/slave status and TX voltage of the
device and link partner.

4. Added 10BASE-T1L support in phy-c45.c. Now genphy functions will call
Base-T1 functions where registers don't match, like the auto-negotiation ones.

5. Convert MSE to SQI using a predefined table and allow user access
through ethtool.

6. DT bindings for the 2.4 Vpp transmit mode.

Alexandru Ardelean (1):
  net: phy: adin1100: Add initial support for ADIN1100 industrial PHY

Alexandru Tachici (6):
  ethtool: Add 10base-T1L link mode entry
  net: phy: Add 10-BaseT1L registers
  net: phy: Add BaseT1 auto-negotiation registers
  net: phy: Add 10BASE-T1L support in phy-c45
  net: phy: adin1100: Add SQI support
  dt-bindings: net: phy: Add 10-baseT1L 2.4 Vpp

Changelog: V3 -> V4:
	- fixed kernel-doc errors
	- ETHTOOL_LINK_MODE_10baseT1L_Full_BIT of phydev->supported is now set inside
	in genphy_c45_pma_read_abilities() call if device supports 10BASE-T1L
	- fix 802.3 reg defines comments (kept documentation wording instead)
	- fix 0x0010 advertise master preference (T4) (instead of 0x0080)
	- added genphy_c45_baset1_read_lpa to phy-c45.c, will get called from genphy_c45_read_lpa,
	if the phy supports BASE-T1 advertisement register
	- added genphy_c45_baset1_read_link to phy-c45.c, will get called from genphy_c45_read_link,
	if the phy supports BASE-T1 registers
	- replaced adin_read_lpa from adin1100.c with genphy_c45_read_lpa
	- added support for BASE-T1 master/slave status and advertising in phy-c45.c
	- dropped yaml file (no need for it) no vendor specific properties to be added in the DT
	- moved most of the BASE-T1 specific code from adin1100.c to gen-phy-c45
	- changed an-10base-t1l-2.4vpp property name to phy-10base-t1l-2.4vpp
	- in adin1100.c, when auto-negotiation is disabled, if increased transmit property is set
	in DT (phy-10base-t1l-2.4vpp = <1>) force Tx PHY level to 2.4 vpp otherwise force
	to 1.0 vpp.
	- added 10BASE-T1L PMA control mdio.h

 .../devicetree/bindings/net/ethernet-phy.yaml |   9 +
 drivers/net/phy/Kconfig                       |   7 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/adin1100.c                    | 299 ++++++++++++++++++
 drivers/net/phy/phy-c45.c                     | 283 ++++++++++++++++-
 drivers/net/phy/phy-core.c                    |   3 +-
 include/linux/mdio.h                          |  70 ++++
 include/uapi/linux/ethtool.h                  |   1 +
 include/uapi/linux/mdio.h                     |  75 +++++
 net/ethtool/common.c                          |   3 +
 10 files changed, 744 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/phy/adin1100.c

--
2.25.1
