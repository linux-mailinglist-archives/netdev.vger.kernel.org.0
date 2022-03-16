Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C8E4DB9A2
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358002AbiCPUnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiCPUnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:43:11 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30072.outbound.protection.outlook.com [40.107.3.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26C66E35E
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:41:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+FYdXp9t9jE9tmnmRKPZb8S+4QzKFzGOV+tzsjCHczc9z6OBFkcgeJ46IFgWyC3cnNa6TdhY/i4Bnm+mCGpOW5muc7So4/TMm5m7UkZeX9/JMu7dexbr6M01ybDcTyFQ/RDzvnWaL4Va+k+KQYGyi4dEu/lDJtZOrqYDelkMsRXtJdehazsEIvqQ1EebhCoWNNLBc3Svz6mZeNqLZGXd2ExzzHLA3KR+lcVV4cp3QzpQT8FgqrhfprCySOS6w7nXCgXDbM3PIQZN4/F+32+tRALs4NFBxUB3vOphSJz2tHSQc5n7tsINtm7YvNdZlz+xNam5Arsl0TL4sEulFIaVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eiRoEGWrHUndveLLUZZFNvZgc7u8YVT+AyKpjqbLOM0=;
 b=GEbv/nv2K5z26P2T88fR8eQmLrnDuQQYOSEoL6IUEbAfDzO2Oq/+P1grV5QgAp3quf2dpoA7J75P8HJ5qez4oDusjdPMYTiOoEMcl6HS2zv3b9J/Qih6KwiEetshAtHsU6AYzVKbH8uED+r1y+jc+LJPcu7F84XnClTU2HHQtJxwe8TglGeR/JR9g2z/jMsePAro4ctQagadrZ+XvtyJHqGi8me/SzBQOxDGDiE/llN6qQuiuiyWePw9rnTuCtRDNBLKxJ95XsLzv8AgXLsNLwuRxBW23NI159bRkDrCKqXkyA8SN7rhbYvRj7V5ho7nxqteDKU3dDSio22RJfSf+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eiRoEGWrHUndveLLUZZFNvZgc7u8YVT+AyKpjqbLOM0=;
 b=mGFfzBdN0LU+zHn/nGLoEM3OjzkBO9t11iEbH3yMqnQtIX37oXsUEwjfynpbZ/9ZGEDuBTQgZ9WalH+bChEzHim6UFYkJdDbFB535OKDMGhSj6wWURd67NztOdjJAXEcX6csFPE+n6kudJO7ru4i4hJZZUVOC/LwqLnPAL+swFk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM9PR04MB8398.eurprd04.prod.outlook.com (2603:10a6:20b:3b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 16 Mar
 2022 20:41:54 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f%6]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 20:41:54 +0000
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
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/6] Mirroring for Ocelot switches
Date:   Wed, 16 Mar 2022 22:41:38 +0200
Message-Id: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0037.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::25) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ce7394d-c574-4a5b-26e6-08da078d67b2
X-MS-TrafficTypeDiagnostic: AM9PR04MB8398:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB83980281BA5AD1D6C0BBD705E0119@AM9PR04MB8398.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JgwakgocGCd4HXiVMpu5iqy+oyvm5VdfBZH+MLjoXZlNmpaqcEN6umWPteJDU2gDaK6lIr4n//65D905ONzK+yZrzBul9IMrOkjuYs2jOeIDNQapddwAFBs/NzVq4EUV+e2RviBQY0mx9qS8Qjei62brdkAPx7tX4/U1n/SAeyrkj2YIo2ZG3P1MCo2V5gdF65mi3JOyURi8vamnE4Klpxt6Bv17P6CTW784i7obN0FUjrDMPKoSKSgryl1IzsI6Bx3U6NJuSKdOrISo8Y+SY9avBp7L0VBhc6jmT0ZutmQW9ybNvRzk4byqVy+by2szgmNDsFdwHxEN9b8PNcinT4+fPIW5dgoTh3zkdTP6TlwyxXitUJEhVs616TWNx/ZjZm1TvHpbIIJ26Tb9TsRqvjK/ImbHgMP/M6lA1H4X098zKoEyirNLKl8V9QhYTTurSZM9SwhQCTuConh8sbdXnwn7LtGfQZb57uOd5Xm6aWkHSshyI909PtAhDWnte2rFvbIZIoIKskYvqKFj28yTIDFtgnDuYrdvibDNIr+jmIVrK35aAl1cgS63de8a4GLsNGh4h6qYSYJF/vUO28ji3vcwT2SX1r6n1pZ/+TRjkw09QnJZ8tlN8LrqeXVX6XaKDawRJ7mozV099CuFsuZyydcNw2wsoiX5mMGa8fHhlf/PWnCk4fwyEclj8jeDgAXMURPXF6gSpWqMwB65PW2nBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2906002)(6916009)(54906003)(4326008)(6666004)(8676002)(26005)(186003)(86362001)(316002)(44832011)(36756003)(6486002)(38350700002)(66556008)(5660300002)(83380400001)(66946007)(66476007)(2616005)(6512007)(1076003)(508600001)(52116002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LyhzWpsqwJdGO82Gt+mrYE0K2gMGibhJZXUoSt6E6gtjkEydTiEdfVVpqRlS?=
 =?us-ascii?Q?+dbhSnS9EpIk2aj/Z3tjVLYc3czxsEOSbk6CMMg64phqAyNgNRjNT6Yq9vHH?=
 =?us-ascii?Q?bSz6s0Ykt/lZRKV1LKlbtzYjiGekCTaphgRpu4sL09U2rTbW7Opx3XnyQYyc?=
 =?us-ascii?Q?m91yiKAJ5R3+UZfaS3BLCkpIzDLy3FGK2taSHeeUbKrzREWxYOcB3/T88MHF?=
 =?us-ascii?Q?FJj6a5R4BOIWpAm0cxkv2r7+MBfvVLXqh7RBVBo6PCWzKnzAJLDVESE7UPoC?=
 =?us-ascii?Q?RHVQ8KCstKAx4ISLUgwOsemVlD4vbumtTSxI2qJBHguwJB2hl5H4qjH/cB+R?=
 =?us-ascii?Q?GfuIvIBLhBhqf0VPbK2JYdteR9VFDt9FRjzloESJeD+zyLu7OGkKJ5Fq+f3B?=
 =?us-ascii?Q?fFJtVlRxWmthC/tq+fxd5q9J5DQmPS9utETLPSas//1lax7jlhCtxdOhaE43?=
 =?us-ascii?Q?TKP9qhFopQ6f/bK+dynq62a7Fwoc8AgjHUXbj7y8jW8BqSQ5dklwt+VgzSEg?=
 =?us-ascii?Q?h3cy8nmb/sXcQY+s+sQgm9UZ98NSaqrrbC48eSZ3mTmTe2o++atcuVUiIvEJ?=
 =?us-ascii?Q?EoQ4U790GqeQGy02lI4zdLoFpBcgXnkBz7xpRY/jTbgqgMIOmlgT7ouDdH9O?=
 =?us-ascii?Q?6MgV82J4QRleCqUu7lomG0rogItnDW6g+gAFnsPd3jDnXwRLAbG4awwaQew+?=
 =?us-ascii?Q?OXhPRY8O9hKkjOqiOyDmU9vf1/TZaJUqGXhZIarf77q++0weccP6wyyR4hlT?=
 =?us-ascii?Q?XO5I60EiqQ26YMGEEnzPC6Lfog3NvNAGzj9g6N7aVlUzagXdkz4d2yRY8U0n?=
 =?us-ascii?Q?iwiyUjaR0JBg9xNm1WLRue9BRkJyeM0qoM/QqN5M558nz2c0vlYaRo0o0Ym5?=
 =?us-ascii?Q?B0HBFPYl/JN8s98PnLr3F4nQb5+X/zDKd/Go3mJ1o3ti3dmKWQZbOskh2CnD?=
 =?us-ascii?Q?CM68dmu9xr2FSzJQeKHEeVn2lsQUD4qrHk0tn3GCX6FjFZ0sVT8dw57FCptX?=
 =?us-ascii?Q?2H4J1wheN5zkR4vxFbSOe2FB0Fr2/nOleAXym3fLQ6sG38huPfcO6HRNsxMJ?=
 =?us-ascii?Q?61w7uRH0aJYrG7QHvib/tlOT/IS4NMss7mawYfqx+yPyGPfGdeHJRoIhfv6a?=
 =?us-ascii?Q?b8z4ghFsmhOM1zzhDP5iCFbyxz/zKsj2SyzPM8cVp0t6JN/hOhCQDflfxDDx?=
 =?us-ascii?Q?aQa+zMpMBETw7jtjU5tHHMIvg1GdyY+b8adn3mhKNjxTkgtm+jONLmboxRVH?=
 =?us-ascii?Q?cSAX8NQojXpe3c4jME/To/byOFHT9PIybHL8aC8AbEycs/UIpTiAvdSnX0S8?=
 =?us-ascii?Q?TL6H6/RQIMKPp0va/nOSKUYWOc1/kRQuNvehcBtb0uIDPDVFi11lY14POyCP?=
 =?us-ascii?Q?SMSB4Lcr06edPdzmY6WniXCtAiQLldEkVwdXKbt/RoYGYQoKY9HZ0Rji5Bj8?=
 =?us-ascii?Q?cykdw2UqlzKME4/NziASTlI17DQwk0tm/meDg67ULfBvo/X7oXjsNg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce7394d-c574-4a5b-26e6-08da078d67b2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 20:41:54.0045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QezxCZlCnRtO5hVHpK6D3/VgA+3aWtY9cg7RoyKCErUb9vsT2Ei9VqYyLkhGxwPWrUUdWVDmNKzC1B9X5q6+ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8398
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for tc-matchall (port-based) and tc-flower
(flow-based) offloading of the tc-mirred action. Support has been added
for both the ocelot switchdev driver and felix DSA driver.

