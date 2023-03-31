Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE1B6D223A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbjCaOT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbjCaOT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:19:26 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFB01EFFE
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 07:19:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlfB4m6CZIRMQgx8unjSpk3jQeO3Ez2/oKu4bH3gfrS04UTsfEIYr2Hx3zf69eiroyHeFCAc+gfu1gQwr2XJI6KP9IWsWF1KxUC1N4Ds92cC6q18HhYYn5J2TPMz51OsVu5okOG0aaqwIKjVoKCFAHdTEIGNGmKjOjf1gh2mh4F3bzb+osDERF0IxP9V8AsmqJVwI6Jz8N0+rt8WmVliUJDYsrPkdJ7zKK2N4ly/2lg0UFOtMYZjc6+lkgm0IigDnOoBWTzexMQFK2fEntcswq3RYzXKTsqog66V2m20fQ5QD1PSR1LIryhDt3R4ynFDVPugs5/B+qz20REwhXhLug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v22ArDAfM8eszJuY6pt/mgRTFzUP+/9s2puYgIOuMwg=;
 b=lhF4unFqvsBhbzASHxThqKS7K0J1WcAQuZisNlNYAIVHqbPGxdrs/dutzP0GLFKMGuuZ/56LtVYD+Xb3vSkXhN3aC4wkU77pKGKkSOYXrynvPPPDBqUe7cXCOqYWdnDL0sAkoNE4CUIm0vnuYJO5fpC/g0FD4ZHndQwwnYs9Rp3vggDOQPCohPVtOSW/SXl3tG2rquI5CnYbVCLct17f5RITqEU9iAuNCVsZ3kPEkrv76nXk7M8fpbjrzHgFzg7pAUDHINoNw88quR5poegayYdCa9/3n+SVi4RURJOrev7vWGfZ1im8JjotHcvJE/4TkRDfmXlScLkazJjjj+4kOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v22ArDAfM8eszJuY6pt/mgRTFzUP+/9s2puYgIOuMwg=;
 b=jtTt4cw+vJ7/EkH86W3vs3xJKT3G1DoIF8VPsns4MDLzO50jeqfQyL/SzLDKwpE/QziUVpjqmNwAsdxIhlDaMVIYV5DfrHhhht0gdbFhAVmxZJT0im1x4eS16EJfhg4oOVBgtRO8oc54N6re/kDXMt6iVQ8At+9XblueFPHRKW4IAuNixSimTZ7uya/J5fGyYkRKbDilrBXVuGBs4N0qUobKBOvVdDMoS1TomxnGsZ2AhV9XBmesfJmw70p3grCfHStGCLODDGqPG9RREGUu8AGtNsRU6QvqtAA+LRwILnoL+aQkTWsrIHjzY11p18ljalHWjLTAxpj70+hm/i/b/Q==
Received: from DS7PR03CA0153.namprd03.prod.outlook.com (2603:10b6:5:3b2::8) by
 SJ2PR12MB8649.namprd12.prod.outlook.com (2603:10b6:a03:53c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 14:19:08 +0000
Received: from DS1PEPF0000E646.namprd02.prod.outlook.com
 (2603:10b6:5:3b2:cafe::1e) by DS7PR03CA0153.outlook.office365.com
 (2603:10b6:5:3b2::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Fri, 31 Mar 2023 14:19:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E646.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Fri, 31 Mar 2023 14:19:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 31 Mar 2023
 07:18:33 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 31 Mar
 2023 07:18:29 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/3] mlxsw: Use static trip points for transceiver modules
Date:   Fri, 31 Mar 2023 16:17:29 +0200
Message-ID: <cover.1680272119.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E646:EE_|SJ2PR12MB8649:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c24bca0-c5b2-438b-e4fa-08db31f2e3b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2v022zXmQmow6Y5WJ0vc5rAqJTyDEwFvhNskZbEGbUk1/jOnAsttML9wziAI8Lo/PWxhpcl4AJ4u3tCPQxUjymuFwATzBQGoEZVLTxJOpxcjFzKTmB5uCqlcKFQ2DlloONJYEL2tZ7PlTNrdAEZl+DRKMCOkbbZEXIDWcNU3wxMcVkirdRhZ+GJBA4ka0EGs7veHt6fzIxjOs1MrjEhVLR3Cjx/HASai4U8vh8o1dfrR+CL0Omcjnt4VrhkQputYzQc8wc+/uEFQUJXQsv8+bOhMBtP9sZ/0Qwf8bY0xN5aWRGQZEDF9tWGyJfDUrqmx4qTr+OU8maIEYLWKTInPNZZh2JoC/97B/N9lTYYUdDAPmPc9JP3ut+KGA9E71Dsx42CNI9TZPDEqgc+cDuKLbiCe5OSTJCIFQhgfy5P/jWMMfn5UY8neXKk9coPqErTwMwd35eDS1H8ZrvGNDZMblAmtf5yEh3QeCG3vg2RTMX0BWRwKDvHkjbpi3z9+NvFUY5BajvnG6Y8O72Kgr17PaWosFx2o192BfH+2F16U0lQMsj9ixYZFq80aWcifKROj5YcCy8gGOkSg1lsC9S/6LAAHYSjeGt+HYM14lAUnKN1MccXmcHD9uxfJC/JZRcg4EXZ/cmyNj/K7MWgYk640afaNMsseMJNqx8s21dK1BZEME5++F3dlfc27mw954RjoDbVA6KkSIxNHwK6gy/SfivmzcLCj/b5m0ZgtOOh2nHUKOdObGUxeFrLebNFrJF/O
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199021)(36840700001)(46966006)(40470700004)(478600001)(47076005)(83380400001)(336012)(2616005)(36860700001)(426003)(186003)(36756003)(40480700001)(16526019)(82310400005)(86362001)(82740400003)(26005)(7636003)(40460700003)(356005)(5660300002)(107886003)(4326008)(70206006)(70586007)(2906002)(8676002)(8936002)(4744005)(41300700001)(54906003)(316002)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 14:19:07.3286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c24bca0-c5b2-438b-e4fa-08db31f2e3b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E646.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8649
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel writes:

See patch #1 for motivation and implementation details.

Patches #2-#3 are simple cleanups as a result of the changes in the
first patch.

Ido Schimmel (3):
  mlxsw: core_thermal: Use static trip points for transceiver modules
  mlxsw: core_thermal: Make mlxsw_thermal_module_init() void
  mlxsw: core_thermal: Simplify transceiver module get_temp() callback

 .../ethernet/mellanox/mlxsw/core_thermal.c    | 165 ++++--------------
 1 file changed, 36 insertions(+), 129 deletions(-)

-- 
2.39.0

