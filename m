Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F09A40FCC5
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhIQPlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:41:24 -0400
Received: from mail-bn7nam10on2091.outbound.protection.outlook.com ([40.107.92.91]:34017
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241725AbhIQPlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 11:41:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0pE/md8rIsVbC9R3k0x6CSamyM2SVf0WQ6ZVAku76E6uJ6pyUO7ToQ01RYnWy8XXxvBQo4/2lAWjeRn4ephNB4Gme7tshEyuFLCfL4HvKsF/cdILrZY9IXjTOuWSUT/LCw/EO3htwqOny6yKt9fby1D1UQxvWEjRiSYRuYgMziJyu/wMz+6+qN0Bt8nYuFczd+yneUcwpqhTu4PXfxq7jgPiCznpMjFrZDk3PmDJBxlfPkVIf3cNSL+Cayo+jODory5pDNj4Jc94sBqfGebK2jXF94xnKwaRIiMbIiTK9lUNzxu6tlhrbar+b+nweGctLS87X7tJ7kFNpLytYmITg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=80NNPZL5JRoBFFfFiENsMWq6GgE+IzrrUZ7Zz0sQ+SU=;
 b=d4xgu44l6+eb0U9kcJLBjWL4KnBtXFumyBqOm//1hQd5FY4FP3b9+/JtuhpgTlmvkj2fcmWGh5liwazxaWTq1M4edxJPYjz0Agnd6hMdPZYh4dQSVwRp9sMaHM1UzKNADnw6W8B+g7MalCMYNjrdBUFpZmil5vji/1loi+mjlN9q0HdLJom2zMZXKNhpvff6Qwj6Nlm3rzDieFaKEzhK44AKBA27OeXRJdhthk7HZjq4YvDk8tR6zuQj5BNGzdl5L6PelThlt9zXcz4WQTKFVyJJh9VAloUOxKFasZ7iaJciMg0Jw2X68qtgzHiEEGTz3SpOcvYBevLwuAn5pZAT+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80NNPZL5JRoBFFfFiENsMWq6GgE+IzrrUZ7Zz0sQ+SU=;
 b=dFrx+XHraZHAp6tajtQCpNsqrcjk8WGyRfAdiHN02YTOIA7E4P5BKlnsd238sVQHTXbP/SfDSRU7NkaUU1PxS9YvkNfkPFOwrRXOA0FaOT6ptzAkPZs89k64UGGo1w2BRPzidpagTqvqE3UzMu0eJ829zx+NTYUNfdsKKvtXxWU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2221.namprd10.prod.outlook.com
 (2603:10b6:301:2c::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 15:39:19 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93%7]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 15:39:19 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 net 1/2] net: mscc: ocelot: remove buggy and useless write to ANA_PFC_PFC_CFG
