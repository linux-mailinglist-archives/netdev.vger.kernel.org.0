Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A776BFF82
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 07:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjCSGBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 02:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCSGBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 02:01:07 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2095.outbound.protection.outlook.com [40.107.13.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE9B22116
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 23:01:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdtOEcnh1957puqnEIC7p1YEQG1pXFovZq3hgsg7/nXT1lEI17y0GjfHriSNpi0FWK8jkci++zeO3qZSvsFFIL3YsG8xUU4dHTYEXwEwuYU0UdhTCVQTs8KI7Nij2zQFmewY+BqVlAiu3U9RPT5xzQXZJFxGxpQFwKd9mFqZ43vzI2axr97+FReMR54tJbGxqBFZnMFCxvIs4XoUUvpgPDUVCereGMWo8xcSP7Ef9Q7PP5hymJ+GSDueqOu7JefiIpPjS5td4zd5CepxucEywroRvM/c+4EKAGBukd5RIHj3sqj3+934SARZ1X1caUWgJ4VJi/BM07fHT8aZRxBThg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HkTS8Jpr/KjJSkQGui7m7winhLAvRRIM8g02MHx2Q0=;
 b=mGhzzJkXRHfARfpdu7NPZDQXqA9E66hNAxWnXu9Mrn8y4/2eTXA9Q8bqpP+SVbORkTUpdRbQaT++cyMArrJ9mq2NDKQ/gUZTGmFxljIxjHelCJp0QeiBgVKJ+XIKSTNcEGy5uhhUKIgeszdFVcIPhj5Qz+xS5sQ+8yRYfUpY7SPZ1dS6fTRL+8BlQ/qxtFuZD0dt2NZ5C8+Z+DnPDj43q2C++443V3rz6UB+6gYnpD6JZ7s7kqVEp5RN3vX78k1zxnNgOTte6KJgXpkVWjLmERNJGp86rfGhdxxV5oI5Qz9eoFxRBUPaaXAH540lPoS9MDUovSa/qmSPMBDwx+VZvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HkTS8Jpr/KjJSkQGui7m7winhLAvRRIM8g02MHx2Q0=;
 b=h8VWyu/XVB/sNB0cFxAAnJh/PDweOivTMHh1mmctiTyTABuV+WjHIWEoR8ZbqhJoeVelPwU+jA5jA4Q1AXkRFi+p0dIZCHwKi2sgOravnqBDZHh7tBtFSSRqRnhdiulF4maSjP6jXx9cUze4U7CuPg6yxVVzy+6qnuNjktwleTg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DB4PR05MB10392.eurprd05.prod.outlook.com (2603:10a6:10:3cf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sun, 19 Mar
 2023 06:01:02 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%9]) with mapi id 15.20.6178.037; Sun, 19 Mar 2023
 06:01:02 +0000
