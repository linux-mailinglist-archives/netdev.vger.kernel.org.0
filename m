Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A596B46E362
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 08:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhLIHn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 02:43:58 -0500
Received: from mail-mw2nam08on2091.outbound.protection.outlook.com ([40.107.101.91]:31213
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229618AbhLIHn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 02:43:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYHexIlocty8JYngisQTXaxfi+5awWC5hWL7wDW25CnmMSZNiT1XL2EeKYNoI5CAmeix05PI3bUEfdtYlzpwHBDez+gkvnEPNztJLkrCAT6odB5368H5w0tKPS2pubqrVfU8tnuaOwdKzr8LUMfV1yFyiw4EkySMWxF+4rXmrIRPMXdyiQ3L20FxziCR1m1mFUFSZVXvHAhzQYQHsHhQ997WOSPmsfWrtqQ6/3Cm2Ok1FtAF3PTCns23DHwYFoxwt14D8ZKraJeggUaTpw/xus/G/1C7KSp1UL4DelG5X6XvY04gcccg38RNhV+djYF0BPuDjQxWkhmhufeUblbJSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/EgepVNvy+OqlDOv1XYKTGHcizkpncJAAzwbNemrnc=;
 b=HCkghWtXFJl0SWjBi4f+MX3eHbT2EzTB4sx70jtW8Tm1/t5TMp1td0eiXejLrBBf1r4TygsOKR51pGxarpFuE+fTtKb7r6Al02Cofyyz0SP7wCRSsNSHsUjbJ3sb2S6k1oWJ4nKbNhCNxLPjwPiun0opLIST2WP0NtBwCVvHbrVDGTG+JhzWQivnRG7r6QzmHi2yhjhOWRSlhYqEOsP8zyZ2/COhnVxRxZ21kINrCmOT6HE2prsdZcrj58gknBqJjamIwsc3LaIPW3hPTMR0YStG5oZSNzzrgOFK9MNoF+ijQGtnt7CiwZcT/Wa5j9CpqzmiBZDuBdqP0WjXjS30Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/EgepVNvy+OqlDOv1XYKTGHcizkpncJAAzwbNemrnc=;
 b=b3JhAhHAqd4pVx4XzDROz+wNUPmSBAR741LrljVyg4ZsdwgLTOM4N5CasOGMsSd6AQx0Iw0U9VqVKwuew2tyZPy2YHnu6RQ0Xn6PNKOnGcoUzhjAtBtPoWoWs8CTNoESMeQsVrNcOamoywYu8U/G78rNhVxNGJVFAOKhWHR4Brg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by DM6PR10MB3707.namprd10.prod.outlook.com (2603:10b6:5:157::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 07:40:23 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::6576:2647:62d6:cfdd]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::6576:2647:62d6:cfdd%4]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 07:40:22 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 net-next] net: ocelot: fix missed include in the vsc7514_regs.h file
