Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47CA4351FE
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhJTRwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:52:40 -0400
Received: from mail-eopbgr30084.outbound.protection.outlook.com ([40.107.3.84]:28293
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231148AbhJTRwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:52:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blNUjwsR5FFAtVbpPMehdpAYE5/a54hGYqCSky+lPNKU1AheLFFO1xyF0jDVugozONc+lMGhcVSS0IAlz4Heh/PHIMq3i6FmdJq0flWbM3zaBsoXUtQEEisBYdcoSMMk2e5fwDETBqc8ywhXLsAKxpfwTfDsk0ICzb16efT85iv29Q2cYr6q8oh/i/LXhQtpIfiim2ErF7dxTFCKA9wfW4Q7zrFTV3BvjPXX9tYK40328FhWYTrFftA068RwZDO1ZJOtdgW5rElHFwL0LhqMCwj/0HD1tcyqxT+DhXbe1p4gU/lIpuFYX7Zx69Dyew2q/XesLS9bH+MpYMQ6IqgBTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxKoQzxWqeB/UyNPP97c4PtW96krePrHG3DpO56Jvok=;
 b=K5jU8Ztd4sYSnVe7lhprDWxSmCmAbjgBQKG4TFPZDJKYoVeCmv/jkpxxg/ELMAF3RGe0xRpooTL11J3jv7wcpkj0XEKixUdcZm1AiRVGNb4ncmvS1OjfNv5EiVqSy3AgiBONmfV6c8lonmSihSFfVvo085+ds1SCnrkM/SkTbvgcTk1/kjioIOak/gXOGsTXYaKF0ZutjgodPH0FYFjO9bL7ZmA61k1lLCBHIl3qnDKanERt1k74KIMYjJrFpdt4Et8P/Ov9KPKAzJ6x/WZxC7ky+/fs/W2WA/LOh4O7ITdlpoOaW8kijqZRX7ksNUK/34kRhyT8xCee9BwcwgllXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxKoQzxWqeB/UyNPP97c4PtW96krePrHG3DpO56Jvok=;
 b=ppPKdt0wIo3AUXOktm0qUStc6u9pIxPGDKVPPqN5PQEVQoKuAiKXQYy7ctMJij8CT7lcJ0K/eQ5rktrnF2tfFxD8Q+qMd+QHu7CxBwE2x5xKRP8yx7u5NWKIOrgRFsreZARoTMDTnfCA/67eGIAdkq+QbvQ7jGauPYHqcexbU6s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Wed, 20 Oct
 2021 17:50:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:50:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RESEND v3 net-next 6/7] net: dsa: tag_sja1105: do not open-code dsa_switch_for_each_port
