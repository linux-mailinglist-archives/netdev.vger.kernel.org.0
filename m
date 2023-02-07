Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C26268E47E
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 00:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjBGXk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 18:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBGXk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 18:40:27 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2045.outbound.protection.outlook.com [40.107.101.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B67228D0A
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 15:40:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFo1VcaNNvlnrVPT+Yygg0YYjAsr6eBDVwcmXy3i8ukRWTilSkJvOx9xPahYgAxN4II6rTW93MlB+q3DzZs9BZ2T8ClDOWG6T3NE9zrasDhCz6OXeqCH55jLCO9+YSmEdqulSkMpBugxSwN+ohg6xl1W62NeTKqgn/KYK/bUiWdZxeBJ9I0EIucrbskIscPftIlBUJscXdzQRr7YrTxty7V7BegjIQ1f5FIIden1ZkjfGqew/AfofuPHMpvuojd5NZhlC4XrnncvbqNydcZh/N432Xpt1oskdXctZabaLAFue/NzAa2FIHzACFf0gz3HCemLFkgn18dVNjX48rAT5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxftgNwDXtLSe21rMHRJq7kfoJi32OY9e3c4h4nFK8o=;
 b=W57eZPD+tfQGf2ArE4mJ/HVcqCmLDguJ4cEqYBPxc6dovMSggCK3s9KQeN4tjRVR0nmQ6gFO8v6PXd3pmuMO8PWaWcSpbPp7ClHH5lGjeLMABvmtiA04ceAxyTK7ycHra5Mn/T5yrH3/eQoVGF188HQLA9lQ3QeXCwY+0jArrtUJV5rimPNkZVCaX2XLR02vsTPHobPZrtYdTCT/+WD03PbGgTeG6fVQHAEnk76gPUxU6pBrP0yOZ+/JMuW7OUFT1I1jv1ecdbeZ3dmiAt9UgfA5ImHv/dvm+4JDZxbFIKLbNXImpzkm/XaaiN1dBRLL8xUNzOa8iaYAhE1WWaVTyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxftgNwDXtLSe21rMHRJq7kfoJi32OY9e3c4h4nFK8o=;
 b=DYXoxwxC2xXlDeh1JAi+ieS83mqDjmmP5pHY+qj5xrIWg/h9xWBbQZZOlSMjLKMea5QmD9r9OTME4LioHNKv+Hsx3e7Tsl9Liu67sXaP7LdSYHPyk2vzwXesql9EXwzYtgHZaHNo6tM7SgPjGwozinF01GeYybFAR+N6QUsk/nM=
Received: from CY5PR13CA0016.namprd13.prod.outlook.com (2603:10b6:930::13) by
 CH0PR12MB5028.namprd12.prod.outlook.com (2603:10b6:610:e3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.36; Tue, 7 Feb 2023 23:40:24 +0000
Received: from CY4PEPF0000C982.namprd02.prod.outlook.com
 (2603:10b6:930:0:cafe::e8) by CY5PR13CA0016.outlook.office365.com
 (2603:10b6:930::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.16 via Frontend
 Transport; Tue, 7 Feb 2023 23:40:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C982.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.16 via Frontend Transport; Tue, 7 Feb 2023 23:40:23 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Feb
 2023 17:40:22 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 0/3] ionic: on-chip descriptors
Date:   Tue, 7 Feb 2023 15:40:03 -0800
Message-ID: <20230207234006.29643-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C982:EE_|CH0PR12MB5028:EE_
X-MS-Office365-Filtering-Correlation-Id: 963febef-e9f9-4c1a-cf7e-08db0964af08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6RUeylVcRb0AaPSqfUZXai7GY0U2rYW/iCjvaT4xmRTL+BNzwMAiYIJi8wncK6xbWQ5Ybb1mLZJzZthgSaobxxec48gSeAQJNfwcNZ0hR6JNe/mK505gurAVnCCanHCDR22dCD2gcvF2J+emSOXQ8lR5hI9Eg2msudPRJ770j826GOlMAIM2pi5qBn9eYt9zYIEFOlAvs4V76Z2jLgvAWrRb8mcil5piTloFnfjcYbF0T94HtkdnExZoQ01BqXimdop2MWqqvCdgiRWX8sK1b795LdXaX747WaejtzV/Zi2EGvApMZXm+Z3PWOHWAXc0zKgoOCP7zT+JrN+bIBtab5FRKzj+E81X5QrlKvPCwpIDgdDvDg0NmqrgA+OSH05FzeI5oVpFRUXj98j3wr57RtUK7iiz6kCxx0sTeUGbf+et09xYjK4gcjkX4P5HscJYTcS67kfW1CCrnqQlf0xpVoAfo15jSq+ToxUgL4tE5bMiDZmWgF4uEDwVaoJ9VVL6kkM7YRwx9m+JZpcCgIN3tFmcvPcDYx7z+RhtQoyXPq3UapyH6NlLafKCENHue6x3GqmXYohzdvSZqBttka0tXMpJc8g3XFDQQRsIDGrraNyw9sB+KbF+vWj1xfqO2kTRUGhkojbJ2lXSbO+MZ860bi0P0udBIQv/priEITpHgtpGAmg55Mp6A1j0QVOaFFX0NYOFjP2KVcWmlDrjS2HrSwQWqFrPXpG1nVakc7AuP7Q=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(4326008)(82740400003)(316002)(81166007)(356005)(41300700001)(8936002)(8676002)(70586007)(44832011)(70206006)(36860700001)(1076003)(5660300002)(6666004)(2616005)(478600001)(26005)(2906002)(16526019)(186003)(82310400005)(86362001)(110136005)(83380400001)(54906003)(47076005)(336012)(426003)(40480700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 23:40:23.9933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 963febef-e9f9-4c1a-cf7e-08db0964af08
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C982.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5028
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We start with a couple of house-keeping patches that were
originally presented for 'net', then we add support for on-chip
descriptor rings.

v3: edited commit message to describe interface-down limitation
    added warn msg if cmb_inuse alloc fails
    removed unnecessary clearing of phy_cmb_pages and cmb_npages
    changed cmb_rings_toggle to use cmb_inuse
    removed unrelated pci_set_drvdata()
    removed unnecessary (u32) cast
    added static inline func for writing CMB descriptors

v2: dropped the rx buffers patch

Shannon Nelson (3):
  ionic: remove unnecessary indirection
  ionic: remove unnecessary void casts
  ionic: add support for device Component Memory Buffers

 .../ethernet/pensando/ionic/ionic_bus_pci.c   |   6 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  67 +++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  13 ++
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 128 +++++++++++++-
 .../ethernet/pensando/ionic/ionic_ethtool.h   |   1 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |   3 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 164 ++++++++++++++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  32 +++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +-
 .../net/ethernet/pensando/ionic/ionic_phc.c   |   2 +-
 .../ethernet/pensando/ionic/ionic_rx_filter.c |   4 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  22 ++-
 12 files changed, 417 insertions(+), 29 deletions(-)

-- 
2.17.1