Date:   Wed,  8 Dec 2021 23:40:10 -0800
Message-Id: <20211209074010.1813010-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0257.namprd03.prod.outlook.com
 (2603:10b6:303:b4::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR03CA0257.namprd03.prod.outlook.com (2603:10b6:303:b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 9 Dec 2021 07:40:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d548b948-e1ae-49bc-b404-08d9bae7281b
X-MS-TrafficTypeDiagnostic: DM6PR10MB3707:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB370762A3075C2C4A3F474719A4709@DM6PR10MB3707.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:350;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XKvA7fHsD2bMnsoSmqLq4kbm9wriCeazOYlervhB2Ju80jMJO7E6N6EjNDlnjdlRfieqr2bz0t/WEg+xynT4tsy/VZ6hDKBFu2t5rV5S6NKVdmrjErQAXkglEWR6kE0gCv5YVKw7V3ghGpet/7gop9Jy18q1G8EkiSv68b1erBpbYciW8/JQphGDR8x26Rs9DgquPg7FFtmpEzrZ7PbAIuUAx5DtNmbZvmDmMjP/zHNHbUs+wJgNQZjaoDHtfaPcWXJyaa/nW1h3w9TW7YIRtX4+y1iJbNJA5Xs3MVRG1pz7+/A+Ggnw3PGiuwBMtsOo5AsVf8phoi438XjuCa/YAYPxY7MBHZAiJrOVvOLHW1KaJW57fpBhL/wPUx7/of5EcE7AkbnCLiPAA++BY5Tbm2y0yufV3K9lU81PoC9w+Tldpi4OdDbSEmILSRCEhKlIiXru80gNjuBYhkNZXEsKoXWFqNXDBhOtrESH6EptRIJfmSzjMSjGMXmdyTSeehcQzh8gMWe7AjCVcW+wkeHJsLyPin/sLiprf1E0N1GwFbhxtQFU3OdrX7zndzAPywmQaDKCwGOgD6RZL/NNJ/5RSGpWgiWQSM/N04YJmylJsDhhEYiQfnAbV6wgc2UuU7xTl7MKudqJgL4+6qOEmuw3wnkmeZIfUOEibtvQUZPfCGzZBVF5CEkjzFscUYsnOWB8BoCEBm7e+p9pU7CYPrFu9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(376002)(366004)(396003)(136003)(5660300002)(6666004)(6506007)(1076003)(44832011)(6512007)(4744005)(7416002)(38350700002)(4326008)(54906003)(316002)(186003)(508600001)(38100700002)(86362001)(8676002)(2906002)(66946007)(26005)(2616005)(6486002)(36756003)(52116002)(8936002)(66476007)(956004)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?86WSx+9SJprthXkOn7kHYNxIT/capi0JFKvC4h9HfRJGgZNAKzjO2OXO7pYD?=
 =?us-ascii?Q?S6U9F3SINssjD1vfI+bII7Ykmao+SXh0wW6MCjDA4pRTUTuZgfgWf7tJuY4C?=
 =?us-ascii?Q?p18zz30wv0Y4W7TTt6muPrgIKIN1rNu8r8DDI/gRDGssBzTpocffNvMH7oxo?=
 =?us-ascii?Q?tKCxC9ilDBuslk8Dhb08P2dHsnM6pa1J3W6qst+LbLOtbEKTRsUURpYYPVTc?=
 =?us-ascii?Q?Mrm9ApEt6vfBtnPFMXLod3C++vk3z5WZ+64U8bmmFa3pBs2e18EbBz+h+VNg?=
 =?us-ascii?Q?xqknkkrTDH6DnNEJaipG5kENDxlNVcsZWRDCvqL7bY+S8mE0FV5FLJE5eW32?=
 =?us-ascii?Q?914oohTy4INfFzARmCI/zS5Mom1H9RwDsHS2JG+Q2fdzxOEXmc9OVsat16k0?=
 =?us-ascii?Q?dIquGLzF6sv3YxnaCjMQ1picB333kpnzHNxi94rjrwSoW1IIKC9MWy2pS6UA?=
 =?us-ascii?Q?BJ1YZH6EuWc7/BnJIinJAgKYV+adi778levgzi7jbb8Emdxrk06EzrdINQpa?=
 =?us-ascii?Q?a3ccs5ARD8EKwLvNnL0+76vjN6VGa7EbCRuMZHCZZlQPDdmrpRJon0nwD9s0?=
 =?us-ascii?Q?ANOJtZyslUcLkCHHoTxo7lc0JR1ozRZVXycEyN2JJB4l/EhSzgVfJhsF1Hkz?=
 =?us-ascii?Q?34CbVP9OjMgT+CoFvcTXvoXANwNTZUIWJ4f0FXlvgTMnhZjm0+905cEU03Uv?=
 =?us-ascii?Q?J572HkJfBpCpkf2l/bFyTTjziCAWwoZWtcJsFwI37bCYLtxU9VRe+d7KWsGR?=
 =?us-ascii?Q?dS3yS7G8C0Ecz5MvfidaiAHwxni3eGjzNQwwBhxOTNgHFKGy/1ncS42jBnot?=
 =?us-ascii?Q?OnsM6eOXdHkoGOemMSj7nyTjknl4KZtUkTSy2jIJbxnWOjHshVWwAQBpAEQR?=
 =?us-ascii?Q?cil95ZftQEN0iL44YoucegzKTHkTB67YKUBWLspIRcoU3hgzKrW23kq27/JB?=
 =?us-ascii?Q?9Kk90SZhs/ZDO9sTMrrZxmu0yuXT65rIeCSV/b+c5M24yZh7WA9ANcl7gMK8?=
 =?us-ascii?Q?FHcvX6hsCblTss3be4cEmSQq9B8NGlh1FykqumxucgFeaXfFncXtqyyYZMb4?=
 =?us-ascii?Q?rCHudgmHvBIu1oM6hhQ/+G9m3RVhke98P1XILeu+h2BiaatENfLA1DsF35tW?=
 =?us-ascii?Q?37axSUw/wJwLZqCkgV+KT2psypq9VfEZ3kI0kO6x5jd1JazwKG8cYBCY64lP?=
 =?us-ascii?Q?21NYx064oKjtzsNy8vsRJ99uO/SoNh7XTTeZ+RonKkSwqPNZ7trNgk/VSWOj?=
 =?us-ascii?Q?T8na+7WZ7X+vAnAlxJF3SDO+mzJJcoUWMCdG0G9EJeWZBYGN+5iKiENqsZjy?=
 =?us-ascii?Q?DCoYkCPikm2GTcTuWJ2yLg3kBd6eaCHE8T610xF1rzvux67+JhsNtmlxRsPQ?=
 =?us-ascii?Q?GvckH63TJQYyee4yRCTCX73zLXuegbmrr/XQ2Qxuz63XyZhoypY1Xt/JRvnd?=
 =?us-ascii?Q?kCBWHFYcDJBi5bjvkX4B8omPsJDV8k1qJnh52SlbpPEih8wiRd4SMcyGDh2O?=
 =?us-ascii?Q?F6L4gjxwZQwNWpdsC+4vu/PKLKKN19/MAnEJvLxHB2AG3d3ZvI7Nm2OqTN+N?=
 =?us-ascii?Q?J3ZIAWVtE4CsWOkhxUfZ7BD+qrkpSjDDoQjeTAZ66W89Uz9k+/+hqcL08H9A?=
 =?us-ascii?Q?exiBeCWCN5dEyEOFbESUdu4FwRMYZUdbem1fcOKzNCyi67Lj7WqsFTLd2++U?=
 =?us-ascii?Q?86huJw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d548b948-e1ae-49bc-b404-08d9bae7281b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 07:40:22.7126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QVW7pL6RTRU8fWaKwIzZzOc43esx8S3jCI2eRf9nF0YBwEOI4NMooH1rPnmN5EN1VDzBd47AQKwLckppQZ5N0YxeaDMi7yiJb4XnF9xPeYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 32ecd22ba60b ("net: mscc: ocelot: split register definitions to a
separate file") left out an include for <soc/mscc/ocelot_vcap.h>. It was
missed because the only consumer was ocelot_vsc7514.h, which already
included ocelot_vcap.

Fixes: 32ecd22ba60b ("net: mscc: ocelot: split register definitions to a separate file")
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/soc/mscc/vsc7514_regs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index 98743e252012..ceee26c96959 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -8,6 +8,8 @@
 #ifndef VSC7514_REGS_H
 #define VSC7514_REGS_H
 
+#include <soc/mscc/ocelot_vcap.h>
+
 extern const u32 vsc7514_ana_regmap[];
 extern const u32 vsc7514_qs_regmap[];
 extern const u32 vsc7514_qsys_regmap[];
-- 
2.25.1

