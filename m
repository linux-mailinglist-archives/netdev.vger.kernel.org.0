Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F235EBFB6
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiI0K15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiI0K1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:27:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2093.outbound.protection.outlook.com [40.107.243.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F958C888E
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:27:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O10SS3UjjhXE1yOaX4qUR86Lb1ywP81Nw8/3NxpwkPIPGv6e9xQ01rHo4fHzxbHZD7df+Nv216ItiiZxoMIswWwwI5CPAM4UrdMGCkNmVmyw7WLnPGzKMc98y8Vs40wSwF4JLKEEk1/Lxs9lWEWJwM6yKsOb5Ev6TvWNOJ3ywgB8W3agpc1E2lO7pEiMd2d6LeBR6jk4U2NEHyQ92GNSYYAUb9zVIXGiN1RG0wzZhY84dubPH6dqb6NTzXuRrgJv7yqYEwQveSHUidt+FumoMPlFpkUfSkjPW4vyZRSe57xlm2WEI1AtXzf69e1kPWfTY75sTbuLd4aYNG/9vppAIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9JU/RDljNiV5Klq4VVr6zcnAc/Sg7hNaltzIfoUlM8=;
 b=SAj+A663dhFDPsiRppWNu3+jKhf0EUl2JVRT/qGtTpLZ0ilJ7Nqn7dmosW91eosKbJ99eIZPbGbWdiBjAxLPHKJEY9sa5XFie9EC3PvfZswIb+nKzKDnyqemPLjlN8Yxav/LFFLXGm4t6hq+LyWGTXVYR/j4qDpX1MpJpEcOaWfzVK4RvkNGS7K3wcTP2dMUaeMZb10qlAiYpAGRTk1+d7a8k+Jgc8dwoUIhEdKMnCnQJLte7T9m/dFSF2f4ng9QeqgPIPo2scixKWmrpWbLkXl2w9ocUBZXAH1g1uYZsrnUQIVtbg4HV79nmSY6dqvn+df0zjf60/UNeRYXdUBUnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9JU/RDljNiV5Klq4VVr6zcnAc/Sg7hNaltzIfoUlM8=;
 b=hDFZQXrfUr0Fl4i73iD+uSy7tf1OQne2gleIgbqrDYd5w5+sHPWnVX+I2wnfCT3E8EmUWSZWoT7Dnp84iE0UIs7OTKbP7Mrc/5fUHzMgAAhwXkqq8tN/Rb7OzLWxThNVTWVUENtiTEY5PzqMiXRDCKPm8MeEiTsZSuLU8zBHGZA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4150.namprd13.prod.outlook.com (2603:10b6:208:262::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.14; Tue, 27 Sep
 2022 10:27:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Tue, 27 Sep 2022
 10:27:33 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Leon Romanovsky <leon@kernel.org>,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Subject: [PATCH net-next v2 3/3] nfp: implement xfrm callbacks and expose ipsec offload feature to upper layer
Date:   Tue, 27 Sep 2022 12:27:07 +0200
Message-Id: <20220927102707.479199-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220927102707.479199-1-simon.horman@corigine.com>
References: <20220927102707.479199-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0017.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4150:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c75a404-33eb-49c6-a72a-08daa072e372
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MxuIA9au5g7nC+KBN3l2AwljHAf/AMhm4cveDG39VnHWxO/FFa1bWNx14pMipBpsZiyhiisP1S702k6G/EZPMjTYYDHCkiGwIHfHlA9t47Agqy1/dzF6jGDHpgfIeS7APCgUbtPBYBIGf5ToIU3dqtBtXuF6vgV3DRksXhezeGYqIIeJFKYS7fVQqPpWgq2VKJVm9KcmfVYqpe13YYCTnoGVDvr1tPwoWH4fsFgy/3jq8RVNNIe94udAv9IsEftW8W5QT0j4HaMR8scZR9Xjfk9IQwR2+MLpEh617Gxitf5vZmvnwzahz2gTGLSnuqxyH1jgMZswamfrAJTijWHfa3bTibF1em1zPi8StUdh5tWWpTUoo3sMu53x4WYuK72AkOwU6HFuHUqdiSjIj2CnUEawtCXStX419+gPFou0Emn5w4Ci7xsQTmO+vPSa+QcUVVMXDUl8RKCvESGtw8ZwDjiC7zF4Qb4MXtkCBKdB07vjzso4G7+AQLThPrj8mg1orsUI/vuymDH0sk8dEnsAksJJxyYEqCIOHYWwufoHpiURw8tdgTb+P76p9F4SOdAqJ/ogwikMmpMVSS2Ca4kAJ8YYBdJJfQvuWgg2HMIWjypWD86Z6PMYm/9VL95EALnfww2Klf4ofkVubOgU93U0jkFO+ewtJvApCjAUKeStdOL52NBvfOn4I2XVFF+HCmq8/cDVSqJpNQaebGldjaRBiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39840400004)(451199015)(186003)(2906002)(36756003)(41300700001)(30864003)(6666004)(44832011)(5660300002)(1076003)(6512007)(107886003)(8936002)(2616005)(6506007)(52116002)(38100700002)(83380400001)(86362001)(54906003)(6486002)(110136005)(478600001)(316002)(4326008)(8676002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5cnkhFaNiaeU1gjz8ouj5U8wgAWMpNJU+XrIxM0NCciavgv4cdICrVOg6gtJ?=
 =?us-ascii?Q?MEuTV4d76tuPBq5vNCBXCZI1Vky96vGqztNBopD3DYyuyEiEDCSeHPxMH3JV?=
 =?us-ascii?Q?JytcDgbslAXfs7EMNlE3xsY2+vFxdsNl+DdF6ifETBFsl0JUzz2IIGT0QmEU?=
 =?us-ascii?Q?t7v69iVeFNT/PWF0caBTR5pM3t9zx8MWVCAgUP3q366fnZcGQvCbNl+2XePG?=
 =?us-ascii?Q?aQtsa+fakuwIU0ZUeRbWwSSP5ILCWP3aC0sfsDOGwvA4ygy5MvyRvYaCfjYD?=
 =?us-ascii?Q?eNnoX7QmJiGefQvbPYh777ixaHZ5k2nokQoNdcntk/xhi45eb7j7aokifhha?=
 =?us-ascii?Q?q4UW3AhJZct8xOOx4qsCsHvKKtZOIsUEyQY7GirBxFBSukbDKtvIFVT3chbi?=
 =?us-ascii?Q?nJVKBCSeKUF7gQsMs8fROWaeZ11WYN+hPDIvJP306TfZZQeSFaC1wxKW21zO?=
 =?us-ascii?Q?GwpaEwTnEQ+fico5NZstMyNjwH3XfC9St/8NXOoyPNnLDr4E7DRV6kk5UyQg?=
 =?us-ascii?Q?UyPwhOWCnQRxImciyOom9mLK+2cTZXoFuA+Feth8mcJocbDYO7cAt0bhT+EY?=
 =?us-ascii?Q?zEH3acsUDgisgWipB2I/pH4/NzZf5KuXaUTTs15ACiJNaeJUMnhAARhPgx7C?=
 =?us-ascii?Q?nsIuSQuZL1xlgvt1BYX5wPBpezxvflG0ddXLZi99NnC2nWupey+neFFs9G7A?=
 =?us-ascii?Q?s/UZnzVwyQpiMDy6r7M2C0V4MROKmpB+UCL/lGiXc9Lvj6x6KkT6w5/6CITE?=
 =?us-ascii?Q?orWsE/bfdQW+31YJNpL2mYVoUiQ6wEBSqEFsNkhlFokovUCiKNbNGxL4Tne4?=
 =?us-ascii?Q?+NtuXpEWrFc74iRuiquqaXOo9awJiI5HtCUB95fuEf3MzEub0ZDy1yjKe9/0?=
 =?us-ascii?Q?imEkD+oL3xfGnwXRuDBcV7KzP5+4B/ExYURpiHMTWIFg2qckIh1s4fZ8npr2?=
 =?us-ascii?Q?dau7WdUM+YphyVuywuGc7JfcLHsb08g0XXoWguwy8ajzigsRV+F5bweHFEoi?=
 =?us-ascii?Q?b6guuCLxboTV8j7kgU++Ja2yAKm4yF09QPYhvO+l4zPb5fpnOAEgDEnm86wL?=
 =?us-ascii?Q?1k+KC3ktGoIiQpTJdeiveknETO5HovgACjkF7X+xOQmeaepId/AwIZiF6QU+?=
 =?us-ascii?Q?yXnB3srGSfB2BJlwYSmCPDMGefBm76ej3jNQXUWDTlOD12Z7bfHXr6kTAI0s?=
 =?us-ascii?Q?pWBBoZ2vDg6o65C8IE0wvHtNwtPqw91bRKOdS7RmVRILkEpU7X1fzDoLm7Ag?=
 =?us-ascii?Q?XpDsuHSpudlAKLnQhcfrtmB2Er1VGuehh4ntUtkRO+m32PsRuvnLShinDLB0?=
 =?us-ascii?Q?KDRKh9Bijo28DlFKeYrcA3JgWPRsaGL+wMS3YzeDPNRTwbTnYuxbQcPLb8OX?=
 =?us-ascii?Q?BHsNhFDMgovvGx235poGdHeQz5faacRrUUw7jQtiJ2Tf590HK+urMlW5llCy?=
 =?us-ascii?Q?3wJDyIc4UPwiCxcEe/0lNEmEQdkc0ceP2TzuydewhjEPFMh/w6y+XoZaWB1G?=
 =?us-ascii?Q?klQ0zXC03urwfBUEwqQ2JbXGTYRl7SJ5x/aIysGf/4z9YFHtgb5Ftee3TLsk?=
 =?us-ascii?Q?Ui2ILrqTmFvGwO53LD03EI+/RgcducWh3+UAo87TUbu5hW548cva0RIcEg+i?=
 =?us-ascii?Q?X2OUCt9oziTHG+WQXvooBL3U9GLUIxkhG2zzIrCaod0NqZOJK1+rv5HCE4/5?=
 =?us-ascii?Q?+PWtOQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c75a404-33eb-49c6-a72a-08daa072e372
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 10:27:33.0566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oj/AlM2kU48XgkgJebn4LSzRjfRXRszH705lnheeqxPYgq/rKEUd458IuvbTOfmW+hVRPv85xYgWu8tSCwZswNdFxbEk1dcDIZDPpFQeYss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4150
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
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 562 +++++++++++++++++-
 .../ethernet/netronome/nfp/nfp_net_common.c   |   6 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +-
 3 files changed, 568 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index 658fcba8e733..a81e6cde4ea8 100644
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
@@ -84,22 +222,442 @@ struct nfp_net_ipsec_data {
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
+		err = -EINVAL;
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
+		err = -EINVAL;
+		goto error;
+	}
+
+	if (x->props.flags & XFRM_STATE_ESN) {
+		nn_err(nn, "Unsupported XFRM_REPLAY_MODE_ESN for xfrm offload\n");
+		err = -EINVAL;
+		goto error;
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
+			err = -EINVAL;
+			goto error;
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
+		err = -EINVAL;
+		goto error;
+	}
+
+	if (!trunc_len) {
+		nn_err(nn, "Unsupported authentication algorithm trunc length\n");
+		err = -EINVAL;
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
+			err = -EINVAL;
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
+			err = -EINVAL;
+			goto error;
+		}
+		break;
+	default:
+		nn_err(nn, "Unsupported encryption algorithm for offload\n");
+		err = -EINVAL;
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
+		err = -EINVAL;
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

