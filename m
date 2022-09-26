Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F615E9730
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiIZAaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiIZAaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:30:19 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2125.outbound.protection.outlook.com [40.107.95.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC04D2252B;
        Sun, 25 Sep 2022 17:30:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqZus+xWKDgBIe/EFqsunypXT/9mw80/4MFrIiZHAFqnDFabfJjp0t0sJxzn9z6DQNNZXmITKoxTh3i2uth+3TEvgnJmxPYJr0t1FSDHO7dAzm3Id9S8blFa+3xDufpuUUOJ79sgRcVhfBpYb8uJ0gG4k7db0ss8D9OlLv1VlC9OOCasf07ZSSYA7BoB5knSi9/XspDbE64wLpfWMikQZ4ZLKxmE+jaBL575Rm8l3eK+4D5xwrGxFKK5vnjkkOwR48HOnaUfdtJb7suoMC90RZVp0oieTmHOHX+uRCqzTB6h3kzgim95wqt3GLQZnF2/LeWGW+UNYOSvbdFl+GHUHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kihWcpChnXd/PIPBdJwfMRvONb6bplCzjyaYAqpRJfA=;
 b=oJ44oacRnOYrl4MEy4wLXkZc18acJH102gkwkT5ruQk1lwObo4lYFqaXalOPeGfiYFiIa8OPhFDZOPB44XyH5pz8erFgVbUeM79o+fP8nsKJvmgnHHAVf36QWtuD6MAZPknCr74ImCxDT3gEiSQmRBGXYIpUU+rvyIahll97dJKNP8DQbRwKTgHVz0+7BZeuryCO7WE3y2RRREsPb+DGoXjfu4oJMtNy4Nkl1OsAQ5S6QNDaeMjCuHkONQvgvJKFV8ri4vWVG27zjMpwHx7yrwA1/eG66XctPj69xic1iUkxhob8iNnAzKy2IQ5i+AgSUVRutiw98qLHUL+jCmpQ7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kihWcpChnXd/PIPBdJwfMRvONb6bplCzjyaYAqpRJfA=;
 b=XcCUKRQFQbrXqURe5xYTiO8oyEZLaqOp5ZuIp1D0dMsFzscKkJeeEJpQsC85Py1tXLxOw3yzJD/zCNDn312dB1+3SH1E3O6ZCtait0tMaW+C39ck47QaUpSDebS5RtYja8l68gdjOJJ3QRHX4Ujechvq5VtDZZoQVXH8QIMw2kk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY5PR10MB6094.namprd10.prod.outlook.com
 (2603:10b6:930:39::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Mon, 26 Sep
 2022 00:30:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:15 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 00/14] add support for the the vsc7512 internal copper phys
Date:   Sun, 25 Sep 2022 17:29:14 -0700
Message-Id: <20220926002928.2744638-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CY5PR10MB6094:EE_
X-MS-Office365-Filtering-Correlation-Id: 6636aa17-7789-4d57-cc29-08da9f5646ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 45Rqxr8sQDP9sd6dzlvUWl0EO4//aQPjxofAqy9dEGSxbzLHgpKrKmYIE41+bwr0d7AfP1EeNlTijm2nppKOp1qV+2WE/8sTAt4BnY0awcCkli4smrHxIpgemRLUIJMBMr/5942Lc0YBKZA3zJ6G+TN+lZK6XFnuIG/Cq6PTiLAemQD519/Ep974VkbbT9w2Y4o9oA81pOeD6ZDCU9kvLBvoDsRZBQ/C6z7FBT8Mj4BxysxW+Z7XWiEv4Nd+g8CGOLwzMKT2Z7vsaPiMC7W3m2qGliuSmflKimb70W2f/m/hsKhFjLMfWyQxSURwyvQn+yRZJQRKITP28MZIODUyif+GaSecTyA8EOcdVhSGUKu4ZejCVnXRfU4dabP38AkaZq6g+kI4Sl3wk9uE+BcxEzSvbZslli+mMBP7u6orh0bOpwHN/tXEFJr4iuXlaeDPbclKcwka9S03I3HxGvhc4NL6QtpfDmveIPg0rXHhPx0ku4YzwZ+5xUcRC+ErjA0ivSQ2H/vxcsiJJ1VX8ddAByRDSi4kCXFAXn/So003M6ev8BvFscv2y/ryR6gVNQlHO23fOpYdpK7VnTF3Y1HFgXDvvpwv5opyYka4ZkqNr2l/7bUOlsuM3oaF81Q6NYYLQszLRkDEFiFVENG71+LHiwQu1DJcb3+vJhiWZMmIJu+QM3Zd6WunCfVkZZi2ZfGWMHKPMNw+phfRllP86duurbHE8J1vmf/k1T1ZKZaADEmVrbYIbgg2h1Wdb2nFnaiId2CtiA+19huN5gYJpjjPlRiPwJQUu+2uR9sb0Owsheo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39830400003)(376002)(346002)(396003)(136003)(451199015)(66946007)(5660300002)(44832011)(41300700001)(66476007)(8676002)(4326008)(478600001)(66556008)(966005)(6486002)(316002)(54906003)(38100700002)(186003)(26005)(86362001)(52116002)(6506007)(6512007)(83380400001)(2616005)(1076003)(38350700002)(36756003)(2906002)(8936002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q4eIKMeTbKpQlCS0KBzu8cbL/7kqkBtW1OOz7SC8FsK5D8Qhy133kXQiu/Jw?=
 =?us-ascii?Q?1ANV1cNyJEEdJIxm7FCm2+D13ZR+S2lLXsjCG21CCXC/NunPOXeSc1BRluxe?=
 =?us-ascii?Q?37tYFGZnuSGX932+/43TKvocbVHvgL0n54981Ifo5FSr/9tV86gJAT+tjzYd?=
 =?us-ascii?Q?uo0q5iZ9IFX7UaqgG0SuHXyn5xUGxZ2kl/vJ+Bq1plHxbuSQzWjEj0qdCyql?=
 =?us-ascii?Q?fKlhjowp7S42tv3PdHAZdi3htPYSrvXpXhdjSXwEqyhnx03vHeUfToXNUGmd?=
 =?us-ascii?Q?xtJG6B/m2eg3dogZAhXzd30jaJxUtQY/HNbDvVdSm5n22zpxxzWPWdDuuYOE?=
 =?us-ascii?Q?EmnyVkxXej+LugFKfTvDQnp30/4TWnvh/d1K6IRDR4zVIOLs+lQsDIUUf4RR?=
 =?us-ascii?Q?+Gx2Mn7ZFStZVr2fVeXmrzaLd7aa99pxgN2kUDvQBao2AEhw2rO+GNnYUmrW?=
 =?us-ascii?Q?H9LI0qPMv3KAT2hZLgarLelhHYjq3tcM5Gw6oXnw0xF/PK1jNEvk05P+gJAc?=
 =?us-ascii?Q?E+fus48oyuQJUAQ9dDftTnAckbhDwva8g2a3wbEiZGShQA8bCqR7xLxYDIrd?=
 =?us-ascii?Q?QLq3Tzt1nBjJkeSoti3vqhxtcMv5yNj6n12Pom9SQ8S1i/JxreLgxjvCNTBN?=
 =?us-ascii?Q?xZf9LEETWl0EtBU2F11WvNA9m8KIOz4q5Fkbnly+B9HxOYrVOv5kSN0qGZzp?=
 =?us-ascii?Q?ES7qthF90q6cyBn6j5zY7a9sfSAnG/qN2msENwZkd5QZLEBpNrcZ+BdS6qda?=
 =?us-ascii?Q?3H3BLpm0TTxaVZ0Kx22Kr+5WCvZeE9i8Pnfy0s04s/1X3qZ7JDW8GUZ/+k07?=
 =?us-ascii?Q?aBCQZqD0Z7I7HEobkWyvXyiERo2c/tYruJTPm2Ct24R8VH1Uba7c4AOPQX7L?=
 =?us-ascii?Q?ZSONtWzpzJHpqO3Nww3b4jpujB+fHpo7v77lWqveTbEZ8r91gYSzdOLpfQge?=
 =?us-ascii?Q?gUmRicrgOgBmF9TcDM6wh/ioOH83zJ9EW+lkQ+8kqOaoeAKkVzUuZKN0JtsS?=
 =?us-ascii?Q?Gdj/ITGozykNNVxwmjLjmHqkJI8uJaNjrJ45AWVKmB0HsEOJtUNmA58ELp4y?=
 =?us-ascii?Q?oImx74vRsGou6dcHq0ECKBSOUvGLnREEtYDpxeT0ZFpv3HM9/feGFg3rd9nH?=
 =?us-ascii?Q?OBxRVX/wj5YWAcYO7LNKbiaOE9P/bk9cY2yZNWDCEGF8uPTmO/31i7Eqj4ma?=
 =?us-ascii?Q?8rvG701EhNTAnCKTLjBHeJrmIAbnaM5n2ayC+skbeAd9bwePjo5LWr5MJak9?=
 =?us-ascii?Q?IXHPWGKEYQIelDvKVUTvGkfoibcsu/cLKcHZnhGOLTowfA7vOgusmPJgxDi1?=
 =?us-ascii?Q?pvRI8GtWrOP+1BtxBvjnafZWZyk+U/wpzGT0JH4Sp3wpqXjMWcZdqsXCVn7k?=
 =?us-ascii?Q?zIqtifAvuArll5APRSui55COTJnztt25TLXjPzMS//3C6534YsRc5aY70Fyt?=
 =?us-ascii?Q?OQ5ja/D862+sEzlUSU3N1rM25lIyGR85lF/1JOGTl9OOWqOBmr3srcG965bB?=
 =?us-ascii?Q?1wREGG4xhDtHzHMxUZEw/Kk3fRjCGcZ7XZJ6QW7jToVEMGgPerH+mnKtY8XY?=
 =?us-ascii?Q?xgqbQoQ9prT6Z5/hUzLeHzJ/pxVr2w5npg4z8eGOVTYn4r5hcm8G0+oREpVP?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6636aa17-7789-4d57-cc29-08da9f5646ea
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:15.1829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yRRMm2PE++1fnhd4M7A3bka6Cqyfq7YAmn34OrEqHHzva3AL5Zzm1L5V3IA5FaiFxm4bCR/5Xs1hmN7KglCKfhg09zoxtk0u51RS/BCDk8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6094
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is a continuation to add support for the VSC7512:
https://patchwork.kernel.org/project/netdevbpf/list/?series=674168&state=*

That series added the framework and initial functionality for the
VSC7512 chip. Several of these patches grew during the initial
development of the framework, which is why v1 will include changelogs.
It was during v9 of that original MFD patch set that these were dropped.

With that out of the way, the VSC7512 is mainly a subset of the VSC7514
chip. The 7512 lacks an internal MIPS processor, but otherwise many of
the register definitions are identical. That is why several of these
patches are simply to expose common resources from
drivers/net/ethernet/mscc/*.

This patch only adds support for the first four ports (swp0-swp3). The
remaining ports require more significant changes to the felix driver,
and will be handled in the future.


v3
    * Fix allmodconfig build (patch 8)
    * Change documentation wording (patch 12)
    * Import module namespace (patch 13)
    * Fix array initializer (patch 13)

v2
    * Utilize common ocelot_reset routine (new patch 5, modified patch 13)
    * Change init_regmap() routine to be string-based (new patch 8)
    * Split patches where necessary (patches 9 and 14)
    * Add documentation (patch 12) and MAINTAINERS (patch 13)
    * Upgrade to PATCH status

v1 (from RFC v8 suggested above):
    * Utilize the MFD framework for creating regmaps, as well as
      dev_get_regmap() (patches 7 and 8 of this series)

Colin Foster (14):
  net: mscc: ocelot: expose ocelot wm functions
  net: mscc: ocelot: expose regfield definition to be used by other
    drivers
  net: mscc: ocelot: expose stats layout definition to be used by other
    drivers
  net: mscc: ocelot: expose vcap_props structure
  net: mscc: ocelot: expose ocelot_reset routine
  net: dsa: felix: add configurable device quirks
  net: dsa: felix: populate mac_capabilities for all ports
  net: dsa: felix: update init_regmap to be string-based
  pinctrl: ocelot: avoid macro redefinition
  mfd: ocelot: prepend resource size macros to be 32-bit
  mfd: ocelot: add regmaps for ocelot_ext
  dt-bindings: net: dsa: ocelot: add ocelot-ext documentation
  net: dsa: ocelot: add external ocelot switch control
  mfd: ocelot: add external ocelot switch control

 .../bindings/net/dsa/mscc,ocelot.yaml         |  59 ++++++
 MAINTAINERS                                   |   1 +
 drivers/mfd/ocelot-core.c                     |  98 ++++++++-
 drivers/net/dsa/ocelot/Kconfig                |  19 ++
 drivers/net/dsa/ocelot/Makefile               |   5 +
 drivers/net/dsa/ocelot/felix.c                |  68 ++++--
 drivers/net/dsa/ocelot/felix.h                |   5 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   3 +-
 drivers/net/dsa/ocelot/ocelot_ext.c           | 194 ++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c      |   3 +-
 drivers/net/ethernet/mscc/ocelot.c            |  48 ++++-
 drivers/net/ethernet/mscc/ocelot_devlink.c    |  31 +++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 181 +---------------
 drivers/net/ethernet/mscc/vsc7514_regs.c      | 108 ++++++++++
 drivers/pinctrl/pinctrl-ocelot.c              |   1 +
 include/linux/mfd/ocelot.h                    |   5 +
 include/soc/mscc/ocelot.h                     |   6 +
 include/soc/mscc/vsc7514_regs.h               |   6 +
 18 files changed, 637 insertions(+), 204 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

-- 
2.25.1

