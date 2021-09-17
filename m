Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0E440F5D1
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 12:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242579AbhIQKXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 06:23:53 -0400
Received: from mail-db8eur05on2073.outbound.protection.outlook.com ([40.107.20.73]:3457
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242482AbhIQKXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 06:23:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csspK92A9bbdX9eOhm02JA/QhEhDMKLzOE4o1XiRYALSoMXoXTy3cMX9pXU+Nkb/Y3Q1MhzPrDNliAdv+prJ1ObWXHiUh7sTGI1V/9chZ2Qvb6v6MNaB05+DsKMPqsyH6Bfwvj42FqnIzkSPVVIemjf4nV6mqIlu+PoZZSw3BLOXySWcw/i7GvbwOaou/yllMjYoNWDOgtrUN+E0A4Q9FHB+6p+iNqaw2ZX9IphIKyhKQlurlmw7EZevuc5H1sYvXmT8LjnRA/KDzohikX9CPLt/4C6T89MGkUQr9x68T0BSOLXIkP25Mc9cEdHAvFdA/MxLfTXqJI/cpzYuZHeTLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ggr1otddYDZOcIzwX1RAtT1MGA0XZVrDJT1O+b3ijr4=;
 b=Fj239/Iz8PvhAeq67CcDjsPaeLAFi2dzn6EFkRr9NvRosxCR3nGIIe8njvPvA6mrZUOcp3nFoD6n+QrP4Os63A04Hu6r7i6R1XrE2VN0bJ5+PNJhQKcI2OwWSvDQEwXeM7YXiQWym7ZC+yS0gmAq+GzCs1tL/TisWWAsZHm4IRjp/AdjTxl6pfgK5MBKhCAFrffc6btBnw6I6yDx8mg9lR1CtiENY9ZvfeUBJZgWuHKNRzmsEEdge/1ZFTxQCviLiW8nIdT2Ciuuw4MUpHCR2YPENRUf7ZxHciaCHIQwE/Fst6GAaHEsgEwt/nTIWJsxFiNU8BIubgUPRmxPX/+Acw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggr1otddYDZOcIzwX1RAtT1MGA0XZVrDJT1O+b3ijr4=;
 b=Sm+I7l81pBVGYX4NrbNeshgKKzhRcZ9++OwHmUH75gUigRiCBMqjRnQZszx8zv9Ga/ZNxtN4Y0tdTASS7kBcheOSSYZ3JcUvnpgElekqsMJNH9QDXAohFBd9G8AhkjGjeH1Mj94HAvPlnWHshSZGkrMpYtuZcSd4VQVubFGZsEg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM0PR04MB4273.eurprd04.prod.outlook.com (2603:10a6:208:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 10:22:22 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c%7]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 10:22:22 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] enetc: Fix uninitialized struct dim_sample field usage
