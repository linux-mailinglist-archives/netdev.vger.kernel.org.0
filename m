Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6335673716
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjASLkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjASLjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:39:53 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2126.outbound.protection.outlook.com [40.107.94.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E7C75732
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:39:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuKe/FoeJZI0Mb6DOnAUHfcpePUaAhgCds5G6BEApXePZ6ueLBW6qw74sqxJ1fw7L0ae7y+4jmk+rdvHveMTiPK0YtB8Kf9u5BlY9yGIEkra5K/60M+Eju+T7xn/NftH3wG03kh/qEI6W1ErakZSUm9C3pIybiQY4wZK3wnYIsh5SH28YX1aI2Y0NIL4yc4LtYt7/Hqxz6r6jIwTduEgjWCPtMYE1U5I+OucVVj7eqsOoE3dlnn2JNOKTLRk0zP7O9z6AsMP1dfnnA6/TXoJg0DAFA9DUs6uN4ta3XDBWcp9TztaNagTiO1+4tNnAmXOltXEBbyl0dyiDU7jjK5njw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HrbdvMj9YKre0MgTGzEidrRfuw9L1S/OmWfB4aZ6ewM=;
 b=FJFYtbFSnPXxVP2Xo4V51UE6delwuDobZ4tRYnxpo0bHUj9/jOTJM3silS9NoShbfI9XKaqGKhHTeEFbxJGd+6eb9ELZYV1BbL4fxJNoj1MKEfRcNlak5glSCk1C86nq/HKnEn+D7XLN5Qq0b7ulTdjF6RBQG/zK5EzQBhRELcBrB22Gt8nMS9WJEnyjOKZ5VJvZ5Tc+mB8Mlj+PlYRJOxY8/XwT0wXgj8TD3DhRDHCJP2Cgh6DUE3M/1nWNrbQ+4/2luLh+DNoEkra45eMxFlF39FpbK6uh0m4s1r6Sji2JCOQXCAZ6en0AHdkMyck6ySp/zMZWdyLLYtvU+LKoAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrbdvMj9YKre0MgTGzEidrRfuw9L1S/OmWfB4aZ6ewM=;
 b=rw8zZw4UqldCLet+OrvM6cwJZMjNdL9ySIndSG1nn6v3U/QS3EfnlyLwsLnxuRe1cEFHA11JyaJYYjo+A+7wkrmEksgc2qD0hxorCxhLu3NrYF+hCQN9Asz2nk7AJGZEDfELDDBNbr9vJLQFGVJceBqlWKl+m3BOi90OPw4Zb1I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5520.namprd13.prod.outlook.com (2603:10b6:510:12b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 11:39:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 11:39:15 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: support IPsec offloading for NFP3800
Date:   Thu, 19 Jan 2023 12:38:42 +0100
Message-Id: <20230119113842.146884-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P193CA0006.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5520:EE_
X-MS-Office365-Filtering-Correlation-Id: e22f4781-1e69-4dda-8b2b-08dafa11caec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S2IojfnGHUwaTjSYp6+jLZQ/I1ENfE9DU012HjpLnhVUntNG9UW/vRTtzWunVKhbXPpKuBo9mLFxwua5zKPfBZNLhl6Cw2K68YGujRQeDgLnQQW2coQccaSY/QZsdRmIQnRDcjnOM8amLAghkeMlfFd44K6VAOuH1HUEAJybSB49wH9L6QQGYKrk1x7Y0QDHxs46JmiQlN7fgL+HJKlel5WPdQCpTitc2n8XpoEca3FPy+IDVU0pttBlU26rpEFU0S+a6QOvYR9RRgQQgNddvtvEO+UClm1JSVORIX7Qrvz4NDP82tR6ozSoxIAKLgW3991v6N31OG785T+QAwU8UkTevkHSJKK6R86LuBFTMgVw4F5EYXjtHCJKhu/DdIeWOo9qT/pLmmY19WKe8aF3CobZev+0b8Jn/g+7XkePB46Pi4ep/2w8QED2B2rdaMZ3CLFYpbP12wfyIIyQd28DPBJmkWK6q1qg0Pehm91afc94coFa97raYV20vrq7VJTyKlWKL024OOgKBtY8PcfR/AsAl+/zXbTd2hPUClfuiuMy9pyJL0u8FmfzmX0/77r2TgSlQM96HRTmlujVxQkrLe8UGqK233JonCA+IVBH4ivudr1LiHwhsAWEk9xw+0AyYuWlZ2B7mCcA8V5F1uDZDHg+tElAi6D1fHC5e/EHvkcspnS1R5uB7TMblM3M47FnuZbV0dt9UutggZ1DZgDuN4QNHlqwuYG2JmSpvHDrwb9emMF/XTFQpZxsxOb6eCSc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(366004)(396003)(346002)(39830400003)(451199015)(41300700001)(44832011)(6666004)(107886003)(2906002)(6506007)(5660300002)(478600001)(6486002)(6512007)(8936002)(186003)(54906003)(1076003)(110136005)(4326008)(38100700002)(36756003)(83380400001)(52116002)(66556008)(66946007)(2616005)(8676002)(66476007)(86362001)(316002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6RiY8ak1kboj1HfsaRFg2YNPyqNzU8K8kXO3pTVwZ2YlpUoYbHgcobj37ME6?=
 =?us-ascii?Q?mvq1MlTnRSNWyhj087uMA9GBZy5IM8t1iiDc2fnBzXu2D8Pw0PLRgJSHtpvL?=
 =?us-ascii?Q?8R6iFVs03qDSi5oT+5cc4Cd5RltUAFTZ/APadrB1ckHbEv+Yugkc6DN+19jB?=
 =?us-ascii?Q?stgjSe5XJ/iR0o0HNy2M0K+jMcaKtN7LiS5ohYB7D7dPh+3vZizEhMy5Y3cD?=
 =?us-ascii?Q?2VYyRsJh24y7TtA6fGW9Ny7+ijZqx8BEEsl/FXC/S3gu6xVGAHa9mfJz7Nc7?=
 =?us-ascii?Q?GUluZbf0/h51HeDpLgynhKqR+ex7n5sihWj/w26aFOcsYcz3whrdFpjSfJdA?=
 =?us-ascii?Q?ccKWjuJwl5VjoSqA/4Hh5TyDodndEYzy7aeXOe9GNOgn1GVCsIpK4TSw4iXl?=
 =?us-ascii?Q?LaZM0ObVM7IKm/rJ4gn1shmv8fOwBr+z312DA7U+m0urdR5vc1NFm+5LWYnN?=
 =?us-ascii?Q?cbx+T6ndLup/31UMREj7XSuuyp3i4FzQ9ekZ3v5ofIyqlV5w1KWrY7LhwgCS?=
 =?us-ascii?Q?hPvRrTYiFpoGYvo214MpPm1qlVAOm/aFjcNv3jBjfV58qxa+J1WH1tAOWyc+?=
 =?us-ascii?Q?tvivmWbPyZB+SIeEt8HAJmEANgbXfLYoj7fGVNvyXAx26W4EJz3ktsrcoFxj?=
 =?us-ascii?Q?smaQvhua+9qbHWsp5uzgBo5IyNcOxRVnzDeMNcWgqK/I4FBNCn/pt9+6rq2s?=
 =?us-ascii?Q?/liED/DffAXfBzApAQ+5r86Is0z66GRMrd4vAfhHEoTpFh1W3/7SzGpluyNB?=
 =?us-ascii?Q?QL05V/VCFfau1txColwNsrtmJuagPNmEkuHTMzhZAed1KYn9nAJSUrfb211P?=
 =?us-ascii?Q?TCbo6ShIWH2L2qHL8b+HihUTcdbDhATN6xy0hkOaCUGympMrChGQGjpxIL3b?=
 =?us-ascii?Q?oPv3R9HiVNjJKz3TeuIdkkXBnyswM/I5U98Yyw/h4eflA3JVb4ihW7G9TXfv?=
 =?us-ascii?Q?Pb5aNImcSnSuPy6mzB/o7Zz1OYzFnAMplxzfcpUyqDEXlO1O0SF8LMV0Ds5v?=
 =?us-ascii?Q?WrWv/Gh+mWTGduHpGcirgJusyfmbqlaqkis0csATXjfKOGYvqESSHdT405fh?=
 =?us-ascii?Q?3TDhSZtQKGbDMrbhCqRznwdlHNbNpHDTIq0GGapdAn7wF6iDboUIn04gnYLU?=
 =?us-ascii?Q?KbxJrm02EvVbEM3L5SW3q2A/+gfKdzJX4QlMo7X2eH3lOZsPqE2IK4nvtfh2?=
 =?us-ascii?Q?7LqHNepSRTHujUFvUAO1QCjQZ2BPP1woyuEC2R7KDdlHqc4QChQ34K1y1eZI?=
 =?us-ascii?Q?sb5Zi35aEewM1KF6PUWN5ac2u2zN9HNSbPemPO+a7C6YSMh/1qFj+sgh5PiJ?=
 =?us-ascii?Q?lkt1tDUvWR3sLZbIMbNTBwqXVwYcT3wdl3r2ckH/jsC7INORMx7Mf0cMf838?=
 =?us-ascii?Q?ezomvk0jQMIdLwH0iRMma6P816lRAs3zKm7W4kKoMyuG+3Rtq2/YkAyU0rlK?=
 =?us-ascii?Q?XbrFjE4SgIul6JY4TB2LFVhJpC1x1dXZ2Fhi+4X9CoWqYuz9uBTRS/YurbsW?=
 =?us-ascii?Q?mpNseJVEpPG6G6FlIP8ntdjB6CyZYuUQJeSb4EV4h0bwtbW0IqUZ+iJYmxlC?=
 =?us-ascii?Q?Tvkep6jDanBnrREmOdwfagE4mBMoaLfYky/AlaxTzlsIYiT5AXKFiHGNM0ht?=
 =?us-ascii?Q?NIvTzKDk3KNn73Nf4Hx/ZhJEbBscl4Uw8XFVwW7fPFKSCuYcM7RkMwO/rfZz?=
 =?us-ascii?Q?xM8hnw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e22f4781-1e69-4dda-8b2b-08dafa11caec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 11:39:15.4421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q4F33qr9vg8EXkzxfA+i7uUcQXMcWpupoO/m672N+d/WtlpEh5AJ+x5vcltM0OssbpRXLS4PIDxgAlUz+lLtEPzVJ4Utsv5Jq4c2tiJqKgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5520
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

Add IPsec offloading support for NFP3800.
Including data plane and control plane.

Data plane: add IPsec packet process flow in NFP3800 datapath (NFDK).

Control plane: add a algorithm support distinction of flow
in xfrm hook function xdo_dev_state_add as NFP3800
supports a different set of IPsec algorithms.

This matches existing support for the NFP6000/NFP4000 and
their NFD3 datapath.

Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/Makefile   |  2 +-
 .../net/ethernet/netronome/nfp/crypto/ipsec.c |  9 ++++
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  5 +-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 47 +++++++++++++++++--
 .../net/ethernet/netronome/nfp/nfdk/ipsec.c   | 17 +++++++
 .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  8 ++++
 6 files changed, 79 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index c90d35f5ebca..808599b8066e 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -80,7 +80,7 @@ nfp-objs += \
 	    abm/main.o
 endif
 
-nfp-$(CONFIG_NFP_NET_IPSEC) += crypto/ipsec.o nfd3/ipsec.o
+nfp-$(CONFIG_NFP_NET_IPSEC) += crypto/ipsec.o nfd3/ipsec.o nfdk/ipsec.o
 
 nfp-$(CONFIG_NFP_DEBUG) += nfp_net_debugfs.o
 
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index 4632268695cb..06d2f95c91b5 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -10,6 +10,7 @@
 #include <linux/ktime.h>
 #include <net/xfrm.h>
 
+#include "../nfpcore/nfp_dev.h"
 #include "../nfp_net_ctrl.h"
 #include "../nfp_net.h"
 #include "crypto.h"
@@ -329,6 +330,10 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x)
 		trunc_len = -1;
 		break;
 	case SADB_AALG_MD5HMAC:
+		if (nn->pdev->device == PCI_DEVICE_ID_NFP3800) {
+			nn_err(nn, "Unsupported authentication algorithm\n");
+			return -EINVAL;
+		}
 		set_md5hmac(cfg, &trunc_len);
 		break;
 	case SADB_AALG_SHA1HMAC:
@@ -372,6 +377,10 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x)
 		cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_NULL;
 		break;
 	case SADB_EALG_3DESCBC:
+		if (nn->pdev->device == PCI_DEVICE_ID_NFP3800) {
+			nn_err(nn, "Unsupported encryption algorithm for offload\n");
+			return -EINVAL;
+		}
 		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CBC;
 		cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_3DES;
 		break;
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 861082c5dbff..33b33a77d64e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -195,7 +195,7 @@ static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb,
 		   !!md_dst * NFP_NET_META_PORTID_SIZE +
 		   !!tls_handle * NFP_NET_META_CONN_HANDLE_SIZE +
 		   vlan_insert * NFP_NET_META_VLAN_SIZE +
-		   *ipsec * NFP_NET_META_IPSEC_FIELD_SIZE; /* IPsec has 12 bytes of metadata */
+		   *ipsec * NFP_NET_META_IPSEC_FIELD_SIZE;
 
 	if (unlikely(skb_cow_head(skb, md_bytes)))
 		return -ENOMEM;
@@ -226,9 +226,6 @@ static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb,
 		meta_id |= NFP_NET_META_VLAN;
 	}
 	if (*ipsec) {
-		/* IPsec has three consecutive 4-bit IPsec metadata types,
-		 * so in total IPsec has three 4 bytes of metadata.
-		 */
 		data -= NFP_NET_META_IPSEC_SIZE;
 		put_unaligned_be32(offload_info.seq_hi, data);
 		data -= NFP_NET_META_IPSEC_SIZE;
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index ccacb6ab6c39..efa8259adbd5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -6,6 +6,7 @@
 #include <linux/overflow.h>
 #include <linux/sizes.h>
 #include <linux/bitfield.h>
+#include <net/xfrm.h>
 
 #include "../nfp_app.h"
 #include "../nfp_net.h"
@@ -172,25 +173,32 @@ nfp_nfdk_tx_maybe_close_block(struct nfp_net_tx_ring *tx_ring,
 
 static int
 nfp_nfdk_prep_tx_meta(struct nfp_net_dp *dp, struct nfp_app *app,
-		      struct sk_buff *skb)
+		      struct sk_buff *skb, bool *ipsec)
 {
 	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+	struct nfp_ipsec_offload offload_info;
 	unsigned char *data;
 	bool vlan_insert;
 	u32 meta_id = 0;
 	int md_bytes;
 
+#ifdef CONFIG_NFP_NET_IPSEC
+	if (xfrm_offload(skb))
+		*ipsec = nfp_net_ipsec_tx_prep(dp, skb, &offload_info);
+#endif
+
 	if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX))
 		md_dst = NULL;
 
 	vlan_insert = skb_vlan_tag_present(skb) && (dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN_V2);
 
