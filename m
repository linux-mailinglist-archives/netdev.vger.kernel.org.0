Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D166ADD94
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjCGLhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjCGLhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:37:07 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A6E41B77;
        Tue,  7 Mar 2023 03:36:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTtOlz7y/uXAzkDHbTXo4vZt2AYM3FO1Zq3ie8D3CPcs+iAXYujVn/AANULDRkg24BazGVaFwMXr1MDHb5Q1HsMAVaRwWsDm5j8ikO0GcGIsTMl4B50e3sN+wlKXH7y0AlWkTXl77mTnrUJngvNRc8EUgcFYJxxKZA08CV7K1qZMN9EF0a/C1BSpN/hYNL2kTCz5kiG5P09ua91K0NOuLzpuBk44p3FZTzZ8JdmG89F4c9xCctvZJczsRQOjcGpKtf/svZczjAN4JaFA/slTbrXffaJH1bkP3vesyN/Ev97ODULMsfPr79erNL8hZnstevCr69rkqsSJzR4kyz0WqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fepNU2V0fiIO4a5+DeoAf/ggvu3xteruRRrkTZ/wxPg=;
 b=K+OPslfJuergIm3KdtYsggW/H201Ywcy3jtSHLY/Y2gbkOseGoQncXYh3VMxDshr7BzcK/y7YZXb9a25RP67IfU/0Pol08OB78NX4i8D2fx7KClboWNtt3b6vMS1hTx3yuvX5riMiM2k6ZkYDYDNtC8rWzlTIDrnAk7ynaKwbB6jyz/m1vW3+ObtxFeQogWn5krfaIqDTVPisW636XrdsuNwkSAAmQ7oA27jwjuIx4QNZHvabyEZ0Vuo4qGHCGN2kMqgPwCMSt9+TgQgUawwhSWdbjXNSixUNWHsW5qKdJP1UZNshka+SN/T1NTzqYrANWcWMnznpe2DkfJ0BBV64A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fepNU2V0fiIO4a5+DeoAf/ggvu3xteruRRrkTZ/wxPg=;
 b=v+fM52qZlj5jO/OXLiDGwfh6ZnReydtdHsGwjnpzjnEk4tXgZaeFDnoa8B09pZ5LOQ40DGLXTY8lALm5fpwoa9F5CDEj0Upa1ALjrYv5r4+BdmPQh8zMPoIP3bBlNqfAFjTWFr1Ud/ERDdRrAEMjaxYYigvHAltA+4e5PtgpxQs=
