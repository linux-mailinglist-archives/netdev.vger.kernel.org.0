Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8556C5136
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjCVQu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjCVQuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:50:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACD15F6CD
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:50:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwiRF4UJsnjdVHKocDIqhffD1KCDwSOZgsmObfWXLMBhCgGHTPEGAEyAh44lu4AY0e70OT9ymjOZradBstzr+FK85Y6P/Oi2CrX7dFU8IpGLTV1GIkZQz56boJwIfHTCkXDdn4vyttxDrW+axEzKNalYR72l3qs/llYDz+Vf+qxq5N+VJ0IYQd4Nw71bmutzsulyW2Tel4cCpk42O1aLNdk6PlDXJU6vM8fgtkGeENd74vFAqskWxlJW+B2ob1LnbxQ5l0nN0hCQWMroJITPWls6vA5H2eelHYR2KhjrhMZa7TscUIaq6jvDWexiFqE5O6WgpCP7X0BqBlbgyC2C2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRVmihgPlKfaCdps5l9CmHaqOobG1LYAkar4JuyMTDs=;
 b=BsXEtZVYUXYcxS6kRkOPT5lgbEHbkZC0hwqw6HtZzpbAKZ8hCJ66kz3M8YL4vPDEh5pIUsvfVdHw8jJVA6YUCt7WpF9WVEQb3C+Ojj058Uvlq0Oriy43ocgKLHT3++IGwEHJBrZ92Xapb+Bs8uLQ3cVOmB70m1431JTuXYdBqzW7CSwDeUdRk6ula+W+mYjlm1NlDlDHzQ0vK3PoSOvPjzwkvIaV97C8LX/iKK8JTr6NJUP9q/KrcCVV0CEMUgbAaBjS1mcwF4JvEZdR0kTRrfRdNNZxPpdU0lYmgLdzHfbbPEcBBqVu/96WUhJwgwHY+HEMdlPGF9sj3kMEDsNMgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRVmihgPlKfaCdps5l9CmHaqOobG1LYAkar4JuyMTDs=;
 b=GSOyTLRXrCB2TrEgQsuemTgWNsGMo5uxQ2o1wu46dt95Ra/dxg7HxD9Jl/iST6/KJ7klFLmsb65n6OvYdPnFInUHycMmwM5mc5r7r8lTkUGEwc8uK3fALeWVPjG730DgcP6xj51zh7H8yoyPCSSs++mpaplAnW32cMy0HWu8SfyVwx3gL/o2qwf/dJ+odZuDWsu9SQuIIcHHoDRpf2UFcvs+ZNasT8V7va2hr1xRRpu+89OgWPbHgGvV9yafb/LZa4qwxYrHFbNj8wJWbeX/UV/BmZ21XmJRXATgrk5Q1tUugd66FKtd6jxqCjBCegaBazG5gNmW+QDHus/kKZX/2Q==
