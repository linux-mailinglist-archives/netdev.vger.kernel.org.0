Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA24595DCD
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiHPNyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiHPNyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:54:17 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19282CDD1
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:54:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ji/8wjX2fZeI32bmS29NapYRbmesGoGBMQA8FgX+cqrqvrifAzwhtZ8I7MO6jV6wjI89LSY2OpSRjD44UB088ZfMYaRNJTBSi4US13l17TT+uKAYL6pdHJ176hPyx+bgvej/zEvs3br4sWog+KdGwupdU1CrPNyi5eZa6DwcDjGo8zGHDXhUOqiQ8rbdcbcPyXh7xi9zELegke7RHHkbjIyVQigZLaMduM03PsSvGH0cPMtlk1kgVbQUT26yC4lmIBG/Ehcxit5HL0+5fviDD51NWLU1mxjzTaVm/SKxopzRZPyrH/5qhXfZ//7jm8vrOAjoBJnB71FsKid23kFKWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1FYHUBLPsjZ0QKzoOjOZnARwHNzo+HDJd0eRxlHvk8Q=;
 b=VJj89nQOLAANlL5jFKqxGbWkzpPq73bobd9uyddJfUV6+0uri5q/7lOiGjFbr/pf6hSAPJz8lcA7CUZ358wXwsnSjRR6nmuqN+KukDA1peZK4a0Tma/Hjz5KhC2HmJilc89U6bM9WMzYjpfVPZVrxg0528SXb4uSp0+cmCpnIM6L8Am/+GFBic2oH/gdtTkHbl/M3IzsKpFGVoKEwBuTRicJvNAiX1RFSdOIbaU/kAka6IlRjAsUQs1Lm6v75HX6SrCvVxDVgttHW9C4Ny3AOUnJdyVATZz1YzizkWQ+K35+HfZiFyIdImOySMeh/XwYwBnPfTJ+hH8i8yQZon3Cdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FYHUBLPsjZ0QKzoOjOZnARwHNzo+HDJd0eRxlHvk8Q=;
 b=JeguogozzPoMd1avaen53WP3PF9fKQfPuuF/zVcdkqgIeGe/+3IhG0jQT718hpbKevXsR6E7bRWGzvCt3XmbKAiVmjDPjnGCBF9OqS68GF/oB4wUP7RhCbtHOHfo3nqWuV0ueLbRi0DWhEbC8OCNTmj3v0X2K8sviZxlcS45uC4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB2989.eurprd04.prod.outlook.com (2603:10a6:802:8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 13:54:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 13:54:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net 0/8] Fixes for Ocelot driver statistics
