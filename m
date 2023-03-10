Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC176B3E43
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCJLpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCJLpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:45:40 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BDA11051F
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 03:45:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gz+zGPrj/FoIh9APTxR9nm/EdR2LRjmLrVEDIRRvQMYGWadAOmecuwShQuKUT2w8JJ+HggQZDXwuSJX79DLJ7+HXM/iWl824DpefsdEak/CNiTxDkjv0ePgATAsLeXb576XxNwIzQoNTEf6fB07poB6gGzDtSL+5tK2+IdYgudI+YGTWeOMtoFT5qcBoLsevB5yclwshNzmaa8GDN7jW3XWDBSGvEl2F6cXvBCGH0rlCR4gChrXOefrnb8ckZpGQX8WqhBwwPzFWJfk8MaTFbguK7QcUCTlTkLGC2nOiLK5vVAKZVfP+zHthdjn4X3p9lbxz5/u802Jt4kwrruBYHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gj+Ujv4K+mxQaF7rzl/Gw04znHLfyexp5Z9mbp50BwQ=;
 b=TjBXtYuhKvHp8nmiNVtgl/YaCNxaDdYELNYsclIFaFlo0CQsBRSdPJDMGBIMu03QlwpyXZqzXC08FzBj+BnixLsWjd5LMntskr6lZYffYsvnq7+n/oqxrZe1UDbfumnec01LCVj9a/blv8ZlvKkvNixyoYk1hUieertA2VEE7CkzVMsu+pvDDPS7oF+oK4f4w08jf6Zdkp2hVTJY3KfCF0ndsEMPNWG+FQak2489EClzyXaWXd+bt1VheZeukRle/NNuQzeATDweGpbT0covCkxQuT8jCV9cJM21yBN54yNg4oGWBQ6IOKNMJ7zNJzPwMr9Kvlu24X9UcneEmOdC/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gj+Ujv4K+mxQaF7rzl/Gw04znHLfyexp5Z9mbp50BwQ=;
 b=MI/HvRyaEXt4uhlqYiKnkWd/6ui+55aQOIifQAleA/wGV+tpOPc1Vn13J0pVfu9rrZG98p3YHIUU+nUwQ7MmuYlUVLh8W20caPBQQVqsNzce2DnszfkKRfal0VWnfZ6Cyy7SOjtYVUEW+ITJ/KFtF9FKZ942HvXRW4ec0VhWvXUTG8APoWsAQJGCGpyvbAjj8XPu0mIjVqTOtd42uopBr5x+pxQLF/BERLazI3KHvjJ2NN5/r4jsHwcV4FtnqgwBC9IsDZrfNo9S11K95K/yLR0hkUjSQii3TGooqzjOm9a53JIUreBkMgC+ztZQNKQqYcB5Oe23AcBhIyhNY5yBOg==
Received: from MW4PR02CA0023.namprd02.prod.outlook.com (2603:10b6:303:16d::16)
 by IA0PR12MB8205.namprd12.prod.outlook.com (2603:10b6:208:400::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 11:45:37 +0000
Received: from CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::a5) by MW4PR02CA0023.outlook.office365.com
 (2603:10b6:303:16d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 11:45:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT078.mail.protection.outlook.com (10.13.175.177) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19 via Frontend Transport; Fri, 10 Mar 2023 11:45:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 10 Mar 2023
 03:45:24 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 10 Mar 2023 03:45:21 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/5] net: Extend address label support