Received: from DS7PR03CA0294.namprd03.prod.outlook.com (2603:10b6:5:3ad::29)
 by DM4PR12MB6351.namprd12.prod.outlook.com (2603:10b6:8:a2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Wed, 22 Mar 2023 16:50:26 +0000
Received: from DS1PEPF0000B075.namprd05.prod.outlook.com
 (2603:10b6:5:3ad:cafe::20) by DS7PR03CA0294.outlook.office365.com
 (2603:10b6:5:3ad::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 16:50:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B075.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Wed, 22 Mar 2023 16:50:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 22 Mar 2023
 09:50:14 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 22 Mar
 2023 09:50:12 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/6] mlxsw: Add support for new reset flow
Date:   Wed, 22 Mar 2023 17:49:29 +0100
Message-ID: <cover.1679502371.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B075:EE_|DM4PR12MB6351:EE_
X-MS-Office365-Filtering-Correlation-Id: 23fa0cfc-fa28-419b-3e62-08db2af58918
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uEaU/fdirRXKhDeBSHJiKA8D0MAiltRhIgWTOXXrLQD5Ct4P+2pnOcR1JCmEMtKKjOM0VHN5Ex66AmhXY4MZZcn3E90qxeJQk0QJkaepHZP39fsqFLJC2ZeOyqcmyRkgQw+y9VG1BQJq4XAdMlulcEZVtszfYfpMbRDJqDaR4KreJ0TLT5B2qffU5g5wKbMsOIN58oLysDKF+bkRk6bbEjeQy7AeSREADusZUrNCqHAa0a7pBHPMDRWCmmGUc+WIhMfp/hEdrRxRdg3bt7Y2yz1JbsJ+G7UXuZ26z4SChTcHR5V2SVMkU2PsxMKpB8B2i1KaqTuRKfqfptka1hUpDiTMfN9cggh6ObAjzUIqe8gPGTL3GkJtaPzHDSW8gVKeylDiW5EYCbUN+IATLlSl/K+zx+jKj4OsyUD0ekir7FS5skKpRWaKQMCAPLsgTK6hqyc3753Yv7kqb3Cb2vwgOqCiHAKRun7dKfluqAbWZ4Of6anXqnFXlw6CXfSITnGiIMdNEduNSe/R7X7so4bKqZfsKZPB9K6dvJOlCZroKbKChFZ8RVCmbk5qSmV0053acgCFIeA+33Ewl63Jn2OwRzvJeeoM39zeB1Hq7FkFotNKRtepmjVnekQC8iO47ol4wgc4OGXdlbhJGLa5MPtkPuMk+xPj4Ylghkx8TQQl6IvObyYIi6nmmawSMyN/8u2Ei6aJhbszu9ae/uhgyjqkPWomVzzgZ/Dbte7w/yfCQvbpg05DwrxjRoorZ16EnoN0
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199018)(36840700001)(46966006)(40470700004)(8676002)(41300700001)(4326008)(40460700003)(5660300002)(86362001)(356005)(7636003)(82740400003)(36860700001)(2906002)(107886003)(70586007)(54906003)(36756003)(478600001)(40480700001)(70206006)(83380400001)(316002)(6666004)(110136005)(82310400005)(8936002)(47076005)(186003)(2616005)(336012)(26005)(426003)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:50:25.6916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23fa0cfc-fa28-419b-3e62-08db2af58918
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B075.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6351
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amit Cohen writes:

The driver resets the device during probe and during a devlink reload. The
current reset method reloads the current firmware version or a pending one,
if one was previously flashed using devlink. However, the reset does not
take down the PCI link, preventing the PCI firmware from being upgraded,
unless the system is rebooted.

To solve this problem, a new reset command was implemented in the firmware.
Unlike the current command, after issuing the new command the device will
not start the reset immediately, but only after the PCI link was disabled.

For Spectrum-4, the firmware will support the new reset flow, which
includes PCI reset. Add support for the new flow and use it only after
verifying it is supported by the current firmware version by querying the
Management Capabilities Mask (MCAM) register.

Patch set overview:
Patch #1 fixes a wrong order of registers' definitions.
Patches #2-#3 add the required registers and fields for new reset
support.
Patches #4-#5 prepare reset code to be extended.
Patch #6 adds support for the new reset flow.

Amit Cohen (6):
  mlxsw: reg: Move 'mpsc' definition in 'mlxsw_reg_infos'
  mlxsw: reg: Add Management Capabilities Mask Register
  mlxsw: Extend MRSR pack() function to support new commands
  mlxsw: pci: Rename mlxsw_pci_sw_reset()
  mlxsw: pci: Move software reset code to a separate function
  mlxsw: pci: Add support for new reset flow

 drivers/net/ethernet/mellanox/mlxsw/pci.c    | 169 ++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h |   5 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h    |  90 +++++++++-
 3 files changed, 254 insertions(+), 10 deletions(-)

-- 
2.39.0

