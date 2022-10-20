Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C7F60577F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiJTGn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiJTGnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:43:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DDE15ECC0
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 23:43:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5OTJir13D7V6NLelTRhX3/YcTjoLrjh7wJWWRNgtSLOpEmHWH+7GkUU8EjCxcs9U2T9BTWLW6QycG4JMaiRDssWrYEjLpuxWFxBPQWCCge0sUU2oyXxtVcPQOr3rKiFtmyFONepjjntw96eRNUDkvYF/X6tsCrCeoRMgJBsakmy/yooOgrJoccHRH9x0t1sbCLr1J6zoiA+sRmWtl4ZyMLebESIhgE8++uRbwJjZwdgnoYdToHH4zaqHk2oz9D+UM8YWH7RDqSfEKg3odgmlz85yJhQ6mUX8LYfSdGYaSSPZ6Q8YGrKZ2hLXLgnIs6IRfbq8cSXneGm3dBQ0ABA/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXrw1PiFV7BFzW9tUMBj3zzYe8L6AQTw/GzXmZIr5Z8=;
 b=bLdZEWYf8CY6wk2G/NbeIZKa5HV6j2puogmoyI9rm3HpC8XSj1Kp29+2T/gAa9JC6GcaA35nwnsqR127li24huoXELr3khZ7Y5j9LBo54vPHZnlfb+IiYWqQdFQEHUs2QnpLXs4RP0XTFxLeq0cj5At5rZarcLTokTNYEYYRH6We6CkL6oU4coxiaF7bh8YAJ3D9LUM+PIzhryLpuD5WchuEhg0B3NjJgVYsx5jjwPj+ihTCjNlhRz0Z3hMJZuZTl3t/EIbOsZpjbcH2xFQregkSLdgeTZe6rENSCwhPuwNd/m+6otZe9vR+GfzOJe9vgh5/j8bTRxFPd+E77aC7xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXrw1PiFV7BFzW9tUMBj3zzYe8L6AQTw/GzXmZIr5Z8=;
 b=LRhWvaz/RI47wsZ03VrjPogpt+2gARNGZneKZJbIC/gbSBS1nKxbmozUIz3yRfHTijDcBWFhk00gImcna93+ppwNLFr698AYvwOFR0fnBxqOFbAJQs2S4fr0raPmW/M5xAKy7pmrLaexTCK4NF1d4TD/xYwz0V9c/cFlNIimxRI=
Received: from DM6PR06CA0053.namprd06.prod.outlook.com (2603:10b6:5:54::30) by
 PH7PR12MB5735.namprd12.prod.outlook.com (2603:10b6:510:1e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 06:43:20 +0000
Received: from DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::81) by DM6PR06CA0053.outlook.office365.com
 (2603:10b6:5:54::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35 via Frontend
 Transport; Thu, 20 Oct 2022 06:43:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT073.mail.protection.outlook.com (10.13.173.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 06:43:19 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 01:43:16 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Rajesh1.Kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v3 net 4/5] amd-xgbe: fix the SFP compliance codes check for DAC cables
Date:   Thu, 20 Oct 2022 12:12:14 +0530
Message-ID: <20221020064215.2341278-5-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
References: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT073:EE_|PH7PR12MB5735:EE_
X-MS-Office365-Filtering-Correlation-Id: 74b0fe5f-f386-4c46-0d44-08dab2665fec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gozSvUM/ZxsnrRza4iDF7+DQmF6NLfjbEfUG3fq54zAYcCI3cyJL9Z9FTdKqS00oKwSWPCO2Ji4pzqwDG462BfT1zTBBgMMcHQWDl0/41+yCshNeSRLnmhSESzUyW14Uh93MvEwfnbKGBiFzgBSQWqhtZXegNj5+y48pmho9mzAFXd1i11WfWP8QWDIevwn3wfODGjk8rBywpc0R5mBSua3cpHHtg8H4wj0WauI5Khpqm1j2oflA4OHkLr7lBzTHcOa5/Gc04+OEfnthizuxg77k1w1Inq1opkVuQGMa/eGhdHA6why9VKo8BoJhtmgJiYJ+Txtmz2GPLhrIaeqbnjs8QMWm8zD7QshanNMsw4miloXz41TmtiQIup91ThQuUriUM+x5I0JfKt4hgq1+9UbPQ8ljGDwo3jkTw0goUODTj4FyOVqvxyTso/+sp3fZC/j4rGr3fvnM2rC3BnQmWElzxMTBw5ShlKhsUDa77wrOydzm5jk9T7KTNjW1ZcAmgmY6b42dsDrt3lCDru/09reavGHhMcdUKPlrnpGXn7fNh0JM9ZlcB7gwklogaaAT39a/8z90CRKaoit/c1OrH6UeGUt/WZ5VEmxkJgC1aHF1bX1oBsgYqGE1AnWlRFH6QqdRp5VYNBJFu8cbTeqblEBlSF5Vr+yRjL8Eak5SuhM3y/nejWbcmE9oRBM0ec3KRhpVmQdFq5tnToTeLrZI+31e2FWf+NH2OSmUNzXO4SmAkSG15f7kqzVNGHbN3GyTOL9DBCjqfMauxbk7cn1I0gRr/uk24H8NAmhthbubE1/nxo8JQNykRtDV/e1+DLfp
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199015)(40470700004)(46966006)(36840700001)(82740400003)(86362001)(36756003)(82310400005)(40480700001)(356005)(40460700003)(2906002)(81166007)(478600001)(70206006)(110136005)(41300700001)(8676002)(70586007)(4326008)(8936002)(5660300002)(316002)(54906003)(36860700001)(47076005)(26005)(7696005)(83380400001)(1076003)(336012)(16526019)(186003)(426003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 06:43:19.1279
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b0fe5f-f386-4c46-0d44-08dab2665fec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5735
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current XGBE code assumes that offset 6 of EEPROM SFP DAC (passive)
cables is NULL. However, some cables (the 5 meter and 7 meter Molex
passive cables) have non-zero data at offset 6. Fix the logic by moving
the passive cable check above the active checks, so as not to be
improperly identified as an active cable. This will fix the issue for
any passive cable that advertises 1000Base-CX in offset 6.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
Changes since v1:
 - Split the changes into two patches. The next patch contains the
   Vendor specific quirk.
 - Add a vendor check for Molex cables before assigning bit rate ceiling

 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 349ba0dc1fa2..8c41ac5676d6 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1151,7 +1151,10 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 	}
 
 	/* Determine the type of SFP */
-	if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
+	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
+		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
+	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
 	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_LR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_LR;
@@ -1167,9 +1170,6 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_CX;
 	else if (sfp_base[XGBE_SFP_BASE_1GBE_CC] & XGBE_SFP_BASE_1GBE_CC_T)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_T;
-	else if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE) &&
-		 xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
-		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
 
 	switch (phy_data->sfp_base) {
 	case XGBE_SFP_BASE_1000_T:
-- 
2.25.1

