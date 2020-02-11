Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C59159C52
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgBKWgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:36:13 -0500
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:38926
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727720AbgBKWgJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:36:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuX8s/DnN+zYyvJpE8G6lFpnshiXTlfTBuOlP8JP2H9zUyzk9QJHSSSeyR64J7j9/0ErHLzmJ1DVZ2zZ3cMXdQ2iv/nqEyjUquwoi9i9uOH5uZdQefA3FBQuFirsehGu+awBl6mg778ScEj/iz6cI98GM1rtVs9W6Jq8ikrs19V/9Sw23R0MYhxCOE9fAZ5UVect9k46dS9nWlaJde3Cd4wgOlFOSLmSeTD/7KyJrCdzOumqiVUo4m+mqmc0/yXLQAgUchoO0FTvjufsGb7pxhhxpb2JDcLYoKXChhHvIkT9QkIUZPOP/g9JZW4n84jsj3sdj8p+ZCSFxMwnRw7nFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvDSN5B7clyCHKgdxmsXYD1J2LKr3C7znCAdAx2ZO/c=;
 b=TWbnMtpdVCi5IjAaVEoOj5BvLIsAg9dZAP568Yc+rql5uHnCEKRWxEMzJ9xDbZfYOaWLhNWOB81OPaeIH87DvVqOlAVvy9cgxhlL9HbDVK8xeY7ZetqH9ZMDy9wQmKaxSMk2KldFvPhzEknKGDU7A+6JErySWIJLqurJdRt4yEPDnlRt0zy5DEnxk6gR58WL90Wc0++zKbzt2yVj+6Kz0mLrgEoodAsK9PioEgYxrGk3SARbdmBXkhxcKbR+sqlmfjdxzGF8qUpu/FyNt0o4k3V99/ULUsYUYsCc7m6azrTZsi5X8uAckk1ezv943d6ayTBkjGAD+uXIEMJbjgUkjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvDSN5B7clyCHKgdxmsXYD1J2LKr3C7znCAdAx2ZO/c=;
 b=lVWzDDXS5AL6U0YLWiSHYhD5w1Iavj5aqzBaZxMPtWbBGcYKp9/NrVwWl1kHQGeeYhnED3ZRt/J3AWp6c04D3CgnpB/DPRv8ewZN6+volhVi0D1E0VR9yGpXAMw/SQZc6XoUiSEelcOSSEd3YSFD5IgJ+OxB/V1vocjIBFo9hBE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:35:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:35:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 09/13] net/mlx5e: Advertise globaly supported FEC modes
Date:   Tue, 11 Feb 2020 14:32:50 -0800
Message-Id: <20200211223254.101641-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:35:53 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 88964a9c-321c-4c8f-b4b7-08d7af42c1a1
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4383F9198CE109CD57F304ABBE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(110136005)(36756003)(5660300002)(478600001)(81156014)(6512007)(54906003)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tQvK9aIYfz/umVLwZBKrbhsw56sQQkz1GJqWr9zBMts6rK90kphKMvC5oY3ORm1iyoGLHdqnQZqkVvx8+HzPx4oJCVfRyX1sZDKqDvwcp5ypHeXwU+NDUQ/4DFklIAUGSLHsHpOfRO8u96JAcbWnR5YrDlwa0vlA5MGoNz29NNvv1hLc09ygH7xV0nyRQA0bbiem0MFWp3FXNr3cW0gKh83izmkoNqkJDwHJ/7RWvTit6UuUkEyVIhEnHLPyAWiA6hUgBwQ9w3uvfkET1otKi5y5vfXi+yaBbsgsMH2nloHXRxrdX1h48a/NKmVJdf+4BBZLtWC6vEDFcBa0lCC+SEMzRkKbVWw+TYMzeYTZlpi32xjyR91lwYJWyRuUqSrluSk8IEX+jst3nhzsR36lQUwtUTizHnXwDHR7k6Vx35qyQxEa2QAsKCAXprz7OoxpByT0zvG2xx9YuCFXY5Kv4lQNV5wSQYm5FVlz77DO1OV93aaXEx4SpXKx0cd5anKjWfDijjKIeJntSjQ9Pb52VjEOKrlGvuOH8qL6iav0IWQ=
X-MS-Exchange-AntiSpam-MessageData: 7Z68qzHTEvlSA33KZvnUW52462RcL8Bcl5LPIdhrMA3RsN7Aao8cXhPTcMN/xzySeZDUqj+g9Dgs27UHBtfkwB9LIiMw/fN2QcbDx4HlWRtqSqx19SR7gE4wr0phIE3tQv21V0j+ivKBtjtZy6Oj8w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88964a9c-321c-4c8f-b4b7-08d7af42c1a1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:35:55.7531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +zbmND5ElhvQvOrqt9NVo6eaTa1gpwq3tBkQ2CAe9sokKK9u3eXrhYFy4lPTptPcR9J8QIWbnKW6ybLDDy0tuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Ethtool advertise supported link modes on an interface. Per each FEC
mode, query if there is a link type which supports it. If so, add this
FEC mode to the supported FEC modes list. Prior to this patch, ethtool
advertised only the supported FEC modes on the current link type.
Add an explicit mapping between internal FEC modes and ethtool link mode
bits. With this change, adding new FEC modes in the downstream patch
would be easier.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 17 +++---
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  2 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 55 +++++++++----------
 3 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index f0dc0ca3ddc4..26c7849eeb7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -441,13 +441,13 @@ static int mlx5e_get_fec_cap_field(u32 *pplm,
 	return 0;
 }
 
