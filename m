Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8846C21ADA6
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgGJDrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:47:52 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:20955
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726787AbgGJDrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:47:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3AUWbEFqSd4qYJ0GRgHviGajBy6vDmT767Lxe1ydS4PEbNp6gvtIpEf/T5bKR2EUFuRGKI/d0Z6AvjmxrvSNGoMikZOyR9n2EGD6GaGyjW29Sfszj5TmlTi9vb8NCVik3LHnWLHeNi06b5JXmIyRzXLSUKsIAxWmPh++95/h8aGN1bCoAboDhAU8SasljX2l5rLz33zgCyb2JNXmWCPMG18bnsUi428V/mpKuRqw16I17nRxhyIiqfTMsr+mHQcEOY9zT9DFZWuZRek9IzUatSnx4RigocWmN+OQvQ9wpzsCqv/dKTG9QcCGKIfKEYybCcYelUKittI/Wp9DpuqKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfOmNgWVGmIHd/B2IYptMCsj575gDYKQ9mMpoE5Bdt4=;
 b=iPgEY8jBBtUzcUJYa1O5Ukjy/FuQp9lQ2eQgAt1k2s7DEZUkGsgPyBNUVhKYpZINXdVCnnBbiI3IKS1hWLy3N75GiaWq53HwRtuznRodtN2b6o3QoZjhopSL8Nk8svUNWVbHfuA4eaUXY7bf0404M2uHw2sS+CIY5IqqrD0Va5GjmQKkY/vu2lfJbt4AwJoI1ECJunGtJg+P3Fqg3fOvkHv0wgCp8tHBLYogJF9bx/Fyl8rNcIPjAcefjb3s7k4Iohow9fAQo5yHyp7We9Hj6kIFr2EvlDJVd5QVaYAiRQBSbGYfiHdq277pqs54lKlYEwhKz7v6zcCtGVAU6419Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfOmNgWVGmIHd/B2IYptMCsj575gDYKQ9mMpoE5Bdt4=;
 b=g/17zdHrFnA9f2AnXiikSHplZVWjw3zs7BdWp+WNs+8S0RYGq0JfRi5YHdQ9PSNHV+kWr1eSeOPdMko4P1As8xf3olJB1h5anAaaH8bbJt/snYnH5/m+0AYXiE1S0qmVOJXZ9CfC45OsJKXBQfRC1Yq1VJVIFDtCIJjEsXtGC7U=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:47:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:47:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/13] net/mlx5e: CT: Allow header rewrite of 5-tuple and ct clear action
Date:   Thu,  9 Jul 2020 20:44:22 -0700
Message-Id: <20200710034432.112602-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710034432.112602-1-saeedm@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:47:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6a671fc6-dfcf-4e78-c8f8-08d8248401d7
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45120F88EC355933019B7072BE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B0g8S6euJl2ByG4qjmrKuEU0zuOK27xn834uPVgrZtsLcHWYCghkyq7TnQ2s4jM+A0Ar6ZYRYCxTYX9ipAAhJGDf6MufDolBij1y50ZkpgcsRCmNPIWRRJcJd+NaklfZNVZ2g1WyGL7ptmldo2F6Iwsqxk69bK5mZkbUJlPsZ/bfvVSXZJxTdC7i5YkY4wQBjJRFnmw1veKAm7HT9bB11ZOBUPNgYd9bQU1dEO4pjkEruf+GWoPIO2dxO7Pw8aZ6ZEArFNasB3DndZt8K6XQrd/wpmATSm0q/KvVC+y0Mx26W2xUJuru7udhohyhdzwjRBt+z2JU2nkAPJly/yeSuZtR0yE3eFKEOJpAb6CLdgzXabST3hYgRcagu9Swg0RS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Us9c7WSnAC+V724XR9+b+FlRNo7ry1/NS+B+Qkx/OCnbdTOTXjjEzLo70nW6mChWYFTFbKnPNpS8sCAA73r54MYVSIUpaoO9jStJ80N7FRWpxSgL4N6XhbslOYH8NfeVEh8NaIspYD1rxbiPiXbe1DWPYVMACD4d7C00jF/b4YQzQzeCgeQAQq+2T2TimCviutYRldROMvFdSBj42U8IJ7HfkwBsOn+oIwPECWT+5m4Muuj3hnoCUYBsWVmvGQ4CYEuHCOFNZ8Av+ggVLKU98oQOTSBVguemD1vephgolwZbWwQHGOQGH/Bj3z+k3uVBVta3fOPfIQUTkOezqzlFzE7Xz5NepsYNu4JWzTHq7nhUH/AEriSaFMCjYZM80lgT+/35Zt6SiFEieVE0Ko4K2J5x/4umtRulyK78MLbktcoAKZPZwzMpB4Q3pVRqPgvbvmhQKlRhif/xSNW+ai4kwtNV+v23SRgkhwX7HgiUByc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a671fc6-dfcf-4e78-c8f8-08d8248401d7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:47:46.1565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUPGbyIZNNxj82CRY9qVjXOAdJ26tdbHgRnX5d8UEFy4JF+Yp7yNKUZVZvz7xAyMEHcMlwItdjOdWPOB0WBZKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

With ct clear we don't jump to the ct tables, so header rewrite
of 5-tuple can be done in place (and not moved to after the CT action).

Check for ct clear action, and if so, allow 5-tuple header
rewrite.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index bc9c0ac15f99..5674dbb682de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3191,13 +3191,14 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 				    struct mlx5e_tc_flow *flow,
 				    struct netlink_ext_ack *extack)
 {
-	bool ct_flow;
+	bool ct_flow = false, ct_clear = false;
 	u32 actions;
 
-	ct_flow = flow_flag_test(flow, CT);
 	if (mlx5e_is_eswitch_flow(flow)) {
 		actions = flow->esw_attr->action;
-
+		ct_clear = flow->esw_attr->ct_attr.ct_action &
+			   TCA_CT_ACT_CLEAR;
+		ct_flow = flow_flag_test(flow, CT) && !ct_clear;
 		if (flow->esw_attr->split_count && ct_flow) {
 			/* All registers used by ct are cleared when using
 			 * split rules.
-- 
2.26.2

