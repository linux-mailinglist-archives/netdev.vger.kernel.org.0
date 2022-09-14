Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B70E5B84B3
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbiINJPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiINJOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:14:17 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2070.outbound.protection.outlook.com [40.107.102.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFA17D1D1
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 02:06:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcLB6bViz8WOY34LIWXwJTDyM5oVFsUaVOLRIQOe1iPEmmm6BQP9209oSvaQ9g6gnOPfPLCngMoTbVSChRKIFd+vqfQckAteAJ7IfDAxBPbJf48QkChCK+/dqfSfLTJUbK4NNZFf+9ap8CvwgXJL5M7nj87LLKpTp/VdiQPKqTWMHucWSHcLhJVKXrhb+cdBSjQp1xHQ3I29xB209o8EfbH7lc57p1CVKpWnftHenHTfUqBByDIsNMwE2/tSTJikeFaDMQQkC+VLvH6mvMRnH6LbS8tGgXAfQW7WUzTFSV9iO/TDBQQLqkwGhIW4MxGQycaYAcJRFY3q1PgrVu6crg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4hvCwSVmYMq8TnNK+jD4dvnMPFguxHSrFAXsYp9F/I=;
 b=A/7xyl7LWH3egiXsn1VbX1dvOhR6qNhwRuXe1JE/NGZ91VbjPMsExopWaqiJOp1zVe8knOHE/3CZ+N5RZOCDMjxqSqK1qgGGVAzPECLvw1cJnP3sPzkEekXW8TYWGYieC1Xohha6Q6cX2yi4i3X38yOQarbpVN9RekRmXSI69HHXi0UZ6IRuS3mJgrap6ShVwX8O+/bskiCCqWGi7n6Kw6fYftf27fVsuOpJTzLhQK9cIaWbBpLU7KkGzwLHk0jrC93vU2Uciz18s8Df3SbduU+Cd6byq1G4hnDyzukjwkhc/ehG1l+UfxRg/uxQYOKunmSQ7BgdXeRoDBqmvKts3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4hvCwSVmYMq8TnNK+jD4dvnMPFguxHSrFAXsYp9F/I=;
 b=WURKRE4SoIW3ajsrTiv0Bln2uSaUjJdmNaMIBArWF8QtGfSukL4kvN9o3bhXWqVqyDC2eRyj8uHeWfZ/XUm/5/uowFe4qMhRb1QqMwH0ifrpnyinyUtxO6lvo+tSUSBvqieNd/aHdVZK6q+CwfZ9QDlX0bm64emxSVhjH1JySmRekqlKoFKWKLGp6SSaulP63toIIm5SDFmuFgtRDcCL/SCTICvWZ7JKDzfQF2k40Vvu3hJMLdZvzWGXbAYwozXRmOTvFwHQv9n5c28goGS0FXIvdFNYHvc3gNp9zDEoc5NFjeFJEkRlkTM1CO3VUt1OoUYONbOCei3pLvL4Ls1FkQ==
Received: from BN9PR03CA0705.namprd03.prod.outlook.com (2603:10b6:408:ef::20)
 by DS7PR12MB5960.namprd12.prod.outlook.com (2603:10b6:8:7f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 09:05:49 +0000
Received: from BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::d2) by BN9PR03CA0705.outlook.office365.com
 (2603:10b6:408:ef::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.15 via Frontend
 Transport; Wed, 14 Sep 2022 09:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT109.mail.protection.outlook.com (10.13.176.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 09:05:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 02:05:33 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 rnnvmail204.nvidia.com (10.129.68.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 02:05:32 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 02:05:32 -0700
Received: from vdi.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Wed, 14 Sep 2022 02:05:30 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next 3/4] net/tls: Support 256 bit keys with TX device offload
Date:   Wed, 14 Sep 2022 12:05:19 +0300
Message-ID: <20220914090520.4170-4-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914090520.4170-1-gal@nvidia.com>
References: <20220914090520.4170-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT109:EE_|DS7PR12MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 774d827e-c1a8-4247-4846-08da9630510f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sm9x3BdQF3UJl6Bvju9+jMtYF+vRTx9T/sHA1OIkbL8Erg4sYXY1tCxwdvMIgF9qfPJkN4w0G3HofP4PbeXGVNgqrMyJrd2N4io6M2/nsidoWL+Hu9scoheSivcTRMtjvvkt7yLgkdfbzx6ohTCgkhYU4P0aGcTvcSR+zkd8J0uoSyiaBYjDd6m4k7xmJiGYJTsO1p/sCKpNI0tBqomqmRf6APcJwzZwPXGvjX2/sPUc4cvkaZ5B5A2Dh2LJPO7nsLXg/I2J4hjikA8zf4NcOH+G9T1uvEkRVqKEK+umsjMCFRFAizL2pFO+Fe38JZXW8YHc0bFFNLn6dy9uprgE4m+wAtBlPa6J9adV+1rXlEY2S406nCKlIglBmuFsW50jWgQJSJh4GTXtiANlXafAH2FzGt9mOQj5/Q+sg9WadH+rhZcm5/uwIPtPzQ/xy736AUZd12KexHaYcgKL2sE2DgWRrGDGQz6c2xdeysorrhVvG9TRJ5v03iM7FyaACRjYuYZi59sDpW7hqPLhNuuv9TNJXrFvjGUSAvdkKYMx00H13GlgddEuiYsqmhG4TsvBktZcIzY4yOq/v2eEvAuu1mYKLSxuXttj9WmBK8g84tLwauHoG9KtMK8uSYF8nxvKgnm01jvMCmMtkVmSICu8NtakYMmKCTuqufVRFTiZtHuO90AZGl8l8Y1azy12+o4iMaSHgwTmbqueYVvev3UE6ZYdye7ms3ZX0lOlLwqOYfiyDrPIn9xBHZ5YqzNelwP+D3yz1P2FDz4t97XU8bzxFQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199015)(36840700001)(40470700004)(46966006)(478600001)(40460700003)(40480700001)(82740400003)(86362001)(7696005)(36756003)(426003)(41300700001)(47076005)(36860700001)(356005)(7636003)(110136005)(336012)(6666004)(8676002)(107886003)(70586007)(54906003)(5660300002)(26005)(82310400005)(4326008)(2906002)(70206006)(316002)(186003)(2616005)(8936002)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 09:05:48.6868
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 774d827e-c1a8-4247-4846-08da9630510f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5960
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing clause for 256 bit keys in tls_set_device_offload(), and
the needed adjustments in tls_device_fallback.c.

Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 net/tls/tls_device.c          | 6 ++++++
 net/tls/tls_device_fallback.c | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 3f8121b8125c..a03d66046ca3 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -914,6 +914,7 @@ tls_device_reencrypt(struct sock *sk, struct tls_context *tls_ctx)
 
 	switch (tls_ctx->crypto_recv.info.cipher_type) {
 	case TLS_CIPHER_AES_GCM_128:
+	case TLS_CIPHER_AES_GCM_256:
 		break;
 	default:
 		return -EINVAL;
@@ -1111,6 +1112,11 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 		rec_seq =
 		 ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->rec_seq;
 		break;
+	case TLS_CIPHER_AES_GCM_256:
+		iv = ((struct tls12_crypto_info_aes_gcm_256 *)crypto_info)->iv;
+		rec_seq =
+		 ((struct tls12_crypto_info_aes_gcm_256 *)crypto_info)->rec_seq;
+		break;
 	default:
 		rc = -EINVAL;
 		goto release_netdev;
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 0d2b6518b877..cdb391a8754b 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -64,6 +64,7 @@ static int tls_enc_record(struct aead_request *aead_req,
 
 	switch (prot->cipher_type) {
 	case TLS_CIPHER_AES_GCM_128:
+	case TLS_CIPHER_AES_GCM_256:
 		break;
 	default:
 		return -EINVAL;
@@ -341,6 +342,9 @@ static struct sk_buff *tls_enc_skb(struct tls_context *tls_ctx,
 	case TLS_CIPHER_AES_GCM_128:
 		salt = tls_ctx->crypto_send.aes_gcm_128.salt;
 		break;
+	case TLS_CIPHER_AES_GCM_256:
+		salt = tls_ctx->crypto_send.aes_gcm_256.salt;
+		break;
 	default:
 		return NULL;
 	}
@@ -484,6 +488,9 @@ int tls_sw_fallback_init(struct sock *sk,
 	case TLS_CIPHER_AES_GCM_128:
 		key = ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->key;
 		break;
+	case TLS_CIPHER_AES_GCM_256:
+		key = ((struct tls12_crypto_info_aes_gcm_256 *)crypto_info)->key;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.25.1

