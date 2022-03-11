Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24A14D5FF5
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbiCKKoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiCKKob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:31 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2114.outbound.protection.outlook.com [40.107.237.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDD610874C
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q89D037yIStqEv/i4Djjyr6ANHluZi02kbh65NCb0YzV3SA4PcuMr63vgyR9VSmcGkXunfzUK9TQhAmqglPRk8gAUg/s405Su49px92VlW/OISigX/6pOjGyH2ht1KL8wH1MH5tU1bO/Ru/r0zA9IrTv9574FtTEKKmNefT1xPxrLkvBqZXE0t0qte0nfMSge3uLOunBD7XwFZZ2CH8EhegYJLrawQ6hoEKKeZj6vD4Ci/ppq9FhxjrZB/DiiU9HzSepDIjM31ScZK5DRZ2CEGLbJf0ASovzGomEdVYtUNBIbGnjiQ7e3oqxeNBtqZF++qxMgYucltB4FaQGAiJlcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1uCKr2plZYgxxwQVXFvs1Ljp1lg8TbHvDqDPiNOeWE=;
 b=kOyIBDzNLEPfaE0O15es/GclOADuU3iSB0ieh0KLQQZgPfvse/aPyev8c6eE6hE3J6mMxfP08+d4f5Z54bwpBM78e0noal06CaauXACrNjLJvipluEstHk5fGbU6RxVKHDYs4WL8O0Afq4oe6G9Jd5q46m0Z1xcFDI6IistW4Cgab7TUOJ3zDYuGM1fdSvV+HuSCBU2DESoIXXzKZj0TIBhS46nbc5FdV3bEmzHCaANR1gerwT8GmcCatnHweK7VGy2kvYTxN/wOb3OO1MZbIoPvA0DJUosclH6B/m4GbqtMBr+pBCiyqQUaWym59RrRzg5Vmd2WiSjGBoNwhIp3/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1uCKr2plZYgxxwQVXFvs1Ljp1lg8TbHvDqDPiNOeWE=;
 b=aZuUJsaVZhH11G3JzgQf9EsyUez+D4oEVy7v9n2acwNFLHemt37TdZ/kZUX6aibKKDWRq1wKjGlDEKQC91Tlqez6ti+a8lIQsTm3oxcof9S97ArP7NyE+9GKLqwHvV3wMzOoQqXyVQjbURGzC/t8vYJCTNSUlW0oXGx482xpNiw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1184.namprd13.prod.outlook.com (2603:10b6:300:e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.8; Fri, 11 Mar
 2022 10:43:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:26 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 03/11] nfp: use PCI_DEVICE_ID_NETRONOME_NFP6000_VF for VFs instead
Date:   Fri, 11 Mar 2022 11:42:58 +0100
Message-Id: <20220311104306.28357-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220311104306.28357-1-simon.horman@corigine.com>
References: <20220311104306.28357-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d40a342d-8de3-4e25-20b8-08da034bf896
X-MS-TrafficTypeDiagnostic: MWHPR13MB1184:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB11848F532E364CA5569D61A5E80C9@MWHPR13MB1184.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WAT4RcMm1LDL5Y2czXZ9ogsoH0SEV13HxLKFeD0CQIlF/IYDs+HZb+gwtaI4YkLRh+4ecoI+8KUPO70nupWeOM1gX0SwcYGGg9/pVWXj133q5HqRAEfsvb1C6ppdPbdi8+G2GCR8NsRfUiHgrb18eiOKTbFPG3WAstNO67GjljvHUG23WaXweA+zlA6eIiUvI+4lfOMnPP/cM6+DUrRRhiqRP+nl7K6B191VUu2mvYfP4xfjZDQZGkXQkQuGKI3gxo6G7dhtEdz4g31DawPCC0nwT5wOQsP3b/5oWcWTYCh2X04sEE5YoySsiiNb63PuPi7DkRe8zy2Cj0w5zLgrKffZ7XpJKuUi+h6amJC+q7YFQ+AX6kCZKBHoFI3rb8L8snxQ9TeuJhEgIDPEy9rlntntujzL5Bn4TifmzT2hhnD/DomWZf54Ra7uGiAAkoIRdGdpaeoxEUsNDXU2u/rmtPoIMAnVYxVL5e1ICOaSBdfjWfBGrwHdXRbr98zetIUAepv11MyQ2L44gUCpK3lvlL0xrcSqaC2zVVc3eC9kS8ufmbdblXEr8sa8lEFFojuoWVPit5G75YYrbLtz2/xVKMOwGztMH13QczT5h9ZwtvX+yKA9afr9mLz1V6W5PKcs8z83deg7vxv3LpV1aBMY3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(376002)(346002)(39840400004)(136003)(36756003)(5660300002)(2906002)(44832011)(66556008)(8936002)(66946007)(6486002)(110136005)(86362001)(316002)(508600001)(6666004)(2616005)(1076003)(186003)(38100700002)(52116002)(6506007)(6512007)(4326008)(8676002)(66476007)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pskGc2e3aVjh3vh32ivuabDP6ZjrJKnhwxOX0GNW+lJBD3hqRLaNV6A4v15h?=
 =?us-ascii?Q?S0G0GcXrqr1Gl4LEhjtWnynLHcX6SaHjl/tm9P80qjuJvM3mbqS0HhqEgJXU?=
 =?us-ascii?Q?HiOx8R0HPyUizc6eqRx6+kD8nDrl8U9SdJRQ8rXnolXkDYrlPjSd1Q4jeMXJ?=
 =?us-ascii?Q?WF3hKxRv0RLG8oURu88MZy84CMN5ygjLFi/LQLMZyNVaf8IUs+yV9b3Tf34j?=
 =?us-ascii?Q?OFpA7aXnH+jJFoaEQc/ub0OLn1aI46KiFkS6plcuaWyPRONuMl5R+ybzJsvB?=
 =?us-ascii?Q?YJRJMWeemHlG3y+8TIklSTAqX2w2nijITr1vW8SO6otLH3r/gq7dxoWDNmTi?=
 =?us-ascii?Q?UTUoMfB7pLNFUAOcF9YQyx4SFpkVzNjfFW8Y29Z5w+qXzAoKoa/gR4UEfhcK?=
 =?us-ascii?Q?/EzpbESXn30maOCYZq5lggKC5eBA0MRnEMzmvA0utsVhMrMZ6CDEgy5IWLmO?=
 =?us-ascii?Q?ua2p23djkTpvM86Y9lA0b9TvM9+gQVEhJ2hw+h2SNqyGQIYYkIos31c+PYJZ?=
 =?us-ascii?Q?m1HM6VbDhPAJuA7HSWJjFj/NH7sJTilPhmhmXTaDAcgtPjB/vb8DnMir0rMO?=
 =?us-ascii?Q?el45qTiu7Y3Q+2a/Og1KfHEJ+VkZQ+jeeii4B0lcFcPqtU9St2IsJ84zshvc?=
 =?us-ascii?Q?v4S0GjYPfWbelYmK6l/XDSZZQP/BKD1Fcc2XuDOjzLx/vL3g20O2OSEWQXfb?=
 =?us-ascii?Q?Nmi8gRnxg6n+ctMleHEZOCQVofzGwVD2Lp5MRbpBvyEOuo1M/gCvaplBOLtq?=
 =?us-ascii?Q?9TOltcXdga7LeIhwqpv3h+U2/sLRqrMETQfj/bVihHfttNPZc4ZUx4M86ImX?=
 =?us-ascii?Q?E7PGTKvc69b4peHNdBhDSv8tOj00ags+hpKbsrHTSGRexW3D15SzYiIrB2L/?=
 =?us-ascii?Q?Pt6HkmoejsSHWOsD9jBuhVN/a5/TKTR3LX4nfQPBPEOEs4RZIHwHe3TcRKs6?=
 =?us-ascii?Q?54ZC6xcOD5rUcvtknKfb0e2X/DrpYt3Hn4md9s0Pe/nKYIMGBHS2N+ujZLMc?=
 =?us-ascii?Q?iU+jY/1uh0GH8QTlfxTgjI4IveCQVR7Ow7fVr1iW1K+0koknc/I9UYa1VV+W?=
 =?us-ascii?Q?uESg4tv/Tg1/4XFnDRML5UIrarQ3TudhCI6CMtm3IpOUhkIAuvR98w7CMyFZ?=
 =?us-ascii?Q?V7X8hRDdJu7zNck9JEfPA5C2ixnM8MjgiYee63ibQMmZhUyy4Uqz57nBW+QE?=
 =?us-ascii?Q?1BzAnR5gd3Mazw1iUv83okEDmjRQNnl5njPvAlDvC3R2OmuHOlSj5tHxwH7r?=
 =?us-ascii?Q?ujzNVKiCdS4vfPP8P5hbwqmIzbiIRP0K+mUoB4mLf0l9vHFke+c8BoVjHdoq?=
 =?us-ascii?Q?0qKt1NFLMLZNDi0ifaocwmfyQrrN/QEMsMWCy8vWWDNoX13mmG85T1sO2zcC?=
 =?us-ascii?Q?3v3KTCQzvVfy/XtEKfv6kAYL44KpJu0IysmnscueYEYosgS9TlAUHGL73h0u?=
 =?us-ascii?Q?Gq4tN4YeRNVO3ArwNTbMZ331Hgm9RiWwIbpCMk7Isq3lX+dFHNMN2DwvHEPE?=
 =?us-ascii?Q?OdTrTN4RaYFmVz2mhEOntRnVsYPUwJB0IjogI6ysiBRIGg/Kc2rvDsFunQ?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d40a342d-8de3-4e25-20b8-08da034bf896
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:25.6708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2DjADIA22I6lktIwnCSMKF7BhWcb0aMETo+bRKKOexVg8MgrsHhQL+u7pFJD+vqTc0fLPz5QJbYDpH/C7pnSVQ1ddZIqLL/wPt4hGLiRcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1184
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

The PCI_DEVICE_ID_NETRONOME_NFP6000_VF is available for use and
should be used instead of the PCI_DEVICE_NFP6000VF. Meanwhile,
PCI_DEVICE_NFP6000VF PCI ID is removed for not being used.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
index 87f2268b16d6..694152016b25 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
@@ -36,9 +36,8 @@ struct nfp_net_vf {
 
 static const char nfp_net_driver_name[] = "nfp_netvf";
 
-#define PCI_DEVICE_NFP6000VF		0x6003
 static const struct pci_device_id nfp_netvf_pci_device_ids[] = {
-	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_NFP6000VF,
+	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000_VF,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0,
 	},
-- 
2.30.2

