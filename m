Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2D9404232
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 02:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348438AbhIIATE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 20:19:04 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:42468
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348138AbhIIATB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 20:19:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5PmOAwZdurJUuCbx7TVuh6GCeVAdsn+hAP+eTG0pHID4Ne6Bdml8XUv0kFDTiT9MyrolgWXTH+IxmYQLRlMZ3Buq+5kSV1aqcP2/CpnzC6JQ4YGgylBeIO5mB5349A0VXLggYn+xfsJOMDX6HwQvUu8kWthEG1EiGaHitd0J6Jnbjn/WnogIrp/52ZzZIvmCI87TtwuNjgWShJtV+suZUnZKww7h2pKvrhwCUKl8UCtkmYQU4yObFgikpNX9BWAToRWUbwobIKEhePvPS0+ilua08gGENyT67j084XQsvA0BDCeabikLQ3DETF8EQ4ADIiGxpqeIuhjtC0HErqkLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=iGgi1cBe1MLiDK5Hq8PxY3rn4I4+FVhaWLr3/d2Ydjk=;
 b=IKcKZFq46JzYaro8u0U9+PgBLc94XeEi3Tg5thY9c7iUA84A6RBkPxjzDAZTVvowibxu8L/0LxX7I2eyACEtWuDYHBllU/OFIdVZG94GxriydrW6jPbRiU8VfcmrdqsVYldYLfBaCPaH24hpl9JNGUz5wWDdsFc+CUwIc+XEgXmViXUnBBASBt/UHn9GYAHYRXt7tl9Nsfwe1qvHQ6sv+x6mouk6IBMfXPj4og0EgZHWIeMGwK1YjwnXwq2Rc9ufOqrDFNKIA+mWM3GIKumAJG57oxsAnLHhUeKxzX5CKh6+W9xhfvvi5GKKBjviM4R9Fndk5vl7ZwpxeYkDjvjJUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGgi1cBe1MLiDK5Hq8PxY3rn4I4+FVhaWLr3/d2Ydjk=;
 b=qgT2xjqRS4L43bAnHRnJ1dNbj/GQDy+rr8eLnY32zchiEL4PgkFX4TU5nCbhN95Tp42nsO5ZTeV/Jp1stO/PERsLZLojc/zC5QwNRpFZVdgZrlAzqifKcpQAztYLkq5nZapU3U0RIBHZE3iAkhr1QWLhng7WyFyLIRYyy6s/nMI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 00:17:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4478.026; Thu, 9 Sep 2021
 00:17:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net 0/2] Break circular dependency between sja1105.ko and tag_sja1105.ko
