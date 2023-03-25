Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A726C8F80
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 17:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbjCYQlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 12:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjCYQlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 12:41:01 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2108.outbound.protection.outlook.com [40.107.7.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A34DEC67
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 09:40:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmE6xO38uwlancoHZVMtfrp7mLChE+4ag4ppWVZmYeDkuHGGB6vIhoXh/34NpzVPujBqBkrfevy/NksA4X1fGUh9RDBdsjOSDStfcgSYujK0kUnpkmiM4MUuWYiS/pzvFuGulrDMCXEddVmkw9FS9FmActiEUuDOKx0o0yzePBf+EwTLqQ4/KaYfCAYqSETPQo2J2QfFsVfL50IDUeQ+GVfQHL3HUw0wGB8UQqWMIncaNVAzk4hVVWXe55NEudF8MHi10VXBkC3Y3zziPdyDOKp3te+fbs4xKENt6VgI/TlGavdn6WYkl+ULMEzLtuFBobYIxjhcZLscr6piHdQ7kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/limPhSmqFPuiGnQeKe/yWZIq31YorUjwu7hnUqyBZw=;
 b=LuwugOMhSfelsUAMnUYbUH7OHszr6jqYPnVnH40rxBrxK4T6zTHAr21DQcv6ZySevrTeMyIPHAGD8hjrkiTS49xXu/OHOqGoQizqwbiQrjzQj5twVWgcmiwgucCKddUgNm5x4ddtUpDvyePqZ2uVeDYnMeDw/ItlsnfyqyqqGKsrmRAm+TE4tiZ1x9MmDmjW8MrNDpX/wu089sEXr5reskrvCNP/sqVcr/TB+PLjRAZAOElv524VvzBHeT8PDSyj2nS8MlLVNP7N6PqsMRjQ2fB+m7Es0RoJtyWnMsVPC1hvyUeRjHucDnVYCDSIF+kT1SM2qwZxCMHEEsuRiSpuTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/limPhSmqFPuiGnQeKe/yWZIq31YorUjwu7hnUqyBZw=;
 b=Yft19Y7g3VdXtp0GsX/MqkvV0lHQavgoEpzW6cPBcaspqAJiVg0r53u66UyOh3hbAaALTGKLdgZ4upodAbxb1+8ERPPeIM5nzSNzYWSNfG3YlxtbdEPR3ABqW/nGOGfjo191XTelw2G2WTSFNyhf57JnbqlOhvLLxXoIvxP5v1g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DB9PR05MB9413.eurprd05.prod.outlook.com (2603:10a6:10:363::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Sat, 25 Mar
 2023 16:40:56 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%7]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 16:40:56 +0000
Date:   Sat, 25 Mar 2023 17:40:53 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com,
        pabeni@redhat.com
Subject: [PATCH v3 2/3] net: mvpp2: parser fix QinQ
Message-ID: <20230325164053.hiwjuxksscjm3ov4@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR2P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::19) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DB9PR05MB9413:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c94b0e2-5752-49ff-d808-08db2d4fb518
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWN0/vLV6RwtmKpbpBpHUDjsWsO/hvw7/pGdyixLnLGs8WqtvkyDsrNKbkHAlVIoKpaQEKUcWgkhXTr4HkNEwqNIjN9xzp0yg7Wpm81UPDzcZwIb4M1CnBB82zsTGhbssRP0wee+R/1dPcx9z4OSwmYeiS21FYKwAF1p5C+E6lfWQ6deAJIde9xUs2BCL9bH/3frQkAhCdiC8mEnzeCSeU0Bt9H7rKeC7BGxALmCX0DXiK9TBrWSFCWjLelTChIgPUF2Yoy78lp3/HPUDcn69e0Gh5LhOHaMVISsqy8dwNnk4LmLAaMnm0NYUbyntamFU1b0O/xatGCWxMCmiPnTCrox7zaCO71RFXbmrfq9SprIFGuBSjeisRw9bFqGvtphjI36mtLz7F9hXAIiTHawuDE4pKP1WGLHtAlMkagRjgiVPzyJCpvzgLpwrECshDzgXCf3w4gia56Rkj1JOeUoN1onTUN43i/F4jB5XzWoVNV+4VoeHMuy1OzcKGq/rTd/3iUVjapVmx2ZXoNgQSbtF51ppdlA4gD2bRkozw3ibUakxQip2myuyqKVGT720HdR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(136003)(376002)(39840400004)(451199021)(6512007)(41300700001)(83380400001)(186003)(86362001)(316002)(478600001)(66946007)(8936002)(8676002)(4326008)(6486002)(38100700002)(66476007)(6916009)(5660300002)(66556008)(1076003)(4744005)(26005)(2906002)(44832011)(6666004)(6506007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i5hXJc8ufvV9MKOZ9PPP8boApcmjBSPVInbst3TtuK38xKyY6qzlJZ3chw6k?=
 =?us-ascii?Q?wGQPQnkKkq2bx7OsGElhnTrih7IiuMWjy7X2LC2xk4fTfaEpgPknzAiXQtnU?=
 =?us-ascii?Q?Y0cxQISCJnfrMrdKSR7epPzKMD5eN3PCAXIX2fBFFUpjRBr1R33psIvcWBS+?=
 =?us-ascii?Q?6t8BEPRUcEPJYJqLIpakfdv10MYwhMpy9Ni9fAcnaUpRthnHle45X9rWvaG8?=
 =?us-ascii?Q?9S6sl0IwiYnjK5Bkr+zMzclIz4eNQ4pcJ/Uh8gx7fRDNDyXNt0W+9is/NjcD?=
 =?us-ascii?Q?HHcj1IQdkizPUToMTuHEz/Fak0yvg+As2JdztMsYuwPV8mrViBYfOWfe0tgj?=
 =?us-ascii?Q?0WXmUJnrwxKeBMdir+nlllSzvFeCs8KePPo686dxy4np44x42T+Fb9aD+4fZ?=
 =?us-ascii?Q?mVC16vpVGKOJic9C8AA3NJwQuA2k/O+rZso+MVkEVueO5kDBaddNGR5Bsg4A?=
 =?us-ascii?Q?0spgFdpYjvjgsfp3GsPQxfn2hH9ww+XAyIYbNfD3Z0t18q9OM8En42/02VVX?=
 =?us-ascii?Q?hl9maePmBNuN3y5B/1Bkg+MYRWneUACaB0iqUyLCkBVT0jg+svRjEZy3jaKM?=
 =?us-ascii?Q?zydm0uu/+EfGgQQKWgBHUwk1f65u45rUTRs5uMb3SPQdjOnJHuSQ9OUdVYx7?=
 =?us-ascii?Q?SI5tDP+PUa9lD3PtgqZrGxsX8NMyxOa19srAPW5bF64g7P59AxT7o+cLakPP?=
 =?us-ascii?Q?sK+RS4hTdfZMC6HhwOiluRxmKKuC3tnikDnSWxkwKJ/Qa69m59hF5c4fzcXd?=
 =?us-ascii?Q?y01bOiWzOQl3OUzTQ/bMZDLVyjEntyadIw31PIupsTC7Hy4gDKMOZhabQyXD?=
 =?us-ascii?Q?Cf8etFxe4FqagACgBqEEDFkF9JrOTmXZ1JC/Or5Nx4lRWPQVxr9HPOdSqr6k?=
 =?us-ascii?Q?9qz7U2Zu/hb5k0WSkwL7XZPnyRKw7sN/Lzk7aUVfKeaUpcWL51faMVUs9rI0?=
 =?us-ascii?Q?aqWdrcRzx3vVFtwHFsSn/vApH6qsnO0bJR4ZNWPjd1g/ONRpkD4/H734bMiv?=
 =?us-ascii?Q?au5b7C7Ja61H3r8M/+6VnBR2Gjxm0y64R7t2oxvRps0g67+dwx3pg9IaceWN?=
 =?us-ascii?Q?XPpcA3ZdmhPBI7gCb5XtyWEaCZiF2+n0gy8FGSzXxyc2EvZihVjpvlQGr7nN?=
 =?us-ascii?Q?a4OTL6H5KgoWMacW1gY0mhjfalcmfyeWWCmVVf5oNy9bxNiEqXYmi2sWoviW?=
 =?us-ascii?Q?q5BpcX1Nk338sqBF7szISstk6R/rVtmHDfaafEcuOb1aSYmAzXswUOUI+xL6?=
 =?us-ascii?Q?k2FO6O8NEbmpgpS8eBDv7nuQW1wnPCjl0ETWoKcRdepdnd95PtEOoZOKQQMP?=
 =?us-ascii?Q?CPDnh/UuOgQhT6Zy4TA33J8U6oGq5N7iS2oG6hF5KDnPHwHs6ylQg0sX8rz1?=
 =?us-ascii?Q?TfvAX/B9vm72OaVRfQdX5YcxmR0L85GDfZVxacUGLj+4X1j/elHu5csfxvG0?=
 =?us-ascii?Q?8b96GXRH39z9TiSyHH6OlbjSlLBQsCLYVSlTwRNK1BSeCETu4JfPcY+rNHIg?=
 =?us-ascii?Q?NYKak+EcBZ6b6l1eCPIcDUtr/PJrX6GirBbo23F7ruBmz6OW1ViEN6xC92iC?=
 =?us-ascii?Q?1NrQIjM0bqNpCWyKBjaDC+Ry+QH2wJG8B2hXcBaXzPEaSdnj/Kne0wYqkz+f?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c94b0e2-5752-49ff-d808-08db2d4fb518
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 16:40:56.8277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zU/L2GcuCiRS+JnQNAexDAZhLOwsEqDp24Rj7BRflaNoURVqJlPKqCQxpLuuPLfyS7VxUPuUyBk+JTdE28wJP3r3FuPv6rmPLKPU8L4Ppg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB9413
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mvpp2 parser entry for QinQ has the inner and outer VLAN
in the wrong order.
Fix the problem by swapping them.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---

Change from v2:
	* Formal fixes

Change from v1:
	* Added the fixes tag

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 75ba57bd1d46..ed8be396428b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1539,8 +1539,8 @@ static int mvpp2_prs_vlan_init(struct platform_device *pdev, struct mvpp2 *priv)
 	if (!priv->prs_double_vlans)
 		return -ENOMEM;
 
-	/* Double VLAN: 0x8100, 0x88A8 */
-	err = mvpp2_prs_double_vlan_add(priv, ETH_P_8021Q, ETH_P_8021AD,
+	/* Double VLAN: 0x88A8, 0x8100 */
+	err = mvpp2_prs_double_vlan_add(priv, ETH_P_8021AD, ETH_P_8021Q,
 					MVPP2_PRS_PORT_MASK);
 	if (err)
 		return err;
-- 
2.33.1

