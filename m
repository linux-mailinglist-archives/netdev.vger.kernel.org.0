Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A0E6182C2
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiKCP2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiKCP2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:28:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40971B1FB
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 08:28:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNFy+lDy/z982RCnuphryJJHSrrV+OELqF7nu9yLthxyY0bb6xvNjVLXAtpmHYOzqDKZ0JUJRyHE2Cjus017cyjdnggIC6AbEYnFJmjFYcrJ6ltufTs9+XP1dpRH5Qqrk6c36fpPlHEoq39fA80S8IEjenlo0FFNT8c5DApeftNqXKYGwOsHceKFOm77ruDwmokFAw8gRIl8Fsyd8JyZrlYxOpuoVi6hJLSuMMRyvgB9LOvs7njiv/fxrsp8r+VbxEpGmxXfnSFQOfA4IrLkoV4eDi1/t60en+GIvEd4BnpiZuyBADSYrX9yeegCtaIffZatdUDdzrZfNZZZS3OEVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YASliACehkvQH7oZxZz3NMQ79jS8k5TpmXs3KHSooJg=;
 b=X9FDPNU3vv+0W1OB80kkPluepshnXUBVTmSQZ5aVClRs+hepO5c3dVzzEee0L7WgnPJWqfF99ou9MBPFUgT8Ebr7vy8MW0Ty/DtFCUmhyti3ug4/z7q3pNMdTAdoyFv+/ux6jcJsjqF4VjEXO1zrSprbyOTSBrL5qt/RzcTMQNRJoupluCCfYmoKnCQi4PlWITFn9/iBPsZEOyOObdx3EkEG6qTSTa1e+tNPOuYvRM1otaPVIjE6Gco0fUKg3buHM7I+dQqX41iVL5jHSljsdw8lhhGTO2wNGIk+OegLo2/ITtlkJZHJFTjKOMvTYZHuWRE5gc4OT/jbIo2V6PC/iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YASliACehkvQH7oZxZz3NMQ79jS8k5TpmXs3KHSooJg=;
 b=mxi5aDNw5vqQ8QyGe14DStn2r8ChChyxIz5uA1lhTtt00EmS3sGsdTSoqNtsbZdGGYRRmJNmZzl/x/3okJCs3+VoXnsBvhSddtrKWv6YErw2v9Bb/Anwd8VdeT5xkj8QYLzcvXc9UAe/u3FU3NEVqsKbWLfxkiRHLRVbKxxkO4A=
Received: from DM6PR13CA0062.namprd13.prod.outlook.com (2603:10b6:5:134::39)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18; Thu, 3 Nov
 2022 15:28:01 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::cc) by DM6PR13CA0062.outlook.office365.com
 (2603:10b6:5:134::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Thu, 3 Nov 2022 15:28:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Thu, 3 Nov 2022 15:28:01 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 10:28:01 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 10:28:00 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Thu, 3 Nov 2022 10:27:59 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 1/5] sfc: check recirc_id match caps before MAE offload
Date:   Thu, 3 Nov 2022 15:27:27 +0000
Message-ID: <a63c30384f7749f46a7e4f5479ca5463b1f46b89.1667412458.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667412458.git.ecree.xilinx@gmail.com>
References: <cover.1667412458.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT068:EE_|SA0PR12MB4413:EE_
X-MS-Office365-Filtering-Correlation-Id: 88b9deaa-c27c-44eb-69ee-08dabdaffea9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SjJQ4izKmdlhv9SQsndae5mPcoTg0G9RMNHveYSiIvpf47fvrOFjgXWEs8+LqDkw45uS136tB66beSY5O1dkv+/0g7XHesYU0ao9YDBPT9y9S4znIzF/kbZGL6aGdlobe17VoE2ihqLoeeCOIHbpLlvjO6PT/CWv/jwQ7Za0mQDE2aATmdacoamvWnm/P8Dv93eT/UAdMURYs6Ee3hmd7bIplLxvaKUVUL/doFZEtSmZEvs8j3nH/Nfo/dy/Hx6DtH+StPU3zbYbZ4blNJUTa2MjO295d9xn1cGNQgMMnhBNfixN30DKfRog7ULBuQT/7lnr5sPfXedkZxr923UuYBzBi+a0EUKhMWHcCukpH6XhkSDyjV95HLJtmyFvXSrcX0gx01y2CVTe4LRFoWPuAyp1Uv6mvYqp4Qa7uXx/QIegDeQvTqrr9vpc+wxDBfDrN5P79JJ37nEmSo6wt2YWR8nmTzQh+KqbK9ZZdOBs1kgu9VKDHwIORH1sPSlG38Eb81jPTLXc2rk4S8YgReuEj04eMnwxLlW7MaU7RWkVcJLKk/f18jQw7AJ/GKAyfhfhWTtSyeeaZ7YKc/0UVmL1hXjXsIuWZoBXGRtnjSYqqpdtXCeXMm865jFkyfu+Ba8C3xhLAKCZgVMuD8qle5bXx/Cf7oZ4Q3EWeaMLCAWdjbDXm5OKB5aaFiyuSOOKfN74n2JZ45XcoHhB2b/FA5eLywwfS8jyC89evpcgdnSHja3jh3+N49kND3wQ3gPJ9EP5awwfi7mTJsPFTK5S9pcYP1bnXHgdpBy9wb1EIi3ksy4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(426003)(47076005)(83380400001)(41300700001)(336012)(2906002)(2876002)(6666004)(4326008)(55446002)(81166007)(36756003)(40460700003)(356005)(86362001)(40480700001)(82740400003)(36860700001)(110136005)(82310400005)(9686003)(186003)(26005)(6636002)(70586007)(70206006)(316002)(5660300002)(8676002)(8936002)(54906003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 15:28:01.5163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b9deaa-c27c-44eb-69ee-08dabdaffea9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Offloaded TC rules always match on recirc_id in the MAE, so we should
 check that the MAE reported support for this match before attempting
 to insert the rule.
These checks allow us to fail early, avoiding the PCIe round-trip to
 firmware for an MC_CMD_MAE_ACTION_RULE_INSERT that will only fail,
 and more importantly providing a more informative error message that
 identifies which match field is unsupported.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 6f472ea0638a..cd014957a236 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -250,6 +250,20 @@ static int efx_mae_match_check_cap_typ(u8 support, enum mask_type typ)
 	}
 }
 
+/* Validate field mask against hardware capabilities.  Captures caller's 'rc' */
+#define CHECK(_mcdi, _field)	({					       \
+	enum mask_type typ = classify_mask((const u8 *)&mask->_field,	       \
+					   sizeof(mask->_field));	       \
+									       \
+	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_ ## _mcdi],\
+					 typ);				       \
+	if (rc)								       \
+		NL_SET_ERR_MSG_FMT_MOD(extack,				       \
+				       "No support for %s mask in field %s",   \
+				       mask_type_name(typ), #_field);	       \
+	rc;								       \
+})
+
 int efx_mae_match_check_caps(struct efx_nic *efx,
 			     const struct efx_tc_match_fields *mask,
 			     struct netlink_ext_ack *extack)
@@ -269,8 +283,11 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 				       mask_type_name(ingress_port_mask_type));
 		return rc;
 	}
+	if (CHECK(RECIRC_ID, recirc_id))
+		return rc;
 	return 0;
 }
+#undef CHECK
 
 static bool efx_mae_asl_id(u32 id)
 {
