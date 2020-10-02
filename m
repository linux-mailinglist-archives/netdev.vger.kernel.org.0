Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF322811EB
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387652AbgJBMDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:03:02 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:10595
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbgJBMDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:03:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z19C6A0BwqgdivhcRlqp1ALC77uEAgEUQsmHFwmoTy1yAb6zJBqVNqfG7xV+DEu6s5ckrNun+36J/xUCW8Wf3yxRtFPpWkBx8k12NnnZ8Ofjbzc/kdkyPzzMa56Jwfh021+OKlVQQWiivD7rfqOCfkXhMPuRL4+ShsSIOEEFiU5oah5D4rAfjW/vMwDLXYazgsQTbce/TbVxPlWIgtWev+xJ6cWGvp99HPiHFDgZvl/xWOm7pAlFmJDAq4dHyuzhjK/h54BLd0eYmhIbgc4oQE4OTqb7Ue5/sArng6A2Op5ZtrzQpyS7cEirXN6SpSbpXedDrhkRvZlrjNA0c4sxcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWAF3hIO0UlAnClyMzuKE6ebt7x8oegyyphALESOQcI=;
 b=dmnThwxJzHJc+FP4cZqDq2hCgb2OB5KLHN66/b934eWPF+5cATLHHJ6f1TVPjMne5rq3ah3hsJVO26o5iCW+rqNj8UHrGrrYY9n9ke/+ng5g/y8Tn+0UvujCu3U5WXWVyrSxwEs5Fp7tw9+1jlatZh3FTH26ZA2hixs+01hXPmeN8irVkS6YdraMFtcKZFMIyijb1Ia0n/gIBHVrlKV4UZBldGCxqmVl74gD9zlSKnEnejYkDMADs5lHx8wF4QF/47T8Gg1rx16ks1nQtrGYJLBuYPRgDRhzQCpxm0Bymr0OlQxZn2/4CVWOnENPTnYiLZrVXHA8D4wLHvNmT+w5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWAF3hIO0UlAnClyMzuKE6ebt7x8oegyyphALESOQcI=;
 b=UUlV8f/OX8jU+iM+vEkHf0SndiTzNOQ+/8lsgpC0g5Z/52aY3ZU1Y1/E9o9v6xAEC20w4NpCLpnTHkbo7aTme+wLcBxLmMn2wVUc5oV3ruEL0zFWL4oCnpC1tRm2C/sRs73quLwCb6+AAisMQWaLZYOsH85gxoCtumATRlOtN3M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Fri, 2 Oct
 2020 12:02:54 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 12:02:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/9] Offload tc-flower to mscc_ocelot switch using VCAP chains
