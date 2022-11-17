Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB5A62DC86
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239973AbiKQNVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239931AbiKQNV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:21:28 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2093.outbound.protection.outlook.com [40.107.101.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7386B2BB33
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 05:21:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zr/zBCmaosYK2BEZxxEnD4KSwzTaekMG2LvukXrUWor5L2KAEln9t2sJKPzuejbMv8ZL5cB4PEJ1K2jsNyYfJ2Bx0ghH8eTbHps3y+HqR3fKNrF96DV04/Xw+dgMNKvb02O7OEbVNTogDPQZNh19nDcOs2Wo04/T8bRBGZBEM45soJX4NrlKONxivGAUXiz7xtLhffcGCGm5BSV0c916bgiV5d1FeV2a+QBf/RuPi45h1U6JpDDtvQF5nsIrJoMyiZcOkjxaDS/xHlXToJgm58lSZ0rFnKZJV8SroaxtzP/c+sgNctySbNxcBYfPMa8pAtfq/6/ZDVLD2zN+RE16sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=arPXmcURno3XJ09pYtgHNRdesoCLW7GFf6c0DXJgaiM=;
 b=mY72JFhqd9aTLse7iVto9J58CrDA3+dZGhNddrpc5MhPKkh8wZTx7dNq1lh0QzgdipIkhmU49bUnpCAUP+1GJ0AP0qaTwoHbrfdt8UlzRhIh8JV8m4PhXAwSgC2DBFdPAiVJaAEZ0UeZppSmAe59vaaEg/IwFzmb/zTaoHHZGPiA811a5ijKEwq4i0UQN6y4OZku9OJspfVIcIA8WQ7GKsOTAsomqGtllHVT0Oi7mKyczazspt+SqGzLlx/VyZWS4e02nM96ixf6/IFUcT/xL6lywwip0pymnQDlusuFW64/glq8BHWyffzGzMQXBO2LoDEWybNg8+Bg0Qm12Z0zew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arPXmcURno3XJ09pYtgHNRdesoCLW7GFf6c0DXJgaiM=;
 b=oKFKA2VC3dT3fvVR19t2OrgZpTTXwOGL4R3Rq3AMyG86hB9jClD7jv9fmWeuQFG+yIbSgu+OlrGG87qa3WKlDna93rN93kIA8QE5lqR6Tf3WdnuSJXzD5jxYpOzUmSiq4YFXiPBov+oVJa0+r9l0bcYZ3oc2J5kHXCf3eRta0Lk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5839.namprd13.prod.outlook.com (2603:10b6:303:1a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Thu, 17 Nov
 2022 13:21:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 13:21:24 +0000
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
Subject: [PATCH net-next v4 2/3] nfp: add framework to support ipsec offloading
Date:   Thu, 17 Nov 2022 14:21:01 +0100
Message-Id: <20221117132102.678708-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221117132102.678708-1-simon.horman@corigine.com>
References: <20221117132102.678708-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0101.eurprd03.prod.outlook.com
 (2603:10a6:208:69::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5839:EE_
X-MS-Office365-Filtering-Correlation-Id: b0461dce-dff5-4da6-24e9-08dac89e9fd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWx31iY8yVYUuMXrd5sv7mduPYpUMnw2A8+DmbJu4uQxCPCbs7rMe5cthmTz7//aI6Qm4SQ/70nYzyFGBCcXfjAxBHQNRfQ/yH+5v/Hm7/4G3JFbjIgxoE7dd9Ur0Jre0HgpyuPZxn49GCl9L2MwoCQr5rPYrW5tN/4YU4rBlXEG1NcmXbNadGlDrLQhVt03xTMB2a3UBwnqN6xyQ61Vn7tQcp3D6VFhzwarNfMRgnDiKiJW1lWopzK/JfGkF3XednPbZIHFTQI/3gG+eOcdQDJmCAei9/V3Xl0ZVhuVEMjKdeDQDNCFJv9vUluLNWFgo+08WsRpbo7vuxO4oDWuS0xnec+CApDVzjHYT04u5cT8hTbI/vdJcyiQKi/446CKuXpBdjlxsZvS5lzkR4vsbGbaIs/KU71mmI49gwAlSuFJkccyddhf52KRJEdSmo2PfVsYXMGVjqd1P7MqEw5+w0IV1Jma7WeClRAiADd4sYtEpZUX/o4sm0BGD6vuqfRbWKTUYOaxzIkrtToDND9yw9KUlGknvir3yKs6UPyQb21c/+UvfH1Aqzh6cOC4EGUni1Z08mIO2S6AA5nYnl67hAOFwTpmpjQUOpF7eNhxxIZGD5I0Z7BZO6Q4h1bhfyB6W7nTOcOL0Ka+tyE7GspzYwlPaZT7Grp5bK/zCbcbOG0d2a5mpvRU4dSV6kyFdnMnYofEuyjymMvOANaqjB8Yd1F8lO3pyMbjzWIPo8EHN9t+tB5+8laVA/tOJFEEB3R7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(366004)(39840400004)(451199015)(86362001)(54906003)(66946007)(110136005)(30864003)(5660300002)(41300700001)(316002)(8936002)(2906002)(38100700002)(6486002)(478600001)(83380400001)(6506007)(52116002)(44832011)(107886003)(6666004)(1076003)(186003)(36756003)(2616005)(4326008)(66556008)(66476007)(8676002)(6512007)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rYPKPINGLONdaYU7BtpqyJ70PerV6+WZpquOlelMijPxx2P+5MsmqaX+l60f?=
 =?us-ascii?Q?DOaID0n+fi5MAwz/ewT542L782rWyrlVdvlUaxkzCCsGh+NellNblxG5OTN7?=
 =?us-ascii?Q?wr5RSR2Rs+vL0F67aG/0t/Xf6rRho1yrcmd5t52kbc9r/cLl/a1obV/kZRcC?=
 =?us-ascii?Q?hHg6lx59aTljeqsiXHon75VLD7lWZAi5fG5IB6iO5VDA5VRAVXL8kY86Atyk?=
 =?us-ascii?Q?209sYVtsi6AxTpa/RCpf9qWmyDEgGoTS2xlAKkd1GiOuS2WubraxW3hk8Igc?=
 =?us-ascii?Q?iKvLgTaOjCrbEGRMbEN2Y3VhbfPSiK31zB39/ka39rm0nnAcAUdWUgXtD4nS?=
 =?us-ascii?Q?sgqtccT2AB9TKevRYGP/1jAifjYy7RzmmderyVuWJDQssgzTlRoXE8cUQKBF?=
 =?us-ascii?Q?QE6UYnHrE5WqW/Oe41B6qn/7G4CF/a/T3RIDltU1dB+ZNqbqDaXG5XFw8IIs?=
 =?us-ascii?Q?DsJv3GfmDDVCwXy9urRQQr78vCz52qvZwbfYm8LxB0Iff0BkA8W/ora3oA5E?=
 =?us-ascii?Q?Noq8K12ZZpS/KlT08iEXR7cE8pc/LFTPk1d82uqgV6J0QzQxiTKyeByhfnIa?=
 =?us-ascii?Q?6BOZSy1IcuslCZGZ9JEb5F/lamgGghFcmu3JYd9TppTyJD8tYVI2I191XWC0?=
 =?us-ascii?Q?EIPsZcdHHQtaSRVVSAG3em4PT3LYWuW+6JSkQIg5460su0ZndtBPnA76FTX0?=
 =?us-ascii?Q?GU6S9CLU+5NodHhRl6HEO7iV7CoZyl0Yrv4iBhpfpFYYCZmhO73/p+EonYW+?=
 =?us-ascii?Q?YV7LCTJfjWrDUb0HCkMrrB5FmpJBuJv5fO4xVZF0czX8xJrGzFeq/RDY8sYF?=
 =?us-ascii?Q?AzvD7vgxgi0RwxR66rnRAtV+zjujyvoFJ1HTTcRT3UX0wIXkkgViDHN4oZCS?=
 =?us-ascii?Q?6zx/eQy2a6jhjdkhvKWx8k3ms3AX++ftOZZe5aUGwMvECD6Cle7x/cp7Myaa?=
 =?us-ascii?Q?3mZhRsas5vJQ6A6Lsy5eafnD1LBO8g1mM1p6J7YTBBBy3svcQsyPwTNtMIwT?=
 =?us-ascii?Q?8fvkCDdzm+8sbSntWfWYt3VoTFqDB5TGtgInrYkz1P2UXRgFmkUQebhrvN9t?=
 =?us-ascii?Q?9D6y5NwuMpXL7KTA1hYb7sb+s/Kp3Wbbuz9sugBBYLh4AjLpNQqrOQYyNsvb?=
 =?us-ascii?Q?5Nbj166Ojsi37UhfALz9vlxwUTV1b4Rs9Gjc0xw2/yzxBgWyk/wcahnGSKFz?=
 =?us-ascii?Q?lANnPjxhzQHpTiFs0u5p89+9T3aUkgVOYygR7mZOEnbZIVO4B+zo22Cy8sjC?=
 =?us-ascii?Q?MU0jyYUthKSaqcEd3goKwl1ptT8aLUcKPbnfyagI35rreLyHVnz5xXaJc0i0?=
 =?us-ascii?Q?D3YbNIE9ZiC1D1KFR/1Wwz67gTkss4iqNCmOG1xyrhVTAFh1IoU4NtVyXUXL?=
 =?us-ascii?Q?impTGGeZ5OACJA1CI4+8eUnwampeNOP+/T0MjlY3W18qGG0FTH60DI02Uud2?=
 =?us-ascii?Q?iITpr4s+gkjAkZnMGoXe0BBO/ZQxNJCYRaJO0x0ky5eXbCVFZs4LED5apfec?=
 =?us-ascii?Q?/RYc8xd6Ih/jIpVsAqy/kEzYMw7ilT83O31YeC8fmTwiO+e/b9rDbqbhGreG?=
 =?us-ascii?Q?t+rFH/9WyLi8re5Wg76nvEwfSjiG0LkkOGgS81mG5+FhIzNKEGF71fSp7BNp?=
 =?us-ascii?Q?tm5Fr/H/tMCr6yKruJXKDLPDYvadYw6JLmFEH6w6zypmfsJ7Xn57EQmHL1B3?=
 =?us-ascii?Q?E+5tvQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0461dce-dff5-4da6-24e9-08dac89e9fd7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 13:21:23.9661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QvUhPqV5+V/7gHxKIdw1v/KOKqqoMZtq2bsIOuV/DwzfnDmGWjsk34zwvxqo+77IA2u1Kv3gzrsWX/zYALLXE92252aj3erADC289dSpqsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5839
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
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/netronome/Kconfig        |  11 ++
 drivers/net/ethernet/netronome/nfp/Makefile   |   2 +
 .../ethernet/netronome/nfp/crypto/crypto.h    |  23 ++++
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 107 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  58 ++++++++--
 .../net/ethernet/netronome/nfp/nfd3/ipsec.c   |  18 +++
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |   8 ++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   9 ++
 .../ethernet/netronome/nfp/nfp_net_common.c   |   3 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +
 10 files changed, 233 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c

diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
index 8844d1ac053a..e785c00b5845 100644
--- a/drivers/net/ethernet/netronome/Kconfig
+++ b/drivers/net/ethernet/netronome/Kconfig
@@ -54,6 +54,17 @@ config NFP_APP_ABM_NIC
 	  functionality.
 	  Code will be built into the nfp.ko driver.
 
+config NFP_NET_IPSEC
+	bool "NFP IPsec crypto offload support"
+	depends on NFP
+	depends on XFRM_OFFLOAD
+	default y
+	help
+	  Enable driver support IPsec crypto offload on NFP NIC.
+	  Say Y, if you are planning to make use of IPsec crypto
+	  offload. NOTE that IPsec crypto offload on NFP NIC
+	  requires specific FW to work.
+
 config NFP_DEBUG
 	bool "Debug support for Netronome(R) NFP4000/NFP6000 NIC drivers"
 	depends on NFP
diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index 9c0861d03634..8a250214e289 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -80,4 +80,6 @@ nfp-objs += \
 	    abm/main.o
 endif
 
+nfp-$(CONFIG_NFP_NET_IPSEC) += crypto/ipsec.o nfd3/ipsec.o
+
 nfp-$(CONFIG_NFP_DEBUG) += nfp_net_debugfs.o
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
index bffe58bb2f27..1df73d658938 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
+++ b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
@@ -39,4 +39,27 @@ nfp_net_tls_rx_resync_req(struct net_device *netdev,
 }
 #endif
 
+/* IPsec related structures and functions */
+struct nfp_ipsec_offload {
+	u32 seq_hi;
+	u32 seq_low;
+	u32 handle;
+};
+
+#ifndef CONFIG_NFP_NET_IPSEC
+static inline void nfp_net_ipsec_init(struct nfp_net *nn)
+{
+}
+
+static inline void nfp_net_ipsec_clean(struct nfp_net *nn)
+{
+}
+#else
+void nfp_net_ipsec_init(struct nfp_net *nn);
+void nfp_net_ipsec_clean(struct nfp_net *nn);
+bool nfp_net_ipsec_tx_prep(struct nfp_net_dp *dp, struct sk_buff *skb,
+			   struct nfp_ipsec_offload *offload_info);
+int nfp_net_ipsec_rx(struct nfp_meta_parsed *meta, struct sk_buff *skb);
+#endif
+
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
new file mode 100644
index 000000000000..154ef841e847
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -0,0 +1,107 @@
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
+#define NFP_NET_IPSEC_MAX_SA_CNT  (16 * 1024) /* Firmware support a maximum of 16K SA offload */
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
+static bool nfp_net_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
+{
+	return false;
+}
+
+static const struct xfrmdev_ops nfp_net_ipsec_xfrmdev_ops = {
+	.xdo_dev_state_add = nfp_net_xfrm_add_state,
+	.xdo_dev_state_delete = nfp_net_xfrm_del_state,
+	.xdo_dev_offload_ok = nfp_net_ipsec_offload_ok,
+};
+
+void nfp_net_ipsec_init(struct nfp_net *nn)
+{
+	if (!(nn->cap_w1 & NFP_NET_CFG_CTRL_IPSEC))
+		return;
+
+	xa_init_flags(&nn->xa_ipsec, XA_FLAGS_ALLOC);
+	nn->dp.netdev->xfrmdev_ops = &nfp_net_ipsec_xfrmdev_ops;
+}
+
+void nfp_net_ipsec_clean(struct nfp_net *nn)
+{
+	if (!(nn->cap_w1 & NFP_NET_CFG_CTRL_IPSEC))
+		return;
+
+	WARN_ON(!xa_empty(&nn->xa_ipsec));
+	xa_destroy(&nn->xa_ipsec);
+}
+
+bool nfp_net_ipsec_tx_prep(struct nfp_net_dp *dp, struct sk_buff *skb,
+			   struct nfp_ipsec_offload *offload_info)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	struct xfrm_state *x;
+
+	x = xfrm_input_state(skb);
+	if (!x)
+		return false;
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
+	struct net_device *netdev = skb->dev;
+	struct xfrm_offload *xo;
+	struct xfrm_state *x;
+	struct sec_path *sp;
+	struct nfp_net *nn;
+	u32 saidx;
+
+	nn = netdev_priv(netdev);
+
+	saidx = meta->ipsec_saidx - 1;
+	if (saidx >= NFP_NET_IPSEC_MAX_SA_CNT)
+		return -EINVAL;
+
+	sp = secpath_set(skb);
+	if (unlikely(!sp))
+		return -ENOMEM;
+
+	xa_lock(&nn->xa_ipsec);
+	x = xa_load(&nn->xa_ipsec, saidx);
+	xa_unlock(&nn->xa_ipsec);
+	if (!x)
+		return -EINVAL;
+
+	xfrm_state_hold(x);
+	sp->xvec[sp->len++] = x;
+	sp->olen++;
+	xo = xfrm_offload(skb);
+	xo->flags = CRYPTO_DONE;
+	xo->status = CRYPTO_SUCCESS;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 448c1c1afaee..861082c5dbff 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -4,6 +4,7 @@
 #include <linux/bpf_trace.h>
 #include <linux/netdevice.h>
 #include <linux/bitfield.h>
+#include <net/xfrm.h>
 
 #include "../nfp_app.h"
 #include "../nfp_net.h"
@@ -167,28 +168,34 @@ nfp_nfd3_tx_csum(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
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
 
-	if (unlikely(md_dst || tls_handle)) {
-		if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX))
-			md_dst = NULL;
-	}
+#ifdef CONFIG_NFP_NET_IPSEC
+	if (xfrm_offload(skb))
+		*ipsec = nfp_net_ipsec_tx_prep(dp, skb, &offload_info);
+#endif
+
+	if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX))
+		md_dst = NULL;
 
 	vlan_insert = skb_vlan_tag_present(skb) && (dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN_V2);
 
