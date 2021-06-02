Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7963988BC
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhFBMCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:02:01 -0400
Received: from mail-dm6nam11on2100.outbound.protection.outlook.com ([40.107.223.100]:56833
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229604AbhFBMCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:02:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSLw8qLlZ+al+btgkQDoFKkxzze30fXuWZ3Fy3xv4XXIwcfLXTDbGeUKjenZ95VY4eJel9eZS6wpnLUgug6G4WDl8H9j0o/pJAjbYaiumTDB1SxkNHSSzGM6JR6m64+UbPjDPKoxGSmEH6ZpC224cCRsxzi7VQxDDYuSUnfnDJ1EYNxjo7U4opebDIfBpYw/l0OQvz+X5A+LXfFEYQAYCbGa5ZgnGioqkmSpZynpZTRhes3ihGAPrY2WQkIwry9v9FFuJzt9A4s2zS0UYHIiLqzJuODVIQaXTAMqFSieVX3GqaCurIl+81y7fK2NW1X/vPbFVxot+3sGbSxWdUlZzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abh6auORIQRf9gGa4Nw4JmfejIc2U4p4JyWtRCXEUEk=;
 b=Hu9ztz8EXHXhqYeo7Co81XwhY06+gEcmGgQK9Gb3JRuUT0ltByHUvLQ5+o5SlnSxJJI54M9E0RYpQEedzaXPMlMmSn82XTk15CtDueciqzgTE+IA/h2HyYuR5vgmMysmEcwH0jwUofAt6xkSLfXzHMtx9t6RUlrIvbJSQL0MZU7QpSaGd2geohcHFOA+qD0NR9Id2TflrM9bCuU9hCWqQqCR6rEdfVaezuhH6e/smV1yW2k7wO5h3BuXmVBdAYdXcrloP8Na68+guMOHDgfYM2AKqm6E5TPCRViWYWmQTEgn8bcFQrMV7buww/4IhHMK+SL+NOpchpTIXufAqMwAxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abh6auORIQRf9gGa4Nw4JmfejIc2U4p4JyWtRCXEUEk=;
 b=MXQ6gkHSe5t0GaczeNr1CZWYXAwxoyMcGNM8QZFpr/qN9WKZxY5zRgXqVOxknvPmm8Y4KMyVgH24UE5wYr9OluecIqOgsv5ztABoEX3g1Of5edzOlrc5e6EI4pr1eDfdJgVOD7zltJ4M4rWmlue3GvT/ZyFb+gA5683x7I2ZbSg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4986.namprd13.prod.outlook.com (2603:10b6:510:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Wed, 2 Jun
 2021 12:00:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.018; Wed, 2 Jun 2021
 12:00:14 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 1/8] nfp: flower: move non-zero chain check
Date:   Wed,  2 Jun 2021 13:59:45 +0200
Message-Id: <20210602115952.17591-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210602115952.17591-1-simon.horman@corigine.com>
References: <20210602115952.17591-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM9P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 12:00:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af554f61-099c-41fc-5a40-08d925bdfb23
X-MS-TrafficTypeDiagnostic: PH0PR13MB4986:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB498682AAB4FD1B625DFC017CE83D9@PH0PR13MB4986.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40gUBXXl3b7MmsZBYr41WKD6Vz4uw0qobap0srm2YVuuoAYp4MKqaAKP7Zy6BIOAeBew4Iemw2Qgo0dbR8/YveURNIMBbZmOl4R6pDIx5rFl/J10BnvU1PeCWqZ3w4xTBMTlMi7zj7iFmNMJX06ETh0fnhNSAW6qCZqnjftkgSdVMTeUzGGGyCtESRrpSdYO/O6+z8Uu5AAXHrGFBJpfGU8xWyqBBsiBqCwlGiV540COMSWqcBhVJdJJ0cUnhXdZRKyZ6TgGEgsdQug0ZL9mdqy8umugFQlNJ+xffq6EJ4hXKoZeE4Ma+Rv24UGyvkSR+qMDBtZNjT469ACOvwdk0v/WuR6oc/kY3ZESIsnt1Ssggtzpebcbe7uSzeOP/k6qgJYKpN02amwukqxgQ2C0+MiJcQqy8LJ+z515ANvt7EB2siW4CeIPBPZDFz1YFyu60873ZDQNAjy9+Tw7HPPKvTC3ZqsVhJkCh/jSHbz9oK3VFfGiR+/iHsRbLv54SNEm/OZ5W1+iUmW9wU8lBagy+skfDfpI8edjzll5NmLd88/PxYYUKVqhoMYB0vCIKq6F5rVnGLVANYcPvWElrQU9P8p6ZTPgQ3MVUwLPKNEMxG8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(396003)(39830400003)(5660300002)(44832011)(36756003)(66556008)(6486002)(107886003)(66946007)(38100700002)(1076003)(8676002)(52116002)(6512007)(6666004)(16526019)(4326008)(66476007)(86362001)(83380400001)(2906002)(8936002)(478600001)(186003)(2616005)(54906003)(110136005)(6506007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?y1DguaeKnn1ZihPbTFa6MEe0qSPDlGCp+z/1P3IB1VtQQvg15h0JqEuInhiV?=
 =?us-ascii?Q?qQ4RQn5l8Cw0D1APCqf/fy1WQefH5hSw/dD3reuX5PbPpIc+GNQ9M/A4gCry?=
 =?us-ascii?Q?laNrpnKHXc0Efc3PSg0F9Mnpn5iZSMg8Og9LqKJKtzsW103fKeRw1PPnmjn3?=
 =?us-ascii?Q?/I2dww8ygtRFclW8ue4XIykZg//QaJS3WtzzKzp2eS8YcV33f0uUufulanwZ?=
 =?us-ascii?Q?TyOobgC/DwHWCOwsCuqZLce7PG1Iz4sLGkSxh+FzhQxk6hS3WqKlNufU9MQc?=
 =?us-ascii?Q?vykBXMi40WaEnrp9+qDVKpu2MgamMVXgm7oKSbd3xeFkzmwHDqJHn+HgioMG?=
 =?us-ascii?Q?/Hn1BFqfkksWeMUsuXvpdVxnZW+63LnJrXm3c4gLCmr8FLUgm7kx1RCM3Qlo?=
 =?us-ascii?Q?VUYDQ2mb1IgaK+gJOsLj7mIb/sdWs2kcmeG4ji2Ynl9wJ803r2SQuekSOnvE?=
 =?us-ascii?Q?s4ff3R2Z0UHkVywHvDECXFbwhORWN3F1pEpXPvuOnrqJm91TioOTLysV3iH9?=
 =?us-ascii?Q?bSMt3fX2iig1HxPPhZaaVDsTBMOMGzKhyalR3AswcYdclCrDwnQKO1Z9FgBg?=
 =?us-ascii?Q?VyoPU60hrJFThnfGicO6kyaXzbIg+36cZdrIzrr7D6imitZwhpCDwZGLrlin?=
 =?us-ascii?Q?ztSkozirqLjyKntGiTXi9kJ43TW2UN/0roKNIMkCAckR3CoeaNyishJUe6RT?=
 =?us-ascii?Q?ZY7uKmrEfnfh0dXYiJfaq+9Rkf5Gv7fchdG45F6Sn7rnV8H7KGCLaI6dNoNv?=
 =?us-ascii?Q?ZFM15+77mVzoMKoboBawC1ADJxRay3cHwWv2CMZ1v1sUgiRO0f2e8w11F+fO?=
 =?us-ascii?Q?+l1ZSeeBwP2/5zsU1Oj069PebyTIhdvROm6pc/hsEg5+3n9fbIcCoDQoWazo?=
 =?us-ascii?Q?SXAP90B2OtSTU9/kxLFHTAWCD6+BDscY3QGexiSq/NQiVHBnlqGv1e86oDgb?=
 =?us-ascii?Q?d4RKDq9xtArrbZqzLADTMlEFLeHKWIU6Jx6m7wXqdWdHOBX8+bRnKBtzxImf?=
 =?us-ascii?Q?wwNijLDpiaGWq2awYrYNE+z+QNekA8VYUKSfZwKZma2Zq5djSu7DrRY0rpEH?=
 =?us-ascii?Q?79z7NJHDEtHZPh9rrtl1c+H1ECJKpPjUr623ctHsKuWGbb78JrRxVp77l8am?=
 =?us-ascii?Q?CUlerYkEsAMl7N40ap+fcY3nJPM3GyZnZVzVmiDxiEya9WjTynATdP54Fbj3?=
 =?us-ascii?Q?7hWladwo8G4oXSw/mvvxz7FriEG4MHzREhQjzZL8nqs/eJhRVbmnVAqR7wRm?=
 =?us-ascii?Q?B73DtII83iYlGHAoIMV6pjMYF5HIXgt34dPA6ApoNDM8yeIYv0kBPTf1WUmL?=
 =?us-ascii?Q?nIFXMVrAJvKmgYhSvHOLvHpDHnDVzoCaLL52+vlHRMl5bqc10t8yTyLwAAVv?=
 =?us-ascii?Q?RuPn7rp3E3MHVGvD+FgfWrEY9sq5?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af554f61-099c-41fc-5a40-08d925bdfb23
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:00:14.3424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KuZ0ZlPOXnvEMJxoygKvtw9M0NaVYB1GKB40icacfRRs0OR3XGfQeVNR6HsqPH/+XL/w15rSFZ7ov1aAK7SfL2qA9H7/YN1xxU7Zz88jEnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4986
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

