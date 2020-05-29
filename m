Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43F71E8825
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgE2Tre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:47:34 -0400
Received: from mail-eopbgr20089.outbound.protection.outlook.com ([40.107.2.89]:61282
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726866AbgE2Trc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:47:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EADvn+0MlYuQIxzw2DGZGAl+zQBu7EhePz+RkRbXEzkiMTe/Udm2GXjWAN5icaL86wn+d1Wnkg4oaRnWz0T1FpqDU4HPBmtwuccROT9EjeS+SY1q9hfQaVL1qgxHNT9B/8zmEBCWIPxIJnXQdHeNcpzbEuZaXGUJgihuKkFsvuMRvNlReQGDWXJaqOeP5l58PYHMbuqYb15+UDRtql9x81B+VbPeZ6+bphgThB/XjSlcPWBS7lxax7sdYap0d9Mmb+SONbP9ir+1Zdns9HL7tdR9qTrLzeH7tN/Aw/6Ns+nlWA2ZV5NN9DjfrZw+TKlBru5YQ896f7FRHMFk+5RAMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cS0kXWlHbNaeNKqhUHjCKCNUWKrmOvmDRvvcChWGOg4=;
 b=FGy7xvJVL5cNExzkFLTG/o+3tS5VmCRojpjELZYAKL0ZDc27YbA4tlVD8HREGjR2J7nPSMpluQx3GeJx3zgTVNQgQo+bVHuF4Fc15K2BYpa1EG7/uJ44bnr5BuTTTUWK/yt5p/4v7dci8Pox/+zL8cxPuRKG/9ZjY4719fSd9/glD3p9xPS0RF5VwTuk5ISGcl59ToV+ytCth9JBYX+PtTUWDIzcd3LaEGzmfwy6gNRUbP6MyJ9OXTkXgB+eGJ2ymdLGNDJTPmd7RSmmc5pwSX9F6x69XqAhTkq3LM/SlQyko3nxxsojLWQ8WoYWpAK9WduLUsUhGUPEFEUJCiVN9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cS0kXWlHbNaeNKqhUHjCKCNUWKrmOvmDRvvcChWGOg4=;
 b=I+a1msySHfefw+ixtAc0Ob+lhVtCJOFY+Ykic1aEOJIDUdj+0/3LcX5yGygX+JtMpmShFLt40TZu4a7oNH+kXot5Nez1ZhNR5B7F2M3GPN79HXaPnK/E31q3brnUO5DNDidq6mDRT9wMAYVmwQWfWI8OZ/onrgvnXkC8XrDHj4w=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6589.eurprd05.prod.outlook.com (2603:10a6:803:f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 19:47:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 19:47:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/11] net/mlx5e: kTLS, Use kernel API to extract private offload context
Date:   Fri, 29 May 2020 12:46:37 -0700
Message-Id: <20200529194641.243989-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529194641.243989-1-saeedm@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 19:47:16 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0768d057-d258-446c-04be-08d804091855
X-MS-TrafficTypeDiagnostic: VI1PR05MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6589199A04EF4D6BF5329054BE8F0@VI1PR05MB6589.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ah/oRyERsAaqtOPKkxXq/hM7UwCA9rzn/SNpOuEt42oxGv+GxExCiMnHks6QCBr5dESYhTG78aJPIUGNtmAzsq3SpDTjsw8uAksLXB98+ISCuNUo1CJPnhaQ+UHxYqokH+nb+vzj+kFcIXtlAKFjTvqDnJwm5JIyWWdo6r19jbkXGT3rzXwTv4ljGnbCNvBJ4tlsYzGa62cOsEphGaOyyV3S8OJrBTZX9Ni5qeZl5UYh3QKr+mNsudbNhXX77zmh+C6+s6309clXE179YX3xHya5/nbQKyIGB6MtQwahO7xeoZBwdm+pb7aFAWa5igl6TxC0EWk3mAlvmbFMClAr2XbvgJQD2hdKcy2dk+JcQdBJAC6/wNeaWExQjCsmMoue
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(6512007)(83380400001)(36756003)(186003)(4326008)(86362001)(8936002)(26005)(107886003)(16526019)(6506007)(316002)(52116002)(8676002)(2616005)(956004)(54906003)(6666004)(478600001)(66556008)(5660300002)(2906002)(6486002)(1076003)(66476007)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jjAHbyFmbQM2KPNidhcKlowfiRlKwbeNRCO9B6a+2AY5EJ+MycseaOwe/WVCI+r4oP4nz2kjsx7aIvI+laMVKPeReqxr4kGfQEUcnTRYhmR1GVUdKipfAg8lWnB2SqWYKZMVSpuE0YoTkmHucXxLibUUOuxU95fMBrRaXIb91bxlJoLXsanFA+GG3I5TQs2N2OqmsDvZvNjZo6zIryw/K6ZIh8N84YKmKdjni+SQd6UVB9AqvpNGUyPyMKfPPI1KxHOqWtL8sd5VR7XZoVPeVnhPUMDi79r9lpJNVZrT40U/1dDgOgAU/a7XdE25M58dfQoGNcwfw9r7Fb3j38S6FzjQHlDjZTUJ4CGegC4QgWOYKDVwtihy41uAJhMS7UiuUVAGeY9hJYQ20Fcw88gnku5SeAYcBLGxGLbp63vBYsEcbgu5mtpnRsowuAsW5HmljN0oWTqPIRUKBXQ4/nl013mjVrRui9jt4CkSNufzPSw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0768d057-d258-446c-04be-08d804091855
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 19:47:18.6804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MeY5Osuh9HMc2EFeB6NDJ3LHBjQfU2lxDXsfvd530c4s2xYLZUkb+PVHGU5tfev/D8oa+pQ3q9ka3dqKiKieSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Modify the implementation of the private kTLS TX HW offload context
getter and setter, so it uses the kernel API functions, instead of
a local shadow structure.
A single BUILD_BUG_ON check is sufficient, remove the duplicate.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 28 ++++++-------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 349e29214b928..5a980f93c3263 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -56,37 +56,26 @@ struct mlx5e_ktls_offload_context_tx {
 	bool ctx_post_pending;
 };
 
-struct mlx5e_ktls_offload_context_tx_shadow {
-	struct tls_offload_context_tx         tx_ctx;
-	struct mlx5e_ktls_offload_context_tx *priv_tx;
-};
-
 static void
 mlx5e_set_ktls_tx_priv_ctx(struct tls_context *tls_ctx,
 			   struct mlx5e_ktls_offload_context_tx *priv_tx)
 {
-	struct tls_offload_context_tx *tx_ctx = tls_offload_ctx_tx(tls_ctx);
-	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
+	struct mlx5e_ktls_offload_context_tx **ctx =
+		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_TX);
 
-	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
+	BUILD_BUG_ON(sizeof(struct mlx5e_ktls_offload_context_tx *) >
+		     TLS_OFFLOAD_CONTEXT_SIZE_TX);
 
-	shadow = (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
-
-	shadow->priv_tx = priv_tx;
-	priv_tx->tx_ctx = tx_ctx;
+	*ctx = priv_tx;
 }
 
 static struct mlx5e_ktls_offload_context_tx *
 mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
 {
-	struct tls_offload_context_tx *tx_ctx = tls_offload_ctx_tx(tls_ctx);
-	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
-
-	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
-
-	shadow = (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
+	struct mlx5e_ktls_offload_context_tx **ctx =
+		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_TX);
 
-	return shadow->priv_tx;
+	return *ctx;
 }
 
 int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
@@ -113,6 +102,7 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 	priv_tx->expected_seq = start_offload_tcp_sn;
 	priv_tx->crypto_info  =
 		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+	priv_tx->tx_ctx = tls_offload_ctx_tx(tls_ctx);
 
 	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, priv_tx);
 
-- 
2.26.2

