Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18073B9E0F
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 11:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhGBJYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 05:24:44 -0400
Received: from mail-mw2nam10on2115.outbound.protection.outlook.com ([40.107.94.115]:9857
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230333AbhGBJYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 05:24:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j54r1CC3fMalkXejdIu3mhYtTV6rFEGDmso2a+Qj171Xne2m6o8lDDfh7wBkcToL5g6QYDPpaAvAUZIz03NplVFnZuLeL/mEiXKyCtSGlpqTOFGXvUrrtWM4JPeaHY5iFivlcxz1PaaWEkSO4kDihiK7lGfyYGiDLCyZqxN1yrSFpd7DX2vY7cVw2cazSBKFdoRWM+2ckMgnO9D4zR7O4GLyfQUPEBbzOarKZex5N+OpqlkjQdJxMGIJRb6G9mbUGsiYsgs2wq9N+TbjBx6nG1HBn3RVtbHKeiAPD8xRfls1hcQKk2UdHQp2p+90YpY++uA3qkOlMzNQJFdGhAePdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNkZOJIcdADK+WyPfkjAbmqflIx8sO18zj0iEdoRLUQ=;
 b=FgWKmLGpYQuczwfsOD36qOZ7q2OMy/qCupQWeBriLZ0x4UlHIHGcf10nI+VPZ78Sz6ISCxRkFcxuIJPNARsZm2ID/iqolZIqTylLw5JnNMUFa1EzW333jTc1sfPWOeEqUcx+4tXdtjrYkXF198hwRpSyw5jlwpKJ/V+tThwNKCSTpUAeId8yWceTk9UFk/9ISVum77YGgUUsBb2DvOBVy3XJfYLkquAtu3ID99hMLKtgyrEb0kRp4Qx9fFsX8Ode4A8c/NC8U9fjq/vQe/NIQidnwwinEMT6pIuNB1zM4adSCPcQfZLBPpXCnHkqdqc9aZOac5jaIIHAoRXH/poZCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNkZOJIcdADK+WyPfkjAbmqflIx8sO18zj0iEdoRLUQ=;
 b=R7k3wHtkeT3BUxGv/W2YCDjPIHlhdHx3mvf+z3mAU4zpJ8W5g7frlrnBVZbd4su2iCPEBSvD+VPELa0NqlGfwFnFmrwO7BXH4SIu9ODgaGhYQoMhOuB1+bwEIUls3ojUDT4g+13TzC99AFZLCob8Xg3xp9LnkMtVfSKxyDNdpkQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4987.namprd13.prod.outlook.com (2603:10b6:510:75::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.12; Fri, 2 Jul
 2021 09:22:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4308.012; Fri, 2 Jul 2021
 09:22:02 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 2/2] nfp: flower-ct: remove callback delete deadlock
Date:   Fri,  2 Jul 2021 11:21:39 +0200
Message-Id: <20210702092139.25662-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210702092139.25662-1-simon.horman@corigine.com>
References: <20210702092139.25662-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0112.eurprd07.prod.outlook.com
 (2603:10a6:207:7::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM3PR07CA0112.eurprd07.prod.outlook.com (2603:10a6:207:7::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Fri, 2 Jul 2021 09:22:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 110c7b46-9816-46d2-3f9c-08d93d3ada2f
X-MS-TrafficTypeDiagnostic: PH0PR13MB4987:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4987AE6F37CE9BBBF6F5C04AE81F9@PH0PR13MB4987.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YWY4gbyTtL93Irr4sZVlIAekRNgEaAKSx4op73tgkVHEP+tQF3yRzdEpPG0Bh+98ejMh9LPONEwRpZxF5B0uEgZhPqm//uw2Mc7khro0XDNUOY+LgYmQebaNoPvM0W56nBuSGra/RjymYmRMOlses+1hfmA8RbNE8EIbyG02/sczpeYUXR/t4oEqzL4cvYSuKm4zVuFzX/7WLGD/srI3VPxkOimau77Bm+ytO29E2KRHRKQZBBAZ6c9at8WLi9w3t/5i4WYwyNMLDxEPuzTnuoQN5qDFkTwc3du1QOr+aiMrBajI9mpRZu8qFv6nb/WG0qxkhJJOCWehqEZXw1/Sqrjy4vU2pFKg2Fs5vgDQqkn6js3KoldumsXP/bvH3izGrkAm7V2xBFHFnA8afNCZHNASXjbc7fHRlUCY1umZy0IFWTC+tJ9xtl2OMeb+XkCypI6XinI6u0HWPZbVIUUWaKboP7RpmIhLZPyCv+H7uvhtxaqUZ41lSN/GFwi84jp1Iv6+xmthGHq1lW5m/YG6jmgtY7IyQDpzZY0vFK3yRdMpRAp0FmogLADz2HuGzdPPLVNPSbfTtbRotkeM8dN7C7MBwFXlAdVSo/kAVgWLkP8i+7fRM7wK+XRajqD23WbkLmA/8+YoGs9vELUwoINq2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39830400003)(136003)(366004)(478600001)(36756003)(6666004)(38100700002)(54906003)(2616005)(110136005)(6506007)(2906002)(44832011)(52116002)(316002)(6512007)(107886003)(66476007)(66946007)(6486002)(186003)(4326008)(8936002)(8676002)(66556008)(5660300002)(83380400001)(1076003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bZeU2qWXB3FZFP4CZhApPRVz3tBa7/zjsvdRBqu6544npGhN9VmAGw4zsFkM?=
 =?us-ascii?Q?qP3OqeAGDgbRKRDiDlB7FwrUp32QshBica3JLqewfODFn9eyZHkvVaI7+KGw?=
 =?us-ascii?Q?ScDB0P3/g/Jgh85sdvYXUDpMDuYu3vzHOxiOebvRtaoKOQtHOIDjChHj4BhK?=
 =?us-ascii?Q?wE/CwsfmNjwM/P1UnkgViAX1WB9TewbklXmRqN9YVYQTq9tOZpINVLD3EHxw?=
 =?us-ascii?Q?1uTIK/tGJF9Ui/Gx2r7tzT8Ja+WVFRuKHQb3XKL8ACaSv9AqBCrG3mmN8JBH?=
 =?us-ascii?Q?ZbBrRYY8usiOaJo1egrxShMZTiGzTjeb5dGwqFfroaR8IPzfRNb5X0Fs+Qrd?=
 =?us-ascii?Q?zwhRMp+Vdw7HlcBqZv+KlfY2lMmY3cGvRbni8l40/YyEvZju2NQqYiS2GWNF?=
 =?us-ascii?Q?JrTwEioshHQUm8KMlzhR4AeRnkhrWwS6pjBuo3ZW9+vmXM4Pj2VvZHVHcc4H?=
 =?us-ascii?Q?6LkNJELiWkeK5ndN+kvslf3BNelMkVP1mZpKLrpasZwVzYwxISZwETjmxEml?=
 =?us-ascii?Q?l8sesxx8AQM2GdWf39RSUGW3rrB6HGVYjNamMQlj6GhGNYX4K9OG7rrbnpq0?=
 =?us-ascii?Q?Og+ZYCwR5KJr8nINeqmiUBimWdu9VmHPgo+Uw3xOMYXC84WxPHK5FwwVLCzV?=
 =?us-ascii?Q?zvcGplNBZXAoSM0Nd8nAC5zNy0JfwAyZAJz5Hu7U00546gZ/sZIK4RpfIA7y?=
 =?us-ascii?Q?8JiCw+D1SXcDhLZYsye46wxw2be1dJvaPCUEbXqQ6aBIbe1iU24saxGduOnw?=
 =?us-ascii?Q?EDxl6WSnioPXWy5H2Pq+4q9ikZVGqmiSQaOK23knIme07mA2674yULOpj6/W?=
 =?us-ascii?Q?niGufF9ZZ4XmzyA553xJCDdWpOV5TJ6ueV4HnaHq1RFNJYe0+DO8i/To55RX?=
 =?us-ascii?Q?PdPOB84QVaWr8w7tJv7dHkUQ0lU6R1QWyJL1XxaGp+FFZvXLvau6DkCToTj8?=
 =?us-ascii?Q?O+6E/vrZKmL5sbdt/b0MyOiE0H9P28eurgz6Eqe2z9ROe+eUdRmRQ2bdcSQg?=
 =?us-ascii?Q?Pp7jRyPF4IxD9MGzbwBCJais6Wnmo4vIWp6inD3GWHFr+9ruZEJVCYRRnu/c?=
 =?us-ascii?Q?izD1PRZC0g+srQORDjd+Q5fq1ByaGlN8AZOUi6biQG3c6VpyvTY4nMvJS0Xp?=
 =?us-ascii?Q?g3+Q5MV0TqNnCezu/SbUqIyGBkeaZAsJ2p+n7KuaK981ssh62PLiF4OSH9ge?=
 =?us-ascii?Q?LpjSJvzpO3Ke13RMnoEWxVwrNfXu25sxlPkqGB41tYA6AzVK0zWZ+egL+T03?=
 =?us-ascii?Q?4GcCUrgcWdBu6i0/c032aUzh9gijfEtF9ZbPcrW/BJVUYArWFZwdmqVoV6D2?=
 =?us-ascii?Q?+IqrTss2yO1avh5LkQKO9DVr83jwqhxjsRX+vY/mGhYSgm1xo3Krj5/0ET5X?=
 =?us-ascii?Q?Jpn093X0AhceU58rQqnacLxxUZoY?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 110c7b46-9816-46d2-3f9c-08d93d3ada2f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 09:22:02.8458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vv5SG4oDK1LcJ+4sLgmbiyA3PWOoTRHpeMWRQ8aGP8hVScLja4jpIY4Es7ONOpoazQXDLTBgzS1CgNra9Pw0ofNbovsYbJYBHxBl07ljflU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4987
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

The current location of the callback delete can lead to a race
condition where deleting the callback requires a write_lock on
the nf_table, but at the same time another thread from netfilter
could have taken a read lock on the table before trying to offload.
Since the driver is taking a rtnl_lock this can lead into a deadlock
situation, where the netfilter offload will wait for the cls_flower
rtnl_lock to be released, but this cannot happen since this is
waiting for the nf_table read_lock to be released before it can
delete the callback.

Solve this by completely removing the nf_flow_table_offload_del_cb
call, as this will now be cleaned up by act_ct itself when cleaning
up the specific nf_table.

Fixes: 62268e78145f ("nfp: flower-ct: add nft callback stubs")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/conntrack.c   | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 273d529d43c2..128020b1573e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1141,20 +1141,7 @@ int nfp_fl_ct_del_flow(struct nfp_fl_ct_map_entry *ct_map_ent)
 		nfp_fl_ct_clean_flow_entry(ct_entry);
 		kfree(ct_map_ent);
 
-		/* If this is the last pre_ct_rule it means that it is
-		 * very likely that the nft table will be cleaned up next,
-		 * as this happens on the removal of the last act_ct flow.
-		 * However we cannot deregister the callback on the removal
-		 * of the last nft flow as this runs into a deadlock situation.
-		 * So deregister the callback on removal of the last pre_ct flow
-		 * and remove any remaining nft flow entries. We also cannot
-		 * save this state and delete the callback later since the
-		 * nft table would already have been freed at that time.
-		 */
 		if (!zt->pre_ct_count) {
-			nf_flow_table_offload_del_cb(zt->nft,
-						     nfp_fl_ct_handle_nft_flow,
-						     zt);
 			zt->nft = NULL;
 			nfp_fl_ct_clean_nft_entries(zt);
 		}
-- 
2.20.1

