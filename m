Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AD16E0BE9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjDMK5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjDMK5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:57:00 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2081.outbound.protection.outlook.com [40.107.102.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFE161A5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 03:56:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kpy8r8tpSjejfkSe2bTDyuIIgyQOu+Z/KztuN/qbq/z0gWtTLU1r9qoaCrSA+Dh7ffpG24ZGL18BCDE8aP9S6Vfs6vWQeJCUNJyO/7qj7YpTXhSBPn8GONQPuRqX/nr5/iixD5XrHTt4o+mGUxY/MXOWccIsVh6umsikE7NzDNGFt/JPNGotGcpHz0hqzrwScDsRsAWEAjVbXBPsl8jeeVvbIzt+DMHZ0uH/sH6SZpOx0vXx4ZPCi3T24BdscZ4Vx4Z/Z3A9eQl4aVavA+rr34Oxvg3sz+e/tslhb9Ze96NX/V0VuDtyou7cVoGYUTimLjPwGYQpKuO4FGHGlVpnPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ib+eDvOY6xBYrtbcP9lbQcWen4EDlGQU+D9H2GobH5I=;
 b=hbAuTbxS5qicE+V0eTPESHdO1mGbcM4SfsLR/D4T0ymyZ23zdGsQpClW/ohCgHfZIf6S/xKFo3jUo1BzyymEtj/REsvAe6tZFk+f2lW2tJ9BFGVJIeqLvkx9FEjMAk+PyjQ8VJnOdGY45hOuHwJPa04stXswlrbfNwSl6IWuhhUsfWhOll1FRugK0vTMdyg+dO776nlomJwPX+C4f1uI05RVhAVLE4ypA85+xskHNDXICJN3CThtJrtnbM5OYBM6Tb5QDK/AJj0mHt8qfzIPq+9VNKOZ76LPCvF3bahwmL78DEeWsxFB+1DZCe6xx8JQ6zDdi/BWjCC65HGWHaj8/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib+eDvOY6xBYrtbcP9lbQcWen4EDlGQU+D9H2GobH5I=;
 b=AICMRiC7UApP7rwb4pyM2b5OcYNA+Kjpxs3wFGnKZmXI19/8UXXjMFgnuf31NyeaEqN+tpM49ZP1FxK4zqPeR/nx1OeSs5pFTm+5jQhL0mEl7zChO+8JlS8Fs1qymMS2hPPN07jt5FnLMT3sGT6ltTIpduoooYUtUBsq2VGXSYH1i/ChmyOTk30VeyOFdEPtWv2tuynDoXGX6FoqeWzeXGRk6/iheI1qfOR8YN2lABsv7kH0ITvoxRqMyVG5EAfbtHMbF9FsfyiYtVtkZ1tVCqQytuoO5R3JgIzAV7PaW5DTzX2cpK0woJrOA5htByYDoJrmxKxRgMbs2zAODA5Rew==
Received: from MW4P220CA0025.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::30)
 by DS0PR12MB8366.namprd12.prod.outlook.com (2603:10b6:8:f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 10:56:52 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::37) by MW4P220CA0025.outlook.office365.com
 (2603:10b6:303:115::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.32 via Frontend
 Transport; Thu, 13 Apr 2023 10:56:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30 via Frontend Transport; Thu, 13 Apr 2023 10:56:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 13 Apr 2023
 03:56:35 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 13 Apr
 2023 03:56:34 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 13 Apr
 2023 03:56:32 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v5 0/5] Support MACsec VLAN
