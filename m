Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87514B7C3B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 02:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245449AbiBPBIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 20:08:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245343AbiBPBHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 20:07:55 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10111.outbound.protection.outlook.com [40.107.1.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405A8F9FA1;
        Tue, 15 Feb 2022 17:07:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwdIGoCLjcV5c7a0VuxMdtUMhLXzpgrXXI7VZy1NsB360qzfiVWiSSTcVdRqj73FJrrBTGx5RUBZfmr1SKkTs7y1tBRfqRGN4eSBNFVy2QiPMhEZqugrvvLCBietkPhNFz1sxWVqq67edZQj8tn2cGPUUbFasW0QQTfTddtuVQnMzIjgx86Qg3r88fOxgkQtWfp4HmnC9sy7+iZFjQK+m9zBdhh2whkGiEdqohyZ7TfCCtAow4HKuYYRpa3Y8W9DXdPeP08+Dpk/cOVit49PBqs4hGLl6v/MD1cDHTkDMQrO1939sI2rXgtcov4D/JGFVoHWXvHIrVxnTiiFDx3xUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxIMZ9YHbefx+KaGMM7Z/e+D9tx6S9Z9HnDaFqgHSbY=;
 b=SKfujQPwbXhbmzgXf3pecuXzN0ZpAiWbfpq5yaHu/vlU0mFoEUaNJ/x9tTvmw1MdjyKtI4xP8CYdWYcdn7qNNAZS1vrq3tzt60BCp2d2bO+mrotAIKPCTfxhXlXRYuVLaxPSGjS9/Gd8KYagMC9C2zrXjKGFD3JwMeylPxM89vU0xgUPiADstfjDKnGtk6+sLZSciy8CDsR6iR/eKS6O1p/K6WSDp45Nd1NwXJ72Yf75f5hV7PbVZFwEUl+Mn4705Bnzm0OLli6vkGJ4lBbj+QVF9YiJJkiQ9CabeZX4WiNZOgsuHcJ6Z+ekv3nKnyGgxMBrkCLqQ/J4NNA1ILkVfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OxIMZ9YHbefx+KaGMM7Z/e+D9tx6S9Z9HnDaFqgHSbY=;
 b=dzIFKdG0F421Gz5oE/Twfy2KoUUCvJjotSEb/zPjdq/mVTbAPkZFS2ReaTrOxeciDRO1U8Fc0IHV0ErXRnh1t1f2E22VhoRMztz3Onzd1k7KUY147QWqDhDLufskSoSsk+C2gFEjDQcy6ZPQDe/THcBhRrGSE87clzY3u5qhbng=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1169.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:266::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Wed, 16 Feb
 2022 01:07:35 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117%5]) with mapi id 15.20.4995.014; Wed, 16 Feb 2022
 01:07:35 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] net: marvell: prestera: Add router LPM ABI