-	if (!(md_dst || vlan_insert))
+	if (!(md_dst || vlan_insert || *ipsec))
 		return 0;
 
 	md_bytes = sizeof(meta_id) +
 		   !!md_dst * NFP_NET_META_PORTID_SIZE +
-		   vlan_insert * NFP_NET_META_VLAN_SIZE;
+		   vlan_insert * NFP_NET_META_VLAN_SIZE +
+		   *ipsec * NFP_NET_META_IPSEC_FIELD_SIZE;
 
 	if (unlikely(skb_cow_head(skb, md_bytes)))
 		return -ENOMEM;
@@ -212,6 +220,17 @@ nfp_nfdk_prep_tx_meta(struct nfp_net_dp *dp, struct nfp_app *app,
 		meta_id |= NFP_NET_META_VLAN;
 	}
 
+	if (*ipsec) {
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.seq_hi, data);
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.seq_low, data);
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.handle - 1, data);
+		meta_id <<= NFP_NET_META_IPSEC_FIELD_SIZE;
+		meta_id |= NFP_NET_META_IPSEC << 8 | NFP_NET_META_IPSEC << 4 | NFP_NET_META_IPSEC;
+	}
+
 	meta_id = FIELD_PREP(NFDK_META_LEN, md_bytes) |
 		  FIELD_PREP(NFDK_META_FIELDS, meta_id);
 
