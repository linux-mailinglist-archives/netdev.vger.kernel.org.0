Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF53C63A41D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiK1JGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiK1JGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:06:04 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2094.outbound.protection.outlook.com [40.107.21.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F6C17E08;
        Mon, 28 Nov 2022 01:06:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShNJqrXYJGCEPLywN7eK5EahH35OgPKHeFmcjc2xodaoyDewAr8Jzd+gYvy+Cr7WJBAhMTrWlxEdKxnshdB68Cu2HmBr0K4Wlywk2V9hxGlyjxe5Y/Uyg8XfrWTqlybVe6OCJNn/Xm36aqJR7izsGvQa5gHWbayVa+Fje+j/dz317n976RyADxKG70/InlAhSD4nMNvIvGoLY7MxeZnbmiApWFI9nQ8/PH63EnYiZgG5oOL/B8FI09MksJIdMSVW5yS4BRUbkE0mS4i4KEH5R6U1VmUifT3M9rxeYAryekIxOh4mM9kHhaOQHYpI8hx29Am1sZb0YXzrR84R/rrUYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vja1QNwU7rjQbP0mnE7QdMQ+SI5agPmt323oYKFLj7A=;
 b=ffF/cHFtZqps9ASjjOM3BNZGIiEnchgN5KZwJ348LSYh85IMKdbQgColPgZvJioCIzrN3Q1Xy13FnRVLk8ltiVA+Cu3kmhIVi6B5IV+QzqccTj3RJvgfoszitYnh0hWGRd3fogJB4NjZQ789ApNmQCZn7NjiAkIPCfLDXnH+MmyfaTeKmHpSyDJZio9m0uVpBMRwYBHsVwc1S3ZVojriOlILmnFzu7YSe7SbZBtXeLwN6jSEcbC6JFPaaD/O2dFvHi6BfPmnyWUQ3om6l8JsjtsHHHtuU5FFSvMhwYdorZEkPJmyH1pqXyoToMJ/N3XGmLf7vXGgGhofoy0IrPK3Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vja1QNwU7rjQbP0mnE7QdMQ+SI5agPmt323oYKFLj7A=;
 b=vmYdwUOnye3J8e+4ZS2QkGowEqx94pMCTr89/NXE4fJZP0UgF2/s2CGCi3dXg7dGpOHfOGEP+6e3K2fQTZ0DdRg5/F3hk8C372BktHn/rsTaDkkoIkVy/Twc9liLyiAG7uWTWWLFXYmuDyTgOtSVBZd3qLl/a9ShR/F0iI9xXmI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0317.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:38::26)
 by PA4P190MB1070.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:107::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:05:58 +0000