Date:   Wed, 16 Feb 2022 03:05:55 +0200
Message-Id: <20220216010557.11483-2-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220216010557.11483-1-yevhen.orlov@plvision.eu>
References: <20220216010557.11483-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::19) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c28eaa87-d18d-4091-ab6f-08d9f0e8b77f
X-MS-TrafficTypeDiagnostic: AM9P190MB1169:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1169C97CEA0A0C165267A21893359@AM9P190MB1169.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MgRcX+zbgmjY92HC9dFHOEJ5xUXvcd5YhTLUlF8jSMCCMurwf0QuTX8E4sDI0sKB4xXZ4MkojyqjhBOX+RX5dZK4ZDmODDp+kC3uY0lbEzDST63cBenzwgGFyPoFG32uwLZU1wNk8Cj/cobsViwdBK0gXQRl2i807oARkY/dQGykvIwUIK7txgQ8FJUxce2XLK6nAu+YyJFlkYwdDhO5xeEYzK9mikLWQCeH3+mfk1jx83h+89cEz+AyeNE0vH+q7vA0BwGAZ0D6ssdsXgsGlrDCKrNKt2ZDXjroChehYncynrQLcsQ0rRuP8EOi5KU9FEtsUaBdSGoKN4d3dY3jDVAJ8uaACOzuGSNjqmVIp2HV1GovugyCdmJwxkZMvBsfPxbddVhc2Mo38cxSfHvohaAIG07vB1XhreAC8yDJov3pRq5wM/2tYbe9qGCFkSkakf3j81BUaYYYjnD/j2LxCSzo1H4yJZ2JdkrXP/aVqP82JWfTxPZSavzIXfjQjn8vm+pL87ExCgFw68zDUj1MQ86tQzuG6VaJ/o8CwUGqWr3+VtZKXKRij/fpiYWpuZ9FxrtsQT4K7Z4B7m/IfL5Yaav1/Eyo8U+pGKZKD+m3wtvAm4eMuboDZrtCnw2wSa0GJpn64vXHdO7c3L7INMpoDT1M/wd+gwuhqxE4bXePAeB2tpme3avPC7HF1hnVymXdjoJAMMPY1Ef82VkS5kxnKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(376002)(346002)(366004)(136003)(6666004)(5660300002)(44832011)(66574015)(36756003)(38350700002)(86362001)(52116002)(6506007)(8936002)(66556008)(66476007)(66946007)(38100700002)(8676002)(54906003)(6916009)(316002)(4326008)(6486002)(508600001)(2616005)(2906002)(83380400001)(186003)(26005)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9tz4NzNhjENRtIXN8zGYY661ZU0oRAutTMsSDkB5aYXrc3cYztzLgFo05HJv?=
 =?us-ascii?Q?m8sJ3PuxNRDhfDZ4FekBlqP4sK/PSDa+ePOLZUxjPK22vlEjsg6IlC9i32Yy?=
 =?us-ascii?Q?oPe/MatrBsCGnQbWh35B5RbGMBwsYyC46xoZWo8tqHduLTNumky5WHP4edde?=
 =?us-ascii?Q?9q3QPtS2X7s+PsyrR8UslFGLTinYrA+uCv6ReQcd9v4XWFYQF+5fbiTK2y3C?=
 =?us-ascii?Q?KkZftzDR1ICcA13CsXy/BF+mS8O15F2oudgnRRg3hvaZY4qS7DZpZCLmRXgR?=
 =?us-ascii?Q?5+Hy6u74LuDOuK4wb13NOq0kGDADNtncewg6RXmJ3zubIauOfs6JcZ4vZ+4n?=
 =?us-ascii?Q?ImrmoBBvqsXNAGxrXETWi8FIZSdI983G6n5V1w1jhfHCIYqB3qXaljrlRVL3?=
 =?us-ascii?Q?X64PgNzQXTNbyrM9WpM3yVHpWVpeQOPyp/2JabvsafezwD5YAUYmrE0afXtV?=
 =?us-ascii?Q?5rOafVtp4Crb94qOnp8i64YQMJuAsGKgyRUIpqoHCEs6SUCFUYezZh9Y+kFn?=
 =?us-ascii?Q?Rsjtv4BdYKGRKae3yfYkAi5dmqAyjRoNBnp79RTjzDesD/Nu4yY+0nk/mvvB?=
 =?us-ascii?Q?lVzbJusRtmVod+Wiimvku4LrNGUSeGMTy1WoWNGVKkflku6EzYgFuR30yLPe?=
 =?us-ascii?Q?BTd3i3lyZjawxjTAilbnW/s2gugh9Q831UApry2y/vhRRQ+dKt765CA/0QrZ?=
 =?us-ascii?Q?b0hMuOF/h3vgrxtTk61xWxXvDauBSbcrntzM5DTeC7rysBNOLTcsh8kc3EQD?=
 =?us-ascii?Q?Pv1OTXhLrzXDIdNqkK66hw5/02qutMba/se4JHvMW7KeM8Qg0Y7rW7cVpM1D?=
 =?us-ascii?Q?OfrmcgRpix8QjAS/fJA9EzWAT99ix8OJxk5PeA+9d5kHVZXOIAvUtsh8dBcK?=
 =?us-ascii?Q?mp+kXcWA3Fkd9Icj5376rMTE36DdUu4pbS9W3gluaow5pwRyHq3NiNDYJzfF?=
 =?us-ascii?Q?4f2OP34j5nkdAphAV89m0La71fesxo2Pjkva2SdQqpOK9pZ7CPkizW/R0VNS?=
 =?us-ascii?Q?+W/0wqszr7wFe37Q3q7ApTx4P/Jacew7IOOv6nsd1PLwbVExkRH8SqNZuxzA?=
 =?us-ascii?Q?z6VXCXNifo1D76D8/ZZv4UnHg8esG2fok8QcP2fDpbQuf3Wjpgi/Hf0H1VOq?=
 =?us-ascii?Q?KYLU0ttUVceb47S2jOme72zUfemA7aH7NYVcmGBGrUXqrZJjQYAX1Qoh6+Yn?=
 =?us-ascii?Q?PX6n1XZWcyVZCRv/3HKpVjvpFvmueNXXZ8AdFKf7i5M6xcCrxBflFrAXGaqN?=
 =?us-ascii?Q?3W5SzRTgmAAjMS0LgYbFFfgLfRboxdkhqZO5XHsrng3i15SFLPpsBj5y92LH?=
 =?us-ascii?Q?wOb0ZwTzjsFS6SvMI9b21NcecooupsD7uh0YT2d7yVjm6tjV4gM0VwsjPIFG?=
 =?us-ascii?Q?KPTncgqbW5wjnS6/IeLX7RhalaNEvq7iZ1+mdpi8i+HYmXWgaZXS74UuhsmY?=
 =?us-ascii?Q?upUEiwdO6dDhzNbuCbapjY8t+NWbbaRme7/qrSkhpztiAFxrBm3kP2JKGcyq?=
 =?us-ascii?Q?GoCeutqAMueH3AveUN7TlD1mFteGsxk5G3mbx17NNQmnh0WxA0cI10GBcq/u?=
 =?us-ascii?Q?J1Vgc7w8xDOlbIq3rq/TMAxLA6hNAbHofC8caXtzfkHtDAZgB0EGcJ01MdHv?=
 =?us-ascii?Q?dWS+dy80wQe6E35PGCi6OihDWFJu+nfWLxIYhswru0eakx137dwERVJEvmxW?=
 =?us-ascii?Q?O6MjQOJGGsX6WXNLkQ5h2Fw+o6o=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c28eaa87-d18d-4091-ab6f-08d9f0e8b77f
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:07:35.2561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ctg1mZvTueLWLLek/6+J3idrLKEnRKB+RkL2NXarrTYpoO6dk8vvkIwkJS47g3dejz+EwuIKpIbmmT4NKt3s0QM9em86RiTY8lUHI/ve3Lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1169
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add functions to create/delete lpm entry in hw.
prestera_hw_lpm_add() take index of allocated virtual router.
Also it takes grp_id, which is index of allocated nexthop group.
ABI to create nexthop group will be added soon.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_hw.c   | 49 +++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  6 +++
 2 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index e6bfadc874c5..fca25b796cf7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -55,6 +55,8 @@ enum prestera_cmd_type_t {
 
 	PRESTERA_CMD_TYPE_ROUTER_RIF_CREATE = 0x600,
 	PRESTERA_CMD_TYPE_ROUTER_RIF_DELETE = 0x601,
+	PRESTERA_CMD_TYPE_ROUTER_LPM_ADD = 0x610,
+	PRESTERA_CMD_TYPE_ROUTER_LPM_DELETE = 0x611,
 	PRESTERA_CMD_TYPE_ROUTER_VR_CREATE = 0x630,
 	PRESTERA_CMD_TYPE_ROUTER_VR_DELETE = 0x631,
 
@@ -499,6 +501,15 @@ struct prestera_msg_iface {
 	u8 __pad[3];
 };
 
+struct prestera_msg_ip_addr {
+	union {
+		__be32 ipv4;
+		__be32 ipv6[4];
+	} u;
+	u8 v; /* e.g. PRESTERA_IPV4 */
+	u8 __pad[3];
+};
+
 struct prestera_msg_rif_req {
 	struct prestera_msg_cmd cmd;
 	struct prestera_msg_iface iif;
@@ -515,6 +526,15 @@ struct prestera_msg_rif_resp {
 	u8 __pad[2];
 };
 
+struct prestera_msg_lpm_req {
+	struct prestera_msg_cmd cmd;
+	struct prestera_msg_ip_addr dst;
+	__le32 grp_id;
+	__le32 dst_len;
+	__le16 vr_id;
+	u8 __pad[2];
+};
+
 struct prestera_msg_vr_req {
 	struct prestera_msg_cmd cmd;
 	__le16 vr_id;
@@ -598,9 +618,11 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_stats) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_rif_req) != 36);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_lpm_req) != 36);
 
 	/*  structure that are part of req/resp fw messages */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_iface) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_ip_addr) != 20);
 
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
@@ -1891,6 +1913,33 @@ int prestera_hw_vr_delete(struct prestera_switch *sw, u16 vr_id)
 			    sizeof(req));
 }
 
