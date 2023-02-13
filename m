Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23266951DF
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 21:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjBMUai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 15:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjBMUaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 15:30:35 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C684F1BC0
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 12:30:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFYs/MWXGQ4HT2nO/pDh3U6hwfe/Bbj7TtJEHXdn9d5FQ/bStGGBSRJ4jxswr6+7L85Im6CVUGSP0thKb2/AgiQ6lR9BIGz4vAfSIsHiVmfj0/TkGDK4IbafmLb/4vz36W93rK2IUEX4HVwcVgVU60Mjc64jpT7F4WZXRZuYu9dzAbdji1PhWH8aRC5Qjlu+Qm6iw7d9H57aYFgyHh17ymDans9+2NyOLM0O2HhqVs+PY2NVa+rn9GCr2qNKyzsQmof2TqTN3Hr2WU4C2gMn9uU4hBzgiYSUnx+gLBw0XsKCWKZEWer9hKuJgim+AxEGdNdwlkCnZCTscF2sxS+HcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=blx4ei9ht+M5TXxVeVs7kDtFyWYdN5Zder26bBeylo4=;
 b=Cs5QTIDh1anXgdrqceNqFkqRhK1dearSa3SYPmRG83yyYkoQ9zWE/nxuMH2y9ulVTK4YJlI0wjzk65GvvFhbgvH/SGtYILDYI9WivKPiXqLpxj1m3YT2tXU4WRJ++VqzU5wH1HqEekRts10ex+TPamM6/lKNHjFYN2wwu0LKed7sJObRHyqp5bZI5ADrqSZPA8nd0FzH7kMFqSDIcFzVuhVuueb9K9wYUw5poBiUk1uQ4huOAOX2Zlw1OKHF02fpeLyb45Fj67CmVd2bNjcWC3qbCmB974wDYh0S6o1/GcA2S8wy1gHDO2LXPpI1xICN8x462gN6Axpp2t/PyTVaZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blx4ei9ht+M5TXxVeVs7kDtFyWYdN5Zder26bBeylo4=;
 b=GO5gApriRON3xaceJO4RnU0gdIU8WAUvUEz+bxq/lVNZZkXumxGOJXQgZYgPztcN07f/r8PhnG5RybGcw2n8ulDTAFL9n9YpnQX62Jp41/8dG0/c/Sw4yVOkNKPCBA2Ur/570PME/Xb9QayF3Xmh7ISH0Yiz2ZwiVqnl/WP7d3I=
Received: from DM5PR07CA0049.namprd07.prod.outlook.com (2603:10b6:4:ad::14) by
 SJ0PR12MB5487.namprd12.prod.outlook.com (2603:10b6:a03:301::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 20:30:32 +0000
Received: from DS1PEPF0000E649.namprd02.prod.outlook.com
 (2603:10b6:4:ad:cafe::72) by DM5PR07CA0049.outlook.office365.com
 (2603:10b6:4:ad::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 20:30:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E649.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 20:30:32 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 14:30:31 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <mkubecek@suse.cz>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH ethtool-next 0/2] ethtool: add rx-push ringparam
Date:   Mon, 13 Feb 2023 12:30:06 -0800
Message-ID: <20230213203008.2321-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E649:EE_|SJ0PR12MB5487:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e903edc-0a64-4e5a-9f31-08db0e012766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K7yFi5tIBm5ZC/vtwdtizgMqY8+j3LRn+igsT9Y9DfnWVkNVsp270YcqvGtMnqDrpfTVN3AfH0VsCpeqP7e+vOC1/rjNyE4R2mXl9Oz9ayfgb3u0iy+lRnGLlMqON6oML/bo9OhfHiQzqYMb23tzZ8AdGapkJ72buFDX8N0QNg/YtN+KPO2WxGclJovprK5Q1FaK4VYx6I30jO26iv6oeolYRdJQpOvwiN881dj+5HEm/anXUGm1hp/AG2YZ0co+Ehh2QmiP56vj7ZDtuyGa/3Bz2zH4Jvimp/ah/Ut7YgFyqhNJdD8Y2/bt+sNu125NvQI8mHkDibHWlGU+mbF1I2ybLp8iICk7dXsK0u4lXcuvqJHdQUi1sg5NV047hGzTOuq9fkwwqG1iCIJthfaj6YTc4+JWdyY6WNcvH9rzGs84rOiyc10Ofe4lM26DmFSoLG0r/2vRVTOPbrIenseaZle6nU/ZD4+RfX2CiP+iRVGSFgXu9aCMeH91HWt+1eDZ3mZHRZHkeePRUjj1Ym1oXeVT1sgK7w4JkgO1P6Ud5MY3B6nRzepCtHFa/0VmzZCF4L0EikJr0hHy3t6fbYi8xnG6bYJEyOLq3Z89hIFGctWbTY1TtNQTWuhniEmu8DBU68wQHTmdVAtZgEPeAvHZ/kmd+7zfA5WiPsztTdxuh6pqXU8x6jaId1mTKi5EwpYAVCWfXXH2RLcD0d8sw1+/+B5uypN92jZvgCNypZzSBP0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(4744005)(2906002)(44832011)(36756003)(5660300002)(83380400001)(426003)(47076005)(26005)(186003)(16526019)(356005)(336012)(2616005)(36860700001)(8936002)(40480700001)(82740400003)(81166007)(4326008)(70586007)(8676002)(70206006)(54906003)(316002)(41300700001)(6666004)(478600001)(40460700003)(1076003)(86362001)(110136005)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 20:30:32.1225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e903edc-0a64-4e5a-9f31-08db0e012766
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E649.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5487
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the rx-push ringparam attribute to the ethtool utility.

The first is a uapi patch that could be dropped in favor
of a larger uapi update patch, depending on timing of tree
maintenance.

Shannon Nelson (2):
  ethtool: uapi update for RX_PUSH ringparam attribute
  ethtool: add support for get/set rx push in ringparams

 ethtool.8.in                 | 4 ++++
 ethtool.c                    | 1 +
 netlink/desc-ethtool.c       | 1 +
 netlink/rings.c              | 7 +++++++
 uapi/linux/ethtool_netlink.h | 1 +
 5 files changed, 14 insertions(+)

-- 
2.31.1