@@ -243,6 +262,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 	struct nfp_net_dp *dp;
 	int nr_frags, wr_idx;
 	dma_addr_t dma_addr;
+	bool ipsec = false;
 	u64 metadata;
 
 	dp = &nn->dp;
@@ -263,7 +283,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_BUSY;
 	}
 
-	metadata = nfp_nfdk_prep_tx_meta(dp, nn->app, skb);
+	metadata = nfp_nfdk_prep_tx_meta(dp, nn->app, skb, &ipsec);
 	if (unlikely((int)metadata < 0))
 		goto err_flush;
 
@@ -361,6 +381,9 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 
 	(txd - 1)->dma_len_type = cpu_to_le16(dlen_type | NFDK_DESC_TX_EOP);
 
+	if (ipsec)
+		metadata = nfp_nfdk_ipsec_tx(metadata, skb);
+
 	if (!skb_is_gso(skb)) {
 		real_len = skb->len;
 		/* Metadata desc */
@@ -760,6 +783,15 @@ nfp_nfdk_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 				return false;
 			data += sizeof(struct nfp_net_tls_resync_req);
 			break;
+#ifdef CONFIG_NFP_NET_IPSEC
+		case NFP_NET_META_IPSEC:
+			/* Note: IPsec packet could have zero saidx, so need add 1
+			 * to indicate packet is IPsec packet within driver.
+			 */
+			meta->ipsec_saidx = get_unaligned_be32(data) + 1;
+			data += 4;
+			break;
+#endif
 		default:
 			return true;
 		}