-int mlx5e_get_fec_caps(struct mlx5_core_dev *dev, u8 *fec_caps)
+bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy)
 {
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(pplm_reg);
-	u32 current_fec_speed;
 	int err;
+	int i;
 
 	if (!MLX5_CAP_GEN(dev, pcam_reg))
 		return -EOPNOTSUPP;
@@ -458,13 +458,16 @@ int mlx5e_get_fec_caps(struct mlx5_core_dev *dev, u8 *fec_caps)
 	MLX5_SET(pplm_reg, in, local_port, 1);
 	err =  mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPLM, 0, 0);
 	if (err)
-		return err;
+		return false;
 
-	err = mlx5e_port_linkspeed(dev, &current_fec_speed);
-	if (err)
-		return err;
+	for (i = 0; i < MLX5E_FEC_SUPPORTED_SPEEDS; i++) {
+		u8 fec_caps;
 
-	return mlx5e_get_fec_cap_field(out, fec_caps, current_fec_speed);
+		mlx5e_get_fec_cap_field(out, &fec_caps, fec_supported_speeds[i]);
+		if (fec_caps & fec_policy)
+			return true;
+	}
+	return false;
 }
 
 int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
index 4a7f4497692b..025d86577567 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -60,7 +60,7 @@ int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void *in);
 int mlx5e_port_query_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer);
 int mlx5e_port_set_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer);
 
-int mlx5e_get_fec_caps(struct mlx5_core_dev *dev, u8 *fec_caps);
+bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy);
 int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
 		       u8 *fec_configured_mode);
 int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d1664ff1772b..6624e0a82cd9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -650,45 +650,44 @@ static u32 pplm2ethtool_fec(u_long fec_mode, unsigned long size)
 	return 0;
 }
 
-/* we use ETHTOOL_FEC_* offset and apply it to ETHTOOL_LINK_MODE_FEC_*_BIT */
-static u32 ethtool_fec2ethtool_caps(u_long ethtool_fec_code)
-{
-	u32 offset;
-
-	offset = find_first_bit(&ethtool_fec_code, sizeof(u32));
-	offset -= ETHTOOL_FEC_OFF_BIT;
-	offset += ETHTOOL_LINK_MODE_FEC_NONE_BIT;
-
-	return offset;
-}
+#define MLX5E_ADVERTISE_SUPPORTED_FEC(mlx5_fec, ethtool_fec)		\
+	do {								\
+		if (mlx5e_fec_in_caps(dev, 1 << (mlx5_fec)))		\
+			__set_bit(ethtool_fec,				\
+				  link_ksettings->link_modes.supported);\
+	} while (0)
+
+static const u32 pplm_fec_2_ethtool_linkmodes[] = {
+	[MLX5E_FEC_NOFEC] = ETHTOOL_LINK_MODE_FEC_NONE_BIT,
+	[MLX5E_FEC_FIRECODE] = ETHTOOL_LINK_MODE_FEC_BASER_BIT,
+	[MLX5E_FEC_RS_528_514] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
+};
 
 static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
 					struct ethtool_link_ksettings *link_ksettings)
 {
-	u_long fec_caps = 0;
-	u32 active_fec = 0;
-	u32 offset;
+	u_long active_fec = 0;
 	u32 bitn;
 	int err;
 
-	err = mlx5e_get_fec_caps(dev, (u8 *)&fec_caps);
+	err = mlx5e_get_fec_mode(dev, (u32 *)&active_fec, NULL);
 	if (err)
 		return (err == -EOPNOTSUPP) ? 0 : err;
 
-	err = mlx5e_get_fec_mode(dev, &active_fec, NULL);
-	if (err)
-		return err;
-
-	for_each_set_bit(bitn, &fec_caps, ARRAY_SIZE(pplm_fec_2_ethtool)) {
-		u_long ethtool_bitmask = pplm_fec_2_ethtool[bitn];
+	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_NOFEC,
+				      ETHTOOL_LINK_MODE_FEC_NONE_BIT);
+	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_FIRECODE,
+				      ETHTOOL_LINK_MODE_FEC_BASER_BIT);
+	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_RS_528_514,
+				      ETHTOOL_LINK_MODE_FEC_RS_BIT);
 
-		offset = ethtool_fec2ethtool_caps(ethtool_bitmask);
-		__set_bit(offset, link_ksettings->link_modes.supported);
-	}
-
-	active_fec = pplm2ethtool_fec(active_fec, sizeof(u32) * BITS_PER_BYTE);
-	offset = ethtool_fec2ethtool_caps(active_fec);
-	__set_bit(offset, link_ksettings->link_modes.advertising);
+	/* active fec is a bit set, find out which bit is set and
+	 * advertise the corresponding ethtool bit
+	 */
+	bitn = find_first_bit(&active_fec, sizeof(u32) * BITS_PER_BYTE);
+	if (bitn < ARRAY_SIZE(pplm_fec_2_ethtool_linkmodes))
+		__set_bit(pplm_fec_2_ethtool_linkmodes[bitn],
+			  link_ksettings->link_modes.advertising);
 
 	return 0;
 }
-- 
2.24.1

