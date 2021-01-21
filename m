Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9892FE8D1
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbhAULbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:31:25 -0500
Received: from mail-eopbgr00118.outbound.protection.outlook.com ([40.107.0.118]:38844
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728390AbhAULa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 06:30:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjCyqr8nJt1S/c/jep5wYtWsuo50Lh4ub2dj5rR2UtKdGn//0X6ad77ACADWBSVqUbf5B/AJbe9/7DexgvmzGBbOM8we5HpErRFKT6jO2S9E31U9Qxzkak3wNTLBBVW9DwXn+L046IQrgw74gtTesxuMuYMFafp+ezDQzrAcJx8JFaPYIkd1X/7Qj16jDPSA3x/c6GgGd4YKi2BgvG1Z+nQNEGwWfBFCN0wFx8azMwFnKvFziZCMv8exq0qnx9zqHmirunOkU87cKc18u1N7b4kg0NXHUiNgt+hmoUufvKjaQIIorJxSpM5tfeWmbiUJKv/neXLOLxk/B4j3wjpCEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jArPTq3idWSsXgCZIkm6J+2GhZOeCMFl3GqO+5MqB0=;
 b=KBbm0zIns2y/oBxM/Phb9V1ozLQPO6JTrM86aHXNS0vNfaJTfbILMkSnZN5190XRvsmVKRmgP3gOVLOsKqbO+zGcnxR9DIjyWFddCNn5ZkwQcVDKYN0+oURFhsblGF6oiK+PsmmJOibcQzr7zOG9XmfFPdQ0sYfmVQB0kr0x+YBVvS52BPJ3gmI/87NVo8kwV505nXxVj0zPLR/Ai+FNl9vWQyTHDNAbIZf2Z0ccYqwK+iysEeMjHzGuLL5xP+rr6LXrOhc5D2N1mplOx65ujMMgc/vfrmUhEctk7VBnOXf7DS+xklFLVkbOMeUhH4LaqoXU98wrQ8NduTL93WWXzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jArPTq3idWSsXgCZIkm6J+2GhZOeCMFl3GqO+5MqB0=;
 b=OGKVubZWiygHvOU/cRD04gXAngtflsp3CLXKd5omPXVB9ueGocxvKhtye3wN7MhYl2U++34aEZ7Y5wupYxEz1X5HVOjib+9G0eKpBNuf9TnTHL4pfr+XJ8A6IaDpTVxQLQdUnjzt6+kAbObE2UozXQdgF3ULFp94rrdT9aGUhIE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM4P190MB0065.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:62::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 11:30:03 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3784.011; Thu, 21 Jan 2021
 11:30:03 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH iproute2-next] devlink: add support for HARD_DROP trap action
