Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B5631A428
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhBLSC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:02:26 -0500
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:1697
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231590AbhBLSCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:02:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJEWvJLcrDi4fmb2I+zeoDTWeuBM7BLS+CQGQHqL/0HRoqSMB0EVGrjYDUZnt+gaoQ0Q0bKti0EIRfcJPLVyaEu2jsCpZtbfaGCzs8GoEPnhVXC87lJ22zLaitpWMaYBrQ2nhq9WknaEtu2Od+o410rLD8q3baBhU2BjlspPVfi7Bt+UbJo0YS1976Hr5MOAZt8xnt99KXPWvHX4lWm/I7tHJuw1EN92XPtMThZ2/9l6uuQ66Iky+zOb2wAxtDnV0nl+v2VJJ6/P6h0qdXO5hnJJQCaTRBbPEIFvNbz6NUa+lyzo88HflXeLvvZgNhCiNcGTRUvc/MjEsQg9Wyvf3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdcj9sjByJulyGiDN0AdJ4wKQMhaXHMtTM6QLGMpsVg=;
 b=XceoEDIR59liZuFvU3wI8g53wiIhbfHnr+c8wuDAFjYyeYOGdKBf/Tr2iwCRvq7HowubO+zWF4BBK1hWbzNh3MYzdlh8ay/IXVt+GKI9ey6uOFcYvKcG11QE0gfFLlSRkj272Cu+kQpo5HdgZva2ZyIgjFXEffd35Z4wmqJNlhRNmLnYtEeyaG3PKZm3t9bsTw6M8f1V1SEyRvN55OQ2lfoN+WaiG3S69M/OAogNmcXSRqpT98GVYzVPuWgznmgy/1lhDU/yeOait6VQSd8benKIUhAQ/22hE5bnZark134donjhpRQjnKD/lOx4FdNqVMgPTVrmBBybckvIGCnbtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdcj9sjByJulyGiDN0AdJ4wKQMhaXHMtTM6QLGMpsVg=;
 b=Au3emJT9H7GU8dz4M230V0tBxAmRwl//w7khJrecccpzfFVZQ5A07qe6H1lwpIJ1z5ZjZ8WYBNCSNVyjHL7ZeLpjQ4Au6TswyJM4Ofy/6XNmKrOQOwRXEkLvhIjvfW8ADleTIVkbEoi+S/he3CDHg2oIE6o1dwMLdF7WlvWkrUs=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2495.namprd12.prod.outlook.com (2603:10b6:802:32::17)
 by SN1PR12MB2399.namprd12.prod.outlook.com (2603:10b6:802:2b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 18:00:47 +0000
Received: from SN1PR12MB2495.namprd12.prod.outlook.com
 ([fe80::319c:4e6a:99f1:e451]) by SN1PR12MB2495.namprd12.prod.outlook.com
 ([fe80::319c:4e6a:99f1:e451%3]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 18:00:47 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [PATCH 1/4] amd-xgbe: Reset the PHY rx data path when mailbox command timeout
Date:   Fri, 12 Feb 2021 23:30:07 +0530
Message-Id: <20210212180010.221129-2-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
References: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::31) To SN1PR12MB2495.namprd12.prod.outlook.com
 (2603:10b6:802:32::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR01CA0089.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 18:00:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: afefe9b9-511a-40a4-7d5c-08d8cf802008
X-MS-TrafficTypeDiagnostic: SN1PR12MB2399:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2399FA0BF4EFAB2D57FDCA849A8B9@SN1PR12MB2399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s2ahhaJVsypYDPv6Dc4d9NXLX5VaIrbYMSmTL5xYcFywahNBVGIW9i6lXj2WfB3zWmnhN7uUsxTQSruBrzLYzc4A704bvqqpt8lbFc416M0vyCAyDxM8ScZ+dpoZ5ch10e6w4zBrStjZDcyvFTwSlD1s1YvtJejix1ch1/JtLneRe3aiUupH01iP6ZcpoGZ19xF6wmQLvKhSOU2jTgiHThY9AwI4pTqkJiiaLK/ti+lX9Pz6gu+Xu34G2prTVqeiP35aNCdgB9fRLMDQWnpMUAOAmR4X11flwdmuaxcPBpfmcU83E+wAn9zN+5g8wvxrOnAWJYfLbpdpG/8ze/PTfsHu1CGwG8uOZiUpiFwM13elE2qpYGKGVlOBtwD8a6LBUlWP5mc9zZKaxt0sh9kW4c9wBQONONeCkbn8+iX4kxhQcytw1n3a+WXxNuSNXTqhpTZnlbomrxWTKa50V8sZpBgVtYxpuEiQAJsnQ3HSIzGPLCpwSwEe4dGbtDzpJmNxGkkUmRjmj5vouUiXAZTrFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2495.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(66476007)(66556008)(66946007)(956004)(2906002)(6486002)(36756003)(54906003)(52116002)(4326008)(2616005)(186003)(316002)(16526019)(110136005)(6666004)(26005)(86362001)(83380400001)(15650500001)(7696005)(5660300002)(1076003)(8936002)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qbY0nVmHi7u6l5z9RaJ9s0k/JgeHfIT1GMdmSBXkIM9cWTeRvy9LOLBYyId9?=
 =?us-ascii?Q?ai3WQnkMW4gB3iGknDUpy9zuoG0AR9P/ktv22JsawobCEHuE0NiRj+wS9fyt?=
 =?us-ascii?Q?PbnIkiRQNsFa03dwF5WEG23e9404Q47q70FPZeIQN2ql8qt2h63nDd5/ZaF+?=
 =?us-ascii?Q?z00rqWj1mCEv8pqoyJXutDfVekxzwgeQXxROH2nGBLdNhQfx7C1nO6SzlJLi?=
 =?us-ascii?Q?25J2TQXZPHdEKFFS7w5xSt9+sovYV9PENQ5xaPggh/s9wu8CQ5tvOLG1BEW8?=
 =?us-ascii?Q?l/d9nDWPDgLiNI72RNoWaw2oO+tgfiNKU7phMIpsplzqKZakdki/2UmIY1xh?=
 =?us-ascii?Q?kOmdcl8yd+fH5B2WmZ4kA60g738I9oc60NlLq80vBcAHozaWqRyS5EGaWRcW?=
 =?us-ascii?Q?Q+YjRo8Zhb3rucBpkAWwW2TKPa0Xs2EuRmzuQbwgJdIxZ9oUUkAY5eG5Koyi?=
 =?us-ascii?Q?2IntGtiSSHIj0EWLRi4mWHLFdyqWA/zSHGgYIRcD57XgydMWKD/RgmG/5M0q?=
 =?us-ascii?Q?FZYN7YbQS2yPyYH6oX8df3FB+HeB65tNyGdtgRSfpXHbvs/p2nQigRR6aMEo?=
 =?us-ascii?Q?FgWJfCuhVPXM2U2L8mYdHVPUNVr01m3YmCy+NxoZn+NrYTt8cooQDib+W81v?=
 =?us-ascii?Q?TfmYmCG8BhhE+KrbfOMf0cJssod+BESLNXK45fnwNW44iNM0Ef0CfVVdMHJ8?=
 =?us-ascii?Q?Xjxk2axK96+DCHHGGSShzP5QVid+HnpXuQb0PYWaaDvmm6c306EMRmApjh3I?=
 =?us-ascii?Q?37F2k5QtdJXJRPrnaognUZDSuMjEEhip5rcI4xTWca140/oSS8r37fwYxEXm?=
 =?us-ascii?Q?sTDqlj3VO2UTiJA/LzX0T4ChgSZHp23EhppvAmak9dRVznVSfEKGyez+X1HT?=
 =?us-ascii?Q?mFi6VWaHf7ISt7yi6z2aBw6rT3LPXh9c4y8e4QnkuwRx9n4CqLYQdiMQ+UG2?=
 =?us-ascii?Q?u4CqdRVZIvX4CrXKdTKUCt7lJB/5FiN23k/NG17bvBVifbxi0CW54fWkKB/J?=
 =?us-ascii?Q?9bs5ZgeA5+cxGGhtAOl9a+Ou/EATokedIc7bYBCYWwDtYk34HWhYVW8FVc0L?=
 =?us-ascii?Q?rY9nHBRiV45D2jducJiyYe4Ijg1CDpcWYHYNqFLXWkkii/3IYlIVJw7ThCh0?=
 =?us-ascii?Q?iI57+PFPxac/jl4rYm5h7DkZbF6DNiJa1Jilv5vneFG9z2x8R5L9fIa5yJVB?=
 =?us-ascii?Q?fa/q212wUDLxdwHinRm8tg7PJM1pte4DF3RYFU6LNFF76ekchzVfpJCg6TNW?=
 =?us-ascii?Q?ZAujYhWILyMtQmSWTbl3E9mt/rKMIciFk1whbOdmlRiFPMVA1F/PnAfrt5Bd?=
 =?us-ascii?Q?nPe7Dh0QlxE8JAnZM5Z2iv/jvMQurOyfeb+cCnaCxdt9IA=3D=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afefe9b9-511a-40a4-7d5c-08d8cf802008
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2495.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 18:00:47.4535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0WpI3zISBF7W7SiFDsmnnwSpBp9B0yhmNufVLXEO7Mo+QxRE7NUbcdA0njUV4l520MHLXVWU2aD0BjkzAZahWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes mailbox commands timeout when the RX data path becomes
unresponsive. This prevents the submission of new mailbox commands to DXIO.
This patch identifies the timeout and resets the RX data path so that the
next message can be submitted properly.

Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-common.h | 13 +++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 25 ++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index b40d4377cc71..318817450fbd 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
@@ -1279,10 +1279,18 @@
 #define MDIO_PMA_10GBR_FECCTRL		0x00ab
 #endif
 
+#ifndef MDIO_PMA_RX_CTRL1
+#define MDIO_PMA_RX_CTRL1		0x8051
+#endif
+
 #ifndef MDIO_PCS_DIG_CTRL
 #define MDIO_PCS_DIG_CTRL		0x8000
 #endif
 
+#ifndef MDIO_PCS_DIGITAL_STAT
+#define MDIO_PCS_DIGITAL_STAT		0x8010
+#endif
+
 #ifndef MDIO_AN_XNP
 #define MDIO_AN_XNP			0x0016
 #endif
@@ -1358,6 +1366,7 @@
 #define XGBE_KR_TRAINING_ENABLE		BIT(1)
 
 #define XGBE_PCS_CL37_BP		BIT(12)
+#define XGBE_PCS_PSEQ_STATE_BIT		0x10
 
 #define XGBE_AN_CL37_INT_CMPLT		BIT(0)
 #define XGBE_AN_CL37_INT_MASK		0x01
@@ -1375,6 +1384,10 @@
 #define XGBE_PMA_CDR_TRACK_EN_OFF	0x00
 #define XGBE_PMA_CDR_TRACK_EN_ON	0x01
 
+#define XGBE_PMA_RX_RST_0_MASK		BIT(4)
+#define XGBE_PMA_RX_RST_0_RESET_ON	0x10
+#define XGBE_PMA_RX_RST_0_RESET_OFF	0x00
+
 /* Bit setting and getting macros
  *  The get macro will extract the current bit field value from within
  *  the variable
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 859ded0c06b0..489f1f86df99 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1953,6 +1953,24 @@ static void xgbe_phy_set_redrv_mode(struct xgbe_prv_data *pdata)
 	xgbe_phy_put_comm_ownership(pdata);
 }
 
+static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
+{
+	int reg;
+
+	reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_PCS_DIGITAL_STAT);
+	if (reg & XGBE_PCS_PSEQ_STATE_BIT) {
+		/* mailbox command timed out, reset Rx block */
+		/* Assert reset bit for 8ns and wait for 40us */
+		XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_CTRL1,
+				 XGBE_PMA_RX_RST_0_MASK, XGBE_PMA_RX_RST_0_RESET_ON);
+		ndelay(20);
+		XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_CTRL1,
+				 XGBE_PMA_RX_RST_0_MASK, XGBE_PMA_RX_RST_0_RESET_OFF);
+		usleep_range(40, 50);
+		netif_err(pdata, link, pdata->netdev, "firmware mailbox reset performed\n");
+	}
+}
+
 static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 					unsigned int cmd, unsigned int sub_cmd)
 {
@@ -1960,9 +1978,11 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 	unsigned int wait;
 
 	/* Log if a previous command did not complete */
-	if (XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS))
+	if (XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS)) {
 		netif_dbg(pdata, link, pdata->netdev,
 			  "firmware mailbox not ready for command\n");
+			xgbe_phy_rx_reset(pdata);
+	}
 
 	/* Construct the command */
 	XP_SET_BITS(s0, XP_DRIVER_SCRATCH_0, COMMAND, cmd);
@@ -1984,6 +2004,9 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 
 	netif_dbg(pdata, link, pdata->netdev,
 		  "firmware mailbox command did not complete\n");
+
+	/* Reset on error */
+	xgbe_phy_rx_reset(pdata);
 }
 
 static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
-- 
2.25.1

