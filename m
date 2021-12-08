Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5212E46D586
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbhLHOVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:21:44 -0500
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:3361
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235061AbhLHOVb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 09:21:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F17f7j5HQVqX/h9DuMvFepaSpIGvzIbWWF0w029Hi8jnhmrFSW21T4GGVtuMPV4rz4FgabXwc7Wn+CrTenrs+7Fw+Yp8CzD4QSlvrPDJf4Ex/FKmtMJeigaiIW+acC6fa46aFYpNqgAbO2rM6exqVQGaiKF/3EVBowK0Yp29PtztZMcA2gzqbdbB/pFpUQzxUjYO+ji0ArmjIzW7PSjavFbtRoBC4XfgpIJKO6j5u52QuHwTt6gn5d0R2/m3gS4Gf2rbwUuTGmHLR77CVgg5z4b8Eupzztpxc1ZPk684rgOh6I91a/BAgbqx4YP0WDX18wKO0j6xub/H8q7lB61QbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LSE8cjKCVgUDXkmMRZbIiGt3SQSFpFkZLawUh3kQdc=;
 b=b1jNhtYrIEsHghzos0UHHzEjtuq2CYdaSSLYFLjvBYoLLZTGXaROUgaT3wde/cALNFjQ7oPFvqJjrwgAkI+PX6hWvJ+tWYvPSBH2jkFTwbWeiyTVvbhqm0aw9BrXtyzgsiJ63Epdy7JXr4iYDxd+sKd+7hRV2g6DifF33NPWWe+kwxZ4WUVzxOYJ35gr+idX+pplCho5xsTpien/HjLfyQgpC69GO1z9YB2KstFj560rDZK5SNgMYllmAkbETdtEempK4/aPvPMY3Ey7hekVrQdB69y3xvbfqo9jxFci0Hw5NTXKwQfUzlVdUfOsK15JZXk1mx9SKE5Q80Qf5KXIsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LSE8cjKCVgUDXkmMRZbIiGt3SQSFpFkZLawUh3kQdc=;
 b=X1tTFdgsN42m8hTWcdA5mwoWZ4sdrxGvGdapkL/XPJol8v9jp8ar6zXTG+q5xULJ84j10quAWKp8mLvUYd5f7dnw4aQU1eihO84ntWRkzRQcfhNH099djg+iZBrU7Gm2ALrkFn0ePcOaWWtKUwyjJ7gu+aSuwbBMMDokLUDpdQLQnjORh/PVN70YT/ca3/sel+qFYJOT2odqrsWMRxDGJvTsU+iyhY8uZjJSUQAC9Or46Pg86oNzdiX/hLddS6n5Pvri0GgnSnUgWlGe3ob97QcMrApefZ18Va2H2g7hjErmge3D4hD52dnzcTLlzYzdbnf2h7T4nQWiEbNtu1FhLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM6PR12MB5568.namprd12.prod.outlook.com (2603:10b6:5:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 14:17:56 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 14:17:56 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next v3 6/7] devlink: Clarifies max_macs generic devlink param