Received: from VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 ([fe80::5912:e2b4:985e:265a]) by VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 ([fe80::5912:e2b4:985e:265a%3]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 09:05:57 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Elad Nachman <enachman@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [PATCH] MAINTAINERS: Update maintainer for Marvell Prestera Ethernet Switch driver
Date:   Mon, 28 Nov 2022 11:05:42 +0200
Message-Id: <20221128090542.1628896-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::8) To VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:38::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1P190MB0317:EE_|PA4P190MB1070:EE_
X-MS-Office365-Filtering-Correlation-Id: 1873e0ff-e94f-4ad2-8864-08dad11fc33e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KvEuBG0vBLqsxCT6RbpHvr5HMX4/r+n5SECm4hJjymJPjoW8FKSmrQkR4XvA3hPVL6wEGP8R5KgXjyRXc8wdJdmW6VAMnirA4iKDj76be+BE7RdgC23CadEStkT1BU4faa2N25Cn2lX43rsD9B/eFvMn3DoaufJaLU6WTmrvDQGzVSksufZbD9QGtSFu3tzKRZeTsEX+7fP2ViW6Ur1Ma2cxD9ibejjhM5wQcSQ4yK5ud0vTYhCBaoS67XgJysu+fderSQ78sVuGpdeyonqPQ0E3BH4klFQWTHMvpU+A92LTZb82dxIMVYpq1J5ucqdolQubYmXbcy1/PAMSNRq92wHMO+qnf2MOzdYpLgJsmfrK9Vdq+I4f4s8cOXUXisQNrH39icvPoIlUhNrwdM2HKoPreVyfOGHAqh4HQ7iDLEDKRoW/iaiGNp1o4ZMV7mhl90L4ld9dlPUE3rK+XnuTwwyRpmofdnbmugHA1Sg03cPlHzXSgCLScIJiUiMm4bA/JYVOwQS+x7YG7FAAD/z0AGoLUsBTsa681tsc0GKaO1P3ZyFV8ouZJLepIZ16eO0pv1LNnHK9GkQoHAjkTBcaumI2Hzn1duBELDVZNurNcqe7AL2DkR4MqFwI8N8eYzI8JdYtW828SthjxKF7sSjmzSzMBwIh1AA1i0P4xR8fIJYItSNnq02HQ89j/5zSNo/fR6GoNC/eIUu/oSPbvIDzChsPs7alSorzSqChmJmXYcw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0317.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(136003)(396003)(39830400003)(451199015)(38100700002)(2906002)(38350700002)(4744005)(41300700001)(44832011)(86362001)(83380400001)(66476007)(66556008)(66946007)(110136005)(6486002)(966005)(8676002)(54906003)(1076003)(316002)(2616005)(36756003)(478600001)(4326008)(5660300002)(8936002)(26005)(6512007)(6666004)(186003)(107886003)(6506007)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lJTRLGHWvn0RqPsfV0GvO/mskxeLUYZEfDc3a+6x9GUPUmL/0lqoGcXCL5Jl?=
 =?us-ascii?Q?KZVdSM9o/ukRdugZma7oq3SIGnMQZeSGCRZ3A6Z06QJQXuJztvPhQ9LW4/1x?=
 =?us-ascii?Q?OhLY+da7MFuZPXQLUybIbv2D6YZ/nroOcCn1nMEAAswGeft1aTZKruuknHVM?=
 =?us-ascii?Q?vnXLEU5pTZVV4vuGBzMRtJ4izlNVYz/CuKzVZBJYFViQD2pM0zEjO9B2Q1ij?=
 =?us-ascii?Q?IK01rZBUfGOEtfAZRJ+hDarGVK/4VoZXRv0I8KqX7szyIdcHKSJA02XeMHHC?=
 =?us-ascii?Q?5ivZbAWUrlbv1RFN2A0JBBfHIbnB+L7PDjs8rXvmsDrm12QpuPJ+krL/eZjR?=
 =?us-ascii?Q?raM2PQrte2siKUbG0CY4ZT7Of2XNsG8a4ZChSkJQ/G1GdXDcg+kzypXay2gT?=
 =?us-ascii?Q?fAbkHhr2pN6ZKb24K7BujH8zFpUXFyHJCSP1DpwfXVOgpNQvGiNdm5ErkeWB?=
 =?us-ascii?Q?W8gxVHLnlu0J35gAl/kmAIX6HA1L8smDjJs74Pty42uejSZGFJFZIY3vdnQU?=
 =?us-ascii?Q?Ys2XL5MTZhgG4GuyAveUKTOfExcfoUmraO26y+V6RX/E2JkfoXy2anKbzdJX?=
 =?us-ascii?Q?GhV41kcEpKq914moid9pxgDKCyf4sJhhwq1EF/Sybne+4j4uQbAhhmZ5OEbj?=
 =?us-ascii?Q?KTQVb8PzlBzn/DZXuHKmIamDRCd/Ems4IbPecY0GIaMXvr802uCZG+8XL6Sy?=
 =?us-ascii?Q?2V+WAuNCcdkyoxFEa8TDe5JGCVm32Eofx16tyNyqdLGeUkvOjjFLmORuG9h9?=
 =?us-ascii?Q?2Y4+NllsErzOcHnJ49ct6kpJUTrwQgrmE05/+bmmKFS1rPejAUpFz7LmIybE?=
 =?us-ascii?Q?opRXETgzjZoW2knAtJ4EOa/44y5+UoqewrOvKtIO3zdirdO+YmOumcXbBepc?=
 =?us-ascii?Q?9tTIzCubePxK6w9dS97V4RODIw/srsbtyD0joc9gVhAV0KwMQO0xSKtqVIxh?=
 =?us-ascii?Q?71EikKU7/oaLO11wxitdjX18ZcLDamDzrITlEOrDAp6urnBdXeGgDtGUV+S1?=
 =?us-ascii?Q?58ZODYOgIP8fPz8GhsvtG9lNwbLb1NKvWLv0m762KEQ6dU/G+x5bVWGr0NEb?=
 =?us-ascii?Q?LpfSDWUjIZIIuVXU7FZgpkrApVK+Cym8LRwGfUbW350rmRUy5FmzYfRgcEAp?=
 =?us-ascii?Q?MLMXPoCMuLNZ5NjEmOzilnU9+EcqgDgGlgu0j5/BzK1klHtO7Zxre3akClkS?=
 =?us-ascii?Q?+IJDWgSKqbyXH4kC46x4YehLq5xnWyNsaZ+guF0K3ltfFIpA7KiuaDHxtYMv?=
 =?us-ascii?Q?2EwKMK8Twr1gX8d4BUrXeifYb51AhW80wko5RVauayGirwWd8x1kpCz0MuzG?=
 =?us-ascii?Q?coh6KyUeRnXiqi+GlgJoRO6cpqgWalem4Qkrl016wrNraIqT4NG8611rnbFw?=
 =?us-ascii?Q?rPKhjPavBt+B5eDTb+enk7GvxEbsFv1O7F8vxUYCSrbIviEZi9A6pvtOlugp?=
 =?us-ascii?Q?MwlsYyR6nsjeeE09Jxz3GfYuK8FUb+lLKT8/7X8mR3oVMSNIn0Q5rOa1e/OK?=
 =?us-ascii?Q?TXRHLRN8n6ID0i8Y7ipabLqs+n0IeeQH73i96TKFENXizhwt8SH9H4GXxVkp?=
 =?us-ascii?Q?orI+8ZkZy6VuO7wcGhup0rLjHBBg+48MO1xgw6uu7xYQpx/Xtlkp6wQCBb40?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1873e0ff-e94f-4ad2-8864-08dad11fc33e
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 09:05:57.8068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBqXOtCXNMfjwEmqGoQGv4vnBGM6CelitLnx9X6c6CZH0BgpVljrmDL8IONYyp7c6a+OZcfUeOjVvUZlNwHNGQM73ZaKQHTDghAMl3pE+LE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1070
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taras Chornyi <tchornyi@marvell.com>

Put Elad Nachman as maintainer for Marvell Prestera Ethernet Switch driver.

Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61fe86968111..3da743bb5072 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12366,7 +12366,7 @@ F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
 F:	drivers/net/ethernet/marvell/octeontx2/af/
 
 MARVELL PRESTERA ETHERNET SWITCH DRIVER
-M:	Taras Chornyi <tchornyi@marvell.com>
+M:	Elad Nachman <enachman@marvell.com>
 S:	Supported
 W:	https://github.com/Marvell-switching/switchdev-prestera
 F:	drivers/net/ethernet/marvell/prestera/
-- 
2.25.1

