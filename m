Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08AD4D1325
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345283AbiCHJQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238795AbiCHJQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:16:28 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70041.outbound.protection.outlook.com [40.107.7.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C202240A1D
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 01:15:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eU+5uXj/QACQPDKuBZ01QV2osnnYe2TBuxgDUYsHpYDhQREJ+/qbHrS1U8qI1Y3Z7Fx+tp5PRGNEVAjGuP+7Jjj1dFIeJzgiMw1sGo+NkfMxUpwD4KCCfeRkjJIXNE8tZA1S0zQWrc26/8ndToFq7oHFZYZSd/FeGsNLidJjSKRGEiGw/Y7d/oixfIhIi8l19OdtbSNawkZ4Hr+bOB6q7bv9NVOPSqqZInk2WzZnSOaKa5vwZOlRBKX5xZezQpWDcaLvLMlMGX7lipbbfr5cHU2jd9AACGdutGjXqpb8W4Am5rZEU3JJnwXbD1K9UQAJlbOWgSx5O3EYtODLJIveMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynpriCgs819jaIB7ugad4tMiBTEyfO1pL+yubHE4GSg=;
 b=jY4h7Ze+G+7i+Sc55srm5nkUNsQjVpwmDshdK5B4T9gSyD4Ii4Lybnki1OlenEqTvyCnyLeuScRLKsknN6Jdd5rQtRTCPIhvzFzhrCmLH+4Znn+S3AT+DHzpsjUQrABCKQBpBPDE76cUODdIM2POI1OOsiLegZgLKr/78kM1g2E9JErdE5CB9xoemkeMhSnh50Pqdct62XmWDcNC9wjJLkvu6P/nUyYKL03nR7fY6XB81OIaLA4E9JndaneDePOkY5mLxaKymVbkZB5eQjU6VXt6/s8Cp7pfJCkEcp82bmXDA/hmzM2VS/n6yVP22tlo1+ICI/Az4eE7iUMprCP4+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynpriCgs819jaIB7ugad4tMiBTEyfO1pL+yubHE4GSg=;
 b=e3941jc4dxgkvj/g9aKz6UQbO8mR25QCPeJuRjK4BL1gEqS5u4VWdjTrGDvlGHY12X6KSVKts78FL0qPKuiKdNTC/uyMXezIgSY0qQaYdLUm3aTrBgyt0jCmeXWBknWMFLK2s46Yqslds069BDA1Nv40/ZZnIfrq/akKA61LEKo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4243.eurprd04.prod.outlook.com (2603:10a6:208:66::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Tue, 8 Mar
 2022 09:15:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 09:15:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 0/6] Incremental fixups for DSA unicast filtering
Date:   Tue,  8 Mar 2022 11:15:09 +0200
Message-Id: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0347.eurprd06.prod.outlook.com
 (2603:10a6:20b:466::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96b2531f-5112-4bd8-219d-08da00e42f00
X-MS-TrafficTypeDiagnostic: AM0PR04MB4243:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB424332AAFACB0A3CAAD8678BE0099@AM0PR04MB4243.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AlAKngI48iRgN3s63t+UEd0clxz/Pg3MSYtnHd/cUF1QzujaqNE2smSeyN9MI+PcZ9yqSpFAOd+XDVx1Ia686x9bovTXZi6k4Rl452oWEDZa2XWCRDBgnsKwh4kQV4Vvrc5MEJsblJIh+AvrJqxK8P7gLXU68U3RF/UcCZJHxY9JwMYWEZSBW13U4NW3RuiqtjVwZ+QcZ3Yi76/KYiimkbR9uxIs974ldgY64R/2em3KWzxmr7Agnzfi/t1kkboTY3TGqlYtA5iBfDtJRKxgD8Y6t+Z4rPwpmHA89mA9ntcA6s/gc07RDxT+aqy1cQPou46TTtkpHzlkqVayCGnpVCrW2JnoxEDP1+KEmDRpGOURYzkQi0m64gAVhbe/UTffHRcK0xkHCCco7SBlcrIL+QUzuSHexObIlPlauXZ1uTrroJTcLl7vQukR8VzvG5t9VfBT58N9Xk0WnfuoK8d45JXVkPQ3zq8XC5AHzhFvsrpguRrEPAiV4hF5ixJXPe1R0kArF+CY7Kt3LQzIIo7AzgbjbrFC4MgEMQ6x56YORaQzbd4JgoVbbtuODMtAHzIhkprTvXLWAqnDOuWkO+/W+DvWxZzkSA1BFDYVdqG+3jHH6EqwC+2Eub9upgd4GW4FbJm0KyLHNR66MBIWc9n6pC8eEk1oOitU+USIQ3KyirAOPI8DvcgMA45bPdrahsFAC0vG6dDrmhoKRXX5Dkt5UKMNwVm9nQOA7/JLoaXwQ4SM/LwePOl4EvBcP5Todmws6+Ub6yQsBqQITlezA3oeaq76dkQ88IQVc8z4HooBlK4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(44832011)(498600001)(8936002)(7416002)(5660300002)(6666004)(6512007)(6506007)(38350700002)(86362001)(966005)(38100700002)(2906002)(4326008)(36756003)(8676002)(52116002)(6916009)(83380400001)(186003)(26005)(54906003)(2616005)(1076003)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NH7r19WeMhjQ6t/UEWw8gKYeZ6XpqlF6SgbEnLVAYOxVAWW9M6RIXeh8xC2m?=
 =?us-ascii?Q?/oE+o5ptwY2CM0D2BtrJyBHn6qmBoF2tnXYAGLhQ6JGGwhMtnIPSy30j45C6?=
 =?us-ascii?Q?renLIK8Q4cHU7cW8LQ5uStQHKgJMqmz9wz632VLwLC+2iX9Y4dYHDxWuufBs?=
 =?us-ascii?Q?mUMayxI1CjVpMB7Jg+Ss9/Ek703OT3lU+RF6M5uAuVdJhO07exmCIYI4U+s1?=
 =?us-ascii?Q?QT1y2mUoYQXQSq8WH1+Pexwj3aRue4usUgD/ILKqWHl6TPR+JgI1b3sfPTLp?=
 =?us-ascii?Q?GwuZxkU7fUZVCuVzqLBtgY9b2jF3Ddr7qmEPPM5u4Sq+ysq7vFSf9VKTlUwG?=
 =?us-ascii?Q?J2/eyhyJwQwLLn357CDQnvVCzY7K8gC1Kiw8crRKO0lhITLWXMqfGOolEtVB?=
 =?us-ascii?Q?BGgbrnXRwX7h1ouzBZs45DBxgw+BdyGP+HyVYrPL4gjBv6aJgi9zfe3yAjDd?=
 =?us-ascii?Q?ZJWPjl9zcrr1Hw0T0K/hLmqFuB0rI2VsoInShXeJFgUTZhLNJIXwKE5hj+a8?=
 =?us-ascii?Q?iIEmVQPkNuE3oJGxtWUoriC4CRJj0TzG6hkJhg7Vyq55zYzjdgEfKsy98Src?=
 =?us-ascii?Q?mjCdJ3P8Hn2sV2DJgXUBS6kS852TMQYrVcOYOYzkIN7m28xV1b2eDKL7MK1b?=
 =?us-ascii?Q?8YOJiTJ7GV29f0RTH2taJqHOXQw2blFoAtsUxOFmk/6qoWGqqwWkebwm7z0e?=
 =?us-ascii?Q?dG4bcSaEuuSzHtD//43pjRQwxbDcbpF7+KiLfCt4T2ZdsHk78kQ8Tcn50hjt?=
 =?us-ascii?Q?Mqi4DY2PViLtMNQAYRcz0YTF9sze2QjDEAXx3xvxmixOAG2orRlpafMaMqSb?=
 =?us-ascii?Q?eb1W4UlOt5yzag0KGQ7IdpNgzEUzK14K2skOeMKJxrVKfCcxnZXpy72CQN5Y?=
 =?us-ascii?Q?hk5lsRQyzd+06oCxXqpTC8ZRRoOP8Ug8p78WAM5swL/LAt6WwlBjjVZM8Qoz?=
 =?us-ascii?Q?q2AvtPZyzETt/kx+9eT8pJ4qMRtkHSwEjVSXBNtBsc9/cTwEUzG052xuqMjh?=
 =?us-ascii?Q?D6bb+ozu1ren5P/U9VBoegLQT5z4m33afcjYy/hgqrVyrvVMzeLHjKJxauO+?=
 =?us-ascii?Q?2AIionbsV1eqgRSuFNsi64jXy4D0ZOu27FsvBfW6cosk3Ghouw8a9p8BEWO6?=
 =?us-ascii?Q?OZ3hnRHrtbmyp1+IuIOwTdoJh+IA22qyoCWzATCg2enTXhlWpSg4toeHPXMS?=
 =?us-ascii?Q?xev6gGHEJ1X/+fyKWvPdIRwOt9J5eWqCVSZENQ0/F/cXWrIQh1ih/OBLf7O3?=
 =?us-ascii?Q?stWsgx6WBGhCjAEJjabTEnlcI/kpE+PbYY83LfV7OLHr9v36ZZKnaNksZ/kd?=
 =?us-ascii?Q?xrkDG5gqlfwTogc44KlJ4C/exR8/f0ne0T4WyyAqhxKim6m9PSXKzBItSK/Q?=
 =?us-ascii?Q?IErzT/6WS2Jftg9+097AV5IuFinQJ5otNTQa8CcL/qYzq9klTxA29sH1IqSQ?=
 =?us-ascii?Q?QCASAGJxJcHlv0Arvgh7Wdq6kkB8phmv5fzkODnKeFCXFKop30OZWfcV6rO6?=
 =?us-ascii?Q?WUyIfcH3b5oKHFRUIXfH6Izf3KnYh9SEJoCy2NwQiC1LBOGd1EHpN7JOaeBQ?=
 =?us-ascii?Q?O6r3bUudM/kgYnMQ9kwI8Bhu41yz0oUZLYY4tQwuzrDh64yQAssCAJTiwlJj?=
 =?us-ascii?Q?Zu60Rj07tpxsDztFHjHnETY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b2531f-5112-4bd8-219d-08da00e42f00
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 09:15:26.9458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jE+15wlqH8dX/qg0+HM1UK6P27lnW3DXd4Kr7rl6zlplr9pgCTXQfeJ3QUWdDLeSRlf24sg75TqnvfA1evfnWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4243
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some bugs I've discovered in the recently merged "DSA unicast
filtering" series:
https://patchwork.kernel.org/project/netdevbpf/cover/20220302191417.1288145-1-vladimir.oltean@nxp.com/

First bug is the dereference of an uninitialized list (dp->fdbs) when
the "initial" tag protocol is placed in the device tree for the Felix
switch driver. This is a scenario I hadn't tested. It is handled by
patches 1-3.

Second bug is actually a sum of bugs that canceled each other out during
my previous testing. The MAC address change of a DSA slave interface
breaks termination for the other slave interfaces. But this actually
does not happen if the slave interface whose address is changing is
down. And even when up, traffic termination is still not broken because
we fail to properly disable host flooding. Patches 4-6 handle this for
the Felix driver (the only one benefiting from unicast filtering so far).

Vladimir Oltean (6):
  net: dsa: warn if port lists aren't empty in dsa_port_teardown
  net: dsa: move port lists initialization to dsa_port_touch
  net: dsa: felix: drop "bool change" from felix_set_tag_protocol
  net: dsa: be mostly no-op in dsa_slave_set_mac_address when down
  net: dsa: felix: actually disable flooding towards NPI port
  net: dsa: felix: avoid early deletion of host FDB entries

 drivers/net/dsa/ocelot/felix.c | 90 +++++++++++++++++++---------------
 include/net/dsa.h              |  6 +++
 net/dsa/dsa.c                  | 60 +++++++++++++++++++++++
 net/dsa/dsa2.c                 | 31 +++---------
 net/dsa/dsa_priv.h             |  2 +
 net/dsa/slave.c                |  7 +++
 net/dsa/switch.c               | 18 -------
 7 files changed, 134 insertions(+), 80 deletions(-)

-- 
2.25.1

