Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BE3394456
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbhE1Ool (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:44:41 -0400
Received: from mail-bn8nam08on2116.outbound.protection.outlook.com ([40.107.100.116]:44832
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233627AbhE1Ooj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:44:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHdv9UJ4Ft3vDJfV90cA4TVne6eHN47LJTHbu3KMDsPBdCE323B2sVJ94Z91AdXZk8PoA2OHBNe+xfprUmR5/jpWPpGWhpDCIGJ77lTRS9L/1/do6dSqykF4Qa3CgO0JFzDaQoz+Xw0R59gDbNwKTkTk3Nv0dLQs1jpWjJyigcAllAV6c8MzrWje6MCRFY96Mbl87/f/xJXW5Sdiee3SQm/HuYIHK7kh/dYTKWjiCiN0UaMd57lTR3Idqapttj/ZHDQwSFFREMCnAHrjrIqOzA2v8QWWtC/6PcS5w+Kz6/7AVq5ksiX9Bc1UT6xu896Soiv4ZpSiJtnBsyjiBCWJzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abh6auORIQRf9gGa4Nw4JmfejIc2U4p4JyWtRCXEUEk=;
 b=BGbDd1bxLnEQ5zeNAxH4GWX/R5o9v75OkcL2AJBEkRW9U0tQrO+IeuR9YGZ9r06NKEdU2K3eekev9MiCRBxRIEZVw+IoftlPd5WGhMu3+pI0egkqdIF6mekx9kQymkenvN7PTvEKh0J8gjZZbfLJtz0jcs+c18PrlM4+fiovPLiOx2q4o7V3ZOzgAGRYnD2yqm6LijreCeG7WWuWYTy8QuX8+cgr1VzQ/N9RikevtyPh6gri6xqCpU/cB7amSlYKAZXB1DyglT3QIUZVET9dFh/oEJ337Iwb4Bc9RbS0j9x0EkgRMHv55fejMctMJcJ10oxOlO5qRqUFsbZo7edaHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abh6auORIQRf9gGa4Nw4JmfejIc2U4p4JyWtRCXEUEk=;
 b=nCs+qgBUg+/s/XyjQjxTAZW0/C0uBwloiQDtbvmNjoMwu6eX/UV0uzKwJvXzvqxxYmcKtqFOzSuQbrEd90mukBszUyIkEt6EacFK9xPzZvVVBue6uHSvNFuMD1Be8fOe4T0lQshlOMNUS/uc4kJ4b1Lg2JatcotGgbc72YX3Tc8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4826.namprd13.prod.outlook.com (2603:10b6:510:7a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12; Fri, 28 May
 2021 14:43:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4173.020; Fri, 28 May 2021
 14:43:02 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 1/8] nfp: flower: move non-zero chain check
Date:   Fri, 28 May 2021 16:42:39 +0200
Message-Id: <20210528144246.11669-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210528144246.11669-1-simon.horman@corigine.com>
References: <20210528144246.11669-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM0PR01CA0164.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM0PR01CA0164.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 14:43:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c8b33f1-444e-4bce-a7e3-08d921e6e53a
X-MS-TrafficTypeDiagnostic: PH0PR13MB4826:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48265B0043BF4868692AD9DEE8229@PH0PR13MB4826.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w36aZMzhbJEAMbLSEF0Ed7jtgoJiJFJM9djw0LVL0zIbyFA7EzJKqTKiqo+KacGupXyrg2rA9QeCD0Ye4NMP6VGuGyLjLD4xvVrQ5F0ny11t7x3VnOrfuN0pGUSpGKH6o2urtuAD4YYMJJwF9dwYo/yziDttJHKaF18CArxWhKJgR8X7NW6DaRPc8sbqOeRx2fJrZJnz/Re54VbI2UC3Vyfva5fDcQ3b6UJR8bRRvp1QP2Q/kydRK4GbzBePMEnyxqt+VRby5ird9Wb+Dl1dwXDGHM7cC3ILD87TvsKYOU6jgKAnML+HlrjbLdWZ427bh3eUBWUOPTO4e8Qu5QW8hFHPVEqJHq2p0t3dBSS/s5rBoeugJDavXmbgzJtYgAdYlH3BOuVEQaaPbQODxXRobAG8NaTYc1qcZJMAFL61KpwQEmPww6xFYqP/yaHymmNVKCsFz5+pPbbUhMy6b3lOH7cyF2HqtYJ9sTyM6bf9nHi9SYPYHrOFpMojMweWmogoT7Aon8zDRerkp50vCAzhXmi7DyhwVMZL/NptEf/YIgPyEDNjcQBwOxe5rc6vE0GQ8f2lb0/0D9pujX3GdxJa3VdltaBLjpWHUOawYoMvHHg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(376002)(136003)(366004)(396003)(2906002)(8936002)(316002)(38100700002)(66556008)(54906003)(52116002)(1076003)(6506007)(16526019)(6486002)(86362001)(4326008)(44832011)(110136005)(66476007)(5660300002)(8676002)(83380400001)(6512007)(478600001)(2616005)(6666004)(66946007)(186003)(36756003)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?agyMNar/C7jHCML8Ny4wKWi6ockkiuHHWgj/nY8I0FgVcQKCUZ6Lc/HSRbu3?=
 =?us-ascii?Q?iSBhiz9VUgBMQILpvwM2uhTs6JrsOrP3mn4BCtbOaZpKI4L0VBWdTcCPoiah?=
 =?us-ascii?Q?hiknuWesLXmGc9CSh1x/OlvG5B2y0PyxnYZlAE3YC+k5SwEudwZzDlgEwEpI?=
 =?us-ascii?Q?zQF7aCtle1d6SGb5x6mGXcSKtxuIdQg1oPUZBIVgoPFgKgub7JCjlCYoyu52?=
 =?us-ascii?Q?8/O1NnU4BbIRm/FMY8urwrnngJEviG4wFjWjbS2jO+5UXzt1FyIpU0ZQ+3YW?=
 =?us-ascii?Q?dGPxzeelpdBMhe6L+ZF1b+ZJ3z+rbNcE8qS8ovOTwSxOYq9RFhgM41Grn3TT?=
 =?us-ascii?Q?YNfmvI3l8HqEGttQlOchKE/9jZCOHAhhWEUJZBTGoOqitexdgLLlpXgCNyiT?=
 =?us-ascii?Q?UdAkG+86uX/ehkHPgM43n+JrHe0MEhtb7jsxsy/xOqPVh5Rj5XbH2M28ioyE?=
 =?us-ascii?Q?WXSY9JVvJDhGoDMlbb37TincKk3I429+QOBgu2RD3qTMLWCqovtSDyoTpfm4?=
 =?us-ascii?Q?jvhA7vvB7cETowcFFrddHB4Qs42AJ3R741Q3G70o9kV0L7vGrqCWTuNYkjF4?=
 =?us-ascii?Q?r0M1N5oUunOj4PbA6ujoOjZxT/lp/nyWRDkDwhTPQCkBqG11x28RRT5iLYbG?=
 =?us-ascii?Q?aEkz7PG9jcodTHv1lpekoKmG8IjNHnAW5gW42I+p3TxzLlKpsAMrf0vC8Ydt?=
 =?us-ascii?Q?uHMnnaTU5pRxYfPz7ymley4rvD8TQRqbLqKXI5sPz7x9eEu/fC0PQOQFhrwh?=
 =?us-ascii?Q?mgyaGznFpp/HhftEanW3Ow5YotG+YHsHCh7fLymrRPMpTFoPmsQtF9RRODmG?=
 =?us-ascii?Q?9NQo6a2xXRF3szqGefUcJfjgKBXI1CZiPM+6trBcug3HWdnYc6J3+6W3tujB?=
 =?us-ascii?Q?7KaBgclpyqw5HQGDHhMZ//5maVj+EhI6lyfX64A5Hdg8heIQws04YQfMZ1Zp?=
 =?us-ascii?Q?xCP9omKQSkLV4WOp2kCnRM9cWHKMc2nD33Ao6pOwWBD2fmnuNLGc4uos89XS?=
 =?us-ascii?Q?J1KfE1Ip5xr58TyrNkqmQZrxnCBEhs/kdfQwX8U3DEu5Wd1Fla8G5luh/BPZ?=
 =?us-ascii?Q?CmdtqJscqrJbpmmk5j1MP6tAJ18cQSIzGmj9cH14QKysC2jDI2Lkp6BCL3hN?=
 =?us-ascii?Q?h821IJs2nAmYlOx5nNTnBHeigTBQccEgQ339/cBl0t4K50or2lEgU8yZySZY?=
 =?us-ascii?Q?yfha9VkuKWAZKZdtZprZtMbcj+pacOGy/T3d7Es0B18plKmUMQ+vavD8ysGX?=
 =?us-ascii?Q?CIxyhfiteYEZbXhvyvSEPJH5cmu0d4Kany8jvHYcBPw5Xwub8qed2sbw+/TJ?=
 =?us-ascii?Q?9oX+BOpMSRtN5Vuef2WhpV/yXWiwn8JBat1ivJmw6Xuk5pNA45BApQLRLrdU?=
 =?us-ascii?Q?anu8dm0JsUNjAunbh7k7ssx0weTK?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8b33f1-444e-4bce-a7e3-08d921e6e53a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:43:02.2573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aLx8wpcZ4YzwWdpEzqCoYpcOjIu1kDhDrdcKKxN/7ZYyt0nWIvYPKWeXg/3Xnw5TIJdc7+G/51xHyM9WRAHhysuCZHgjjDbuEIJKKq9AII0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4826
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

