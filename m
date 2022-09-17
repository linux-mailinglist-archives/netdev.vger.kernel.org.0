Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C4C5BB9CB
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 19:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiIQRvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 13:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIQRvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 13:51:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2136.outbound.protection.outlook.com [40.107.244.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2506527CC9;
        Sat, 17 Sep 2022 10:51:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7X5mzs9Whna/oIF/DkAkdeiBwXEkZdQCEq/s6mmjmjsrh9ccKeM9NrYTaiy2Qw+4GGc38ltlIfU80OsLM5UoTQfmaE14aYv9OO41UKWPAYzfh7TMgtdDgdxb86/uI5x/NtI4knq8eexM+K1llIC5DvVBp5tbtBelIty+qrLNuDWwlRS8qVYcCn/3ylXk6qyhhtH0eljWGaqRaNUPsUeJFyIN8BYb1QaVgkBnmHXWvMsDP23nPiVO4WwWSneRnSfgOO2EEEYLjaaSAHNBZ+M3mYL/CeBpd8Ra7x3FVyOZwqhhMCmOVwdOuwJJruHCzTTUmkL2gDWP8XxMSi9JR0TYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLnXy1snSQcnSi8vxiR/A8j7yP0N54nPVaYfN7HRKCc=;
 b=ZPy8CjMdvmI5PI5QkWkp1c1PIocaAPsyhCZhPNm5LbNYC2CXo/djKlQ1e22xwlYtd//wq0gnuVG8MBhNw1UR2IT6mioYoA9rDLWTDpQ8qOd8uKSCEu1bpMfXONmcuH9cMEjeGBBZM8gPQPs5b7jsfR8iAzbNUo27MrTTIakaoCS5oNF2srCtITZS3crlcQpNj1u9Gy/lobL5OKpz5MWxgW3w39pBuKwtPb565dj7L70DwxZNjt4CxkcicgL/KFjP+yQiRw94q6JoTC5KsdZenNT5CZ9Pl+TyiVDaec3/UOxMprlzQE+qM4oJHTXCMh+R7O18GwF2qaeZYShDGgDBmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLnXy1snSQcnSi8vxiR/A8j7yP0N54nPVaYfN7HRKCc=;
 b=xhO5E3Ofkw5QvrDS+ijWEOrK3PVDzT/AOtWOf1W/0tZO2EnkhhNKERWq0fYeLtLYQ9+EsztOTSPAue82tkotQw4cUgZ5/Oj/BhiYMALkqPN/QQcZaeFltmd7DUVW5inkcdL7T4HRQTIJ/a9PUSoNEtrZHb01JUmNBWyB3wo13h0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4523.namprd10.prod.outlook.com
 (2603:10b6:806:113::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Sat, 17 Sep
 2022 17:51:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5632.018; Sat, 17 Sep 2022
 17:51:43 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 2/2] net: mscc: ocelot: check return values of writes during reset
Date:   Sat, 17 Sep 2022 10:51:27 -0700
Message-Id: <20220917175127.161504-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220917175127.161504-1-colin.foster@in-advantage.com>
References: <20220917175127.161504-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0148.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4523:EE_
X-MS-Office365-Filtering-Correlation-Id: b5213f95-1d4e-4830-7eaf-08da98d547d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kI2ppEoQpZ1Mmz/Tw7NKTbYVj4rGKyRddMs87ykyGYP93CWqIsU4rMIkbQaP3+qI4fuCwGOdSgn486q4TEGbE/x/NNIGtJCYATAffTQe9n1eM8zCE4Hr8j5owJM5Vq14hjQdR1wKlMsGlt2hCzmtemUDwlJQkD9etBYQj2bBNgdK/+ZieSAcM3wHU7i5nkqOuigaE/kiWQLtMVjw+IAQ4CXGG36Hc4ehYLpeqYhlIeyuy94qMd7Ya7wB5PWqJ7RAWUt4RRWMvDD2U/c7XuCSxnq7WH/c4wwgSIdcR9UA8+za1S91Vb8GbtilwW5VoUTHDet/0O184vPvQPjYqr6zxc1CLmMnH/HdhH8TPTCibC3+7koueO9xE+Wt3wVCfcwKTPMLoParqJX7jC8WvBsSiGK0nXhn7ujeotYGVtoKW6NZb46TImyLvbitlzICNJjiDX2by21re6o1TybOAUKqFdA5ig+cReFZfZkKV8X83j+dbkx6Nc4d//kKQwut9lXBts6JjRijP+u44fDj+bCyOaYyAacz56glpfCI6/GZyM0kJShLkdS6ckXDGZsDZS8Bl4WaPH5lVaoMXtFLZffft2LeYGhr1H4Pd07HwNfJ6e1FRbskcMJPnw/wHRiL91CQ8aZF9jwu7kiXHUOqJf1/KFUgknsqFFORoCPEGpl8tuWUODVgWLmy2jeIaHzit8bnjL0bnNrZHbivlAD1Fzwx2GV8W0RK8ooiVfEq/FXxr7w25j99yyXxZJToQy5sjaML0lz4iEqjyvCMxhfY62/Og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39830400003)(366004)(376002)(346002)(396003)(451199015)(36756003)(5660300002)(8936002)(2616005)(7416002)(38350700002)(66556008)(66946007)(38100700002)(8676002)(66476007)(86362001)(44832011)(2906002)(4326008)(54906003)(478600001)(6486002)(83380400001)(1076003)(186003)(52116002)(316002)(6506007)(41300700001)(6666004)(26005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bh1yBHA2BizGjrE7oa84Xllc3TZmYL7BF/9HyHBtdt3fEUJJzpgpojHfBBEW?=
 =?us-ascii?Q?0kfuadRAa37/YzisWzqGeSHG0V5eYzPKaOo6hYpdXCel4cUtbm6XQvg6Wzzw?=
 =?us-ascii?Q?ivqCJiBIDJEGIgkjxAi/G4DuBFnTH6O2eJzR73ukIX1tsrjrYypCoMRP36Ew?=
 =?us-ascii?Q?H2LFnY5zKgw941qVnP5Inc6/gMj8cmVB+sFHUc7VXtKykMY6niZ11S133LnM?=
 =?us-ascii?Q?cHC1bdAe9G8o1Fj1l2Ehs9zHGlFTv3xNOLJhhNOQv4e0GLx8rf39gT1LWNt5?=
 =?us-ascii?Q?v46SXHsApHUaW8JPl4uxHxPp9T1a5eIagviPzS1nSxpQKedVONg8+xHK8SUn?=
 =?us-ascii?Q?EVN3+GwErJti7JXOs3q5M9bJc8hjfZwPcpOSj7risogRwTKqu7oPLh50FVAq?=
 =?us-ascii?Q?RX+IseHUR02JUlptUo1hqRWv7TqbPVC3iAwQcLatiZlRDQalytUNKKGGBmdR?=
 =?us-ascii?Q?Jd5r2XRsL2bGywHTJPB3SJL+D8ogyaBs7Qq1nn5IrWhiD6h/NsVknu711cqS?=
 =?us-ascii?Q?Wx+FasKOyu9KvxFqUjjQd5NxjDWVbL1CQ/oVagfIH9vOauV56SZ9grWyO6dH?=
 =?us-ascii?Q?eHPKsM/x87vdKNhQKixwLb4z0wPDFZxp98+gfSVTdCUKjsJFe1IFFuftHDo/?=
 =?us-ascii?Q?tTj1cllGkqfCDBKuhwL+CrH5I6HnbxgVvCjhZj9421Y/c4QwmfUBeLOYe60i?=
 =?us-ascii?Q?Z/qUQ9XVfSNggLBp6Z20AOYMXlRFvlV0Zt/ijtZWuTBh6WJtwSYazgM7uZU+?=
 =?us-ascii?Q?r4ThCwk1HyvfMbVOBYDHNxnLs2rCtbZDUgRx4AxlmYDighfsOa+hGdCPx7WP?=
 =?us-ascii?Q?mXmk8fToUnNfVuAAPM7ByKRX2qm/mk3hjwv67L9i6PPRyV50364L1ocvLDK1?=
 =?us-ascii?Q?DpLCz/gofX9QbMex8WbmHo8TsZVwEjR36hH8xLxqqy9qPVgXfrN7ZK0szgMB?=
 =?us-ascii?Q?X8dVozdGrgDwwUqWI9Ic9kSe/yZx4WialsFb5lewEoS77RYzvOFED5dF3JlH?=
 =?us-ascii?Q?AGPq0PWzIDVHMC/b9IKQyhFTY7Ezf66jcetGhy2toQ8yB9wcmEUANki2zuEH?=
 =?us-ascii?Q?y2YyKf3jmRqOG5KTkbIlGceEObrFM2C0P/OZdwUvylSDHeLWGJtf1kXcHcLs?=
 =?us-ascii?Q?jb2uVTLkOKGrQMuZVRn3+C8sWfgyiZOlJs2WKkY2QklSapgcToNIA5s9ZmKi?=
 =?us-ascii?Q?G4D0mnFAduMwU1C6x2OGT/HBHHxmoqlUk2SJr6SGkBA/4jwcdtI7NlLIsfhc?=
 =?us-ascii?Q?D3PaaeL2VNkIeMA4JLSuT71pb11LLux9g9GjNIGj5hQZRrNLgrWd+uHIKux8?=
 =?us-ascii?Q?F+EPB8iXhld85BgUhWEwOSIUTFDCVG+9fUpzbPon6mK2t78GlRjx0agN9ON4?=
 =?us-ascii?Q?J7VvkMEkn3hDG0S7cTFUs8KmyTETI5BB0hV5NaZuexWk6EJy2aVbnRZXFbjQ?=
 =?us-ascii?Q?R0gZqjKdsnGT7UtSzhbLiIXkY7jFSAkBdvF/mEkegBgVCQPsZ4LHEfiXQKef?=
 =?us-ascii?Q?Hx8sLFtis8bXQSWfzyK745N0jzJAW/fdgcZgzBafE0J5ETSucFh2iCC1Fc+z?=
 =?us-ascii?Q?vsrhSzYgLda7/V+KhVWhytdJBJ22l5ob8Vw2SujHeV9mh482WPxfUaYP8CcP?=
 =?us-ascii?Q?XejkyaugU24ql05rfRXqkts=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5213f95-1d4e-4830-7eaf-08da98d547d2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2022 17:51:42.8810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmoVvVGriPNoiHkC9ji3b70WtIf3InoOF+a7DySpsPhuFm9Qk79Vk+FqbF+TQPWnGUFp1swwhpmMnoNCU95tL/s2w1nRusAmf7Pz/QxXuIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4523
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_reset() function utilizes regmap_field_write() but wasn't
checking return values. While this won't cause issues for the current MMIO
regmaps, it could be an issue for externally controlled interfaces.

Add checks for these return values.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2:
    Change "err = ...; return err" to just "return ..."

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 3fb9183c1159..6f22aea08a64 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -211,8 +211,13 @@ static int ocelot_reset(struct ocelot *ocelot)
 	int err;
 	u32 val;
 
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
+	if (err)
+		return err;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
 
 	/* MEM_INIT is a self-clearing bit. Wait for it to be cleared (should be
 	 * 100us) before enabling the switch core.
@@ -222,10 +227,11 @@ static int ocelot_reset(struct ocelot *ocelot)
 	if (err)
 		return err;
 
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
 
-	return 0;
+	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
 }
 
 /* Watermark encode
-- 
2.25.1

