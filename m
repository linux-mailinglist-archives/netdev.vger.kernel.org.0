Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF66142914C
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242968AbhJKORK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:17:10 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:28382 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243978AbhJKONb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:13:31 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19B2tTL5000693;
        Mon, 11 Oct 2021 10:11:07 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 3bm7b1c0jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 10:11:06 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 19BEB5KQ034949
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Oct 2021 10:11:05 -0400
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX8.ad.analog.com (10.64.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 11 Oct 2021 10:11:04 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 11 Oct 2021 10:11:04 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.858.5 via Frontend
 Transport; Mon, 11 Oct 2021 10:11:04 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 19BEAxn4020418;
        Mon, 11 Oct 2021 10:11:01 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v3 0/8] net: phy: adin1100: Add initial support for ADIN1100 industrial PHY
Date:   Mon, 11 Oct 2021 17:22:07 +0300
Message-ID: <20211011142215.9013-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: QZU3HRkF89ezPqvXJd9KGQi5R4uX1ICr
X-Proofpoint-ORIG-GUID: QZU3HRkF89ezPqvXJd9KGQi5R4uX1ICr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=525 impostorscore=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110082
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

Ethtool output:
        Settings for eth1:
        Supported ports: [ TP	 MII ]
        Supported link modes:   10baseT1L/Full
        Supported pause frame use: Transmit-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT1L/Full
        Advertised pause frame use: Transmit-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  10baseT1L/Full
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 10Mb/s
        Duplex: Full
        Auto-negotiation: on
        master-slave cfg: preferred master
        master-slave status: master
        Port: MII
        PHYAD: 0
        Transceiver: external
        Link detected: yes
	SQI: 7/7

1. Add basic support for ADIN1100.

Alexandru Ardelean (1):
  net: phy: adin1100: Add initial support for ADIN1100 industrial PHY

1. Added 10baset-T1L link modes.

2. Added 10-BasetT1L registers that are used in ADIN1100 driver.

3. Added BaseT1 auto-negotiation registers. For ADIN1100 these
registers decide master/slave status and TX voltage of the
device and link partner.

4. Allow user to set the master-slave configuration of ADIN1100.

5. Convert MSE to SQI using a predefined table and allow user access
through ethtool.

6. DT bindings for the 2.4 Vpp transmit mode.

7. DT bindings for ADIN1100.

Alexandru Tachici (7):
  ethtool: Add 10base-T1L link mode entry
  net: phy: Add 10-BaseT1L registers
  net: phy: Add BaseT1 auto-negotiation registers
  net: phy: adin1100: Add ethtool master-slave support
  net: phy: adin1100: Add SQI support
  dt-bindings: net: phy: Add 10-baseT1L 2.4 Vpp
  dt-bindings: adin1100: Add binding for ADIN1100 Ethernet PHY

Changelog V2 -> V3:
 - removed unused defines
 - dropped 1 V 2.4 V voltage link entries (will add these features in a separate patch)
 - dropped extra PHY stats, will add them in a separate patch
(adin1200/1300 will need rework too as it implements same stats)
 - added PMA status register and PCS control register in mdio.h (registers specified in 802.3gc)
 - added auto-negotiation advertisement and link partner registers in mdio.h
(Registers specified in 802.3 2018)
 - added 10base-t1l-2.4vpp tristate property to ethernet-phy yaml
 - replaced standard registers defines in adin1100.c with the ones added to mdio.h

 .../devicetree/bindings/net/adi,adin1100.yaml |  30 ++
 .../devicetree/bindings/net/ethernet-phy.yaml |   9 +
 drivers/net/phy/Kconfig                       |   7 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/adin1100.c                    | 403 ++++++++++++++++++
 drivers/net/phy/phy-core.c                    |   3 +-
 include/uapi/linux/ethtool.h                  |   1 +
 include/uapi/linux/mdio.h                     |  56 +++
 net/ethtool/common.c                          |   3 +
 9 files changed, 512 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1100.yaml
 create mode 100644 drivers/net/phy/adin1100.c

--
2.25.1
