Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994BF6DB2FB
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 20:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjDGSp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 14:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjDGSpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 14:45:54 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D92B456
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 11:45:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uomlgtg0cS73HaKlMvKnQt3AadtfHTCBDc8djj0AwmWLbqFe2TgZ58Wr+zq7+/r04Jc0qMovKtriw7Ppraf/f0qPH4LEHaFgSMeOFDbHxcAFX+Z9jnh/nQQ9FpaLSScNcF0B4lRJVYz3ZXH9iVbzvfEbdRmZsQv2yny30aIzuAdS4rTQil6QOGNp03BuZrxJbpOUc8vvBNS6e29JmdF+nwHLnp3kiNwJf9dqbGlZIlTuRksm41gphcN7REikyu7hlI5jJF3Jh6H3L+wXi2UOLp+XFnpbDE9qoU42SyvoACD1ha0p/rh/8VnfccY6QHDaUCAis3R6pZs4A5KZzrLwMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oshc6laBLzucuv2ki2t1BEC77Bs99pMbr17cQ42j9sc=;
 b=O6pHUJzIROwWaVO6ItPOwfwpzd8f15VDLalDTKjFK7MNjSx0vWkfUbCOizqgXElq4QFD2Jba9RG52+mNRldWnVxiRrhqjDD7Cnlmt2KxixWbxTwi7X63subLXv4LOCL2VV2S2j62hGR1mW82S4rHt/dkyetgfU/EyR/D4kHClk/WnVqnPyjEV1oybxXjP2acOUP6avRXmtjHmRD2xntjiO1rxYbXOZPIu/5QqhmQ7nCpgE9JxL4R/Lsm8FK1PnkTTNHimsylTC5n1ehGlAn2RXyQ7U8+YDpgiDpgS1zEGYsBKuXozonM24ipXrufc2XMWwvK+hdDkQkEYVwh4AGFlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oshc6laBLzucuv2ki2t1BEC77Bs99pMbr17cQ42j9sc=;
 b=vJB4HQ1Knn2njx0Gd9QYD6FWi6hagpNAe1aPrM2f8mq3Gux6JZX5c+tFF61TS3x5KNFmlDwgTcsJ+n26Y8U/RuE/raCxCpNmi1bzHPaf5S39Dzj83mhlgWLtqyO7QQaIu4jwuPH3XPOSFdGEEopF+pCtEUFTYLit8/hJ+P+k/R4=
Received: from DM6PR13CA0030.namprd13.prod.outlook.com (2603:10b6:5:bc::43) by
 DM4PR12MB6424.namprd12.prod.outlook.com (2603:10b6:8:be::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.35; Fri, 7 Apr 2023 18:45:51 +0000
Received: from DM6NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::96) by DM6PR13CA0030.outlook.office365.com
 (2603:10b6:5:bc::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20 via Frontend
 Transport; Fri, 7 Apr 2023 18:45:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT094.mail.protection.outlook.com (10.13.172.195) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.20 via Frontend Transport; Fri, 7 Apr 2023 18:45:51 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 13:45:50 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <shannon.nelson@amd.com>,
        <brett.creeley@amd.com>, <allen.hubbe@amd.com>
Subject: [PATCH net-next] ionic: Don't overwrite the cyclecounter bitmask
Date:   Fri, 7 Apr 2023 11:45:39 -0700
Message-ID: <20230407184539.27559-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT094:EE_|DM4PR12MB6424:EE_
X-MS-Office365-Filtering-Correlation-Id: 29b648b1-d0fe-4486-6056-08db37984f89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JZIK9lnVGNdXm24MLhm95Ltg06FQ5eQUFCQeCzh7pvOpCAFG1fmQSpZqq68zBDB0sgbbjtw9sCSnXFm/KYoOfPGwaxFffCkGtuldgCKRJISFbgJ4wZSQFIShvxkdVMuc6Rf0T0CQI0zBpmYIgZJXCeZBYnZ03eNfwpQJbvd4GTf0HtFg0KSTncH9XSPynpdMh5quVxuAsbcSeLCzcDkY/IKJfErjVpyO1jptINvjumDa1QyL78YvfpzRwc37la/3nz2R2sG6TW3kiDTfmpwgyAGPGykrIdvkZ0qoz8NQ/7uuomyheLHjBmMzbvloGnSn1YYBXMERTOSHegjQqwVLYNEhOmWmZqostmcJCcGcO9IRaIxHBW1ae02iwds9X3365BgWZJI7AtSpZxpQIsjcQstKCnnN+7v9tzZOmYdm5XrmwabK4ncW5DVe874j9AeobMO43SzzIegH3yYzvwvk/vk5UOmRvhqCB0e1B/PvUA/CShLAYwhLpUVSByAaPV+NGp00eNRSQ+ECcMVe4qHSbwIePJGsHoNLvLdnDYJJROx7TCKX9E6ZCiqPZvZwp5ZU0xutp0IGREciQ/npulZH31DDRUZ0zLty4jyBmobr8w6ZC086T8vj1SjDQc89ZRzXJnSv+rltORURyzrw0oQ6bvFJlRXVxAFBin9ck8TPvWkRfirF5X7BkjEqyxVbcfx8ln4sDkqw8FVbih2duf3uDkjtrAQ1HetEwnPm21e4QHs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(82310400005)(6666004)(36860700001)(426003)(110136005)(336012)(186003)(83380400001)(16526019)(54906003)(478600001)(316002)(26005)(47076005)(1076003)(2616005)(2906002)(40480700001)(82740400003)(5660300002)(4326008)(41300700001)(36756003)(44832011)(40460700003)(70206006)(86362001)(81166007)(8676002)(8936002)(356005)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 18:45:51.1235
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b648b1-d0fe-4486-6056-08db37984f89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6424
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver was incorrectly overwriting the cyclecounter bitmask,
which was truncating it and not aligning to the hardware mask value.
This isn't causing any issues, but it's wrong. Fix this by not
constraining the cyclecounter/hardware mask.

Luckily, this seems to cause no issues, which is why this change
doesn't have a fixes tag and isn't being sent to net. However, if
any transformations from time->cycles are needed in the future,
this change will be needed.

Suggested-by: Allen Hubbe <allen.hubbe@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_phc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index eac2f0e3576e..7505efdff8e9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -579,11 +579,10 @@ void ionic_lif_alloc_phc(struct ionic_lif *lif)
 	diff |= diff >> 16;
 	diff |= diff >> 32;
 
-	/* constrain to the hardware bitmask, and use this as the bitmask */
+	/* constrain to the hardware bitmask */
 	diff &= phc->cc.mask;
-	phc->cc.mask = diff;
 
-	/* the wrap period is now defined by diff (or phc->cc.mask)
+	/* the wrap period is now defined by diff
 	 *
 	 * we will update the time basis at about 1/4 the wrap period, so
 	 * should not see a difference of more than +/- diff/4.
-- 
2.17.1

