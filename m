Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FF66C92F7
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 09:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjCZH1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 03:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCZH1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 03:27:38 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B819265A7
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 00:27:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIGDbtyEyL42POqZZ1s3wCIY7Ii1FXRmI6FuUFIvsJx5UyjzA4F6dnVN/RfmfPkHjxapgSBG+9kiedqNM7fR0wfOgM4W9Hz5D0Ppnfdwp0WL45AA1jCGegqab+3nEbLtkDKJyrJNi4UZhP3iRDY/SLZ8UJhIop8y5ylJlX0OlbdnChiwwdS0FjnPx2tx4C5FBB6rGbh/17oKysvvm2Y+odHLr4dXgdLx5wfG6sVQXgT66jUJlRu7QMCEDXw9bVPY3M/9Yg/fyg/M6zZPmuhS7mdkrmKkEGYzlqtTGOcz3d/TIJbIzCTJCpokk2SGMsRkOELZ8snz/5U00qRLL5UR4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5Q4gmkUSpD3i6CWDl6WJ8BY2w2mYZZ3QDNb+KctPyI=;
 b=cnYUucFcZuW5DUZZIEgt4ktPj2eONLbL61nsHMdZ89Wc9C6T2eeBjNF84atuo+9cR3FfvnVP6dWbL9l10WV9JX+N3tQCXFuuodTd+8dkGCqaIGWXzOMlJVziLz7Iv8YWAxCk75UxomAOAfNi0gVYzehjNdZEsI2csJ8KhuBXgBTOl0QTBQNyNG165RM9ZqC8Xk8ePa5cgVfmYJEhSSc1oGJ+b0681+d1PupHdwQVmKk1ehpReTpMNi+nwK9l7qrKwv44clMuwmMr3QcRCSGruWE15wyMew4p71RX9AAhcWLbNklKHbQ+KiNTv4dkYiP0cH+gC4D7HFFklIAVUvpfRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5Q4gmkUSpD3i6CWDl6WJ8BY2w2mYZZ3QDNb+KctPyI=;
 b=sTs0lCGqy2fD8F+2Bc2km4iR2ujiD+YF9cRa34O+BEBKI1J5R0LtM/kvGlbxcGLQY7FJSOUkfeZ0NPPjuiwahgCX9OSt8PR6k4LCjAACdX5n3hvNb4kIsEd+VaVTDxh3/4rMkH9u4llX9LLFQiQzJ86hdYmB0HHgAulTAa6PGiCbiIEvZ3pNeXPM1K3lJSAcclNC7TAeRXNt7fnUC4Qn2YNpwHRL7BgKn9UYDq0atWT9Ys+9aoIw1cbIrZ9d9b54bXVgZ5W28Xjmg3p3bhLpVgYgzVa595sickPORJXM8ZWd+lmWJTHkPvZurydg787Y7Krc70Ufr25uzRw9R0uOyw==
Received: from BN1PR13CA0014.namprd13.prod.outlook.com (2603:10b6:408:e2::19)
 by SA1PR12MB6972.namprd12.prod.outlook.com (2603:10b6:806:24f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 07:27:34 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::b) by BN1PR13CA0014.outlook.office365.com
 (2603:10b6:408:e2::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.13 via Frontend
 Transport; Sun, 26 Mar 2023 07:27:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Sun, 26 Mar 2023 07:27:33 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 26 Mar 2023
 00:27:27 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sun, 26 Mar 2023 00:27:26 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Sun, 26 Mar
 2023 00:27:24 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 0/4] Support MACsec VLAN
Date:   Sun, 26 Mar 2023 10:26:32 +0300
Message-ID: <20230326072636.3507-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT050:EE_|SA1PR12MB6972:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c22eb28-9989-49a3-d546-08db2dcb910d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e02MdgR0rNGrc5WsrFR5J/7yZiZ7hUfzrmEBQNl6//u03P/ePUaQR5By7LYsfaxIF9LUT1VYTfZAOC5JeobQ5bj+FOx5RrVaNF33ByVrrCG2rdmms4ijYJq5qfYapFUDMiE8P5oeYK5Olh7Dhd9CYRkq9x+OCOylA6lE+jrvmcRuoszVw90Q+8E7nw8/QolMmOYHB2eF+pn4qtbrh2O4GgR2VrSJiVJXU+AsV6eQAdqc71oiB5hP2Tnn268oNaj47OhxbsrG9Xz8H7WRyzQItn0MzyDPaV4tJ1r4SJqm+xxYAbwApZzZsWQVN9txozGAFrZVjmc1M8dX2ME8OwuIrzjSu4GFWgtn0bJt18UenIxQl9G867sAXTlc9rh928KbG302SAECi/VIBAw/rnuGKaWRUD02UQijGm6ht8qPF/ccuiIeM/Ez6TID7u9jKoYy1A8V6dTfxCc0NPKJVrL43K4pXJEZt51qwFZzPxMCrvSij9Zss6cEF9flA0HwkScis9FKroWEJmcvl2PUZk2XBZ7qIyCtE5vJcXt/rDVNil3/THlVfRa6+pKXRkgnxmIZuIo+i/mQDfevyBjIb2fDAzNNP0eTUHlqf6pYCjFSFNJw1dit2yYWBfgk3tLNsvEgGgrGR1KDZk7Cfoi5vUKiWyds3twgTy61CWI9izuBiOduuFkIQZmpWs3Q+AJCk1iapiV+MngDfhirtwWl70GNHu2E8S+3Yx3AHntUyA6riAn1IE/z07O21X+wBqbbXsOLKAPKzTjejC64aU7jMf/IIBNEJdg9duIKrIWef8vBHDY=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(7696005)(478600001)(54906003)(316002)(186003)(8936002)(336012)(2616005)(41300700001)(6666004)(107886003)(5660300002)(426003)(7636003)(47076005)(36860700001)(83380400001)(82740400003)(2906002)(110136005)(26005)(1076003)(34020700004)(4326008)(40480700001)(356005)(40460700003)(8676002)(70206006)(70586007)(82310400005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 07:27:33.6396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c22eb28-9989-49a3-d546-08db2dcb910d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6972
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

Thanks,
Emeel

Emeel Hakim (4):
  vlan: Add MACsec offload operations for VLAN interface
  net/mlx5: Support MACsec over VLAN
  net/mlx5: Consider VLAN interface in MACsec TX steering rules
  macsec: Add MACsec rx_handler change support

 .../mellanox/mlx5/core/en_accel/macsec.c      | 42 +++++++++------
 .../mellanox/mlx5/core/en_accel/macsec_fs.c   |  7 +++
 drivers/net/macsec.c                          |  9 ++++
 net/8021q/vlan_dev.c                          | 54 ++++++++++++++++++-
 4 files changed, 95 insertions(+), 17 deletions(-)

-- 
2.21.3