Date:   Wed, 20 Oct 2021 20:49:54 +0300
Message-Id: <20211020174955.1102089-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
References: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0034.eurprd03.prod.outlook.com
 (2603:10a6:208:14::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0034.eurprd03.prod.outlook.com (2603:10a6:208:14::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:50:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d8f496b-1707-4d57-b559-08d993f21422
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-Microsoft-Antispam-PRVS: <VI1PR04MB55017151F684B28C6FB04C7DE0BE9@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9bik0k1PSfrlNf0HEl75lmc+JUNep/YdE9GoEpL26FRjfgVrHHNiE4FaoCH6PnmI+VyYoGkGWp/P4b/soVYzQIVKns3IApSUEDeBCPMXBzKIvb4N+iuiFTErNnB+H96GPxwX6Oz1r24/vM8AXr0iA7TyJXL/A/B/f8x4JNgDcP9zZZxmkxfkH/KQ6KVmySPwwKAX6kxLSv/Nvyy2+PbQeHwFVm1wwHH4R8t6WSBhHR07upNzxLCoHyH6qoZxu8l2r8PhOQeWdDbvWJ93v81NjdbJThzT6byQVUJOydbq14G26nkUwo+APN/zHIdi2saZLRnXhw4kYtpsJuoAZ96JqjIkDPLW0TUTUQtB23K7Y3SbfS5Vu0ECPIiDJCKVQNmxLrIdO56W/RylLi3wFSWxaWZc3DyrnB5ezDryTr5/ImsA7D3l2ZqBvS/2Ec0vRYQXuhj9JUzLKn4D/b26+IwbuPIs2PbaglorHv+axmg3AKvdUAgsl0m8bcApLEaS5ju7m1RGFPNHmoyOvwyzxpELXOpNcJblFW2+sJJZNmuWAUq1MTVokxdFWDvZH2w5RZWcRuIUFUjdThSCkMdCCX7U7wZaZFi4Mtn5MKzxhA4uh2kEbBG7ldkKKBsOwWQNG6DfpgP/u4wsOGAFDtsugpmdVs3KAB8HE0yUbmLMk/UEhrO/VFue8/5V5vCYaIJjt393pnsk3cXnbSgywLMzJPf0Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(4744005)(6506007)(86362001)(38350700002)(956004)(1076003)(38100700002)(110136005)(186003)(2906002)(6666004)(316002)(54906003)(6512007)(2616005)(6486002)(26005)(4326008)(66476007)(8676002)(66556008)(44832011)(508600001)(66946007)(52116002)(8936002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5rH8LCfuNu3NIsLlwhEf9MYJYhSstXbKHbqwmwUbRyfbLTDtes5o0tQ1dmMQ?=
 =?us-ascii?Q?lnaGD1OQnmv1nEAy23n2dYGkDolfg8QQuvffdgmMSHgDAkxiKcK4ZRzgapkM?=
 =?us-ascii?Q?sZCgd1wsjpJhj5qA3sb3uwyIB5MrBdO0VH42UbxeVc5aNCYTgZ5a7WP/YIMN?=
 =?us-ascii?Q?9JxGsg1OHrTqoq4hrLsbRZ30xDk44yAsd5jnLWYikxW/ui3e4M0u0qbt4Pr5?=
 =?us-ascii?Q?C/OcX0ERAOLsRIjbmmv7CLimxZ8ul3eQ7KAfhhWmL2znjaxwVOFUw5lwwkGQ?=
 =?us-ascii?Q?n3wyAExg1lj7/6Lc5gx+iBC8Hzo38Wd8Gl0DRzSq+5sxIT+3HAx18mUy7ANo?=
 =?us-ascii?Q?W+y2acRSACWy2UBNi4CDL5R0PMt26bdltyxj1GZGUtoxacbZArpLQSatn2Qm?=
 =?us-ascii?Q?DCCZWhXy2I1r5Mn3vDA1TWQIKmisJT4roG5gxXN7dC/7nsHZi54R3+UOSFmQ?=
 =?us-ascii?Q?E/DNkazhjNmM+8/NJgnN6sFI4cVxJ/V2FRDJeEpjmQyqYbCIwFefmRVkrZ+Y?=
 =?us-ascii?Q?2s4o25QgF/tYT8i6X+jgBGLQLProwipqLuxncJRzq1IYQhiiLZjYi6GQaZvC?=
 =?us-ascii?Q?z287BEbv1dk4ErErOc3YcZN8cbLeH3AWN+ct+7QOP4BGYQInSAieEGSbyc01?=
 =?us-ascii?Q?VfPygJ5C/hd8kazY1VKQvFIyTu0tFiGaw9rUtQ5MeD0CERXgE2MwaQaQqGEu?=
 =?us-ascii?Q?/EMR0ooDtxAOJvh5LSaONIixnQK1YBm4zOFqHbmnSKtd8ApIxC599vsQCdtu?=
 =?us-ascii?Q?pHzy3nmZ2zCPoBU0IP4TvWfpsDoHfQuQnq4P0Xk+ngcWcJwN0FsKeFdBUchT?=
 =?us-ascii?Q?sFSQHL7LY0p5bpChwpAWmFpE8C6LtXaSghrR4iSFCM5RxVTV/KkZgeedkcGc?=
 =?us-ascii?Q?lfRH1UoNSTpO9vU1pP752uot4fBKWvsHnG9sDAVp0CqdZ1shsJAhPUT9AwIQ?=
 =?us-ascii?Q?UuT11qKsxLFRIIksiGqolDarTJ/GGM89PqS8XBi++bmEulnNv/f1JwU9fmUK?=
 =?us-ascii?Q?5P5JdoLQcsuZhGcGPjCEH8q8yrCkv98hqTZ2PfWJ4W8U4HBLerfADoDy1hgz?=
 =?us-ascii?Q?8c1IfFOSZzxGfV/Io2h66WIkpd/9CCHoXvzIQePqZ7QVcO1LirhhBVDM+Y74?=
 =?us-ascii?Q?r1LILcQ9BSykNDa0IjE83SHKX3Ibpou6UddN5mClEszr/V1Xkp9JTv8QRp3D?=
 =?us-ascii?Q?JD2OHyUa7VB/Z4Q1qG8VyPc2KN/nWEhQqYzGlRw+0XWgLXyHtGHoCRHpxiv5?=
 =?us-ascii?Q?wRyitLWuuvP4OY3ed2WP7X2zFyi0G4ubH7G86SZDIVBPWizcjlFXBC1y+2ns?=
 =?us-ascii?Q?1Ilo4gvqu2WgVTNhy1BBZwRi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d8f496b-1707-4d57-b559-08d993f21422
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:50:18.0612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJfeCY992/NeRZZWGW4Rsm4IKzT6a7ArYNIu0ftxx5h5ntjyrZ3W9d9VIOhioZcfnN1bPg9TcnxbzAVCVfQA8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find the remaining iterators over dst->ports that only filter for the
ports belonging to a certain switch, and replace those with the
dsa_switch_for_each_port helper that we have now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_sja1105.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 2edede9ddac9..8b2d458f72b3 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -158,10 +158,7 @@ static u16 sja1105_xmit_tpid(struct dsa_port *dp)
 	 * we're sure about that). It may not be on this port though, so we
 	 * need to find it.
 	 */
-	list_for_each_entry(other_dp, &ds->dst->ports, list) {
-		if (other_dp->ds != ds)
-			continue;
-
+	dsa_switch_for_each_port(other_dp, ds) {
 		if (!other_dp->bridge_dev)
 			continue;
 
-- 
2.25.1

