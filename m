Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFC469A904
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 11:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBQKWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 05:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjBQKWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 05:22:52 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403D72102;
        Fri, 17 Feb 2023 02:22:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qn1EBxy41h14ZQOBjCaVopKp8OJWtaZGngmZR1PplmTOjlVNhsPPgFqrSlV6XWiYp0jhq6UZPcCw4AjYABoAWVCsMzsvJHhWeoheBnTT5+xk39mC4z1WZ+TFmsT5I4U/RamtWgdmERDRQ1qerH18I5IyG062U+Rt5FmNZ2L2kHOMrIca35RBoAB+x+Kv24HwprzbbrcGQo3xz/jDBd8NjUeMefjPknEadIZ0eaTisulNO5Tkb06STYR3M7/FdKU5BCYDQ29X3QUx6AIdgQTj3YFRu2u+OGxZPaNSyXvc7L/IZUaiix6LaV5/Mloaq8+Umq6j9Hi03+ynbYatX2dGPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3kocTw3bqdcCt2BPz1Tdebp/ArGqbsCl7MPy2nxTlfI=;
 b=ZbwjhThtAKzYfgt4Xjz/dzAwydFTXQZsfOOAFFXacvbrqdpdrFJ9Us8POMlB/HY3g66S9fsu3gCtOnamB7anQNEigC61tx+vUOAVj3HLpZ9Zr080bQRgqYnaIFevFh52HvprabsWrHDsovA2P3h/WtcjVyfvLIgvr4GLxqSdcA/ThUgD14kF+tcCzvypgkiOxNilpszWPZqvlsrg6zaYfSr2A5ru0eppa7fdhq0hpNusB628b6gf0r1/Lr4aSPfKg207MR5jJPsnB0mxzKk1+ER6hFEDiXxfVDLdXxDQlYoNFW1Z2Y+OawYkWUTeZ7pClq+hBnlpHFvL4phR1tlwrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3kocTw3bqdcCt2BPz1Tdebp/ArGqbsCl7MPy2nxTlfI=;
 b=h1nuDMIUXgvJAtYwdT2a+0Faf7g+IEGrjY8cDcUpSWdpP/hdA0GA+xTf++2yLZM0kYnIK/etOhXOTLj8kBEgJnLF9u49cgJN6OpysALJ4r0mcDJJr8RFT0796xc3qQAjNthtdu2cL1f4JxMmnIlNsFneeUSyEYf0LMLDyLUSdv0=
Received: from CY5PR15CA0037.namprd15.prod.outlook.com (2603:10b6:930:1b::34)
 by PH0PR12MB8049.namprd12.prod.outlook.com (2603:10b6:510:28f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 10:22:47 +0000
Received: from CY4PEPF0000C971.namprd02.prod.outlook.com
 (2603:10b6:930:1b:cafe::f2) by CY5PR15CA0037.outlook.office365.com
 (2603:10b6:930:1b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17 via Frontend
 Transport; Fri, 17 Feb 2023 10:22:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C971.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.8 via Frontend Transport; Fri, 17 Feb 2023 10:22:47 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 04:22:46 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 04:22:46 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Fri, 17 Feb 2023 04:22:44 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH] sfc: fix builds without CONFIG_RTC_LIB
Date:   Fri, 17 Feb 2023 10:22:36 +0000
Message-ID: <20230217102236.48789-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C971:EE_|PH0PR12MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: b15b042b-26a2-4e38-3370-08db10d0ea37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mDwgAtJUe+kTprPzmJi0p+58KukEV/rjWL7Gq8fzMg1xQ2QsiUktrtSwcMCGHBl2ElUcZQxL1XiKzyw3ltkw59/CTIu3mdhClVn8d9HqUhPN5zzAuh0RgMuT6BtpVdYtXk+IiLSVHsNCp2kYNdgLwuWOK3JpFP8RlM8h109ZmtsPO48Y6T0re2f435NRumqFR//DtbN0r+zz1+XaJN3k3fb5B2S1eSULXam61vW8+mfOM2lmGHJDToNzN62ebh2ihUuVI5feATRIGIdFwHOK3Iewccnr7tceJGSpLoV3s41wkdJUJccX99i3hr0bDCxMNgbapgMzSRctC/whNnE7tBZ3uVDMrdrkwSUQd/727DkczbPi+uk+Nao1YdnYAOr0HqRc/9JXbJAfpH4M99C8ZmiWUwESZ0N2zCNTtCDInUPDf2kM3QuFDeaVKI6DeKk0m/4rOUhv5kyfhRVLRtC3Spe3h3iP/B+oxqGco/PA2odnRGeCOnXOkETEURkhGHiEYAdbRqPsNkeKX+KmsrdPcM3v2SzO8JMER5n7vGuMl2WSK0X16bDy4/ZEBilBm4dn4C1/T8aT/DWMqhelPzkjMsjvmnY14wyQ/CsbHS5fSt/1alF3M2hGLoMh+IZ21ePLc1eugESZSHAZHc7GhQPokdkBhwzD34JLitw+/OVTxoL8LAIvLcZHuGLEi6EtcEoUOdYKb13yP+sB81RcgQg20MvfaWSK3SpdVrQrlLzcUmM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(40470700004)(46966006)(36840700001)(966005)(36756003)(2906002)(2876002)(336012)(86362001)(83380400001)(82310400005)(40480700001)(2616005)(47076005)(82740400003)(81166007)(356005)(40460700003)(36860700001)(8676002)(8936002)(70586007)(5660300002)(6636002)(110136005)(70206006)(54906003)(316002)(4326008)(41300700001)(7416002)(6666004)(1076003)(26005)(186003)(478600001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 10:22:47.0691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b15b042b-26a2-4e38-3370-08db10d0ea37
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C971.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8049
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Adding an embarrasing missing semicolon precluding kernel building
in ia64 configs.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202302170047.EjCPizu3-lkp@intel.com/
Fixes: 14743ddd2495 ("sfc: add devlink info support for ef100")
Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index d2eb6712ba35..3eb355fd4282 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -323,7 +323,7 @@ static void efx_devlink_info_running_v2(struct efx_nic *efx,
 				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
 		rtc_time64_to_tm(tstamp, &build_date);
 #else
-		memset(&build_date, 0, sizeof(build_date)
+		memset(&build_date, 0, sizeof(build_date);
 #endif
 		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
 
-- 
2.17.1

