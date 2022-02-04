Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38934AA379
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353587AbiBDWrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:47:03 -0500
Received: from mail-eus2azon11021019.outbound.protection.outlook.com ([52.101.57.19]:46583
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353060AbiBDWrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 17:47:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlihyDs4PSfL7VgwiccR5pX3jqJYpYDOMBp6iLbPQ/jcCWajwmHWppw4DWkwwqfH1Ph67ipY2/NpnWfqdKf6Xu6n/wlqP6q2wj07QHZqjVFVbnUe5R5RfRQYYOZRMR9pBnSS41MduTWFmrkakg+f4geVkF4x22LSw/fj/ExtusdCB0bzOEUxHlbVUEDntZQOn90/iLiscSAn8CxXwXlULw3K1sW0ATB1Gxy/m/DsAMJVNxZw1u751P/syGnX2XeblcEtBMOLiDn/P9WCmWdWJCMvuzA834oaF6VHTlqVgoxkMWducgvw0nvaoF/W9z3chSdb9JOuE266QMHnUrGcBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FHHZy1+nj7WYa9wRffSn6QrdHSKcvd0K3Ec4u8FE1pA=;
 b=QIXJQ7h03qFrMx61o7GQa042c0F3h7iCd8rAIkLy1bNAoPu/JUhS0rtJRQ/I1rs09JjMYbF13g3DBJnQum/6FL/dahkWyNslVqmuBkPtssLGO96kUsQScoUiOno773bc7HakHx0aSYebzDV00m/12Q+okzeyl5NxWqqfJu8tk9LA2uEsMqnLzN6CCQpSxg6HexNGlCWkIgrYX/2S0dihSu2bZ9YrhkfdKpscgGD383nDs7U2NM61NjxhQFbcB7RPyVDjIK7Pk48UqHfZSvqCUwvd6HccoDsDl2mEeHH4xH8PviUBje14thxQayFBEcSXwUTW8tdz/0d1KXYtMSFkBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHHZy1+nj7WYa9wRffSn6QrdHSKcvd0K3Ec4u8FE1pA=;
 b=OEfY9NCozWf1/TyozpkKwvCPiAU9p/y4FRvTQQcshojEo6406WKjoheuzbZ6IV6HFll4058VReRQ2eqctxGIL4jn1Oh4D4rf2wOVx19lTCeK2NtaS5LbKiUmg2oxbjA71GY1AjP8NzuVaGMnASkeuAvY2FzuR604zda7+jpvmpQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by BN8PR21MB1155.namprd21.prod.outlook.com (2603:10b6:408:73::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.8; Fri, 4 Feb
 2022 22:46:56 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd%8]) with mapi id 15.20.4975.005; Fri, 4 Feb 2022
 22:46:56 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 2/2] net: mana: Remove unnecessary check of cqe_type in mana_process_rx_cqe()
Date:   Fri,  4 Feb 2022 14:45:45 -0800
Message-Id: <1644014745-22261-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
References: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0018.namprd06.prod.outlook.com
 (2603:10b6:303:2a::23) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75c8de84-4272-47aa-fc73-08d9e8303f13
