Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE8249303A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344534AbiARVxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:53:20 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:23862 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343750AbiARVxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:53:19 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IBe3ok010515;
        Tue, 18 Jan 2022 16:53:02 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2059.outbound.protection.outlook.com [104.47.60.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnbdu0ryn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:53:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=St7aBMOGAqEN8NTZLaWZdg6gK4Pmjge1coW3LV0OO1lYU3cfgLmDOdZr4PqRpNn0Cg1FcB+0r46uCc686xhZvHg7r4Q5Bn8YEtLOUeocpZY0NX0SrC3hDYJ1gDcZfo3IEgP8aRCsx0cauoDTeqZ4zSE7xdNkWVhUEFF7O7n5G7AittmMIKSTvV3kpDq2EghU5W3fZqmhgMGI91z+PBz3kLXQHcai0n4E4Zurd4uOOETDPWKlHGVAymC0NwZS6jgsNp3C9z1EgertJPwu3ybIWHyzncbh8efykHeo3M5ob7LJO3ClXc8DHGBgz97xay+hWI22XGDQ4EWNzx2F7YbvKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIfE06cqrwLgknQOJtVmOLAEfjSKVK/3MZgW3oQu1LM=;
 b=RLE7XZRf4yrbbqONyyMp56huSFj8OWfXoUP+qHsbkYXsQp4VsUGkczSrB3ucy+8XEKNCrq1J0Y+rwYuOmKOr3NwBkfCKjauaqDvJtk5UeXNL18+U7jcd3fr76ewa/goyYih04VYNJilA7E8sfhwwA0OKmbgEku2nuV+eij4Qd0xnZ+34hn6y8j8R9XfM2e04nGpcPuClYTNPmoZ3DNfzYHlKAEdt08aXg4h0lYAsIrJCd4TQO8qOgN81dUEvWU8otMiR/IpYygAN0V3fy3tAhS93cK+8QlT7war9bTemsGsTJzlgzqIya4U48i6wCYbaTMN0TqoKO61pVlKWZ5GyYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIfE06cqrwLgknQOJtVmOLAEfjSKVK/3MZgW3oQu1LM=;
 b=Kc1fYb3ri0bcMHyE2QuN13VDF4JiJyS5MedoKelZov64SOzbMbK7K9zm//LqqwDkqQSteYKa5i7cMUjBwzjOj7m1YlbsZs8ku7FsDYt2LnTGd8gCEtVgnd2cMFLG7DI2BhHa1ALkbCog1V2VyJIWA3P6fizif6G+gZ0rLLXn3OY=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB9228.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 21:53:00 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:53:00 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net] net: phy: broadcom: hook up soft_reset for BCM54616S
Date:   Tue, 18 Jan 2022 15:52:43 -0600
Message-Id: <20220118215243.359473-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:303:b8::18) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1ac4caa-2666-474c-30bf-08d9dacce54b
X-MS-TrafficTypeDiagnostic: YT1PR01MB9228:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB9228D50924370AFF2D7E192EEC589@YT1PR01MB9228.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: THogW4BUCXe7V0dxyssoTO87W2Oz2X86VrfY1npDq93KNYFcoHeFG1drSei4XkriBig2BBuOVta4M9JaYEv7kDOSMuMPM1mG10I8h2NMOrZT0q9P5QhrfJsST+D+ZGNDGXXI/d+zDKuhWCeS3oj1a7E/l+tOxVa4oDHej0u7djMwOAEFJiHZOQiZmtmf08n4V/91BRpMnPSJ1hHEdwDCVhRr7MlkTPhA6L/OKC07axQHI+JmYYBt0Tg8btG8UuJVvXMmXN9UIDFqReKHpKOJ3roS3xAmVCkGHimAIbaVacfLU7QJXTRzOprCAojMkEzwugWJG/pkCSsO1SM0rnOhCvNy93Hl0C+flZWLwhcYwUz+jo82Ujx2+awgs0PO/aURKviJpxVnv1MNmVASfgsG+FGG2Ai0VzKXoIJqKHCPjQvDGSXgp1GoJm4NBAGaxHqUMghfEJD0MMoJL+4QBHpnd0jvyCGrvjZhajEFe2b9Tl4kC13u0FLREC5EEOFu+nj2vYCT0acKnJsm8PkVy06Gy2OTlHjWF8DixrnKBdVjRCGSBa6Ytd8KDSJT6u8ZQpW/zQ8x3n68UEQhiNZBE9zsDrkCya2nIC5xN6UMQGvJEmkERjjb8XQD2dcDxYeBHqXSseLffy9seGfxyOQyPsMU7HJjFcPkUAdusYY41ue+FBHrjwhkCoOHyNNlQUE+as81j/6ZuKlRIsAOXx2RIFhKrtqWbjHLw3YkHm61jL/fPOElBs7haCKt5w4hn91gOahlfSF3VWCLjLczrogNjo2GEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(86362001)(66476007)(36756003)(5660300002)(316002)(66556008)(66946007)(38100700002)(6916009)(38350700002)(2906002)(2616005)(6666004)(6512007)(6486002)(4326008)(44832011)(8936002)(1076003)(6506007)(508600001)(8676002)(186003)(52116002)(107886003)(52103002)(158003001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TgI9gbPCypcDfySr13UiWCGC2+QYtWJNZRvnbTOj/1Puj+FT4aDCAjUc6mMc?=
 =?us-ascii?Q?dQAo7XttgkkL5XFHVKS15cbWN6ue5u6+nWnMJa2aMwnWwjRHlfxLLHu0f0pv?=
 =?us-ascii?Q?DbZmNin+1jtRc1WtxGHRUrgICjIUNSWQWqdTRNz23ZZwzTQqvMRzlj0CLUEB?=
 =?us-ascii?Q?5L9/gFWbgokdHdrwviSipgh3lTxunj/8lD7+0FfIeWrbqClvG6HCzODld9Ju?=
 =?us-ascii?Q?IOkSgccdLr5HqspDIJ7hr3Ucx9+8IcqcTcMoRcijGrPpDi+WU74LyldyjZpK?=
 =?us-ascii?Q?F4sIyuArk/hMGVRyZa6MA/G9EGVflJr1BwA3wd/Vw778SOwujBFkWLoMBJdp?=
 =?us-ascii?Q?yzNZhz3/X5ev8DN4N/T33DQTRCCKsY9Uvm5PohGk1Q9bHyCZgQAz7YE4z49t?=
 =?us-ascii?Q?cPKGLysg0WgKaSm8R7xLuC8frFAa/aSvVGdyIDR6RVTOSGA6T7DHaKQwa0oe?=
 =?us-ascii?Q?GEVp0nrO924jQusm1B6K8P1SQd4Vuwkhf6YZfWjU+NZZCpeF687JXHr3nQMN?=
 =?us-ascii?Q?RNw6RPeoKRAxj1JxvYj6sg0N7pnnyiqCoRKSVMPtqpX4BrcY5kj50bjm0/iU?=
 =?us-ascii?Q?ZH2vzMTWI6BMJ8rkCgx6w12/Wa9CPoXATJLHQR5OF8sga3VOJr6oiu2klVwA?=
 =?us-ascii?Q?Mb+euo6W2j6qENk4gHZvSUwaQuo7FRjtEtUNJyffXGODHmnLmlNJdvT/HKT8?=
 =?us-ascii?Q?2t7ck7rI8ejxOwhYGz3CPfe2ytxd7z+fhTFBxOg6PAFK1R38whqolUivZn1K?=
 =?us-ascii?Q?0V4WRiKwnHZbhIMgbSuLfXJbYscozX11CM8pd2CuyWDZmbyZhAmfH3F6DQ9P?=
 =?us-ascii?Q?mniFJjeVjyTVXgPscrze6ROJ58MQ3NClBouKuBQpL79DSJRNuKwQwX8f1daP?=
 =?us-ascii?Q?A+oAlvBF5gURhmNn9YAWZW8PrcAVJ4M3Oj2SsNzfEqCw2gL8HBbUP6tyIpAu?=
 =?us-ascii?Q?P3waqE9GolTSvvP7P9Jm+89mXXusB0OXCQvS9ujCwfhJdvDBiYKlSuD6Om6x?=
 =?us-ascii?Q?p9429VIsbmZH+GYItzHjNuxDPlRntdfyjcRFlhri2awMfJ+4N2HaTvDP9NlR?=
 =?us-ascii?Q?DZuOkk2CNRvNbOdan99BPQd24KOrcoBtFFfgyCyXXxc6Q6tOvmjGNdyJKL9q?=
 =?us-ascii?Q?gLF7TrYDX/9fLNZd+C7TPnlEDjRBDiKMtM8K1PJtWrYo2G9utjr+Y8QacxBN?=
 =?us-ascii?Q?ZA26MMUMcBNjQyaNG+BPvDLITcf3zgkXjLDZ9gvlc/Tr2HoC0SVhUoeykQuF?=
 =?us-ascii?Q?UoORoNP91URZHTktqlV/EaQ5PBYh3oYYrm+/KMuA8zDTfjY/mJmk2LmB+ygq?=
 =?us-ascii?Q?M2stqgIkHctkD9/EIzrh7PYt/bAdplAQy/99sOGcZSCsaLg4bjIIylQjgyyA?=
 =?us-ascii?Q?UWXZMKVoZmO1o+ODwGs05tRkuQEMjRtv2+7EQTtK/V5UZqCCvJ1q9G2vqv8U?=
 =?us-ascii?Q?S85y45X/rJ+HCJ3+mVj/PGxcqY0plXwFP/GBbC2i3hLsyswnBkemt9/nJr2U?=
 =?us-ascii?Q?1hConW5pAzH1hNt8tEThYMEJr1EhvBDk27pMfHBybMoLJJE09ix4eME6Rv/d?=
 =?us-ascii?Q?oXJ1irxOIjHy0VVwxqIg1oHasmAvxaWlXOSr8gjW5n9wVi8BhfoYa+XBs7Hq?=
 =?us-ascii?Q?r6YhHqBoa35YBlpZyjRi+QF2vDrGYK3HshCvM63CzPFGDY7kRM0+R86DSY1L?=
 =?us-ascii?Q?LEvJjgQm89bIfqq+7rHr1lpPgQA=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ac4caa-2666-474c-30bf-08d9dacce54b
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:53:00.5823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEbpJmGjwiQSoi5n5Z8uaZV7oZjberOrgO/wlzft733wvZdRr8iUJHTfnwF8IPHRTwVl/4r5YdQTXvtmVLdSHLD+/OhMy6evtW6tWHnDlZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB9228
X-Proofpoint-ORIG-GUID: RX_WAxHd-ICzJhF_Azp64tWakGDd8I-H
X-Proofpoint-GUID: RX_WAxHd-ICzJhF_Azp64tWakGDd8I-H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_06,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1011 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A problem was encountered with the Bel-Fuse 1GBT-SFP05 SFP module (which
is a 1 Gbps copper module operating in SGMII mode with an internal
BCM54616S PHY device) using the Xilinx AXI Ethernet MAC core, where the
module would work properly on the initial insertion or boot of the
device, but after the device was rebooted, the link would either only
come up at 100 Mbps speeds or go up and down erratically.

I found no meaningful changes in the PHY configuration registers between
the working and non-working boots, but the status registers seemed to
have a lot of error indications set on the SERDES side of the device on
the non-working boot. I suspect the problem is that whatever happens on
the SGMII link when the device is rebooted and the FPGA logic gets
reloaded ends up putting the module's onboard PHY into a bad state.

Since commit 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
the genphy_soft_reset call is not made automatically by the PHY core
unless the callback is explicitly specified in the driver structure. For
most of these Broadcom devices, there is probably a hardware reset that
gets asserted to reset the PHY during boot, however for SFP modules
(where the BCM54616S is commonly found) no such reset line exists, so if
the board keeps the SFP cage powered up across a reboot, it will end up
with no reset occurring during reboots.

Hook up the genphy_soft_reset callback for BCM54616S to ensure that a
PHY reset is performed before the device is initialized. This appears to
fix the issue with erratic operation after a reboot with this SFP
module.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/broadcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index bb5104ae4610..3c683e0e40e9 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -854,6 +854,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM54616S",
 	/* PHY_GBIT_FEATURES */
+	.soft_reset     = genphy_soft_reset,
 	.config_init	= bcm54xx_config_init,
 	.config_aneg	= bcm54616s_config_aneg,
 	.config_intr	= bcm_phy_config_intr,
-- 
2.31.1