Date:   Fri, 17 Sep 2021 08:39:04 -0700
Message-Id: <20210917153905.1173010-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210917153905.1173010-1-colin.foster@in-advantage.com>
References: <20210917153905.1173010-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by BYAPR02CA0055.namprd02.prod.outlook.com (2603:10b6:a03:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 15:39:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d099f3b-4e59-4c1d-473f-08d979f15059
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2221:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB22216A72A88FEF1D0AD75E90A4DD9@MWHPR1001MB2221.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rGmXjK/Ek1LAjCVnUYg8r52wT/LFJ9b4Pv0/wrAlqYAjgSmpGoMopnEUbWznzUZDfYTa+h+DyD73SvUdqXG5uTPmUySVTJQVPKPFSE14pNQfNof3p9fMtI4gGkTnwn5gaqRytHsibC0kM17419oRJBfBHEjVteRe+/CRqJRNzfzG6A9PxzQ9j4UZsCb6gTaFY3KcB57DoNGqNMz2Z42Uc9DhrufKip/8uniV/XlTj7dVsw0TylElpLv/Q+mT380lN1fEU89+KziRhluP9jWjhCNWEN2c1QP0Kbq5oTwsbWqn397xlMLSkF9dwvUOeuUkM1gRy6hSdOLpwFamn4GXf5ncUTe2uz/jmescVPtc1iW30LNeoby9K4Tj+85SGVg44GIjowqiXcxvJsPyG9dMfSjW0V48m8qeOZx6lrE+kgUpzq2fsa4oCRx8yjIibS9Nvdtvepn5DbSiIBo19oz8bYvfMojAkICDlrmCrkxhizdi/IofQELHpUFDhMBPTJSb9hsmW3TLI/JiGs6Vbg/ObcxvvpJEj29HSf8z99F95P0b89ImQ9gswcFUm+lxDDLi4DbJpW+ikKk3yv5mXzZJc3nqV2BpYolkRV6kof5z+VQNGucOEOS4VEmViygqzQ4vT3hGmKXeqSJ1NDFBkpDNsYBbcOFhAuRRzAncIkNfyENmFBSoACQVyeg/6aIllhxEWkgx8KQmlhPHKdX6IBGuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(366004)(376002)(39830400003)(52116002)(6506007)(5660300002)(956004)(2616005)(1076003)(4326008)(186003)(478600001)(66556008)(66476007)(26005)(44832011)(38350700002)(38100700002)(6666004)(316002)(54906003)(8936002)(2906002)(6512007)(8676002)(86362001)(6486002)(83380400001)(66946007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xj3rKRhlxLpFH9Ycyf336LqCmktZskkZTY2Xxs/wIJjY232nSg0qrPGDjC7e?=
 =?us-ascii?Q?l8wEsJg1+sL17AxPJjFaL43IQEj9R9zA9prxRBRm4YKRcXtHYXDPZBHm94iM?=
 =?us-ascii?Q?jw5aMhBl1IrjsZ9Kzif+xU38b0xS5ITA2A0Y0p4aLdqMVrtZv66VL5OUcZnQ?=
 =?us-ascii?Q?Tw4RuqzgLwPzaoxprHZtGljHrhZkj3X9+0fywAZ+IkC/1R1BHRxMwkH+S8DB?=
 =?us-ascii?Q?NB70AHxoWvHVxAz5YlpmiKkYkfAdAb8r4OmrZP90dNm7UIU96cE9TkLTWf23?=
 =?us-ascii?Q?c9IjN67R+LLgaJPxiwQUAyH98YPfLWA3zaIlVTqlQDf03dzuHePhPXEeAFFv?=
 =?us-ascii?Q?ZInPWhhopPyhkoyDJZ37+zchLbM3FK3H5JYH4HeUfA3lzImYohmw2Iu709RQ?=
 =?us-ascii?Q?POU8JJZWSxG9/El6pyiK8inGuYoAejdCqRcpMnk8WW0CuZ3Zv/ilSY0r9qLA?=
 =?us-ascii?Q?Y/sr9DKi1weh5sjoB650nWxUJ2l9XSMLeQYkV/XnB2F6kd0hfQLRPnDSLnSZ?=
 =?us-ascii?Q?MeqpsqnVhbsdMjbz5NjaZTxKpotjF6TeeZE3XRm7/lu7o9rj2e7KxAMpGSos?=
 =?us-ascii?Q?4IZvQP13NWpsQ0r/ilO+n5zEj28amWICa5ConKP9XwGTneptaoVKZBJ+GbEE?=
 =?us-ascii?Q?MA91fIkr9AQJk1BjkcYd6Q4fyl0LpW7Ulr4ppMTuqTwvkExrjDAo5TY2Y/1u?=
 =?us-ascii?Q?125FpnYiUzhhnh8ORGl/uJ90jGjdP7Xv1+S8Mp1LQ3NDsXxa6+rp/jBnbym6?=
 =?us-ascii?Q?OsgDcoUPL7W6SZHV89U0DzwTH5uQThb2aLgHEISKTrcx97CI7tOVwUArmA0T?=
 =?us-ascii?Q?0zr1zbR1fwjLXyWWf17OBaKg3j3gp700KsWgZ4QvevFbQ/c5QVoSoDm+DGuf?=
 =?us-ascii?Q?WuqNLGzlYb3hZVUHaUr29XAlHPwkhpPfH8NU/A10TMjjKp8W+2tXPpJRFfYE?=
 =?us-ascii?Q?PPP7ORH/87Hkde1oUTFcZqlrDljm1lMCW1WN/1qt+83XHAsa7zxnVL496zhY?=
 =?us-ascii?Q?KLFimJwgpEJQDc1+b6uDPxH2gHapOynK9SzG2ACGRTbnDAgANcsXMEl2YFwb?=
 =?us-ascii?Q?VG6gjSNNb2Ep413zhyQUdhQYyvxcq/ipVSNehgxPPhJjPP3li1975c717rO0?=
 =?us-ascii?Q?KerWdmhS5AOPiDcHj537qmle2JaQM9aPUCN0t4R0Zp6zMRJ9nWHtwHIHBXJF?=
 =?us-ascii?Q?U6yVXXW2YDVAMbaXvlxt+PxqCO+M9DsqHjlMUBleg1P4MqUA9Ey4P+0quve7?=
 =?us-ascii?Q?wUirtg3M7hFcMR03qFy9m2MH7tc6l0/t7eDn0XiWGz6DryWypDFMSDHqo4BO?=
 =?us-ascii?Q?xugfF01YGUmx3nOFn5Sqjkub?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d099f3b-4e59-4c1d-473f-08d979f15059
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 15:39:19.5321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ykWj88JUDavyJpML0V7wNheyBRURlEvlOsLGgBTnAeov4HiTGaAb3sctkFfoLxHwDXYeHkcbiUNJb5Eixoy75mbmVR2bo60OcRCLwFOIeYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A useless write to ANA_PFC_PFC_CFG was left in while refactoring ocelot to
phylink. Since priority flow control is disabled, writing the speed has no
effect.

Further, it was using ethtool.h SPEED_ instead of OCELOT_SPEED_ macros,
which are incorrectly offset for GENMASK.

Lastly, for priority flow control to properly function, some scenarios
would rely on the rate adaptation from the PCS while the MAC speed would
be fixed. So it isn't used, and even if it was, neither "speed" nor
"mac_speed" are necessarily the correct values to be used.

Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c581b955efb3..08be0440af28 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -569,10 +569,6 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
 			   DEV_CLOCK_CFG);
 
-	/* No PFC */
-	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(speed),
-			 ANA_PFC_PFC_CFG, port);
-
 	/* Core: Enable port for frame transfer */
 	ocelot_fields_write(ocelot, port,
 			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
-- 
2.25.1