Date:   Fri, 10 Mar 2023 12:44:53 +0100
Message-ID: <cover.1678448186.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT078:EE_|IA0PR12MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: d2e28cb6-f14f-41af-2b6a-08db215cf6da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aRenFypbqo70ZZVcQodpTKD7OxLrK0gnqSrvoWSDJ9nkW0f0oKZcBFjkY4r5RU0LWNfYGGM/oDb1I6VcyvEMuVc8mhSod8iM9ndpeQrUhb/lLSGfZ9ngs9d49ymQnw2ZIGKt1F5j/7T3puixKYmprKOi56QztogDesy4rpwwsCkIvXoKSoTfHMwsV4aRGEUe4NiA3n8PnOsK4IqeIaq7Vt3f5ubGaFfyuSUXrpUmxPsBJhoOtS1Gkwm/WPf/TAAji8UiPa8VDBRlQyy0sdlGIrRjSgN+Mi/rtKAIkL3xNw2vyk8tMT3l+XDBOCgH7RT8w+bLxhz3i9ivjMW5dqIkVwNvkJGiPfKJoQPCB1sPftjYe6d5WAJ7b0GP3qi4R339x0t0x1KxhNmC9+c9DOMZEDv7IbrTAHZ2S2f6oIaQ75KDJy5rxgRxFAAhzpB20T+c2h8qGPFJuwqjqDW4mFpuTG7Jgnz8gEXBdRm4nMzXT28EvBnN+wkczFCjw49pJAUiXBpnpvvDQ0BPhyuoe70FtQ238K/y8n6i3hdEH2FG42AWw8ZM1XUI0Jfm/VIbzKd5nzexBUojDTuUiLuBi+SOUUuK985KZ8DflNqEQCSpQ8YVpZQlGS9X/0V0Zim4GwEA3+iNRJ76txRUuiqmG2mJq4XcVAIx1U5pzxD51i9DL2tjIvEFRsERsDKtdjA2zbGbw58M05NiFMiPqPOx5V4yg2kRNmEzOyMniQVdXhDs7gzjkap8mRxSJSpsDbBD3TnD
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199018)(40470700004)(36840700001)(46966006)(2906002)(5660300002)(26005)(8936002)(36756003)(8676002)(110136005)(70586007)(41300700001)(40480700001)(54906003)(40460700003)(4326008)(316002)(86362001)(7696005)(478600001)(356005)(107886003)(82740400003)(6666004)(36860700001)(47076005)(16526019)(82310400005)(2616005)(186003)(336012)(7636003)(70206006)(426003)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 11:45:36.3695
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e28cb6-f14f-41af-2b6a-08db215cf6da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8205
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv4 addresses can be tagged with label strings. Unlike IPv6 addrlabels,
which are used for prioritization of IPv6 addresses, these "ip address
labels" are simply tags that the userspace can assign to IP addresses
arbitrarily.

IPv4 has had support for these tags since before Linux was tracked in GIT.
However it has never been possible to change the label after it is once
defined. This limits usefulness of this feature. A userspace that wants to
change a label might drop and recreate the address, but that disrupts
routing and is just impractical.

IPv6 addresses lack support for address labels (in the sense of address
tags) altogether.

In this patchset, extend IPv4 to allow changing the label defined at an
address (in patch #1). Then, in patches #2 and #3, extend IPv6 with a suite
of address label operations fully analogous with those defined for IPv4.
Then in patches #4 and #5 add selftest coverage for the feature.

An example session with the feature in action:

	# ip address add dev d 2001:db8:1::1/64 label foo
	# ip address show dev d
	4: d: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc [...]
	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
	    inet6 2001:db8:1::1/64 scope global foo <--
	    valid_lft forever preferred_lft forever
	    inet6 fe80::429:74ff:fefd:1feb/64 scope link d
	    valid_lft forever preferred_lft forever

	# ip address replace dev d 2001:db8:1::1/64 label bar
	# ip address show dev d
	4: d: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc [...]
	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
	    inet6 2001:db8:1::1/64 scope global bar <--
	    valid_lft forever preferred_lft forever
	    inet6 fe80::429:74ff:fefd:1feb/64 scope link d
	    valid_lft forever preferred_lft forever

	# ip address del dev d 2001:db8:1::1/64 label foo
	RTNETLINK answers: Cannot assign requested address
	# ip address del dev d 2001:db8:1::1/64 label bar

Petr Machata (5):
  net: ipv4: Allow changing IPv4 labels
  net: ipv6: addrconf: Support IPv6 address labels
  net: ipv6: addrconf: Expose IPv6 address labels through netlink
  selftests: rtnetlink: Make the set of tests to run configurable
  selftests: rtnetlink: Add an address label test

 include/net/addrconf.h                   |   2 +
 include/net/if_inet6.h                   |   1 +
 net/ipv4/devinet.c                       |  10 +-
 net/ipv6/addrconf.c                      |  30 +++-
 tools/testing/selftests/net/rtnetlink.sh | 172 +++++++++++++++++------
 5 files changed, 169 insertions(+), 46 deletions(-)

-- 
2.39.0

