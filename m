Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410C05B00DE
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiIGJsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIGJsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:48:37 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2121.outbound.protection.outlook.com [40.107.100.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2609C233
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 02:48:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDjq2Cnyk9Aqthlyj38dMFPTcb/+AnLuQb9RDutETlEbz/fTQP+8dkB6CqiNQIYmKJ4noVrY2OacpmEPYQRGxdRASZ3I0pssr5xZL1xr06JTIw7wfNxz+hDpX8i1nrjfZjLEHNCh4ivT+DZIyHFPZZjafiJ1TppOhu5bWmQucZbSiInPD8ItnuOAgvzkiYjvRsDXpXyMhs4NmTQVCwDG5ML6ZUVu8qm/79ojWsjYUgAZqpjhFm+EWuRH9EjyoaR/Bew8mt888k25sWCuiCFcXTjazNhE9NbbRPZdwCugfkGm7GXvCs91cy2bJaB2W5z6d0KWkQcFGS7sFf9kHVP1ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/8yfokQnqMmHWdYrraPyDVZSOqFEDZfupmO8mXxDhI=;
 b=FcfRR/51V+xgI4Lh/fHxVf7V5uThKfGR0FOUtbP0uZfh4TSTssvA739Z4MmCPbfjU8WpiXP3DNPNXp+CZ14cBbgA8t3XIzb/lmYLEgy7fWiDE2tyaYVB3N8+DnOVZveZXX9n8U7zLGPBS/1gJr/cQwqFVr+HW7+GKJholQBBINiIUrHe8Jfkvlgvi0cVYnGpoGiAxtJjOaCYlAn8XUUqfiLYLwEJl8Jc2/HDiLTT4zgVDMmlqIe3YURQpYxW1uCv2XQ9i/1WdHT52vjQRUMeZSfBOVsWl1NZiebCGgeXXjmFci/VkYg7NR/kVTos31L+qA83ZcBiLdhPqh0meDHbXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/8yfokQnqMmHWdYrraPyDVZSOqFEDZfupmO8mXxDhI=;
 b=ieqPppOcBjwubAJAsfBtezwlP2u1lHseAjsPFs3ReEgb/qjeVqBBAXN5oRmxqyhs5gmM1bsJko5BRx4WScxywgGEzIDrmpzK0OI2hRFgDeebdUGdf6LQBPKrA9h/UoSoEOg9P8vwL4srBeO7fRFqXEsYB8M0a8jS/tctfs4dg44=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5617.namprd13.prod.outlook.com (2603:10b6:510:138::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.9; Wed, 7 Sep
 2022 09:48:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 09:48:27 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 3/3] nfp: implement xfrm callbacks and expose ipsec offload feature to upper layer
Date:   Wed,  7 Sep 2022 11:47:58 +0200
Message-Id: <20220907094758.35571-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220907094758.35571-1-simon.horman@corigine.com>
References: <20220907094758.35571-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0093.eurprd04.prod.outlook.com
 (2603:10a6:208:be::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5617:EE_
X-MS-Office365-Filtering-Correlation-Id: e4cf4168-989c-4a0f-a87e-08da90b61d37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dxNZ8e8vrrXsFkF3xthyyodGFhfAFTl3tgtKjTy2lxHXr3UtOV8QlGxWw7WjtbvjCyOqZGYsxbp0BXP2v3s+RYfH3SI+DkUMDAXTGm+dtbMAcV82mEVEtiu1wRycF9VwiSupdtX/YO1dSQ1ccdlav2VrCvuMu+AP89NAuUEpy01H/itEu7X7sxNMUyWZGgabPcfb53uXtpyWA/xr84kTetexcCzMyRIyiroPB0HxNFTIlGH3bq1eM2DO6dNteaFVDtCxD/RH1kc3jMiCoGqSAapWu8KKPEKcUN+mFAuI6HlcTQMdQn3gaRcofKccdKKsjXc8yCeiVZdgzoZjeGOPqANhOnfp/Xy4zUVdVt0c0d+nYOtGqvDmeqR5Ou4ozgCKlt/jxvfdhOb+trpCIL1U3Ap0ZKI7QS0S5f7wIcmwG6K6UUhVnHhV41ZhFT4E5Zoj/TLt3fj9sBxG88h4cDqkrHvn78OZbdaRLmgUZVrfUmJ+BHCjwdHZ0mLmyIrcnf5HzGFoMHWQG0soNvYNJu1r9chqwC5s98yILvUCqMDmaj6UtVX0yEDHZYFLzVr78LB3U3D20RKbXuKTYDaJjeba3fgWl+Q8HLLJ6ILPIgHeLvnVAej11v556a3ke4MG8P9dfIKK/Otynt9ECdh62A/M6pbSBSaKUIXaZTM9ZNsshwILqtEPejAjKz6QxGWRzHIXhxiiQkSu77+kj2A6Q34fBKXq6wWPw62T2MxBXqiWe2es7RG4YRw159OEfSvaJmXB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(376002)(346002)(136003)(366004)(396003)(186003)(66476007)(38100700002)(478600001)(52116002)(6512007)(6666004)(6506007)(83380400001)(107886003)(1076003)(2616005)(6486002)(41300700001)(5660300002)(86362001)(8936002)(8676002)(30864003)(44832011)(66556008)(66946007)(2906002)(36756003)(4326008)(316002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yld3/Pcedfzi7TsFXXlov83GbRr5qqGQIIlLC2rNnyyrZwaF3Im6adkQ5vi+?=
 =?us-ascii?Q?oBSsij2eywEURGilOb7oXorG72qsN/q6QseGGDfTScpRm0kT4O8eCrU8mmgC?=
 =?us-ascii?Q?NpMlGU1xToMm0keiTVXu5tYV/zlKhrsTPK7x23TEr/wST46j42Ln54my4XPk?=
 =?us-ascii?Q?W7hPe7wP95YQbk/ipEymstLD+3yf2kTHq8qVF25xqe4NTWfHenFWH28z/C6s?=
 =?us-ascii?Q?HXCXXZuNbqJ7lbRLQ3QMY2z6o7IqHXFS/+DuC+CyESTcUUMrr2zdQOK0DgGu?=
 =?us-ascii?Q?oIOKrN4vffakJa9DMJg+Y2ScykMAkIlhT9Orp8N8tdN4spwxzSicsi9JS14w?=
 =?us-ascii?Q?OvXMejtXxj3FVVoa8vdHUdDEbxcSnJ1Tny6wj1XNezeTAGrRRgKuL4fs9N/0?=
 =?us-ascii?Q?aNy+AZRy1R4n+qDn9/O/2Kx1E8DjhKElkPJ5VJiT9Oz205PxP04da+GEg6Qn?=
 =?us-ascii?Q?+6cxGyY73DzjMwPj1zV2Aq+cO4+KCZCrD6wA76Svrj6s7acs3J2zZ9SsOZ/4?=
 =?us-ascii?Q?VCmSPlvMWaRSoXyUbvlxxfr+TOP8noU9r34S/ZxU+OGvTQcuRAl6N2rEAQwC?=
 =?us-ascii?Q?Aa50TNeZYYMouvbeXeq6n1yXhK8HuB79GdUdBinQYsXjx8g3GmQAuh8Mr1Uf?=
 =?us-ascii?Q?PXQ9Wo4ldTEvWUKPK6cSSFl07zC9ddF+wFQzxqQSD8aJOKyCggkwej77//79?=
 =?us-ascii?Q?QyM73KIJeUyTZpAq0TqUbyPmMpnN+VsXiNjaqWw4A7g/N48GLo6ioFCAq0yA?=
 =?us-ascii?Q?sUdVo7c16NSlwb9cy0B9hy/EUnTIaMdjUaD5uAW6pRMudUaO/fMprZzVEDRr?=
 =?us-ascii?Q?x7ROOXQ3F0Iqp8AxU+97tlULJQBYHdZ5wU7hRgk61Q5IrJG10+1qYwSyxxPs?=
 =?us-ascii?Q?RmTtlAalbklh6oPV4OgPdSGSVFpvEJMNPr7WaSMo4E6Wc+aNJZQKOH0WR/E9?=
 =?us-ascii?Q?f1b7fiGeDfmRaNGR6XvXt1ktBojtrU4GZ4xpmOoJ7lfah50uw3FPQumkOJnr?=
 =?us-ascii?Q?jyKcGuyR6K45kHjMIddVQh5BxLSMR4eviT5uPAATTubzKVdDEmyoOuNA0DMW?=
 =?us-ascii?Q?VzNwIk/atSkNDl3ZQjSLexD0yKXzWX4ZpZxkGOvcP8IoYPCGeVIZFVXkE4Td?=
 =?us-ascii?Q?KWtXs0VFgGbAFUvhPJefWjzPuj8vu6COYm4C+e9Lt5XHdr8wJUs49TPNVJ4C?=
 =?us-ascii?Q?lsJ/zLqncj00d2YohHQX0A54+VKLb1PQYwMC3pPzRWfPHgKmFc7ibFpFBzWG?=
 =?us-ascii?Q?pjxr+9+pLOqehLdgZsm9g2V9XiAsi7au25X7G3OAT6XGitKWhTZGplu+58KW?=
 =?us-ascii?Q?LGwecJBdOh09CyER4My4wvxmqp4l3eBBRnVvOguStjY/dSFMCS9A8XZ79Zl8?=
 =?us-ascii?Q?IwifiH9BI9dT1Ds6Rk/l0QM+SS+cr+rLR7N2Qu1ECYcpckbZGWtEgDKpWX1l?=
 =?us-ascii?Q?d6Eseduj6dJER2TMj3w98JTLLFY3gQ2FOhD0xjCs9DXVmAP/vN1GDvehewi7?=
 =?us-ascii?Q?C5wI0iYTocrM/rRYx71UH0e4cUCEZJj+FrNYqFNd2ToU09LSmMhPmFQ4yze5?=
 =?us-ascii?Q?dm3r6KW41P1FjTk1miMjk9FadCa/ZVhpLn29LyhNMsjN91NCnd7JQPOqV4MK?=
 =?us-ascii?Q?WWgNPbKXCnQhRwQmiSMZdfRMlbIHVNQyBzJuRKms8g82NjnTiR1vA88bAWvk?=
 =?us-ascii?Q?QPUFUQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5617
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 552 +++++++++++++++++-
 .../ethernet/netronome/nfp/nfp_net_common.c   |   6 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +-
 3 files changed, 558 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index 658fcba8e733..4c2e1247e487 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -17,6 +17,77 @@
 #define NFP_NET_IPSEC_MAX_SA_CNT  (16 * 1024) /* Firmware support a maximum of 16K sa offload */
 #define OFFLOAD_HANDLE_ERROR      0xffffffff
 
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
 /* IPSEC_CFG_MSSG_ADD_SA */
 struct nfp_ipsec_cfg_add_sa {
 	u32 ciph_key[8];		  /* Cipher Key */
@@ -71,6 +142,73 @@ struct nfp_ipsec_cfg_add_sa {
 	uint32_t tfc_padding :16;	  /* Traffic Flow Confidential Pad */
 };
 
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
 struct nfp_net_ipsec_sa_data {
 	struct nfp_ipsec_cfg_add_sa nfp_sa;
 	struct xfrm_state *x;
@@ -84,22 +222,432 @@ struct nfp_net_ipsec_data {
 	struct mutex lock;	/* Protects nfp_net_ipsec_data struct */
 };
 
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
+	int i, key_len, trunc_len, err = 0, saidx = -1;
+	struct net_device *netdev = x->xso.dev;
+	struct nfp_net_ipsec_sa_data *sa_data;
+	struct nfp_ipsec_cfg_add_sa *cfg;
+	struct nfp_net_ipsec_data *ipd;
+	struct nfp_ipsec_cfg_mssg msg;
+	struct nfp_net *nn;
+	__be32 *p;
+
+	nn = netdev_priv(netdev);
+	ipd = nn->ipsec_data;
+	cfg = &msg.cfg_add_sa;
+
+	nn_dbg(nn, "XFRM add state!\n");
+	mutex_lock(&ipd->lock);
+
+	if (ipd->sa_free_cnt == 0) {
+		nn_err(nn, "No space for xfrm offload\n");
+		err = -ENOSPC;
+		goto error;
+	}
+
+	saidx = ipd->sa_free_stack[ipd->sa_free_cnt - 1];
+	sa_data = &ipd->sa_entries[saidx];
+	memset(&msg, 0, sizeof(msg));
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
+		err = -EOPNOTSUPP;
+		goto error;
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
+		err = -EOPNOTSUPP;
+		goto error;
+	}
+
+	if (x->props.flags & XFRM_STATE_ESN)
+		cfg->ctrl_word.ext_seq = 1;
+	else
+		cfg->ctrl_word.ext_seq = 0;
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
+		err = -EOPNOTSUPP;
+		goto error;
+	}
+
+	if (!trunc_len) {
+		nn_err(nn, "Unsupported authentication algorithm trunc length\n");
+		err = -EOPNOTSUPP;
+		goto error;
+	}
+
+	if (x->aalg) {
+		p = (__be32 *)x->aalg->alg_key;
+		key_len = DIV_ROUND_UP(x->aalg->alg_key_len, BITS_PER_BYTE);
+		if (key_len > sizeof(cfg->auth_key)) {
+			nn_err(nn, "Insufficient space for offloaded auth key\n");
+			err = -EINVAL;
+			goto error;
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
+			err = -EINVAL;
+			goto error;
+		}
+
+		if (x->aead->alg_icv_len != 128) {
+			nn_err(nn, "ICV must be 128bit with SADB_X_EALG_AES_GCM_ICV16\n");
+			err = -EINVAL;
+			goto error;
+		}
+		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CTR;
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_GF128_128;
+
+		/* Aead->alg_key_len includes 32-bit salt */
+		if (set_aes_keylen(cfg, x->props.ealgo, x->aead->alg_key_len - 32)) {
+			nn_err(nn, "Unsupported AES key length %d\n", x->aead->alg_key_len);
+			err = -EOPNOTSUPP;
+			goto error;
+		}
+		break;
+	case SADB_X_EALG_AESCBC:
+		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CBC;
+		if (!x->ealg) {
+			nn_err(nn, "Invalid AES key data\n");
+			err = -EINVAL;
+			goto error;
+		}
+		if (set_aes_keylen(cfg, x->props.ealgo, x->ealg->alg_key_len) < 0) {
+			nn_err(nn, "Unsupported AES key length %d\n", x->ealg->alg_key_len);
+			err = -EOPNOTSUPP;
+			goto error;
+		}
+		break;
+	default:
+		nn_err(nn, "Unsupported encryption algorithm for offload\n");
+		err = -EOPNOTSUPP;
+		goto error;
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
+			nn_err(nn, "Insufficient space for offloaded key\n");
+			err = -EINVAL;
+			goto error;
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
+			nn_err(nn, "Insufficient space for offloaded key\n");
+			err = -EINVAL;
+			goto error;
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
+		err = -EOPNOTSUPP;
+		goto error;
+	}
+
+	/* Maximum nic ipsec code could handle. Other limits may apply. */
+	cfg->pmtu_limit = 0xffff;
+
+	/* Host will generate the sequence numbers so that if packets get
+	 * fragmented in host, sequence numbers will stay in sync.
+	 */
+	cfg->ctrl_word.gen_seq = 0;
+
+	cfg->ctrl_word.encap_dsbl = 1;
+
+	/* Sa direction */
+	cfg->ctrl_word.dir = x->xso.dir;
+
+	/* Allocate saidx and commit the Sa */
+	ipd->sa_free_cnt -= 1;
+	sa_data->invalidated = 0;
+	sa_data->x = x;
+	x->xso.offload_handle = saidx + 1;
+	err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_ADD_SA, saidx, &msg);
+	if (err) {
+		nn_err(nn, "Failed to issue ipsec command err ret=%d\n", err);
+		goto error;
+	}
+
+	mutex_unlock(&ipd->lock);
+
+	nn_dbg(nn, "Successfully offload saidx %d\n", saidx);
+	return 0;
+error:
+	if (saidx < 0) {
+		ipd->sa_free_stack[ipd->sa_free_cnt] = saidx;
+		ipd->sa_free_cnt++;
+	}
+	mutex_unlock(&ipd->lock);
+	x->xso.offload_handle = OFFLOAD_HANDLE_ERROR;
+	return err;
+}
+
+static void xfrm_invalidate(struct nfp_net *nn, unsigned int saidx, int is_del)
+{
+	struct nfp_net_ipsec_data *ipd = nn->ipsec_data;
+	struct nfp_net_ipsec_sa_data *sa_data;
+	struct nfp_ipsec_cfg_mssg msg;
+	int err;
+
+	sa_data = &ipd->sa_entries[saidx];
+	if (!sa_data->invalidated) {
+		err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_INV_SA, saidx, &msg);
+		if (err)
+			nn_warn(nn, "Failed to invalidate SA in hardware\n");
+		sa_data->invalidated = 1;
+	} else if (is_del) {
+		nn_warn(nn, "Unexpected invalidate state for offloaded saidx %d\n", saidx);
+	}
 }
 
 static void nfp_net_xfrm_del_state(struct xfrm_state *x)
 {
+	struct net_device *netdev = x->xso.dev;
+	struct nfp_net_ipsec_data *ipd;
+	struct nfp_net *nn;
+
+	nn = netdev_priv(netdev);
+	ipd = nn->ipsec_data;
+
+	nn_dbg(nn, "XFRM del state!\n");
+
+	if (x->xso.offload_handle == OFFLOAD_HANDLE_ERROR) {
+		nn_err(nn, "Invalid xfrm offload handle\n");
+		return;
+	}
+
+	mutex_lock(&ipd->lock);
+	xfrm_invalidate(nn, x->xso.offload_handle - 1, 1);
+	mutex_unlock(&ipd->lock);
 }
 
 static void nfp_net_xfrm_free_state(struct xfrm_state *x)
 {
+	struct net_device *netdev = x->xso.dev;
+	struct nfp_net_ipsec_data *ipd;
+	struct nfp_net *nn;
+	int saidx;
+
+	nn = netdev_priv(netdev);
+	ipd = nn->ipsec_data;
+
+	nn_dbg(nn, "XFRM free state!\n");
+
+	if (x->xso.offload_handle == OFFLOAD_HANDLE_ERROR) {
+		nn_err(nn, "Invalid xfrm offload handle\n");
+		return;
+	}
+
+	mutex_lock(&ipd->lock);
+	saidx = x->xso.offload_handle - 1;
+	xfrm_invalidate(nn, saidx, 0);
+	ipd->sa_entries[saidx].x = NULL;
+	/* Return saidx to free list */
+	ipd->sa_free_stack[ipd->sa_free_cnt] = saidx;
+	ipd->sa_free_cnt++;
+
+	mutex_unlock(&ipd->lock);
 }
 
 static bool nfp_net_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 {
-	return false;
+	if (x->props.family == AF_INET) {
+		/* Offload with IPv4 options is not supported yet */
+		if (ip_hdr(skb)->ihl != 5)
+			return false;
+	} else if (x->props.family == AF_INET6) {
+		/* Offload with IPv6 extension headers is not support yet */
+		if (ipv6_ext_hdr(ipv6_hdr(skb)->nexthdr))
+			return false;
+	} else {
+		return false;
+	}
+
+	return true;
 }
 
 static const struct xfrmdev_ops nfp_net_ipsec_xfrmdev_ops = {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 040c0c2aad80..0e48e2887278 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2375,6 +2375,12 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
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
index fff05496152d..b7e62d1186ca 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -399,14 +399,14 @@
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

