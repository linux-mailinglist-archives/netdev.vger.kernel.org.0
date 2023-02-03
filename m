Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7186168A406
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbjBCVCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbjBCVB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:01:57 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C83A910F
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 13:00:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7Ry92B2o1v4VwhCFg2vKqj1HETjkArr8teB4+BI0dtWujCOuZf4rdztX9sqGiEqbGOrmcVzd/ETLbySdK2jtAcWKmRn5m/ziNJgTc8+4n8iRs9wNFRrQveqnOAJTLw0+1g6cJw/dL/Yja2jeXalxbEwtQYpgGyTIxu1mTmLDB9EFxbbia8m16S4xA/A4NvKbsolPGgLRfYPmYnTMCurSzwYSCGUsFgd6zdc/n9yKhOh+tRH6JpdX6LfSqqeyff7XvQ4sL4nKhw62He3r2vgLjd7PFQGqrubFJG99CkuwCiftn9ih9L3UtKhkj+iNMbTbUmd3VE2G/dofpZZicEtJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUL4p7hI1LSmUvgl8hHgrkWNwSAks0JiSczpxlupNtw=;
 b=IKVyAn8MTr15BHqu9yieZie+t0QHQi0Wi75qc5ULhVjRLx7FV/GwQie21O1LzHo7okuhM7Wxt6GyEoByYpvX5DWUbbxoZ+kNzA/9B70po8sRgdZr4y/KS9NNZjnhD00Cy1w34UU47w3XEYwZnPZQBfm1p7ztu7IF3T90ht5g9RYYnF9x0G2nihjMxKHPwuJqJ5iwowgCorb0I0Zbwwp9sZb7815WBQ72oFGF2n/bmHMhQqTULrnV3Kqm9+9tzFnzlBTIaW2gByeHyom7chxYASLqd6jwKyS9ZL3gJJdHCeNp4n58anyH5JBAvDkLa0zhveWxNNUoHa6bHvl6Tgqtkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUL4p7hI1LSmUvgl8hHgrkWNwSAks0JiSczpxlupNtw=;
 b=Xw3dVzaBdbSQZghw1RCA6cOgCN8+5KGhPO/6MPv367MkiPFCD1GZFUURTdf+b+6BD5ZiGtLtPtJ/XlDRHULU+mFFrFs7mkGL0hg8NFovE7Xvk5fj+CWwPTaWA8aIZS4RnHtevQbQNE3m7/GBGYLH+b1dUCz61+OKZZC2qoN256I=
Received: from DM6PR18CA0017.namprd18.prod.outlook.com (2603:10b6:5:15b::30)
 by CH3PR12MB8187.namprd12.prod.outlook.com (2603:10b6:610:125::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 21:00:39 +0000
Received: from DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::68) by DM6PR18CA0017.outlook.office365.com
 (2603:10b6:5:15b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29 via Frontend
 Transport; Fri, 3 Feb 2023 21:00:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT097.mail.protection.outlook.com (10.13.172.72) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.31 via Frontend Transport; Fri, 3 Feb 2023 21:00:38 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 3 Feb
 2023 15:00:37 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net-next 0/4] ionic: rx buffers and on-chip descriptors
Date:   Fri, 3 Feb 2023 13:00:12 -0800
Message-ID: <20230203210016.36606-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT097:EE_|CH3PR12MB8187:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e6adcc-6f1b-4c24-3ca7-08db0629b435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CqiqwAXlPxqVlviRXr0pCxAtJYYyVCEXj546YNl0H/IDHRy82qRQZoLHsUucjOBjhulkBIliDe8IYwpsuRF003pwszRN8KSW+WvmrGz26U91TkGQteDAgrGFGJmffjlz317get8THeiQUbgQ4m1rvDraKahOZTIwZK8pMemtHmWEDVz8SxhQGQm7D3qZiNyIPe+O7vFKw2Hh+kZvPXA2NpboimHs76fVXzFiVngf1M55690+9oTY21hfjT+qH6h5bBGxPAHOvsZvlld2uRM7dAMsHajbl24QQZ+kufaOdTlE1ne0P75qaZa2MvrImp2UqpvxN1nL06OaKIhMr1u/8lAaqgNYSmW7atpER9wVnewBn5kj+9MNbMoaF2MxUjrzdML+DBEXvS/AmQAW66k79tO73idgdGc4KEztlZys+lL4918E1F2PPDWxfH8PTOuF3cZBMgYQVf4NKGK9k+K4xVBm8iUeoh13JTg0C85URS+ih1OiX18zczQPjDIvTp9n3mhn+Ry9QMq2XBfmSSCV0X5ng5vdBQ5++FvBz+zstQSA9CEzvNpGFGN3rsA3qU+6jbSALJ/VNCIUcsVgCkgC70rL0DpTimdcy7fUeYzOPe8DW83mXEQ3ME979MgJN5CaMwesBQU4xrCx7lwVbCpOJC/y9d/ctrgkPjZ1hiTmUuRk+dV8FdTBhomEX2U+8szmJZXLnHj1zYXuzivOSjCFNR9JqIMl1Zo3t3H7A2MAsA8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(356005)(86362001)(36756003)(81166007)(36860700001)(82740400003)(316002)(8936002)(41300700001)(4326008)(70586007)(70206006)(54906003)(110136005)(8676002)(5660300002)(82310400005)(40480700001)(40460700003)(44832011)(2906002)(336012)(426003)(83380400001)(47076005)(478600001)(2616005)(186003)(16526019)(6666004)(26005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 21:00:38.9089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e6adcc-6f1b-4c24-3ca7-08db0629b435
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8187
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
descriptor rings and Rx buffer page cacheing.

Neel Patel (1):
  ionic: page cache for rx buffers

Shannon Nelson (3):
  ionic: remove unnecessary indirection
  ionic: remove unnecessary void casts
  ionic: add support for device Component Memory Buffers

 .../ethernet/pensando/ionic/ionic_bus_pci.c   |   7 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  71 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  29 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 128 ++++++-
 .../ethernet/pensando/ionic/ionic_ethtool.h   |   1 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |   3 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 164 ++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  40 ++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +-
 .../net/ethernet/pensando/ionic/ionic_phc.c   |   2 +-
 .../ethernet/pensando/ionic/ionic_rx_filter.c |   4 +-
 .../net/ethernet/pensando/ionic/ionic_stats.c |   8 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 318 ++++++++++++------
 13 files changed, 644 insertions(+), 135 deletions(-)

-- 
2.17.1

