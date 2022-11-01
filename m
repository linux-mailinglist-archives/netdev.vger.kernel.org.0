Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CD3614823
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiKALD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiKALDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:03:25 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2127.outbound.protection.outlook.com [40.107.95.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0C319024
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:03:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJS30ubG6S3KXPI2lQVEKEIyxe1mKMpwKrg4IlB6Hh9nkVFTn5s1/iSIQvyS13vTGmk8NQ+flRS3YYNcab3boRGK3DPPr1OCJ6R59r3oBYIZjdTAv6CVxZA5zDOQ+cV/SVVOWyhzs/sov47vjbj2STrgzigzqh0tdObC2YouqHXndQ3QBtR2FsS7K3Z4hAGtE6fR+lOJkSaWLZY8e33B4aDPH/IbMxJMifP2n9J5UA4I/0pTdaKKJtMEjFifGmX7UrwPrV7iqaqCYU3RNwbQ5vDDNVI7qIPWQvjukGyt0pZY8JSzf4OjOyztvH+/6PVOLL49t2ITRlzB96UgKHoWRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sX+HboMKruktpSf1d53fzLJaz7GhN1bRQm5SWsppc8=;
 b=XnuJZSFo8CxaaD519x8JOre01aGPqjBXCLUm8f0qX1MGdOx/lXqAGk2ZOmZRy3Aok4AzPMoZ8zgm10R7I+r3KpC0enfDOHuIIP9RqYJDkk1PdCqAkQm0H1P3QyO1gx0BDGd/EAlAuXwT3VAh8h9rHwIell59cKMwfePMHMTv2E5ybl5K24n8Z+6Sg4VxxubhUjk4u13YDXMQ9bdTDwkEtTiGN3SBjPKXLRT/HLQek32c5u0fYoMZ9VglD46PyD11j9Sw72ftX4vP9dVEsfVYNBCnLsPoJdpOAuVN0K/koqrF2e9+pXkrK27ss4LfhqmK816iOifvevwFKYntU8wR1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sX+HboMKruktpSf1d53fzLJaz7GhN1bRQm5SWsppc8=;
 b=i8KjHEwgM5YaqF/0VgMvFvaDNfMjTcB6+PkhyuURmVw4hKjhqEsMsSkp60Ur2LPi+7E7gtRRENVb1/RhJs5o0hR4Eg1tO3YDbYFAxXLLfhWRhj4ROh7d263dKPJCcuZ97bKKEP8uV4P2nzQgrbQZmLwpK1auI3tV0M9Pis0jSqg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4578.namprd13.prod.outlook.com (2603:10b6:208:332::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.19; Tue, 1 Nov
 2022 11:03:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%7]) with mapi id 15.20.5791.017; Tue, 1 Nov 2022
 11:03:17 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose ipsec offload feature to upper layer
