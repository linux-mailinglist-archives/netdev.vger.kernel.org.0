Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E9C4CAE64
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244968AbiCBTPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244913AbiCBTPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:15:39 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8912553720
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:14:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHjnYidyH2f0XqJjH7Nb9XqcRa4pCIJ6lvC9kLQRDM3HUSaze9ENbDN/NBRt2gJj/CUF3SNatVMZhSeN+iC3CN1TSzclK3qXA5aSzs29cOq7DYq/7EmvL0yITNL497MfM+cu70OXElnFPRjVPl02UOtaI2ZDIo/s4P0BXqMmvcv5SQjlcZUpmHmAmtxU7faRJZa1tm5Huz6rigMD4R+GpEe6LJpaGg+w9GT2+AObmAuzKlbd6VYHXNcGn06QhReNMAJXHwX8tm8thULd0P24VXk1tvdQgqrd1VRur+SJQ1dY88r0LIN5kZbCU49ZERPkcYGJJLwR+W/gYE3BgFxeOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yRU5zkWTGvEAw+2JZTlUZXKTvbtHrt0FpuCCtjLpfA=;
 b=bHz9hsrYiE8pTSmF0nEDAubkjixKp+XhynsIg7dQJYzjCfz2OISbNtD2/pLv1MuPNKIJxchCjAPquekjL1EXaXUFF4j0Xcr/yJiXSpGy+fc8IXkpmkejct4Z3p9tYgJhHeKqPeLs5kq0RjYXgCVo/X69jK1aPu3jbrpxG9fqU609bD1Tnya6J9eQt0PHL3WgnhxbzQCyt0kDKHdyDECYlzqsFIVSeQpE1GAcBA1P3XQpQEK5JWIM/Ovg7Eli3RgF6Qn/PnC6uX/2VA4ulRgG6lC4QraDmEVlpjWkHhQzCMiPOuhWHz4wDKevi8xnHb1edscLlmJcY8Pd2aqeGUrqVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yRU5zkWTGvEAw+2JZTlUZXKTvbtHrt0FpuCCtjLpfA=;
 b=QbwLl3vHvWyko6O3NuhmvwGV6Z5egQza89d3zKpaUxKIZtcRJ+rDnydNTqB1BaUfm+EoETFeGWAARArXWlnJ7Eu6sevl1RMpO0nLKzPtSLVbMFCaVy2CYPgqu62f8FWgbYRSZLpeyRjy7+en4ClLf2zplkgqw+5T5xlc5IukBlI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 19:14:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:14:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 00/10] DSA unicast filtering