-	if (!(md_dst || tls_handle || vlan_insert))
+	if (!(md_dst || tls_handle || vlan_insert || *ipsec))
 		return 0;
 
 	md_bytes = sizeof(meta_id) +
 		   !!md_dst * NFP_NET_META_PORTID_SIZE +
 		   !!tls_handle * NFP_NET_META_CONN_HANDLE_SIZE +
-		   vlan_insert * NFP_NET_META_VLAN_SIZE;
+		   vlan_insert * NFP_NET_META_VLAN_SIZE +
+		   *ipsec * NFP_NET_META_IPSEC_FIELD_SIZE; /* IPsec has 12 bytes of metadata */
 
 	if (unlikely(skb_cow_head(skb, md_bytes)))
 		return -ENOMEM;
@@ -218,6 +225,19 @@ static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb, u64
 		meta_id <<= NFP_NET_META_FIELD_SIZE;
 		meta_id |= NFP_NET_META_VLAN;
 	}
+	if (*ipsec) {
+		/* IPsec has three consecutive 4-bit IPsec metadata types,
+		 * so in total IPsec has three 4 bytes of metadata.
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
@@ -246,6 +266,7 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 	dma_addr_t dma_addr;
 	unsigned int fsize;
 	u64 tls_handle = 0;
+	bool ipsec = false;
 	u16 qidx;
 
 	dp = &nn->dp;
@@ -273,7 +294,7 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_OK;
 	}
 
-	md_bytes = nfp_nfd3_prep_tx_meta(dp, skb, tls_handle);
+	md_bytes = nfp_nfd3_prep_tx_meta(dp, skb, tls_handle, &ipsec);
 	if (unlikely(md_bytes < 0))
 		goto err_flush;
 
@@ -312,6 +333,8 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 		txd->vlan = cpu_to_le16(skb_vlan_tag_get(skb));
 	}
 
+	if (ipsec)
+		nfp_nfd3_ipsec_tx(txd, skb);
 	/* Gather DMA */
 	if (nr_frags > 0) {
 		__le64 second_half;
@@ -764,6 +787,15 @@ nfp_nfd3_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 				return false;
 			data += sizeof(struct nfp_net_tls_resync_req);
 			break;
+#ifdef CONFIG_NFP_NET_IPSEC
+		case NFP_NET_META_IPSEC:
+			/* Note: IPsec packet will have zero saidx, so need add 1
+			 * to indicate packet is IPsec packet within driver.
+			 */
+			meta->ipsec_saidx = get_unaligned_be32(data) + 1;
+			data += 4;
+			break;
+#endif
 		default:
 			return true;
 		}
@@ -876,12 +908,11 @@ static int nfp_nfd3_rx(struct nfp_net_rx_ring *rx_ring, int budget)
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
@@ -1081,6 +1112,13 @@ static int nfp_nfd3_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			continue;
 		}
 
