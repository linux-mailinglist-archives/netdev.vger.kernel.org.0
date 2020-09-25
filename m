Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EF12786E4
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgIYMT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:26 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:63262
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728148AbgIYMT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHgvfWQn7ClkMQNyaEoTDbUWP0Q0bqJDkLiAqEI7xZk5qoWDv/VTZgxpRbRSTHXvPyCcfQ0KLjC/fVw7IPaAggTOlIcvF5m95sEoLU/b29fEzOCZ1LclnI9AgYlCFr4x4G/IHmjKrl2JaDISqLv3PtdFUcj2FWG758g03oah/J89UhATfMQBeMMxnn7Ia3FAPeCagRreNeh3jzueFi6ub7Jfo6m4qoyK7saS/ku8Xix79h/o9jCEMfR64URAMWgLl5QIMJT5GqVXSiE4u6aPmxdP24f6e6h96LgTnn+PxRN85MPAqztLHUbgBp/+X2El0wt6jjGWeMYZn6kbjtLL1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Dcw/ZPUcH4tLI0X2/ymMrKwYdaAKoN2R9NTJQbZLu0=;
 b=lYuJInQcdM6ZpZXXKEf2pQ6lqKcnNEsSS53WHQsmyUqj7eTzN4LC08iZTd4PJE3bozoPpFG6APXBSl5zoAw17axSxpSB+twFc7mW4azDexY0GR20RlbZVfNt7dBqk8LsXwvuezRsF0pNq1TKVTQaZzP2dxhsU9yWkadPoVHZNxwiYC00GpdYdW3MgBMgFAfoGSB3P5u1q/GqBPQXGsNwL31vZlkDlZKOaiK3OGwVDke0eCNpMeDzGYYfDPBqinyRAcsEAVQfL0+jC3wW6n+QK3GOgIUhuXsLbpJi2IrXaOx3nujxXPhTMKgmC5Hge0YDfLWlLpwjVOm0DTctaeOYJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Dcw/ZPUcH4tLI0X2/ymMrKwYdaAKoN2R9NTJQbZLu0=;
 b=JhteAtXLqdJsv5bmdmov5QqWNqam3VlL+U5YxaOKUO/2YRDxL5Fo3XzxVvyczEKOeBOOx9n3WgJIf+veiW2gFS71ENeebJBvN0Nr8F2sccnze5v6X5LuB2V38W5KSt5iI6KE6SU/CrTB+kQvEFnH04b7SbSigjYsX+UKTRESZoI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:22 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 00/14] Offload tc-flower using VCAP chains
