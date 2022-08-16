Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE1B595DD3
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbiHPNyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbiHPNy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:54:28 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10058.outbound.protection.outlook.com [40.107.1.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B30357FE
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:54:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxvnOAQ+cXmWTqUNAs95/VsMBLgnCHqPcECHVUJsNkK21KS/ZNko+1H53sCa/+oAFP7sQlC0NEnBYsA5HNIMIHpIZjdpaNI6mUEO/9zL2nYqOQN/x+ZO/eOCk2czgH++YfiUjoAKlBoVr8/4BOIKTf6XPxyWxFLe+ukJpHhDvFmmEUGoKoJ3BLhDkdkCAC5R227ssEb4c80jy2mZ3nBU3nNWTfLjRz3X25EhZerVMhr2lyn0YhPHaQn4r+VTytHtp0ynmHtCxCNamtnFdGFgQPsLDGTipM9vmcqIQnqUQlE5rRde6gL8O22hLRoWJkf+Od2zuoJ/bLSTFr0+qrvVEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+D5OUjp/c87q6VZKq0y8om8v9eZHRS+kEGtAXoSqoWY=;
 b=kfLrmzVtmxv9gff/A5nF5Tnnoa4Ixbv4PzJoJJSvPpfftBt+f2pneKrRpYeyA3J1lWUcTy0YO1xLUg0T3WJih6rByb/gi6g7cXiyEtpIoPC6YrG+H6FY4Pv2VN0fqSU/Ts9s6iZWZsDEMSUhMOByJmrTFkHbdS2ZwIsJ8kZZDR8oyUxO26il/kPMukbFTN6qv514Z5r5aOlRSl45YyoRrnY5lQ9R5o05gxD32I3qwJS8Y3erJZcACmr+BKYx5tp4loRpG0hSS4/4yu7D8TKLRFypWXj5aqH/Rhjyd9oqq7TI7ZxmmMbuqE9tX1k1HwHYOVEm6RGz0RSjklif+Xk3zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+D5OUjp/c87q6VZKq0y8om8v9eZHRS+kEGtAXoSqoWY=;
 b=M0QglnTgEl59R5dx8hhXWvWUrEEwi80HIM/2IiKb+RR/EfnZoWGowT0kYXiSsjRZIKIOZCbiV64B6CQHxd+en4ZKhw2v1JH85pWGky6GChB2zpPy4nioXi0C7Tu4D3BQfBJduOQBOxLRq0SfebVfTmsadbSiBBgzhiwR7ErT3O0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5702.eurprd04.prod.outlook.com (2603:10a6:20b:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 13:54:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 13:54:17 +0000
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
Subject: [PATCH net 5/8] net: mscc: ocelot: fix race between ndo_get_stats64 and ocelot_check_stats_work
Date:   Tue, 16 Aug 2022 16:53:49 +0300
Message-Id: <20220816135352.1431497-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0244.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac8f2b77-1aca-4087-4a83-08da7f8ecf91
X-MS-TrafficTypeDiagnostic: AM6PR04MB5702:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8kCu2Tns90trE2A7vLDZ4Jm8kg9Z3xae4Lxhm7gD99TVyJykfbJOLhXOlfkE9pcmGFJK2Xh4mscaPgREwDQlYiFMinCmb2xao9tMOKVTZTPMBUvVk6M6vLDjXtflPJV2qTYMHnewRmoN2lHujMxe6fKmu9cNg8Xhrz/KmTwYXuRcXBSEUPGPxsgiMYAM7L+q8G3n7YCFae4fHnlc4tqvjX+K6D/IBCngcBFQ0v6P2lreCbByBn4OXh5C4ES/plLrYqMOlPu5VsQAqJxqwrd6vjReHvEJsjJpR24i/Hz/f7NAF8W/ElJ2I0vjiUb6nZTXvS3ywQkRvFFLHZ20HhUF2m6RC0d1rM15YDjDbhMlwJdVWALSSWniwj82gFI/4v0Qs2xp9sUJ0EoMczvGnouEaKPObhzI+c6Q6ct368NX9c47txSVD33vcgUujgQzxZTdeJX57vU261LAcoEeICMt2M0AKH1xJ1/GCBseGiA4aHxy0LadB6b4mwyct3IaQtT9IBfigia7aMJkcyPQm5QUkY6UOR2tMHZXhod8vP/qCXQiu3p230qgjW/Fl1YOw40WLQddMwH4sMjVWX/YOYpZf7HxNk2HvhCB1U73LhurjZJhcVncRW38/Jn7Xti2Qwp+ux5amsF7zFsxqrjhw890PY63in1vaoOx/1rWUKEZT03wdx+iHOXQ2EzqZcNtEAdKmk1/ACccFdF29w282wHAi2bEnHCbCqSY0Sp6rlGnapyzPeAjchuf0dKdop9bEwq7uVQFKsCxv64zVmRXv+PnCCf4F9wqRK8x4ORLsOegC9k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(54906003)(316002)(6916009)(83380400001)(52116002)(36756003)(1076003)(41300700001)(6512007)(6486002)(478600001)(7416002)(2616005)(186003)(6506007)(6666004)(5660300002)(26005)(8676002)(66946007)(2906002)(38350700002)(66476007)(86362001)(44832011)(8936002)(66556008)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?66ssP4MDbngv7emNyblkPfOCJ6WNvsf+52Cmr6HsjW5+7tDwJ2dXgcgyTX9K?=
 =?us-ascii?Q?P7zxyHa8yucvLw31GA5Am5dEkawXoD6nDcuuZC4kCi41EaQyOA+8aJvWNeYI?=
 =?us-ascii?Q?vlyuPyNHFIYboo1cIVBX2bKi9XfLX8B4DqDtp4656e3d2GPA7qIfBiedso7j?=
 =?us-ascii?Q?icoWOug2jsTgAV0s4ym8CU1pyJPU6HVApZFkQ7zxD2RibupZUiNL+TL9p7wh?=
 =?us-ascii?Q?qvwkyeUPgxi3nFqdvvuX/x2MeTithvOFg07gjO8WI9NFmgx0WPYEKmMxCaKG?=
 =?us-ascii?Q?SvkOK3+X19d4ldpGN7YJxczPYdUwNcE6YjPYyzLe9Lb6kyjurqGMsLEsBXIY?=
 =?us-ascii?Q?Re8vlRSpc/CWhLYcqKQ8nUHMV6ETiPcApiqmt2tbkVGQpUPG5pr0i/Pj/GPq?=
 =?us-ascii?Q?VjxDsSRnSYonbs41UoaeA/fmoABrHhUCnmg0/1s5Z9k4jqcXObN2w/bbSwS/?=
 =?us-ascii?Q?6x19AS9/H1KsUEr0q2txCozhvO+KSoPtKRe4eys+lB0b4bvSmrTzY82zq+YT?=
 =?us-ascii?Q?b41GE9l7F8vt3U3cieQP2rSFPL5gtQnsqa1KjBR4Qv6YkY5tK87Szg6pZNPC?=
 =?us-ascii?Q?ohyo7WRIxtwYbLkx1cVBtkoqExpiVnYg0/edEqpQlbl6hZ+eEac0tb1kTWPR?=
 =?us-ascii?Q?aGM3uBmm97Hx+fP3ohh/hVWqp3ArPun1DtGqJ4FobLapWkvBxPelcFYVEyyO?=
 =?us-ascii?Q?oetB4/roMFeqdx1/mrv41o309SCalrLmUYJ86kvkGzWdpjI2T8FNfc5ClMzg?=
 =?us-ascii?Q?XgOxxUCTxi/gBrNmsEsQF+Z3unl8jQEAklm/Nzxnxu+/eWqJ0RxxMffT6Vu0?=
 =?us-ascii?Q?YAcrQR2383SrhkWBwC+qL9qXyNRBg9addiE7L3B1RSl/0BzuBJrUoermS1wg?=
 =?us-ascii?Q?fZ02ip0jVPmbFlZEFyEb0zHNrm3WrMhWc4N7t1Z5M9djJZsN5bp2GnyrauwT?=
 =?us-ascii?Q?SVIP69O1BeOTGLBLKo/3YSkfn7cbjMhKi97bKhDVcqwBgxosHJAftHKymbd4?=
 =?us-ascii?Q?3SxHzlsR3NEkHHAkFv8JcmDKMMeac8Jg8OrfbGfhycv70aPC7zE/gsqiqYHI?=
 =?us-ascii?Q?/YbPIUeZNORQ5rxLwp75xvkrlmK7MozGoTHIwNxfx3Ruw3TcLLNtDVq9bW6+?=
 =?us-ascii?Q?lyFniq9Wxha7cK9KV2aFd70rBEsLcms7PgeAS+qLqmKcIdpdJ82lIHgCYvbO?=
 =?us-ascii?Q?2hBDoMhngkxbpS794zyOPF0yXhGaEdhPrKzmHaAx4NY1xXGbO8A33+w5gbIc?=
 =?us-ascii?Q?XhYaVDRVLg6bLbvONj+TEFm4vQ/5Yl0j9RpUO/BptwBdi6q3jiLWhgFk5f1h?=
 =?us-ascii?Q?jrZgZuhHPbLX4nH7LgO9WDTQoimt1GyVzL6Vpqri9UC+FQNOKE7LV2hLA9pV?=
 =?us-ascii?Q?NaLtvblgrtvo66KfKgzh479gzqBj/khPP8qCKbo2Q4RO3fhA1h12gfWwoR+c?=
 =?us-ascii?Q?yMCiwxq0fz/D0DI73SYse3dnCq3TTSqwBn8xNX6LuVQR+252cIpA/JI3piiy?=
 =?us-ascii?Q?u4r81H4YksPOj7YWSN8ZIWYBOTKfDAfY3gKa6eV12NMDDfiJkmFvmNmQ0pYB?=
 =?us-ascii?Q?MXX5/vc3i4l5rCs0+SFxUb/f4Kjow/2dF8SJZ6j/HQj+XIT0PUG0hCZQsuTr?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8f2b77-1aca-4087-4a83-08da7f8ecf91
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 13:54:17.2397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MINcnpjTrL7CTQ0pKTarYIXOU0aeyiLb89uZEoUcYnG1dlXAbbGEcx3ylkBz5nrd2rMTjhiKaBN5CZ6/VBsySA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5702
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 2 methods can run concurrently, and one will change the window of
counters (SYS_STAT_CFG_STAT_VIEW) that the other sees. The fix is
similar to what commit 7fbf6795d127 ("net: mscc: ocelot: fix mutex lock
error during ethtool stats read") has done for ethtool -S.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 9d8cea16245e..6b9d37138844 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -726,6 +726,8 @@ static void ocelot_get_stats64(struct net_device *dev,
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
 
+	spin_lock(&ocelot->stats_lock);
+
 	/* Configure the port to read the stats from */
 	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port),
 		     SYS_STAT_CFG);
@@ -758,6 +760,8 @@ static void ocelot_get_stats64(struct net_device *dev,
 	stats->tx_dropped = ocelot_read(ocelot, SYS_COUNT_TX_DROPS) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_AGING);
 	stats->collisions = ocelot_read(ocelot, SYS_COUNT_TX_COLLISION);
+
+	spin_unlock(&ocelot->stats_lock);
 }
 
 static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
-- 
2.34.1

