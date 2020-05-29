Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23171E7640
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgE2G5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:57:31 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:29351
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbgE2G5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 02:57:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHMQIij76sSy4MqWN1/76/OVp+Xl8vBDiZxcaYefaqNh4BEMcBy5Ps+IkiMgtWpfkjk+e7ypa9i1c12I3HIVazZT8fHS0yXAy4A4vfnfTr0MR0zXt7wgd0gX8Nl6zDQ7m5jZ+lhobyG1yG7QR7JcyDAjeV97waHZbtIAxdzfMYHPvQ6NOU7lQ2mnM58b0v0nNAPaESDrCUookpyApbPFg9BjjkzPBrJafBkUn67QueuodXwF+26GYYjUJ3VENMCaEfN/CMD+6mrBC2Dh5uMEnhib07Gn6+Bslh+wgPH47MsZ78b9yMvMfGuPytqmtksOAjRh5yInKF5P+bgv3jByXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaxE6wmNqatoj+cYpNIoKtsj/UkbrcSshsHd6A8BkDY=;
 b=Mq8Td6+JU8dMFQzJ6H2HmzRPGJBUDLEDfkSO/3ho1YDlaTUodYk/f8m31XRBGN/bL22jCPBFHaUxNr5P5eKcqJNzgi8npLLqncAknwwJPT2RciHqkNKFhKM1nEdsQjT77sbX5Ll5cGJVn6snL3DyE2mUZ2K6W9NI57axNJk8OEg0obzzaziB3GGDX65tXfu3OEwnEuWL3DtYFVUVcLOZvJgVfOcIMAdU1qLRp4KCZrZ8gVxWxnnMHfzBg6ACkLbz8/VnTNw6OaubGkhWxbZfkDsjI90Kt26YUKgbKuKcMZFarfMTEu/oI0ki7X79uDH2LCaQ1NiZtbdnqRlNxt89cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaxE6wmNqatoj+cYpNIoKtsj/UkbrcSshsHd6A8BkDY=;
 b=cvqtSdvy8Hq5Zt8PiDqPBkG4SUmfEw8Yy0AHXwVaCIjoS7mMzZNLXAYr5ittJP2JxTxAOyzMCreZjUlX5ctwvW5ogt+lQXSBl7PpBKbUnYWQNGbOef1p0YpeA2q6p2u47htTTzGWEkC8eGfb/cz3qCPs+B9Ypm4JDPNq8krwmqo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4189.eurprd05.prod.outlook.com (2603:10a6:803:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 06:57:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 06:57:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, jakub@kernel.org
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/6] net/mlx5e: Fix arch depending casting issue in FEC
Date:   Thu, 28 May 2020 23:56:43 -0700
Message-Id: <20200529065645.118386-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529065645.118386-1-saeedm@mellanox.com>
References: <20200529065645.118386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0027.namprd03.prod.outlook.com (2603:10b6:a03:1e0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Fri, 29 May 2020 06:57:21 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3e369f84-bfdc-4202-6e9f-08d8039d89cf
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189BE9B6B244A6BE33A5BBABE8F0@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lHHHnwzfqCaHIfy4mXOqnVbNoThVvphpHzyNFQxXdHKY8IwgQvxqV1bilkkMOIYbxlo3/UIVt1XwMulErxgKHfj8NEOMVQvmKL3k0EXaBhndXeDsFRP5oK/tZYgtglZlEUUnoXbls2GE1RzpaZI64BUyJQxs417vb1nhXjvSGr8Ebq+Iqr0borkof22ttrp1MdzrrszT8tTlh9xUl8EUeaOTeTs2TY+s5N/Ayo1+H0BLcHL+XCcjsaff77NAN3RPvybxkqwneF4uTkhxfXGjM6gZk1YkbIR0tYdg0zD+cxnHAwJH9fOi/VFrQB2Tje/Pd+KPprQrQy1fuqYkZi3mPASFOO2MF0G0BtEf1RYGn2/V6pevEHu4OWfqnEmQ87yY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(26005)(1076003)(66476007)(8676002)(54906003)(8936002)(66946007)(66556008)(2616005)(107886003)(5660300002)(956004)(83380400001)(6486002)(6512007)(186003)(16526019)(52116002)(4326008)(36756003)(6506007)(2906002)(86362001)(6666004)(478600001)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fLQPaZYYyKVxKjURmBLZam8qoyKBj/uqvvoburuiqOkaQyclJx5PuI4o2HF774bw8+xJtYAoBtvFUNKj6TAZnFoiEYsUARgWiYcsXNIFMEaCPQBRwgf3DGUFoEd4hMs593oH8lTfKz4qEJnnFNXF/BDECl13+EeqfqZgHjDB5NXuGSq0R8XQo57KrPqu2ihOh/7ylTFqIEv8Hwp2nJqaqZUbsYjQrAelO/fXCYUk+2doGwBueADablIWjsv8cxGevskXVjBB5uCqnszd8Vf9oe6xKyqYeQTktC1oGFiwhOzr8WJoh/wqBYIcgrBJboeRfpHq+Ks5QoBj2Qgqt6qnFr0mDa300tfm8IO6nGptqq7C2DePhDq2xgCfq7GENsfT7aRmz2+N4V9opqB/lC+msP5xvmB9kVHursTITuD9jNpQrF5hGd9V4C1Sqcc2ULj0jiLypPppOBItY9sFO1xJ9y2LTfyYUyCc9NoCvvLYgPA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e369f84-bfdc-4202-6e9f-08d8039d89cf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 06:57:23.2275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KGvcPz1heWD+OrVmIWBIH0xmQlr+LUxTIDQm0IwfiQNilCQyMW3j4+kicZGgbzTPCEVroxCit8N9JHwJmaJ00Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
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