+#ifdef CONFIG_NFP_NET_IPSEC
+		if (meta.ipsec_saidx != 0 && unlikely(nfp_net_ipsec_rx(&meta, skb))) {
+			nfp_nfd3_rx_drop(dp, r_vec, rx_ring, NULL, skb);
+			continue;
+		}
+#endif
+
 		if (meta_len_xdp)
 			skb_metadata_set(skb, meta_len_xdp);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
new file mode 100644
index 000000000000..e90f8c975903
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
@@ -0,0 +1,18 @@
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
+	struct xfrm_state *x = xfrm_input_state(skb);
+
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
index 0c3e7e2f856d..6c83e47d8b3d 100644
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
+ * @xa_ipsec:           IPsec xarray SA data
  * @tlv_caps:		Parsed TLV capabilities
  * @ktls_tx_conn_cnt:	Number of offloaded kTLS TX connections
  * @ktls_rx_conn_cnt:	Number of offloaded kTLS RX connections
@@ -672,6 +677,10 @@ struct nfp_net {
 	u8 __iomem *tx_bar;
 	u8 __iomem *rx_bar;
 
+#ifdef CONFIG_NFP_NET_IPSEC
+	struct xarray xa_ipsec;
+#endif
+
 	struct nfp_net_tlv_caps tlv_caps;
 
 	unsigned int ktls_tx_conn_cnt;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 3b3cad449f7a..593df8f8ac8f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2564,6 +2564,8 @@ int nfp_net_init(struct nfp_net *nn)
 		err = nfp_net_tls_init(nn);
 		if (err)
 			goto err_clean_mbox;
+
+		nfp_net_ipsec_init(nn);
 	}
 
 	nfp_net_vecs_init(nn);
