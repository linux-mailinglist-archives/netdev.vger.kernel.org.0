Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F511205C3A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbgFWTxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:53:21 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:47755
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387457AbgFWTxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 15:53:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdoezjDpfNO/VbAOOokicMVl+VNplzvRFUkP1e1LCU4KJjFZimDRxpJuQL22yKgn9BATosjszmj+lGHo98J3hWdJx/0ph6hnk9qkEov3KXIwsaSQEJAKx3zjnS7rw9541NBDCtW45wvMfEVoo1olewkNxvmEyVsGgG0EUMesg5Tr/a/km0qMspqcLPUYLAaHO6TlygpHshOnZZ6dr9FmQY6fqerJZxrTb2OomSlTrVBq4HHZmVPlheS0o/Q4LhxDQ4bQHr23kcRKPV+1AKIVcqffwdXtrVTL7F2kOOKrcK7xlntC2S3KwywArWtK850BnlwqIUxxb8SeBeSTSRQIYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCXRlHlu5CEt/4nsKsGeDz5XXV6Vz22WvOtXlDzTxto=;
 b=mr675TVsVOo02/YyU8q2esHawxSuGefO2b/NISNJnz95esL1hds/qmrMZzLL6yEyXvq2yMWwPVANHBxp2Tm5Z4ZsRtPF3fCK/FkTXJKECr19f0YFJNQkiuWMwvx/FSw19tJq1RMEuHt50WOpy5xqbJ4g/O4TNyhUb0gI+d2mz3T1iWwS6IFRHBh1a1u7eoZO+9iT3xB0GYRoCIeFvqsS7jy2FoUIgJC89iT4fAPkYb7dkFggBA34Tskde8pppIWRKIvDIRXALXjoBf54Wui5LCUAr95mvCSQRGvFk50IOI3blHUvJIU8sFuMFbkwoMheqWhFxOM1C/pJHOkWme/pDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCXRlHlu5CEt/4nsKsGeDz5XXV6Vz22WvOtXlDzTxto=;
 b=pELpUHQW2URwdzCzvQt6Tr2+ixe13xKM6Ey1n6pqUshq8qor20Gm7ESBL7B1+xgFUmISiHPI+zq+YRPGT2UnAuEPgNd8ZA7RJe8ou5oR47dVqjoHq16l2BBYEyrDACl7FEUo2+ATdyD1LnWFtPbHFUWUw2FBmIyyfCLGpLJ6Awc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB6101.eurprd05.prod.outlook.com (2603:10a6:20b:ad::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 19:53:08 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:53:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Maor Dickman <maord@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/10] net/mlx5e: Move TC-specific function definitions into MLX5_CLS_ACT
Date:   Tue, 23 Jun 2020 12:52:26 -0700
Message-Id: <20200623195229.26411-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623195229.26411-1-saeedm@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0081.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::22) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0081.namprd11.prod.outlook.com (2603:10b6:a03:f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 19:53:05 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 63f0fd1a-ce25-454b-b0dd-08d817af0ce7
X-MS-TrafficTypeDiagnostic: AM6PR05MB6101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6101F1D217D0C08486640539BE940@AM6PR05MB6101.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:308;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tHqfIP4hkvgAxdrn+kJX2UYXGNeAKqATStv475s423PYWNvSwnTetXi2eAyWRCVpTWEaleLC4SmDrmJVWVST2fniwOGRNDrQxOf/Kg2quFOLJtrcBrU5jKBkzIaGT9/4bNMkuL2kAJGOmfLmXRnDd24CMYM3mAJJbkT6EAoDedm1CMRHXfZkKU79hP4vaXWMAIzdicEEVLYREk0/tXQvVQdRx2iV3mIMMcOLdlPm04B93whD8pp/eDi6Q6rO61Y6OKcNzoQDiilNBn6p9uQDMrzjc97Nhebb0kPp42LBCNganRfLmWR08zK1if3/dAX4ZiQ3iVcxaRTuPwn7AiCidY+VEJX6n1Mj43TaqKuwEf02EVnOwyNhBgJwfE3rC7s/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39840400004)(346002)(316002)(107886003)(2616005)(4326008)(6506007)(956004)(186003)(54906003)(6666004)(16526019)(6486002)(66946007)(1076003)(66476007)(36756003)(66556008)(8676002)(52116002)(8936002)(86362001)(83380400001)(2906002)(6512007)(26005)(5660300002)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UGU7P+957ClJDnRGAfiZm+c20kZQOgdxICqB8CEmZVQTY8ft1j8hgxEbgpiPR8y6dIY0GeiFMMN4dYredQunx/z6jWQrovf2CSQOmtp4hYBUZjAjZTd28H3Qe/mt3Nt6dh1+DenOF2NX5aflBToCPDk2Y6ScC2LGPt5iVvp5Ih14/hYerdnKHFihTrAiJxZWRiXjeXPwDglSDTl7eyZoCRrJ5a76+P7Qt4xNZ6P2Hc2gCqsA8lfoXAQtJxeT7aj7KFEyj00J3jacUA0ZyLwaMldCP4kt2LUAECW/Y5ho16mgIZiwoK7rJF+5FSH0x0vnrto8rDy33zlJv8W0WpKzUX/4cBi8VkVwPor8HRgDY06nY8KV0pB0CbtN/HWQKC7bWk6yAAoCswm0i3XZuvfh1BNV/PKqpweutTlFLEHI1rQP8uBBn9pqUb0HEToQBISj/eUHDtmCPSvHGvgouvSDlM4RYatl5unQfajbgjyQhII=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f0fd1a-ce25-454b-b0dd-08d817af0ce7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:53:07.7830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7fBxWMvGj/C6C/uLVifzOpdLhupbt7ZWEsNybGQqCHwZ6l2DKAA42h/LtYMGGFQa/8uTjQnuhffMQ3hgMLhoFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

en_tc.h header file declares several TC-specific functions in
CONFIG_MLX5_ESWITCH block even though those functions are only compiled
when CONFIG_MLX5_CLS_ACT is set, which is a recent change. Move them to
proper block.

Fixes: d956873f908c ("net/mlx5e: Introduce kconfig var for TC support")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Maor Dickman <maord@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 5c330b0cae213..1561eaa89ffd2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -40,6 +40,14 @@
 
 #ifdef CONFIG_MLX5_ESWITCH
 
+int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
+
+struct mlx5e_tc_update_priv {
+	struct net_device *tun_dev;
+};
+
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+
 struct tunnel_match_key {
 	struct flow_dissector_key_control enc_control;
 	struct flow_dissector_key_keyid enc_key_id;
@@ -114,8 +122,6 @@ void mlx5e_put_encap_flow_list(struct mlx5e_priv *priv, struct list_head *flow_l
 struct mlx5e_neigh_hash_entry;
 void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe);
 
-int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
-
 void mlx5e_tc_reoffload_flows_work(struct work_struct *work);
 
 enum mlx5e_tc_attr_to_reg {
@@ -142,10 +148,6 @@ extern struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[];
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev);
 
-struct mlx5e_tc_update_priv {
-	struct net_device *tun_dev;
-};
-
 struct mlx5e_tc_mod_hdr_acts {
 	int num_actions;
 	int max_actions;
@@ -174,8 +176,6 @@ void mlx5e_tc_set_ethertype(struct mlx5_core_dev *mdev,
 			    struct flow_match_basic *match, bool outer,
 			    void *headers_c, void *headers_v);
 
-#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-
 int mlx5e_tc_nic_init(struct mlx5e_priv *priv);
 void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv);
 
-- 
2.26.2

