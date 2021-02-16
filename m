Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C65A31D0B2
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhBPTIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhBPTIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 14:08:39 -0500
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04on060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe4d::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233AFC061756
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 11:07:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ih2ANkFsMTSkQVaVoKxj5I6wJfToMEgMVfKvtUuwc5o//s47jdiWnUK0VYdKzcquOn1n/LdmWSJldhkHvs0RiXgMQkaXg9FWYMl7jcq3i6SdYRGHXc37h0oAhmFkzyLY/hlrvIJJDOd+HvYE17nDo4LoufSl4alBf5zYU0d6UDothOophDGFv24qcJCWeYZSLnJlqg+qppV1Slcx+AJw8QfwJ7wLcFFnDUgD5xugVi9o32xb2H0KDXcM2sMBFSI2vQM+hepfW/GLqlNejrVsY/X2vDw4lgnfqhf08k1oiyacq76bWQd0TYwqJwN1FIToB0Tg9yifePYhCnHbqkRrNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSyvPVGe9jDL3zkzIpw+vu0zYBgmCAjL6jsB59SRpzk=;
 b=AoShvi/kzET7clvbYx8/4NbZW43TZX8AUk99Y2pGKmkyu2iYjRSFNcEy5qf0jEi0qaTZvf4USHje7ShYz3IB2z+i7XtoRUWb5scWKNL4onqOaYlp4e8xN4HTKHXWEQwcyI1RJ6d/6i/sKNK0Zb35z0iSIlm/tD25Z+OwyfCcLaR6jKxzixx4gEZHg/mPkznosw45gaKUvnCf1uUChAHsyPQGq7I0QSpIqc2NgZxKtXCwG2R7c1DfxS5XIumj9a5VLf5L1wn8tsuGkrHIC0GB+cLwzwzg65RucfHZ4eMUmrTfnna7xKYQNwYSkIJPLmPCJBhFKiYut49cJXtbZLvLtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSyvPVGe9jDL3zkzIpw+vu0zYBgmCAjL6jsB59SRpzk=;
 b=I49B8s2Y/TT1E14d72NJy+cNADuSOiEzLpMIrSO0Rdf4DTkzXgdu3IOdJ06g/sFaIuLgD6n0wPexVhD56s9Gon60JUvXwQeKVTBhD+Zo4Z69MujhOrkaEdrhotXHfLshcBNzEfWXf5mKPOWktqULH5illdWJJpqfNchlfv++Eog=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from BL0PR12MB2484.namprd12.prod.outlook.com (2603:10b6:207:4e::19)
 by MN2PR12MB4334.namprd12.prod.outlook.com (2603:10b6:208:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Tue, 16 Feb
 2021 19:07:52 +0000
Received: from BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::5883:dfcd:a28:36f2]) by BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::5883:dfcd:a28:36f2%6]) with mapi id 15.20.3846.031; Tue, 16 Feb 2021
 19:07:52 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [net,v2, 1/4] net: amd-xgbe: Reset the PHY rx data path when mailbox command timeout