Date:   Sun, 19 Mar 2023 07:00:58 +0100
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: [PATCH v2 2/3] net: mvpp2: parser fix QinQ
Message-ID: <20230319060058.iaptzyiwpi7sigez@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR3P281CA0079.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::7) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DB4PR05MB10392:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d66530-ca67-4bb4-49e2-08db283f5194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x4TOyqUUKVncClO8GRKCyk4zMkkIOZz8SXIdACFXLvV6GSvbs/mJEpyLV2cWaksumy6IjLb1tDMvr0OOfmSL1f+dFE49ePu+tKgLEyFZsuVG4eJhnpw0BzdI5pBHZW7/idHp8HJk6/RSfX8ILCBZ2MaC1GiOs9Hn1HH6trCqRPSYwFM5ihIA4RJUWdt/2Xbi+SMdHYsq+QKi48fo+nby215uybovECsCabyEPZTKPz3Xaf/k/2WC3mQ5xGi249OJVoYxGOXQOfCc4fENztZxgo7ZXR/FEKSamzyag4oDrrjSAI6yERdZekdUVBfjga7ugmyYvKFSNYRxU3UmyHYLWJQkl1G5zT9fr8RqdUXar0CKzrmumceRf0SFTWlG1zIBFzwVQKwqW+IvtUENgSBmoFD2+SvkQG/sgFWgT93Hgh8cEpuqspL84J0Ij2X7tdmfwYyqsUNwMben+AvY87cBLaJi8QFqDzaNEyWdtmMRdSwmqSwygk0DQvL0bLnLBqNlhf5k9F2CeWPzaFFXwF0B6snJOYGtMx0JduaQWE/DJDjZlbD3KkOCX+ODS3ve3CN4dSRJKLx0yzpV+DDXmWWXpcHVjBzEwDz3eRKfsyaX/gcQmzH4esf+0xKAhWeluhtuJ8rJMjQPIBh0JscDvl0/Cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(136003)(366004)(396003)(376002)(346002)(451199018)(86362001)(316002)(4744005)(2906002)(8936002)(41300700001)(5660300002)(4326008)(66476007)(8676002)(66556008)(478600001)(6916009)(66946007)(38100700002)(83380400001)(6666004)(9686003)(6506007)(26005)(6486002)(186003)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z3S0sFW7ACc9KWxSd3u+dPO+897fGT+YJelRBx9LWAUrcvOSkLFhLtOzTzY+?=
 =?us-ascii?Q?FoC2LoflIRbgNUVAvhu2q4JicUefKD5H8WfZTPfyyfTBsWP2MPzhCtMO8qyT?=
 =?us-ascii?Q?RF2fmCrD09Hoh54Assj97FH4VW2KnoKPaYjY+aajoGWKtasqnuOxTKGjWr1u?=
 =?us-ascii?Q?6oUUPJYtsAPl7tqO/k8XNGZGaVwPoVvBv4Fil2HXinAROhhFbx2yEYa8RZB2?=
 =?us-ascii?Q?orI1ZY3nQO+Qla11VWFt4M6HVXqzI/YkfgROIOh+l56PrB7HRSQ76SB2JMmO?=
 =?us-ascii?Q?YOpUcLKHjf5tc8hzXroCluwqTEGCbVedRp6EmKn828m1B/pEl/Pqcd/2znbR?=
 =?us-ascii?Q?SN2f9bbiyystEPu/B00sDIkRIWfEMlP/kOX+61Piemlfs+p9tbVVVc4dtOcC?=
 =?us-ascii?Q?X9XiCr0PBm9C1Qu4HMMkeRAm66u/h38ezCv2kMkq8i94Fct1Nn8DGRbuUDji?=
 =?us-ascii?Q?YNGcmlg4iuRw0S+tz/qCtIucULfWoHRuSk9DHRcto+/fA2PYvx1r4nJtXYA4?=
 =?us-ascii?Q?ZcHw8DxM7o6lIrPgiwaj6dzksjDVvsNtJdf7XQu+pEFDfbTnvbeUSwCeAvYZ?=
 =?us-ascii?Q?3Uk974quVdxDhYvJGKdQiSS74aa4J4nKFtGyNW+KQEjd7cfvUGpB6q2rNuKK?=
 =?us-ascii?Q?tFpcCWFrwv8dREjGiSWlDVnSAkekGVoNSqxUZJax7t69dQCkZv5RFyquNeAK?=
 =?us-ascii?Q?GtOSeKXBwQolRj3QLqxV+i1vnzMfK9ln7QBKxQVVNDtsCpsrzOzSQXHOEXzQ?=
 =?us-ascii?Q?0WPDEvQjXVJ1K40BPPPo4TR5/gLH2oxZApcRZtIAFbkUT/GLrAoo88Q2j7DN?=
 =?us-ascii?Q?6uYOeNuevSs0aFR6Hefj4iCOdtUicOPjZ42cZ/4LmwCmMoepSCzGl/pgZRJz?=
 =?us-ascii?Q?4JMMFat6iTaT/OyeUWAvKpGUJYIC5iPV6IRliN0jFNQf+ae+Ppfy4ahcIK1H?=
 =?us-ascii?Q?52FxYcZ8MY5SOVb+iTQ1O4vQwi3Gt3h0TY6Bik3cu8f7B5oXbqWPTlkhK7az?=
 =?us-ascii?Q?6fVtmDfv9W9SqSgrmlgBXbx8PKiVoraRJA0mrNN/ekYfFWI0CsfffSycyLva?=
 =?us-ascii?Q?YQgrbjgNA1sY/unsusvp12fqF9O3kENlKHGSsVweBZwHO1YGLuFPzkA2dFoc?=
 =?us-ascii?Q?QCKwxQLE42gXNjmVPU4Sz8s73pgdVZOesUuNUGf74FOEun6PMJU/uinY4xO8?=
 =?us-ascii?Q?cPm5dUNNYx99uZBwHQFBHnXOhrKaORRk3b5cBXIZByZSYPjVwa2CapOO40I9?=
 =?us-ascii?Q?HPbvqUBswu9KeWNmZFnVeIyMZBIQUDTExqYhvKtMnrLT7GPdJfvzKoODgjG7?=
 =?us-ascii?Q?PN7iD0A9wdVsW1WRlxs3P7YYvA4vGH+z/kGScY85URYGuTQhmjgEZftxMsLt?=
 =?us-ascii?Q?l3BhVYIoSwbxv9P0MWY5WCkm2wpdfPsmDPYqw1AZZh/ssOpA84IEqnD0bkoA?=
 =?us-ascii?Q?S7kQaudCnsfYzI0Zj279IzXYbqSx4tFvws6kgkua+o2XhuDnhmvYD9ZpQ6A9?=
 =?us-ascii?Q?3sXdfv2K/3lh1ApZWiESojg1+hoCJL23MMF4FXL+4go7B0TEl/MsNuBBDZtC?=
 =?us-ascii?Q?osU+XKbGrmOgDzch7VrOFyPkfdIJATSbtkv/l/h0z4AloGvuWjocQA/HN/Jh?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d66530-ca67-4bb4-49e2-08db283f5194
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2023 06:01:02.1343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RQxCt4qOkj0wc647ZEyjDEsQ1A2ElGhHaXTSEzEoKtj3D/divmL9HyHQ70P6BEqbDZ1kY2gZBo10qnusRzY619dvSh4HAsEA+j2ZQBpqyho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR05MB10392
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mvpp2 parser entry for QinQ has the inner and outer VLAN
in the wrong order.
Fix the problem by swapping them.

Change from v1:
	* Added the fixes tag

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

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