Vladimir Oltean (6):
  net: mscc: ocelot: refactor policer work out of
    ocelot_setup_tc_cls_matchall
  net: mscc: ocelot: add port mirroring support using tc-matchall
  net: mscc: ocelot: establish functions for handling VCAP aux resources
  net: mscc: ocelot: offload per-flow mirroring using tc-mirred and VCAP
    IS2
  net: dsa: pass extack to dsa_switch_ops :: port_mirror_add()
  net: dsa: felix: add port mirroring support

 drivers/net/dsa/b53/b53_common.c          |   3 +-
 drivers/net/dsa/b53/b53_priv.h            |   3 +-
 drivers/net/dsa/microchip/ksz8795.c       |   2 +-
 drivers/net/dsa/microchip/ksz9477.c       |   2 +-
 drivers/net/dsa/mt7530.c                  |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c          |   3 +-
 drivers/net/dsa/ocelot/felix.c            |  20 +++
 drivers/net/dsa/qca8k.c                   |   2 +-
 drivers/net/dsa/sja1105/sja1105_main.c    |   2 +-
 drivers/net/ethernet/mscc/ocelot.c        |  76 +++++++++
 drivers/net/ethernet/mscc/ocelot.h        |   7 +-
 drivers/net/ethernet/mscc/ocelot_flower.c |  21 +++
 drivers/net/ethernet/mscc/ocelot_net.c    | 183 +++++++++++++++++-----
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  53 +++++--
 include/net/dsa.h                         |   2 +-
 include/soc/mscc/ocelot.h                 |   9 ++
 include/soc/mscc/ocelot_vcap.h            |   2 +
 net/dsa/slave.c                           |   3 +-
 18 files changed, 333 insertions(+), 62 deletions(-)

-- 
2.25.1

