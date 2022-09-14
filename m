Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B56B5B84AA
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiINJPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiINJO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:14:26 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2089.outbound.protection.outlook.com [40.107.95.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F9A75CEA
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 02:06:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BL3RGbp+/0q7AZ+dPnavcvpIxLcfgVdnZxyepCEZgKIN1I2QuAb2hh27ou0wb0Whe8vdh0GUEXezBiEuYUTXcyS78qtgBMq4FTcwqfG0+F2q9b1q/uH5JZwQYfF0N8767+WA4iPXzDAEDjHX9W+oCabtUfxKWepuywV81pYDRMgZciX7ldwjJyCaEeXQqXtT4GT/YJZUMIN+3jf47ShxtQfMhsp6NE01TM+ONh0K7HndGr2iXMP/GjP4pyCDYtZuzfKs0TIPcyDSccXWpTSPRR0Frk68E5fToMsstJNywDmI5hx7t8wbnRdRPL/MRY28UGWWa4ndkUlcMUvxUGt8vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BrADrF5rrc2VHtT/1gcjQqjdDlP3KBcxxNKeP8f4oqA=;
 b=cIcmDoKF9t219Riud5MLx9dU4Sj1pKODBlIN4F6xMN6SUGEpOb5IKg3r7opX02bxA5AL5Rzx+0dobZCKQD6TbPoL5r83VCIN80txW+4NbivajxKWTiV1atIQTChXh9b1y95JjvqIVi5KMBuYOPahk05NI0y8tI/hycOJinuYaSGrrwjhJjZ+MBB2BofpXQwOjKsZyQRj6g9WXeTIMdeu0mqZsH7DjIwKrG5z7KNUDGwF0oJFGsrehlRQAQafvIkkylc3V1TdxMVtKImbNZx8ZRbxDbk8nKkmpON2A53rnke7VISjqMoPjAwKtj9g9HCoL2N3CUwVHBTmEFsFlrKJ7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrADrF5rrc2VHtT/1gcjQqjdDlP3KBcxxNKeP8f4oqA=;
 b=d94nA5mMPKeGNzdLYyCgQFf3WyV3VNIHzHWV/25/eAQSr41UgD26t7F+dxQxpxC8LMR/+jhc4yYUbvsDw5LS3IHAcFd8eCBWeoz9WIiT1TDyQOvUL7noS67tolGeHt4D3oavex7pjZsF+LODKKhgMRO61fi20mRIIzGRnV8nMkYtFu/rb1UAmASw9hDic57L6U+ykrZ6vfuXcF172B/klfav8jJbVfOUlHONSH3GWPoS/3sfOy7/quORrFfoN0duwx7xAfqUzcKc9zWjeZUQwGohKpNia8N59N8vBc1aQfcsn5QJ74RJ8EvRJQe5iCq29APdZNL0BGcZmupNwuvkgw==
Received: from BN9PR03CA0583.namprd03.prod.outlook.com (2603:10b6:408:10d::18)
 by SN7PR12MB7298.namprd12.prod.outlook.com (2603:10b6:806:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 09:05:42 +0000
Received: from BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::9f) by BN9PR03CA0583.outlook.office365.com
 (2603:10b6:408:10d::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Wed, 14 Sep 2022 09:05:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT071.mail.protection.outlook.com (10.13.177.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 09:05:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 02:05:26 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 rnnvmail202.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 02:05:25 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 02:05:24 -0700
Received: from vdi.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Wed, 14 Sep 2022 02:05:22 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next 0/4] Support 256 bit TLS keys with device offload
Date:   Wed, 14 Sep 2022 12:05:16 +0300
Message-ID: <20220914090520.4170-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT071:EE_|SN7PR12MB7298:EE_
X-MS-Office365-Filtering-Correlation-Id: 082d11a9-4137-4720-da49-08da96304c98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WInHzThiS/IVXuTru/JdDLgoeAlluQKsStmaQYbOanX6/T1tcj5kHPM01gY8shqngohzTR+EPVKsrYR8F+ci4jXcE9Gm8e4dG1ifK1JPRbzofrIIluRy1Hdpbtm7fUaTpFwDjFOncG2lw8iOSi/fM8EWILEIgl1I6ARvX1NE7X9KPq5cJ27eG10sDr65+ViaZYcdTWAPKv5NHCpEBISdFUR0KHXHKS5x2unymqBs+8V4hNNO9YHNqkFGodhE6NNfIxtZVejT0XLIIT+rN8sdQYdgig3pXAk1KsW53TRHX+9/hgBUe84mHJKnSAQayPsQUfKCkWUnRzxdp9DQ5St5r25VEQE7wwtvA4IRFME59qWuhsWNyPrC8IpXFl6GiknueSW2UHsRAyJUfvSS/MmK1TDOfr47xJB/kkhyJ5GeosnTEY/jljfEkRUxMzI5Tz67X5mfOg5g8FnVOBMD7f1iL8+A/Qb/ym9dr8LyZTHNzQU4Labb+CcFVgHpMQqoxsCYTwRUHmxMnoxzRfsHNgSCAsdsqu54X8RfDc7wxFzOextGYLUku5sK2PvdIlpqCG61uf4HhqrvjWwa9J3s9n84n1CerRIigT53w8eoWlymCv1TKrmPWsXb8MVIr4K6Wiy1Vmjkvd8AeHUIGiWavOTbqx46s76yOFIine9QD9Ty8chqZXJ4xpqVg74RbyPfBkuZki4vT52WCsvqw7EtJP5kqh4CwbWtoZNKCAkEfUDA7MYufAj3MIHn6DZK9QPJpUqDO4yadO1Nec0NC0dzlmUiag==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(36840700001)(46966006)(40470700004)(426003)(8676002)(186003)(40480700001)(7696005)(5660300002)(1076003)(478600001)(107886003)(54906003)(7636003)(70206006)(82310400005)(356005)(41300700001)(86362001)(40460700003)(8936002)(336012)(36860700001)(70586007)(6666004)(26005)(110136005)(2906002)(2616005)(83380400001)(316002)(82740400003)(4326008)(47076005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 09:05:41.1997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 082d11a9-4137-4720-da49-08da96304c98
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7298
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,
This series adds support for 256 bit TLS keys with device offload, and a
cleanup patch to remove repeating code:
- Patches #1-2 add cipher sizes descriptors which allow reducing the
  amount of code duplications.
- Patch #3 allows 256 bit keys to be TX offloaded in the tls module (RX
  already supported).
- Patch #4 adds 256 bit keys support to the mlx5 driver.

Thanks,
Gal

Gal Pressman (3):
  net/tls: Use cipher sizes structs
  net/tls: Support 256 bit keys with TX device offload
  net/mlx5e: Support 256 bit keys with kTLS device offload

Tariq Toukan (1):
  net/tls: Describe ciphers sizes by const structs

 .../mellanox/mlx5/core/en_accel/ktls.h        |  7 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 43 ++++++++--
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 41 ++++++++--
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   | 27 ++++++-
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |  8 +-
 include/net/tls.h                             | 10 +++
 net/tls/tls_device.c                          | 61 ++++++++------
 net/tls/tls_device_fallback.c                 | 79 +++++++++++++------
 net/tls/tls_main.c                            | 17 ++++
 9 files changed, 225 insertions(+), 68 deletions(-)

-- 
2.25.1