Date:   Fri,  2 Oct 2020 15:02:19 +0300
Message-Id: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM3PR07CA0130.eurprd07.prod.outlook.com
 (2603:10a6:207:8::16) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM3PR07CA0130.eurprd07.prod.outlook.com (2603:10a6:207:8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 12:02:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bc64078e-f3c9-47c3-1076-08d866cb17f3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB422235730E5900805381124BE0310@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2pKSOZkV/xwZsJiPXZ0lfE5UKB69vpl7q2yS3PE260scFMzOrh1PmETSA7GbUeLGKK/ZSv4V/dc33Flbp13CD9qvFViY86kWd25/e54royBk3FRZiN4t0Aq5xzyT9YI6wMBKqpA8BCcC3XoFeKfVAeAi7pWjYrXre0d1dwEnueluVH6L0y4t6TXmSnbgfIXm00P6KPLkeO3risKvxaxdavVgpeoK/dn7TAkXHlBAgQCydDmaFv9V0/tnm+aKxovWTO00tjle3jCRpX1G1ur1sVjvVG6hodyW3TeIpjyUD1cpGTHHZe7zxD2QHnVsbDmbalayCL0r0q+sqAJC2qt3akmf1sq6Fyw4D4C1TUlDIas597sQqAPhFoW6Ezm1olwvwp1hlBnBj5lcHXgPDJnpnpqzsziNewWzZTQsJomME96tMf9/7uqFbprXdGro/tw1lS+Nd+6hSjiDdEGn3nvRgjlLt2ThYPkaXA3NmYdrNAa9OGruhBXFbvrqIAYOwJT8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(86362001)(186003)(26005)(2616005)(16526019)(7416002)(52116002)(478600001)(5660300002)(6916009)(2906002)(6506007)(6486002)(66946007)(36756003)(69590400008)(66476007)(66556008)(956004)(6512007)(6666004)(44832011)(4326008)(83380400001)(8676002)(8936002)(1076003)(316002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6lusg26gZsTvvp0M9A//fN3UrJrvcEgmF9ZW9Q/fPurpv6X1LUJB9J+NW88L2K6rEw5zLl4/CgXKP6oYbhuZU9kn1y3ZZCqBq74xcJbA+xxCvyYyrYlYTaheAAjBo/OPx398BX/rLiaCRMbXuzmUOe9Mkg5xw57skHqH5+Pux8ZpZ7ZPevCZTLXDPn5S/fkyX3jRaTKE4Vhcqy/Ep/1RR053mN4alN8OgTjPqrqeu0+bdo4MFKX32mPJNcODYX9/bXblulUmhNY/1ijnoG1C8JRZR031tNXGbKBszP58S2+to93rcJ1SAJieGG23F3QmrdUTDkFYqUqcl5G3hIJCTrkkluF435MM1vpsBX+sqbPqZi52Uq9KfWzbjKQ9dsP4b0giI5rra9DhJIZJKHwgXVeT8p4kae6N5M4ZYeYZnojT2EiWubKh82mRjj3Q6qHUBLn6tmTY5n7ZE3e0fMhcSVEyXrb1NHnt11Nmwkp/7piDwJfD5BQb8U4d7KY/Y73kr1bfOUufhjZnZPN/YAJVAP2RiI2LInxJTgKN5pe2tlCsIJ5GbOguzr6v/XV5Rf5if3UoV7z263PIvutTh6rmivy2CaD+T3QzxgjWzkbYhN+FUaybzOdQqdHhBY5lWHSrgQaRyUhjG71WYd70FexAwQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc64078e-f3c9-47c3-1076-08d866cb17f3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 12:02:54.2862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fRSm2mdU2Um1v5gPFEkD3quKA1vyHfFN2rsejtLH4YrQjpBP45OMwgk+FXwXz008aPf9qKulDJU8aQs77TTmmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch is to add more comprehensive support for flow
offloading in the mscc_ocelot library and switch drivers.

The design (with chains) is the result of this discussion:
https://lkml.org/lkml/2020/6/2/203

I have tested it on Seville VSC9953 and Felix VSC9959, but it should
also work on Ocelot-1 VSC7514.

Vladimir Oltean (7):
  net: mscc: ocelot: offload multiple tc-flower actions in same rule
  net: mscc: ocelot: introduce conversion helpers between port and
    netdev
  net: mscc: ocelot: create TCAM skeleton from tc filter chains
  net: mscc: ocelot: only install TCAM entries into a specific lookup
    and PAG
  net: mscc: ocelot: relax ocelot_exclusive_mac_etype_filter_rules()
  net: mscc: ocelot: offload redirect action to VCAP IS2
  selftests: ocelot: add some example VCAP IS1, IS2 and ES0 tc offloads

Xiaoliang Yang (2):
  net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP
    IS1
  net: mscc: ocelot: offload egress VLAN rewriting to VCAP ES0

 MAINTAINERS                                   |   1 +
 drivers/net/dsa/ocelot/felix.c                |  22 +
 drivers/net/dsa/ocelot/felix.h                |   3 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   3 +
 drivers/net/dsa/ocelot/seville_vsc9953.c      |   2 +
 drivers/net/ethernet/mscc/ocelot.c            |   7 +
 drivers/net/ethernet/mscc/ocelot.h            |   2 +
 drivers/net/ethernet/mscc/ocelot_flower.c     | 516 +++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_net.c        |  30 +
 drivers/net/ethernet/mscc/ocelot_vcap.c       | 362 +++++++++---
 drivers/net/ethernet/mscc/ocelot_vcap.h       |  96 +++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |   2 +
 include/soc/mscc/ocelot.h                     |   5 +-
 .../drivers/net/ocelot/tc_flower_chains.sh    | 273 +++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  43 ++
 15 files changed, 1261 insertions(+), 106 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh

-- 
2.25.1

