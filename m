Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0A5336C0B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhCKGVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhCKGVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:21:05 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0612.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27921C061574;
        Wed, 10 Mar 2021 22:21:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ga1WsgQ1dus8ZHFdI6Fv1ktx8iFu2lIRNAehC9bGYhtE306qGiFgAW2zEpHgRu4f8co6Jd+XAVP6GGh1Z9OIIvLFLbDgJuM/4Ell3/DnYHGUOvpfU47gPRKSbpalt6im57jAiiQxcz+LO/CuD880G7C8veThDTpAFOSFOaQg/ppH0Bq+fJ5Oox+1MZ83dh67+Id2pY+Nyg8hUyFxbN7vyahc75KQNkbGXXQWUZYaHDkZzQhH6KkVzuFcWLSOUbZ2imUxLPT77tltgrJjmSQbAvnQuR7NhztgG3/6TAPv1dRJjbpvbqV5ieiYT3J39FV0ka5gKYcYKhHgn7DmVwzxNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoRnjbAindRW1u463l4Q+5r4qWTfHb/DewqTC/ACjj0=;
 b=i1GbrYU6NLMwRAVKZ4ehqaDeBtuVsZ/JNgkLQSdXoC/QvJxtozzUZAtF4HvvqABaEWHGJYHLcEfy2C2UUB37DITanpt49hBPx8/BBiE0aHkhcgNWz/Xwn8Ql4/xxth3Xylf9zzooxs2dCmwBA+QB9DYPtsY4bWfDBc9kGt5uiuRMm8Dk44/ZAtsfURI9vh4FqlBRJGs7M02NXneof3B+ysR+FwpOUI7y7T66Zot0A6SqEBl39OhTe7ta0xwooMnmQdP6Q5JGjmimkjh4B+Hpbo7M2Kzw/sNzmAGwVwwbJeLgExVgGaJkWlsXNbiy0fYTSC7jfzAmdl9xPKC2e3zorQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoRnjbAindRW1u463l4Q+5r4qWTfHb/DewqTC/ACjj0=;
 b=EhrKf+mJ9q+o2YQ3vuSTEVf+A+cWLj0uRe6QsCc5uFFmfeMAYIWOnpaGTGCkOiy46C3vOQDZvHvoncPtKmwQSMUuSYIOAIIreL9KmpnoAj091/hiDvcPcdPz67HVS5lwASxukMLqgyGGbAloNFVMTaslP5bJ+FeMie/KAb/6lJQ=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5473.eurprd04.prod.outlook.com (2603:10a6:208:112::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Thu, 11 Mar
 2021 06:20:43 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:20:43 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH v7 00/16] ACPI support for dpaa2 driver
