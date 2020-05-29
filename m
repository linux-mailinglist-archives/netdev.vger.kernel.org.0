Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A4A1E8924
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgE2Uqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:46:54 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:6087
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726975AbgE2Uqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:46:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntEic9bNn5Gusyh8OAwY2Ezwgayu3YUsXuOjD+As8gswfuUMGn4P02Q02nN8Jy/ml3ZKq/H4wA7mLP4/hxPLq3u03GtJDtlAvubvPIzV1WlDKy2SAL5rSeZCqH4sqgVghTYvaOUbTgBZqOzwy86y1q0LzrqBIrgt0vDKyADdOd04Bur5AK3+3sz9NF5m26YYYpw6x7f68c5ZLK2Hf6TcwsBsgaboGjjxe6HvSqAWwTbpwQxyBLHTyUo/wTgg0h4VS1PTu3YLN/iHRRMf0LRG+fjeRuYV/uQHwQjFYsuqT/wKgpu4sQQMIf9qi08mf5Y/XyBzR2P/KBhh/YhVvStTgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaxE6wmNqatoj+cYpNIoKtsj/UkbrcSshsHd6A8BkDY=;
 b=NSgjXKh27kmKRqOC1l/JPwk8cEWXlcmVYsx/tFGuSNUMD26oNwevCgZG8bZqCeQgZe+Lm1ycuVd3UKSdYQyRp5776Y3AwqXIOCpQzyfjQ19yC4nmycy1l5jPUa33GxuenkwP4kZDnnUPIuUnCCaA2zXNAYNlOYJmJOwrUI/QWkoTo6VtFAAMj3NLbDf6FyuLNvaznRNZGIb5+oQ2gPp9iLKOLDTjXPCUSvENqEf3VH0lIWt423baUXXAsF0sfdJbDOMeAWiZGSydyDcVBLeUhXv30GPS0b2UKS7MuD2l5rN86bAXPBmTVkbCd7fE7YmzTdodGPkyVU9+ssnsTL8rBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaxE6wmNqatoj+cYpNIoKtsj/UkbrcSshsHd6A8BkDY=;
 b=LF71kVpAbXze9nuW5N5cp8+mzgHaxZTu3mgedN2mWmRm5o23dzHgzWAlLPWPEYrOLnJWA0Q+dimQPjd8SHt0+0BerWKJb74m4DrCs68NT4pUPg4CJo0b0t8YktR7i7YutoUMxRcNtU976l1uyrztoEf5dIOXmXz19YBqvkcx5Wc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3359.eurprd05.prod.outlook.com (2603:10a6:802:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 20:46:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 20:46:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 4/7] net/mlx5e: Fix arch depending casting issue in FEC
Date:   Fri, 29 May 2020 13:46:07 -0700
Message-Id: <20200529204610.253456-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529204610.253456-1-saeedm@mellanox.com>
References: <20200529204610.253456-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 20:46:46 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f194e5d-cccd-4525-7c0f-08d804116821
X-MS-TrafficTypeDiagnostic: VI1PR05MB3359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3359373A394F5D02E8E1E0B1BE8F0@VI1PR05MB3359.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +B4Fdu7eapsQOagFp/KBsVojX2HvnxbuGZLZY7hddp3ksVY7pGk/eWk+HLCFKlkC6PCEAoASvefdF/ooA/1hoUcsC01gsiq8vXLkFqvmG+Kv2jYt281EJr340f4zce2Z4AawCW+qMDCcFJmNCpbNoRLlzalowv9ll65+laMBatdbwCJHCHChvVhlZR3b4ny1wkE0LiXuGV5APMFpVkLAmhhJN5vcwZCZE0bnNA6kCPu/Rm2Cl5tndubxp2at6r3iFc48ZecHIzgTPqWYuDOnOMgjxkEF/T8Q8SQ55jsyhamww0ffSZQJ7N4hvMNp7yaR1+1Zkp83nxj0QBjvKFARQAWyksU/2uxIN0Gp5HmCL+c3e82zOWPYrhhQ6Fc6G+ek
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(2906002)(66556008)(86362001)(478600001)(956004)(2616005)(6486002)(54906003)(16526019)(6506007)(316002)(186003)(26005)(83380400001)(36756003)(66946007)(8676002)(1076003)(8936002)(66476007)(5660300002)(52116002)(6512007)(107886003)(4326008)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: d93vRhdbtNeevhyHJGHnzwVPc1gYBgX3cQqVBvztxESq+QsjZMYOMgd30uLqm8FJBLKwnlQjASyhAHHwbKhParOD4dNWBBioNCJKbb2mzUaKnM43MnLzEdkwDZq1lG0SIBfxCggBfPhcCDaKK4mWPJo/DBJsZoR8UDeFmrjEptTLWM+5n76Sx3i0tunxcbMsHMgz/b4sKs6/ekbkFbJgUVDb5SwdLPBdYPaNQ3j4N/vXOrD6q/Jzfq27h7qjFn/6+AGkUSCd9U16oVqSeoBsMBaXMnGnENkujC/4/lpCY78ARgv2GI5fBZZ/C0oprwAo/I5cTYPl0oKoWVLUvt5ZaDEMI0ZSl0Fmmerd+iMwSkg+gPf7Y8rDac+/Imr0HuNt7Gsi9S88mj0zD1TslkE2gruNNGC8uUqm6WgGkUIdetH65F8gRmj+S8wDKrcrKOkpBAXQDSoo4iKwPbLMGfYADdZlZEx1Tb9Sh1YqKZG/aYM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f194e5d-cccd-4525-7c0f-08d804116821
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 20:46:48.6032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8Q2BCGOo2b5H+pnM/7paqxdtu8+MppSBN3hNpnYzcOnENuXkLytoqkB5olmTyQ7S18sabIwYs6IcLiYkHfQ1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Change type of active_fec to u32 to match the type expected by
mlx5e_get_fec_mode. Copy active_fec and configured_fec values to
unsigned long before preforming bitwise manipulations.
Take the same approach when configuring FEC over 50G link modes: copy
the policy into an unsigned long and only than preform bitwise
operations.

