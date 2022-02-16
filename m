Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469C64B8E71
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236607AbiBPQsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:48:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbiBPQsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:48:23 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C3627FBA6;
        Wed, 16 Feb 2022 08:48:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfFOppCktEebESWFbuIHYJ56BRPzYpvJs4P7Jk0697IgUWmqfhmc9txtSyaWKBiISJ7kL7vgu78TgIU1cMYxI+Mion2+4+iWKBGU3ebXFF+F985Noby9yyiOFPIKOWvEFRVax4XvkRsdp7iMKeMnFFpCU7uOAIyzFyYRRa3WcC/o864NdCGEKCc0NkoleN3qciaBPpi4ZyXiwthQ0RcQPIuXORMH8/nmhSBOsgKldIPgi7NMQAUEPjSISk9mRH+njO66wGbf5ahCBHEGASBsKnvsyovDrPZj7iZ25ba0jfOQrYpjgVT5N2xbZkVqVTmQ+wiD4t8r+Bq/EJzkuzCUWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OppAk68F1MgUtj6bgqjPfOk3WTkgLDTHksS8X3drSJg=;
 b=j/U5gRC20sWY45AniMaAQS5+q0dGTX+j//p/XLR3Q3oZyNHVJ+/GXN3NhpkOSHWyaCeXwbMqx18NWG0LpBEYX5IRsw09Sk8la3dNmBcBKy1PNkB1QufkDq5EEVX88JaAZN6/ePam0HWzgoYe3PQB8u33g313vMeDxVbJiobBIzKhR7uNzxw5+DCKvPF0ZyiEKDiPYuyQmVRXCblG8p6gvD+m1lkLn87vLKwg+LXmPUCC6vjMvsLDLgT8ytPzXs+55apIl70o4VctJScc9si/uLEhTzEo09B1L5ARhBYCQJcxVQi5byAHTOPEev/4kMtxQl9dzwgbUPv0wtlGmU66GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OppAk68F1MgUtj6bgqjPfOk3WTkgLDTHksS8X3drSJg=;
 b=fujv2/sQr024RA/vu+BjllLOyyXToDLspr6Xtvny7xa/CCAYPdYLswcFGWeJvHm5XmNFj+P0MYQpQ35N44EMDhFyCgo4t0nTcxQ/+cymytW7SuJZw38GdSXkWgWPyjUaOwqbWcwKZurK4zlPAyivM7c81Uvd9u25Vdby007ZCCQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4091.eurprd04.prod.outlook.com (2603:10a6:5:1e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 16:48:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 16:48:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH net-next 0/5] Remove BRENTRY checks from switchdev drivers