Date:   Thu, 11 Mar 2021 11:49:55 +0530
Message-Id: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:20:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 592cf5bc-a881-4b4f-c467-08d8e455cc6f
X-MS-TrafficTypeDiagnostic: AM0PR04MB5473:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB54733A10EF751CF116088ACFD2909@AM0PR04MB5473.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:313;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Bu72NCsSbqCmtIdub9/ks5BIQpRpcixZnHV78E1D+PJ0URh2/3IiewHZA01FSyo1EulDmTeYqaG4tjXNB4fB7aAL6NWMhqDdkQseb7DLsnsnhN8cF53iF/LHktty8cCd/Xp/wLmPWKaJo73hi1gAZV+C7RY5RjKqCSh7Fz3fpDYyRQVAWXYMJA2DcN0Wk7QIAjf1CuQmpXm2vYfn4c9P8SKBXxjeKGr8sffAoFiiqu/sUywiDdZlcpymj0olzE8qNguyK2mra25QUmAfRa7YNb+FsqssiWNEBr0CtJcUFhUlJbKP5Xie4c1yatWbvwIeTzOLE6PMd2j+DUpECCyRiG30Xmg4lKuzrl1oOl0O1U0+3yX/abaLMoPCr84kzJskv3WvXK2SS3BByZIrdQcMb+BiAMuERQ3FVS6gNoQuioBMcHkaaYPLxc6sWq0/Jcrlk410z13HZsRkiogA4XJf/M260ux/EIkqsC3NOK+qa85CRaBM/V+8gg9Ajqp9EzcDns+BgZjeCns04EhvnizJQwPiUJ5fVhpPCqSjofzV00BTjmLHDX6NsZFQLZUhrWlJPrUJLN97/cLwxt0feAT7J09bUhzo408R3/BUbhFVCY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(44832011)(186003)(54906003)(66476007)(52116002)(5660300002)(110136005)(1076003)(66946007)(2906002)(316002)(16526019)(6666004)(6486002)(921005)(4326008)(478600001)(83380400001)(6506007)(26005)(2616005)(6512007)(8936002)(7416002)(55236004)(1006002)(8676002)(86362001)(66556008)(956004)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0xBhXTXgJ5jFGhDCN92Wbw8rguxqGW2+wsVnitCf/Yc0xXd6Q+ecbrZS/uee?=
 =?us-ascii?Q?VzUg+sDbx0SoXgM4j+H57z2Q8is1R4Gr/r1ZaJ4yfmRmP6EaOTwOvzkF6exj?=
 =?us-ascii?Q?eKCZGFMHqI2ZkIVT7VA2LWe17YnRAXkkkWqJEld+4cr6wUxs+WbdP+lhssle?=
 =?us-ascii?Q?vmJRSTpWzlam679pkNuQLIAD79nRwnTBZcoVGgEEHeKy3+etfu03dXUNAGHd?=
 =?us-ascii?Q?S+Ptb791pABCnePHO5t/+6DhWUj1pGNEuKCOjwf4WKb9Xo70pbjVQUvJY1ei?=
 =?us-ascii?Q?PYjSFppOO5ZE0py/fyQPmM3XKBt3cfaUsiVeMA+nAWNonN0yQAEWj3WVMaTP?=
 =?us-ascii?Q?7xKzWN6Y479VGFn3AmgSaOWKRoVsFCXF9V+2zgM5ecc9KvZoG01Nte0Qbm7p?=
 =?us-ascii?Q?HEcAPWCwOCHu0GdcgctnKJVQnV5xaLPXktz9J6B9cvfjkSx0ky7u4wYJlbiu?=
 =?us-ascii?Q?M8TZbpkWey863OnHEytm1gV6cQ2tOvfpnno84OHI11tsZUtq52NIvP0DfThJ?=
 =?us-ascii?Q?a9NpyRK7LG99YZlxwjSWNyc5VJWqGtbkrJ+uaKh/Qk+b248SbuZ8oVZK1MP8?=
 =?us-ascii?Q?5LxmkwESVFyyq04uY4htXfWdl6is4bbUNs5yxsD9J02iINB5gzX0Z4qcmzdb?=
 =?us-ascii?Q?QE1zWIeF02wnM2YIRSl/qdmpLZHO/540AJ+DOf1Le//U4LQjMqH4JZuhWQVY?=
 =?us-ascii?Q?84zfBxxS2eStuEakb+8N9Gq0eelhwascGCwhPqJOIqv+V8bZHg0WEdKz43+F?=
 =?us-ascii?Q?htlMlbAqmXLU3b9we0TwqRrqJu49QAzlY4ybbzJfHb6j7NVRABTxfyKPFKSX?=
 =?us-ascii?Q?sZRIUbwSsCQlC/LUg58kOtvkxLo4GqesGnAnpxXIiQguZBavFIQ/umr9nFZo?=
 =?us-ascii?Q?iaIt9C05TX7Gfl1ruLrySLR9jF8TRWC9P6+wQW07ngEKxU6hxjcJuqAQWJ2g?=
 =?us-ascii?Q?1oQucNdNowCsMBk/w9ah/XvvSQGONgE9c12Acl4kUAeXcQYHlUnAtmhv41zs?=
 =?us-ascii?Q?1Cas7tdIxr3fOaAJU+Vg8twKvMDbIpwrR2PHKZN8nj5ZziKcZl8yGALEvUkd?=
 =?us-ascii?Q?CrJa/K0DTeJ2aWzYYQs/WJ2dbLp19HBC1UK1udxh091aGw2+jFeuaUabo4Fh?=
 =?us-ascii?Q?JqRv+Mv9g7+YODl0uR1VecNRZNN1WJvNS1d7Qe5xIILZz+HJJ49k8m7Z36nQ?=
 =?us-ascii?Q?vucHM9m5z9TBhAspGxZiD0ucIZeImv/vJeiczWMx1/A41swIGxq0kBRJzLFX?=
 =?us-ascii?Q?pHhCABN4elqoIYrKTp2y6j0Yanla+fQCtpP8bu5r/voYCGSoNEybsL/O88al?=
 =?us-ascii?Q?IGcesVhcbB2GS0/wJbrkI94r?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 592cf5bc-a881-4b4f-c467-08d8e455cc6f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:20:43.0332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYgzgwiF7jAFavj1qQ5chW6bQMDEWOkxc0xbrG4dLmMR+jf1f3ydhhhIOEwUMXZntcfZdqAWISmHK6nqGEpmzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5473
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch set provides ACPI support to DPAA2 network drivers.