+int prestera_hw_lpm_add(struct prestera_switch *sw, u16 vr_id,
+			__be32 dst, u32 dst_len, u32 grp_id)
+{
+	struct prestera_msg_lpm_req req = {
+		.dst_len = __cpu_to_le32(dst_len),
+		.vr_id = __cpu_to_le16(vr_id),
+		.grp_id = __cpu_to_le32(grp_id),
+		.dst.u.ipv4 = dst
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_LPM_ADD, &req.cmd,
+			    sizeof(req));
+}
+
+int prestera_hw_lpm_del(struct prestera_switch *sw, u16 vr_id,
+			__be32 dst, u32 dst_len)
+{
+	struct prestera_msg_lpm_req req = {
+		.dst_len = __cpu_to_le32(dst_len),
+		.vr_id = __cpu_to_le16(vr_id),
+		.dst.u.ipv4 = dst
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_LPM_DELETE, &req.cmd,
+			    sizeof(req));
+}
+
 int prestera_hw_rxtx_init(struct prestera_switch *sw,
 			  struct prestera_rxtx_params *params)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 3ff12bae5909..fd896a8838bb 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -249,6 +249,12 @@ int prestera_hw_rif_delete(struct prestera_switch *sw, u16 rif_id,
 int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id);
 int prestera_hw_vr_delete(struct prestera_switch *sw, u16 vr_id);
 
+/* LPM PI */
+int prestera_hw_lpm_add(struct prestera_switch *sw, u16 vr_id,
+			__be32 dst, u32 dst_len, u32 grp_id);
+int prestera_hw_lpm_del(struct prestera_switch *sw, u16 vr_id,
+			__be32 dst, u32 dst_len);
+
 /* Event handlers */
 int prestera_hw_event_handler_register(struct prestera_switch *sw,
 				       enum prestera_event_type type,
-- 
2.17.1

