Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31D664D85C
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiLOJPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLOJPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:15:21 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2088.outbound.protection.outlook.com [40.107.21.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0F72E9FC;
        Thu, 15 Dec 2022 01:15:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anY/Q26ioToxMc3y4zcA7IMw1fl0OXueZ5Ds9Y7Z49vaOb70I7WT/DswmCf++OcfBEp76EZDGTxyvY+ci+bIG8fC/wk7mW33je+C6E4xXr1BquLRG2kZy74H2BV2oBGmxWspUh6Cx4MtfyM5v/lwL2QgBV3XQsD3Hk7FFzD7YC4opOvQTAON5l/WpMq9o++uqLa0Af7eXYbabSpfCEsWGFGjctO14mULGNmVLDuMw8qeP62wLWgJN+F0k8+GP1lab4FAuVWSpaaxSKsm5WQ68jE3XZ3kpH9WLmE5qYFSE5Pk1hl8aLNQqdS7UqoXTGQ3DjZ5or2A+EQZuwSQRew5iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZmB2nvF0k6CaxhQDiw3HXGt0GtUvm+uVW5lzBSdCmFs=;
 b=LmkJSpl1RSOlfLmV+hkptJS3hJCDwYyghGOYG6et9D3ksXhofI/s/T+AoOeYlFkSPa0bYVZmw04mc1LZyFjo/6jkPn90DTKjBvrDLIkUA9Dp3thq1Qfl4GWk6tnC5o+MRXXnlEdq7fdwRJWMMkJRHlLKod8hJtyTVJELBfpM9Y7HPrHjn1nw0paNv2M733uuT71D0iKuFOgtyDupaOaQpFnzHoAE17gGa3V+YIsL1an6oHxFOF0fEEkoSsCdMox61sAT9G5vFHzeh9be1nFoRsNw2BiZIOWlKGcaO6QbknravbejeNeN4+vy9iH39Z1tkM3UUJ+KwOZe2WKcliBxBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmB2nvF0k6CaxhQDiw3HXGt0GtUvm+uVW5lzBSdCmFs=;
 b=AN6ZiAbORPXOga6Z7Cd78ZlskElumjAeihMCFy497usBfS7MkMJoHGayaLymnUwquyrfo7jq2gNZIENRTK86WnAOLzP4oFEe9Lkay0SeYI9mQ3nmu6jD75kVbbs3R/U62JSuQCGAhmJ9gNWtxmxNJVpmaDGn276OH3WY2G9iSgM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AS8PR04MB8609.eurprd04.prod.outlook.com (2603:10a6:20b:424::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Thu, 15 Dec
 2022 09:15:15 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::e9c1:3e78:4fc8:9b24]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::e9c1:3e78:4fc8:9b24%9]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 09:15:14 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, xiaoning.wang@nxp.com, shenwei.wang@nxp.com,
        linux-imx@nxp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: fec: Coverity issue: Dereference null return value