@@ -1186,6 +1218,13 @@ static int nfp_nfdk_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			continue;
 		}
 
+#ifdef CONFIG_NFP_NET_IPSEC
+		if (meta.ipsec_saidx != 0 && unlikely(nfp_net_ipsec_rx(&meta, skb))) {
+			nfp_nfdk_rx_drop(dp, r_vec, rx_ring, NULL, skb);
+			continue;
+		}
+#endif
+
 		if (meta_len_xdp)
 			skb_metadata_set(skb, meta_len_xdp);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c b/drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
new file mode 100644
index 000000000000..58d8f59eb885
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2023 Corigine, Inc */
+
+#include <net/xfrm.h>
+
+#include "../nfp_net.h"
+#include "nfdk.h"
+
+u64 nfp_nfdk_ipsec_tx(u64 flags, struct sk_buff *skb)
+{
+	struct xfrm_state *x = xfrm_input_state(skb);
+
+	if (x->xso.dev && (x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM))
+		flags |= NFDK_DESC_TX_L3_CSUM | NFDK_DESC_TX_L4_CSUM;
+
+	return flags;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
index 0ea51d9f2325..fe55980348e9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
@@ -125,4 +125,12 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 void nfp_nfdk_ctrl_poll(struct tasklet_struct *t);
 void nfp_nfdk_rx_ring_fill_freelist(struct nfp_net_dp *dp,
 				    struct nfp_net_rx_ring *rx_ring);
+#ifndef CONFIG_NFP_NET_IPSEC
+static inline u64 nfp_nfdk_ipsec_tx(u64 flags, struct sk_buff *skb)
+{
+	return flags;
+}
+#else
+u64 nfp_nfdk_ipsec_tx(u64 flags, struct sk_buff *skb);
+#endif
 #endif
-- 
2.30.2

