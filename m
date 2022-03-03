Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEDB4CBF88
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbiCCOHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbiCCOHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:07:06 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130044.outbound.protection.outlook.com [40.107.13.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B78F18C7B4
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:06:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWMtLe7uNZ//Kk2uOg1ttpoGJi/h9MwV2aLigzXH/q0y9WhApSclI0WjdcE5qPnNmTSTQM7QkTyVpJfourKeB02g2xeexLduGnZcuhNpxAOAZUJ9c+uJ1H5hQRn3RhUCtO/Xamh73o64lynRhbRMT/dM7YPb0j6QCdUPUL/7tlgJ+qIfcA7bQjlUo+J83II68Z1hIv6tV/cMngQurnu6hS1oPMI8d2xoN2aZG5I/DrZpUQRJr2nLzNcBFU/VdKrWoLy+GkWna8AoASSsvKJbj9O2TGlO3nbJAoc3+S9gU722JIVOIdACXFn+Q0HWmkXagmnsggWneWG8sohU2T6PjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDmb8w8Vc0U9OMptEp+ywsP8yj1JEshDjW4iJxrJRAc=;
 b=Xr0St0DOsKkYU47pNxaci/Bb2uoicO47TSbtCK9hK2CNgfBN6biCYw4GOiTXK1ie9kCLHnGIZHIycPmjJy2+bPUhYcNXrNeCZl+NFsU07rghcfxbQtQvsV4EyfCby+8uiN5mB4FQcIcO/M29ULjrB7dQQaHsTkfKPYOOXhXozk+/2s55sEELB8AH4h7eTc4z4P/zVQ9BqwgxoxRiSPvQItPvinSX4M1A89T1TKaLzMeeO0UNh+qTuKhD6UF/dZ8nTFpXEVnSEdqu6zx3bx29rzo/ELqJm9XAioHbJy1KAuFljMtJA3pChAwexfTfGJLDF/9P9Ww+FOywpRVDk5f6Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDmb8w8Vc0U9OMptEp+ywsP8yj1JEshDjW4iJxrJRAc=;
 b=Aau/0col20HlLoiud9kxX4Z2Yps2rsxb5ml+XJOZu+Dwrnw2iHRQS3BYWCU5tJ8ByxXYV11dL5AQHkCDJBubqMnJ9jB53aT0EzMIkC4EmmyFk5A1j2jIdeVYBTiQsoupoeNt9I06ELwmgNp1/9fCNVNnggZRjxq77HuGoM6ut2c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6994.eurprd04.prod.outlook.com (2603:10a6:208:188::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Thu, 3 Mar
 2022 14:06:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 14:06:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: unlock the rtnl_mutex when dsa_master_setup() fails
Date:   Thu,  3 Mar 2022 16:06:08 +0200
Message-Id: <20220303140608.1817631-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0118.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0052f82e-3006-4b56-2a6c-08d9fd1efbef
X-MS-TrafficTypeDiagnostic: AM0PR04MB6994:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6994915058B7894513E102A4E0049@AM0PR04MB6994.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yn7Ed/IrArqVWVS+Wu4fblhV9mCsIRRgVROebm3AM6nsdXAPHCVnVazXdLylEsoydXgpoeUvdVPGXkTaWLpI+a6Iu9YvYfS4Au0NyoateX2+/uTdDq72IxYECqzayxVPWdJfNIcpTS/d9C9dYNdBlUzmIES87a4n9uLlMXRNwnQ0Meb5eHOKIRvHnfo7vioX0qznFbVdGZdvf0jXStYuJBPMXjm2DNxPPv3vr0r4JmNfrTp7okzL+QDkZkS8tFW7Y+/mVazO+2SlnVfzJdDDdWjoiGvExedYtVEakDYg343/gF3pTzPQ47wMyLkKARcJlnOiX8LlRsdLqFKRqIgi7iHa2gqR73LGJr6Le4yUeOswBNpoXBAZU8CrotULIkZS3yfih8DzZTd6hjZY/nMUJvuoeJ/xTolVmSr8CsRf5yntaM9rFy8rO+9wbo+w/nDwmuCJyUcVqeboj2LsB8b2tdwrNMuDM+MHsSeqtcC8oyjHEQ/lmSqbvz5hhfhRf7eSC/mdcM8IMw3CZfjDJ+VMJdEBRUZduspJX5DrdXXOIkAclftZkthiIdQ2mU7yhDBUpnqE8bUCLDMzvtlSslZhsi/CKCtIutVgYpbCV8HKXXEse5m0QdZDxKdtqs9o0AmX67bW9QU86Dbyql85XQN1uo3y1RZ3rL2YmXPmMdk3Lh1afRpsgEGKjv7ZF5lQRo+0smSiTpAaxLCN2vM90dGhCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(498600001)(6486002)(66476007)(52116002)(66946007)(66556008)(4326008)(2616005)(5660300002)(8936002)(6506007)(83380400001)(6512007)(4744005)(36756003)(44832011)(26005)(38350700002)(38100700002)(8676002)(6916009)(54906003)(2906002)(1076003)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5t9hkVVq3zt+hTaOrvkRPZqflPMH9stIRdFR/5oRN6EuBbz8KnJDdDKYgg+Q?=
 =?us-ascii?Q?rpltvKBDhAUoFMqK1ShDn41t+zrsXVAxoW4aeHGXkVF+KEaK0AwlKeZWUC/E?=
 =?us-ascii?Q?W3cB+w19kOiUcfSffk4Bv+ozoHQG7v3VL5wsKUGtptLr0+5Gh3lX+7JLDdpc?=
 =?us-ascii?Q?ss8PgZEpVXT7OqF5VjqLS9FacKT2453Lwi6rR/Pynp+E7bLgOa6ONjRa3BT/?=
 =?us-ascii?Q?DgKyv/UBvi5k/CinQXDwI2zge/aP7CoceXp2kePSYzENCcIxNOoT4LI1cNhw?=
 =?us-ascii?Q?MbLjpu++RZnQ9VpAh1c1+zfJemAmlPqfEtbca7s8alPSSVOtEgy7zAMHPo9H?=
 =?us-ascii?Q?a5tndrSaKTBkDvLrgA44YC4RHbMJNsTnQdbQYiktJ1vqj3MbEyUoVKVwNlXV?=
 =?us-ascii?Q?HuplabV7YO7Mcrj4PuUTre4G+f/XDaZ98e6TjuJvAoczV/3c5bE84x4IksEf?=
 =?us-ascii?Q?BOELJPEeQq7X1ZS0vTW7f9y0XEcwi1oSoW4dXyOAms1QsHpomSiRAXsHCrpD?=
 =?us-ascii?Q?NI/pcttW2lRPByiwe+7eH1KSAknd/7ZpG4RMjM7iJK//dPyXRg9SNn82ZFFU?=
 =?us-ascii?Q?fDElHVt9Xgl0e/9UhfKIy4dnz+cQdvqN1Vb71idBDFn84G5P98GQXtPnLolw?=
 =?us-ascii?Q?TQQdyEz244kToHev1e1EiZdqhABoLjN5R0S81NlM2ENLD8a6dYbeI5HgWIcW?=
 =?us-ascii?Q?IG7Rg4zHnWIZeQ5ljeKfFPaSvgORiBA9G3k1UNk0ZoZbGLlw4stDc2ZfGwvI?=
 =?us-ascii?Q?2sDVM0Yz1r7MsJPaUclkvBkwJ14IVaNPePPdlqkLMp7YdwtZ8mcmbEWCGMs6?=
 =?us-ascii?Q?EDbxbmmCxGuJ5bn2yr8p69RSD7vlmDsfL2f4uE4h3BCOaBnIlYkfn1vSnnkY?=
 =?us-ascii?Q?EsctB7aa+qFl3TRV9027lvs6G69IAHfsxSXslj/N3VIa13aPwwot0ABsWS3C?=
 =?us-ascii?Q?1wa2CbAOpWR9Mu31oaU4tp/iVQ9CigzGuU9Mp4FLvO1tSk9wsU25x4Q2NGd9?=
 =?us-ascii?Q?pwK3cS2CriZwUw/KTuuYBsy8USQ0Del/EQJ86epHVuFjRdzjQF/bqPLYLh+V?=
 =?us-ascii?Q?pGHAhbIPx2bA9xeMVhV8MDzT6ytssCQEFkVIi4Whl6WehMoJV2uH9w2fiHNy?=
 =?us-ascii?Q?MhKdYSvdmiBCNE17kGZazOQI0iEtYETdS9wXJO6tlQwt0jlR9A2SmII+yLbJ?=
 =?us-ascii?Q?grGbletL6qc+3n3FfbZuKGzQDI/sRpYq74eM5KRp3buRCrSKU1RjO4BGdYf7?=
 =?us-ascii?Q?CNRCsK6ZQmn3YcKBjQOUBRihUyJzLoiKthnZ/sNuAl/856gsnOxfhrmwpbqX?=
 =?us-ascii?Q?RHuMSR74AOGC7EDXYNKL4XeUlb8/9yHUqJHpPaGTE4q4846aKLmXwmgB+ZVq?=
 =?us-ascii?Q?n8JNHiO5ub2Hz3Wx+kDpDaTXRe28yWsjTbnh/TdYD2FMviY8ZVHjvGqmQw3K?=
 =?us-ascii?Q?kH5hqJ2hPB7bnqkJfGH6bm1DRjzpxSkCT6QfFQZwXp+nVjnmhMSrH15OJDa/?=
 =?us-ascii?Q?SfREor9oxIQhzhqriMTy8BmNm4FPkPFWirM/wZ73XtgSAjAFbfEB3ELjEsGT?=
 =?us-ascii?Q?t+C88U9JpATXUvYYeegMDl6j8V5tFgOZDTB12goZH61oizwn0OuoOlJJvF5O?=
 =?us-ascii?Q?SGOzYeJbR5RxXct3dGyWlnY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0052f82e-3006-4b56-2a6c-08d9fd1efbef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 14:06:16.8487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pH7wlQundvkIIF4fy/1eHvIRa3vSdRVlMgLqE1ricRQuI6A+hohfMskjdDxTocatVXmK6hkWHema7EcRBCTWqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6994
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the blamed commit, dsa_tree_setup_master() may exit without
calling rtnl_unlock(), fix that.

Fixes: c146f9bc195a ("net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 030d5f26715a..4655e81138dd 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1072,7 +1072,7 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
-	int err;
+	int err = 0;
 
 	rtnl_lock();
 
@@ -1084,7 +1084,7 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 
 			err = dsa_master_setup(master, dp);
 			if (err)
-				return err;
+				break;
 
 			/* Replay master state event */
 			dsa_tree_master_admin_state_change(dst, master, admin_up);
-- 
2.25.1

