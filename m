Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206E6691F73
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjBJNDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbjBJNDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:03:41 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2060.outbound.protection.outlook.com [40.107.100.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494AF7396C
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 05:03:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuFfZ1Y2GwjSXBTH+FuD4OqEJdYq40EUefZeZ3Crj0UiwPgXL/k8lPBAzq6UsfAXHCYnevE4VQj1UBf56UK6ndsserczck7S53dTkr6cPD3opSgz4aosA6/PAzs46RdYX4V7+x9XMDuqCynqK5mXDo++8idnZWAVU4wsVRNDal6o5NYxGm4xQbNUcLi8EbCva7BrWWrbMqEekhM+oiq76rCmOey2jFNhXN+pgu4XAg5PuKt5SQgMp4uPZSyqEYpxxonX9P+y5DSnWBwez5kjmtyih5ZuWhhAZTVeNB/L6UtJNgxMaXvjbREmOTOLgyct8JeWB20r7duPpXbHmfw6TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wYH0bnHcVI/TNIS/CADeDb19tKHrorfFMBo/nX+fL+k=;
 b=BdaVR0VPIHlJ6SaMlz5VnTcy40fBE6TCVQcx5R+Urrq4qKqbVYrjkMYbsGtENxShTxeB37xeyei3Jy9e6DZtSdJOIJr0uV9Dz5SEkVXx+recxKw847kfNXzSdGgFq6dcHY9Ml/eELQDcPK88b5QaUpzo8udGMRw6bmLX2YR49jH8SK1vEUEvme+56yGVh3ccSLmhowZOvJj6xtyfbaJRyQiEHEXwPDJmL+1lshr7qBILLXi3NolCNyWv6jwaSRiOvoJgh3WyYi0NHsoXaEyHztBLNqpOK7eRKcjq6PJnJ7EGG5bx22bgO0TVHlP2LEFZIX7wGHdn4W+/hfP14vq+Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYH0bnHcVI/TNIS/CADeDb19tKHrorfFMBo/nX+fL+k=;
 b=ltWdY56+twNnDgzA7uYrXUYLBg/eX80jJl0JRorYSMI39p2rzWOnu9EXw1UJCSfDEDATh17nWEVQfAaZXXoXGugMQnZZ3ii6lH6hV2fTgl0K2cEvIro/cADqnSvWXzh0IRA1A5OcQHr78g/r+gXjUaMVzEzq3oa/YAadZkJSZO0=
Received: from DM6PR18CA0002.namprd18.prod.outlook.com (2603:10b6:5:15b::15)
 by SA1PR12MB6947.namprd12.prod.outlook.com (2603:10b6:806:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 13:03:34 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::d8) by DM6PR18CA0002.outlook.office365.com
 (2603:10b6:5:15b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Fri, 10 Feb 2023 13:03:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.19 via Frontend Transport; Fri, 10 Feb 2023 13:03:33 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 07:03:32 -0600
Received: from xhdipdslab59.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 07:03:29 -0600
From:   Harsh Jain <h.jain@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <thomas.lendacky@amd.com>,
        <Raju.Rangoju@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <harshjain.prof@gmail.com>, <abhijit.gangurde@amd.com>,
        <puneet.gupta@amd.com>, <nikhil.agarwal@amd.com>,
        <tarak.reddy@amd.com>, <netdev@vger.kernel.org>
CC:     Harsh Jain <h.jain@amd.com>
Subject: [PATCH  0/6] net: ethernet: efct Add x3 ethernet driver
Date:   Fri, 10 Feb 2023 18:33:15 +0530
Message-ID: <20230210130321.2898-1-h.jain@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|SA1PR12MB6947:EE_
X-MS-Office365-Filtering-Correlation-Id: 963c953f-fa64-414e-846e-08db0b673774
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xHOTVBl71ipm5x6rWMbPkWKaKuqseXkIXcFDctPtHPuV8ylPvb6lB8nuy67AZkEPwEJzTzog/3fMJFgHJl8y97P1yiapv5ow+lH1tzY2W3NDQq9wvIJmXbBtxSn2++1L48AyR1ptpuQuw1y/wQtOcenPu7mkyLcdmmWJQQr9EVVyroi2zEo3HUw1zmOOmMnhViDfAIBEK0EHlYtibEX1mXsVA58nHYdf9snqZvgSc1C6+6v/yvIaa8t1TBxHoIS/dGb7Cccp3SuEzqkMSEB1kh8ksddm1NyMvjzWsQ/zWzWNq6ofwuYlDgywyHa6qqJztaZTdo9hCly7d03zpsZqQzb1Y6vpG/+bC3tMeJ2s+crl15jAX6TggE1KbMeCXc7kgRiJEwdeA3LRLNuYnguvbnlcN/VOq536Ev2yEN+GHxgDxboiA/prqcDx66mKAWkNiENypDWeHrOh0eOd7BWBnNS7j7rSsQ3lycW4tY+NTousnhA92vjLG1ROiUlV3nQHnYcSeiU4ZYdph2KoFQLD1YcT5/p0K29216WXpRTVvvO+SJQ253EPFJYO8OwVu5ltKEU8OOXRCgahFJxZCkEyFqGhSkINvhhIs1JN1AN9RUCMEehn/nD5RVChltwaQnhK9mHlZQha/JIm/LWBBssLDHhUQslhThrZyTaNLW0vogaGN8NLzE/XtgfmzrHY214X1yFEdoQNQKh0dpRveog7RfklEXC/PkMg+NrPJ8ZlyxUIp5hrdrsC+x1hbiSwmg+t+nK8ZiRTCeUmAzS2Q970+A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(2616005)(26005)(86362001)(478600001)(966005)(8936002)(6666004)(336012)(186003)(1076003)(47076005)(426003)(110136005)(40460700003)(8676002)(4326008)(921005)(356005)(70586007)(41300700001)(70206006)(82310400005)(81166007)(2906002)(316002)(82740400003)(40480700001)(5660300002)(36756003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:03:33.9539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 963c953f-fa64-414e-846e-08db0b673774
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6947
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds new ethernet network driver for Alveo X3522[1].
X3 is a low-latency NIC with an aim to deliver the lowest possible
latency. It accelerates a range of diverse trading strategies
and financial applications.

[1] https://www.xilinx.com/x3

Harsh Jain (6):
  net: ethernet: efct: New X3 net driver
  net: ethernet: efct: Add datapath
  net: ethernet: efct: Add devlink support
  net: ethernet: efct: Add Hardware timestamp support
  net: ethernet: efct: Add ethtool support
  net: ethernet: efct: Add maintainer, kconfig, makefile

 MAINTAINERS                                   |    7 +
 drivers/net/ethernet/amd/Kconfig              |    2 +
 drivers/net/ethernet/amd/Makefile             |    2 +
 drivers/net/ethernet/amd/efct/Kconfig         |   40 +
 drivers/net/ethernet/amd/efct/Makefile        |   13 +
 drivers/net/ethernet/amd/efct/efct_bitfield.h |  483 ++
 drivers/net/ethernet/amd/efct/efct_common.c   | 1314 ++++
 drivers/net/ethernet/amd/efct/efct_common.h   |  134 +
 drivers/net/ethernet/amd/efct/efct_devlink.c  |  829 +++
 drivers/net/ethernet/amd/efct/efct_devlink.h  |   21 +
 drivers/net/ethernet/amd/efct/efct_driver.h   |  788 +++
 drivers/net/ethernet/amd/efct/efct_enum.h     |  130 +
 drivers/net/ethernet/amd/efct/efct_ethtool.c  | 1286 ++++
 drivers/net/ethernet/amd/efct/efct_evq.c      |  185 +
 drivers/net/ethernet/amd/efct/efct_evq.h      |   21 +
 drivers/net/ethernet/amd/efct/efct_io.h       |   64 +
 drivers/net/ethernet/amd/efct/efct_netdev.c   |  502 ++
 drivers/net/ethernet/amd/efct/efct_netdev.h   |   19 +
 drivers/net/ethernet/amd/efct/efct_nic.c      | 1558 +++++
 drivers/net/ethernet/amd/efct/efct_nic.h      |  104 +
 drivers/net/ethernet/amd/efct/efct_pci.c      | 1099 ++++
 drivers/net/ethernet/amd/efct/efct_ptp.c      | 1481 +++++
 drivers/net/ethernet/amd/efct/efct_ptp.h      |  186 +
 drivers/net/ethernet/amd/efct/efct_reflash.c  |  564 ++
 drivers/net/ethernet/amd/efct/efct_reflash.h  |   16 +
 drivers/net/ethernet/amd/efct/efct_reg.h      | 1060 +++
 drivers/net/ethernet/amd/efct/efct_rx.c       |  591 ++
 drivers/net/ethernet/amd/efct/efct_rx.h       |   22 +
 drivers/net/ethernet/amd/efct/efct_tx.c       |  330 +
 drivers/net/ethernet/amd/efct/efct_tx.h       |   17 +
 drivers/net/ethernet/amd/efct/mcdi.c          | 1826 ++++++
 drivers/net/ethernet/amd/efct/mcdi.h          |  373 ++
 .../net/ethernet/amd/efct/mcdi_functions.c    |  642 ++
 .../net/ethernet/amd/efct/mcdi_functions.h    |   39 +
 drivers/net/ethernet/amd/efct/mcdi_pcol.h     | 5789 +++++++++++++++++
 .../net/ethernet/amd/efct/mcdi_port_common.c  |  949 +++
 .../net/ethernet/amd/efct/mcdi_port_common.h  |   98 +
 37 files changed, 22584 insertions(+)
 create mode 100644 drivers/net/ethernet/amd/efct/Kconfig
 create mode 100644 drivers/net/ethernet/amd/efct/Makefile
 create mode 100644 drivers/net/ethernet/amd/efct/efct_bitfield.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_common.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_common.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_devlink.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_devlink.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_driver.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_enum.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_ethtool.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_evq.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_evq.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_io.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_netdev.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_netdev.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_nic.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_nic.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_pci.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_ptp.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_ptp.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_reflash.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_reflash.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_reg.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_rx.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_rx.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_tx.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_tx.h
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi.c
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi.h
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi_functions.c
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi_functions.h
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi_pcol.h
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi_port_common.c
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi_port_common.h

-- 
2.25.1

