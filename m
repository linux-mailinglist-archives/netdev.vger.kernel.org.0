Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5096B0887
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjCHNVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjCHNVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:21:34 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFBEC70A8
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 05:17:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=by3EnuxDtA+t6ZAjtWeMRPraAq1lfma26OMctNJD/Y0T0Ae2BRUKzY0xOl9PMocLEQPJCm2e8Cpy5p/YAk1UsihfIDzg/nBXyfUTRsB5R73VHzZfkLxZN3q+wheapECXNKuixMCiu01alADtCGTMt/AqlA6f4GvfCbG05wcqzzG3WyLfcwqdP3fDuJB3S79W5MPpdoF6URCncSsiuwJCgnqVFPF9UvSwNknZ2nOU7juZGgFY9+zsE1btpCFVco4G9x+VMu+gsibsaSLKIL0YNtL+L9Hpk6nLCuErBPuPJbU58YoHfpcuiECfZvcVIArU0ZxqrbEfQegxPjHjBNc1jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vcYSOIvQQWIRLLqh70ToouxG+pt1UXBlq40f4XydHho=;
 b=NzK60W1SELswOymna0pr/VWUb/1B4rH6sQjMjv9+LYLxwcpvLVqmXaHqdbl+qtbZxeLQAsy7oh5k3ZFDQ8moBnzpMCPoNBRDX/WVZ/IoubIQY1JdWaZx75ODOHLBRKwUXyXzwRX2t8UeGpsIyonuyyDr0QG4fIr8yzxUEofxdTAcqL0H0yz4Mov5pxuSvvoue1FCScMnKZ11FZrGe+by6jC1G5hBjfLyfOzitCDcnsGmKhwdwqKBLxx8f6BsBYqf7tvedTZHeQd8Wm+mxGMLSr0oTmY/ubIiQXR3ylVOovtNF+SSY7nP0ruj31DD7Q92xrom189KAj7eGuse1okZ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vcYSOIvQQWIRLLqh70ToouxG+pt1UXBlq40f4XydHho=;
 b=FFI+tdb+D1QZzTLCU1/lPbb/m8dtF9T4HDmxisHSOy9k3kf6wBcDQyBNbcI4TAxxrXfKeYFT3fSUdPpVSje0P6U+atbgC/REFsw02//QjRMiCmCRIQAU0YRKvqB7Q01JagK0jEv+E/iMbyu1TvnVrfgFxoOUHQsxtf9kDfIA9DTRd/3ITJn3rkiqPLl5Nc4dpnXp6MGjOs9lzWxOkTQatGlGtIsG7gF/Mlzg6MYGDpsW+UjtfWKGkjhL5YUFDhRV81ze8LGNziQAg1IT2vn2TjeK/Y/z3Db7Q4qPIa7eDO8VfnybnBr5gCmXa85HDiDaNfgLIHH1fYdcmUI9CPz8ug==
Received: from DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) by
 SA1PR12MB8920.namprd12.prod.outlook.com (2603:10b6:806:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 13:17:11 +0000
Received: from CY4PEPF0000C985.namprd02.prod.outlook.com
 (2603:10b6:5:3ba:cafe::65) by DS7PR03CA0212.outlook.office365.com
 (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 13:17:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000C985.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Wed, 8 Mar 2023 13:17:11 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 8 Mar 2023
 05:17:03 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 8 Mar 2023 05:17:02 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.5 via Frontend
 Transport; Wed, 8 Mar 2023 05:17:00 -0800
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next v2 0/2] Couple of minor improvements to build_skb variants
Date:   Wed, 8 Mar 2023 15:17:18 +0200
Message-ID: <20230308131720.2103611-1-gal@nvidia.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C985:EE_|SA1PR12MB8920:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b868807-41e1-4340-9396-08db1fd76d0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zBBWcZyhtU7KL/Ff5T7Og7lwM7ZPePkd200mJZMTuHn2N067JIJna29+Nn8iwAWkKo+eoqbCwqBbRqU9ymlQSLVkoFfYMpM82TVI4KT+QkGYFhAbcKKMAtlOHeFP1E2wlLUpNuJNhnpDBltK36B9Hyp5zExMVPJxYtsEfmAFQAzsvjgUb1yoMbCIaHe7BlDvE7Da7I656Yv8EdFCtVMagCqaE7+rXL42fiRwlGDq37kvmzEoU72vfyXnjih5BQK6lBINAxRaQuFQ2sscWU5tsV2g0+wcxScNJ4o5wVHUNJfKAddPxxhdX7dpEboZmeMPVtUmCh7XZ5RDaJw/SdkfN6jKj4obkR7ihk6jbfNs5RkcnvMEc1+6oCC6P8iZkt49ism7K1hkqiCIHU918uEdzX4pnPiWivta8EV3aFlKH4YiKKrIbFkWAw0naCb04HISYIe+ZgM1kKCMCr70ytD/Ts9XOoGAbLJBaCnj5GnA6j5Ii35w+mcZY777f1TBjDYaeFMlcDrQih4c4y/euf5RRpH98+BT3AdmFcVuy40z9CUp81cFaqrm2vqytVmj1PtJj5LYfCsjhHoEqiYiF8kgeBzw9epq9Tvk78GzzSq2v3pDbKY1s6ESdrLQaLn+d1r/1vvto1oHqGAmcbFlPATvSMphy8bAKDo3goVLmGpvTUVPjkm5c2la08SL5cCsNwSQUHFEVlE/QFmomPfakdMiFhbWgeSZMGNdQkIYSDAA31EmpCbAJuLdOx87fEMrKyNJ
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199018)(46966006)(36840700001)(40470700004)(82740400003)(2906002)(186003)(4744005)(2616005)(5660300002)(8936002)(7636003)(36860700001)(356005)(26005)(1076003)(8676002)(70206006)(4326008)(6666004)(107886003)(47076005)(426003)(82310400005)(70586007)(41300700001)(86362001)(54906003)(478600001)(316002)(110136005)(83380400001)(40460700003)(336012)(40480700001)(36756003)(7696005)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 13:17:11.0221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b868807-41e1-4340-9396-08db1fd76d0e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C985.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8920
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch replaces open-coded occurrences of
skb_propagate_pfmemalloc() in build_skb() and build_skb_around().
The secnod patch adds a likely() to the skb allocation in build_skb().

Changelog -
v1->v2: https://lore.kernel.org/netdev/20230215121707.1936762-1-gal@nvidia.com/
* Add 'frag_size' into the likely call

Thanks

Gal Pressman (2):
  skbuff: Replace open-coded skb_propagate_pfmemalloc()s
  skbuff: Add likely to skb pointer in build_skb()

 net/core/skbuff.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

-- 
2.39.1

