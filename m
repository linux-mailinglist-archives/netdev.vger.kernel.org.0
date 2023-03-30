Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D516D0770
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjC3N5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjC3N5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:57:46 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2046.outbound.protection.outlook.com [40.107.95.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4463B6EB8
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 06:57:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNFBuoiq39Y/jW/fgoa/minZwDTPeXAUQTfAWTGVhrDcldwJVBDPk6dCFAwx38Hm5k6xU3dK/diIqgcHxE9+/Lg+OfH0tSjw5G2k24+7lBvlqosk1rxvrc1lf5fwBR5rOP0a/0laoOPdSZHTpYCUU+DgCa54bQ8H5fsE65v9ftT7Wobqux266JsaM+pkxdQwUQP6mCT9lFkE+av/lGQvG6PfE4ljMAaZ/LTwwWk+G42c66kKK5peR6szmJivSBEl30bCd04ryhIFaJfEjeOd49QOnRbJsLgrBwse3c0ftzluRDk2XEHL7oLHZRxwmOlCIWBzenrhrkEfm3Crb0fe1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4ASn5c0ABW9vEihQZZ9PuxD0BOdh88lPaocWCXvj+g=;
 b=iDJdkysDlhoG6h1qwzSLLG0e9ovRHZl82svn4RNCo9/xBT8c9+5eQ5k7A5afwF0PxfLeKBNOeT1WgRpP9D5skDV2h3KRc1XTCRf46Qd2/h456qUGL6ATePFD4rpwZKfElUIFrb7/QaFQExa1PCpTgoEiwX3AWfYmhDeJDcRRgFSPbQpgMs5LRwQgWA8WHngmhKeVKKQPQbFUDWsuoqSvCMMKpy6fqn8vVHJwZ9uT1ybWp2pFxESmCmwslZaJ8CXolIzXj+hbZUs6QYRILuPug+lL4Ecq3k4jznqUz99i9xv2eQ7iFNHV3480h4yMODwMbrgcFWAv4RVngHfg/tYEiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4ASn5c0ABW9vEihQZZ9PuxD0BOdh88lPaocWCXvj+g=;
 b=BeER4svuqd6wLSI99wKiHiP4emioSkHHjNW1lwl2hP0aNwET8no9u9Hs8fjTj/vJcUJHZ1xNdMyv2YwsGcB9IsNutq5NIAxxDjgOat4IAXs5m8tnRPcRV5d3sXO0CEeT5qOCnKwVpbvzi1IGOnD9XCw493cio2Wvxg/H1XV+03R5RlfU8bZGxs+u+QQs7myL/n2Z5En2xeCRDMMrwhiCzmvaCO7xJI1qpnLeZfOTuoJshye+RbKvvxu5l8AFYnP2BvXVIzExLULEouyyM+js8jyx1t+pitlASTmgxMDMrDRifP97gdRhrlly4mUnV6M8ppF8CUUBic9u+cciGQkXBA==
Received: from DS7PR03CA0091.namprd03.prod.outlook.com (2603:10b6:5:3b7::6) by
 IA1PR12MB6282.namprd12.prod.outlook.com (2603:10b6:208:3e6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 13:57:43 +0000
Received: from DS1PEPF0000E633.namprd02.prod.outlook.com
 (2603:10b6:5:3b7:cafe::9b) by DS7PR03CA0091.outlook.office365.com
 (2603:10b6:5:3b7::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 13:57:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E633.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 13:57:42 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 30 Mar 2023
 06:57:25 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 30 Mar
 2023 06:57:25 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 30 Mar
 2023 06:57:23 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v3 0/4] Support MACsec VLAN
Date:   Thu, 30 Mar 2023 16:57:11 +0300
Message-ID: <20230330135715.23652-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E633:EE_|IA1PR12MB6282:EE_
X-MS-Office365-Filtering-Correlation-Id: 85219df3-e1c7-4a54-f96b-08db3126bba2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YDtzO2//HZFF1xhMd8avtSmyKNKx1oR9busWcnXlxrIYtnbh1AKglYbvJulrJryND2tmJCfRWaeowHSwy8HIBLbTSRb5Hb7Cun5MRQACMmJm0LfG8QFSqShjR5K9Kyu5gqw5JU1DPLRBa7U+XT6c9AKjboCCwP4IqPImG4eLapURkN1wbmCZ4UGNSD2vhckeAT7Cmix+IVYQaiNx9xeNYQqadXKQYLoZ1rPUGto7GR2fPkF/BZ8VaL+Bepqay64mIBPzxg3w+qh9eNaAPWNlStcL9n4eNnW3U9lcyQyWJ7p896Wghw7Ga1C/tizjkAfU6eG9rkg9bse7gOAa5yWsf/+bZtWvj/CJkuu83Kwv89mY0QTAyH6c9+tAufc+VsJlxm9R29lYDiG2pWgH31Gtv9rw4mcx/6HcTKGCDxd66gV0CXY2fSA0aLf5ZzXf3RT+xCwjUl1OPjDiT+cv12Ota5RvOlxh6zS0lgdhSSroTufF9iyZ+GH/TKlihSMhJpaGyt12Q+yBhRLbYE2yjTruxz6Ut/0l2Ikw8EqKgcZSV0qRNOScHWtsdtn6oigWN0wBzqe6JOkhmbAo00Drc6YIcnOn55MBQiW13RJc7St00wmoH/UxVm1MaCJaqNmNyVTYy7fVk7p8TJ1YDnoJceqt3WI7HVCt14roPiAdWWI/cPiVJP+MmGvfE8+WCbH60bfw2YapKMYdduHO/gcKzRA92R/7iHJgKm6dy53HuRuyFPIvwMAjvn+seEmt/QoEHush
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199021)(46966006)(36840700001)(40470700004)(6666004)(107886003)(7696005)(1076003)(26005)(110136005)(316002)(70206006)(478600001)(186003)(47076005)(36860700001)(54906003)(83380400001)(70586007)(8676002)(336012)(2616005)(426003)(41300700001)(7636003)(356005)(4326008)(82740400003)(5660300002)(2906002)(40460700003)(8936002)(86362001)(40480700001)(82310400005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 13:57:42.8033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85219df3-e1c7-4a54-f96b-08db3126bba2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E633.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6282
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

This patch series introduces support for hardware (HW) offload MACsec
devices with VLAN configuration. The patches address both scenarios
where the VLAN header is both the inner and outer header for MACsec.

The changes include:

1. Adding MACsec offload operation for VLAN.
2. Considering VLAN when accessing MACsec net device.
3. Currently offloading MACsec when it's configured over VLAN with
current MACsec TX steering rules would wrongly insert the MACsec sec tag
after inserting the VLAN header. This resulted in an ETHERNET | SECTAG |
VLAN packet when ETHERNET | VLAN | SECTAG is configured. The patche
handles this issue when configuring steering rules.
4. Adding MACsec rx_handler change support in case of a marked skb and a
mismatch on the dst MAC address.

Please review these changes and let me know if you have any feedback or
concerns.

Updates since v1:
- Consult vlan_features when adding NETIF_F_HW_MACSEC.
- Allow grep for the functions.
- Add helper function to get the macsec operation to allow the compiler
  to make some choice.

Updates since v2:
- Don't use macros to allow direct navigattion from mdo functions to its implementation.
- Make the vlan_get_macsec_ops argument a const.
- Check if the specific mdo function is available before calling it.

Thanks,
Emeel

Emeel Hakim (4):
  vlan: Add MACsec offload operations for VLAN interface
  net/mlx5: Support MACsec over VLAN
  net/mlx5: Consider VLAN interface in MACsec TX steering rules
  macsec: Add MACsec rx_handler change support

 .../mellanox/mlx5/core/en_accel/macsec.c      |  42 +++--
 .../mellanox/mlx5/core/en_accel/macsec_fs.c   |   7 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 drivers/net/macsec.c                          |   9 ++
 net/8021q/vlan_dev.c                          | 153 ++++++++++++++++++
 5 files changed, 196 insertions(+), 16 deletions(-)

-- 
2.21.3