X-MS-TrafficTypeDiagnostic: BN8PR21MB1155:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-AtpMessageProperties: SA|SL
X-Microsoft-Antispam-PRVS: <BN8PR21MB11550B12C4F278DD0C8F7D1BAC299@BN8PR21MB1155.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:478;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oiYa0/Ni4kosmJ+56KRZOvxRjpwnm+Ldv+2NXY71oXHALByuXjeF9gFl4VlJOMWa8nYlSu0J4qoKDNtEct5WTxGLciIMWyHVJCdoW28Lm3XKwhpByofMUesNy41X4Vw6M2KKAPRofYPq6nfjo8tcG4A0c9KX1w0Il+TqJiuoKFd24DEdi4NsAH7SK4sYFxvsyl8qR2OjyZiuVNpe136Q8fOMacSCoG/3vpOGkM2cDME6VuIaEqJiRfD/cTjaZp2XcokAMbyj7d2DSSAuH3d0Ij+gv4U54MhwgZVf9+3eQzFKpykCzCkb69oMTfObnddDp92YxD/sERb0vc9ZNgcwrkkbeOx5e44r+uO5U8w8OKkhCKhC2Q3dRIgltSb7CQ6G9ORawa1sdXE7sGTGInRokXKV2A4OWsCDRDk9oggqo7M/TazItXTnld0f020PxZKEkAlePwz0jstOrjcDLVURnF4Kxffs/3sZslli2LJpSfBlsvlcyyE1eonmKkTPrBTD4eEaMx+56m08Up3wF9czPiBpe+/jZohUR74lFFS8TnMbgLmo/XLsJAfI+D44p0uBKmscfDCFjBVPN4O8x3nnpZA2f45qR1UI3t3d5iFN/tE7r2/Va4w1GHPLH2GyH7E6uULuFunCZ+GGkPFepf0dNCaOPRKMvdBQdhirKPHyZ2CB4iMscSuifE0QAthGmeK6ipmLj/XEmbCEyM5VsRdA0To7sUUuI6QAeLf2J+ykCh1tR7Mdgs1JBuZ55mOk5eFZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(38350700002)(4326008)(83380400001)(4744005)(2906002)(5660300002)(8936002)(36756003)(2616005)(316002)(6486002)(8676002)(52116002)(7846003)(6512007)(6506007)(26005)(66946007)(66476007)(82950400001)(82960400001)(6666004)(508600001)(66556008)(186003)(10290500003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jj75fZ768J8Prd14CA9F9V19jnzdCttH/E0G/mfDGZIgyULDzGGoMDCredu6?=
 =?us-ascii?Q?X2geSUBylsY8SEBN5pay3AAANBVXLWZprWkvdfLrNpxal9Sj23+6Ng59sLl0?=
 =?us-ascii?Q?J73IHBdQzcan1u7v9OW0FbFiIbCKJr8eAkKjQ40kPWnErDW+PNjiMT6I6cSA?=
 =?us-ascii?Q?sIopK5ioiuSa1MLAVFlyVS7tWThuhV/KdP6VtlZ7CEWXrCIYBGl4vDE7xdC5?=
 =?us-ascii?Q?iQncPGXPkX4VejJKen/zSYXvpL2ytF6+g+nKjK6/wT22ILGE/2XR08D4lMgF?=
 =?us-ascii?Q?fm7X++7WnuH2Qq4GvDBrjCmEK8wFHs4XihmQOApa2xGO4d7lQScHIhZv0vm2?=
 =?us-ascii?Q?frjdAcajHh7aFS2UCyTbsRXVQ1c28cZCwxn3Yzm97Gc9UOup1qKPtVo/7Aj9?=
 =?us-ascii?Q?h/kq4kXF2lVlN7CVIDigOOpvD4xgCV5BSVxUH0dxnsyFZoUKzs0DxYv1dAqZ?=
 =?us-ascii?Q?8b76GOvp5qvs36WOdxr5/RI2ML5A+pGsx2UdKzCo+bIxeLdXP3l6s15un3Z9?=
 =?us-ascii?Q?VOkNfrekqacKzxphefJ1sjHCSUw86B+Q3sRnR4bU0ZiURu2g6galNLPZ7sUg?=
 =?us-ascii?Q?PkjoFEtvzLBntbdYKAzdguqjXaKlG7C3aOuJJGagHIxEwuX2ojQzTZh2Sh7f?=
 =?us-ascii?Q?Igg8/HarTcaqStsdTL4XeMh/DTyZj5RLvjpa0BlsgBoG1Gd71o2U9V9ik8WI?=
 =?us-ascii?Q?92WIwpmC6XplAzlFOqG2Gt0wedxulpw9V/uRCALk1q2Igfg4kolgqWMAqhyd?=
 =?us-ascii?Q?/jNP4DsysLb/G1cGRfnuLodqfVzyNZjBbg+1tBSeJycjHOhLSPbyQjNX0XiD?=
 =?us-ascii?Q?uv3KwQereVBmjzmWbbnjy0iErECsm7ljbh3YMzEJY/1ve5QgOamS0WV+U1CY?=
 =?us-ascii?Q?p7Gn8IU5qdlJznZK3SIlbCZHTRxjZdMKIlvvtGHi6oiPR0XMF80T2yQhHEjf?=
 =?us-ascii?Q?u/AI1zSqzydN0muF9MPzAZ7SVGhccRGiU8vryJL56YjEYAo9QrGA2fd99hdS?=
 =?us-ascii?Q?5m9K/9IlhqJMO3AZ84gQQI4Y7fQNDc3jx2wMXulkIhtAttrE3QhJ+SnUDvRR?=
 =?us-ascii?Q?CwfHC8WQtixpV5CDZ+N6TPvEkOchNKDaFMPLPMK2RiFMTk7LB0AdoYxT03aQ?=
 =?us-ascii?Q?JCwAAi//wCM4uupbzUyuyWr0ZKHIqw8hhsPbtOG+AM71ed31gIysYsvrS3US?=
 =?us-ascii?Q?eOk/dM3OCUGblUoKbixqbV+GXgd/Sth+oNMO297W6kyVsZlwHvafoN0Ub4Fr?=
 =?us-ascii?Q?wKg4mCi7eaOjtcoNl667IlIxZs5000wVcCbMuZnloSB+SNIQCh+M8WF7hiLK?=
 =?us-ascii?Q?hdPv/Dl7RYpZLvxPKVN40eJadd+o8Rzhb1HbSyw4MCfiGYceN8hoOzqi8zVR?=
 =?us-ascii?Q?Jv2q9JOuSH6gqzmJ9UV+FJwbkcTb3Coo7ZUcQEME+dGQep3cJV7cb/2AiQAN?=
 =?us-ascii?Q?+oB1X4mlKI/1252Ks0VzILS/rOT20gZFfYo9NMhqELgbfMgB5VsMVMQGRE/F?=
 =?us-ascii?Q?wxNku8A72AiiThWaXBNsfsCld5ZeMyxVnfibIDmv6p4gwHkt3Zy/rv35vSX5?=
 =?us-ascii?Q?lmtzv/tfRxIRUa2w5h8PEJ1ZHl/v1H6x9ISRmtZYwlGp7hiHlaI2JOYPUMrL?=
 =?us-ascii?Q?6AGyghVeh7XD6jgskp1T1zE=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c8de84-4272-47aa-fc73-08d9e8303f13
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 22:46:56.5084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4iT9Uzev9tTQ5YA6iO8iRq+kHQKe10ETzzgEHrLDRmzuelmxePReFiyrm2GJxKouNZMW0I79T8XspDNYhxBPNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1155
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch statement already ensures cqe_type == CQE_RX_OKAY at that
point.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index d2481a500654..b7d3ba1b4d17 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1104,9 +1104,6 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 		return;
 	}
 
-	if (oob->cqe_hdr.cqe_type != CQE_RX_OKAY)
-		return;
-
 	pktlen = oob->ppi[0].pkt_len;
 
 	if (pktlen == 0) {
-- 
2.25.1