Date:   Thu, 15 Dec 2022 17:11:49 +0800
Message-Id: <20221215091149.936369-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0251.apcprd06.prod.outlook.com
 (2603:1096:4:ac::35) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8106:EE_|AS8PR04MB8609:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b127f74-0206-43ab-427a-08dade7cdebc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jXiHO52Gay1byMTArtW5tqj/c2beESmGlfaWom3TIYRM4Gj5/jYRMPpq46KuO5qvWjl9LD+WYsyucicw444/kx5U6ThRiPOnvGp5S2PzOXwVdEZ4FTS1skVj+zyvClNXj/SQP+24uz3ywHtvKVZvvi7yzUxvEo8Auuy2AcSgxRuTDKOqQRSWnWKZU+u+tMYsEsLjgSAJU4qVbrA1cr3x+un3J93Z5V6Q6S7B3W7e8oHBJC5qo65b7NNZzYHcfvvH8VL38xMQsXevkE/uBEaJfgbvoQ4PPI3W9fWpliu/rZFu2PX+BciFAnYQ3mMTXQNcXJt7rkjzQHdgd9S68nHxYJpkckOYZ6dJoJM419EB8KUaR0JfySdcsYlt4enGw2jPB9ftzaPEkH+f9FsvXr79AfGPZG7yHn8pi4klKUAkWrWW2UhZeGVYvl96dZfNzWNQocXznGlQfRaGjJz8Avi4f1uV4tiOEc5/yMhg1Ymm6pHpZTgRb3jBX3ro9JryckbAz/DkEvX0fwR5Yy19rQEcCEt5mPfeX5TDmQdtoIa+uQlfixGiMyHHbtIXhGshFmcMUKwb/bmhlYNYb/qsJvr9hwTkqTANoYJ62IQMAfQ6O2ZLAogkZ0p9zzbK/OmkqzVitawqtLtdWTQWy24bz3Mci0hlWZeCqnbqzQUc/tHARww5Bde/9wUfah9vGdtCJN/BvGt0/MsA8I2hCRNZEXJjJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199015)(38350700002)(26005)(66946007)(66556008)(8936002)(36756003)(6666004)(52116002)(6506007)(6512007)(9686003)(86362001)(316002)(38100700002)(83380400001)(41300700001)(4326008)(8676002)(5660300002)(478600001)(6486002)(66476007)(186003)(2616005)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Rzcg5ziGOYQMDnR0ZoGY53YVfA42qdnC8vas0qGjMCZnWx3eyY1kU7AxwS+?=
 =?us-ascii?Q?AkmY/GPeH9nHEz6uDELBgBB+C+33cyyNm3IRRyUVilGG4ELmMLhZYw3ngMQZ?=
 =?us-ascii?Q?XOIOqfAqnPQTd1Py9VoAVp1ZFI00opRAj7O132QTUvy1CFTgotZvheHJ4No1?=
 =?us-ascii?Q?hOxRbXwM8gcofN9CkR6O2it0vZzFOhmj5cwrE9pPoczppkJ3ziMs+iCr7ypn?=
 =?us-ascii?Q?GxquEx3YCoEjPAXP9G6Lc2pQgKYbY5am4sUd8/RAs9mJNGIAqcuyWexRDV3J?=
 =?us-ascii?Q?EmAemX64hJDULQIT192AfUmeCuz7t3CvxYdNf7MtzgurTkUq7x8iZcYvV44x?=
 =?us-ascii?Q?k/N/HFSgNFfjCjVZa3d6y8dzvr+rNV1TcIfKpo464kN0p8+TExJOHTtHTTD+?=
 =?us-ascii?Q?wiwT2xqaPTvLKKOJZ1qys+CxeZGOFWyrbVlM0JdtIbHA+nYpAV1W3PjMT0s7?=
 =?us-ascii?Q?A8ccD11zi5JO3/iE1vSsxOrCRbUdZ2vBbxZ4QXjYTRq9207NKKf/v4edQml7?=
 =?us-ascii?Q?iNBxwkuFV53QQhbpRj9uz2I8Zc7o1GUojiMOGBtmp0tSJkFtK+Kzlk8W6H+0?=
 =?us-ascii?Q?Lrkoa3gF9xVc++Y7mJo6p7y4ug6QsjT3VH/PHEYzWNa+4sQFNyvxsywuJ5VT?=
 =?us-ascii?Q?tXU552t+xZEOz26rK/UFhWtIoMzfxiWEr5HH7cKHfXZW/rV42bWdOKOEs2O4?=
 =?us-ascii?Q?9PT6aBLRku4S2RF/gSNkCDgYhCPlwo9SOrtgJUa9+5V1CF1EEZjzoQr19ZDE?=
 =?us-ascii?Q?gJElKeSl5K6mh30dp6UNtTd7PC9OZE0w3jsrElmegsCklxepIaIFPjQEw/jW?=
 =?us-ascii?Q?dYo97NNdlAKfEaTpltOm9cVVx4bt83/Fs7RdFGVp3WMss7bJJxMmdd87HFQN?=
 =?us-ascii?Q?HwOTX76HGKHwWJo8THK9NWGKrMYkubqWOurTQmhf7gBObbbKxIg8+zRVLMhg?=
 =?us-ascii?Q?aC4/vvoX7/6SJs1uuoYt3icEheTXUjyQcuJcbxUQWu3Eel4anZByJnrJRX25?=
 =?us-ascii?Q?XirNuAvgAauzwwS79utbVrj4jd+HgXRnepOK6cZmKg44KJhu8c8+8yUIfS8q?=
 =?us-ascii?Q?1MhLoipognKwLjnyR04j4g3G9AUVEQBUwcPK/toRVXRyRwsUbkVwing0tFQt?=
 =?us-ascii?Q?L3id0Yc3XZizg5QYLanrtToNSfK5/5Fhdkmhizb5azrwuLIpByxvBMaWHzwG?=
 =?us-ascii?Q?tVAWBISxlNDaJVY0FdlDMkjXNR8l2HsodqLWqbWjldDjCr83gqsepsE/CJ1n?=
 =?us-ascii?Q?cShLMj8S43VYsKdUuTeliZabpnFDugd6oVYvoEfythG9fMm3AFNkp+vYJ6KY?=
 =?us-ascii?Q?vmn4jjAhDAIA37KDg7FulHGVFyJXEUMUaWcKnbOBBj91jNcb9Ne5mtQIamxC?=
 =?us-ascii?Q?i5/HlIk4h72uEw/B0rNIOgMrs3z5CmM4tXg5tMWP1+bjULnnmU155oCKrVNE?=
 =?us-ascii?Q?YngLtAYGd9Qhxu8zDqtmgEDz/N4sAY3J2TGybZm4knIIGXPLC+nxqMemOqfO?=
 =?us-ascii?Q?F/VvYIhoFkdcS1dmd13h+ejfX89ENO97S++v3aRfurQimTIbBPdIWJk6RxbR?=
 =?us-ascii?Q?Cqbl/lNKcFzOfe5Rfbfhy9H93TLkyEgqKWGuk8Sy?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b127f74-0206-43ab-427a-08dade7cdebc
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 09:15:14.2420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwcl3mgOmC6O8+88Yi+UKxW4j/ikpbEA/0/aGEKX5KWh6S/efN+FNmTv5t1BpJ4uQ46usB4ESRpeawYnQiwIRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8609
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The build_skb might return a null pointer but there is no check on the
return value in the fec_enet_rx_queue(). So a null pointer dereference
might occur. To avoid this, we check the return value of build_skb. If
the return value is a null pointer, the driver will recycle the page and
update the statistic of ndev. Then jump to rx_processing_done to clear
the status flags of the BD so that the hardware can recycle the BD.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Shenwei Wang <Shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 5528b0af82ae..c78aaa780983 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1674,6 +1674,16 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		 * bridging applications.
 		 */
 		skb = build_skb(page_address(page), PAGE_SIZE);
+		if (unlikely(!skb)) {
+			page_pool_recycle_direct(rxq->page_pool, page);
+			ndev->stats.rx_packets--;
+			ndev->stats.rx_bytes -= pkt_len;
+			ndev->stats.rx_dropped++;
+
+			netdev_err(ndev, "build_skb failed!\n");
+			goto rx_processing_done;
+		}
+
 		skb_reserve(skb, data_start);
 		skb_put(skb, pkt_len - sub_len);
 		skb_mark_for_recycle(skb);
-- 
2.25.1

