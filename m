Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEA85EBFB5
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbiI0K1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiI0K1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:27:35 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2093.outbound.protection.outlook.com [40.107.243.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4808DAD986
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:27:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbA0E7C8aGZ2b+wiZAoMyjvvZ/r8Y8S58U73k5xX7TJlzM3ebIoaF0catqEZcVJPermAXKu08RhVnzHLHfLyjr0UFS/ZXZUlCksFAN5ack21fnArouxFjZhqY8m25kX+MeR+uww/UCjg9nTv9VXdSbn3EyITJ9ftR9lmUg8RBEE3THajE+Dqwl6FSARhAmpE0VohO88JlvrE6TgoRbLOvu4sBdTpSGhtF8ZV2qSAskJ2K8syLj3qmSoZ0b6xP+SdMzlNGAlVG+J4eLlvvf96LuUmqUrlD2lyHMRMBS3FOyd31x4LAyNzIa1lAbs0HvdLySbl/FqH+RSBHWIlwohVyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4I9JURb3v9ZP4NX77p9I5tUIH9SFbRA9gjtZMMm7Xs=;
 b=CoGZTx9moPl2nWr5njHnBALI2uwNTC11evDFaxLzqOmypCf91oWoeHTpn3rJk5eqcMPQPaik+TwZ66BWQUPPSb80gv0SS44GNmMa6HG3T+kcMzrud7XGuO76HZXTlqNXieKS8h2Pv2faeQariouYVjsxeVkXZYUBAF4q9T7yesTaz5uKCbBe5Xb/oh3De32IIm8mZo1NSrYajd44f91PRWY8kHzAEsJs1BZK4WZKxbS1nmatE4bRtqRRS+vTGQho7LOSHj+uIT52mm2IWsL6kUe8WJFhwQsQeM8uKUiIbC7lfLUKnfYHE6cnw9KkVtsNe4W4zHKwf0P0OwaHgaTG/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4I9JURb3v9ZP4NX77p9I5tUIH9SFbRA9gjtZMMm7Xs=;
 b=Ee8Rx4jpJNfA9e3r34MO041NQ3XwKxQM3uvSgDLzHBEkTbrQPeZNQmXlMclNP5TO5CxQ7tQvft5lZX4IV+uUMOgDindCpBu3+PMk6flCYZTo6nr+zAHrn4FsjUZJkC28Mt1c+CllA9vbgAb2VmkylBtpJknPCxf0tzW9USWVNl0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4150.namprd13.prod.outlook.com (2603:10b6:208:262::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.14; Tue, 27 Sep
 2022 10:27:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Tue, 27 Sep 2022
 10:27:31 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Leon Romanovsky <leon@kernel.org>,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Subject: [PATCH net-next v2 2/3] nfp: add framework to support ipsec offloading
Date:   Tue, 27 Sep 2022 12:27:06 +0200
Message-Id: <20220927102707.479199-3-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: d51b22e6-987b-4821-1eef-08daa072e26c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V7m2V153QmbWtPATTPdQg3ysWCbP7MAqshwF68QSnIv/GhjlqKme4owM8GG5KCRze41jvuLRGQ9yk9V0zQ7vKIICIyWZGbcxCMGy5dbHlbHNRxWxERn2aE7wRX1NfTGn2HDR8C+wvseyyd3A7isPxrkzAgFcsS69bRMDWpVqAWKtnYQ0VYEr+AroR1SmFsYJbjHsuGV9yW3VrQOUh11f5gK2/WZa3Uxoghsa2lt1E6wCdXjY667UtSXBll0aqnId5ELVHiJF274Pl4vem6OC7irjsRzGuXwZ+dWFPap7lf/oBYQ+SM60nlaKKGra9ljShXAr1s9MpwxyS7L3LWMDDCyO2WJBsWX3kH3heAbd1NAK7VHdhE3DskAoaR8KsSiFppTFWyemrZzR+duCCupeJcBx/p5K2Fa0OEdw1/3kA8nT4E4/jfwcouxLDj7ybQrWD7nwXzJsb80/zEVsHDvYX5XjStUVclhoVg+vDazCof6zqhsybdKZMOLRfmGdsEyPaK0InF38UMrJF/svCWT7P4mE8K8sr17Q9XJxWiAnMsA0h6wVqaqEB7Wzka1T5RNiX+kLgNTGh8AQz+cKcwowWCT0o3yxcuCe0Ea7iO24duPCTdjZfanza32EP/3mX5d/0hG5mcwMgx0gdkdNMkguqn7eEWkA1+Dj2TiY7jbV2Wrzu50/Jw46u8biaFL7UxR1GTkDLhBCaPVSddVpp0Hm018MowPML2B4B9OipgQbiqTNLImIKeSCAFmn0yWB90RcJz6UMOAJrrpLBdHa86UuYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39840400004)(451199015)(186003)(2906002)(36756003)(41300700001)(30864003)(6666004)(44832011)(5660300002)(1076003)(6512007)(107886003)(8936002)(2616005)(6506007)(52116002)(38100700002)(83380400001)(86362001)(54906003)(6486002)(110136005)(478600001)(316002)(4326008)(8676002)(66556008)(66946007)(66476007)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nu8yfzfIrqXh2mG2IyY1XLxzybgRFedPzRcMIf0ol37oylPafFlDIoPeDpVy?=
 =?us-ascii?Q?B7MxeuSvINAH2hQHK+xxbLIku/K0/no+bvVLXXuOsYzmxT7wLDTIclonlAT9?=
 =?us-ascii?Q?QD1XzxV0TRU5MGTxBwCuJa5GoxW+w+WlW36aadxqWiqPYZOAajw8uCLP3MjK?=
 =?us-ascii?Q?vINcwr3KI76iT795v8uIxDs+7E0hVRZ9WYEVGf6FrXlbW0s/VVZwJZ/7ltcF?=
 =?us-ascii?Q?LlpxBr0bZWr6vtdWP+dXkZ+icF+dfHhjjV/W7+wI35l5MCGukWr4+SHAvcMT?=
 =?us-ascii?Q?tKYLx7UvbGOnBD7E7KIxWjcUFlgLNKf8a76AoSCtrpHPc57+efQvYbWm5pah?=
 =?us-ascii?Q?mkCWIsnjznI2JL09+BTjA1zwQ6He8lkNsTD0VdNIt6488Ghv/AAhx+qeN4kH?=
 =?us-ascii?Q?9B9L4TnqlPOB54PVQDqA44/XQuMxFlMJBsRW0aN8sqZiHJOdo4P10TA8pGZ2?=
 =?us-ascii?Q?DbzNUds7LLK7tNilozoqC+C7HGkp6RmKmnoDW5YE6BFE6EMw7Ht9Kk2pTNM5?=
 =?us-ascii?Q?C1tt2xkg3QLLMFYvelVfp+5SsZEx2T16eTX+zPOZgCTwqGoBbjZ3f6hpSQCa?=
 =?us-ascii?Q?+1x98UVaX/Jpb0KmxLK9jRAsVkF0t2Dl52j/zllPoy4fvqxriKU6/mk1NWzA?=
 =?us-ascii?Q?J77hm5xpuekN2iVGYil7qNoihEiannrsEtrd+hpglseMCB7b/Gy+BeusKGE8?=
 =?us-ascii?Q?1+gOfAkbqEhh2GYNuDa3gZr4WcrVDo2+hahJMkjX0RmExd/G5XrDePMrIyKF?=
 =?us-ascii?Q?FmVdb1XyCzGajaZSveWVhrz8Jvfk5ncEAA5CGDiZlzAysjnIRs9yzdb3NRpU?=
 =?us-ascii?Q?fps9jz1GdeFiRpRE7qMlz68PLG5vktoG7OVLLvVvR2+odbpi4kQhG6ORAzbh?=
 =?us-ascii?Q?u8b01KW6Avy0W6MAsX5vqpHzwuWS+J7QiW+DsMZR1Cnu8NR/LF8BJnIYxXCn?=
 =?us-ascii?Q?1Yeslwmn62IVuIwYc+xPEXzHKDrOrKn5S6nASTuCOxVvSFOBqcffA3WyeKzk?=
 =?us-ascii?Q?ajHM8nrExApPziiQrjgOIV8GpbyZr2199RNx5G6O7Yabb9CAEHmG0OfEXOid?=
 =?us-ascii?Q?65ORADPfHtqzqB1HhYTyA8WGBW21t97sIOXbPIt1ceg1ggSC3zVMM0AIWRaM?=
 =?us-ascii?Q?c7FowTscREYb03YCVwEyL1I9kDoTt6reOvuaufpjQV9qXuUq1QseoGZCgAY0?=
 =?us-ascii?Q?3hAKc8R/eoIj3cFnufkj36AI6uIJXaYT+fZyiP+ya9h3aX4FDScOp4xppDz/?=
 =?us-ascii?Q?wQ3EscXrxsSKsPeV8JMvUiQx3WtXwRNqRCpOGTe4UA/epRrGlQE6KqKdiTNu?=
 =?us-ascii?Q?2wZQGaMK1XVo6mrj+zmTgmrkF1OwdLLyUYIU5eNXsN19weBXvE6lw2T1cUtF?=
 =?us-ascii?Q?oetxMtLcMxpL7v7vL90ZDOK2ex2j8FBDRBjVMHtADRlFtWPiq7J3fwdBLwif?=
 =?us-ascii?Q?bivgsbcNLWMUQwAVW7Dk9Nn/b4uiAIfaiOsjWVKbDWiFd+Neujy0Z4kiKj0I?=
 =?us-ascii?Q?1Ct1mOYg2cFnQVeziVfKhSzp7d3uU0TCXtlSH7pGkSLBP7Z4YhTE372RMk9d?=
 =?us-ascii?Q?1ynkFZfLnW/iDKVeEfCzthPNiNYWf2LX/Smjgep1AbJoC1ov8qHueoEJHJX/?=
 =?us-ascii?Q?Zh769Y/L8Bv+FpJT49e4IZQcYcSeWPml455h5fJ0anuSebAMGiyZ44s3hblv?=
 =?us-ascii?Q?Xy+Rrg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d51b22e6-987b-4821-1eef-08daa072e26c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 10:27:31.3673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JYU/Mrx2ou7TDS34MGzPasNswEP+n8ThQiUGGx0I2A5KVU1DCcQGw6Odf24wYzcOEL0lJY8Pp6FvusdFkEHXOpJWE2awnyrawK80avvYMQY=
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

A new metadata type and config structure are introduced to
interact with firmware to support ipsec offloading. This
feature relies on specific firmware that supports ipsec
encrypt/decrypt by advertising related capability bit.

The xfrm callbacks which interact with upper layer are
implemented in the following patch.

Based on initial work of Norm Bagley <norman.bagley@netronome.com>.

Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/Kconfig        |  11 +
 drivers/net/ethernet/netronome/nfp/Makefile   |   6 +
 .../ethernet/netronome/nfp/crypto/crypto.h    |  35 +++
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 216 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  43 +++-
 .../net/ethernet/netronome/nfp/nfd3/ipsec.c   |  19 ++
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |   8 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   9 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  10 +-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +
 10 files changed, 354 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c

diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
index 8844d1ac053a..7f669d39e471 100644
--- a/drivers/net/ethernet/netronome/Kconfig
+++ b/drivers/net/ethernet/netronome/Kconfig
@@ -54,6 +54,17 @@ config NFP_APP_ABM_NIC
 	  functionality.
 	  Code will be built into the nfp.ko driver.
 
+config NFP_NET_IPSEC
+	bool "NFP Ipsec offload support"
+	depends on NFP
+	depends on XFRM_OFFLOAD
+	default y
+	help
+	  Enable driver support Ipsec offload on NFP NIC. Say Y, if
+	  you are planning to make use of Ipsec offload.
+	  NOTE that Ipsec offload on NFP Nic requires specific FW to
+	  work.
+
 config NFP_DEBUG
 	bool "Debug support for Netronome(R) NFP4000/NFP6000 NIC drivers"
 	depends on NFP
diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index 9c0861d03634..3d33b2838e0d 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -80,4 +80,10 @@ nfp-objs += \
 	    abm/main.o
 endif
 
+ifeq ($(CONFIG_NFP_NET_IPSEC),y)
+nfp-objs += \
+	    crypto/ipsec.o \
+	    nfd3/ipsec.o
+endif
+
 nfp-$(CONFIG_NFP_DEBUG) += nfp_net_debugfs.o
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
index bffe58bb2f27..a27a378e3ebe 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
+++ b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
@@ -39,4 +39,39 @@ nfp_net_tls_rx_resync_req(struct net_device *netdev,
 }
 #endif
 
+/* Ipsec related structures and functions */
+struct nfp_ipsec_offload {
+	u32 seq_hi;
+	u32 seq_low;
+	u32 handle;
+};
+
+#ifndef CONFIG_NFP_NET_IPSEC
+static inline int nfp_net_ipsec_init(struct nfp_net *nn)
+{
+	return 0;
+}
+
+static inline void nfp_net_ipsec_clean(struct nfp_net *nn)
+{
+}
+
+static inline bool nfp_net_ipsec_tx_prep(struct nfp_net_dp *dp, struct sk_buff *skb,
+					 struct nfp_ipsec_offload *offload_info)
+{
+	return false;
+}
+
+static inline int nfp_net_ipsec_rx(struct nfp_meta_parsed *meta, struct sk_buff *skb)
+{
+	return 0;
+}
+#else
+int nfp_net_ipsec_init(struct nfp_net *nn);
+void nfp_net_ipsec_clean(struct nfp_net *nn);
+bool nfp_net_ipsec_tx_prep(struct nfp_net_dp *dp, struct sk_buff *skb,
+			   struct nfp_ipsec_offload *offload_info);
+int nfp_net_ipsec_rx(struct nfp_meta_parsed *meta, struct sk_buff *skb);
+#endif
+
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
new file mode 100644
index 000000000000..658fcba8e733
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -0,0 +1,216 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2018 Netronome Systems, Inc */
+/* Copyright (C) 2021 Corigine, Inc */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/netdevice.h>
+#include <asm/unaligned.h>
+#include <linux/ktime.h>
+#include <net/xfrm.h>
+
+#include "../nfp_net_ctrl.h"
+#include "../nfp_net.h"
+#include "crypto.h"
+
+#define NFP_NET_IPSEC_MAX_SA_CNT  (16 * 1024) /* Firmware support a maximum of 16K sa offload */
+#define OFFLOAD_HANDLE_ERROR      0xffffffff
+
+/* IPSEC_CFG_MSSG_ADD_SA */
+struct nfp_ipsec_cfg_add_sa {
+	u32 ciph_key[8];		  /* Cipher Key */
+	union {
+		u32 auth_key[16];	  /* Authentication Key */
+		struct nfp_ipsec_aesgcm { /* AES-GCM-ESP fields */
+			u32 salt;	  /* Initialized with sa */
+			u32 iv[2];	  /* Firmware use only */
+			u32 cntr;
+			u32 zeros[4];	  /* Init to 0 with sa */
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
+		uint32_t dir :1;	  /* Sa direction */
+		uint32_t ena_arw:1;	  /* Anti-Replay Window */
+		uint32_t ext_seq:1;	  /* 64-bit Sequence Num */
+		uint32_t ext_arw:1;	  /* 64b Anti-Replay Window */
+		uint32_t spare2 :9;	  /* Must be set to 0 */
+		uint32_t encap_dsbl:1;	  /* Encap/decap disable */
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
+struct nfp_net_ipsec_sa_data {
+	struct nfp_ipsec_cfg_add_sa nfp_sa;
+	struct xfrm_state *x;
+	int invalidated;
+};
+
+struct nfp_net_ipsec_data {
+	struct nfp_net_ipsec_sa_data sa_entries[NFP_NET_IPSEC_MAX_SA_CNT];
+	unsigned int sa_free_stack[NFP_NET_IPSEC_MAX_SA_CNT];
+	unsigned int sa_free_cnt;
+	struct mutex lock;	/* Protects nfp_net_ipsec_data struct */
+};
+
+static int nfp_net_xfrm_add_state(struct xfrm_state *x)
+{
+	return -EOPNOTSUPP;
+}
+
+static void nfp_net_xfrm_del_state(struct xfrm_state *x)
+{
+}
+
+static void nfp_net_xfrm_free_state(struct xfrm_state *x)
+{
+}
+
+static bool nfp_net_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
+{
+	return false;
+}
+
+static const struct xfrmdev_ops nfp_net_ipsec_xfrmdev_ops = {
+	.xdo_dev_state_add = nfp_net_xfrm_add_state,
+	.xdo_dev_state_delete = nfp_net_xfrm_del_state,
+	.xdo_dev_state_free = nfp_net_xfrm_free_state,
+	.xdo_dev_offload_ok = nfp_net_ipsec_offload_ok,
+};
+
+int nfp_net_ipsec_init(struct nfp_net *nn)
+{
+	if (nn->cap_w1 & NFP_NET_CFG_CTRL_IPSEC) {
+		struct nfp_net_ipsec_data *ipd;
+		int i;
+
+		nn->dp.netdev->xfrmdev_ops = &nfp_net_ipsec_xfrmdev_ops;
+
+		ipd = kzalloc(sizeof(*ipd), GFP_KERNEL);
+		if (!ipd)
+			return -ENOMEM;
+
+		for (i = 0; i < NFP_NET_IPSEC_MAX_SA_CNT; i++)
+			ipd->sa_free_stack[i] = NFP_NET_IPSEC_MAX_SA_CNT - i - 1;
+
+		ipd->sa_free_cnt = NFP_NET_IPSEC_MAX_SA_CNT;
+		mutex_init(&ipd->lock);
+		nn->ipsec_data = ipd;
+	}
+
+	return 0;
+}
+
+void nfp_net_ipsec_clean(struct nfp_net *nn)
+{
+	if (!nn->ipsec_data)
+		return;
+
+	mutex_destroy(&nn->ipsec_data->lock);
+	kfree(nn->ipsec_data);
+	nn->ipsec_data = NULL;
+}
+
+bool nfp_net_ipsec_tx_prep(struct nfp_net_dp *dp, struct sk_buff *skb,
+			   struct nfp_ipsec_offload *offload_info)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	struct xfrm_state *x;
+
+	if (!xo)
+		return false;
+
+	x = xfrm_input_state(skb);
+	if (!x)
+		return false;
+
+	if (x->xso.offload_handle == OFFLOAD_HANDLE_ERROR) {
+		nn_dp_warn(dp, "Invalid xfrm offload handle\n");
+		return false;
+	}
+
+	offload_info->seq_hi = xo->seq.hi;
+	offload_info->seq_low = xo->seq.low;
+	offload_info->handle = x->xso.offload_handle;
+
+	return true;
+}
+
+int nfp_net_ipsec_rx(struct nfp_meta_parsed *meta, struct sk_buff *skb)
+{
+	struct nfp_net_ipsec_sa_data *sa_data;
+	struct net_device *netdev = skb->dev;
+	struct nfp_net_ipsec_data *ipd;
+	struct xfrm_offload *xo;
+	struct nfp_net_dp *dp;
+	struct xfrm_state *x;
+	struct sec_path *sp;
+	struct nfp_net *nn;
+	int saidx;
+
+	nn = netdev_priv(netdev);
+	ipd = nn->ipsec_data;
+	dp = &nn->dp;
+
+	if (meta->ipsec_saidx == 0)
+		return 0; /* No offload took place */
+
+	saidx = meta->ipsec_saidx - 1;
+	if (saidx > NFP_NET_IPSEC_MAX_SA_CNT || saidx < 0) {
+		nn_dp_warn(dp, "Invalid SAIDX from NIC %d\n", saidx);
+		return -EINVAL;
+	}
+
+	sa_data = &ipd->sa_entries[saidx];
+	if (!sa_data->x) {
+		nn_dp_warn(dp, "Unused SAIDX from NIC %d\n", saidx);
+		return -EINVAL;
+	}
+
+	x = sa_data->x;
+	xfrm_state_hold(x);
+	sp = secpath_set(skb);
+	if (unlikely(!sp)) {
+		nn_dp_warn(dp, "Failed to alloc secpath for RX offload\n");
+		return -ENOMEM;
+	}
+
+	sp->xvec[sp->len++] = x;
+	sp->olen++;
+	xo = xfrm_offload(skb);
+	xo->flags = CRYPTO_DONE;
+	xo->status = CRYPTO_SUCCESS;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 448c1c1afaee..db53e0392923 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -167,14 +167,18 @@ nfp_nfd3_tx_csum(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 	u64_stats_update_end(&r_vec->tx_sync);
 }
 
-static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb, u64 tls_handle)
+static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb,
+				 u64 tls_handle, bool *ipsec)
 {
 	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+	struct nfp_ipsec_offload offload_info;
 	unsigned char *data;
 	bool vlan_insert;
 	u32 meta_id = 0;
 	int md_bytes;
 
+	*ipsec = nfp_net_ipsec_tx_prep(dp, skb, &offload_info);
+
 	if (unlikely(md_dst || tls_handle)) {
 		if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX))
 			md_dst = NULL;
@@ -182,13 +186,14 @@ static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb, u64
 
 	vlan_insert = skb_vlan_tag_present(skb) && (dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN_V2);
 
-	if (!(md_dst || tls_handle || vlan_insert))
+	if (!(md_dst || tls_handle || vlan_insert || *ipsec))
 		return 0;
 
 	md_bytes = sizeof(meta_id) +
 		   !!md_dst * NFP_NET_META_PORTID_SIZE +
 		   !!tls_handle * NFP_NET_META_CONN_HANDLE_SIZE +
-		   vlan_insert * NFP_NET_META_VLAN_SIZE;
+		   vlan_insert * NFP_NET_META_VLAN_SIZE +
+		   *ipsec * NFP_NET_META_IPSEC_FIELD_SIZE; /* Ipsec has 12-bytes metadata */
 
 	if (unlikely(skb_cow_head(skb, md_bytes)))
 		return -ENOMEM;
@@ -218,6 +223,19 @@ static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb, u64
 		meta_id <<= NFP_NET_META_FIELD_SIZE;
 		meta_id |= NFP_NET_META_VLAN;
 	}
+	if (*ipsec) {
+		/* The ipsec has three consecutive 4-bit ipsec Metadate types
+		 * so ipsec has three 4-bytes of Metadata
+		 */
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.seq_hi, data);
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.seq_low, data);
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.handle - 1, data);
+		meta_id <<= NFP_NET_META_IPSEC_FIELD_SIZE;
+		meta_id |= NFP_NET_META_IPSEC << 8 | NFP_NET_META_IPSEC << 4 | NFP_NET_META_IPSEC;
+	}
 
 	data -= sizeof(meta_id);
 	put_unaligned_be32(meta_id, data);
