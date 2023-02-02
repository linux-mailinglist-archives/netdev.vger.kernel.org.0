Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6503D688064
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbjBBOsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjBBOsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:48:07 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D958F532;
        Thu,  2 Feb 2023 06:47:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCBidV0IaPkk+MnJmiakcdhqZ96Qq8Vc9HAzOxqcZYtLSqjy9XpuVHeOekqMkf1OwX0B06iEGDxD8EcTd58XGF+DMHJm1n9DaeVmLwAY94w448w/lynWQLIGSKOfTP51lyiK1CqA7Tmz9onysisE/kpREpuHZtJsbej9BBhkqqOkuxQD0AvzGfCXzuPXUeRX3WZd3QGgNcE9F2zwOOKx02wbkBLt//+lCgjy5WwPIz2Sf2lutd2KUr4Y//Y30rIg4zZ9uweveMvwvVpxYBZg/6DzoV+611WV33sYIM5YVS7qD3hQ7S/grwzzBZVW6aDMtgBE+6/dQPOOpV+NGc8inQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWq234xCb8JZRWLRDKcj9324ddutLM4/+Ni3aKJHS0w=;
 b=CjaXesNoX0kjJ13iD5DyejnixfO0UTEfnEGGWAR88/6HcvI2o2k0N2/AewRwNMha5/rNXzNb5MprnMlN5KkgMpWySP8zvyrA/8aBQ8607rGDYXK22lFk23YAm8Cp7Hja+sh0jzrWLAbD9NcjE8kkkTapL+EgbbN2Un0v+jx0YJj376wDEPT976QE4KEyC34xTMBoHIMs50tPIVVZFSpLUHSg8s2w1kCrdHnwxFvv7KrGIQkeZx2kYz3aoswy8kv8aKa7eaKnlH6FT9I3uH1G8UHQ3qpHVqOOBs4ahUtV/9e5gXI09hBxYJwWm160YT61h5bDgqLKxkaou7nvr6L0CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWq234xCb8JZRWLRDKcj9324ddutLM4/+Ni3aKJHS0w=;
 b=jUKBNFskeHE23RniHI3ULQDDgDLObo9Ock3GLK6NDSWHF2VIKzEBR8dPh9J1dohEOg9N+ynz/VfOAWE72pWHawA/0OVBzFB7Z399WDDLPZQ79ijvJMUHYbvq+NVHgP1SMULqm44nxtk8z/TUYefam7WLqouCG8vurTTqZlat8t5shQplCQXANzAr/OwfW/YX1inS//6laKbDgpUZCQGIoHJqSVJHDnHWciYEXWhFZKXD90nI8c80YVNtTr/VnYaZsoZxztsedNCXBMPP4qM1TsXyfYIy/RV7AzjDtg9V4EwHkzRaT0PHoFSYEx66udsGeVSrYadSGnMXX5jzjskgsQ==
Received: from MW4P222CA0001.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::6)
 by PH0PR12MB7981.namprd12.prod.outlook.com (2603:10b6:510:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 14:47:51 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::55) by MW4P222CA0001.outlook.office365.com
 (2603:10b6:303:114::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28 via Frontend
 Transport; Thu, 2 Feb 2023 14:47:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 14:47:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:39 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:39 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 2 Feb
 2023 06:47:37 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 0/7] devlink: Move devlink dev code to a separate file
Date:   Thu, 2 Feb 2023 16:46:59 +0200
Message-ID: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT022:EE_|PH0PR12MB7981:EE_
X-MS-Office365-Filtering-Correlation-Id: 22125dd1-862a-4e75-4b20-08db052c74fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CePZbgmLhzQLkDpLmPGd9bu3+vjmWlbdn/VoBWhrXhId86b7kKpnO2+pufbaU4x/UBVqs5LFl6NMoylsJfEMuXYuLRNwIGV60wMTyqjY7DiRRx2dQ2F57hg/VOsvBcaE/0KAh5ZdnWKtk6Qpebwr2OiJqfABgjEIOSQluA59mnnCxjlBl2btiDd1MxsdPzcBx5D+K9gt6ar+E+o6IOEBYUl8vY+IiWS5fsqdaKXKz0jGmwPMPfNXMx8L5s5YpZ/J/cizyeroHCNJU1Ou6HSu++sYwGGjLTU9TiaWRMrgNM50xH8JzO8tG5SgTTNT3tE7awC64buHT/NfceQZvk7G4ltinzkXwaikPxi08LZ5NidaHwkBPAg53faUg23jL8UiIi8R6lWOJuDaNz1x3utsMtE3ju47eNk+mJQfvmd2gc6N8Sgb+subUZfvuqRgtZJ3EXr2R5l99FOkHpAX+KExqFCU7XMIf0DSqqNNkOKnbEpgRjI5/+7aLA9XzbqPv2bsUOizmXpgv74zJHfZjSdcQs9YSAXyzixF/NrUcK4hClkhsDtbm8fvPa6HoiORwsrhbZpk5VnB7y2GTI3NiudAQFTrtYJjw000dHKZ938X0Tia8PSKXs1b2Yx4yeTTB5HrrMl2jc31bHkeDlkrHGEA/BUQkL9B5bE01scW5/+o2NsWsd0QXQrICeJgO0YIhU6+wQ82lBmq9rnzjX4+R4MH0w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199018)(36840700001)(40470700004)(46966006)(356005)(86362001)(36860700001)(82740400003)(70586007)(316002)(70206006)(7636003)(36756003)(54906003)(8936002)(82310400005)(8676002)(110136005)(5660300002)(41300700001)(4326008)(40480700001)(2906002)(4744005)(426003)(40460700003)(83380400001)(336012)(2616005)(7696005)(478600001)(47076005)(186003)(107886003)(26005)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 14:47:50.1485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22125dd1-862a-4e75-4b20-08db052c74fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7981
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is moving code from the file leftover.c to new file dev.c.
About 1.3K lines are moved by this patchset covering most of the devlink
dev object callbacks and functionality: reload, eswitch, info, flash and
selftest.

Moshe Shemesh (7):
  devlink: Split out dev get and dump code
  devlink: Move devlink dev reload code to dev
  devlink: Move devlink dev eswitch code to dev
  devlink: Move devlink dev info code to dev
  devlink: Move devlink dev flash code to dev
  devlink: Move devlink_info_req struct to be local
  devlink: Move devlink dev selftest code to dev

 net/devlink/Makefile        |    2 +-
 net/devlink/dev.c           | 1343 ++++++++++++++++++++++++++++++++
 net/devlink/devl_internal.h |   30 +
 net/devlink/leftover.c      | 1470 ++---------------------------------
 4 files changed, 1435 insertions(+), 1410 deletions(-)
 create mode 100644 net/devlink/dev.c

-- 
2.27.0