Date:   Wed,  8 Dec 2021 16:17:21 +0200
Message-Id: <20211208141722.13646-7-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211208141722.13646-1-shayd@nvidia.com>
References: <20211208141722.13646-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0502CA0011.eurprd05.prod.outlook.com
 (2603:10a6:203:91::21) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM5PR0502CA0011.eurprd05.prod.outlook.com (2603:10a6:203:91::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 14:17:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39b04edc-5f1d-44d9-335b-08d9ba558788
X-MS-TrafficTypeDiagnostic: DM6PR12MB5568:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB55687B6F01F1B653DB554836CF6F9@DM6PR12MB5568.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: owztJhh9UKfYTPXaAF/gVvsoQyawcIgK00wBGAg4jgWTmV0B1+MwTZhxPjH3OQNB+xG16Sf57/5CfwjIc8cnauhvepX8vcdp/qOQLqo1ia/ARro4v61CGA7W1QaCnAaePonhpxYOFr5JM17FnyT18DV3XGr3uOazAlY7c/YPLYfbSNM8j/T6yS+lQKmlD2DCbnTgZqEBfLtjTxwFf+xz4hQ4jKqE/Dm54b/tgy+g9iuKCKIVcd6nXa6p/KihS/vG2fq2PtJvKpKc2PsYcKIC5hQLlmCk4ytmOmFuf5evuuApTu2mhR8SXxYdx0Tjm/kM1MTHfP0ZtcYBTef4TimUObd7wtOUI2oZ6qMTYscuS3cTQbsQJ3CHiDHb3Cek8g6sFcSjRvZaoScRVLhm6D572lT6JiKYhSzMvBwFCzKS5ahXRFOZ/lnxX8Vh54Nxjha3OfZt1lkXahusctvxJASJoyfB9esp04pg0kGBBmE5OIirIMUuzvXGyDwweEBIVSQhbo3cr3UTUwk7m6G/uouLqrcJZu56r6xtM8wZgk+AogkrwiXS2FeZY14CIRcHfquOWvKftRodfJEpaIQuBjCNVDTmD27Nvsr6LMiX0PyJigYG6VQURKDlNcc/N8b5Ur1ACmfK+3gcsSrhajJ4Lv2466P+uNJKztmFJVd2efK7t8Sr60i89Mal+TtwgJe7vJc/un4rY3Zx08A0x8Tt8YS+J0jckblvtNTy3+LuXU+sRg4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(66476007)(66556008)(1076003)(26005)(6512007)(52116002)(6666004)(107886003)(66946007)(6486002)(508600001)(2906002)(5660300002)(4326008)(8936002)(6506007)(36756003)(186003)(956004)(38350700002)(8676002)(110136005)(2616005)(83380400001)(38100700002)(316002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OTywo5120e8jptQZStttY2AtkkXSIuZGTGFIVeOQMSGYbaezhpCGcRd0vPO/?=
 =?us-ascii?Q?xIlhiyqUjFqSzR/VVqoo5PUYnkJ36dq0Ezg030AATRIeTMXWyXzFxX1SFZa4?=
 =?us-ascii?Q?pNgE3R6I4MSl0Id1t+Pq2vCnNvNUpGXYm/Y6FOgRjUoHvD0vUMKwq6KOZNUL?=
 =?us-ascii?Q?Wu8DtSOpt1M5olDSc9QXn5VQJc1jc3WNHrEwjgkTuGg2C/q+DA2ELaO/vUUG?=
 =?us-ascii?Q?xoRsXfv47h2dTWxD/MvvedBHlDuSg9vgQynfPdLZbFoRvm0E2afMxB6YozMy?=
 =?us-ascii?Q?a7fSGpOKI7A8wU+Jf9GsplOresnhp2i/NDS1/UHXUm25pRLellS79MxjKqoq?=
 =?us-ascii?Q?dXJwPMIvLCyQRBpYWPGDFcAqSknIR+eSSNY2WZE9SynDwxa/xPWPkzVEXATe?=
 =?us-ascii?Q?FHIcinCGiUoGJVKCqtyTQsm39Yv3qP8v/2gI/aT6FjmAmX1uiE5n45drTTpT?=
 =?us-ascii?Q?3tZdWyblpYen+Evv9kBV5uMBLGkNjT2VVTOL+NlHVwlx5v0KthAp/gJpQqHG?=
 =?us-ascii?Q?QZh6OEUFcn+73YtNlN5/98QbB1ZlfnxUXzLTR9L9ojSuiFQSfF7dt4zlkO4+?=
 =?us-ascii?Q?DttCu+l71c0/WEBPttLkV83vLy3iIlLetR/RmyK0QJQdLEdDaCiW5FalyXgC?=
 =?us-ascii?Q?CVDBwNdGFD0OQZll7YKYNBC47WwVEMX0uwpQp7ugc/9TN1Et70BT70nqlprL?=
 =?us-ascii?Q?PJs5g0U2CrIyWI1bLg6aeedyN71M/eQCNUxvRYYrzGuvE4oOPFPQsu/vkwez?=
 =?us-ascii?Q?nOQzTQQ4sm2pA+uJoHHpeHEt3fX2RC/Ni7nVdBsCdEa0TVLiPuxuktgYtFHp?=
 =?us-ascii?Q?daZIN5IiyjaTmuE2inZTf49nRRex/TGx4lJ+NUvPBab5MULwxn4u/LURyAx4?=
 =?us-ascii?Q?kxqiCiHiTIApxGqRU4S7ccneNpyGSEz2nJwODZZVPL8PtAKc5vwyOuuFS/nX?=
 =?us-ascii?Q?nKa/qu8lJCdn6UTBiU+G3D0lqqo2pRRfMpCKtzvDfqcfk6uw+B6knzryam2z?=
 =?us-ascii?Q?KSRTX4IZJ6bSTRK26MMalWvlR9SJBG9SAbd8aHt5dAB21Yhk1wCmEzNDqhRF?=
 =?us-ascii?Q?ZujXW48bk3aJaM3XUxnDkvdZgvPE34TD39hMGS90cY0gVnPCo5R1EeEvnpXt?=
 =?us-ascii?Q?Ry47OPxknvmtlQoKvhUVpXZJ6OrRfIXcgPOjDkN1QscGJ5Lu6XPCuBavGGrr?=
 =?us-ascii?Q?VcL8V36efnDWIcq3wDXSKQsBX2kxBC5/iRBXNhITpZX1XWKVGmIZnBQDmug1?=
 =?us-ascii?Q?cT0woxhbvKkVau0GYPijqmirUoaMfP3bTjhEW8hOBnIqmWOue79Ss0BG67pC?=
 =?us-ascii?Q?p/G5Elq4PoG7uu2O5YUL8cPn0cQ9ci/dwmFwhZKWETBSaYpxvKYRjVIMNMMM?=
 =?us-ascii?Q?BqyhqEtl2FTPaAW6Ln/033BVKWBqPUBzcBDE9lOkFoHLgotZ4eIUDQ+n1Nnp?=
 =?us-ascii?Q?1EwdZlQF/oVwCjoNg41yhDKBZOGvxa7PV127zGc1Y/46kxlL/sZxNngAXtom?=
 =?us-ascii?Q?bJ3rPIupbwGDo8uZaJjTV+RNLfe8PI8b4ynOf3JlUH74Y+RuztjABNUBVGxw?=
 =?us-ascii?Q?rAqhRF4IK+PD5199momC6cN7rykbKo8yGVwZeM0iguA7TfgApovLN3ClmIJ+?=
 =?us-ascii?Q?vbjr05nwHRBvrCbP0hrrU80=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b04edc-5f1d-44d9-335b-08d9ba558788
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 14:17:56.1250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrJU5mhQ0KN9hprYBC5OAt9evq02mT/6GafUYE7Ydd1jKsZW2G319/rA4VX06osuX+qgkq0y/CGeGz/NMGwfBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5568
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The generic param max_macs documentation isn't clear.
Replace it with a more descriptive documentation

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 0eddee6e66f3..2cbdce4e6a1f 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -118,8 +118,10 @@ own name.
        errors.
    * - ``max_macs``
      - u32
-     - Specifies the maximum number of MAC addresses per ethernet port of
-       this device.
+     - Typically macvlan, vlan net devices mac are also programmed in their
+       parent netdevice's Function rx filter. This parameter limit the
+       maximum number of unicast mac address filters to receive traffic from
+       per ethernet port of this device.
    * - ``region_snapshot_enable``
      - Boolean
      - Enable capture of ``devlink-region`` snapshots.
-- 
2.21.3

