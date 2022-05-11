Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43EE4522FDE
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiEKJui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiEKJuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:50:35 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20077.outbound.protection.outlook.com [40.107.2.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B48527FF
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:50:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKdrFyJDCVbTNEQqG3oFXJECL+2lMGRi5fpoQ7KBUCrvKtqfHX1MC3436sW/ZFOkQX/Nvdr8r8J104suafiu0MXEp0a2NJFpxMJltmiQJ2MHdOicBoWY/04CrdvZ0kT037tzi+LDXHmnEWN7dGMEzDNZVgfkVZLvFc5fCpLyiNyhJkWHy0bh9xsjWjJg+vycD3GLll7avVez2RhtVCJuteYXfAKqpXiSGC9pf7RZbYIIrBKTI7gIimQbIOC4xi+B0Q+8qm2Lx2JW13D+vukpGEIgSX5UaqJFiIYQxuHIerruv9+XHNyvtvYY71uJM4YVkzdOKoq/SHlGxL/qwlZ4qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9kyAo2CwSK63MKiaCT35NLoHoOicZntE1trIjtyM5A=;
 b=RDYuhRFmRv6+58h1jqTCBgMJ+OOWGMMrSuGFOvQwOsAIGbRBWKYJ4htUvdsuiYWxPKT5urlpQgclylnC8/m6BrPgjq3IkoFd1APNyKw9qaSzkexvJC9ilxjIwm+Wr0wuCZM9nYHTdkzhfca/9R9fkAyc3bVr+uLauyD+jg2mHUXUfkc9Ln/lpCX5XNL7C596oumRaTW/I2ffhZ1iMyRMLe6jGhzDBhTa7RbPrQHwJIZiN9RugAFhGAGrQcaIuB0pRZ43qXKrsMusOX1vNyB6f7Q5dvUfNEHiGSqEONtSUQznc22Sk7qqILWRpVK1tgjp+GaRyirjf9mFrzTfb+1wlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9kyAo2CwSK63MKiaCT35NLoHoOicZntE1trIjtyM5A=;
 b=nAVhRQTS+wOEc4qbtJUNN7NRkwZyV9tYlZ13amfjruhPOugTeoDQ4itlpzwR1k366cmK7xQiOLU7eZmLAI7LdTkQf4VWLTeGU4fYSgilTGzTs4vGSpNiB1Dm8vvmgRrW9NirtSHGMTgoGj73o2k2APJ9lo1QiVFjztd7NQiI0Fo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9155.eurprd04.prod.outlook.com (2603:10a6:102:22e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Wed, 11 May
 2022 09:50:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 09:50:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v2 net-next 0/8] DSA changes for multiple CPU ports (part 1)
Date:   Wed, 11 May 2022 12:50:12 +0300
Message-Id: <20220511095020.562461-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0158.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78d164b3-18e2-4771-9995-08da3333b051
X-MS-TrafficTypeDiagnostic: PAXPR04MB9155:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB915578F63787968309C8FE92E0C89@PAXPR04MB9155.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gc8g2WZ340BSTwSf0j+dxbsJf9BOs+q6WNuPVzUy/xEtDS0vdHuRVo1Mgbgxn42LL9R/FjtHCjUhtBrb+i5mbEHB83sfN2sV4lozKFSAftIWEtwDA3Cx/SKqLeG7/LC4sE7csiRxds/5HTqHkihtrShgGF2tkVVRMrTgjqXulXDtkmwyIDkV79mC4X/oCsf7EZrOgnKJeunNmrjFPZmGyUx8Ni9QbokJo1P5BK494r8RVVPFfNhGxv40vhyH9wUniPpsdxRm79z7hWjS3U8C9mFgws0RxoydjUBE5qxsfWvSkjdDClpbEC/eF6CwJ2LuV/GakwP5fk9KRR6p2EwmPWtWX6k6CKkQYA7Bpk+uYuTORvILZwYbONKqzYw15VWebeVWvw/Ekbhxc4VSskvQU0nbUTU6DXo/Zmqf//m9Zk9pMpN4jh7n9tMO/ItcTNjx2v+7oHxx14XMWvLgacRjsO4tHB16MkJPQJ32hH9KB+xwp49QossFbmtcWzbCw5P/MgbEKmOMOtm3oj5lADl7S/XLZfW8VnczY/l4mPMMg0fW+EAkb/j+M70wAfqCm/nxhZ7CBCHR3HD4rwcboN0jY0fMtzH6YTCnFPuB+dxn9VYvnlJ3dCvjMAjqtRSfPtjq0AU/OVdilxSKZ6fj8RiV5gQhjEWeUnXOB8zC6Zn0iYcwn2NNBTRiZxY4s4ME0EhLlqcm9tTpCO2hAXwRlnJyPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(186003)(38100700002)(38350700002)(1076003)(7416002)(2906002)(44832011)(5660300002)(8936002)(36756003)(2616005)(8676002)(6506007)(6666004)(66556008)(66946007)(54906003)(4326008)(66476007)(6916009)(52116002)(316002)(26005)(6512007)(6486002)(508600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YYEwtOQ88FGhq/UXDDgzgfOH+/BRw6RCZfq2LTb/fQHb4lNOLIzFn6ZzIZi7?=
 =?us-ascii?Q?rB1M4KynbDMb+5N0hpYcPPhuTgMVBu0VWBvlnmgDI1+4jMlBClKqtOJox9HN?=
 =?us-ascii?Q?3+tFFTUB1g8o79D2+nwaSVN8TKbXO45duTar8bIg1EPTV3qus6Lpqk2jjEro?=
 =?us-ascii?Q?HZvwqBQIUeoq9lBLw2gy8RuOx/gQLWggZ5RuoTxYDSciYb61IQlR1XsA0+bf?=
 =?us-ascii?Q?/3K9jJsxwMSa+XnO1ZQPUPDfJpD1SD5OMJEUzitkscGZSPdnuaLJ+B2KE6Qu?=
 =?us-ascii?Q?Dr+j/h4paGmJdXwbc6DGMUuefYYghkLl4Fkw41UNg6m3PEsh8D4NRqwXEGLl?=
 =?us-ascii?Q?pP1FqzpsDB46u05rwMQjel4deZWDcn2N3xTL9y9lJnZyw2LRG5p4KezU1cIf?=
 =?us-ascii?Q?IS4eDSPVDW7bdU0Scx6RC5mwdhXZrTJbQRQiO6i+DnhkHsWDUsRKC4N39/y0?=
 =?us-ascii?Q?nlc/5OYktvYpLkVcgJYgnDrpOTXinuy7lXpo2RVFKC62bYdtNwYryssrnee3?=
 =?us-ascii?Q?NXnjS/6S1GhlBEuL9xrAyrz3dacgjKssI+wn3DPVe70D7EqBVpqQHdzSPv9Z?=
 =?us-ascii?Q?H4iDuBY1TqgtooB4LQxNpDifzSXrprbbomrvwmo3K1lztguegBr/q1ol5IXn?=
 =?us-ascii?Q?jiGIZs7MNs56Tl7b1c414ZGztdIGL02JMCW0KsvOwKqlQf71SLYPKaZzX+wR?=
 =?us-ascii?Q?75ZEsrO28O14nibGkgNqv9b7Vdln9pIATvkBnWjftGExMOpDjfztEfZLW/7C?=
 =?us-ascii?Q?PIFyXlWZKSR7UhFH+tQzjSfMaN+qYa+mBadR62mXppxxhxZ+b4nMm62DiNUv?=
 =?us-ascii?Q?W+ah2EtKiWUv4wRs3BTnJI2CCJBimE8V/DW68GmexKkoZ91lFeQJEykJT0uY?=
 =?us-ascii?Q?xOJPuEBfyg7F75nGBtb1f7/3+5p9tHS/uwI0b3lXoRdzAm3BPQx3Ds3zZJHP?=
 =?us-ascii?Q?XMd5FQHA7rtjm38NRE2pcaqWBQDvlAjsEl1MaDGLW8PP0neO+aRhY9frtm4n?=
 =?us-ascii?Q?zp/OvVd6OW4mqezJu7lV10WUwGTFDCrA+N8DQ9X94+Xit8PERxEW/Vq8bvSU?=
 =?us-ascii?Q?0WGDp0cgBxhW+kVnRbRmgF6Crg3xCuqO/CCo8N/z5DSUi/yVexs2K8+Y/Dfr?=
 =?us-ascii?Q?tHGNsEr28mUVuARLB9/zy9t8idOW+eB3+tSWnCba6+nMI5ziFYPeEn1rlszO?=
 =?us-ascii?Q?snkjHtC93nW7cRISG+sey9zz+dX/bUbIo8Bqk09hVgWEMihRdaH56X3fjUSe?=
 =?us-ascii?Q?q5iYTnp0FG2ALQiB/x/3dcy27RqYZ0V1PTRNyOxao0i13KaHrO95bYSViQlL?=
 =?us-ascii?Q?2J2lvJ8RZEr9AHHvuHSv0V/ijw1ehZPZQYky2521wcL6MO9FVdp917Oztegy?=
 =?us-ascii?Q?Be99ZHmWEU3AaZ+AW5uU2Fu1DwUBTJocrKvVltqAlwAcJ01ri+VAMUTnBiig?=
 =?us-ascii?Q?8YiE59eGcv6OnIIjPE602y8GFW40Rp5s4wORwn2uAUr0T0Sxv22NAap1crhE?=
 =?us-ascii?Q?+w7O51RKC6QObDdrPf8kEKxU/O6AuXsz2XjUbwM4LBlPaAV4MvPIlER+bz8b?=
 =?us-ascii?Q?Zu7CidhbLFtmHEanlEVb9gBUcXrh4+TeCTlp4I1+X4lCie++DeBpoR00EKw2?=
 =?us-ascii?Q?d4jgLlgbqH0c71oQ+h/zxGpNcV63eh1DzZImoGFI14cpqoAxWktYLU6Mq8V/?=
 =?us-ascii?Q?F4lBTPj0DQNA9/7IPMf1x0v+CPFR4xz9w+tJZ4Sxr8BAB4/5wRn/nrg1HNlV?=
 =?us-ascii?Q?D1ZmAbhLvh0yz+CQ0VIbbNy7dDmXSYE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d164b3-18e2-4771-9995-08da3333b051
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:50:32.2395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 44oBAwKmCr790xyKADS/+DUVB+EdetYt/g+T5glg4/xoSODelQS7mDN1dVqVgOrzHiWY1O0pgy7/mAvt0hDslA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9155
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am trying to enable the second internal port pair from the NXP LS1028A
Felix switch for DSA-tagged traffic via "ocelot-8021q". This series
represents part 1 (of an unknown number) of that effort.

It does some preparation work, like managing host flooding in DSA via a
dedicated method, and removing the CPU port as argument from the tagging
protocol change procedure.

In terms of driver-specific changes, it reworks the 2 tag protocol
implementations in the Felix driver to have a structured data format.
It enables host flooding towards all tag_8021q CPU ports. It dynamically
updates the tag_8021q CPU port used for traps. It also fixes a bug
introduced by a previous refactoring/oversimplification commit in
net-next.

Vladimir Oltean (8):
  net: dsa: felix: program host FDB entries towards PGID_CPU for
    tag_8021q too
  net: dsa: felix: bring the NPI port indirection for host MDBs to
    surface
  net: dsa: felix: bring the NPI port indirection for host flooding to
    surface
  net: dsa: introduce the dsa_cpu_ports() helper
  net: dsa: felix: manage host flooding using a specific driver callback
  net: dsa: remove port argument from ->change_tag_protocol()
  net: dsa: felix: dynamically determine tag_8021q CPU port for traps
  net: dsa: felix: reimplement tagging protocol change with function
    pointers

 drivers/net/dsa/mv88e6xxx/chip.c    |  22 +-
 drivers/net/dsa/ocelot/felix.c      | 469 +++++++++++++++-------------
 drivers/net/dsa/ocelot/felix.h      |  16 +
 drivers/net/dsa/realtek/rtl8365mb.c |   2 +-
 drivers/net/ethernet/mscc/ocelot.c  |  16 +-
 include/net/dsa.h                   |  19 +-
 net/dsa/dsa2.c                      |  18 +-
 net/dsa/dsa_priv.h                  |   1 +
 net/dsa/port.c                      |   8 +
 net/dsa/slave.c                     |  36 +--
 net/dsa/switch.c                    |  10 +-
 11 files changed, 337 insertions(+), 280 deletions(-)

-- 
2.25.1