Date:   Thu, 21 Jan 2021 13:29:54 +0200
Message-Id: <20210121112954.31039-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [77.222.147.22]
X-ClientProxiedBy: AM3PR05CA0144.eurprd05.prod.outlook.com
 (2603:10a6:207:3::22) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (77.222.147.22) by AM3PR05CA0144.eurprd05.prod.outlook.com (2603:10a6:207:3::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 11:30:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9324061-2535-4f09-5e3f-08d8bdffe51b
X-MS-TrafficTypeDiagnostic: AM4P190MB0065:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4P190MB0065811D2CBB28019F21564EE4A10@AM4P190MB0065.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R5xpYQ7LvZWhWqeKVQWUKpnu14QSv38M2XeWwzBBcAkj19oj1/IrCbJK1LvcYEco0TKKc/Oj0Zyg3qtXH65C3fa2/zOqXC38iQP6eDYd7y+JOQFMcI91oEV9+5dTvf2iQ+h6SaaJX2zKNaUM4rzsxNMNoQkm/JlUKz2MarulxBwq2qwQ5FYNuaC+vU8F/dDa8lNKw67vYhf3gELu2ebKTDBDYwhzFQtoKDna5GW4ktwzuNhxgAyPHoSMNTlSvKBveTr5RjFUljSATfwSd9Gyk6bEYlMvze9GIvdAqySVSpRZm7XwVo//4J1L5rAPNnoSCNlpXdGCsp7gASv1GFl8NjtHWcxIOjAN8GAVyHE67y1PsbADNbbMUIoLJINjPmqPaH9BhgCG0CPHF4QdywCPpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(366004)(346002)(376002)(396003)(136003)(86362001)(316002)(2906002)(8936002)(6666004)(5660300002)(107886003)(6512007)(6486002)(478600001)(1076003)(36756003)(4326008)(44832011)(2616005)(16526019)(186003)(26005)(956004)(66476007)(6916009)(55236004)(66556008)(52116002)(66946007)(8676002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/QPRixWQINYJ9TFthge7OsO4tDyapkkX9abj/X10+4K9mtin047xaBuYRDkX?=
 =?us-ascii?Q?GB1V7AAV45TM/uNo3EGW4UGqqA2jcBHDqhEEMiYMzDpmJYVeX48zR0KesCRi?=
 =?us-ascii?Q?G2BNJfuBqEDKID4vwbAMFxP7KZ9xfng0k3fvsxUWPt3Zkh4UIKI3O9H40gfd?=
 =?us-ascii?Q?uGinLIdMV8aoTpE6mCOmd94QyCnxhYR8bfYcGD4InGP9pvKctPKYaypTXwjr?=
 =?us-ascii?Q?SosD8SMeVWmo5KSeRDE3SolwpC6V0NVXi6o8m66+0BLPyC0l1IsmXq6rrFLL?=
 =?us-ascii?Q?ZW1dWl+LerJ/mChgSS79psSvGYwUL4k8bjREPalCLVRuX6A9AFWnJHeNAPWG?=
 =?us-ascii?Q?ymEkpDou+DXuWV5FqwcN27oPk7oweH0nDHHb3Q1e7Qturhs9VqqM0MsTsqoE?=
 =?us-ascii?Q?igyGmZj99ZfF0zQoHbd8ExzfP6CY6X7/YtmEh/nuAT+XWxb6mv+Q4pYHGed8?=
 =?us-ascii?Q?yPwoKM8ATrRgJYqsYAyyTePM3GBn9Nz6AwwbDdWOCwdzBnOtS3rQPMhN0TEI?=
 =?us-ascii?Q?0Ze7Vj///531J4WDNGDlcU9L5bE35H8n5pNMPzgQl+ubkPOpMSyluxykjEY3?=
 =?us-ascii?Q?Wx019z8wEPw39onoNsCfdJpcee0dmbHyjkZAOP2TQ3zDIXsAV4znzowddaOq?=
 =?us-ascii?Q?BjXeu7pxzIyqvjc+bZRpCusJN1Syh72A7EYVgow7uLhDx16ROJ55OP0t7/h0?=
 =?us-ascii?Q?wU7qDvUXZwCIvXkqQGcvzco/ogDGVUyG/7NRwBVuuhpLC4gPuxTBenVJhC0f?=
 =?us-ascii?Q?wjgKkeAGiaOceyTk+v7C9n/ff/i1VAyS2xjLy6FO7+oIjpJrAvEkAeIN4TiD?=
 =?us-ascii?Q?WcyQRb06/d3UN46d7XpFTKPTKONCqEMq55UtN3q98KjGkrHsj7TP7ExIEiUK?=
 =?us-ascii?Q?9bgTDGTGSgm8tz1PFcuUa21YFVrnFbvxkpvgVJ4DKnmTxDL4Ma9SIoEOSDdT?=
 =?us-ascii?Q?HM/mjIYEe1B5rctdYlH22SVkCePKuN+Gg1rq34fC08EmOGzVwX/bIttV/iJk?=
 =?us-ascii?Q?A9zv?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: b9324061-2535-4f09-5e3f-08d8bdffe51b
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 11:30:03.2584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zl4FpQXHKX21R8DEb2hsw7NlxCZaXh8chNiFnE8VYhoJZl9QQzaVHy8XCI1haaiwMmXab/cqzxfGNhV5RWMcUFbQZbZJka0Onx7SwLSwMXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for new HARD_DROP action, which is used for
trap hard drop statistics retrival. It's used whenever
device is unable to report trapped packet to the devlink
subsystem, and thus device could only state how many
packets have been dropped, without passing a packet
to the devlink subsystem to get track of traffic statistics.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 devlink/devlink.c            | 4 ++++
 include/uapi/linux/devlink.h | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index a2e06644..77185f7c 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1335,6 +1335,8 @@ static int trap_action_get(const char *actionstr,
 {
 	if (strcmp(actionstr, "drop") == 0) {
 		*p_action = DEVLINK_TRAP_ACTION_DROP;
+	} else if (strcmp(actionstr, "hard_drop") == 0) {
+		*p_action = DEVLINK_TRAP_ACTION_HARD_DROP;
 	} else if (strcmp(actionstr, "trap") == 0) {
 		*p_action = DEVLINK_TRAP_ACTION_TRAP;
 	} else if (strcmp(actionstr, "mirror") == 0) {
@@ -7726,6 +7728,8 @@ static const char *trap_action_name(uint8_t action)
 	switch (action) {
 	case DEVLINK_TRAP_ACTION_DROP:
 		return "drop";
+	case DEVLINK_TRAP_ACTION_HARD_DROP:
+		return "hard_drop";
 	case DEVLINK_TRAP_ACTION_TRAP:
 		return "trap";
 	case DEVLINK_TRAP_ACTION_MIRROR:
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 1414acee..ecee2541 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -261,12 +261,16 @@ enum {
  * enum devlink_trap_action - Packet trap action.
  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
  *                            sent to the CPU.
+ * @DEVLINK_TRAP_ACTION_HARD_DROP: Packet was dropped by the underlying device,
+ *                                 and device cannot report packet to devlink
+ *                                 (or inject it into the kernel RX path).
  * @DEVLINK_TRAP_ACTION_TRAP: The sole copy of the packet is sent to the CPU.
  * @DEVLINK_TRAP_ACTION_MIRROR: Packet is forwarded by the device and a copy is
  *                              sent to the CPU.
  */
 enum devlink_trap_action {
 	DEVLINK_TRAP_ACTION_DROP,
+	DEVLINK_TRAP_ACTION_HARD_DROP,
 	DEVLINK_TRAP_ACTION_TRAP,
 	DEVLINK_TRAP_ACTION_MIRROR,
 };
-- 
2.17.1

