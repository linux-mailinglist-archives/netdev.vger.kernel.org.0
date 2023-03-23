Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891036C71D2
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjCWUrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjCWUrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:47:40 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB7B1C7FE
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 13:47:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDxGvN0d6SZndzC5YWYA5w3/DiTBvBDNYp29z3QWV6WEsCEg4I03U5hNen7WIz53jYPS7SeF0ykdKtID+n6L7XhEbZFvMX1cHbikSStnZO0hnrpUfSTH+hShCncMQ17Y5YV8moumWS53u4cQ1WyQtBzuOZJCBA3QYHBGFUS8FYnQDAREYoIEnEVHwYa24Ze5B9MQO5ivuiQLewj3oo7y0r+Z++uHlP2Gwv8UpO3tbvgSNREwO8Asl7vai8SaKceXv6VuO+GE/7NoW+QHiA/izfASd/Gz0bxPl0R1Q+Tfww9lS5lJjx6tnvVXoiVEmaioRcbrzBex6/lLXzZCHGqotw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fw8Hio5RLLIhrEi+tYRAkl0AZzkN5u5JjzaRqizN4jQ=;
 b=jUWoSArEjXgev5pW9QDHDYj3vSRvgjJ7tXoWVrKmkP1CYdZuQUblLse6Iz+kJ9HoiJ86fkJdmdkQXCS3q/gv5eGLMidODKbbRYV+sMvqWgWs5+rVPkZqRNYagocQShGFpjjf3ep9NmjDiSb5DZhtBJigTvNXyrfj1j8BEuxfIm6u1gcFH1OjtK/9TiIhUVFvvvcVlfTcBwXf1dKuaCzsFtRjhChwsX30h+mzcdH5+/sblpCf4zgP75vsjhC7a8+jSiny66F9me0R+cKJpAuk7khz9wGoasZi4eCDKMwvxeKEucq1Mh/6FBmfhSWa35a9lsAHbijnVixTwSBhCZGhhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fw8Hio5RLLIhrEi+tYRAkl0AZzkN5u5JjzaRqizN4jQ=;
 b=b3M9MWAHWnErLUHeDlZqjVvgcGZk1Scf9hurDo52lXZd8L7Mi4FOCJt5oT0x9OC8JiRLzB6bQl45ur8ucqDED14a2XsBbUdbe9nyDVil2w00fPgShDnoHQSSaNQMSQziRSo60uYaQnswyjkn6WC9bBXkw7+rjVB7Pe4IXO6/pj0=
Received: from BN6PR17CA0045.namprd17.prod.outlook.com (2603:10b6:405:75::34)
 by DS0PR12MB8454.namprd12.prod.outlook.com (2603:10b6:8:15e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 23 Mar
 2023 20:47:34 +0000
Received: from BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::3f) by BN6PR17CA0045.outlook.office365.com
 (2603:10b6:405:75::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 20:47:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT070.mail.protection.outlook.com (10.13.177.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Thu, 23 Mar 2023 20:47:33 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 23 Mar
 2023 15:47:33 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 23 Mar 2023 15:47:32 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v2 0/6] sfc: support TC decap rules
Date:   Thu, 23 Mar 2023 20:45:08 +0000
Message-ID: <cover.1679603051.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT070:EE_|DS0PR12MB8454:EE_
X-MS-Office365-Filtering-Correlation-Id: 00c1bfe1-fa9e-4ede-e79c-08db2bdfd40f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ErgzVd5mWx3dn4wGafBdnGfUbAXbxzCCsS+dsbAkqy9w/AsmOGwhjmA0dGfMNFGUhRI93NBaBLxFEJEp45T/eRucvQEGfdd1V4wSag50YXdB5lhRHJR4KCaaicc0fUiJ8brv5duD1pS/19jaYVCGJe9CES3ov+yhh3JokKW0k065KI+hLbDG7tgdEG/5gH+1+iHd5vgVw3xocW75rSlTazV9nagzaXkVHe0benOuvpULZwWTbqQovJ5IIvf9JF+IPTnx6sBJiPYofh84u9aFh+0TJd6T/u08CWwYrZ6mwQzXGYo8NUmW/AMQ6iZNdKTWTFzuq/ywakKaZD418+Zd4300SR8TpXoSxmNEWbk7JDU4dpTT2FF6irT0y/FGooFpW4sioe0FK8MDSd7GG5Kl4HR+rPIbWtcEdNIRBkqkGbhLll7Zy7Yl8U6fPjCBktmLC0EXD9OQQwSTtUPPR3KyfmlnM0VqBLcB9uUXx04WpSTSPxSHk5fTs2hdc/nl+Pqgu/4qcrO7B9UG3Uds8/coxyfnYmW9aJbXd/Xzoibr8qgxC1TSVUi58DJBS1xLNoQuQFgtFWodny0/DFEvxPovq2Af7qxa4UcVlrumhgCWH0xPv56PQSQzZKWfWpQ6mY7HEGQybX2tmU1yCLxSc6vyDa4ucpIvZrskWtU5b9eXWUQ6Fwm7NdnOboWiXKwI9wt04A9dwmb2sVb7cg6XHoxEgWBK8V1UUnnDXZN3nDMDVBc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199018)(40470700004)(36840700001)(46966006)(55446002)(86362001)(356005)(36860700001)(82740400003)(36756003)(81166007)(41300700001)(2876002)(40460700003)(4326008)(2906002)(5660300002)(8676002)(40480700001)(8936002)(82310400005)(426003)(9686003)(186003)(47076005)(54906003)(336012)(83380400001)(26005)(70586007)(110136005)(316002)(6666004)(70206006)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 20:47:33.8101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00c1bfe1-fa9e-4ede-e79c-08db2bdfd40f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8454
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

This series adds support for offloading tunnel decapsulation TC rules to
 ef100 NICs, allowing matching encapsulated packets to be decapsulated in
 hardware and redirected to VFs.
For now an encap match must be on precisely the following fields:
 ethertype (IPv4 or IPv6), source IP, destination IP, ipproto UDP,
 UDP destination port.  This simplifies checking for overlaps in the
 driver; the hardware supports a wider range of match fields which
 future driver work may expose.

Edward Cree (6):
  sfc: document TC-to-EF100-MAE action translation concepts
  sfc: add notion of match on enc keys to MAE machinery
  sfc: handle enc keys in efx_tc_flower_parse_match()
  sfc: add functions to insert encap matches into the MAE
  sfc: add code to register and unregister encap matches
  sfc: add offloading of 'foreign' TC (decap) rules

 drivers/net/ethernet/sfc/mae.c | 227 ++++++++++++-
 drivers/net/ethernet/sfc/mae.h |  11 +
 drivers/net/ethernet/sfc/tc.c  | 600 ++++++++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/tc.h  |  37 ++
 4 files changed, 857 insertions(+), 18 deletions(-)

