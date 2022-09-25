Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A085E91A1
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 10:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiIYIPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 04:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiIYIOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 04:14:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4844F12A9D
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 01:14:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvcDkjrK+DjqbsZqtegIpJ7RMFzvqCSNtDPYpbSfB9+SGAFGBRADlboNuHTBhe3RSSPi2spcXJjUggy7bdyzg0de5AtewxeO4FMkG1qH6iU1iHEftd9iQ0CtRV44bW4tdiTeCZ+i8KTqVEn3xKU5lDaZoiTBaA6VMo1iq7KDo1/+PAn5dGZX9bAUbfFc878GTgdHOdINnCRkJ/HTUEVswxiY4YXY0oaRBIGdkELsYjloTrxH0hm/SACDov6hfRWaNKheRfPB1MfxrCv9iUVNzcvUpeR1xrH4kFqBYibRzqzi2IOmOF4cPt28dcXCS+ZFA49/RPDxV/qOvXdoVfXNZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUp3RbE89Zptvm5X5qYXoXON0J6E+8GT81Eq36gKd/8=;
 b=dOZVSSBCIcfg/ulA5xO6qJHzRC73wiFGlBfccJSbNfOPtaax/h7b32NHmeW6qMhKA9fMlSPeygc/sU5tyuNMKaIoTcBtUxLt4oWXfSPMoQp0D9rai179KFc0VhwnL1DZQSrdV6QblXUaAvC8SWR+wo5NlGEVNaSanFI3X2EkzC21NaV/qT6ydhXAL07IZcz3i+zPEIADuKwqUkIzVN4AX/nq5z/VU7JtOyK8NDYC6Oy6rm0ZpFZKRabeALxkntoQ7bOc54bOOSWYShMYMr43Pv9UeTiWDD8H5JthQszsv+1uw6lwgGW6sTGEH3S8CbOE6AZn1miE0Qjxg0EGW80jsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUp3RbE89Zptvm5X5qYXoXON0J6E+8GT81Eq36gKd/8=;
 b=ApaPgdDvusAgRhCOMaZIXVEEU2vAVRqdZp/GDDHPlPIjKU3hs8SnLwB8zY9AXE4RMYEoAR2o8105UWpI3pOvYczV+GpiH2r8brY+UnVUMl5f+VH6Cv0IENUNMoGtsluuWALNgPMfMJ5XcivFUP3hHkzDltAfY7VCYauDNn4yrr05aq6zonoupvGVuV3bSEWV6l9uBOv7JN84AbLaIFMZToBAlG2c4MCcI6NvaT8IBwvxZ/gl41dUjzZP+MUH1n5ctw2Au0tUzUfgeI/wOdPB2FkGs7/VqdlsTD2QMA3TGbeiM9VyRd5aiv/gmryxuSnhXicSu2LOXe0zGz1t1Ic8nw==
Received: from BN9PR03CA0146.namprd03.prod.outlook.com (2603:10b6:408:fe::31)
 by MN2PR12MB4334.namprd12.prod.outlook.com (2603:10b6:208:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Sun, 25 Sep
 2022 08:14:44 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::e7) by BN9PR03CA0146.outlook.office365.com
 (2603:10b6:408:fe::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Sun, 25 Sep 2022 08:14:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Sun, 25 Sep 2022 08:14:44 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 25 Sep
 2022 01:14:33 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 25 Sep
 2022 01:14:33 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Sun, 25 Sep 2022 01:14:30 -0700
From:   Paul Blakey <paulb@nvidia.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net v2 2/2] selftests: add selftest for chaining of tc ingress handling to egress
Date:   Sun, 25 Sep 2022 11:14:22 +0300
Message-ID: <1664093662-32069-3-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1664093662-32069-1-git-send-email-paulb@nvidia.com>
References: <1664093662-32069-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT017:EE_|MN2PR12MB4334:EE_
X-MS-Office365-Filtering-Correlation-Id: b93c5c23-aeb9-4ac6-771b-08da9ece011a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JzhfHlVRECxpRE/z01B55JXcS/F1pVMdn3hydIpIX8R1Tx/fF51Jvw4GLFYO4MBDgF+f9cFHQFb+GVtyFQrvm7WHSWgQPzYg0vptdIwqO9T2DPxqZBJxVJ9/v06nUzbqSX/tyfVVHd9WZz8f3SymKCuTU6cYNUDGJ12ezPnK1waQ4L9nX8VcYFeoD6cLog8wxe2vqTvbnpuv8cX7ZckuTdIFP8XBRrIIm2/J8DNp1SifpKKsyZZwzsRdbYpNPy+GvpeixPfgM5tLvU6EqX327G6+lPcIKYdhsVWKZr+kLlqVexeJOFdAfXhe7+vzE9ru85QdXcFvVKv0PcTwuQ3rDb+dYLDLiAigcssNUo9GuOXi83O1k37877g6oPuYNeugR03G3n3vLf//8e41lon4nILzIWDx3iFfYaB22KNKu6hA6AlvfVkHxCDTRlnFGdOrjNKJi4UsSYkJjhewZYhBaueVNcdQM8ENXF2AU7lHTV1VqWv5eyM0jh1SSDQecxx3BtmwEOMQsWX6nlitXVZuKK/nqgAVwLn89iMuh+w2IsqY4j1VJjA1iezs98mQFzNRdAKPWhqN5CJGMmQRJaXcD8JCdXhLu1m4Cwue6zV7MPErRI7ZHo9cvp/JCjdqVind5WBDwOh2ixl+UFdZicYgjO+Q9pq2yjB8FzpMsEvPcswIY/YbYw0+2XMYoG83sWnZiywYvsYGBDhujfXqXScQRR9cLtn54VOG7n8mqOuzTmVO8clCmp+8PO3mMTFAk2aZ/RnDlUy2F5EIsujJfQIlqw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(46966006)(40470700004)(36840700001)(36756003)(7636003)(82740400003)(356005)(40480700001)(86362001)(40460700003)(82310400005)(8936002)(6666004)(41300700001)(4326008)(8676002)(5660300002)(26005)(2616005)(6636002)(54906003)(110136005)(316002)(70206006)(70586007)(478600001)(36860700001)(2906002)(47076005)(426003)(186003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2022 08:14:44.2966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b93c5c23-aeb9-4ac6-771b-08da9ece011a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4334
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test runs a simple ingress tc setup between two veth pairs,
then adds a egress->ingress rule to test the chaining of tc ingress
pipeline to tc egress piepline.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 .../net/test_ingress_egress_chaining.sh       | 81 +++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh

