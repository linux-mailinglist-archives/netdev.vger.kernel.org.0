Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66DE395AD5
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhEaMsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:48:11 -0400
Received: from mail-bn7nam10on2126.outbound.protection.outlook.com ([40.107.92.126]:16736
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231367AbhEaMsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 08:48:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQYGKGoinhZ0KWzdpu40LDbzHGGUp99tLbiJSyrnam8fsPNiDcbnN6NeHA+Dszv/xtLoWEV7uXjtxj572GVjk4RXd14b1dqSzsBE7T0Y6W6Xoujx2uqATjtZZd1Jljr7G7QSbZ7Js7Jc70sXtYtDBO3ZE/3XqZyKuR+HYxYqQmrqMMfaW3G8TRT96D52w0XfvM4lgMxtBqBw/J4BdshAXsatZH8zQrLfbFwxfKyOUuPmlN9nbGcnnZZA8G8iDSh/Nbcmslny4xe7wz2PC0l+0bUA5/C0E3qiZcgJJklFxF00b6lRHkb3bZL8WKgi4d+FDx597PDWje34p0vsTCdPxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abh6auORIQRf9gGa4Nw4JmfejIc2U4p4JyWtRCXEUEk=;
 b=CkIJsDhSvKrUZ3eOz+D1aKh9FzLmoY2lQEKPf7VU2yVfusRmwlOq2XxtgtOOkaMPcwil2bSDHrUrvrnLyjv9AVBcVs1QTLMIb+eY4uwVClOe08vMGr/tgAd3Bts1EeMo4AkO4PiTtv8U/3IFOokoaA3b3RNjRpbXO4v0x4KO4zyqG2QRn+9+c2JwO5AFS4lmOEHHwaaevPILsOrsn0LS8OkjotmnFnX5m7fSZGukAUq4KxbGLsI8HOMCqevq6XVlq/QTa8H56tdUL4/zOejAoX0GgYpHZ0trCQFirWpi+nFpIwvoZLrEPD72T74tVomY80dVNj1DOQLXZEw3QulUKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abh6auORIQRf9gGa4Nw4JmfejIc2U4p4JyWtRCXEUEk=;
 b=eWM85JSlQz3hoqdF55QaYXo30jAjg8fPnAJO3Nc0YO5fgVvYbWZUMSWJBANlH/C3/eUy03rHqL18kk3AjDvPk31MV9k2Domnu8WXg5TugEyg1cv1wXFIlKd7hw/9/cfWaMTcunmZdLkAaAT7UEbcNjt0NDMNpx+ZF0JjqzdC5cQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4876.namprd13.prod.outlook.com (2603:10b6:510:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.17; Mon, 31 May
 2021 12:46:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.016; Mon, 31 May 2021
 12:46:27 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 1/8] nfp: flower: move non-zero chain check
Date:   Mon, 31 May 2021 14:46:00 +0200
Message-Id: <20210531124607.29602-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210531124607.29602-1-simon.horman@corigine.com>
References: <20210531124607.29602-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 12:46:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 922a788b-379d-40c0-4b1e-08d924321b76
X-MS-TrafficTypeDiagnostic: PH0PR13MB4876:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48764A8E96CFCE0D03D24604E83F9@PH0PR13MB4876.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9rFPnc1Z8ooHrnXtGb/AZfCE12ga/JMyTIW1uZBWhV/NR/pqZsrEQ4zAjCmwBWgJZb7DeHhbLcXeRhvxRpkT31Wq+koMzMGIgboNk4ZPwzDp2wlkUwRXkIeXCsSSfuTF7nqEoWZOHIv2ugOArh3gDz40BtR/ERUmCc8ok+X5eTds4ylr4qyA0DD9+j+zMB5eh/GyXR6FJNRqupaWTBM9oDIwXm2RvZAUfBv/n3AmGwNR5WuKlMDjcehAJmC1352U/mEjJrMwHGU5X+oieWDbZLmNZp6lXBc5/BFPkwWtGrbCfrzZCERAWebB7EzsduFWNxlUQGl29ZeFHhr49zAssqAb6AzaE2qccyyxYdGK2sS9909YpacJG1KNH4FUXtamN9x5MJz+0mo4DPqjLc5qs2iVawKDRZz/CBp5bC4CL7vBE58K3nzLFSOE3T921m8f1fllafuoCe+PqMZIK8e0Fvg0InJ3cBcwLESn+huDKGKxfyI89L2yb+tbU6jdPGTbdRqVOrq7I1s24j0H336rb/vWQk9JAZhd65QXLSSoI2YTEEcEbTdZm7v7280NFsLV7Aa2XhiKiXy4FTziZ7Q0o9/ZLjU9ImqCJ5JwAdu6bi4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39830400003)(136003)(396003)(366004)(2616005)(6512007)(5660300002)(6486002)(1076003)(186003)(86362001)(36756003)(8936002)(4326008)(478600001)(6666004)(16526019)(8676002)(2906002)(66476007)(66556008)(44832011)(107886003)(54906003)(83380400001)(316002)(110136005)(52116002)(38100700002)(66946007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?33iT1s0yqi/+LjIsOCr6Xu98NmrPtviJTMP1fPzaFcvkovUelDvv4eGr2vgT?=
 =?us-ascii?Q?do6Mn8ognuDXJRrviQS/KcbUJkdmKSMrYtHR2tKrXr3rGgr5luUqVR8gkhgN?=
 =?us-ascii?Q?FRb+dSyFepIOVZpl/EK/+XGGCKtQ2DZDpNTJVSvCM0takP65srwe+/bGvkfC?=
 =?us-ascii?Q?MnteYH2aBKGxFjUVTISIYM7rzX+tU14Kl0Yg/p4lkkpWVx5eWAKHWirgN58R?=
 =?us-ascii?Q?7aQ+eboDQpbOmm7XE03dPJTWMYt/ycHqENJ+bwfUe9eYpF5qBHcHzdT1fKIx?=
 =?us-ascii?Q?O8przNWzQJTlspldKfDzs88cCSGNWgwth4p2jom5+DjKJFVT5ltGAVWFcpxh?=
 =?us-ascii?Q?XQu90H39Vd1Ntk66CXiPQrpw5ZWd0C+cBs6UYkiaozNAIqveSza8aP7oTvgP?=
 =?us-ascii?Q?HT7FEDwaQThh43Jg8T3wexdzFsNlo+kkFenEEMylfHS4CALfaMXVsOalPosr?=
 =?us-ascii?Q?WQkGhHrx2R/tXikbQZkxFgbHZr27UJRlAD6tlLaO27yFxymJokLGleakP8et?=
 =?us-ascii?Q?8nFDVxe+qr0Sdg7mxkrLZodj6+/IhlC9/oaMXo/7S4Gcvs++ToSddA4QTlX8?=
 =?us-ascii?Q?U/HaiByvaZHZI8OrOuHuW583JeKd1UGCfCE42zNJ+LQw1werouV9RhTaa+66?=
 =?us-ascii?Q?fKGjTJQ/SX3Fr1+eoFCenj94KcL6r14Jw2xZe/nqNuHeIufzoTMZ4VVXBz4o?=
 =?us-ascii?Q?OyIhB4Kgi9xPWhvEb3mGAFIhMM+wYejgR/FWq/3Rt5jylEVgObOAMsz4U+qi?=
 =?us-ascii?Q?G0FyQAQK7QQ6CWITjbWgn6BEbBGg6gjfjmHR8G/DBnswKFwtuAO7SbKCe4hd?=
 =?us-ascii?Q?0f4MTM0MHEW7NdGXcSvf/4jzrk6Ber+YR7/caAzi0UTypSYTM4VAdIUMqeLx?=
 =?us-ascii?Q?Rd+36ciXpzeu94dfDsDxbeaD/1vYTdxqyegHCyBaaHufp+y9yGHyGgKWwMSA?=
 =?us-ascii?Q?I2A4EhmYJr++TXVX/JjNJxIUC60p0uJVRDpV0EQzFAxRj8aDsU+CknrPdP/P?=
 =?us-ascii?Q?Ct+uF5isZMm2Ci5VkU4FjdgLPxQYAjnXwPLLc9S2YtUhVX8oZLOaXb+j35vM?=
 =?us-ascii?Q?OIXT2YzlyeAt05DNlFrhHE2A8T1M6L2dFy7UVSqUwPt7179MUj+XJahPzROc?=
 =?us-ascii?Q?nmKVXOJdVACEeIU07a5fzOkuaiU9QUAu7qJkkXE0lsCaylwK8QJSAb9g9Lfm?=
 =?us-ascii?Q?jV1jLS0E5FnuTcrmdAJXjb++UV4JYcvwNxdRIz+DqukZ2RZnhExBh8t0azOz?=
 =?us-ascii?Q?0hv/2qS8/m8ydxspKvEjirMCG2ZMGLqXOwygeArYjHSM+FVQQG4cEjPlMuBD?=
 =?us-ascii?Q?tf4ZBoxomWt6DCqFPkC3dFw+n/QRM6RFqTECfJxbIHE+lh9cdy+NzLuhGeDe?=
 =?us-ascii?Q?sgdvclaa7mTZ3/XGwQbfA8Db0NGZ?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 922a788b-379d-40c0-4b1e-08d924321b76
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 12:46:27.8472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FOhZAJmmOw8Qu/USUU206U43QuyZRAVtUME5oTUFD9HS/A9Y4Ul52EEh0TcjQrz+LRCNFXhstoZ8HbJP4Mz2GNJBy0gaLmHr4olRe1q1mZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4876
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

This is in preparation for conntrack offload support which makes
used of different chains. Add explicit checks for conntrack and
non-zero chains in the add_offload path.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/offload.c   | 24 +++++++++++++++----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index e95969c462e4..16ef960a150d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1276,6 +1276,20 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 	return 0;
 }
 