@@ -2587,6 +2589,7 @@ void nfp_net_clean(struct nfp_net *nn)
 		return;
 
 	unregister_netdev(nn->dp.netdev);
+	nfp_net_ipsec_clean(nn);
 	nfp_ccm_mbox_clean(nn);
 	nfp_net_reconfig_wait_posted(nn);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index bc94d2cf1042..8f75efd9e463 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -48,6 +48,7 @@
 #define NFP_NET_META_CSUM		6 /* checksum complete type */
 #define NFP_NET_META_CONN_HANDLE	7
 #define NFP_NET_META_RESYNC_INFO	8 /* RX resync info request */
+#define NFP_NET_META_IPSEC		9 /* IPsec SA index for tx and rx */
 
 #define NFP_META_PORT_ID_CTRL		~0U
 
@@ -55,6 +56,8 @@
 #define NFP_NET_META_VLAN_SIZE			4
 #define NFP_NET_META_PORTID_SIZE		4
 #define NFP_NET_META_CONN_HANDLE_SIZE		8
+#define NFP_NET_META_IPSEC_SIZE			4
+#define NFP_NET_META_IPSEC_FIELD_SIZE		12
 /* Hash type pre-pended when a RSS hash was computed */
 #define NFP_NET_RSS_NONE		0
 #define NFP_NET_RSS_IPV4		1
@@ -263,6 +266,7 @@
  */
 #define NFP_NET_CFG_CTRL_WORD1		0x0098
 #define   NFP_NET_CFG_CTRL_PKT_TYPE	  (0x1 << 0) /* Pkttype offload */
+#define   NFP_NET_CFG_CTRL_IPSEC	  (0x1 << 1) /* IPsec offload */
 
 #define NFP_NET_CFG_CAP_WORD1		0x00a4
 
-- 
2.30.2

