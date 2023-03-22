Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19816C5137
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjCVQu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjCVQut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:50:49 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::61f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380995CC1E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:50:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/+TMWZzdA4IYGtbEt6gQd6HcAFDwNmnKCgweR4NuEFnMHuK2lViIeNzPvE8OtpVkwlAEufAGu2oYGb6OukO9GpxljsLnni+3SfjsD3yBxDGHR/O78VZMCqgSoYOrUmWrq3UoBD0IlY0yLY5M1A843fDcUUR+tIku97mjvLFsg7mYiMmfNQveeTJj01/wEXQeSl8nRnpFTrAU4Hk3BGIGbhGn1jfP7EVc/KmwbYw5PpqBk8ZpaPP57gRzf2SYv5PyszcvjsO9xKM2WTlBbn4wHCrtcZGQZe+Yx8vBH3l2XzIqNtllcU8ey9JWx1bcLK4bvNBY4T0+305tpQRf+IucQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=arC0ALJUMlSGGm/CB4lE6gkS1e7sMF3byQmBlyUE37Y=;
 b=N9r6Fue/Pzda5NwdltqXSdTKUHICG+BhkSzR4Z842+8ON20MM9xhruhcghiunN0pqFDkZ3TeFfZPPOA1y5tZ6DiJhPhIUrtFr9LJ95la45VZ8D/eHleWpaMUJys7jk4mc9hikYWxAxrZvjXbLb3fQtTj+ySq0NE8Su7ntIa04cg1dHCIOH7EAQROWDlMfIDIZt94UdFDAYMYUmF2NS0cZACdjgt1hnri3JjfF6krydqYDN92OwfOaySu+4BB5F3qqEXvXq1BYwXSrev88IYL4pkLJa89aiyyNwKpyWtYDHjgBEXfkkHPHHhw83Qv7aoUiDaleWshieRxiPYu9GyzAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arC0ALJUMlSGGm/CB4lE6gkS1e7sMF3byQmBlyUE37Y=;
 b=AZC5POsqF9E2b+oLDuOY8ccA3qBFTQpblqkQoGIv8YAAAtVfZm/UUPwLMuhso6sAx076x+1rdJ2wpZ4eP6NrJuO2xReHhovZzYO5UqAIWbCPh2X+qnOOiYpzo+8/BjiuMXv9GIxoymWFdSDLSOBpBX/m/b2FOg86ydB7XLwYT3QxQLoK5Fxr2afD0FPw+wdMxwbLK5Pm2qDtvBAujLRgKJHIM6SIBYFkQikxkEkECJMihfUsqogCP+Q88ppunKMZ33dvY5lWvFys/yXkxE2MJ5abRvSFStLZaQFttRONjd1qEjH9TY8ZRDcdQbpvqp43cI23ASu7vUhd8KQ7IBx0YA==
Received: from DS7PR03CA0281.namprd03.prod.outlook.com (2603:10b6:5:3ad::16)
 by PH8PR12MB6890.namprd12.prod.outlook.com (2603:10b6:510:1ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:50:29 +0000
Received: from DS1PEPF0000B075.namprd05.prod.outlook.com
 (2603:10b6:5:3ad:cafe::cd) by DS7PR03CA0281.outlook.office365.com
 (2603:10b6:5:3ad::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 16:50:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B075.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Wed, 22 Mar 2023 16:50:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 22 Mar 2023
 09:50:17 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 22 Mar
 2023 09:50:14 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/6] mlxsw: reg: Move 'mpsc' definition in 'mlxsw_reg_infos'
Date:   Wed, 22 Mar 2023 17:49:30 +0100
Message-ID: <9ece6a3ddfc4f092fc07e912ace0efe9f882334f.1679502371.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1679502371.git.petrm@nvidia.com>
References: <cover.1679502371.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B075:EE_|PH8PR12MB6890:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e485465-533b-40c7-4a60-08db2af58b6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QL6EhXzpoqZ2HSLPOB967ALaln09QtpcqGSajsf5jWVuWziQjP5tBT8TwE2UUMj0zes24erTRy17SYd6Kd/3D6oPEyNmc6QAO8IVqVmEqLLK2xciWL/osy0AfLLpbbvOWrSlxV/16F/K18k6Lj2vv5VWFmoNZP/yLpk0mGlEuaCQMwQoW5Or1glY/osaVOCR/DJYZBHU+9BGi9zlBZA3+hi/Z3UuNx3KOvFsS5M/BW88azOSjL75WSHO700MFLthxD5AXmdFqEml5m8eE5ud/9XBN6rWHfFYm7IoWDVtqUF9HvRw/CjKYxBD2g5JoSaDZJ1LobyTza5CfQPeaHpIGGmLQotz04qfMQe5tBglRqrC59ldAXnbj9luuMRzDc7zU72kJZcchlFqPYPDVqG8bLhPIqGcKGsBnvJbPyscNx+a+hjks34pBmGnFCxHEbMK/JWXcaQpwngeaBfgmFzLypfIDfzIFQ8nlwFd4rEZn2x1qYTCGnl+2NqYTtzk807Ms76dvKseee0rKUQ2BDTM591vGoro070DPGK9gwdBXuVqJQelCU+Q/5U7ce78lc/fCSUPOXnpPRSUfL1YSmPEiob8UDDP6TYIagGcWM4qa2tx/T4gIX721LjqEBHQapKlMQJmRLtMTeedhH9upTmc/Sa4UYULuYMRWcXCRCqAsEKoMZqZKm8SVo5oYqJGyUBprmQZBrwfizGJWwDMM7eG9nAA2ksaqxzspXRY2UYa4AoRCYw6s7rCoX4Lro0UWteG
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(426003)(186003)(107886003)(47076005)(16526019)(6666004)(478600001)(26005)(336012)(83380400001)(8676002)(2616005)(54906003)(110136005)(316002)(70586007)(70206006)(36860700001)(5660300002)(40480700001)(41300700001)(8936002)(82740400003)(7636003)(4326008)(2906002)(40460700003)(356005)(86362001)(36756003)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:50:29.6135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e485465-533b-40c7-4a60-08db2af58b6c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B075.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6890
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The array 'mlxsw_reg_infos' is ordered by registers' IDs. The ID of MPSC
register is 0x9080, so it should be after MCDA (register ID 0x9063) and
not after MTUTC (register ID 0x9055). Note that the register's fields are
defined in the correct place in the file, only the definition in
'mlxsw_reg_infos' is wrong. This issue was found while adding new
register which supposed to be before mpsc.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 8165bf31a99a..0d7d5e28945a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -12901,10 +12901,10 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mcion),
 	MLXSW_REG(mtpps),
 	MLXSW_REG(mtutc),
-	MLXSW_REG(mpsc),
 	MLXSW_REG(mcqi),
 	MLXSW_REG(mcc),
 	MLXSW_REG(mcda),
+	MLXSW_REG(mpsc),
 	MLXSW_REG(mgpc),
 	MLXSW_REG(mprs),
 	MLXSW_REG(mogcr),
-- 
2.39.0