Date:   Wed,  2 Mar 2022 21:14:07 +0200
Message-Id: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0030.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eed8530d-7885-4255-7cc9-08d9fc80eca8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2911B91CD534A63444AE175BE0039@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fBfQZHOHg/X0Ef0veaU4agJSNXIZgt3C/6ylI6x1YUiYDLqTYN09K95iG8FvSGTReu8iHi3MYjSP6pB0f2fUQM7BMiwj4Ms6Bk0kAXyQy+vaIgd8gIZP98KItuXwak7MX+LyLS7q8YSrY8RMW1AbTK5HUIuiL+5yIgluo2PjjNsrtfwZV8TKYg9ksULIABg9q/f/DYxERgkrNGNBGffFowQqcXPQmfs1OyexeByR2E7vX8dneiPSlCNrsmC/5AXcUOAJZbsi6oUBZuEIokRleRhKt7A8ANeXgUpODV79pFUD1NGlfXfaXo1Ug0KhNcJTUHDuGT8OFE8G8xeIjC04cZhaQO2F39IvTSLcDMO1B8SW2nyyuvN6JxnT+qSu2Hjod52jEUP8F0paaCNSXOQp7vXlFQgHOGIa0g6bHbCTwN5/FOH2ph1/ujPE93doYr/QgvyiiFigGTdRA9Y31bwHn3yyGjlR5Jw7JeSyS3PETmzgPjJFANq+/r8EjarzBLhnUtJtkWxaxGcx0NpfVaSsfzL7b9NCKMymv6boLDlhTm1x5SvOvYAue+q672NMLYWDhPFtBhETvSooDP3cVFW6LIW/ahDLPLw5jNoUnnBaddIvAYCV43Uqni2DMCqXZOYa2e6Xsg3yQ5YuO/ykLghQnQnkH8KY6I0b7dI7w2MnUfB5nGREqnNoKxM/SbIYQd1l3xwE+QKOpsS/jZRLF5Cvcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6916009)(83380400001)(5660300002)(8676002)(4326008)(7416002)(66556008)(66476007)(44832011)(36756003)(54906003)(66946007)(52116002)(8936002)(38100700002)(6506007)(6512007)(6666004)(38350700002)(1076003)(2616005)(26005)(186003)(508600001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e1nxkMtePxXUNeJG+VpIag7CfjMj3fhyHLwK1cIMOouM5DR6d9jwt/MTm0in?=
 =?us-ascii?Q?h+1Silrm21lmFL72s9H+3HUZz43EkKioJIHmMGwOjC45AexPkdCoGDLez1lB?=
 =?us-ascii?Q?omdgY4VQ0FJI3sfwlOzCsVuMlDHUm72EXCmFNmdSSR2ydq/jmp1UMMnM7srk?=
 =?us-ascii?Q?rqUYlHgBlXipP+xyeeh+/wTMStJgyOHhcsA57u4yXjJua281B+Ddcd+biUH7?=
 =?us-ascii?Q?DCK/ErI9/pblw8q0uexU+06bbPnsHPUAeqkHQtkgM0n3xd7PZyEiLtwpwFa0?=
 =?us-ascii?Q?mCZq0cZsWbUpyLkQlrreh3Id2p5KnwxaSiyJ8QzNiSDPu7XpuM88FIpeadUe?=
 =?us-ascii?Q?y/ycsmrXolPVAjSM5iMFm7eEl5hJbW97zZ0wUdiBDtf6fKyz8pNlXpMTicGp?=
 =?us-ascii?Q?eCkjL+vmueJZuLFyaptnFonrBOSIMgRtICZDzzc8fgq4j0oJgrkdroIQEDFY?=
 =?us-ascii?Q?IVxHq9Bk7+cl1QXpoU7A80CO81sognkZxwO1MJNmXdxB+3NX9dRPgqsRJ5BD?=
 =?us-ascii?Q?qBVlpfYsHuh+4E8Qll5x2URKFBDmqYDwdppwJ1ShykuPMedhTTm/1C5+1Sqi?=
 =?us-ascii?Q?Agcj5yMQ+XDUOp2BJBl74/YJDc1yVxD3Vq4w7dDAFdLn9gR2dzJYa1y+SaLe?=
 =?us-ascii?Q?UACr8s/8w5sdZcJeyjCDgtBJ6ueGk41bOYoFhP0lo2zzqigMl4CQDSQFpAeB?=
 =?us-ascii?Q?1wJqaFQz1fWGfIfpouPyipYm42pDQDpqRvFLyZJEY9RuC4sS8rk/GdQnC/tg?=
 =?us-ascii?Q?jMJxCFqXkVXZvw28lFnxpMRzOHGDj4tGmVPrQYKv0eIt6dRiAHkVzHyfw3DC?=
 =?us-ascii?Q?8hQA2GW9Dh1oMTfjONKZ1+31AVevirJgHTVP2T9MLN/iMFQW0ZdPBZECjs3K?=
 =?us-ascii?Q?bybxGwb9qyuuqi7Dc5Whp5fZA6M/0uIJEA7E+4uslxXuL5r1PSBcEac+rlOr?=
 =?us-ascii?Q?ZOiWc0kN/pUiF9kWkeXmm5N4d6UXXMRWnCi/ZOfIWswtpWZAOpkh3uzV4i7j?=
 =?us-ascii?Q?tUj/WSe8kVlOxi5iQg9cFVSoUDNZfqdgo86UmqqTOUa2CTi915Jk73OIBUuY?=
 =?us-ascii?Q?+yZrh2V4X5DevBTsC84N5KzhaenselN64DdWQ98OHB+f91FFcjheeA8hjbwb?=
 =?us-ascii?Q?OnTNlHZ+NwjDkgAeRafguxGs4PiC3J9+YdTlDe+8tc/3+KiKgZfpVIQEUf4a?=
 =?us-ascii?Q?LbyXYIlrrNRZ+5Bp0JlXa2lJzaZICq6cpU+bWivGPda5TGPPzPwAyQNRwCKD?=
 =?us-ascii?Q?/ZtoDiD5GrApa8O8rVGYlG/ElqY7TcF5NxrYeStPcgKBmxXNWXlJO83yhpYK?=
 =?us-ascii?Q?q8UdM1dv7H+ZggQoF1ViQ9EEV6n3DiUrxTlubFFtQ3pqpYzu3W95Pwtohv/m?=
 =?us-ascii?Q?5hZZnpYW0OVQ8JecRTeP0oFeNH/d0sQ6tjlCDOO/igV6TGQ5SHSJ+zwbYIC8?=
 =?us-ascii?Q?wZt9Q83nxKY4pB9OgWXdPvW8MxjmVw/cBCHa5CnOFZPLRWIQZtxglDyDVUfV?=
 =?us-ascii?Q?iX7mdXuRCnCzKDRENlzOrM2vY1U4Z10/JHcsAQfW3ur+Ry080cJ0AA9JT+Rp?=
 =?us-ascii?Q?BqoikmHSdJm2qyP6SD6quBrMjuEq2Pnc+hLus1YVPRLkeh3IFP1icRAG9uC6?=
 =?us-ascii?Q?e6be6gu/13/dvtuA9vqVgSw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eed8530d-7885-4255-7cc9-08d9fc80eca8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:14:50.8770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqxn2M22TkMjf1q/Po5myAlpd1CsI6nzR1AMB9YYKDzuPnq6PZZHfuKvFcOHVZGLKKhXnXEaOYKjEVvU3LMn8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series doesn't attempt anything extremely brave, it just changes
the way in which standalone ports which support FDB isolation work.

Up until now, DSA has recommended that switch drivers configure
standalone ports in a separate VID/FID with learning disabled, and with
the CPU port as the only destination, reached trivially via flooding.
That works, except that standalone ports will deliver all packets to the
CPU. We can leverage the hardware FDB as a MAC DA filter, and disable
flooding towards the CPU port, to force the dropping of packets with
unknown MAC DA.

We handle port promiscuity by re-enabling flooding towards the CPU port.
This is relevant because the bridge puts its automatic (learning +
flooding) ports in promiscuous mode, and this makes some things work
automagically, like for example bridging with a foreign interface.
We don't delve yet into the territory of managing CPU flooding more
aggressively while under a bridge.

The only switch driver that benefits from this work right now is the
NXP LS1028A switch (felix). The others need to implement FDB isolation
first, before DSA is going to install entries to the port's standalone
database. Otherwise, these entries might collide with bridge FDB/MDB
entries.

This work was done mainly to have all the required features in place
before somebody starts seriously architecting DSA support for multiple
CPU ports. Otherwise it is much more difficult to bolt these features on
top of multiple CPU ports.

Vladimir Oltean (10):
  net: dsa: remove workarounds for changing master promisc/allmulti only
    while up
  net: dsa: rename the host FDB and MDB methods to contain the "bridge"
    namespace
  net: dsa: install secondary unicast and multicast addresses as host
    FDB/MDB
  net: dsa: install the primary unicast MAC address as standalone port
    host FDB
  net: dsa: manage flooding on the CPU ports
  net: dsa: felix: migrate host FDB and MDB entries when changing tag
    proto
  net: dsa: felix: migrate flood settings from NPI to tag_8021q CPU port
  net: dsa: felix: start off with flooding disabled on the CPU port
  net: dsa: felix: stop clearing CPU flooding in felix_setup_tag_8021q
  net: mscc: ocelot: accept configuring bridge port flags on the NPI
    port

 drivers/net/dsa/ocelot/felix.c     | 241 ++++++++++++++++++++------
 drivers/net/ethernet/mscc/ocelot.c |   3 +
 include/net/dsa.h                  |   7 +
 net/dsa/dsa.c                      |  40 +++++
 net/dsa/dsa_priv.h                 |  53 +++++-
 net/dsa/port.c                     | 160 +++++++++++++-----
 net/dsa/slave.c                    | 261 +++++++++++++++++++++++------
 7 files changed, 609 insertions(+), 156 deletions(-)

-- 
2.25.1

