Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495D9697B97
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 13:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbjBOMRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 07:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbjBOMRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 07:17:24 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072.outbound.protection.outlook.com [40.107.100.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DA69EF3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 04:17:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1KX0NE5EpK4tqJgwdWBH9WXJzNSdoTXoBHMSd871mOpHuB4hToD7L9gQgxVYfPkoyTKujjHQjtbVV1aI1vHE1lGzP1uYRaFIGoNTl4JSCabkYuA1MlcnT+p97IrXua9saW04LbnKdolmaBmfjDtBp63iEVI+OM/Iv7YYcpc9SZ/hBMZvgfQjT4qQtg/GWUVlaXIBlncMxj/Yyx/MFbAdWVxFPX3YnOwOD7J9FOuHt6Ers7ZC5rZZ5Weg7flngVhguo3D7iAyBq51lBbFPVN8al+D8wYlXHn6p4DZ/ECJ3K4Nw95b2TI32BTNVSDHsQ6UTEw6d4X3rexYBGL2vWsmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ctlWVoaqj7H1nF4AeftRfmvV1XG+TZolbxnOOvW9bTw=;
 b=JWz+dPwFFiTxzDtfEw+Dh/ty2GAWHy1HPPbV1jgqZwjRngY1H24VbcdmDaiAKZOOfc/arSjVrmfbaR6Ej9rEVo2Uq2FvnAdE0snHCPHEG6NYjBUrc42UtWMwscNdzM4VOR6ZYS+mD2dVmzWms8bEX/a1eeZhlAHAh0CYSY6V9URLYWNcHIrMUXTGIzJKv//xOP/39V3R49pdVfsdkAWgqImrMUB8KQVGztMLiGKNEepcWC7A//LzQRywD9lQOn1CieiKt59Gl+Yvy8o6H006YTsBZSQRl5u40DPTTvIzKikdE+u5RiidxsStvpFBz4WpFAus+5mylQHEUZZz95UQwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctlWVoaqj7H1nF4AeftRfmvV1XG+TZolbxnOOvW9bTw=;
 b=Ja5scoIX6JEopLlG6Mq0qbhX2ofpZ72HbL23cbp4frpCZfiVwoiibsu1ppH7Ktbq8HUxkvG52YMy/M01lNaA+35ShRL3CAdVRdrLAB9xHmd7MVIQj0JDH6xfHCOWJTtHv76S+t6/1nPs3jh+kehqxnTuMo5DZHDMijT+qr4y8mbdsH9HHpA+n1s6bYfoBK4q3CSo6kZ6rAH4ScfYRkxzwV1xfgpm21Z5JpbgUAl8kg0gR94qI2LXbT0k0ewbVNOCszRAmvPXqAiQHTjnql041xXv8TXiCNTHnVFt9Z7EoOqARBmX9EQGVYXbpgPF0xJpAxosThqwP6tsRZ2DJ/bzsg==
Received: from DS7PR06CA0005.namprd06.prod.outlook.com (2603:10b6:8:2a::20) by
 IA1PR12MB6578.namprd12.prod.outlook.com (2603:10b6:208:3a2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Wed, 15 Feb 2023 12:17:21 +0000
Received: from DS1PEPF0000B074.namprd05.prod.outlook.com
 (2603:10b6:8:2a:cafe::43) by DS7PR06CA0005.outlook.office365.com
 (2603:10b6:8:2a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 12:17:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B074.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Wed, 15 Feb 2023 12:17:20 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 04:17:10 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 04:17:10 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 15 Feb
 2023 04:17:08 -0800
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next 0/2] Couple of minor improvements to build_skb variants
Date:   Wed, 15 Feb 2023 14:17:05 +0200
Message-ID: <20230215121707.1936762-1-gal@nvidia.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B074:EE_|IA1PR12MB6578:EE_
X-MS-Office365-Filtering-Correlation-Id: ff83d592-2941-4452-14a7-08db0f4e9641
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gHdShS8dRYDBY4PdIFFrTXeXqiAM1lDb6VCBvV715u/543UmD0wf8855WAOpnKXZ/jy50858HB1Uy/EwElRJRTX9I0ye0EEWLxKL9O8ik1d6h/l7w06mTTPaNg97co6YE8ezBFvqLmvqQh8ZwioreZHOUpEUDBF8/RcAhXtYVXscahjPQyAGt6DMUbfGSXdQs/b3mzKzgJ587Kot4ystcUG+GdmGW1ieNMHEcyo6wDtDXqdAdp/LEASHsIwlnWoLbtD57Tzvka/GDpHdcUz9NOZ+8/IlXb4UNbnt5MEdwz23v0YGNToYoN8JQYCBFZ4n6+hQd00vNzDrF5vYMCGJoaWSwxLBCTE6Z4ghw8IxbUydB/2TxBg3BfLfPbtibqnkWY92kApm0+O11iSyIgbFkQ41umIuzU2V0/+jVT/X43dpN5GuXZF5nzy0SCQIvqVQ06LKnoGgmluI5c9+RiJIahhfXVZm2CG6CVSskTp1NLlubZ3A0ROUQJ/rsRKPwxGONskL84qVCRYbEyRo0wBSV8pmzOPSuQEErKpOE0d01uA2h3/IdQ4hQ7erP/INeQDmgi7tgZz3hLJmky/NoReJg135HaT9v17Fr8gBh2rERHirBpMzIxw3UdS0MArlowhtlYRrysk3BsIYPWGPPbv0AFKc32EOYT6rxMvRU9ebZNrakbsrbY4TBJPuaekXDNLC5K+8sKRa/TlDt28RhfkVkQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199018)(40470700004)(46966006)(36840700001)(186003)(4744005)(5660300002)(40480700001)(107886003)(6666004)(8936002)(2906002)(41300700001)(36756003)(40460700003)(426003)(336012)(2616005)(8676002)(1076003)(316002)(478600001)(47076005)(4326008)(26005)(110136005)(83380400001)(70206006)(54906003)(70586007)(86362001)(356005)(7696005)(7636003)(82740400003)(36860700001)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 12:17:20.4364
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff83d592-2941-4452-14a7-08db0f4e9641
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B074.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6578
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch replaces open-coded occurrences of
skb_propagate_pfmemalloc() in build_skb() and build_skb_around().
The secnod patch adds a likely() to the skb allocation in build_skb().

Thanks

Gal Pressman (2):
  skbuff: Replace open-coded skb_propagate_pfmemalloc()s
  skbuff: Add likely to skb pointer in build_skb()

 net/core/skbuff.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

-- 
2.39.0

