Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6DD5BB2AB
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 21:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiIPTOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 15:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiIPTOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 15:14:06 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2131.outbound.protection.outlook.com [40.107.92.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0056B6D12;
        Fri, 16 Sep 2022 12:14:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJmTYMg9TLZz/IDwpHUL6QHt8PG4nax6eRp+fhJkWwDVafosSShV16ieHqf7G8aaVJJJ7HM4Nj+Df1ualVgj2BeVD1SZa239DsuIl6PhmmXD0TnhHhwhwq1zrsK1q9+/aJSb6Sgk+E94xyqsrtIVG3p/K/aOh1TFfRxI54Mdv3coW6l2IW9ycSnfwUPZae4rzq0O5cgMHASfHTk7rQWZi4QwdxBmxNoBl+NzJiziTBG9LyLfFkPxhhh6mBRrqQA2QGK6yt3g0f/bL6PfcR2AVAuLnS00RLhC6btEMDwhdWU20+/FlpsD/dL+7StRa4+ZRuLcBxqO54dt1Tu1d3LpXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xH/FiaOPFENc+GAD97kihRXe7kaIlIA39qEztYg7KQM=;
 b=BfJSl3oyPTjQUw0shZJqfJGweAyVMw0myEukTzmfyHK2QEweqAwXdIqvW2qPRc2hDVW1mTCYLufVXrxGWFBR2ZTspFvcXHqEIlyaxBL5hCcNhGd3vpWSjEvNHXFUW0+OzkslTIk0tCMZdlRDdeU6anO8WW+JGBtotKGKNVKRddRSPbSyavvj2zEfx34lClI6G+JKKGRJlKCkANCRknZG78fdiEjOzErr0osPsJF+scjLc/efr5t32yOwNTvHKV6oWEXD3IKGChzhDYKAqcz1sJatfpiTYj2tCtmKO4FHnDCw/h+B+2uvoXAqZQv9CEdweBNgYBpudwYbJjeVoziaaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xH/FiaOPFENc+GAD97kihRXe7kaIlIA39qEztYg7KQM=;
 b=OzvQGZbN1pz+qBQS16WMfTrV9ot4GgHubF9/EERgq+ve/x5WJzHjh0enwSNDH+dw+982mCKxDUE17/GySiug6ysxf9gN+yA6JYLQSglXKbukKkzS7u2OzFyUejCsjAQBO//dF89xx0wsbqqfcNY1yZUK8Xcsm0HG+MOLYciy0OM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4492.namprd10.prod.outlook.com
 (2603:10b6:806:11f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Fri, 16 Sep
 2022 19:14:00 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 19:14:00 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 0/2] clean up ocelot_reset() routine
Date:   Fri, 16 Sep 2022 12:13:47 -0700
Message-Id: <20220916191349.1659269-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: 9625227c-cff2-4d59-9646-08da98179c6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xVBQAern+bYaW/WQevHnSYxJH/Mto8ZtODjN9uLgsx04XjkZaQbcrjAPH3Jidb1cdaWGSOu8lg8S3nyFyewJ2SqYdAh7lzLmyITlb0Gfj6CW7/Bj/Cg3Xz9AnXjaePRTdexrzNcPcPt6+Dr1NsI1SVbAPfi+A9gHj5KiCuVy7+M9OmEkBgug8q+0KIGhILKzkBfzqnQ4vJViwSEsOeiJ46tQvNbTCMueqi65hEW7p9KiiwYs/+LkUcEdDmMorot0rf9XYLubxTaY7HId1D2qibylL1kLI2JlNnC4bjs7J5y/WwaHauGfOGymmVSOe9igJhIi5AZmD9BRD1obL3qyAFlexBsZfI7KPOjtnQm/SBVBKLSHhYCzEqy6k8LsJpOYkf5pwnBZsOsvZHalukSLDlrJiOMGsQq72TdmvV9ebeKEcKGww6VSMv5vSU9kzTjHtve8IMYqJZI8ydkSJx1sj4oe2INMXAN7ZpurJpCmooG+8KiMBgDm8+22/wV3iwfw1BYgqq3t/bJhOSUL117rhG19cPUi2593+SF21KgIgcsuvHEr0Ds6J9uUPxTm+sl7sSflgNyZHW1gjIrwAxOqPXhCL6VP4JOL7dO7Gg79ieSi5boW+YQn8zAJxpwGAlFF9E6RhnuViS61zv1iIuKAKQkLOeQErYQdNyaltf7TPzyWKyjhaMDPEG3gPSv1mpITUHYAk6/BcJpotCG+wMMOy/sSo4SzccpJplZnJr0IJI5mBNaJTjRUG84QgtFSyZgJG/eiYT3L8ptJqVHNrkFy9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39830400003)(396003)(376002)(136003)(346002)(451199015)(38350700002)(38100700002)(86362001)(36756003)(83380400001)(44832011)(4744005)(6512007)(26005)(2906002)(478600001)(41300700001)(186003)(6486002)(6506007)(2616005)(1076003)(6666004)(52116002)(4326008)(66556008)(316002)(54906003)(66946007)(5660300002)(8676002)(7416002)(8936002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BAMtj40vVYvzE6HoJeEqe9+TQrz7ogwH0BwGJD3wSFM08jnbRX1VvHlNH0eh?=
 =?us-ascii?Q?XFpu94z0EZ/eWnnW4VII1ONxWOY+86D5diZ0RpPHZ9JPTxjYaNpm86sadQD0?=
 =?us-ascii?Q?zOHC/+qtSlVrHTehXBkcPrxr2th+o/zoibK2ZBteLxOJ+O0lgPoxwMNxud7P?=
 =?us-ascii?Q?6NTVEaByaDYypChsw/ZJX6FIe8ZzUulXwC0mnT4wfdE9XT9w1LdpWcy//KkS?=
 =?us-ascii?Q?TeiFGKYtZM2PKgOk4wBeVMhmTJZjEsqEFLqQtpAh/SUYVqGvgKoI5Q1SOSez?=
 =?us-ascii?Q?VOhnnoEODwvF3/eHgaiMSfIFe5ugcrMWcxFvZwTrVA6AMHyGKYa1NLJB9MhF?=
 =?us-ascii?Q?IAiCupHHvHugyVzhynmVd6HWAedGFolAKFNJabimTdawFJrDR5WACyTz2X1e?=
 =?us-ascii?Q?OJRR28OOhAOrIMQQaqirRLPU/WTMN4haUjh3Xu+V9BuFVrE0Z4RSMbwhCnHB?=
 =?us-ascii?Q?dVmn0EH1HaNPASyL2hyYt+63GlStMM1LmBJBvCjtOYsumZ30noGBlCyT0B4p?=
 =?us-ascii?Q?m12iZOgQ5/kW7Pe12s4nnejrhnCU4Q9grdPqR9m1DloGykGjAFHFotDwygYD?=
 =?us-ascii?Q?j5Pgpc1YlqujllqINiAHkkiZPYBjaa994G14ln1fdMRqN0EVp4vLzreTas9g?=
 =?us-ascii?Q?+E0fIvzdNusrtAZdXbNYnKoRExgWgKSXr04kHEqwBiP13YbI+B54ix8y/nNp?=
 =?us-ascii?Q?0mIlSOUP32wxH7JQHaVacWg6wTMeDTwQXxfKi8kKExFcYjhPzJ0odOPCsMIx?=
 =?us-ascii?Q?1Qq5T3fu4VzwNkSKDJ6NQvXzXAFhdjCMB94PwbJx7WQ1zI9FID/VfHA8bnm2?=
 =?us-ascii?Q?lP4ci9CEyhzdyKIYhia+wCZlZM+aw5RAqoxAbZxb2Dwgr5y6otK8hsHL939S?=
 =?us-ascii?Q?aZn0Bz9M28brDJVIksV9Rr/RD5n0JoJNdH4SKYYhFuBIPCAeatwkmM9y+Lqa?=
 =?us-ascii?Q?JL/F8t80zAE5XV0ofBK4ORqjJo5vNJ1gVIF/SJAephyZOhYUse2zJDE4F9Gt?=
 =?us-ascii?Q?wFbIjvdcCCuhO6oBH5eW8MFL5lQDxdzYXEqfgJHmqDNjj8SPxgnsAt34QR+A?=
 =?us-ascii?Q?y2VC1Qk90lbkPW2g42uNPxsobKHPIx+sTI9azxE6YYdzr652nGGMo2QcTA6x?=
 =?us-ascii?Q?9dyGaiork5M7eT2dyT+26McDrDvpwmPG+jd/5to7pgrk4+PoXeipYSP+oyrS?=
 =?us-ascii?Q?NyG+reiW94GWAk3kkko1ibscyuJHhzS/uiJtt3o/iicofPK6d+SjgyfJEqRN?=
 =?us-ascii?Q?BNtEYocB2a/0LwREPKF8BxxGPZ5gzMyebLiKODv0NOB1m2zFuLVbjoZvcMGE?=
 =?us-ascii?Q?cn80LmRnTU1K2SgDBAdayjIOxgBynYlek7ocFmt07s6E35D4AuBgBTSwBvml?=
 =?us-ascii?Q?1wMsDhQJYEt/5lP0RcvZ6wL53KF04sKEqpe7h/Ln9LqV+y5IV9Puzkh1gTbs?=
 =?us-ascii?Q?UFUU6m7MWYEse/Q5YSCoYgIRAFn+Aa6MPBBBFnueX9Jv1Lh/E6jiVIE/zh8L?=
 =?us-ascii?Q?CVpyZcWiMiKzr0pMRobJfeUEf8ThAftBoobnNWk2TiTIkoMCrz29vrtdEQmR?=
 =?us-ascii?Q?8zcXuZq0ck++2Cr3rcTJjMPEOB6dTOvc3SmsxCx+4mBDAmBBCTW0xSlgfbhA?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9625227c-cff2-4d59-9646-08da98179c6d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 19:14:00.4631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ofDZZG79V9d+LpfevYLBxTHwuBzR3rlYDrzTiRUePBs/nYsQnSPRvUzmUA5nBf1npcgM9qxm3wtMQ5+00vWv4bcPwebQMgcTWyiWKPIjmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4492
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_reset() will soon be exported to a common library to be used by
the ocelot_ext system. This will make error values from regmap calls
possible, so they must be checked. Additionally, readx_poll_timeout()
can be substituted for the custom loop, as a simple cleanup.

I don't have hardware to verify this set directly, but there shouldn't
be any functional changes.

Colin Foster (2):
  net: mscc: ocelot: utilize readx_poll_timeout() for chip reset
  net: mscc: ocelot: check return values of writes during reset

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 48 ++++++++++++++++------
 1 file changed, 35 insertions(+), 13 deletions(-)

-- 
2.25.1

