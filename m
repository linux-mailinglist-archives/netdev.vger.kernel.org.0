Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F226E32B4
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjDORGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjDORGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:06:11 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26E730C6;
        Sat, 15 Apr 2023 10:06:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8W5mn/7olVcASxe8lEWNorRnxRpRxXyQendCs+W8PLSsWgkPHzHo93XnC6xnbYIp56h84gMkspVY9mSIEe7+gHDLhda3MaQkRJnoA3BauMNIyNqcSHohcPrCNpwukHeSCTa80XHGtU0ePAAqHeznZcFdm4+LPZNNxoXYZHUmZwnawbQ1N0Dlgw17SrhqQEzu5+pG/7zkFZxFVQtZ7rAINV9dZhUfypgSnUg3MMySCWeSrwq/6vUA8tfUzm9b3d+V/2cidRCTyJN3/N09A687TCdWqkAdRbj25EdpKVqQS1P6aNrWjL2vTP54z1z78D5x6S6cHj5VfDxgqoRAuzf9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afY6r0Kn+k6weONKGzaM+H6Kcb4u6DXJGxF9+T37KLs=;
 b=BNs32kg9jdvuLXU1jYE9dKusdd1tWsYpZVurS69mXjcIXibrIfpnblBbYOeStJg08yGgw6WBns/Q7/roF8LnZVAO6zBkSJM+IThF80j5MXMUAWbQtjBr2c7qktZYmgqjxI5as36eosbp/RegKEBA+AlwTALmbeNBDYqa0HBa4s7DyIy1cL/pEehSjjwP6v8I242x+g98Wzaly7cTBvoWZncpxMuqrKxK+XaWcXOeXm3W47WHpMdpt8Ed6PzSdeBPER9mDq/Vbdvl3kYycWlY6eNhoUmrfKT5BFGaPmGAHn2XFJvxRsyD4MUNFnFJQbSo9E5GCKdACShIc7asQYmpJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afY6r0Kn+k6weONKGzaM+H6Kcb4u6DXJGxF9+T37KLs=;
 b=XioVDDmnkM4iwv+b6zOwwZ3KylPJIfxmyR7xWAG5CgLBobiZ+3b6gFMCEtRFuiD2qI/iBybRh3FBWVPp10KAO/vXOenns3j1clG+kJvAQ8lgSwVjLIOgMmBo0IL3w3Llij0pz4+FjovpZ7Mpew2TuBzJCYP9XZmieKYgWOb5U74=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8158.eurprd04.prod.outlook.com (2603:10a6:102:1c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:06:03 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 17:06:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] Ocelot/Felix driver support for preemptible traffic classes