@@ -246,6 +264,7 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 	dma_addr_t dma_addr;
 	unsigned int fsize;
 	u64 tls_handle = 0;
+	bool ipsec = false;
 	u16 qidx;
 
 	dp = &nn->dp;
@@ -273,7 +292,7 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_OK;
 	}
 
-	md_bytes = nfp_nfd3_prep_tx_meta(dp, skb, tls_handle);
+	md_bytes = nfp_nfd3_prep_tx_meta(dp, skb, tls_handle, &ipsec);
 	if (unlikely(md_bytes < 0))
 		goto err_flush;
 
@@ -312,6 +331,8 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 		txd->vlan = cpu_to_le16(skb_vlan_tag_get(skb));
 	}
 
+	if (ipsec)
+		nfp_nfd3_ipsec_tx(txd, skb);
 	/* Gather DMA */
 	if (nr_frags > 0) {
 		__le64 second_half;
@@ -764,6 +785,12 @@ nfp_nfd3_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 				return false;
 			data += sizeof(struct nfp_net_tls_resync_req);
 			break;
+#ifdef CONFIG_NFP_NET_IPSEC
+		case NFP_NET_META_IPSEC:
+			meta->ipsec_saidx = get_unaligned_be32(data) + 1;
+			data += 4;
+			break;
+#endif
 		default:
 			return true;
 		}