Fixes: 2132b71f78d2 ("net/mlx5e: Advertise globaly supported FEC modes")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 24 ++++++++++---------
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 20 +++++++++-------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 2c4a670c8ffd4..2a8950b3056f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -369,17 +369,19 @@ enum mlx5e_fec_supported_link_mode {
 			*_policy = MLX5_GET(pplm_reg, _buf, fec_override_admin_##link);	\
 	} while (0)
 
-#define MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(buf, policy, write, link)		\
-	do {									\
-		u16 *__policy = &(policy);					\
-		bool _write = (write);						\
-										\
-		if (_write && *__policy)					\
-			*__policy = find_first_bit((u_long *)__policy,		\
-						   sizeof(u16) * BITS_PER_BYTE);\
-		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(buf, *__policy, _write, link);	\
-		if (!_write && *__policy)					\
-			*__policy = 1 << *__policy;				\
+#define MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(buf, policy, write, link)			\
+	do {										\
+		unsigned long policy_long;						\
+		u16 *__policy = &(policy);						\
+		bool _write = (write);							\
+											\
+		policy_long = *__policy;						\
+		if (_write && *__policy)						\
+			*__policy = find_first_bit(&policy_long,			\
+						   sizeof(policy_long) * BITS_PER_BYTE);\
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(buf, *__policy, _write, link);		\
+		if (!_write && *__policy)						\
+			*__policy = 1 << *__policy;					\
 	} while (0)
 
 /* get/set FEC admin field for a given speed */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 6d703ddee4e27..6f582eb83e54f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -665,11 +665,12 @@ static const u32 pplm_fec_2_ethtool_linkmodes[] = {
 static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
 					struct ethtool_link_ksettings *link_ksettings)
 {
-	u_long active_fec = 0;
+	unsigned long active_fec_long;
+	u32 active_fec;
 	u32 bitn;
 	int err;
 
-	err = mlx5e_get_fec_mode(dev, (u32 *)&active_fec, NULL);
+	err = mlx5e_get_fec_mode(dev, &active_fec, NULL);
 	if (err)
 		return (err == -EOPNOTSUPP) ? 0 : err;
 
@@ -682,10 +683,11 @@ static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
 	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_LLRS_272_257_1,
 				      ETHTOOL_LINK_MODE_FEC_LLRS_BIT);
 
+	active_fec_long = active_fec;
 	/* active fec is a bit set, find out which bit is set and
 	 * advertise the corresponding ethtool bit
 	 */
-	bitn = find_first_bit(&active_fec, sizeof(u32) * BITS_PER_BYTE);
+	bitn = find_first_bit(&active_fec_long, sizeof(active_fec_long) * BITS_PER_BYTE);
 	if (bitn < ARRAY_SIZE(pplm_fec_2_ethtool_linkmodes))
 		__set_bit(pplm_fec_2_ethtool_linkmodes[bitn],
 			  link_ksettings->link_modes.advertising);
@@ -1517,8 +1519,8 @@ static int mlx5e_get_fecparam(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
-	u16 fec_configured = 0;
-	u32 fec_active = 0;
+	u16 fec_configured;
+	u32 fec_active;
 	int err;
 
 	err = mlx5e_get_fec_mode(mdev, &fec_active, &fec_configured);
@@ -1526,14 +1528,14 @@ static int mlx5e_get_fecparam(struct net_device *netdev,
 	if (err)
 		return err;
 
-	fecparam->active_fec = pplm2ethtool_fec((u_long)fec_active,
-						sizeof(u32) * BITS_PER_BYTE);
+	fecparam->active_fec = pplm2ethtool_fec((unsigned long)fec_active,
+						sizeof(unsigned long) * BITS_PER_BYTE);
 
 	if (!fecparam->active_fec)
 		return -EOPNOTSUPP;
 
-	fecparam->fec = pplm2ethtool_fec((u_long)fec_configured,
-					 sizeof(u16) * BITS_PER_BYTE);
+	fecparam->fec = pplm2ethtool_fec((unsigned long)fec_configured,
+					 sizeof(unsigned long) * BITS_PER_BYTE);
 
 	return 0;
 }
-- 
2.26.2