Date:   Sat, 15 Apr 2023 20:05:44 +0300
Message-Id: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::6) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f0f1a08-5fa2-4ce2-82f5-08db3dd3b1ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1mlM67TYuobDk2vLgiRsC6jccMQaj12n8NkCeSiSPK3nwQnwwVtslVRBD58kaWbBLkF6U7BewKpZlVb2h29Uv7xqBhc9eYc0+Hi0iF534CIR8SrDYusls/QtfSWpfgOupTdkyr4duNoZFm9JhpOnoCM4/9+T+wFTndNgqZ22q5G2BO6H1UWhIsLHAGGxrsoAbXa9qNGoD3apNruMgsV2umcvyyfOaYE6DxLLo5+ihvuuOL+MnZJGJfhjOdWT0v/arZG+65G0hVz5wzqCYnCSMC8/RosWypeVnq36Z0tHPeoO4ZEiwx84uX6wAQfxEA2LYBZCSGNGICgSycRtiN3Ok9r0fQCW6wL5bAOxTxY0cD0KOZCk3s+CgocHGypOLiylsfHryDiVfSK+Vm75aN/SkqO3rrPt5Hievc8MAO5+lyGWFHmxZF64Brrp4Y4K5wqQdGv3unNgtd18+lAiISKBaCtHNMAvsTlB0emhqGhrR4Mb3cAmWX7YY2bIXxmwo49d65LUuQl5Q7tHdjDqajejjO9YV/DIrb5NUB2Tw2RyhsELjI49HODjqPrJSgkr6+ss1JY9MTSceMigFA275yyQTT4UP9VsZCZo8VBlQUQrXL8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(316002)(4326008)(38100700002)(38350700002)(6916009)(66556008)(66946007)(66476007)(5660300002)(44832011)(2616005)(6666004)(52116002)(36756003)(86362001)(6486002)(966005)(41300700001)(54906003)(1076003)(186003)(6506007)(26005)(6512007)(2906002)(8676002)(7416002)(8936002)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qCRL550JyZIaYtIqFzUJ5icv/qoUKnbMDHU4Q9CYeRWgKd72FdMULBjYCTJm?=
 =?us-ascii?Q?jQb2cKXsCwI5C+syQpqtlHelixlCVZmdfufl5LhWV3CJ06qVx3KyNnF8VPL4?=
 =?us-ascii?Q?HtHTR44dUsbjn9BlsJNJ5nCC8bHe+GQWUesncrd9FhtSV4wbH0XLY3NziZLs?=
 =?us-ascii?Q?qOLgrnGKj5pZOemjmbWe7LgExiHofUNUILDa6WCtmbtVRb+k+uNkDUakitiq?=
 =?us-ascii?Q?03DsPYzBsp6QWUrjlfb5mw2a/iq3wNw8Q3K19P+wl1VNaQ1s/zPjhcCS78q7?=
 =?us-ascii?Q?GSs5heekA1i9Sf3QQVy5/dBaSPK3k8L/UrChbKG7e7PUEKDAKDqlKpxFZnXz?=
 =?us-ascii?Q?JhDcjML3ZvoaOFuS/OSZzu48NY/S+BZAM760yyC32S2X1NclRkaRq5+m7CfB?=
 =?us-ascii?Q?X1YSJlnQ8p/2lRK1fCvBNUDoquV27M9Ke8oZ5l2/FGaM9F+J5hnSRGAAJ/XS?=
 =?us-ascii?Q?JozQPoB0TS09qR6nBGXxHdQGvFzl7/TMkoVmtpJLSjKbktZK4woMFJMKfX23?=
 =?us-ascii?Q?9shk46MYqxT9F/UZ70jGHChINqxm5XduMlYQomi0tOg9ORbcEVt0eAIecSRn?=
 =?us-ascii?Q?AlihabZlmOA2wqERKHHDVpfzEbqxnZz63gb2osu7GADhjoyuuWhLfUt/qNNf?=
 =?us-ascii?Q?ViZwkHzpPAzPgWZ9WKUT6F+eBseyujyovbCKmB7NH3k1gMG4jX/f+Kkh3J1R?=
 =?us-ascii?Q?aQBtUzFYdAnrsQZ2nvNiQSPeFibBr167pKQPkHeeP5NBV15/bngWBNdcBWhC?=
 =?us-ascii?Q?76269jbn8LDPonNNJeD3K1aJ8UxSD87I9GynOwyDJqaJVHd0zudB16kRD/gD?=
 =?us-ascii?Q?DQNH8F8u74cGlhWfMIxDy74VOePqdq/N7Fxr8PPRYhXCR7FLUkEF1QPSC8lr?=
 =?us-ascii?Q?Nheo61h2W+P4xpub0RXcbypfP8CFnmj4ZTXu9At7wdfi3ZsR/s0xR0lP7BqM?=
 =?us-ascii?Q?lrZ6uwwGUb4a4N9839Sol6UTOV0HlZil/rzXIpjEay1u1q60sOjmPCy9Pykh?=
 =?us-ascii?Q?6rHVuCrouKnhONUtFsP1P+hsBffS7rWxZ+WMWjrfpj44rrffFF4y7CEA6Q+0?=
 =?us-ascii?Q?xdNQKTP9TyQrCmCWgsYGH6d1lqdE8uZpYuVIbiUPegT6gdqgfxz/g4jYOZbh?=
 =?us-ascii?Q?t9mI2JAx3h42Q1cZL/31e+AT68Ny36CuGzXWVLglI/qOcP64kG8qbgNFLOFU?=
 =?us-ascii?Q?SCDJtBB8QIpvKsfPRQgg7BvIoVVW2gJ8cq8sFowCc2NaqknF3GmicZ7TxovN?=
 =?us-ascii?Q?BmhGH0yPJXzSzWzybBwdVCq/2DBIuydkjcJ3C55ak6HYR2m1jhn32u7slvMj?=
 =?us-ascii?Q?5CWygm97XRJ5myWbTV6Uc9UURE1XYfTiurzAm2Ef4+uukDSefaF0/AawT5JN?=
 =?us-ascii?Q?8fhwMGLgiRgpezK3sNeAW83cxIuFFYtBPpCPsFITUu2zsIFKIPsQCSs/xgB1?=
 =?us-ascii?Q?b5T+1f5uKVTvZtztIb/YSiqAkYg/7OGsHi6Y18lbxWcbQS1HtBiKvSO8urcj?=
 =?us-ascii?Q?B0Ud3SGLYiV//6Go2uDULHT9A9BSG/UnldITT4Avkq4yG2ltAbiYoegnTZx5?=
 =?us-ascii?Q?SeONBDPFlgpPkoKX9PL0zfVNXtxelxQ6gt9z11sswWjVu15yBv5te3lPWnNW?=
 =?us-ascii?Q?qw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0f1a08-5fa2-4ce2-82f5-08db3dd3b1ae
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 17:06:03.3527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9bLBmqjAtPu4+OiFcUG93S9gmzxSB6a8XQxZt3Vt7+BFXYFzZxa1nF5bkEboAOmY23FtIoq3ek7d9eD+r0ziUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The series "Add tc-mqprio and tc-taprio support for preemptible traffic
classes" from:
https://lore.kernel.org/netdev/20230220122343.1156614-1-vladimir.oltean@nxp.com/

was eventually submitted in a form without the support for the
Ocelot/Felix switch driver. This patch set picks up that work again,
and presents a fairly modified form compared to the original.

Vladimir Oltean (7):
  net: mscc: ocelot: export a single ocelot_mm_irq()
  net: mscc: ocelot: remove struct ocelot_mm_state :: lock
  net: mscc: ocelot: optimize ocelot_mm_irq()
  net: mscc: ocelot: don't rely on cached verify_status in
    ocelot_port_get_mm()
  net: mscc: ocelot: add support for mqprio offload
  net: dsa: felix: act upon the mqprio qopt in taprio offload
  net: mscc: ocelot: add support for preemptible traffic classes

 drivers/net/dsa/ocelot/felix_vsc9959.c |  43 +++++++---
 drivers/net/ethernet/mscc/ocelot.c     |  60 +++++++++++++-
 drivers/net/ethernet/mscc/ocelot.h     |   3 +
 drivers/net/ethernet/mscc/ocelot_mm.c  | 107 ++++++++++++++++++++++---
 include/soc/mscc/ocelot.h              |  11 ++-
 5 files changed, 199 insertions(+), 25 deletions(-)

-- 
2.34.1