Date:   Thu,  9 Sep 2021 03:17:34 +0300
Message-Id: <20210909001736.3769910-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0058.eurprd04.prod.outlook.com
 (2603:10a6:802:2::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by VI1PR04CA0058.eurprd04.prod.outlook.com (2603:10a6:802:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 00:17:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c75f880-55cd-4cfd-ba85-08d973274224
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6511CA03DF62A5172A4B091AE0D59@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O0xW3KCaa4DbFmf2Tk51kgCj/ancTu67CrCPo1dSYwQBu8WtP6tvUsuvAS2MBvPZJpujrH8OJgusQV1cX/jkZUzV3/RKScufz3UxZJH6pTX9qlzzBvGhWdBeB8M/iev06o8NKSOqVwBNTgGblQYMasoHbejbAyylcOCyoj+UcF4ygjGGvdnnT9lDTavq+S09Yu86ML+QwBaGjoxX/Rupx2/dPY1FvuKzgq4yAVMzSCEWgDTzBO8IidSKFRKAs0nmGY54xm13b7uqZeQCKtE8zj19ji+uuBNhOhZGFaqeTnkRf+u02jJl7sb0/ygPQ+a+CL4pHmynRdwTkgb1f8rOQrFT4pwDefhbQFy5FgFC9Hzx8as6OT/QVKxTr5nqhto2gusxiIfAozKVjtCljwRWY/0QsxlOK3hzkKqBZGKsqGft87RQArCxOIBZLSBk864jhljGmLKR7/6me/IwU/Lltaj6G6WrmfNu9412fspVUMZg7j6TYIxJrL7mW47CQfgVLjhkvgVbM6L3Mqs8S1jbU+wwmStFMoAO9ewoHh+iK+CaovRwbS+ePUrmRxMGyupekVVhMrcKDdX95IGX8f/SvsCHxuvdyErsp826vB63/096exmrEewB5b0pbOcKhasK/agKNEgxLsSGRIVYJ5JKHzI8ZEVGmpz049qFxu5ehoqZIADeuzILySWXv5bUEFxzYHLwKPbln+NKk9EzQuA67C9z2k7ygNUbhwMO586KEsF9xspY6KoAhwg+KLbh6MT4qGIreBT7iNzqu0ins7GqMEt+Wn116FlvEnWHW0nN+FY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(38100700002)(1076003)(4744005)(4326008)(8676002)(2906002)(6506007)(66946007)(83380400001)(2616005)(956004)(66556008)(966005)(6486002)(26005)(6512007)(8936002)(66476007)(5660300002)(6666004)(36756003)(6916009)(52116002)(86362001)(44832011)(316002)(508600001)(186003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aTitsuJe6VL2CMDux/V2AFJSPZaMJOdhKwamKuUo9rmALumNfVu9pl7I8UlF?=
 =?us-ascii?Q?52DW9t47P7xvCW3i/xPNUJEfjTOy9BjdMT1KLezNnde7mDyk2u1WraYyL7+k?=
 =?us-ascii?Q?5krkmlPPpLjuv4pgTlQ5gS5m+NcTzysR1SKdRnLzb3tNmHIXSVuKEBVGR1Ub?=
 =?us-ascii?Q?yh/ZGrAv8YkgB1RHqU+/SDBE8nl/Emt9rghkFMvcQ3uSOSXpbDwTYDBQ9Pik?=
 =?us-ascii?Q?Rnm5wGLJ+Nz4yan1iwYRfPM50Gh/STMWNGkAKTI6KJQQvO5doU8Ts9qBGHwM?=
 =?us-ascii?Q?HZtfWCGxY05WoCaLDXzxRXbLyTM2VLhemEFxm49eF34uEeMti5VZnyK98gEZ?=
 =?us-ascii?Q?urXmRON5SH4EaPWFXjLWmiXvq7r7vVMXozL8XHu4B9EMGbFRm9rrl66vsTIe?=
 =?us-ascii?Q?N8KOYmwYsgZgxU/fFZFpKFc4/9kBdHRcCfhfzoOUquBVVPWUWgHrzpxsU87f?=
 =?us-ascii?Q?AcKUPcHk0y2dtYU3lHkl9GvM+89g9zETn3kYWVP1jOmQflUYwJHh2DbjvIsh?=
 =?us-ascii?Q?F84biZ8LGGGsP65vYkWEmDcL6blJNeyvn2335rlVg8ymLDE3moJFyqiX1CXU?=
 =?us-ascii?Q?XR848qfMA+FnY3NSltcnjH2Qz5MaNsJzQFCwGIfhzsyWkN7ey1YCzyM4ji4r?=
 =?us-ascii?Q?jfkelRtIBJnqMb845K0O338M6XkiIaCwcFF2639cK25bLaiUpjRvODQCW0oJ?=
 =?us-ascii?Q?y1HGXU7l7mTMZP02zqf3wk3/EXzegU9JW2BfaP2WwRBMZVWoKHpBPgIEvhAI?=
 =?us-ascii?Q?JLf6WQAhvNxwOT6TTDm9/ElJQNSh5iAkV4Pqf0S0uj0t1zy3s763awStSmBp?=
 =?us-ascii?Q?sZAEmSw6ubvA3Gm3fm+fO/10R5vYdv3Gn6ulGtDDkHaLqikogJ4+/1e6a3QD?=
 =?us-ascii?Q?8uUchfz2etvSF7MakBJ0SC6uSEfMhyN4P/cEuGOwa4k+JMZ2mO9sFuGGkDma?=
 =?us-ascii?Q?vUwQhN5MMKSRXPL9h4VGT1Swo5wVsA8y3vV5SE/ParHaX08+2oPjQLb6p6JM?=
 =?us-ascii?Q?OiHBQqI/J9Tw1iEA3W8QsG8iFjF6Roamrzf8BnqLq21i/QkZ53ZQaPhF9Ho/?=
 =?us-ascii?Q?vpfv0NS+CHtY8VmV/dx4Yfx0ewUlbiVXD1InUzBO/VFpBZT6jwqmPLG/NuQm?=
 =?us-ascii?Q?e4pvFvbHXnAmSV4YnXQrQ/Cjp6YjEdThvSu7kjNYpwWibnrEloph7HbaqeWy?=
 =?us-ascii?Q?jMvdx7p83lRBwF/JV56Q4zT81i9fvrgZoCUGy2r4l2rmuvigqo1YHFvFW/Sc?=
 =?us-ascii?Q?fZ0vJsixFFwio5/ZMdunwIgUnUZE1ERgTOHkSU3O/FohCzRE2tyNPrdiYjpF?=
 =?us-ascii?Q?kHUD2ij0+vZg5TPSHgtcdTaz?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c75f880-55cd-4cfd-ba85-08d973274224
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 00:17:50.2316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GsqhzfXIfQKqJWJ1QZzwu4UXXoxNFMK69vApoXmv/jxrBByEzYT4MIrQmu0S7bN1mlMxjETn767h94AEC0HUWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches are posted just as a basis for the discussion here:
https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/

They are fairly large and I didn't feel like posting them inline would
be very easy to look at them.

Vladimir Oltean (2):
  net: dsa: sja1105: split out the probing code into a separate driver
  net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol
    driver

 drivers/net/dsa/sja1105/Kconfig               |   4 +
 drivers/net/dsa/sja1105/Makefile              |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 316 -----------------
 drivers/net/dsa/sja1105/sja1105_probe.c       | 322 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_ptp.c         |  45 +--
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  19 --
 drivers/net/dsa/sja1105/sja1105_spi.c         |  12 +
 .../net/dsa/sja1105/sja1105_static_config.c   |   1 +
 include/linux/dsa/sja1105.h                   |  29 +-
 net/dsa/tag_sja1105.c                         |  43 +++
 10 files changed, 404 insertions(+), 389 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_probe.c

-- 
2.25.1