Date:   Wed, 17 Feb 2021 00:37:07 +0530
Message-Id: <20210216190710.2911856-2-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210216190710.2911856-1-Shyam-sundar.S-k@amd.com>
References: <20210216190710.2911856-1-Shyam-sundar.S-k@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::16) To BL0PR12MB2484.namprd12.prod.outlook.com
 (2603:10b6:207:4e::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR01CA0074.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 16 Feb 2021 19:07:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d2b32b93-4fa1-4d9c-5d08-08d8d2ae28ec
X-MS-TrafficTypeDiagnostic: MN2PR12MB4334:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB43349EA5ACBF60C5471F5AA29A879@MN2PR12MB4334.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /sP5sPG4X+yzMW/VFpTUgHp1Wupw87JREq9wI0trZ2HpLKPKR8aVpG9GAa1TCAg1NoYxppM+SZPv87JQcuRtVAK0qOu7tBwp/aNnnTYRBthTyIJ+nC33gHOtmBxN/QaK7enmNXDByfw8mlN64+WdQngBUJF3YmHLGdGI4SYwyymI1t0VZ2v1Luf5fA+TH/6NLiiK04CyVe4c4cjyfXhQFM+I2ZPqHUe2HWwVMvNcANIy8kETA9Coopx7yCr+c295JZdkeRYSqxMpZFBVI/B70PrLfET8p08D+cfUhCCbil+nwj9c/52mktGPW8WoMPKR8kFSfFV43IU2Gvi9fFrNrQh5VUhBmM3zsnzT0g58FNOWaqiT38OygiErtln69wv1xMzz5H6RrLYt3RBuXPxQetcwUAvdJwd3b5KmwEfu+JoBDWx92Ml23lcjJV7U8Xn+CRgkIt8B4PLbx6slOuKwvCrfBI1uOXuDk0FjRv4V4HSZQR/BHjQhsUMNqLRsaeL6XZlZF1QMINv2n29Q7lpT9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2484.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(8936002)(36756003)(7696005)(52116002)(956004)(2616005)(1076003)(86362001)(316002)(2906002)(26005)(66946007)(54906003)(5660300002)(16526019)(66556008)(66476007)(110136005)(186003)(83380400001)(8676002)(15650500001)(6666004)(6486002)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RMdjt3yqmIWpsyynNwB2ekZTpHiEUa/8xhpRdP8B+QNptnjnito2JMsq4y1I?=
 =?us-ascii?Q?ZmzWwkTnyGOSSS1QUKV9zv06O4M5Q8GQB24R2t7rKHX7Kg/KypQuYsNiBbzd?=
 =?us-ascii?Q?00LpElYsQdKA2PaB0KhpO8RFKWaNpPTF3BPaUMzS7Ua1A347OkUOGvKyHoS0?=
 =?us-ascii?Q?IVaQLjlLpdJWQYlimd+KCuGTbYjHzYrN2P2LV21tWVDxM24nBZkNU3SvJI+6?=
 =?us-ascii?Q?P+4iVx2bpSb54KyZ/hfuHX/yXePf9eZuBs1K2M40LTQiJnsuDhbucNFQMHN7?=
 =?us-ascii?Q?3a7LOjAZ/T8sIhUrloZSTzOIus9gmOJ/MYHmKi4nx8hKtb27grhsU3aEFzTE?=
 =?us-ascii?Q?bI3UGH7BRUCgjBKTzN4hVxBqPhGp6autzj0lhpZWfe3Qfy0jKAFPDyVpwsNb?=
 =?us-ascii?Q?T7F4JWi4VSc+KJyM+SRo6d/B6737HvwFtpwtHhq/5LkqWCkYqCSiEQDa05w7?=
 =?us-ascii?Q?lRZqun9GtuMwPpfDuchYxfHRy3s/H4xAG1WxQsOQfTBP5ad+/VCdbkGIxV5+?=
 =?us-ascii?Q?tUN6JT/vwe6UB3cCTTzDKkzlNTSMM4tPDdQeH3oXW7QgvRCz4RrGwMSmaDpY?=
 =?us-ascii?Q?keLZY5J33Xwp+GQf066QjDAcoVSo3JZYKr8k3MLwoAgxSPZO1JfrNc/RrxEJ?=
 =?us-ascii?Q?H9/+R/4aZ4ZD1Rkp73Vul7rLmAUe5R4SISMObUUZ+hwu5EDBcZGpr3kvCW5S?=
 =?us-ascii?Q?ZIcWdLty0C2Xx3NILAcpAJZvGUp7ejs4VQdeY7oSe0qu0cnt+jSXeFYJWBjy?=
 =?us-ascii?Q?Me4VczIY/CPNA/LMM2wrzFARkHQ0CYkcxDPKiUuvw3n+s8awOFPDetWYVm5X?=
 =?us-ascii?Q?zCZl/AJWM9ccsUDCE/0Gg2xStiXogb3JA4zCPxqOOAGCgmxUiBDvm2NaxOeF?=
 =?us-ascii?Q?XWN86spkAFN4a97aT74tjgbgXKsLB3NJyRdID0m58Qc0ZBsiP28ZMPCEUz71?=
 =?us-ascii?Q?uq19ftjZlqO8FlmDe9A3mWE3Kn/lcQ2xBbP/0jun3y026tNEG4ezKjmmYJsS?=
 =?us-ascii?Q?UvI3cf7hf55bDHFEzon7FCDrcsDmmkzhkeO1gg0ull5iOstAOiXrpHMLI2ND?=
 =?us-ascii?Q?a+Xj5V4Qm1sVAHgEav8q//Gl4N6JTOrbZySfvJdpGSN/Sf/PGd/bElQKSKlQ?=
 =?us-ascii?Q?xoVu4g2B+WRNf1AnFoxWEqGgDGXYlmzmzbruAfnXITlDbPoY2w5Mur8PEuLO?=
 =?us-ascii?Q?pMkt+ZCRm2Kaj2RtUrXDqbDvxqq/GZM0wT0mj4fPQtgxAjt4LXA0b7CDlQfc?=
 =?us-ascii?Q?ORp80FXCOJc9cVQWQIKcXODX5ysp4h3W/YDfQb14DzxqcS3mJDzsTIHYAmWr?=
 =?us-ascii?Q?r6yez0RUjPBftXJj5RCWdgyi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b32b93-4fa1-4d9c-5d08-08d8d2ae28ec
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2484.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 19:07:52.7025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9wBcGYh0u3AKlaxNMoz13COqYyK9pfxqF5pZKUifITRK95qwU6cR9NxpcKjhEpTjNrvYtSla5wQWXBO78xczg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4334
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes mailbox commands timeout when the RX data path becomes
unresponsive. This prevents the submission of new mailbox commands to DXIO.
This patch identifies the timeout and resets the RX data path so that the
next message can be submitted properly.

Fixes: 549b32af9f7c ("amd-xgbe: Simplify mailbox interface rate change code")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
---
v1->v2:
- Add Co-Developed-by: and Fixes: tag
- Changes suggested by Tom on right usage for PSEQ_STATE.

 drivers/net/ethernet/amd/xgbe/xgbe-common.h | 14 +++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 28 ++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index b40d4377cc71..b2cd3bdba9f8 100644
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
@@ -1358,6 +1366,8 @@
 #define XGBE_KR_TRAINING_ENABLE		BIT(1)
 
 #define XGBE_PCS_CL37_BP		BIT(12)
+#define XGBE_PCS_PSEQ_STATE_MASK	0x1c
+#define XGBE_PCS_PSEQ_STATE_POWER_GOOD	0x10
 
 #define XGBE_AN_CL37_INT_CMPLT		BIT(0)
 #define XGBE_AN_CL37_INT_MASK		0x01
@@ -1375,6 +1385,10 @@
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
index 859ded0c06b0..087948085ae1 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1953,6 +1953,27 @@ static void xgbe_phy_set_redrv_mode(struct xgbe_prv_data *pdata)
 	xgbe_phy_put_comm_ownership(pdata);
 }
 
+static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
+{
+	int reg;
+
+	reg = XMDIO_READ_BITS(pdata, MDIO_MMD_PCS, MDIO_PCS_DIGITAL_STAT,
+			      XGBE_PCS_PSEQ_STATE_MASK);
+	if (reg == XGBE_PCS_PSEQ_STATE_POWER_GOOD) {
+		/* Mailbox command timed out, reset of RX block is required.
+		 * This can be done by asseting the reset bit and wait for
+		 * its compeletion.
+		 */
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
@@ -1960,9 +1981,11 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 	unsigned int wait;
 
 	/* Log if a previous command did not complete */
-	if (XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS))
+	if (XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS)) {
 		netif_dbg(pdata, link, pdata->netdev,
 			  "firmware mailbox not ready for command\n");
+		xgbe_phy_rx_reset(pdata);
+	}
 
 	/* Construct the command */
 	XP_SET_BITS(s0, XP_DRIVER_SCRATCH_0, COMMAND, cmd);
@@ -1984,6 +2007,9 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 
 	netif_dbg(pdata, link, pdata->netdev,
 		  "firmware mailbox command did not complete\n");
+
+	/* Reset on error */
+	xgbe_phy_rx_reset(pdata);
 }
 
 static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
-- 
2.25.1

