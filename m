Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3551D528399
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbiEPL46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiEPL45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:56:57 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2101.outbound.protection.outlook.com [40.107.215.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132A011C3E;
        Mon, 16 May 2022 04:56:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYWjQooV1bIbR1ImWx8d8WeOflEGcmqVMTHAUUK6GpUts4iqXeXtqd5aOK76h1soGdXzvJ2CE61QVq+DJee+QopNJx/MYsv8+olgryvgn95K8VziJXu5e9ff8WB5AgjOKqND5zk4ntiNriZyIpcoM5uHFOqR6Cc6hV63HcYTzvrLYrxA+J96xRtV5mPgdCq5zDY6GnT9W3UXAFnHRYTPTmGH0RQ8dnfzK7sBIHu2nvkd1qZdV1XTnS93xhlZ7FHrirc32F2m1ktvCYWYVgmsOuJ7iSVUlJeJ27YMNlMAGYpQV3Kh0dTyBdJjQJNSK82t0jg/DOfUO+AwmXbbH+a3iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJjiNImeZyqgWm6iKRExU3Qds3WzXgY/yenanrfZQkk=;
 b=bzrmz+fkEm8BzY79cXqwiiG4cZNjte+HSxjqXR4iqWZtEOTjVM+L3bCMsH36b5nf3CSUCpLpP1/LWenn6pddICABM3N1dnnYLTmHEj9m2UeAJ5YI5/EOjffo5i3SNcJibTtnw1jsbeLP35HrkWoetv0Ne2+4tMAkym53bj3APVh5KWBo0ZKPkJNZlcaYvi3WoQK9IXNJb0hWP27qoQFXJDlIp+OvNK3Tac27O/GzDxK8ku4QBPXegiqGNyrKkD2TslxV8cCgzac6eCsln38yED5FRzHU83OksDcKzSXXUU8Z1LCzVOmn31LeOrk1T1rjP5aCS1TM0CJDq08r22cVrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJjiNImeZyqgWm6iKRExU3Qds3WzXgY/yenanrfZQkk=;
 b=IXtRGFR1vg+zH2zcqVWXTqKET2xW4etVblMi6bed6pWKdvVHk1+4bLxjhEQhy3JPIQd9f2lKYQmPlzc03vc2iucfd80mr8OFmY31EDzC2oVfvd+5HxwGxAKTGNBxoYt7nS1pJq/2G388OIcIbkh75dgyNkeYe8sHWbypxsq/jeA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by PS2PR06MB3448.apcprd06.prod.outlook.com (2603:1096:300:6b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Mon, 16 May
 2022 11:56:51 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 11:56:51 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Ian King <colin.king@intel.com>,
        Guo Zhengkui <guozhengkui@vivo.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com
Subject: [PATCH linux-next] net: smc911x: replace ternary operator with min()
Date:   Mon, 16 May 2022 19:56:25 +0800
Message-Id: <20220516115627.66363-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0024.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::11)
 To HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2969509b-9f2f-4810-282d-08da37332998
X-MS-TrafficTypeDiagnostic: PS2PR06MB3448:EE_
X-Microsoft-Antispam-PRVS: <PS2PR06MB34489FD131228F52C917AA04C7CF9@PS2PR06MB3448.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DwW+K1BoQiionY68h1HtHgXIfcLel5hyBPBNZ29YDySt7+ckXfjmJ8ORwqBtDUtjAPKIZ5lvq6ZxrVFtAL/iMzXx3t3zxnIW+qvR5Lut+sODVcy8Ks1TG4/otTfW9DoM4h/aGDzD5RoVLtnCGUy0jgpIt1ruYPhdnFgCB1kGZ7J2fl0UPfhAzK1bV2QYnQI3FXnZuRQHp5kcWjVvwr8wVV0lTtROeHT6P1oajqKt/avDtDIs2lsRcp9dpuIO/rG3iS7vrJdBC9T6ZhOAtRnF0uV+QKT0pJ/4iOJsNHgLG1iWiQlvFQiwJNnelAmYtjT/nTdDCk7E+5rxH4QnArNyE2QoIQF0NlOC2cI/p7ra4agW8UMwS23r053y6gEw69RS6fcDkH1WBpOQ5mnJDyJ/0kfsSV11MCI28z/AP+PA0YrtVEL6kydonEo2rsEn1QcB3lyDUGMGs52Fsjh2U7Jf5asvqrcbjHHUsZQbPP+ai2QePfEuX0hW3u4QZYwPpjCenRqiDJBODjBRi5XnNAiEy2i73IXO5hOfjFxoTI+ZWjFWLPF51I9I1L8hOTZPvquYoF5tEjdsAAO143eQSVPB2tp389QMszbSezHPyIKHCdTQ/o37yErMog7Rr0lJpY331P65Hul9I9uzELK4uIIDJS+yUbyJS/IlyAgYBefMT5ndBtYZ+Z5Ge5avxKYL1FbVapolM+EMMZ563zBqkBcK/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(86362001)(6666004)(66476007)(38100700002)(1076003)(186003)(2616005)(6486002)(110136005)(83380400001)(2906002)(316002)(52116002)(508600001)(4744005)(38350700002)(8936002)(66556008)(8676002)(66946007)(26005)(6512007)(36756003)(6506007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c2wvEivsl3NlwunC1WqaEfich/qa0Zl7drDuOLF6wrTbmV1q9IawOI6UUqj8?=
 =?us-ascii?Q?I61DZI3+gnm0J5TRsNo9FwY+MWuFVbo8AmmaVP6eIR8enI2Nz9o61FpRSiiF?=
 =?us-ascii?Q?KkIgirLPpMHfqZzVX3bj2WV3dLmZPI0RaPlna4rnu8aXSHmutUyKQ0R5rxiZ?=
 =?us-ascii?Q?lyxHHXeJtXp5Olu1LaeF7Rbctv/Q+E5hgBU4f/iPCcb3YoGrrKRPlcyupjXg?=
 =?us-ascii?Q?gH8IB+RVJWpc8QzXIiaMx22wYhuWAGDEEZesyR43iwqOJKyhNnsc53aSjVv/?=
 =?us-ascii?Q?7dAegWxfXddlGWZhHXoO6fjffERpU+OyjIk/gvHh3Za9kiQcRPbTgyp72xA7?=
 =?us-ascii?Q?LRhr7I0N2MdoAywEMZ/HzW6l26MPQmpNxCywk7h4N5DZ0KJRufsLYOfACxXc?=
 =?us-ascii?Q?Ds6hLKIADdxbs4d1rWvCIm4AFxZIZHnEoVhFw9G+HXlvw9NezKX0FYfxJpJv?=
 =?us-ascii?Q?OiXZuG0eooqdLcR5ogoRPp+Wcl22czeWk+JyxGGCX4ra4jpOdI2FsgCbowuU?=
 =?us-ascii?Q?JHZuIh64sZVLxWJouETU7b1stCGemsWQD2TxTg5ZwAu9cpDEV1FKNfv/dlPS?=
 =?us-ascii?Q?OA+SLth2aQD2gTwT48xIyCALrzPK7+OkAL896vbZ2+Lwx/AuJBJtImPloU/y?=
 =?us-ascii?Q?FPsCg42JWkccOpOvk74JgQWk7Pt2oR5cfurvOIudygAij4hh/gGM8EzieJ/a?=
 =?us-ascii?Q?ySYx2jrKxnbFwh4PRstjXUYxk53gudjmcqM+jEK/UKnhNJpomCWJDLdAvY5D?=
 =?us-ascii?Q?gZbzbjWOYb7h+1EwkRhG9iY4Q0Ro6azr9JDgSFI6KJ6VTw6K37eUxoRcrLO5?=
 =?us-ascii?Q?a7Z5c9/ioyQ8q15aJc7WiSe4fFu6Rm14ShSxIG8ShN5UbiYZIZ8YXQ6XY6Zx?=
 =?us-ascii?Q?TZQ56U9hTmQSMNyDykBls/OfNmWWj5Z1Y+kON4qkgFhYVPpmF3irixFj88EL?=
 =?us-ascii?Q?9Z8Ztvc9QMXxbGuZKnnDUO8d4zoGWVOs0ga9Wm+rj9tGMwwiywcyfJUW0Ryy?=
 =?us-ascii?Q?tLHwfuPJskCKIHvfTc2bezhuCkg6IFtsfMLPpB7VVbgZd+RRUTsW30XxV6KP?=
 =?us-ascii?Q?kV1vlp7A8+AlHlQUOV4xzDADv0oiEa58Ci634mWM8PgXt3c2iYKOYDLo589w?=
 =?us-ascii?Q?ATvwK5kHxxvchilf20PzaFQQsovmDzuaNlmisUh1Aw2Nl1lX40lQFjIzKjL8?=
 =?us-ascii?Q?ASY4wHaSAyMNDMCcVyDA/GhAbuEXu+tazjquZMdx4f5P38t9GLcxBmCbA94u?=
 =?us-ascii?Q?H3rvQKYfdsSC2PKMn2OZAm2nrfC4pQ8lGuH6/sIusNc9U5DVaKWMkUz0Tuh4?=
 =?us-ascii?Q?IC/Ixh5rH0yCerB3ABrWbBENfrKC/eAr1ZS4f3W7tvx7buRQA8vtP3OWPsEX?=
 =?us-ascii?Q?xL8EhrpAaLL2lWBHa+ZNn/mxVEcDbBQsWSxTSBtKIKXKOciLmbj3dyvx3gTE?=
 =?us-ascii?Q?F6Uk/CB7WRlP3JJFecZQ7jRq1H+msD5N22myIlGe6gwwT8NvBYDVdVTmWu7t?=
 =?us-ascii?Q?DARUU5spR6DKhirp0n8alNmrk9R7R/TktOuuNfvb+rIXezY8pkxRxVgM15pZ?=
 =?us-ascii?Q?SnRfD3pbJpswFM8U8ZL4QK4ajETAMDdwpsGYkSObKUmQuiUUy/GRLKlV/Xq8?=
 =?us-ascii?Q?8xpq/GRZg0xbSrX48NxceiKpxQeXBC2y44Ta5bLrb/9GyxDqwEc3MoD0wuId?=
 =?us-ascii?Q?bQQehbIShWxBOkCPmNN4Lcpvd2FMmTDlk+fiiXGFQpoicREPVDQnD0LWJLVu?=
 =?us-ascii?Q?4pmmOtH7WA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2969509b-9f2f-4810-282d-08da37332998
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 11:56:51.0325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ktAgj3wmYtZGStv/k5IAkWPfkbAT4hnZ0uirs8QQgmfO59TrciQP/RVVOTCyBfjOqTQ/W73ofoWBdB5tDfwMsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB3448
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/ethernet/smsc/smc911x.c:483:20-22: WARNING opportunity for min()

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 drivers/net/ethernet/smsc/smc911x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index fc9cef9dcefc..2694287770e6 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -480,7 +480,7 @@ static void smc911x_hardware_send_pkt(struct net_device *dev)
 	SMC_SET_TX_FIFO(lp, cmdB);
 
 	DBG(SMC_DEBUG_PKTS, dev, "Transmitted packet\n");
-	PRINT_PKT(buf, len <= 64 ? len : 64);
+	PRINT_PKT(buf, min(len, 64));
 
 	/* Send pkt via PIO or DMA */
 #ifdef SMC_USE_DMA
-- 
2.20.1