Received: from BN9P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::17)
 by SJ0PR12MB6710.namprd12.prod.outlook.com (2603:10b6:a03:44c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 11:36:33 +0000
Received: from BN8NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::78) by BN9P220CA0012.outlook.office365.com
 (2603:10b6:408:13e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 11:36:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT093.mail.protection.outlook.com (10.13.177.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 11:36:33 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:36:31 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Tue, 7 Mar 2023 05:36:27 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <jasowang@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <eperezma@redhat.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, <koushik.dutta@amd.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Subject: [PATCH net-next v2 00/14] sfc: add vDPA support for EF100 devices
Date:   Tue, 7 Mar 2023 17:06:02 +0530
Message-ID: <20230307113621.64153-1-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT093:EE_|SJ0PR12MB6710:EE_
X-MS-Office365-Filtering-Correlation-Id: 25311e8a-93e8-41a8-6319-08db1f0033b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Mtr0sBz3983gjE4t5IFLG+SyP56mMGgyvkjeGC0VY+hnAscTOZ+9tbQS9vOoiWYOSHRhqvkkGLU1S75dBTPckkqK0w6F8zHb1N12Hypf+T5O5zhmYT4m9Ue+U0Zhhn8/UK1tK2fufmo1Pa2Ip7xcwsWZaDWFLq8NwM9hAa8LE4e71Per727FSJKa7vXK0g9G+zQiEFX21FkW/dhBqCddRnvCYrlpc7EadMdfZ0WjuZWQXRhUK9/tPc7J5jb31VzvKFhxcI2E0yhyGSSXEvDtxjiPVALFgqHS05JTHELKZXTMNlz+yWpyD487oudzyheKxXjVeOjkYIu+VPFXq1+KBd/xOT4/6TpHBnE5dDCu8v1YtUceG/VyWD4CB9Af8Ym40N4aKNNapi2OWyToe0sgA1IzL4NcdU9qcdRamAQ3v5nIqGzzphyNJGHCynh18+9Zr2L+7o5YmI+1KN2NWn7CoY059KlhMp1zDps9wUKfvBx6xsAAaVkv6l/oAA28Q3pCo3Kbr7B4/fks0I38ya0HXIFjiell8foGZD8hQltUyG/z65P5qoaIM01B5+wmhfc8t2sd6mzkRztjKRHinePDS5/73lSLsTFg687aFn7rWH18rr1wqdfL9y9xYWxiXK/l9EZVp+TuAisdCsqS0hQAQsAKENNv+4R8LXHoX1lEsmrGI+fCvPOWlNehD8slk/HHEAEYVXdIM6mqDLLb57M15pB3rmE5LDlKKtnUYCJqa1iDDMyF62+nQjsJWfZhtyn
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199018)(46966006)(40470700004)(36840700001)(44832011)(82310400005)(478600001)(5660300002)(7416002)(186003)(26005)(83380400001)(6666004)(1076003)(86362001)(336012)(2616005)(47076005)(426003)(36756003)(36860700001)(40480700001)(356005)(921005)(40460700003)(2906002)(82740400003)(316002)(41300700001)(70586007)(70206006)(8676002)(4326008)(81166007)(8936002)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:36:33.0378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25311e8a-93e8-41a8-6319-08db1f0033b2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6710
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This series adds the vdpa support for EF100 devices.
For now, only a network class of vdpa device is supported and
they can be created only on a VF. Each EF100 VF can have one
of the three function personalities (EF100, vDPA & None) at
any time with EF100 being the default. A VF's function personality
is changed to vDPA while creating the vdpa device using vdpa tool.

A vDPA management device is created per VF to allow selection of
the desired VF for vDPA device creation. The MAC address for the
target net device must be set either by specifying at the vdpa
device creation time via the `mac` parameter of the `vdpa dev add`
command or should be specified as the hardware address of the virtual
function using `devlink port function set hw_addr` command before
creating the vdpa device with the former taking precedence.

Changes since v1:

- To ensure isolation between DMA initiated by userspace (guest OS)
  and the host MCDI buffer, ummap VF's MCDI DMA buffer and use PF's
  IOMMU domain instead for executing vDPA VF's MCDI commands.
- As a result of above change, it is no more necessary to check for
  MCDI buffer's IOVA range overlap with the guest buffers. Accordingly,
  the DMA config operations and the rbtree/list implementation to store
  IOVA mappings have been dropped.
- Support vDPA only if running Firmware supports CLIENT_CMD_VF_PROXY
  capability. 
- Added .suspend config operation and updated get_vq_state/set_vq_state
  to support Live Migration. Also, features VIRTIO_F_ORDER_PLATFORM and
  VIRTIO_F_IN_ORDER have been masked off in get_device_features() to
  allow Live Migration as QEMU SVQ doesn't support them yet.
- Removed the minimum version (v6.1.0) requirement of QEMU as
  VIRTIO_F_IN_ORDER is not exposed
- Fetch the vdpa device MAC address from the underlying VF hw_addr (if
  set via `devlink port function set hw_addr` command)
- Removed the mandatory requirement of specifying mac address while
  creating vdpa device
- Moved create_vring_ctx() and get_doorbell_offset() in dev_add()
- Moved IRQ allocation at the time of vring creation
- Merged vring_created member of struct ef100_vdpa_vring_info as one
  of the flags in vring_state
- Simplified .set_status() implementation
- Removed un-necessary vdpa_state checks against
  EF100_VDPA_STATE_INITIALIZED
- Removed userspace triggerable warning in kick_vq()
- Updated year 2023 in copyright banner of new files
 
Gautam Dawar (14):
  sfc: add function personality support for EF100 devices
  sfc: implement MCDI interface for vDPA operations
  sfc: update MCDI headers for CLIENT_CMD_VF_PROXY capability bit
  sfc: evaluate vdpa support based on FW capability CLIENT_CMD_VF_PROXY
  sfc: implement init and fini functions for vDPA personality
  sfc: implement vDPA management device operations
  sfc: implement vdpa device config operations
  sfc: implement vdpa vring config operations
  sfc: implement device status related vdpa config operations
  sfc: implement filters for receiving traffic
  sfc: use PF's IOMMU domain for running VF's MCDI commands
  sfc: unmap VF's MCDI buffer when switching to vDPA mode
  sfc: update vdpa device MAC address
  sfc: register the vDPA device

 drivers/net/ethernet/sfc/Kconfig          |    8 +
 drivers/net/ethernet/sfc/Makefile         |    1 +
 drivers/net/ethernet/sfc/ef10.c           |    2 +-
 drivers/net/ethernet/sfc/ef100.c          |    7 +-
 drivers/net/ethernet/sfc/ef100_netdev.c   |   26 +-
 drivers/net/ethernet/sfc/ef100_nic.c      |  183 +-
 drivers/net/ethernet/sfc/ef100_nic.h      |   26 +-
 drivers/net/ethernet/sfc/ef100_vdpa.c     |  543 +++
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  224 ++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  793 ++++
 drivers/net/ethernet/sfc/mcdi.c           |  108 +-
 drivers/net/ethernet/sfc/mcdi.h           |    9 +-
 drivers/net/ethernet/sfc/mcdi_filters.c   |   51 +-
 drivers/net/ethernet/sfc/mcdi_functions.c |    9 +-
 drivers/net/ethernet/sfc/mcdi_functions.h |    3 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h      | 4390 ++++++++++++++++++++-
 drivers/net/ethernet/sfc/mcdi_vdpa.c      |  259 ++
 drivers/net/ethernet/sfc/mcdi_vdpa.h      |   83 +
 drivers/net/ethernet/sfc/net_driver.h     |   21 +
 drivers/net/ethernet/sfc/ptp.c            |    4 +-
 20 files changed, 6574 insertions(+), 176 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa_ops.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.h

-- 
2.30.1