It also introduces new fwnode based APIs to support phylink and phy
layers
    Following functions are defined:
      phylink_fwnode_phy_connect()
      fwnode_mdiobus_register_phy()
      fwnode_mdiobus_register()
      fwnode_get_phy_id()
      fwnode_phy_find_device()
      device_phy_find_device()
      fwnode_get_phy_node()
      fwnode_mdio_find_device()
      acpi_get_local_address()

    First one helps in connecting phy to phylink instance.
    Next three helps in getting phy_id and registering phy to mdiobus
    Next two help in finding a phy on a mdiobus.
    Next one helps in getting phy_node from a fwnode.
    Last one is used to get local address from _ADR object.

    Corresponding OF functions are refactored.

Tested-on: LX2160ARDB


Changes in v7:
- correct fwnode_mdio_find_device() description
- check NULL in unregister_mii_timestamper()
- Call unregister_mii_timestamper() without NULL check
- Create fwnode_mdio.c and move fwnode_mdiobus_register_phy()
- include fwnode_mdio.h
- Include headers directly used in acpi_mdio.c
- Move fwnode_mdiobus_register() to fwnode_mdio.c
- Include fwnode_mdio.h
- Alphabetically sort header inclusions
- remove unnecassary checks

Changes in v6:
- Minor cleanup
- fix warning for function parameter of fwnode_mdio_find_device()
- Initialize mii_ts to NULL
- use GENMASK() and ACPI_COMPANION_SET()
- some cleanup
- remove unwanted header inclusion
- remove OF check for fixed-link
- use dev_fwnode()
- remove useless else
- replace of_device_is_available() to fwnode_device_is_available()

Changes in v5:
- More cleanup
- Replace fwnode_get_id() with acpi_get_local_address()
- add missing MODULE_LICENSE()
- replace fwnode_get_id() with OF and ACPI function calls
- replace fwnode_get_id() with OF and ACPI function calls

Changes in v4:
- More cleanup
- Improve code structure to handle all cases
- Remove redundant else from fwnode_mdiobus_register()
- Cleanup xgmac_mdio_probe()
- call phy_device_free() before returning

Changes in v3:
- Add more info on legacy DT properties "phy" and "phy-device"
- Redefine fwnode_phy_find_device() to follow of_phy_find_device()
- Use traditional comparison pattern
- Use GENMASK
- Modified to retrieve reg property value for ACPI as well
- Resolved compilation issue with CONFIG_ACPI = n
- Added more info into documentation
- Use acpi_mdiobus_register()
- Avoid unnecessary line removal
- Remove unused inclusion of acpi.h

Changes in v2:
- Updated with more description in document
- use reverse christmas tree ordering for local variables
- Refactor OF functions to use fwnode functions

Calvin Johnson (16):
  Documentation: ACPI: DSD: Document MDIO PHY
  net: phy: Introduce fwnode_mdio_find_device()
  net: phy: Introduce phy related fwnode functions
  of: mdio: Refactor of_phy_find_device()
  net: phy: Introduce fwnode_get_phy_id()
  of: mdio: Refactor of_get_phy_id()
  net: mii_timestamper: check NULL in unregister_mii_timestamper()
  net: mdiobus: Introduce fwnode_mdiobus_register_phy()
  of: mdio: Refactor of_mdiobus_register_phy()
  ACPI: utils: Introduce acpi_get_local_address()
  net: mdio: Add ACPI support code for mdio
  net: mdiobus: Introduce fwnode_mdiobus_register()
  net/fsl: Use fwnode_mdiobus_register()
  net: phylink: introduce phylink_fwnode_phy_connect()
  net: phylink: Refactor phylink_of_phy_connect()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++++
 MAINTAINERS                                   |   2 +
 drivers/acpi/utils.c                          |  14 ++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  84 ++++++-----
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  22 +--
 drivers/net/mdio/Kconfig                      |  16 +++
 drivers/net/mdio/Makefile                     |   4 +-
 drivers/net/mdio/acpi_mdio.c                  |  56 ++++++++
 drivers/net/mdio/fwnode_mdio.c                |  98 +++++++++++++
 drivers/net/mdio/of_mdio.c                    |  80 +----------
 drivers/net/phy/mii_timestamper.c             |   3 +
 drivers/net/phy/phy_device.c                  | 109 +++++++++++++-
 drivers/net/phy/phylink.c                     |  41 ++++--
 include/linux/acpi.h                          |   7 +
 include/linux/acpi_mdio.h                     |  25 ++++
 include/linux/fwnode_mdio.h                   |  29 ++++
 include/linux/of_mdio.h                       |   6 +-
 include/linux/phy.h                           |  31 ++++
 include/linux/phylink.h                       |   3 +
 19 files changed, 631 insertions(+), 132 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 drivers/net/mdio/fwnode_mdio.c
 create mode 100644 include/linux/acpi_mdio.h
 create mode 100644 include/linux/fwnode_mdio.h

-- 
2.17.1

