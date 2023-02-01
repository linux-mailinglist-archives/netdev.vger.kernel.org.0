Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1BB686CFA
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbjBARaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjBARaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:30:16 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F5B6E42F
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:29:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQ/sYW6g9f69mSVwACRoRXepnkj4i9kXIrWm0sAyIWcJTQ87QvjQN5SprAu3RQ4YkYb/u/h5wFyDcxAvTO63TTF9xMmKP+/SwD0IV1Jn6T8eJWEdfHqVT4816PUYIJFHNHdZSS0B8ldulsXdrRcHPT0BwkmD9m8pgvJqm5kvaOSNz1ySOqq7JTH5PsCaOI57xwZ+6amn5N7izFGx+JwWAOsxFobMGJ8CRzQrv1nhIkOu8UkSniqkVlzkTc/u4gRjXCiLJ+rP07cpuElO4onJZFvH+rA1X6XUIPevvAXsrY5A5Ci+hqhNf10HprBKKEFyigRpKU0vrXtMmz2yJB1QYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QfwDjRcqFxkcs4B67gJfwkJ/lZDxYu654RNOFOi9rw=;
 b=Pg1xGlKTO1/DfLKxQslCULXsfpgqqNeZSDDbP5Cd9b6d8QgUe90g8LZD0EhNW5BoHaYfEWxEbJuFwqQXZ5AC7R67xiGl2MfalYGojsijgauaSOuIDoWrvm1AyFMAuoidwmLJ4okVYbH3ANdqk5TRm3/Ar0vr+daE+7IIE+uJrqDX8wDLiy4dB5NsnrxcBD1xxe2v31tCufavOF0ZwK8sg5SuNY90lbv7+s5IgbllEe6SbneHjOT9FF+yOAhgC62w272NCY6OerkDfyAoh1AGW0VsnCaK1dY1oDAJYoi304XD+QArufeauPUehl7IvxbI/xBNCQkts9YfHLABK1YX7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QfwDjRcqFxkcs4B67gJfwkJ/lZDxYu654RNOFOi9rw=;
 b=BurUQIx/z78d/zozfSe6Oc0ZOTkt5bUkbolGS5SgtMAEYy2eVi6VdZXU5IIyRKFdUcJwlVOPcyaa6diNaV0QoVpMjPAx81CnEZhCFn9GzgctK0CSDCZR2lD605ml1b9GLSD1JFvtc0PVZExNrtm6uCT2sOG7B6a9gGXV8fCMvdwGiLkzjgeZHBHqBF+AxPX2lRqxTMU5pdfJxLU/HiwTB7iCbPuCF5Jvz0jVW0PErK2lTtHYzKxDJd5r9l9Cmqk3T7oZVkd/iComeDiESR/yIvoEqH08aQaymF0A9vFHbv2bdlU4/arV7fLukZNro6QiZG/Z1NtT3UhxI87c3d/P4w==
Received: from DM6PR13CA0014.namprd13.prod.outlook.com (2603:10b6:5:bc::27) by
 SA3PR12MB8021.namprd12.prod.outlook.com (2603:10b6:806:305::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 17:29:47 +0000
Received: from DS1PEPF0000E632.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::21) by DM6PR13CA0014.outlook.office365.com
 (2603:10b6:5:bc::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Wed, 1 Feb 2023 17:29:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E632.mail.protection.outlook.com (10.167.17.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Wed, 1 Feb 2023 17:29:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:36 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:33 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>
CC:     <bridge@lists.linux-foundation.org>,
        Petr Machata <petrm@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next mlxsw v2 10/16] selftests: forwarding: bridge_mdb: Fix a typo
Date:   Wed, 1 Feb 2023 18:28:43 +0100
Message-ID: <aad4cf4f3f59aa652a2aae0033df95af91dba055.1675271084.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675271084.git.petrm@nvidia.com>
References: <cover.1675271084.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E632:EE_|SA3PR12MB8021:EE_
X-MS-Office365-Filtering-Correlation-Id: 243c5c71-0b21-42ee-0db3-08db0479ea7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oOS1thWwsRqWXs5keHjMJPP6bVnYmeicr1OCn33kTPN5FebkCtG8o9mP9b0+LoFvQmZHqCKSCKFvP2GE8uUC7sPjliEopxnY46aoP0E5BVavXmHAv5L2XPPKXVMbnSr6EOHrNf/8sEkr2bUwjHOUI/M7RdA4Btd8sC+3TGnojshKyNSv1E/K8ic8UimEdxVQtZgxnkoIC/uyBc5dMUeosY2DAkMs9LqewyvZAIlLPfNJU45ATSTZa9GmAzIOje11o6hCGflyVf47IUDV2z9SKuzMTrbhBZWE8KzHuwmyF3t0UHp3f/c0W5gsr3x6rXuh6gwSjQO0CXD6xAeId8nFqRv8L0WBBdgZmKYJtXZeOop62iK50YytBXLXcAyONk73rL6DziUWT1a4AKA49NTEOhfNZKyKDs8u+5RwDqnItk3oL7qOWIvXxcMIqiXOqhKDByuW79NmKNyuPQZ2NpnQNFAlsX1Ngg2K01s/UTmaWjMWq6KT++NJ0Gcm/wThuU+rCzlmDCpAQoi450KNM+QJKcIkBovWCQSWLG849jhtR3ZzE0ER5ScfaCgfcl//JoRa7zH0Q558yjaDNDdGlclbmFNtkuUcZ9jiXfpmsjW1mmsVfVY5n5azl/7Uz2POlFWJ3DhRsf6Mdkm4lhGiwGNbL3SWR6Z7bWbtU3JK3ViYluXIllDWSar0inxyrFCbfdlMoVAlJqqSLibaWLL6pEZSVw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199018)(46966006)(36840700001)(40470700004)(2906002)(36756003)(5660300002)(4744005)(40480700001)(36860700001)(82740400003)(40460700003)(2616005)(426003)(336012)(47076005)(478600001)(16526019)(26005)(186003)(356005)(7636003)(8676002)(70586007)(82310400005)(86362001)(4326008)(110136005)(54906003)(83380400001)(70206006)(316002)(107886003)(8936002)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:29:47.3178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 243c5c71-0b21-42ee-0db3-08db0479ea7e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E632.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8021
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the letter missing from the word "INCLUDE".

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 tools/testing/selftests/net/forwarding/bridge_mdb.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index 51f2b0d77067..4e16677f02ba 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -1054,7 +1054,7 @@ ctrl_igmpv3_is_in_test()
 
 	bridge mdb del dev br0 port $swp1 grp 239.1.1.1 vid 10
 
-	log_test "IGMPv3 MODE_IS_INCLUE tests"
+	log_test "IGMPv3 MODE_IS_INCLUDE tests"
 }
 
 ctrl_mldv2_is_in_test()
-- 
2.39.0

