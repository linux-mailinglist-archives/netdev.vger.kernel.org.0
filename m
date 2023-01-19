Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C32D673592
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjASKdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjASKd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:33:26 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FEE5410D
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:33:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VkyLjAiFJ25SGGHp26HPLbN5jJX+iONTftq37qJyeMARVtI9c1ZHOkjYApSEz0Zn6jsb6SPA+hwooCuNqYFYI2l71duj93PH5YAERnciOlkc4+iY33Jk61xVWc/E9Dt8crwyC7ExUeaj7rf/5784uxzwknAcws+6j/jFuQkQtz0xgElzfXCFXXxSY34Bp4SoQXg5wnN4SMAvPKwAgoLd3di0SNaZ0gmVju5iWkMEXsaVYIcM2RLeVPJJF/s56O59uDPquvyuoiJrEcTvNLVGpsG4fKOPGf424K13H94k+zbQnAGC8M7kVKjFt62cZ6yeRDfBGJEuGqggJOYFF0sjlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FjJqLQSn7wVyp9yOcRYr+tILDVFGZNoeGZFwSMsqwg=;
 b=Y3UrOVqrr7Hso+rC0m5MJv0QCMvXd+/YYdJiILW+qq3mHgwDM7TdGXRaznBFQwUSK6ehRB2RyawblDmPjKbkkXnVWjRzqNtctc6ukvxfpaHD6PEynzx9jc6Fo9ZmMlnyz7m/p+1x6tgE8xfoT4fG4QrOhvB3ZyUbreP2JVEfO0UW8iJUe9muC+mSKPl4XiV5SciMTTSbFiuECtn4OpAwlKigMTbrAtH01mew1hD9iop6t2XHm/VPWs9FXWj807cja06VQLx7/JMGBdym4wLUY83PYnus/ONibilj8RKqgQicdgMVMeA99BEdbuVy7YFfTOtpSeH9vzZnqmNCr/rHNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FjJqLQSn7wVyp9yOcRYr+tILDVFGZNoeGZFwSMsqwg=;
 b=huwfRKFlTPtqvAD0T8AiMuPsMrOr7ouvGf+2OjhEm99mH0xaIV0jtxi9R8yA+12Wvcx8o8ud/byBlufAQB3fCqAbK+juYumxWz043jRSpDAmtOFldU//4JoyvwUcX4Aw9mOJqULrrTovSqgWB1uwabAZrNAgwVW8ozqurkSmwaSUz7r6oP7GBFMwLfTDccFU5EyEC2L7Ut358gtUxIuPOJigGpWtayZQiqGBbfp51fBxJCqUIdnj982bFyCBWWFHiii+cl7O1NaABVf+oZuKpy3czbR4y8tbecsJ0Xpvf0LPRc99NVuREQOv6ccEPtZoQnTHLu0jwGorUdA+Fky8dQ==
Received: from MW4PR04CA0336.namprd04.prod.outlook.com (2603:10b6:303:8a::11)
 by CY8PR12MB7633.namprd12.prod.outlook.com (2603:10b6:930:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 10:33:22 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::de) by MW4PR04CA0336.outlook.office365.com
 (2603:10b6:303:8a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 10:33:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 10:33:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 02:33:10 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 19 Jan 2023 02:33:07 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 4/6] mlxsw: emad: Add support for latency TLV
Date:   Thu, 19 Jan 2023 11:32:30 +0100
Message-ID: <22a5475ac73ea81b8a0279e49e821bd223329b18.1674123673.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674123673.git.petrm@nvidia.com>
References: <cover.1674123673.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|CY8PR12MB7633:EE_
X-MS-Office365-Filtering-Correlation-Id: cfced538-9222-4b1f-2546-08dafa0896cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T/NKvdavfC4LVsrbtaH7QFxASxX4xFMdhaVQjrx9WjdB5VgmJRbtD7lGkky/sEOJKx6UIJ2geH0DVjCX5mEBXc92UpRsAOR7gZ0AahSFsyjFdVFQ2Agib7QS2WeQR4lRl/OWXWLg9gVoUOsQk+s73+3Wx5V7OyvcGq7IbNHl+smNrJD2DD4DKBYfKUQ7EEYr2sNSJyLI5Tvc6YdTW35m8QqU6LDOSau1UUml6OMwmi4d5SHwihlsWFck1X8F9FySOHh1fHN9l6CR4GqXmRAYF+NXN0/eSRBov+ZQu0DH6YoOnD3iTUuehqX3hXME+CZ89REtgCYipjHveTsP/cuonEm2/nOK5ms10jOdDwb8VkCRiYPLODB8EOJqXHz+HktevpDxczZtODSq2SCPysj7uXve71GjuEtx3MGqoVWcwLJUeffKxQySx5C32XPILjgeGMT0svAbGmTS1iiGL+vtst6VnbJIpLul2lWq9eyOUqUin8rxu6r7v7EQsOriibst700M1Zq8+fyBnwoEUSBvSBaeIpVHK+hD3Zr2A3msXmx+v7hLbkjbcN5iFFy8y+waluVU0F79YHoiMG0aKac1L9t+DH2RgDYVNHULgsjxNSYKh1FGulhf8oVtqhIyiDGLdxCalkw7KH9XlfJ5STdrmB2xfXMf+LFiqZCdo/y5lvkoRVfRippbPUMu8+AlSZj75+KmuCakHDbeIdXW07DmYQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(426003)(47076005)(54906003)(86362001)(110136005)(6666004)(107886003)(40460700003)(478600001)(316002)(40480700001)(36756003)(7636003)(82740400003)(186003)(82310400005)(356005)(16526019)(336012)(26005)(5660300002)(2906002)(7696005)(2616005)(36860700001)(41300700001)(70586007)(4326008)(8676002)(8936002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 10:33:22.1780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfced538-9222-4b1f-2546-08dafa0896cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7633
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The next patches will add support for latency TLV as part of EMAD (Ethernet
Management Datagrams) packets. As preparation, add the relevant values.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/emad.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/emad.h b/drivers/net/ethernet/mellanox/mlxsw/emad.h
index acfbbec52424..c51a61aa19b7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/emad.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/emad.h
@@ -21,6 +21,7 @@ enum {
 	MLXSW_EMAD_TLV_TYPE_OP,
 	MLXSW_EMAD_TLV_TYPE_STRING,
 	MLXSW_EMAD_TLV_TYPE_REG,
+	MLXSW_EMAD_TLV_TYPE_LATENCY,
 };
 
 /* OP TLV */
@@ -90,6 +91,9 @@ enum {
 /* STRING TLV */
 #define MLXSW_EMAD_STRING_TLV_LEN 33	/* Length in u32 */
 
+/* LATENCY TLV */
+#define MLXSW_EMAD_LATENCY_TLV_LEN 7	/* Length in u32 */
+
 /* END TLV */
 #define MLXSW_EMAD_END_TLV_LEN 1	/* Length in u32 */
 
-- 
2.39.0