Date:   Tue, 16 Aug 2022 16:53:44 +0300
Message-Id: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0244.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14d7733b-3b40-4307-9d45-08da7f8eccee
X-MS-TrafficTypeDiagnostic: VI1PR04MB2989:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QcDFJQTKy4vmtXtL0qI+UQKBLq/aDFl6POH09dBaXDlaoywwQmWZHSgCOjHqJ2HaE5H04zTeK8QhOGSpDEdXBRLCxPpPMCdAdzEtRXCXXhxZD0Fj8tElXj/1h/3YVaKx3bUl1GQUitUZfHQbfooU+95J90L3Dtt3xmhQpmLWj/EZdmy8wZnTZZ0Hke0ikrvk10tpJn09ncqZ313fLIGpHgyarGCB59BDEf2P46T2ks/ix7aqERBB5uiCJrFp1DxNocTY1O0CfKI0SakOX3eJHqRBZpjOdIQzPbL/T2QaQ/o2lBvb1NQq4+oN7FgMyyzeGCerWmNm/g9dFIQPSMZ4JyV6iQvSywpl4pLOdjec0qnsbGvQXvNVBdERE9FpiG4c02yYIrvjbWKXa0sph5rBNo+xZPAVOIgbQW8CRfhSa7BkNo6j65OBCsGIWBbqy44cJkpEOwHBZnYfWyIlS/vk00A47TVulmnvdkgsVvtQNUoeIpdoDdamOjoEf1ecDFyiBnOszeK287skEmAxVyD9z5cnKEbbDZg3Bsxs7wDH7LOfKcjrOoJEPXI31ogXdjzXlJaGVoRYt1X305+fwaJ95B2+YqFO0No874wjy+mTJ0UemG2fbxlJbbr6soGB4++y6lY4qiGwC+EKyDmiiEeQNq6PEdw3j/jqOmaPRYbJvissSft9ItL0ETzItuvLEZ9tYDsbvoiQZtDCZPV71sAd3u/mlJL1KtqrLcztBCsdXSHhjIs8hfnRTCpAzFm4Aljd5lAf4wd7lCt9qHchwfHPOMzFvrcbpqf+RWNDYcjEY/x9uwGZ1ExklapL2MivP8/Vva9Hr54VqE2jBzvp7Jl3Jio0iUshxMKWUxNzeY0r5dw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(38350700002)(44832011)(38100700002)(2906002)(5660300002)(1076003)(2616005)(7416002)(4326008)(36756003)(8676002)(83380400001)(8936002)(66946007)(66476007)(66556008)(186003)(52116002)(6666004)(41300700001)(86362001)(6512007)(6506007)(478600001)(6916009)(316002)(26005)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mRvaOJsULu38aVJNIBHzKIZDr5LWjPe0T0QNuw8VP5oigqDsQMru0XqKa65s?=
 =?us-ascii?Q?J+Tj1XriXK9AZ4pZrB+ir4zmx2k7Z4XfEcUYDleP5XnyDpim/h3NrAs1p6CM?=
 =?us-ascii?Q?spYC1lCnVozFcrGfWudOxTCgkmzSEcKUYzfUTvN/AOx/DBEJz5hEUxuQSPfQ?=
 =?us-ascii?Q?VMHayT1p820gr8xItasHt6SngxtVdp7Pas3Vib/CbvPPsszzfAzV49RolpZc?=
 =?us-ascii?Q?CymnUpkA6GrbqxRRz9WMn9zixvdZIV2ovsuBA3axLHfyFkElWB0UHJVnAToW?=
 =?us-ascii?Q?jcxs0Dq0DUvANlz5kxQNE1qtkgl+Pt+WQ8NJOrbPBmelARlUKyl43i9JPbAV?=
 =?us-ascii?Q?fz7vXTed5Yqopd6cN+aoYaUP1hSIEM0WtVR2HcmHE8hEXvNiUJxDLLWlFVNB?=
 =?us-ascii?Q?pwJwefn8L74Yv1YyHyLWVORPFGRr8UiyeGCP5Wb6REarvfc8UPjFTNQoHeE7?=
 =?us-ascii?Q?sBtlfXmg+a+YRDsK9CejbcGkmFokbuUz/VYyF8oBrQ+5u7w6C2YmyErNc4Ry?=
 =?us-ascii?Q?k5Be3iHeEVZTn2l77Qiw4AyMfY4VZ7VVypIJyZwj/JrLy07EpH4Z7DFwjwRK?=
 =?us-ascii?Q?a7qkFWKqCZ4bUx6V1fL2+prbUiqvIiuR8U+u2/DTiKiDhCTULGA8XLKPiP36?=
 =?us-ascii?Q?U5mgIdkISsMNLMnFtTE+eRWrYTb93XgKXDsUMsguKzs2YXhO5Dh7JE5DjtYq?=
 =?us-ascii?Q?OGzY5WpxdZM1K4V+76aI/Xts2vWxJMacSAnEmsFXIo91sCz9Br+AETpG1tiV?=
 =?us-ascii?Q?04uEnJPo4x2wmDLvC1zrpaLUmzG/eTCEJKpMk203CaysUsmgrcAEFqI6BzYN?=
 =?us-ascii?Q?Azwb+8Fa9N1F0NBEmNCK+piCijkAxsziVRTbSohhezCakhMd6RiIdZ95AEka?=
 =?us-ascii?Q?m4jASYSad4u/sb2/D7tHkKr2eNDoWMYPPx69qpV3NNbkgF+xOXnTvQcoEm5w?=
 =?us-ascii?Q?yYqZ0sasVuSdK2BAQt/uVEkk1CYVDtDt90Ol1Z4XxJwwnGPTSLWl0fFLDSdG?=
 =?us-ascii?Q?QPr8vA4xbABnUCNa86yuz1aqAH58y9HQWQbLZDmjmaaRlTgQbbCdR8ODCLOP?=
 =?us-ascii?Q?uiCy6Hy547NKNqmrWPZGaTqlTaiQv6VnTPvQOPZj/NufVzH9zhylxUgLq5Qq?=
 =?us-ascii?Q?zmuZYaukgyY31g+3qCgGFulrFu6LNmi2UwZ4rQizlf/Z4Xke7zjQwrTpyG/b?=
 =?us-ascii?Q?2QBCTH4NKxK9pa8sU+iJWayjWDDt7ZwyfbYjHUvKDL/IK2ZsAgOuOxwvSyfZ?=
 =?us-ascii?Q?UYhHzLAtmT3viaWNP5QJTcW5mQDEV21eJ58haaU06q9s/xDzsofnYeTrTVKR?=
 =?us-ascii?Q?83PRsG53BsMt+yz+IJbIRRuv96ozmK/59ME4PxFsGtCYxhCJH25atQU8JFD1?=
 =?us-ascii?Q?S3nImzrR/IWpY2aXv8ozGSX5FPxm5vr9M9UhpTo3XEicoakJee7C94sejKfH?=
 =?us-ascii?Q?MTBFkX3pTY8s6yNH4X3zyP/0TMqDkGMqwMXLdc4eYK+uwnUI0d+QRESD3a/J?=
 =?us-ascii?Q?aOBkFocvplcOHRz+47sGwyTLHkUsUd/cxWV5QQVobRFZuxg3moG7W5Tfvi8U?=
 =?us-ascii?Q?nTmsAOplr65QnJpl3UTDn6CRlO9Viiv2ddlv1DuJXbjjUATDruh1xmoYU+jS?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d7733b-3b40-4307-9d45-08da7f8eccee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 13:54:12.9432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p+QhOm1jXUcBkVMOoS6NoK339z31MK/VLO5DoDHBuMVbaolz+Zv9VAuuwTRc/SglQ+Hl1bsg6Y1p+J2M5rh8Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB2989
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains bug fixes for the ocelot drivers (both switchdev
and DSA). Some concern the counters exposed to ethtool -S, and others to
the counters exposed to ifconfig. I'm aware that the changes are fairly
large, but I wanted to prioritize on a proper approach to addressing the
issues rather than a quick hack.