diff --git a/tools/testing/selftests/net/test_ingress_egress_chaining.sh b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
new file mode 100644
index 000000000000..4775f5657e68
--- /dev/null
+++ b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
@@ -0,0 +1,81 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This test runs a simple ingress tc setup between two veth pairs,
+# and chains a single egress rule to test ingress chaining to egress.
+#
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+if [ "$(id -u)" -ne 0 ];then
+	echo "SKIP: Need root privileges"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v iperf)" ]; then
+	echo "SKIP: Could not run test without iperf tool"
+	exit $ksft_skip
+fi
+
+needed_mods="act_mirred cls_flower sch_ingress"
+for mod in $needed_mods; do
+	modinfo $mod &>/dev/null || { echo "SKIP: Need act_mirred module"; exit $ksft_skip; }
+done
+
+ns="ns$((RANDOM%899+100))"
+veth1="veth1$((RANDOM%899+100))"
+veth2="veth2$((RANDOM%899+100))"
+peer1="peer1$((RANDOM%899+100))"
+peer2="peer2$((RANDOM%899+100))"
+
+function fail() {
+	echo "FAIL: $@" >> /dev/stderr
+	exit 1
+}
+
+function cleanup() {
+	killall -q -9 iperf
+	ip link del $veth1 &> /dev/null
+	ip link del $veth2 &> /dev/null
+	ip netns del $ns &> /dev/null
+}
+trap cleanup EXIT
+
+function config() {
+	echo "Setup veth pairs [$veth1, $peer1], and veth pair [$veth2, $peer2]"
+	ip link add $veth1 type veth peer name $peer1
+	ip link add $veth2 type veth peer name $peer2
+	ifconfig $peer1 5.5.5.6/24 up
+	ip netns add $ns
+	ip link set dev $peer2 netns $ns
+	ip netns exec $ns ifconfig $peer2 5.5.5.5/24 up
+	ifconfig $veth2 0 up
+	ifconfig $veth1 0 up
+
+	echo "Add tc filter ingress->egress forwarding $veth1 <-> $veth2"
+	tc qdisc add dev $veth2 ingress
+	tc qdisc add dev $veth1 ingress
+	tc filter add dev $veth2 ingress prio 1 proto all flower \
+		action mirred egress redirect dev $veth1
+	tc filter add dev $veth1 ingress prio 1 proto all flower \
+		action mirred egress redirect dev $veth2
+
+	echo "Add tc filter egress->ingress forwarding $peer1 -> $veth1, bypassing the veth pipe"
+	tc qdisc add dev $peer1 clsact
+	tc filter add dev $peer1 egress prio 20 proto ip flower \
+		action mirred ingress redirect dev $veth1
+}
+
+function test_run() {
+	echo "Run iperf"
+	iperf -s -D
+	timeout -k 2 10 ip netns exec $ns iperf -c 5.5.5.6 -i 1 -t 2 || fail "iperf failed"
+	echo "Test passed"
+}
+
+config
+test_run
+trap - EXIT
+cleanup
+
+
-- 
2.30.1

