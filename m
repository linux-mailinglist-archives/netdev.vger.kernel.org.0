Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4BE4C6F25
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 15:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbiB1OSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 09:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbiB1OSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 09:18:21 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30072.outbound.protection.outlook.com [40.107.3.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA120CCD
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 06:17:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nA892jkbH71e4kkvs56hJc0s5X9GIaxbHxsKpqCI0PjWkjiklQqRB4Ox6w6AiUQvSZmtYHL1L1++YhnLs1bIXpReaad/NTP9lZSuGddsRFInr5QyXW39Jj2w9p6qpIPgcwxGXk2Rcx2xrK83KE/VqoLHIS4h2w7lf8Zeda51eFSD+8h54XSUNnm50jCoE9mFZMHAu3qzpE8aiPoH+HDLSYA13enK/E6cRV3xnonevAI+TWas3acpDuptsMZkz1vA+FVBWpD/n0KDFnP/sIg6Xz8Ov8yl+aCz66k9ksnWTj2uXiTdM5naMnYeleBFgxBUsHdKaj1B9CZGcaIGVr4fWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ZJTTphXZZ35xTRU8xrXVJPNpF8aYr9MBgbravPQUpo=;
 b=HPbTvYj8oBDcIy8cihC+whd6bQAylpb8y9+6agOQUKHSRqUWhK2M/AyRB3jDeVshXmASxPffnc6I09iRW3uWyLkMZCkpQZsMoIKr7ZyPYk9sME8Ryi4pHirA3+Pe6NDkbI6XqzkIMkPvSF7ES2yk9DLXK3F+jG3MC4d8xDDed1huOoFVGpRBQykS+fSo9K9SJddrWg+G5ryMTikLNibE51QAzR+3Xjm19vFVhhfRQ5hrrZ2Kf23gHFiown8Cmv3SDb/8uCXXV7Jqkr9jjFiy0coTe3v+QwDpHfrb1QrfYvilHmSebPu9K3s8dFJFj3SRI1B8lvzTryPxGS1++6xMPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZJTTphXZZ35xTRU8xrXVJPNpF8aYr9MBgbravPQUpo=;
 b=KNNHwNr9ffU1StfP4GTkwLAZmHyxhyu3NSvC9/Lrmb6VGWNWPbAXAeYgI05tpu6KMr7VA9SpsmAF8EowSc7fTg1rW/kx3r9WqSLe50cBYS5GrL78sa4wwmnO+7iIfn0JlU+KrIBx32yoKKexJLXpGpPoy/1IBGThslF7PvONfHM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB7043.eurprd04.prod.outlook.com (2603:10a6:208:19b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 14:17:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 14:17:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net] net: dsa: restore error path of dsa_tree_change_tag_proto
Date:   Mon, 28 Feb 2022 16:17:15 +0200
Message-Id: <20220228141715.146485-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0110.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 647f52fb-38be-4b36-f939-08d9fac50fd6
X-MS-TrafficTypeDiagnostic: AM0PR04MB7043:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB704323C970B81D4005B35860E0019@AM0PR04MB7043.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vutXluRwHbvUDq+DjpllD65IPzqyiuahtV23ihKemP+JTAiUzvyHAhT1CASBhHevkhhdlfNkxZIZS8K3Q0fdRl8zwuTcnCtgHsviw33C3AwLGztvAAuZQG+7rUlm2F62BWC849cX8Bo+LV24ZzmpItHrVyF9f+XZuQVGFKG010Z30CsC6k5IGwJFJm51QIIOhUCU9HZjbDdSaRpN4nmxjtUWV4p95KaP8ylv061NPJ5FVt/zW1OJziY7ODdsFrUmVcaqNhGrVGoS1riv0xsk51t0vgiBbaYC7GsJM08fRP7pU20pz0wlhSc8Y1PzbIpLAR+Dcmr9Cl/F09WQlaQ0OgUS2RgH0jc2QgpIYwcwQDs//D+ov3SUeLLM/YHDColIfJ80YmViSe5QrjPrAlRp7Yp1UqaXzsxt/tfn+tBFxhbo/RHTA/zHYrrOlRdA47CC4uY1As+3dWg9HotlGrVbHwdIHROMam8J945l+CCc/VMqFSfloFcRVnqRGKXQSOUB675PZrDz5zRymQ47EKBnuj8CSgeTlC1ItCDH2X5AkgZHGi/z5Yl7+tIdg+TJuvWniP6BUmyiIrA2V6cq808NEKRm5Hh+pm+Jd6lKdkSw+GsgoJYObIo9ALPbMdl132M4I2LYD69Qvta+eTP5LDR7qb/v4ex2d0QrSRPB0Yx9OaCO+Qgj/kQtFgQVRHyDWitk0zJrM1jFAldfLWFE0c+AQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(38100700002)(316002)(54906003)(2906002)(38350700002)(83380400001)(5660300002)(6916009)(4326008)(44832011)(66556008)(1076003)(8676002)(66476007)(66946007)(2616005)(6512007)(26005)(36756003)(186003)(508600001)(6486002)(6506007)(6666004)(52116002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6TIyuFa/e80kPv4PrzQa6KvzXfZSOlRcFz3C4lvSjEUs1pCc7lDTDTzU2rhv?=
 =?us-ascii?Q?q02v9e48dWtOY+/uB7gLU9sCZljhOeEnQ+vbiM/uwN9ljwBWOT9YG9JPdtUB?=
 =?us-ascii?Q?rfwHLLNQqYXdrgRIcApCGgMwyDmWxyfnLxWnAtovCCvo0HlDQr6Rzb3kgTmi?=
 =?us-ascii?Q?cmxD6kGrI029nIs9Q0WqtVGXq4CM4bcwvnKchsm95AgpdL7f20bKtWyu2EP1?=
 =?us-ascii?Q?QSNlpjGd59y+FEKKmR+B+znDS4b+tqrHihCr5l7M/nOcAh9uwrSFK+6fTqz4?=
 =?us-ascii?Q?gh2N8RUr9ts+myRk8J4mVDdZViwYPDy3nC5WkBdW9mtxDSgcLXJKGq503qRI?=
 =?us-ascii?Q?irJXKOc4aeZN5m+tfmhl0jDM2pmf6fBacjBatItNCSStUZWL1GNr90ziEVJt?=
 =?us-ascii?Q?0Ml0WG5T2oxdevnPiKpiPIySqm++mZVdr5axVyGoqy0R+wApkfDLiRpHOuDN?=
 =?us-ascii?Q?xcwVB9HazOiiDveECGRwaA+65jttjMUqsqZmvnWnDCZar2fwQgnTDB7wl+Ds?=
 =?us-ascii?Q?eQxoN8kpnnUlTZ4KG0sTTBZcbLHehc6CfvmPDU0wDozqlNKFdyhYwDQlUT+6?=
 =?us-ascii?Q?ajY79egXPo7oZT/3AKnoYZkiVKLZaNt4WNxlkgFimwurHnOggJGFlP5UwEO5?=
 =?us-ascii?Q?MmtgSz/n5nPQQYuM8Tts8gma25t9NrVjesqkeXC5VikjQRh22XwYALamm9R/?=
 =?us-ascii?Q?7W+odzSVcwZB/5WsawGZDgZEezFiTn++tQJpnIoM5xhp/9s6SVcIL8T9Deu1?=
 =?us-ascii?Q?CrgKPrmWqXJB5xC+F8tfpF2zbL6tHcz3L6rja+QGrDdtoKV4piFHhO7DCuzB?=
 =?us-ascii?Q?dO9A0Y0H+0H/VEckoXcF2HC1N9roLqW07seL8jyd62AHmv3lHP0sFLD6Dhe8?=
 =?us-ascii?Q?VEW9LVidukVdhOqaCC+/A0AK4rDjPPz3kC32TqnH3vEr55rrpgJZQDzEMd1S?=
 =?us-ascii?Q?lhWkLCye8qNTAOdcgm689UtoKlYFCnwM7Uqt6H1GJwFHRff0ggM5pY/6qfQC?=
 =?us-ascii?Q?Fa0yTS8M6VMOlnGI6xvebVEaLs9eiE4oF8jnTqbsOHVw8LIEQVd9zk5fCBcI?=
 =?us-ascii?Q?Jq/huj7s6QrZRLCQqDbkHAlIUxsRzTW2FBueEp+8kW07Kj52+/hK0vMFabZg?=
 =?us-ascii?Q?xhn+qzkKXCD6o81NtkZzBILII232KOySTprbFSZMZWBg6YAYEvKqL0x6LlV2?=
 =?us-ascii?Q?VxWdePfHyJO5vbnZiHgx+tdeGpI0n2aS343x5vJD4CNJrzC7dgyriusDXu8i?=
 =?us-ascii?Q?Tc+m5mYEfQmLZXYjK3mvW9ThTwdN8svJWmMhGEDw8STirwroir0lDOqk1N0z?=
 =?us-ascii?Q?hXFZFrOAmVzvBjh4+lKuIpd8R/RHfTOn6ffQqmcF6azwuhC1PZJ9KbuUykJk?=
 =?us-ascii?Q?MWs5GpU/wQBTerxF7EiYvByzN8byRbU8JDWDZ4zI7UyymSiy1jjX0DU4sY8L?=
 =?us-ascii?Q?Lk+ztWyLUltHWN4iTC7VLO06vqtJwVOIOkjR7dmLBRc9DO8awkxoHbqr3mEx?=
 =?us-ascii?Q?rK2UeCWV1pZ1C16JJNubyN2z7UeAAo84PYK46OoObpmNgC4ERsovipeQivm5?=
 =?us-ascii?Q?SOGRI4ouRV5TEqxTy6+ZK4ED8nklDUQogNpHwK47r5Jw9GsfFbCuHHx5MX/F?=
 =?us-ascii?Q?mtW9b/BPYbAm5rFytCnsGtw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 647f52fb-38be-4b36-f939-08d9fac50fd6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 14:17:33.4008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HaZp57hyZMF5iyPR73Za3GOmq9BXvzJQN+Yi5VUqoQ6nYAEWQAcjIxWv5LCWdC4ruuQzPJb2NFhz5i95BSqqzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7043
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the DSA_NOTIFIER_TAG_PROTO returns an error, the user space process
which initiated the protocol change exits the kernel processing while
still holding the rtnl_mutex. So any other process attempting to lock
the rtnl_mutex would deadlock after such event.

The error handling of DSA_NOTIFIER_TAG_PROTO was inadvertently changed
by the blamed commit, introducing this regression. We must still call
rtnl_unlock(), and we must still call DSA_NOTIFIER_TAG_PROTO for the old
protocol. The latter is due to the limiting design of notifier chains
for cross-chip operations, which don't have a built-in error recovery
mechanism - we should look into using notifier_call_chain_robust for that.

Fixes: dc452a471dba ("net: dsa: introduce tagger-owned storage for private and shared data")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 030d5f26715a..d3f9dbd3a815 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1294,7 +1294,7 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	info.tag_ops = tag_ops;
 	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);
 	if (err)
-		return err;
+		goto out_unlock;
 
 	err = dsa_tree_bind_tag_proto(dst, tag_ops);
 	if (err)
-- 
2.25.1