Date:   Wed, 16 Feb 2022 18:47:47 +0200
Message-Id: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0009.eurprd03.prod.outlook.com
 (2603:10a6:205:2::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 481402cb-6f8b-4059-95f7-08d9f16c1bbe
X-MS-TrafficTypeDiagnostic: DB7PR04MB4091:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4091620370314D8C6799E6EDE0359@DB7PR04MB4091.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MnMOx7XTvziFQ3OQ9KGZkscYp9ExrMNwmcyRzfCulSfpvOmGLuqvdcSnkDMmW1c+jEJvF+zH0a4rShv9FatfL5uPpJI6VMDTK50UNs3e3HtoOG2182x8rCWUV3fjM6CZ3fQgchn70esrQJPvd4yYU0netVRLgbh05ckkHviaINy+/FNvOIPGdFu5TkSatYu8UvCINpvzLv1SLCaxJl+GB9ckmIRqZcSngGe0WawvGV3MWxh9tFjMSFozaj4VU3VhVKxj/Qc0zCs/9OqKF508K7kxYHE46Hyi3A+WM7U1ZOlE96pfU+oIy+MZbSGmpsL29Z4ANKvNJFBRws+U8p07tVeC985NiRpJK+RsD87mQ9bCISq3yZf7pL/Suzlt/l6uzG20VkYg9IgzECG42uFOvSTZhghXFlQBdxKd7eYNUh/dPTPCgryo1FK6NJnKlFhKwjiv6ffVy2QA84AQxk11OMdKc+BDOuPx00R7BLCIBBUab0R6eW3MBrxzgbYkgiN3VZHczgtTBmh8Bw0YAyrLLWfbDUpCNaU7xVOOreOacrwQRrsPHfq+ZBqwgpLEwN1f6QUK5ljg2nE4uQa2hH/O3gO/wPKAhdayylKfZDvDhNkvv7Sy3xDmY3qLR5JOYfNDSk6UlQxUF5j9wyNffFoAFNFjldsKgHuGSu4W40lV/m2yBKCWSUc4065BEvKR/LUtAdb86A/cEeyY1pUxAim8RuCtJyF33GM6IWETWBbQKWYbDfJRKrBVGDhkOU5xTv3++skWWhYt1BUkt9XOl5ACYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(44832011)(6916009)(5660300002)(8676002)(52116002)(186003)(7416002)(36756003)(26005)(66476007)(6512007)(1076003)(86362001)(2616005)(8936002)(38350700002)(6666004)(83380400001)(316002)(38100700002)(966005)(2906002)(6486002)(66946007)(66556008)(508600001)(6506007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R641XOU3g8eET7DVSAnacoMdJOxmKtKKu1EhF6rHi3dXXn2jTJEres9aTwhM?=
 =?us-ascii?Q?7QkwQDi0Vtx6bn9P9iQ/+RvX3coSKPxVbwvGfmitG/+tTu0GnoZII4iTWdQ2?=
 =?us-ascii?Q?A+YjCZZb5+OXxlZOJ3RmgEyuNcgI9CKBBHUIS3KDvtnZpkZSyFhIoyqZDAmN?=
 =?us-ascii?Q?c/FhvX7getgOM91sc5tWi2ez6xfKH2FLW5qzN3l1o0E5t0I4A04yrPVhp1Xs?=
 =?us-ascii?Q?Y9AiMe6K5L4P9jVNYG474Vp6CbTaR91SrIge/goqUrGpp74lLjo2302nhihy?=
 =?us-ascii?Q?xE11qxsT3EcXmkUrv3Hwx8YHCJ10uUdwcbub8gpm6ceZi5+uQ+VoDNApVDDH?=
 =?us-ascii?Q?iHJvyXTadCkGkVQbjNYXizmni5jnagnYWsIXqTvDwcVCRApJ+xjjPfdcwXqM?=
 =?us-ascii?Q?KHW6ZCIP+Sg/crO9WRxbZBnhFvIfOw+qh+g/0L7R6yrtxOxcVl7+Cf+QYQtZ?=
 =?us-ascii?Q?CDumGzkiMK2QpLyiXkOSqNMWGwYful7MoSA5A5a8hdAmoYFZ0ZLA6gjyHb6Y?=
 =?us-ascii?Q?kKKQ6d/Ei9PtYCOAtxvAeLxrLAmknPa5cdX9gaBzBEpi+lDpdPJ5t/8Y/Mpc?=
 =?us-ascii?Q?NLZRZOg+tZZacIpaR2a2tM9FDK66YWuUqG1A6yUUf9aMNPNveM24UYmL9D0D?=
 =?us-ascii?Q?RbigST6tlBrvRSGwyuEPPoCNZl308Z1roah8VdFSm8J629jmNGcMwE4O8668?=
 =?us-ascii?Q?MAUpwK1935lFBVJJKFuutIvULgQN0aLuj/JS4BKbj+BxLpeSffQ86NTwv4fB?=
 =?us-ascii?Q?6Y1dj9+v6PtNOGDIctEhYDjG+Lyu5EkaAz8CbYq8fk1OaU320k67wN0nrmav?=
 =?us-ascii?Q?chiibJ8EI5U5kF7vGg1xb4GJtITouufZ/f5viMy8+3jhH9KThXrsrMcNRbtP?=
 =?us-ascii?Q?0L9TtoCcH0nR2g5vm91i0hFILUiCYlITyl4YJBXuvoa5U/sHqtyYzwkEWi6J?=
 =?us-ascii?Q?dh+IWiwAV2TuFNXJ7q/zveGZMyqjUTJ+Ztu2N9zyP1XKU+hLbM6JbpShpjm4?=
 =?us-ascii?Q?oHZgSHjYxA9WHL5eecCJRmE40EhUIYk6M4/FkrOKZ8srsoLATq/F6vS0E1Ib?=
 =?us-ascii?Q?sIvbDjtCA6084wbhebVyVdXDY1yJiUwSSaGqUXznZ8MYbfleqKpUUn6mNIQz?=
 =?us-ascii?Q?FySpWDR7uyQlEv2hsuD6Dnlmz/psiaGeQZPwzQLN0Qjb4zD2ncB7q51GujC1?=
 =?us-ascii?Q?UYTxt0wd66nJxKUZiDakRhQK5II4h63lWk0GRA+E9AG6GPZHNy5T/ZqPSPOE?=
 =?us-ascii?Q?8zq4FsGp/S2lDlEQoaFWYEEage0bbblGfzZEybXogi9Fg2vsLw+2VX0RgtUx?=
 =?us-ascii?Q?4N7R0Vcs3k0iAkzeuVS8CGt+oSmY899CDq1GO30PDg69wPWOufb+iaVdOry/?=
 =?us-ascii?Q?UshKO5lb99WtIru4qfytuDNL3CBJGPKr4RAhwQPEjFotjNqCp6HlryT0nkip?=
 =?us-ascii?Q?hWakgsHH06LoO3Gctf3KvDqJbVU3Zy3uNqMnQrYmRnusFPhp/tEqbwyeZlPG?=
 =?us-ascii?Q?74viBRswvYN0wqijwU4HkdUQv26fcTAs3zn16/BUSVsnmWx6sSla5dDpgd64?=
 =?us-ascii?Q?wLnmKPI85tf7roH/3HM66uUyZThFWMcqEk3mj6K6FZ6Z+HojcOFH4Gugd2bv?=
 =?us-ascii?Q?QF5pe4XztdwoGHxpRVjbil0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 481402cb-6f8b-4059-95f7-08d9f16c1bbe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 16:48:07.6216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kIu/XGQVr3X3R84JOWa5RxmaJGauEPQuuTeB4CkxX9xRb263oy2SlxmyTM1M5LVFFTu/SnTN5Rvg/j4q2qzCpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4091
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed here:
https://patchwork.kernel.org/project/netdevbpf/patch/20220214233111.1586715-2-vladimir.oltean@nxp.com/#24738869

no switchdev driver makes use of VLAN port objects that lack the
BRIDGE_VLAN_INFO_BRENTRY flag. Notifying them in the first place rather
seems like an omission of commit 9c86ce2c1ae3 ("net: bridge: Notify
about bridge VLANs").

Since commit 3116ad0696dd ("net: bridge: vlan: don't notify to switchdev
master VLANs without BRENTRY flag") that was just merged, the bridge no
longer notifies switchdev upon creation of these VLANs, so we can remove
the checks from drivers.

Vladimir Oltean (5):
  mlxsw: spectrum: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
  net: lan966x: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
  net: sparx5: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
  net: ti: am65-cpsw-nuss: remove guards against
    !BRIDGE_VLAN_INFO_BRENTRY
  net: ti: cpsw: remove guards against !BRIDGE_VLAN_INFO_BRENTRY

 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c  |  4 +---
 .../net/ethernet/mellanox/mlxsw/spectrum_switchdev.c |  3 +--
 .../ethernet/microchip/lan966x/lan966x_switchdev.c   | 12 ------------
 .../net/ethernet/microchip/sparx5/sparx5_switchdev.c | 10 ++++------
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c        |  4 ----
 drivers/net/ethernet/ti/cpsw_switchdev.c             |  4 ----
 6 files changed, 6 insertions(+), 31 deletions(-)

-- 
2.25.1