Date:   Thu, 13 Apr 2023 13:56:17 +0300
Message-ID: <20230413105622.32697-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT027:EE_|DS0PR12MB8366:EE_
X-MS-Office365-Filtering-Correlation-Id: 86deafdd-b06f-460c-4d9e-08db3c0dc967
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /INPw6S3bWJEq7c8tuDQTTrIsZFiUQEsshLufRPd7LAnxeT3KsGaH3PTDMFnz+akym1FvM4n3fi9+7WuA6zwdT1eH45oaE4OT9of4/H0PNALwufE5UCSt1W4YNQITfq3ge12detj6xmBl0IY16VLK2Z8Tz6wG2MZ/gq24AJOMh9XLSdZAhblkDxBTD2T6/wYPNjrqinRwn1pooX3ew/zmtL2IZ09d8iIpFP0yKNMZYvd5K2D5MSD+N2/gzfUmNYb6JBUIknkkkNZtKABXImuD4QhddL/0ATQ/xw+6w1Kk6xNuESKdpKCZtnAX/Orlz5SJDePSXF0AqRSR/Vw2+CJ7Kkbv6j//mP8t+YqUxUaj0u6nBBJJDclC9KUITWM5SGhuibskNW0qJ0z+NBZ/LTZrG73L/T/Wd7eEYp3yzr7R03//ubuv7zErhJhJXpA66dx0lIxrt+EePKsTG0Gacy9qIlpFr71Olh1N6rnohSzA7VirrZqPVX4C/9LA5GjBJjsuVHmvx+os5XINR/Hrto1bKHj3ADvMRVgtwun1mEsI8XrWDBKtzS5ozZSm8VUf3Vt5Z+OgA04YE4Z5z0/1Lve2VvWc8lqOlWjDnSfDD01DScOURUrZvwBleiPSP8jw62yvhfIl4aR3fH8ns0KAUQoWpaF8SyB8borMU5uXR3uexCiK2HqD1MjnLXk64W/TYsGTH6RXrpnvL6NVIJIS/8eJpCP+CAKGYctGzZ7FnJ5yhfVokifGgLI+trM+v05+5pGA9lJUFxjOkOZfls1sHw5isS93OTjIfxRpQW5UDRXI4g=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199021)(36840700001)(40470700004)(46966006)(316002)(4326008)(82740400003)(70206006)(70586007)(2616005)(47076005)(426003)(336012)(5660300002)(41300700001)(34020700004)(82310400005)(7696005)(6666004)(36756003)(86362001)(40460700003)(107886003)(54906003)(40480700001)(26005)(186003)(1076003)(2906002)(83380400001)(8676002)(8936002)(36860700001)(478600001)(356005)(7636003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:56:51.2726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86deafdd-b06f-460c-4d9e-08db3c0dc967
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8366
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
- Don't use macros to allow direct navigattion from mdo functions to its
  implementation.
- Make the vlan_get_macsec_ops argument a const.
- Check if the specific mdo function is available before calling it.
- Enable NETIF_F_HW_MACSEC by default when the lower device has it enabled
  and in case the lower device currently has NETIF_F_HW_MACSEC but disabled
  let the new vlan device also have it disabled.

Updates since v3:
- Split patch ("vlan: Add MACsec offload operations for VLAN interface")
  to prevent mixing generic vlan code changes with driver changes.
- Add mdo_open, stop and stats to support drivers which have those.
- Don't fail if macsec offload operations are available but a specific
  function is not, to support drivers which does not implement all
  macsec offload operations.
- Don't call find_rx_sc twice in the same loop, instead save the result
  in a parameter and re-use it.
- Completely remove _BUILD_VLAN_MACSEC_MDO macro, to prevent returning
  from a macro.
- Reorder the functions inside struct macsec_ops to match the struct
  decleration.
  
 Updates since v4:
 - Change subject line of ("macsec: Add MACsec rx_handler change support") and adapt commit message.
 - Don't separate the new check in patch ("macsec: Add MACsec rx_handler change support")
   from the previous if/else if.
 - Drop"_found" from the parameter naming "rx_sc_found" and move the definition to
   the relevant block.
 - Remove "{}" since not needed around a single line.

Emeel Hakim (5):
  vlan: Add MACsec offload operations for VLAN interface
  net/mlx5: Enable MACsec offload feature for VLAN interface
  net/mlx5: Support MACsec over VLAN
  net/mlx5: Consider VLAN interface in MACsec TX steering rules
  macsec: Don't rely solely on the dst MAC address to identify
    destination MACsec device

 .../mellanox/mlx5/core/en_accel/macsec.c      |  42 +--
 .../mellanox/mlx5/core/en_accel/macsec_fs.c   |   7 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 drivers/net/macsec.c                          |  13 +-
 net/8021q/vlan_dev.c                          | 242 ++++++++++++++++++
 5 files changed, 287 insertions(+), 18 deletions(-)

-- 
2.21.3