Date:   Fri, 25 Sep 2020 15:18:41 +0300
Message-Id: <20200925121855.370863-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:803:104::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VE1PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:803:104::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 12:19:21 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4f8b9a8e-1c1e-411b-16f5-08d8614d3bd4
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3550153A70B92D9CC7BFACE7E0360@VI1PR0402MB3550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RsQVTM9is3f/WzgZt5Kh2dU1VpGgQ0x8u+KDgujPpAD7UdQ830uQuG1BEMLEJdBY0G9iJ/C3PzeeTvinDQg+XIAwnPVHQ+NF7LqsLj+T4cgvnJOxz5n6Bnj5CFlPYsCjOSxzMzXSUqwBNfw3b1UIEUOUiaZ38y5j2DhnKz6+1gWnvuSd2UHns7D2aG5QTDnsWxL6UrtTHQUPC1zGqeHKGuBuYd9E081ufrzmKBxzWaf/TCObuJBab+UhSPUJIQDfmmMJP+4un3VADSMn0N4lniN96p9gNVeYHWD97WoevaNQ7/KzNkzNtWB25HhKU6p27jomY7qTKVMYaG0lhMXEWa6vAP9Av5K3elcox5GX2a+V6i4d4/YCuX0WxN6PGU6tbmIJKU+zhif5fg5jftSBMGhI8h3IikX6da1oP+YDC/hNLJxqC/IqH1uywQcIrUHkodRfSYbpI67G1HoV0CsztA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66946007)(66556008)(36756003)(26005)(4326008)(8676002)(956004)(2616005)(69590400008)(83380400001)(86362001)(66476007)(44832011)(52116002)(6916009)(6666004)(966005)(1076003)(6512007)(8936002)(6506007)(186003)(7416002)(5660300002)(6486002)(2906002)(316002)(478600001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1gKql2yGiqQeYdBf/RIaMwcT/pj4mvzHpCdztgIz/Qp4dWBLOeWhtlO1QThyzs0fiUtnctxTN9NTpgBP+jZB02EEJiTghq5wxW5JtAlpa+kBMR3nSDBHiF7B8YUChHoZe91yUMe2kdWWKcDKgJO6f0VyzQlG3bwChOpd8+mAhDft8CzSpRdlddJfXEKVna2DIt09Jeqll15HyU98HRIMMDPyMCP6WkwmzfsHwIdsmrA85IuzDLaCXF+VQb7+2kGjMwrMtDMEu/GB7oUSXBnXn/M2Ul5JDAu1Nuos4TrNUggqEaL8/6bwdI3Ck/g1PZyjBHvSAaA4DyrPuQx04m6F9DoIfzKMLX0Soa9zfR+Z4Rt0GgmOTjFTt9gcviqtQPDC1lkL8ZdnEWa8VCC8HoD5/WXHdw+kik4kxFSgMkhfDDEDeT68gU/XW03rEyG7t4D6tOI1ts3KCgDuRAfKyzLQSOvRfKUcgNDoCRTltIIVi+yAaW/lcs5jh3iquGPMCsrk7xt7j1+H/8fCTiolhFYavxtM8fQifhgnNbF1mxaI+nS2IBuCz16GlUjwSzLukLx81MVzjeppyloGeN//BOvIMTWunB5Iv/M7UrTz6BFt1W6NfrAoRXhwhJ1us9SrlLOMZbAKU2X/cZgcvp4IUq4jaQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8b9a8e-1c1e-411b-16f5-08d8614d3bd4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:21.9465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSP1RFECMrKDjvrFyR5ll3iR4tBFO+oz8UJo94T59BpixX0kFTwdwYOSd6MARemliOReLRjUWGlPgmjZQmXFZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the result of this discussion:
https://lkml.org/lkml/2020/6/2/203

RFC because there are still some TODO items:
- I haven't added VCAP fields to Ocelot and to Seville, mostly because I
  don't understand how to derive the ENTRY_WIDTH setting. Would
  appreciate some help there. I've only tested this on Felix.
- The selftests script is rather bare bones, not sure what to add to it
  to make it more comprehensive. Understanding that this is the go-to
  reference for any user, it would need to be pretty clear how the thing
  can be used.

Comments appreciated.

Vladimir Oltean (11):
  net: mscc: ocelot: introduce a new ocelot_target_{read,write} API
  net: mscc: ocelot: generalize existing code for VCAP
  net: mscc: ocelot: offload multiple tc-flower actions in same rule
  net: mscc: ocelot: add a new ocelot_vcap_block_find_filter_by_id
    function
  net: mscc: ocelot: look up the filters in flower_stats() and
    flower_destroy()
  net: mscc: ocelot: introduce conversion helpers between port and
    netdev
  net: mscc: ocelot: create TCAM skeleton from tc filter chains
  net: mscc: ocelot: only install TCAM entries into a specific lookup
    and PAG
  net: mscc: ocelot: relax ocelot_exclusive_mac_etype_filter_rules()
  net: mscc: ocelot: offload redirect action to VCAP IS2
  selftests: ocelot: add some example VCAP IS1, IS2 and ES0 tc offloads

Xiaoliang Yang (3):
  net: mscc: ocelot: change vcap to be compatible with full and quad
    entry
  net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP
    IS1
  net: mscc: ocelot: offload egress VLAN rewriting to VCAP ES0

 MAINTAINERS                                   |   1 +
 drivers/net/dsa/ocelot/felix.c                |  24 +-
 drivers/net/dsa/ocelot/felix.h                |   5 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        | 188 ++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c      |  27 +-
 drivers/net/ethernet/mscc/ocelot.c            |  11 +
 drivers/net/ethernet/mscc/ocelot.h            |   2 +
 drivers/net/ethernet/mscc/ocelot_flower.c     | 485 ++++++++++-
 drivers/net/ethernet/mscc/ocelot_io.c         |  17 +
 drivers/net/ethernet/mscc/ocelot_net.c        |  30 +
 drivers/net/ethernet/mscc/ocelot_s2.h         |  64 --
 drivers/net/ethernet/mscc/ocelot_vcap.c       | 794 ++++++++++++------
 drivers/net/ethernet/mscc/ocelot_vcap.h       |  98 ++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  27 +-
 include/soc/mscc/ocelot.h                     |  43 +-
 include/soc/mscc/ocelot_vcap.h                | 200 ++++-
 .../drivers/net/ocelot/test_tc_chains.sh      | 179 ++++
 17 files changed, 1800 insertions(+), 395 deletions(-)
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h
 create mode 100755 tools/testing/selftests/drivers/net/ocelot/test_tc_chains.sh

-- 
2.25.1