+static bool offload_pre_check(struct flow_cls_offload *flow)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
+	struct flow_dissector *dissector = rule->match.dissector;
+
+	if (dissector->used_keys & BIT(FLOW_DISSECTOR_KEY_CT))
+		return false;
+
+	if (flow->common.chain_index)
+		return false;
+
+	return true;
+}
+
 /**
  * nfp_flower_add_offload() - Adds a new flow to hardware.
  * @app:	Pointer to the APP handle
@@ -1302,6 +1316,9 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 	if (nfp_netdev_is_nfp_repr(netdev))
 		port = nfp_port_from_netdev(netdev);
 
+	if (!offload_pre_check(flow))
+		return -EOPNOTSUPP;
+
 	key_layer = kmalloc(sizeof(*key_layer), GFP_KERNEL);
 	if (!key_layer)
 		return -ENOMEM;
@@ -1646,9 +1663,10 @@ nfp_flower_repr_offload(struct nfp_app *app, struct net_device *netdev,
 static int nfp_flower_setup_tc_block_cb(enum tc_setup_type type,
 					void *type_data, void *cb_priv)
 {
+	struct flow_cls_common_offload *common = type_data;
 	struct nfp_repr *repr = cb_priv;
 
-	if (!tc_cls_can_offload_and_chain0(repr->netdev, type_data))
+	if (!tc_can_offload_extack(repr->netdev, common->extack))
 		return -EOPNOTSUPP;
 
 	switch (type) {
@@ -1746,10 +1764,6 @@ static int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
 					  void *type_data, void *cb_priv)
 {
 	struct nfp_flower_indr_block_cb_priv *priv = cb_priv;
-	struct flow_cls_offload *flower = type_data;
-
-	if (flower->common.chain_index)
-		return -EOPNOTSUPP;
 
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
-- 
2.20.1