Some of the noticed problems:
- bad register offsets for some counters
- unhandled concurrency leading to corrupted counters
- unhandled 32-bit wraparound of ifconfig counters

The issues on the ocelot switchdev driver were noticed through code
inspection, I do not have the hardware to test.

This patch set necessarily converts ocelot->stats_lock from a mutex to a
spinlock. I know this affects Colin Foster's development with the SPI
controlled VSC7512. I have other changes prepared for net-next that
convert this back into a mutex (along with other changes in this area).

Vladimir Oltean (8):
  net: dsa: felix: fix ethtool 256-511 and 512-1023 TX packet counters
  net: mscc: ocelot: fix incorrect ndo_get_stats64 packet counters
  net: mscc: ocelot: fix address of SYS_COUNT_TX_AGING counter
  net: mscc: ocelot: turn stats_lock into a spinlock
  net: mscc: ocelot: fix race between ndo_get_stats64 and
    ocelot_check_stats_work
  net: mscc: ocelot: make struct ocelot_stat_layout array indexable
  net: mscc: ocelot: keep ocelot_stat_layout by reg address, not offset
  net: mscc: ocelot: report ndo_get_stats64 from the
    wraparound-resistant ocelot->stats

 drivers/net/dsa/ocelot/felix_vsc9959.c     | 558 +++++++++++++++++----
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 553 ++++++++++++++++----
 drivers/net/ethernet/mscc/ocelot.c         |  62 ++-
 drivers/net/ethernet/mscc/ocelot_net.c     |  55 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 468 +++++++++++++----
 drivers/net/ethernet/mscc/vsc7514_regs.c   |  84 +++-
 include/soc/mscc/ocelot.h                  | 179 ++++++-
 7 files changed, 1581 insertions(+), 378 deletions(-)

-- 
2.34.1

