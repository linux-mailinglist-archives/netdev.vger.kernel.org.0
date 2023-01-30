Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A24681698
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237624AbjA3Qkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237636AbjA3Qks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:40:48 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2F43D0A3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:40:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1gXgbuh2dxAnxindLJbFIy4BqbabbWZbU3keqOosQxmod0ZzJ/tQHI3VY7nkKITy5+2fr4iLFaojaBgu3WxAjnaWfKoMZHD37kembWKsTZc8okdrkH7FS6iefNFwrqZqmQQi4npbjl8dJVE3W2wU1whhtvxm5fmeSgEsREnWBx9Baa8ITwQQ3+fRZ0UdrHnnqYtyUXxwQn6RV0o3l4kPCKubwzL3dUXxIs1MxlH3Ul5Y9y7slvYsTa+yxxcdpx9lTOaU3qpB30zXBhJ45zQpwEHDrSLJMupVWWEqhmbpSXHQixNtUVhHBJBeUGgQb2XuFCBmzgCob/x3komInPXWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OCWNqWXuTF/vLRZ1Y82HB1GksZgrOQrUuiadot2KssY=;
 b=kDXIQOvFltU8wqcUVuW/wB6waQ7+0BxFdsGGXk33CM3CaVNBRnmbzCJvPW/t7F/meP6bEy6QqOFe6FBtoJnkgDObcA74UvsFPkW6CpZA6bDFfnjY86+5IsEnVqy5Ql7hx0tGVJmx4mN6O00ii66SM361IoLHY0JJZi8u+FfaTHhA9kxfAKRSUgdPZ/zgcli3LcFI0Uauz5L9vDQmMzgbh8PXaOCNAtKEc9ekzLzRPkErgczsD1uN8cGgVVydFwCzQnr2oz+XOc7JauWT8qUW/n3ZYqacLLoJ0V4tImOvLfJUzz8wlpAEpYl5EkU9im9MCWgq6q/edHZkt7m6WioyQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCWNqWXuTF/vLRZ1Y82HB1GksZgrOQrUuiadot2KssY=;
 b=RjNJWjYBI84ViRAdrAIhvGXqYO4bbNLR90tNEWTCVhh9XPWtw4PXv+qRHp+kkISTy0cQYWXTdx+Z88uAb+ad2WZr/a+1ok2MBHb3gGVrauKuayx9+ppmTBzQXKON7mbxJJX6XtEhvBonnw2dvMXTFh3EG362qKQbNbwRMh3uQhor29Hd3KDXMR+aH4NOWetMXzZnXZwatNz8ocZatcoFhpHvoIKw3lI5ANcNNtlQczOn0lZ/h2BHE5FWHQ7bpqu5MItB8gILWPgc6bfLvp/rULY0a3xxo/gfpDNeW3Z5QEmkGxS9tO73mU6kC5roLMyyE3bP1BflFb3ByKiVK3qh0Q==
Received: from MW4PR04CA0245.namprd04.prod.outlook.com (2603:10b6:303:88::10)
 by CH0PR12MB8506.namprd12.prod.outlook.com (2603:10b6:610:18a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 16:40:44 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::d1) by MW4PR04CA0245.outlook.office365.com
 (2603:10b6:303:88::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36 via Frontend
 Transport; Mon, 30 Jan 2023 16:40:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.36 via Frontend Transport; Mon, 30 Jan 2023 16:40:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 08:40:33 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 08:40:31 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 4/4] selftests: net: forwarding: lib: Drop lldpad_app_wait_set(), _del()
Date:   Mon, 30 Jan 2023 17:40:04 +0100
Message-ID: <044f4338337d9c3201198d775069f5daf9d76ce9.1675096231.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675096231.git.petrm@nvidia.com>
References: <cover.1675096231.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT036:EE_|CH0PR12MB8506:EE_
X-MS-Office365-Filtering-Correlation-Id: 850ab1f7-402d-417f-7c28-08db02e0bb67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpxD/BzvgtdJiti3YaWNq+ceN2kTIKMnJ9tgjItljtSrZf5OzzMqWKURkU17H8bNE0Ypeoe/bSFB1ovIA1dqTQyaZSQdoX+bI8cpo2vgJVUpCEo7PuEuB79c2to3GOTVYEhORGuWLzrrScBj+2r218AoYggB+K+3mIFNblCZQ2/14TcflOh7fu8BIM9lxdfW5IyMfWySeZ6v2Cn+y6UeomtlCpj102m+5tLtKnNrKfDUjBY5nxY/iHGCCyfeNLxVg9fM6WIRnPh3L4JhdzlOTOPp2Qhfu+s5+A7zu6L7vprS2dqTUPPOxtH6tPtokuaHZYbUPkJQddx5I5+EXNBhZ4LV0EbCiEO9s+K5gxpkuOiElOAnmmgl46DPCE2wvasx8+HDXA7UsNihikn1hkZ+73Vx9ZnIL61de8tQ12gClIhKOj6f47K7HeP/yBUfT6vQI2dkDxDF+xDFC+d1YgYzDleu+FQ8ttrwYAVndCOkoojf1ddtXrYT/9rU7X5lPaU0E2IWAzSiy6qmlhYYTciyDpE3ohx+lVmjTjRyIjTDhvw+WsjINYsqda0qXWMAc8aQy2duMUO5cQIpVdNYVZmFzQAH2ko5ibDknB1GMA46xebFdUJQwgTlgYC3nPX4BRQKl5L9SDTPM3KyHpvaox+kSU5Y1UPsGcd7EO3f3rwLfMu+ulYrFBceX4kwlNqq2a4Auv06hISvOOymWbdAmlqn6A==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(8676002)(2616005)(4326008)(8936002)(70206006)(70586007)(336012)(5660300002)(83380400001)(426003)(47076005)(6666004)(107886003)(478600001)(110136005)(54906003)(316002)(26005)(16526019)(186003)(356005)(7636003)(40460700003)(40480700001)(82310400005)(36756003)(41300700001)(86362001)(2906002)(82740400003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 16:40:44.2170
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 850ab1f7-402d-417f-7c28-08db02e0bb67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8506
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing users of these helpers have been converted to iproute2 dcb.
Drop the helpers.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 21 -------------------
 1 file changed, 21 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 7b3e89a15ccb..3693fd90c23c 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -524,27 +524,6 @@ cmd_jq()
 	[ ! -z "$output" ]
 }
 
-lldpad_app_wait_set()
-{
-	local dev=$1; shift
-
-	while lldptool -t -i $dev -V APP -c app | grep -Eq "pending|unknown"; do
-		echo "$dev: waiting for lldpad to push pending APP updates"
-		sleep 5
-	done
-}
-
-lldpad_app_wait_del()
-{
-	# Give lldpad a chance to push down the changes. If the device is downed
-	# too soon, the updates will be left pending. However, they will have
-	# been struck off the lldpad's DB already, so we won't be able to tell
-	# they are pending. Then on next test iteration this would cause
-	# weirdness as newly-added APP rules conflict with the old ones,
-	# sometimes getting stuck in an "unknown" state.
-	sleep 5
-}
-
 pre_cleanup()
 {
 	if [ "${PAUSE_ON_CLEANUP}" = "yes" ]; then
-- 
2.39.0