Date:   Fri, 17 Sep 2021 13:22:06 +0300
Message-Id: <20210917102206.20616-2-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210917102206.20616-1-claudiu.manoil@nxp.com>
References: <20210917102206.20616-1-claudiu.manoil@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0163.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::32) To AM9PR04MB8397.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b5::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (92.120.5.1) by AM0PR01CA0163.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Fri, 17 Sep 2021 10:22:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce4e209f-e828-4f24-17cc-08d979c5098e
X-MS-TrafficTypeDiagnostic: AM0PR04MB4273:
X-Microsoft-Antispam-PRVS: <AM0PR04MB42733FE4188F7128B58E770796DD9@AM0PR04MB4273.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZwJieOhM5YMEqjaiHbdFZVuv+ukRNmJKxrLAdzJHxDaED/hGT3LkDn82AsMJOJ6M5e0/ruJRiE/Lb2xyYZ79cTJGxz0j1rVg07cs52HgiI4hXz7M8+eF+k64cNQ+WC8ZMM1xevrsEt8jjTmRow5cmd4oJi+85vYR8zsJQ4bnIJZONSCxN2jps6iU+9aV/lAT+B8HXCquv3wfFMnHxv5JhreCmDsmD73s6hPtVJ+QE7fnG2TgOKRd4y/8B7xSpEcZ2kube6CU+5I+7Hg6zqDiFw20pPYFcFHf65MP7hPZfedKuU6jTUG8hmBf7fboj2Lu47H9spPN0UYJCB1VdMg3LVM0TiBM26h8HTt4/VuFlfySDJmfsRkPI9w73hlYUS+ejhezdZysMdAN8QK34D1DE1fsdYueYWROs1i53LwduUEx0ojsES7P/wgbDiNTz18zwe/8eNYFah+Q/02zB+CbJND73IQ3+IK8WKtxIGoS7vUmY09aNtyVFub4cL6mYSW0r+SeIk7CDqGJcK0EZGYeg9BtfN+SwMUNaxra5ZSpHrd+pbqJ7eFVDBHbcYrXvTPyE8zwXv1/lqivtviA/XP2L/+6ntdhMaCDX0uVsZV/H8G1uhYwP/thzQc2Pt2hJ18qAHiPrf8ce3gTbc1oCLfsaJMFViI2RFhtQMaxth9m+3l/b848ZRUu9dSfW/8AYd/s5+fH+jqffs4+Hy0B6tsQPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(4326008)(2906002)(66556008)(52116002)(66946007)(7696005)(6666004)(44832011)(26005)(83380400001)(186003)(1076003)(38100700002)(38350700002)(956004)(6486002)(66476007)(2616005)(5660300002)(36756003)(478600001)(54906003)(8676002)(86362001)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3k0kBLdmovR5fMwa2rTGDPekb4te37hbDebtFYYBYqpJUkcyUpDenwEZpcDG?=
 =?us-ascii?Q?6klFOKMwIhKhT9YrwEBqYe6PCetjzzbA1BHE7gXJkoFFi+3TiMIoEdD8FKX8?=
 =?us-ascii?Q?Q3vp0592yG6Ot8ek9PY+e9iQK1WZGzD8czgIX7aaYfDAs/MwWkTnh7hkxGAt?=
 =?us-ascii?Q?urcRhoDfzlIoU6bmjSJTHTh+5dquZsDpEaMBiUGpU4RI8D4o1aA4kZbgjD7b?=
 =?us-ascii?Q?0B1j+HBmGzwbknPKf0ZEfkl1YPU7gt9AzxVPhF63D19b3jYvN1UfDt7EuoRQ?=
 =?us-ascii?Q?4ssPPqeBhjg9Pj3OBiYZZYz0yN7OHhAa1/zRM6plxvUnqp/M3CoKPYesGsU8?=
 =?us-ascii?Q?Q6gBAd0xPlh1KVAzasY/6QLfuAxMG494l8U15rmFmxbiMBacE11YZVh5bmqH?=
 =?us-ascii?Q?sQ/RKLwE1m2XDNgM6D63sBnBRND9ikkxEEzYFOjIP/ifBb8kBPt57uggQlsk?=
 =?us-ascii?Q?W/I6gNroTBIWixjyRfKSIzIpMAWj+nfy77uMzljCziI///PBihfhNN+4CUSB?=
 =?us-ascii?Q?O/JEgceZ1SPPsP8sxRkKeqh4cCSPgF9C04H9pMa/s43joJNYPcJe6IJ2N56R?=
 =?us-ascii?Q?8UKBKkUvzYIv/LD+1pzOsdmiZqmG/w5KqwwyzPT+84+dkKqERTyqreBHz14W?=
 =?us-ascii?Q?OTVR8mfj1AAWcm7VLL3NPrm+ZZ6bmt9fOYAJbEwm0ufDKyiWuDI54457X4LA?=
 =?us-ascii?Q?c4YQLwQMIuu6SQYs0p1DkU218tumbnOGh9RNEiNp5glCfEvUNtFqLJFSK0Ja?=
 =?us-ascii?Q?VJ1m6ZKE3HasuLFcr5/G3adW47byvRckh+DP+p8essQQbteIiOVuay3qemiS?=
 =?us-ascii?Q?JuyqgFmQOMgaIQu2OvwHnJSQJVOee925rrHCMaIai7DYeZ0b6veDAG/+9rsm?=
 =?us-ascii?Q?sxlUY4wyoU6PSXVePimg0znNxom8lexF1tdsgjfy6IApdNs02LF5tWmNwN8h?=
 =?us-ascii?Q?2JGGNOeEtz1hMYQzW/QKIOG61miL8to8Q3DDaq1UivpdW1obpXk/yUowRHeH?=
 =?us-ascii?Q?3tufL/7Al0AvsT+By8/k+VPP4ibktP5wRVNLsir1sBhv5VkTghziNGbKE1k8?=
 =?us-ascii?Q?OwjfUrYpnBB6PRBQw2Xj67pxCZlJQ35nOsx/jK7U01lwETuYEbCgVX0GrbZt?=
 =?us-ascii?Q?+qa4TyHaQKlKCXt3prRPwsqes1A0DKnntcL7lt4/FwTLvCIsKP+JjeHvIgZ/?=
 =?us-ascii?Q?pwD52v9P+cURwnDTwL6fq6W00BRZ66lwv41wPKueiNxlHvhhhgYttGcbl+ri?=
 =?us-ascii?Q?E2ARNc+6a08wDmYOwNMgJIjaXOTAmLFLfTDBDk/qQMtxchQQylXIFc8NJJdT?=
 =?us-ascii?Q?qj3cXfLJN0+s5RLpwR+smNuH?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4e209f-e828-4f24-17cc-08d979c5098e
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 10:22:22.7054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uhh0tqadZOuipuvLhrbXErr2v6KAt1xUozu3cumlKclWTAX30I90FmKaeOlKt6Ug8CdrP7Z96Eml9zkgW+NwfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4273
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only struct dim_sample member that does not get
initialized by dim_update_sample() is comp_ctr. (There
is special API to initialize comp_ctr:
dim_update_sample_with_comps(), and it is currently used
only for RDMA.) comp_ctr is used to compute curr_stats->cmps
and curr_stats->cpe_ratio (see dim_calc_stats()) which in
turn are consumed by the rdma_dim_*() API.  Therefore,
functionally, the net_dim*() API consumers are not affected.
Nevertheless, fix the computation of statistics based
on an uninitialized variable, even if the mentioned statistics
are not used at the moment.

Fixes: ae0e6a5d1627 ("enetc: Add adaptive interrupt coalescing")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 7f90c27c0e79..042327b9981f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -419,7 +419,7 @@ static void enetc_rx_dim_work(struct work_struct *w)
 
 static void enetc_rx_net_dim(struct enetc_int_vector *v)
 {
-	struct dim_sample dim_sample;
+	struct dim_sample dim_sample = {};
 
 	v->comp_cnt++;
 
-- 
2.25.1