@@ -876,12 +903,11 @@ static int nfp_nfd3_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
 	struct nfp_net_tx_ring *tx_ring;
 	struct bpf_prog *xdp_prog;
+	int idx, pkts_polled = 0;
 	bool xdp_tx_cmpl = false;
 	unsigned int true_bufsz;
 	struct sk_buff *skb;
-	int pkts_polled = 0;
 	struct xdp_buff xdp;
-	int idx;
 
 	xdp_prog = READ_ONCE(dp->xdp_prog);
 	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
@@ -1081,6 +1107,11 @@ static int nfp_nfd3_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			continue;
 		}
 
+		if (unlikely(nfp_net_ipsec_rx(&meta, skb))) {
+			nfp_nfd3_rx_drop(dp, r_vec, rx_ring, NULL, skb);
+			continue;
+		}
+
 		if (meta_len_xdp)
 			skb_metadata_set(skb, meta_len_xdp);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
new file mode 100644
index 000000000000..f0d74d6b49d0
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2018 Netronome Systems, Inc */
+/* Copyright (C) 2021 Corigine, Inc */
+
+#include <net/xfrm.h>
+
+#include "../nfp_net.h"
+#include "nfd3.h"
+
+void nfp_nfd3_ipsec_tx(struct nfp_nfd3_tx_desc *txd, struct sk_buff *skb)
+{
+	struct xfrm_state *x;
+
+	x = xfrm_input_state(skb);
+	if (x->xso.dev && (x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM)) {
+		txd->flags |= NFD3_DESC_TX_CSUM | NFD3_DESC_TX_IP4_CSUM |
+			      NFD3_DESC_TX_TCP_CSUM | NFD3_DESC_TX_UDP_CSUM;
+	}
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h b/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
index 7a0df9e6c3c4..9c1c10dcbaee 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
@@ -103,4 +103,12 @@ void nfp_nfd3_rx_ring_fill_freelist(struct nfp_net_dp *dp,
 void nfp_nfd3_xsk_tx_free(struct nfp_nfd3_tx_buf *txbuf);
 int nfp_nfd3_xsk_poll(struct napi_struct *napi, int budget);
 
+#ifndef CONFIG_NFP_NET_IPSEC
+static inline void nfp_nfd3_ipsec_tx(struct nfp_nfd3_tx_desc *txd, struct sk_buff *skb)
+{
+}
+#else
+void nfp_nfd3_ipsec_tx(struct nfp_nfd3_tx_desc *txd, struct sk_buff *skb);
+#endif
+
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 0c3e7e2f856d..768539f12214 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -263,6 +263,10 @@ struct nfp_meta_parsed {
 		u8 tpid;
 		u16 tci;
 	} vlan;
+
+#ifdef CONFIG_NFP_NET_IPSEC
+	u32 ipsec_saidx;
+#endif
 };
 
 struct nfp_net_rx_hash {
@@ -584,6 +588,7 @@ struct nfp_net_dp {
  * @qcp_cfg:            Pointer to QCP queue used for configuration notification
  * @tx_bar:             Pointer to mapped TX queues
  * @rx_bar:             Pointer to mapped FL/RX queues
+ * @ipsec_data:         Ipsec Sa data
  * @tlv_caps:		Parsed TLV capabilities
  * @ktls_tx_conn_cnt:	Number of offloaded kTLS TX connections
  * @ktls_rx_conn_cnt:	Number of offloaded kTLS RX connections
@@ -672,6 +677,10 @@ struct nfp_net {
 	u8 __iomem *tx_bar;
 	u8 __iomem *rx_bar;
 
+#ifdef CONFIG_NFP_NET_IPSEC
+	struct nfp_net_ipsec_data *ipsec_data;
+#endif
+
 	struct nfp_net_tlv_caps tlv_caps;
 
 	unsigned int ktls_tx_conn_cnt;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 7e4424d626a6..040c0c2aad80 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2565,9 +2565,13 @@ int nfp_net_init(struct nfp_net *nn)
 		if (err)
 			return err;
 
-		err = nfp_net_tls_init(nn);
+		err = nfp_net_ipsec_init(nn);
 		if (err)
 			goto err_clean_mbox;
+
+		err = nfp_net_tls_init(nn);
+		if (err)
+			goto err_clean_ipsec;
 	}
 
 	nfp_net_vecs_init(nn);
@@ -2576,6 +2580,9 @@ int nfp_net_init(struct nfp_net *nn)
 		return 0;
 	return register_netdev(nn->dp.netdev);
 
+err_clean_ipsec:
+	nfp_net_ipsec_clean(nn);
+
 err_clean_mbox:
 	nfp_ccm_mbox_clean(nn);
 	return err;
@@ -2591,6 +2598,7 @@ void nfp_net_clean(struct nfp_net *nn)
 		return;
 
 	unregister_netdev(nn->dp.netdev);
+	nfp_net_ipsec_clean(nn);
 	nfp_ccm_mbox_clean(nn);
 	nfp_net_reconfig_wait_posted(nn);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 80346c1c266b..fff05496152d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -45,6 +45,7 @@
 #define NFP_NET_META_CSUM		6 /* checksum complete type */
 #define NFP_NET_META_CONN_HANDLE	7
 #define NFP_NET_META_RESYNC_INFO	8 /* RX resync info request */
+#define NFP_NET_META_IPSEC		9 /* IPSec SA index for tx and rx */
 
 #define NFP_META_PORT_ID_CTRL		~0U
 
@@ -52,6 +53,8 @@
 #define NFP_NET_META_VLAN_SIZE			4
 #define NFP_NET_META_PORTID_SIZE		4
 #define NFP_NET_META_CONN_HANDLE_SIZE		8
+#define NFP_NET_META_IPSEC_SIZE			4
+#define NFP_NET_META_IPSEC_FIELD_SIZE		12
 /* Hash type pre-pended when a RSS hash was computed */
 #define NFP_NET_RSS_NONE		0
 #define NFP_NET_RSS_IPV4		1
@@ -260,6 +263,7 @@
  */
 #define NFP_NET_CFG_CTRL_WORD1		0x0098
 #define   NFP_NET_CFG_CTRL_PKT_TYPE	  (0x1 << 0) /* Pkttype offload */
+#define   NFP_NET_CFG_CTRL_IPSEC	  (0x1 << 1) /* IPSec offload */
 
 #define NFP_NET_CFG_CAP_WORD1		0x00a4
 
-- 
2.30.2