Date:   Tue,  1 Nov 2022 12:02:48 +0100
Message-Id: <20221101110248.423966-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221101110248.423966-1-simon.horman@corigine.com>
References: <20221101110248.423966-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0007.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4578:EE_
X-MS-Office365-Filtering-Correlation-Id: f59f8bad-d907-4b50-6fa1-08dabbf8ade0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6KtYSgXL5vK+SCB1Kg43dee6aN6Fdu0YQ8Gr2KHl+4XRfXD3RrvYXEy6rZQw132jT6RgGd640QZGaTkeHfbS7NSX+aGX419X32l+aEfVsg2qg067HykrXHVt9cv2vk8HS1xwCWLwW6c9PEbstYeQqpgsp3hD0PGjRXYtJLgdfLF0dwqCUg4fvdZRdK0rmNStZC8xiMzK5nZ2KHC6hMHJb7c429aMrskXGOrTrzgUNY12S6SdfvQgiMcshotZsM+OMGqOTexyNQ9M9y5EHpgf1msoke9Ka71eFcGfV9ZgVyiL8EB+ZFmY5sSqbwrA/Wrnuo2RotmXpzVf9dGW/b4tFvswtfp2Z5rWj5F1ghOxSR4TCZVJtExgiDnU6nVAaYcvPy4CBxiQP5cPNshmzqFcrISxAGBBjgo6t0rcDuJETqT1AxPBvddmE3NGJK1tpDpUDfc+kSAN2dlgnK5DHWf7OcIMiDb/y4PsAf9F/EZScZx0IN7BUBNcDiB5MzCqmjv3zioBkKtDlv+PYihOsFTYxz1cu6BfxhufdPtlGLyXMPbt2ZO6gHe47jy73kfjBa8B3l520JzUec659JoY1D/ufQlsJ2riq4vp7hNewTMEmh0eIEAY9z6w2jHPUUcjBQp5ORpSZolKGv6IgO4kfFih+lURCSMuXbmpTRFn7BNb45g8q1gdOlr/XUExkl57SMLMh4V8yf5AGdNPgkYD/EvAJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39830400003)(366004)(396003)(451199015)(41300700001)(2616005)(86362001)(83380400001)(38100700002)(6512007)(316002)(36756003)(5660300002)(6506007)(4326008)(8676002)(66946007)(52116002)(66556008)(66476007)(54906003)(2906002)(186003)(110136005)(6666004)(107886003)(6486002)(30864003)(44832011)(478600001)(1076003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RiQfAG9fzqXU3wQAympC18OZ7/5jdtaPi13A1XJYfO8+a8sI3/tQa85dCewj?=
 =?us-ascii?Q?PPjqkCWA52TJLwmvEkUB4Fh2zHfvLuor75FhJZwd4ZB9juCjxzkrD1UkHJP3?=
 =?us-ascii?Q?0DXgkV1qMXg3T7NR3QWg4to3Z5HhDpSR5lKirI409BgGGI/e+5M/e6UY3Gdl?=
 =?us-ascii?Q?Ms3h5lKkoBq9xDE1ldcHMb0LhCULI6CiGER9VscLfisRiodfICWTjr8fCFuZ?=
 =?us-ascii?Q?FY+bdn954BbONt5CWHqQg7dX3+I/3xUvVL+cANSGPFlD17BOIXyd8eQX2MXW?=
 =?us-ascii?Q?bflxTrEdwojD3uO7yjOGUZ+fLqoevAoFhOXGF26wCaWkwLqSVFiVAdLz31Ek?=
 =?us-ascii?Q?9PzsRlqGGpYuctCVkq8pgA4wkV8AbJoCBgsgvwtSBeMiEAqQlsJB2Ipr+KvU?=
 =?us-ascii?Q?nwjli7SzsTYPcfXDFdYsyvGPBq9g+kT1BlTRfPoxgKec+YZMIgoO8gkMEwjV?=
 =?us-ascii?Q?Pgm6Tp+xUuOsDWjZXCF8x3fdDlMjY1YILwnRxdmVPwPSEvJxoW4TrS53Ci6e?=
 =?us-ascii?Q?8Z/fTgDAMUmi1Lp/Qnwrt8cXEDJTEDU90LN6t5mybDwvUZKMS52lMyl9m/LA?=
 =?us-ascii?Q?ypmUrcD79PF+U9w/+Cd6AQ0bb9yEHENOVjYvxlPr3JTjpfI/eKetb48PI9Ms?=
 =?us-ascii?Q?eSK8wAJuxzISbTFNb9AbAw7sYY5Z67kFi11z1Nlx526nf9Thh5qsA6HVTBxX?=
 =?us-ascii?Q?+R1SUAupOG5AgYLGpe20tyYpaBWg7QIiQoPl1vx+4+8QpAQWeN2AjKr5j5bo?=
 =?us-ascii?Q?VXXCsJcezgQlUMgqUxhRJmXsD3QmO4ev3Fd75J+sLUh9dj8l5mMCB27+Lu2G?=
 =?us-ascii?Q?lZWeiJ0+6U7Xh2MzxBpBwkkcyJ9AVBsn9LWcg74UMMyoMDEZUUKz4PtrBhv4?=
 =?us-ascii?Q?XkpCJXMldIwHSTomq4h98vHgHQhl+etAvX5ta6GrTGAZjJaT9RmACR3MTiJj?=
 =?us-ascii?Q?PVFruJTPyRvoLhafBVj/EhHZiudPhYagNrB67SkXNWsClsaeHv8nWmrqJkl6?=
 =?us-ascii?Q?1GX0kJXPwogTGYOOtpbik29kvu+McU7ShHdnfRfS7BXxGeQv82MQvtVO3CWH?=
 =?us-ascii?Q?6lMx60aAYHf52vsWBYrXxlCiId6dAV9uL3odksaP7IQRgyxOmy4ELLhHeLnW?=
 =?us-ascii?Q?oVMjJZW8zfWKd6gUzCE6FC6YRh0lW+/NBh44C02nc3SjrYyHE4bFTc1h0UZc?=
 =?us-ascii?Q?ZXYGulGrGrV6zhVJAuHUAbuJkb4vQcFuU7am+NdNP0nmObltWSksaUSMoBPZ?=
 =?us-ascii?Q?x7Ql/jMadQAqcNSZ6yYCwULeKLY97/Z2QyAOsY8PByP3ghvdq6dPOBYi5ahx?=
 =?us-ascii?Q?/LiHK+ZiP10K6UxtXj/951zORUNKtmjrxxgBNmfk3lZUr3ybdaib3d1Mb3gH?=
 =?us-ascii?Q?WoPBvelsfASeNExJUlhnpkMQVp6sMJ/L5Nt9lTAr+HEwZCm54pNwIZli1OsP?=
 =?us-ascii?Q?O+P0nMOno9Z6Mq02kCYcQSZxDXuOGplhLTLODaEli09cYfu1LOflaSdB3s9/?=
 =?us-ascii?Q?gzyvsLKTE2+PfdPagWuNJMYzXfVvMmJ4uiUb2+6dB2f9/jW8EF1Bodyat8Ew?=
 =?us-ascii?Q?JtWWhLrdbHGp1w7KCjVAxdOZt0uGcO+c8iz45oLeYRbmvpvhz2OrM/tMKABF?=
 =?us-ascii?Q?MUawuqTyoqG/rwvJemwi0iCUHzsGu9E5Pu98d7ubpSChHOukPoi12AbwgwKT?=
 =?us-ascii?Q?C6rn3Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f59f8bad-d907-4b50-6fa1-08dabbf8ade0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 11:03:17.1514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lqgkyGDSKtyy1L6fhon0NUGQwqyAzJUCs18aHeHOPboYmy/VGled6OGRt0OePTG2bX/Faf/3EClJ1WPR+Cr7xfuIK6b3RRYMrReM+1JfsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4578
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

Xfrm callbacks are implemented to offload SA info into firmware
by mailbox. It supports 16K SA info in total.

Expose ipsec offload feature to upper layer, this feature will
signal the availability of the offload.

Based on initial work of Norm Bagley <norman.bagley@netronome.com>.

Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 532 +++++++++++++++++-
 .../ethernet/netronome/nfp/nfp_net_common.c   |   6 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +-
 3 files changed, 538 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index 11575a9cb3b0..664a36be60e7 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -16,18 +16,546 @@
 
 #define NFP_NET_IPSEC_MAX_SA_CNT  (16 * 1024) /* Firmware support a maximum of 16K SA offload */
 
+/* IPsec config message cmd codes */
+enum nfp_ipsec_cfg_mssg_cmd_codes {
+	NFP_IPSEC_CFG_MSSG_ADD_SA,	 /* Add a new SA */
+	NFP_IPSEC_CFG_MSSG_INV_SA,	 /* Invalidate an existing SA */
+	NFP_IPSEC_CFG_MSSG_MODIFY_SA,	 /* Modify an existing SA */
+	NFP_IPSEC_CFG_MSSG_GET_SA_STATS, /* Report SA counters, flags, etc. */
+	NFP_IPSEC_CFG_MSSG_GET_SEQ_NUMS, /* Allocate sequence numbers */
+	NFP_IPSEC_CFG_MSSG_LAST
+};
+
+/* IPsec config message response codes */
+enum nfp_ipsec_cfg_mssg_rsp_codes {
+	NFP_IPSEC_CFG_MSSG_OK,
+	NFP_IPSEC_CFG_MSSG_FAILED,
+	NFP_IPSEC_CFG_MSSG_SA_VALID,
+	NFP_IPSEC_CFG_MSSG_SA_HASH_ADD_FAILED,
+	NFP_IPSEC_CFG_MSSG_SA_HASH_DEL_FAILED,
+	NFP_IPSEC_CFG_MSSG_SA_INVALID_CMD
+};
+
+/* Protocol */
+enum nfp_ipsec_sa_prot {
+	NFP_IPSEC_PROTOCOL_AH = 0,
+	NFP_IPSEC_PROTOCOL_ESP = 1
+};
+
+/* Mode */
+enum nfp_ipsec_sa_mode {
+	NFP_IPSEC_PROTMODE_TRANSPORT = 0,
+	NFP_IPSEC_PROTMODE_TUNNEL = 1
+};
+
+/* Cipher types */
+enum nfp_ipsec_sa_cipher {
+	NFP_IPSEC_CIPHER_NULL,
+	NFP_IPSEC_CIPHER_3DES,
+	NFP_IPSEC_CIPHER_AES128,
+	NFP_IPSEC_CIPHER_AES192,
+	NFP_IPSEC_CIPHER_AES256,
+	NFP_IPSEC_CIPHER_AES128_NULL,
+	NFP_IPSEC_CIPHER_AES192_NULL,
+	NFP_IPSEC_CIPHER_AES256_NULL,
+	NFP_IPSEC_CIPHER_CHACHA20
+};
+
+/* Cipher modes */
+enum nfp_ipsec_sa_cipher_mode {
+	NFP_IPSEC_CIMODE_ECB,
+	NFP_IPSEC_CIMODE_CBC,
+	NFP_IPSEC_CIMODE_CFB,
+	NFP_IPSEC_CIMODE_OFB,
+	NFP_IPSEC_CIMODE_CTR
+};
+
+/* Hash types */
+enum nfp_ipsec_sa_hash_type {
+	NFP_IPSEC_HASH_NONE,
+	NFP_IPSEC_HASH_MD5_96,
+	NFP_IPSEC_HASH_SHA1_96,
+	NFP_IPSEC_HASH_SHA256_96,
+	NFP_IPSEC_HASH_SHA384_96,
+	NFP_IPSEC_HASH_SHA512_96,
+	NFP_IPSEC_HASH_MD5_128,
+	NFP_IPSEC_HASH_SHA1_80,
+	NFP_IPSEC_HASH_SHA256_128,
+	NFP_IPSEC_HASH_SHA384_192,
+	NFP_IPSEC_HASH_SHA512_256,
+	NFP_IPSEC_HASH_GF128_128,
+	NFP_IPSEC_HASH_POLY1305_128
+};
+
+/* IPSEC_CFG_MSSG_ADD_SA */
+struct nfp_ipsec_cfg_add_sa {
+	u32 ciph_key[8];		  /* Cipher Key */
+	union {
+		u32 auth_key[16];	  /* Authentication Key */
+		struct nfp_ipsec_aesgcm { /* AES-GCM-ESP fields */
+			u32 salt;	  /* Initialized with SA */
+			u32 iv[2];	  /* Firmware use only */
+			u32 cntr;
+			u32 zeros[4];	  /* Init to 0 with SA */
+			u32 len_a[2];	  /* Firmware use only */
+			u32 len_c[2];
+			u32 spare0[4];
+		} aesgcm_fields;
+	};
+	struct sa_ctrl_word {
+		uint32_t hash   :4;	  /* From nfp_ipsec_sa_hash_type */
+		uint32_t cimode :4;	  /* From nfp_ipsec_sa_cipher_mode */
+		uint32_t cipher :4;	  /* From nfp_ipsec_sa_cipher */
+		uint32_t mode   :2;	  /* From nfp_ipsec_sa_mode */
+		uint32_t proto  :2;	  /* From nfp_ipsec_sa_prot */
+		uint32_t dir :1;	  /* SA direction */
+		uint32_t ena_arw:1;	  /* Anti-Replay Window */
+		uint32_t ext_seq:1;	  /* 64-bit Sequence Num */
+		uint32_t ext_arw:1;	  /* 64b Anti-Replay Window */
+		uint32_t spare2 :9;	  /* Must be set to 0 */
+		uint32_t encap_dsbl:1;	  /* Encap/Decap disable */
+		uint32_t gen_seq:1;	  /* Firmware Generate Seq */
+		uint32_t spare8 :1;	  /* Must be set to 0 */
+	} ctrl_word;
+	u32 spi;			  /* SPI Value */
+	uint32_t pmtu_limit :16;	  /* PMTU Limit */
+	uint32_t spare3     :1;
+	uint32_t frag_check :1;		  /* Stateful fragment checking flag */
+	uint32_t bypass_DSCP:1;		  /* Bypass DSCP Flag */
+	uint32_t df_ctrl    :2;		  /* DF Control bits */
+	uint32_t ipv6       :1;		  /* Outbound IPv6 addr format */
+	uint32_t udp_enable :1;		  /* Add/Remove UDP header for NAT */
+	uint32_t tfc_enable :1;		  /* Traffic Flow Confidentiality */
+	uint32_t spare4	 :8;
+	u32 soft_lifetime_byte_count;
+	u32 hard_lifetime_byte_count;
+	u32 src_ip[4];			  /* Src IP addr */
+	u32 dst_ip[4];			  /* Dst IP addr */
+	uint32_t natt_dst_port :16;	  /* NAT-T UDP Header dst port */
+	uint32_t natt_src_port :16;	  /* NAT-T UDP Header src port */
+	u32 soft_lifetime_time_limit;
+	u32 hard_lifetime_time_limit;
+	u32 sa_creation_time_lo_32;	  /* Ucode fills this in */
+	u32 sa_creation_time_hi_32;	  /* Ucode fills this in */
+	uint32_t reserved0   :16;
+	uint32_t tfc_padding :16;	  /* Traffic Flow Confidential Pad */
+};
+
+/* IPSEC_CFG_MSSG_INV_SA */
+struct nfp_ipsec_cfg_inv_sa {
+	u32 spare6;
+};
+
+/* IPSEC_CFG_MSSG_GET_SA_STATS */
+struct nfp_ipsec_cfg_get_sa_stats {
+	u32 seq_lo;					/* Sequence Number (low 32bits) */
+	u32 seq_high;					/* Sequence Number (high 32bits) */
+	u32 arw_counter_lo;				/* Anti-replay wndw cntr */
+	u32 arw_counter_high;				/* Anti-replay wndw cntr */
+	u32 arw_bitmap_lo;				/* Anti-replay wndw bitmap */
+	u32 arw_bitmap_high;				/* Anti-replay wndw bitmap */
+	uint32_t reserved1:1;
+	uint32_t soft_lifetime_byte_cnt_exceeded :1;	/* Soft cnt_exceeded */
+	uint32_t hard_lifetime_byte_cnt_exceeded :1;	/* Hard cnt_exceeded */
+	uint32_t soft_lifetime_time_limit_exceeded :1;	/* Soft cnt_exceeded */
+	uint32_t hard_lifetime_time_limit_exceeded :1;	/* Hard cnt_exceeded */
+	uint32_t spare7:27;
+	u32 lifetime_byte_count;
+	u32 pkt_count;
+	u32 discards_auth;				/* Auth failures */
+	u32 discards_unsupported;			/* Unsupported crypto mode */
+	u32 discards_alignment;				/* Alignment error */
+	u32 discards_hard_bytelimit;			/* Byte Count limit */
+	u32 discards_seq_num_wrap;			/* Sequ Number wrap */
+	u32 discards_pmtu_limit_exceeded;		/* PMTU Limit */
+	u32 discards_arw_old_seq;			/* Anti-Replay seq small */
+	u32 discards_arw_replay;			/* Anti-Replay seq rcvd */
+	u32 discards_ctrl_word;				/* Bad SA Control word */
+	u32 discards_ip_hdr_len;			/* Hdr offset from too high */
+	u32 discards_eop_buf;				/* No EOP buffer */
+	u32 ipv4_id_counter;				/* IPv4 ID field counter */
+	u32 discards_isl_fail;				/* Inbound SPD Lookup failure */
+	u32 discards_ext_not_found;			/* Ext header end */
+	u32 discards_max_ext_hdrs;			/* Max ext header */
+	u32 discards_non_ext_hdrs;			/* Non-extension headers */
+	u32 discards_ext_hdr_too_big;			/* Ext header chain */
+	u32 discards_hard_timelimit;			/* Time Limit */
+};
+
+/* IPSEC_CFG_MSSG_GET_SEQ_NUMS */
+struct ipsec_cfg_get_seq_nums {
+	u32 seq_nums;	 /* Sequence numbers to allocate */
+	u32 seq_num_low; /* Rtrn start seq num 31:00 */
+	u32 seq_num_hi;	 /* Rtrn start seq num 63:32 */
+};
+
+/* IPSEC_CFG_MSSG */
+struct nfp_ipsec_cfg_mssg {
+	union {
+		struct{
+			uint32_t cmd:16;     /* One of nfp_ipsec_cfg_mssg_cmd_codes */
+			uint32_t rsp:16;     /* One of nfp_ipsec_cfg_mssg_rsp_codes */
+			uint32_t sa_idx:16;  /* SA table index */
+			uint32_t spare0:16;
+			union {
+				struct nfp_ipsec_cfg_add_sa cfg_add_sa;
+				struct nfp_ipsec_cfg_inv_sa cfg_inv_sa;
+				struct nfp_ipsec_cfg_get_sa_stats cfg_get_stats;
+				struct ipsec_cfg_get_seq_nums cfg_get_seq_nums;
+			};
+		};
+		u32 raw[64];
+	};
+};
+
+static int nfp_ipsec_cfg_cmd_issue(struct nfp_net *nn, int type, int saidx,
+				   struct nfp_ipsec_cfg_mssg *msg)
+{
+	int i, msg_size, ret;
+
+	msg->cmd = type;
+	msg->sa_idx = saidx;
+	msg->rsp = 0;
+	msg_size = ARRAY_SIZE(msg->raw);
+
+	for (i = 0; i < msg_size; i++)
+		nn_writel(nn, NFP_NET_CFG_MBOX_VAL + 4 * i, msg->raw[i]);
+
+	ret = nfp_net_mbox_reconfig(nn, NFP_NET_CFG_MBOX_CMD_IPSEC);
+	if (ret < 0)
+		return ret;
+
+	/* For now we always read the whole message response back */
+	for (i = 0; i < msg_size; i++)
+		msg->raw[i] = nn_readl(nn, NFP_NET_CFG_MBOX_VAL + 4 * i);
+
+	switch (msg->rsp) {
+	case NFP_IPSEC_CFG_MSSG_OK:
+		return 0;
+	case NFP_IPSEC_CFG_MSSG_SA_INVALID_CMD:
+		return -EINVAL;
+	case NFP_IPSEC_CFG_MSSG_SA_VALID:
+		return -EEXIST;
+	case NFP_IPSEC_CFG_MSSG_FAILED:
+	case NFP_IPSEC_CFG_MSSG_SA_HASH_ADD_FAILED:
+	case NFP_IPSEC_CFG_MSSG_SA_HASH_DEL_FAILED:
+		return -EIO;
+	default:
+		return -EDOM;
+	}
+}
+
+static int set_aes_keylen(struct nfp_ipsec_cfg_add_sa *cfg, int alg, int keylen)
+{
+	if (alg == SADB_X_EALG_NULL_AES_GMAC) {
+		if (keylen == 128)
+			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES128_NULL;
+		else if (keylen == 192)
+			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES192_NULL;
+		else if (keylen == 256)
+			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES256_NULL;
+		else
+			return -EINVAL;
+	} else {
+		if (keylen == 128)
+			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES128;
+		else if (keylen == 192)
+			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES192;
+		else if (keylen == 256)
+			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES256;
+		else
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int nfp_net_xfrm_add_state(struct xfrm_state *x)
 {
-	return -EOPNOTSUPP;
+	struct net_device *netdev = x->xso.dev;
+	struct nfp_ipsec_cfg_mssg msg = {0};
+	int i, key_len, trunc_len, err = 0;
+	struct nfp_ipsec_cfg_add_sa *cfg;
+	struct nfp_net *nn;
+	unsigned int saidx;
+	__be32 *p;
+
+	nn = netdev_priv(netdev);
+	cfg = &msg.cfg_add_sa;
+
+	/* General */
+	switch (x->props.mode) {
+	case XFRM_MODE_TUNNEL:
+		cfg->ctrl_word.mode = NFP_IPSEC_PROTMODE_TUNNEL;
+		break;
+	case XFRM_MODE_TRANSPORT:
+		cfg->ctrl_word.mode = NFP_IPSEC_PROTMODE_TRANSPORT;
+		break;
+	default:
+		nn_err(nn, "Unsupported mode for xfrm offload\n");
+		return -EINVAL;
+	}
+
+	switch (x->id.proto) {
+	case IPPROTO_ESP:
+		cfg->ctrl_word.proto = NFP_IPSEC_PROTOCOL_ESP;
+		break;
+	case IPPROTO_AH:
+		cfg->ctrl_word.proto = NFP_IPSEC_PROTOCOL_AH;
+		break;
+	default:
+		nn_err(nn, "Unsupported protocol for xfrm offload\n");
+		return -EINVAL;
+	}
+
+	if (x->props.flags & XFRM_STATE_ESN) {
+		nn_err(nn, "Unsupported XFRM_REPLAY_MODE_ESN for xfrm offload\n");
+		return -EINVAL;
+	}
+
+	cfg->ctrl_word.ena_arw = 0;
+	cfg->ctrl_word.ext_arw = 0;
+	cfg->spi = ntohl(x->id.spi);
+
+	/* Hash/Authentication */
+	if (x->aalg)
+		trunc_len = x->aalg->alg_trunc_len;
+	else
+		trunc_len = 0;
+
+	switch (x->props.aalgo) {
+	case SADB_AALG_NONE:
+		if (x->aead) {
+			trunc_len = -1;
+		} else {
+			nn_err(nn, "Unsupported authentication algorithm\n");
+			return -EINVAL;
+		}
+		break;
+	case SADB_X_AALG_NULL:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_NONE;
+		trunc_len = -1;
+		break;
+	case SADB_AALG_MD5HMAC:
+		if (trunc_len == 96)
+			cfg->ctrl_word.hash = NFP_IPSEC_HASH_MD5_96;
+		else if (trunc_len == 128)
+			cfg->ctrl_word.hash = NFP_IPSEC_HASH_MD5_128;
+		else
+			trunc_len = 0;
+		break;
+	case SADB_AALG_SHA1HMAC:
+		if (trunc_len == 96)
+			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA1_96;
+		else if (trunc_len == 80)
+			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA1_80;
+		else
+			trunc_len = 0;
+		break;
+	case SADB_X_AALG_SHA2_256HMAC:
+		if (trunc_len == 96)
+			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA256_96;
+		else if (trunc_len == 128)
+			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA256_128;
+		else
+			trunc_len = 0;
+		break;
+	case SADB_X_AALG_SHA2_384HMAC:
+		if (trunc_len == 96)
+			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA384_96;
+		else if (trunc_len == 192)
+			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA384_192;
+		else
+			trunc_len = 0;
+		break;
+	case SADB_X_AALG_SHA2_512HMAC:
+		if (trunc_len == 96)
+			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA512_96;
+		else if (trunc_len == 256)
+			cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA512_256;
+		else
+			trunc_len = 0;
+		break;
+	default:
+		nn_err(nn, "Unsupported authentication algorithm\n");
+		return -EINVAL;
+	}
+
+	if (!trunc_len) {
+		nn_err(nn, "Unsupported authentication algorithm trunc length\n");
+		return -EINVAL;
+	}
+
+	if (x->aalg) {
+		p = (__be32 *)x->aalg->alg_key;
+		key_len = DIV_ROUND_UP(x->aalg->alg_key_len, BITS_PER_BYTE);
+		if (key_len > sizeof(cfg->auth_key)) {
+			nn_err(nn, "Insufficient space for offloaded auth key\n");
+			return -EINVAL;
+		}
+		for (i = 0; i < key_len / sizeof(cfg->auth_key[0]) ; i++)
+			cfg->auth_key[i] = ntohl(*p++);
+	}
+	/* Encryption */
+	switch (x->props.ealgo) {
+	case SADB_EALG_NONE:
+	case SADB_EALG_NULL:
+		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CBC;
+		cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_NULL;
+		break;
+	case SADB_EALG_3DESCBC:
+		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CBC;
+		cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_3DES;
+		break;
+	case SADB_X_EALG_AES_GCM_ICV16:
+	case SADB_X_EALG_NULL_AES_GMAC:
+		if (!x->aead) {
+			nn_err(nn, "Invalid AES key data\n");
+			return -EINVAL;
+		}
+
+		if (x->aead->alg_icv_len != 128) {
+			nn_err(nn, "ICV must be 128bit with SADB_X_EALG_AES_GCM_ICV16\n");
+			return -EINVAL;
+		}
+		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CTR;
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_GF128_128;
+
+		/* Aead->alg_key_len includes 32-bit salt */
+		if (set_aes_keylen(cfg, x->props.ealgo, x->aead->alg_key_len - 32)) {
+			nn_err(nn, "Unsupported AES key length %d\n", x->aead->alg_key_len);
+			return -EINVAL;
+		}
+		break;
+	case SADB_X_EALG_AESCBC:
+		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CBC;
+		if (!x->ealg) {
+			nn_err(nn, "Invalid AES key data\n");
+			return -EINVAL;
+		}
+		if (set_aes_keylen(cfg, x->props.ealgo, x->ealg->alg_key_len) < 0) {
+			nn_err(nn, "Unsupported AES key length %d\n", x->ealg->alg_key_len);
+			return -EINVAL;
+		}
+		break;
+	default:
+		nn_err(nn, "Unsupported encryption algorithm for offload\n");
+		return -EINVAL;
+	}
+
+	if (x->aead) {
+		int salt_len = 4;
+
+		p = (__be32 *)x->aead->alg_key;
+		key_len = DIV_ROUND_UP(x->aead->alg_key_len, BITS_PER_BYTE);
+		key_len -= salt_len;
+
+		if (key_len > sizeof(cfg->ciph_key)) {
+			nn_err(nn, "aead: Insufficient space for offloaded key\n");
+			return -EINVAL;
+		}
+
+		for (i = 0; i < key_len / sizeof(cfg->ciph_key[0]) ; i++)
+			cfg->ciph_key[i] = ntohl(*p++);
+
+		/* Load up the salt */
+		for (i = 0; i < salt_len; i++)
+			cfg->auth_key[i] = ntohl(*p++);
+	}
+
+	if (x->ealg) {
+		p = (__be32 *)x->ealg->alg_key;
+		key_len = DIV_ROUND_UP(x->ealg->alg_key_len, BITS_PER_BYTE);
+
+		if (key_len > sizeof(cfg->ciph_key)) {
+			nn_err(nn, "ealg: Insufficient space for offloaded key\n");
+			return -EINVAL;
+		}
+		for (i = 0; i < key_len / sizeof(cfg->ciph_key[0]) ; i++)
+			cfg->ciph_key[i] = ntohl(*p++);
+	}
+	/* IP related info */
+	switch (x->props.family) {
+	case AF_INET:
+		cfg->ipv6 = 0;
+		cfg->src_ip[0] = ntohl(x->props.saddr.a4);
+		cfg->dst_ip[0] = ntohl(x->id.daddr.a4);
+		break;
+	case AF_INET6:
+		cfg->ipv6 = 1;
+		for (i = 0; i < 4; i++) {
+			cfg->src_ip[i] = ntohl(x->props.saddr.a6[i]);
+			cfg->dst_ip[i] = ntohl(x->id.daddr.a6[i]);
+		}
+		break;
+	default:
+		nn_err(nn, "Unsupported address family\n");
+		return -EINVAL;
+	}
+
+	/* Maximum nic IPsec code could handle. Other limits may apply. */
+	cfg->pmtu_limit = 0xffff;
+
+	/* Host will generate the sequence numbers so that if packets get
+	 * fragmented in host, sequence numbers will stay in sync.
+	 */
+	cfg->ctrl_word.gen_seq = 0;
+
+	cfg->ctrl_word.encap_dsbl = 1;
+
+	/* SA direction */
+	cfg->ctrl_word.dir = x->xso.dir;
+
+	/* Find unused SA data*/
+	err = xa_alloc(&nn->xa_ipsec, &saidx, x,
+		       XA_LIMIT(0, NFP_NET_IPSEC_MAX_SA_CNT - 1), GFP_KERNEL);
+	if (err < 0) {
+		nn_err(nn, "Unable to get sa_data number for IPsec\n");
+		return err;
+	}
+
+	/* Allocate saidx and commit the SA */
+	err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_ADD_SA, saidx, &msg);
+	if (err) {
+		xa_erase(&nn->xa_ipsec, saidx);
+		nn_err(nn, "Failed to issue IPsec command err ret=%d\n", err);
+		return err;
+	}
+
+	/* 0 is invalid offload_handle for kernel */
+	x->xso.offload_handle = saidx + 1;
+	return 0;
 }
 
 static void nfp_net_xfrm_del_state(struct xfrm_state *x)
 {
+	struct net_device *netdev = x->xso.dev;
+	struct nfp_ipsec_cfg_mssg msg;
+	struct nfp_net *nn;
+	int err;
+
+	nn = netdev_priv(netdev);
+	err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_INV_SA,
+				      x->xso.offload_handle - 1, &msg);
+	if (err)
+		nn_warn(nn, "Failed to invalidate SA in hardware\n");
+
+	xa_erase(&nn->xa_ipsec, x->xso.offload_handle - 1);
 }
 
 static bool nfp_net_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 {
-	return false;
+	if (x->props.family == AF_INET) {
+		/* Offload with IPv4 options is not supported yet */
+		if (ip_hdr(skb)->ihl != 5)
+			return false;
+	} else {
+		/* Offload with IPv6 extension headers is not support yet */
+		if (ipv6_ext_hdr(ipv6_hdr(skb)->nexthdr))
+			return false;
+	}
+
+	return true;
 }
 
 static const struct xfrmdev_ops nfp_net_ipsec_xfrmdev_ops = {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 8e9b34b133f4..e83f58590248 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2373,6 +2373,12 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_RSS_ANY)
 		netdev->hw_features |= NETIF_F_RXHASH;
+
+#ifdef CONFIG_NFP_NET_IPSEC
+	if (nn->cap_w1 & NFP_NET_CFG_CTRL_IPSEC)
+		netdev->hw_features |= NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM;
+#endif
+
 	if (nn->cap & NFP_NET_CFG_CTRL_VXLAN) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO) {
 			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 8f75efd9e463..cc11b3dc1252 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -402,14 +402,14 @@
  */
 #define NFP_NET_CFG_MBOX_BASE		0x1800
 #define NFP_NET_CFG_MBOX_VAL_MAX_SZ	0x1F8
-
+#define NFP_NET_CFG_MBOX_VAL		0x1808
 #define NFP_NET_CFG_MBOX_SIMPLE_CMD	0x0
 #define NFP_NET_CFG_MBOX_SIMPLE_RET	0x4
 #define NFP_NET_CFG_MBOX_SIMPLE_VAL	0x8
 
 #define NFP_NET_CFG_MBOX_CMD_CTAG_FILTER_ADD 1
 #define NFP_NET_CFG_MBOX_CMD_CTAG_FILTER_KILL 2
-
+#define NFP_NET_CFG_MBOX_CMD_IPSEC 3
 #define NFP_NET_CFG_MBOX_CMD_PCI_DSCP_PRIOMAP_SET	5
 #define NFP_NET_CFG_MBOX_CMD_TLV_CMSG			6
 
-- 
2.30.2

