Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B129A6671CF
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjALMN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjALMNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 07:13:09 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2101.outbound.protection.outlook.com [40.107.102.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE01C44378
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:11:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWpRzvcODpbrgoAotVv3DKygy4s8xWQIcFU/D7jLZWsMBWlHCWOaFu25WJtKJ/yckV535MotSYIwOIV6TfT9BZQVWGd1xgY+IdvOurJ5pVkc0ZKLF2UUcXEnPcaDWK8lEka5DAXmFgRdKdl2/IK7ELtjhERGQRyrBVeEzcv61zsYtAKeAzS45ja+BTS20RasMK4SszK0QQafQKpXACizJ6BkkYWlCuqR4bEsf+uE1Ls7m84bGzj5Dku97Ig9gH+122AA4cgkh+zO0KQ9xMqgmH80//6l3BaGl3N0UpAg8RPoUq95QsDdFzCl8lyZsH7g46PTByzVtdi2G2bGl9u4hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MDRt8JoBhglpHGgFDP13aD+P3uz5PerQ1fvR9t3VTCo=;
 b=UQ/B6537Vjek/Hnkrrs6TxrQ3ol00cEnbaSQIwTakYuulEopHm4qsQ8jyjWuliaVfKl0DGEATxjFtKjEqk2m2Q1unq3cUdJp0+3+CsTsbJA8u51hBbpHvDWKQHMroY2wonZsPktdBm7gxj8/+SbUjqPXwk0PVG04jh9JyM11lkahBD6o0RXrFNkllxfV9zhNnHgIfUVtKsVzv6lVbDFEMR3LkszsB83u07u/gWCCmT5HP73fSz4APQPSaK0nd+cVcGqBTiUDdCktNnmGUk0JNnyIVmmsi/ttpAXo7paPsGcqPoktBkkMTBu2pnwcK7Sj3Y05Vuae2OmRZ5HEQg83oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDRt8JoBhglpHGgFDP13aD+P3uz5PerQ1fvR9t3VTCo=;
 b=heyyKVnurIenA6niiHqQ4y2EgXy+NiZX0DWJkB/CJdUzco1Su+f2rD9HfLV1Ja+RzpcwZNf5FEygLxLddsmyw0kBHS1fErj8dkUSKlExQWbmK/P091Z8HfZqLvu4Z+NoSqZQG5b7bXilkUGuOa9sQGJ0cD3qUqzZldXX3kRPp4I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5125.namprd13.prod.outlook.com (2603:10b6:8:30::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Thu, 12 Jan
 2023 12:11:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 12:11:48 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Bin Chen <bin.chen@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 net-next] nfp: add DCB IEEE support
Date:   Thu, 12 Jan 2023 13:11:02 +0100
Message-Id: <20230112121102.469739-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P195CA0029.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5125:EE_
X-MS-Office365-Filtering-Correlation-Id: 61c5a40a-bdc8-4a70-7de7-08daf4962e0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UMwpwI/Wp+j4mpURefeTgt/flTtjXzmvMHCPP+b/pnu1CK2yKtNZCSYkOa73MT+K7hyUokhHqSMYR/OTJrIlrZGnq25TUbp6x3HdaxdLcB+XlCzIxMuXQlhk+dvCCks/HvB0+8cZiXl8tTf/VH9uF7AIek4sJyaCecj/4sgcGGUWjPiqPoNZwxDJCkmnD/y/xOPc3eQZ2/VNWT03oUtFiVRBLxwIwQwy2ieLRrp2STsLW+df0WrB1DttkhMIwFnnl3xJ2m4yd/tcs7yvhjbV/fgujYZ0rnEPH84TP2rXg2G9pZ/YBV2pheVspkpSh3z3WC9FnBmPMnvPo9ESKTCsRGDUOt1+9FeAb8zim7Q0hcHPxH6TfeMl+X+MQveONSRefIsbbGEryO+sg7GCTnQbsBn9XhRjqmgcwgmpWzdQKI4Sl0gn/niENd4hQvzVVRF/ydth48+rsXHPv0W/d6xcODw810wgJ+czZArG4IysctJDqou1uHBvgcXgUhIYa51IXZ+W4MsS/JS3tTDmN6twwcpStBvjzhs0vW+IhOWxxelbS0702aGJwbfrb6SQL4wvE8Vpktk3ftj+XFBRuNKSGw7uqhxCa8QS8ikfkCqT35R2197798tV5XT+MzvJN7aydMOvOzLFTJXxDUrmBxK281dgHi6JykH5RICAyoDAOJWjL0rlvw4qcNgyfMV394qK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39840400004)(366004)(136003)(451199015)(8936002)(5660300002)(83380400001)(41300700001)(38100700002)(86362001)(36756003)(2906002)(44832011)(30864003)(478600001)(186003)(52116002)(6512007)(6506007)(6486002)(8676002)(4326008)(66476007)(66946007)(316002)(66556008)(1076003)(110136005)(2616005)(54906003)(107886003)(6666004)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SZWqtXgSNSN7Uki5ZiUWg1wxnIr2MRNXBgIqNy2M8vCfoAgaG343qvgIZWXq?=
 =?us-ascii?Q?vHF1Vk2eA0rz6MV4u6Td3ofz4I/KTin48DA/cfqd+iIDECFeLf7xkD4CiGR4?=
 =?us-ascii?Q?IsuAFohS+yE0mW4l23OMuoFBm/yNXsovXxsywnc4oP1j5g3CrJ0nd2xj+LEq?=
 =?us-ascii?Q?0G+xBjhhnCRsEUaSgQGZaZTPyoU2ZoNc4Zk/JNVR2YHqaZiESPVVrGLIG614?=
 =?us-ascii?Q?sAZxnrNzZabvjbKTPIbTuc5y/6yq4FfTCwtD4lZBkhRcDYPie515Oe+rxmHZ?=
 =?us-ascii?Q?39gEWa6iplXvUwiAwG2E74B263kdczRmnlb7igxTVncPBUIO9hN4luWphHQ2?=
 =?us-ascii?Q?Xg1UeZtBn/44bFMAUxw4CTCRjRIIJj5Ttun+CpB+oS0mhoyYv1wka2KgXXkR?=
 =?us-ascii?Q?Y+8p6LCtr8HXTxIfdbKE/QZaWb/IM27gdXctWYYOQl8BG3cM+TC2Pq5E3KvS?=
 =?us-ascii?Q?6hjwd8TeUvfM6qAvg0JvvPIOasulMUiu0Gvu6wl555H1g29ZFeDgHslxjbvZ?=
 =?us-ascii?Q?cqsDwygeJj27aLEAQRGDubVVbqCUV7DDAIjN5/2K23/VGmM/Cg7ZLV/npUi1?=
 =?us-ascii?Q?TVjHp0Il7qjexp88u4EXy4VBkWjW/A/SkIHPIVZ1RE5OyBItAkyyH6iOoyzq?=
 =?us-ascii?Q?BuonuZzU9RE54Mm/Jkb2qFPjLuFIxU9NtpfS+EHVCmnHLIp6DyoYa37qaGKh?=
 =?us-ascii?Q?Aja+BDtBiBX59qYKtj3SnRz4Y/F5B/GFe+NHnobYpjbC9XClUq0TMApbErrB?=
 =?us-ascii?Q?nxFo79UkIoCpS7DBcsv75Y96IrkIhU2uHmF+tb/odyDQfCn+6k00MIfJIP2j?=
 =?us-ascii?Q?0yA/FeLzvONxr73etmbUi7R7XhLQps0UqMGjlKIrgK3Ap5oONJJXOhlpaw32?=
 =?us-ascii?Q?bObZESkJHK7qNNQaWw/nQnWs2AIZ7L2Rl8bki0joPGkG1Q+2PDe0jZelvtfM?=
 =?us-ascii?Q?WG84phwQOUOqtc2u6wEBzs8SlE9aXWwKwf0EcxIbfRgyw35pTcTe0oMhPwuE?=
 =?us-ascii?Q?iCkTlywYHxkMNJmLUqGDjiTh3bTle7NsLGwWgO9aMojUDuczoCgvWVUQ6t45?=
 =?us-ascii?Q?EM+J6wEVIauaZIRFhfsmwqTSYSmqxEJ8h+zWhDXG6zv4u9RT9aUtSvLukJ5g?=
 =?us-ascii?Q?IxkDZ9JyjWHkOYc+SPIssA73Tr+a+DPXwKo2LFs6Jbh6QzsXYtlT5A1p8vZ/?=
 =?us-ascii?Q?lSemN7bdeCaToLFAyAWxWrHu6QUr5vFM9ds1WV2/0MVBzGA53RhAWwM63u7Z?=
 =?us-ascii?Q?QMdSMFOAkBQk9hSyHxYYPKqPbPVIoa11EjpXQq7XDi0vH2TdC7+y9VarxdFL?=
 =?us-ascii?Q?XGoePex+sEUuqARXo2YNCYPo8Zv0S5t3w/atS4t/cFUC6RaRR/om0OQsHbJe?=
 =?us-ascii?Q?K9BMCiF+A0NCrcF2ZMq5cl4pYTzW5McyHyUfD+oibAWZY34ntoAixLLgBiqU?=
 =?us-ascii?Q?ni65Ic2YkRG+F9zZKrc+xFwsEY/6QumZlwCRzepUt8ZoClHWQY6t3A8XbTbN?=
 =?us-ascii?Q?0iBxRZJp35s8aZPP2hXDS/1ilch4AUmqYtcWa4RUKpC4cFRPYME0WDbIBEmW?=
 =?us-ascii?Q?SSNEzpM0zFLHejfVR5VrEsOT38BT2VXTe/e7UUxJAA0TxqNvFr47T7kAVWOO?=
 =?us-ascii?Q?qYFmRyF1zv6lvctty+P6fbAvbM01rTGnxQWp6G8BAvJ59y26TVhUS2QJDO7A?=
 =?us-ascii?Q?t5u0CQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c5a40a-bdc8-4a70-7de7-08daf4962e0f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 12:11:48.4353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOHpnfHlJALt+byzdrDt6f/kS9nHVh/D3RadPfnrRaB8AXXXccnj8cQkadlTzsvaRrtZwPhr3q5S91+6hTH7Z8ftFSyRQpHmYGpFT1OqbtM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5125
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bin Chen <bin.chen@corigine.com>

Add basic DCB IEEE support. This includes support for ETS, max-rate,
and DSCP to user priority mapping.

DCB may be configured using iproute2's dcb command.
Example usage:
  dcb ets set dev $dev tc-tsa 0:ets 1:ets 2:ets 3:ets 4:ets 5:ets \
    6:ets 7:ets tc-bw 0:0 1:80 2:0 3:0 4:0 5:0 6:20 7:0
  dcb maxrate set dev $dev tc-maxrate 1:1000bit

And DCB configuration can be shown using:
  dcb ets show dev $dev
  dcb maxrate show dev $dev

Signed-off-by: Bin Chen <bin.chen@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
Changes since v1
* Squashed series into single patch
* Sanitised copyright
* Provided example configuration commands in commit message
* Corrected return values of nfp_nic_dcbnl_ieee_{getmaxrate,delcapp}()
* Drop unrelated include change in bpf/main.c
* Updated patch description

Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/Makefile   |   2 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   1 +
 drivers/net/ethernet/netronome/nfp/nic/dcb.c  | 571 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nic/main.c |  39 +-
 drivers/net/ethernet/netronome/nfp/nic/main.h |  46 ++
 5 files changed, 657 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nic/dcb.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nic/main.h

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index 8a250214e289..c90d35f5ebca 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -83,3 +83,5 @@ endif
 nfp-$(CONFIG_NFP_NET_IPSEC) += crypto/ipsec.o nfd3/ipsec.o
 
 nfp-$(CONFIG_NFP_DEBUG) += nfp_net_debugfs.o
+
+nfp-$(CONFIG_DCB) += nic/dcb.o
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 51124309ae1f..a4096050c9bd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -413,6 +413,7 @@
 #define NFP_NET_CFG_MBOX_CMD_IPSEC 3
 #define NFP_NET_CFG_MBOX_CMD_PCI_DSCP_PRIOMAP_SET	5
 #define NFP_NET_CFG_MBOX_CMD_TLV_CMSG			6
+#define NFP_NET_CFG_MBOX_CMD_DCB_UPDATE			7
 
 #define NFP_NET_CFG_MBOX_CMD_MULTICAST_ADD		8
 #define NFP_NET_CFG_MBOX_CMD_MULTICAST_DEL		9
diff --git a/drivers/net/ethernet/netronome/nfp/nic/dcb.c b/drivers/net/ethernet/netronome/nfp/nic/dcb.c
new file mode 100644
index 000000000000..bb498ac6bd7d
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nic/dcb.c
@@ -0,0 +1,571 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2023 Corigine, Inc. */
+
+#include <linux/device.h>
+#include <linux/netdevice.h>
+#include <net/dcbnl.h>
+
+#include "../nfp_app.h"
+#include "../nfp_net.h"
+#include "../nfp_main.h"
+#include "../nfpcore/nfp_cpp.h"
+#include "../nfpcore/nfp_nffw.h"
+#include "../nfp_net_sriov.h"
+
+#include "main.h"
+
+#define NFP_DCB_TRUST_PCP	1
+#define NFP_DCB_TRUST_DSCP	2
+#define NFP_DCB_TRUST_INVALID	0xff
+
+#define NFP_DCB_TSA_VENDOR	1
+#define NFP_DCB_TSA_STRICT	2
+#define NFP_DCB_TSA_ETS		3
+
+#define NFP_DCB_GBL_ENABLE	BIT(0)
+#define NFP_DCB_QOS_ENABLE	BIT(1)
+#define NFP_DCB_DISABLE		0
+#define NFP_DCB_ALL_QOS_ENABLE	(NFP_DCB_GBL_ENABLE | NFP_DCB_QOS_ENABLE)
+
+#define NFP_DCB_UPDATE_MSK_SZ	4
+#define NFP_DCB_TC_RATE_MAX	0xffff
+
+#define NFP_DCB_DATA_OFF_DSCP2IDX	0
+#define NFP_DCB_DATA_OFF_PCP2IDX	64
+#define NFP_DCB_DATA_OFF_TSA		80
+#define NFP_DCB_DATA_OFF_IDX_BW_PCT	88
+#define NFP_DCB_DATA_OFF_RATE		96
+#define NFP_DCB_DATA_OFF_CAP		112
+#define NFP_DCB_DATA_OFF_ENABLE		116
+#define NFP_DCB_DATA_OFF_TRUST		120
+
+#define NFP_DCB_MSG_MSK_ENABLE	BIT(31)
+#define NFP_DCB_MSG_MSK_TRUST	BIT(30)
+#define NFP_DCB_MSG_MSK_TSA	BIT(29)
+#define NFP_DCB_MSG_MSK_DSCP	BIT(28)
+#define NFP_DCB_MSG_MSK_PCP	BIT(27)
+#define NFP_DCB_MSG_MSK_RATE	BIT(26)
+#define NFP_DCB_MSG_MSK_PCT	BIT(25)
+
+static struct nfp_dcb *get_dcb_priv(struct nfp_net *nn)
+{
+	struct nfp_dcb *dcb = &((struct nfp_app_nic_private *)nn->app_priv)->dcb;
+
+	return dcb;
+}
+
+static u8 nfp_tsa_ieee2nfp(u8 tsa)
+{
+	switch (tsa) {
+	case IEEE_8021QAZ_TSA_STRICT:
+		return NFP_DCB_TSA_STRICT;
+	case IEEE_8021QAZ_TSA_ETS:
+		return NFP_DCB_TSA_ETS;
+	default:
+		return NFP_DCB_TSA_VENDOR;
+	}
+}
+
+static int nfp_nic_dcbnl_ieee_getets(struct net_device *dev,
+				     struct ieee_ets *ets)
+{
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_dcb *dcb;
+
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		ets->prio_tc[i] = dcb->prio2tc[i];
+		ets->tc_tx_bw[i] = dcb->tc_tx_pct[i];
+		ets->tc_tsa[i] = dcb->tc_tsa[i];
+	}
+
+	return 0;
+}
+
+static bool nfp_refresh_tc2idx(struct nfp_net *nn)
+{
+	u8 tc2idx[IEEE_8021QAZ_MAX_TCS];
+	bool change = false;
+	struct nfp_dcb *dcb;
+	int maxstrict = 0;
+
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		tc2idx[i] = i;
+		if (dcb->tc_tsa[i] == IEEE_8021QAZ_TSA_STRICT)
+			maxstrict = i;
+	}
+
+	if (maxstrict > 0 && dcb->tc_tsa[0] != IEEE_8021QAZ_TSA_STRICT) {
+		tc2idx[0] = maxstrict;
+		tc2idx[maxstrict] = 0;
+	}
+
+	for (unsigned int j = 0; j < IEEE_8021QAZ_MAX_TCS; j++) {
+		if (dcb->tc2idx[j] != tc2idx[j]) {
+			change = true;
+			dcb->tc2idx[j] = tc2idx[j];
+		}
+	}
+
+	return change;
+}
+
+static int nfp_fill_maxrate(struct nfp_net *nn, u64 *max_rate_array)
+{
+	struct nfp_app *app  = nn->app;
+	struct nfp_dcb *dcb;
+	u32 ratembps;
+
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		/* Convert bandwidth from kbps to mbps. */
+		ratembps = max_rate_array[i] / 1024;
+
+		/* Reject input values >= NFP_DCB_TC_RATE_MAX */
+		if (ratembps >= NFP_DCB_TC_RATE_MAX) {
+			nfp_warn(app->cpp, "ratembps(%d) must less than %d.",
+				 ratembps, NFP_DCB_TC_RATE_MAX);
+			return -EINVAL;
+		}
+		/* Input value 0 mapped to NFP_DCB_TC_RATE_MAX for firmware. */
+		if (ratembps == 0)
+			ratembps = NFP_DCB_TC_RATE_MAX;
+
+		writew((u16)ratembps, dcb->dcbcfg_tbl +
+		       dcb->cfg_offset + NFP_DCB_DATA_OFF_RATE + dcb->tc2idx[i] * 2);
+		/* for rate value from user space, need to sync to dcb structure */
+		if (dcb->tc_maxrate != max_rate_array)
+			dcb->tc_maxrate[i] = max_rate_array[i];
+	}
+
+	return 0;
+}
+
+static int update_dscp_maxrate(struct net_device *dev, u32 *update)
+{
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_dcb *dcb;
+	int err;
+
+	dcb = get_dcb_priv(nn);
+
+	err = nfp_fill_maxrate(nn, dcb->tc_maxrate);
+	if (err)
+		return err;
+
+	*update |= NFP_DCB_MSG_MSK_RATE;
+
+	/* We only refresh dscp in dscp trust mode. */
+	if (dcb->dscp_cnt > 0) {
+		for (unsigned int i = 0; i < NFP_NET_MAX_DSCP; i++) {
+			writeb(dcb->tc2idx[dcb->prio2tc[dcb->dscp2prio[i]]],
+			       dcb->dcbcfg_tbl + dcb->cfg_offset +
+			       NFP_DCB_DATA_OFF_DSCP2IDX + i);
+		}
+		*update |= NFP_DCB_MSG_MSK_DSCP;
+	}
+
+	return 0;
+}
+
+static void nfp_nic_set_trust(struct nfp_net *nn, u32 *update)
+{
+	struct nfp_dcb *dcb;
+	u8 trust;
+
+	dcb = get_dcb_priv(nn);
+
+	if (dcb->trust_status != NFP_DCB_TRUST_INVALID)
+		return;
+
+	trust = dcb->dscp_cnt > 0 ? NFP_DCB_TRUST_DSCP : NFP_DCB_TRUST_PCP;
+	writeb(trust, dcb->dcbcfg_tbl + dcb->cfg_offset +
+	       NFP_DCB_DATA_OFF_TRUST);
+
+	dcb->trust_status = trust;
+	*update |= NFP_DCB_MSG_MSK_TRUST;
+}
+
+static void nfp_nic_set_enable(struct nfp_net *nn, u32 enable, u32 *update)
+{
+	struct nfp_dcb *dcb;
+	u32 value = 0;
+
+	dcb = get_dcb_priv(nn);
+
+	value = readl(dcb->dcbcfg_tbl + dcb->cfg_offset +
+		      NFP_DCB_DATA_OFF_ENABLE);
+	if (value != enable) {
+		writel(enable, dcb->dcbcfg_tbl + dcb->cfg_offset +
+		       NFP_DCB_DATA_OFF_ENABLE);
+		*update |= NFP_DCB_MSG_MSK_ENABLE;
+	}
+}
+
+static int dcb_ets_check(struct net_device *dev, struct ieee_ets *ets)
+{
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_app *app = nn->app;
+	bool ets_exists = false;
+	int sum = 0;
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		/* For ets mode, check bw percentage sum. */
+		if (ets->tc_tsa[i] == IEEE_8021QAZ_TSA_ETS) {
+			ets_exists = true;
+			sum += ets->tc_tx_bw[i];
+		} else if (ets->tc_tx_bw[i]) {
+			nfp_warn(app->cpp, "ETS BW for strict/vendor TC must be 0.");
+			return -EINVAL;
+		}
+	}
+
+	if (ets_exists && sum != 100) {
+		nfp_warn(app->cpp, "Failed to validate ETS BW: sum must be 100.");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void nfp_nic_fill_ets(struct nfp_net *nn)
+{
+	struct nfp_dcb *dcb;
+
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		writeb(dcb->tc2idx[dcb->prio2tc[i]],
+		       dcb->dcbcfg_tbl + dcb->cfg_offset + NFP_DCB_DATA_OFF_PCP2IDX + i);
+		writeb(dcb->tc_tx_pct[i], dcb->dcbcfg_tbl +
+		       dcb->cfg_offset + NFP_DCB_DATA_OFF_IDX_BW_PCT + dcb->tc2idx[i]);
+		writeb(nfp_tsa_ieee2nfp(dcb->tc_tsa[i]), dcb->dcbcfg_tbl +
+		       dcb->cfg_offset + NFP_DCB_DATA_OFF_TSA + dcb->tc2idx[i]);
+	}
+}
+
+static void nfp_nic_ets_init(struct nfp_net *nn, u32 *update)
+{
+	struct nfp_dcb *dcb = get_dcb_priv(nn);
+
+	if (dcb->ets_init)
+		return;
+
+	nfp_nic_fill_ets(nn);
+	dcb->ets_init = true;
+	*update |= NFP_DCB_MSG_MSK_TSA | NFP_DCB_MSG_MSK_PCT | NFP_DCB_MSG_MSK_PCP;
+}
+
+static int nfp_nic_dcbnl_ieee_setets(struct net_device *dev,
+				     struct ieee_ets *ets)
+{
+	const u32 cmd = NFP_NET_CFG_MBOX_CMD_DCB_UPDATE;
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_app *app = nn->app;
+	struct nfp_dcb *dcb;
+	u32 update = 0;
+	bool change;
+	int err;
+
+	err = dcb_ets_check(dev, ets);
+	if (err)
+		return err;
+
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		dcb->prio2tc[i] = ets->prio_tc[i];
+		dcb->tc_tx_pct[i] = ets->tc_tx_bw[i];
+		dcb->tc_tsa[i] = ets->tc_tsa[i];
+	}
+
+	change = nfp_refresh_tc2idx(nn);
+	nfp_nic_fill_ets(nn);
+	dcb->ets_init = true;
+	if (change || !dcb->rate_init) {
+		err = update_dscp_maxrate(dev, &update);
+		if (err) {
+			nfp_warn(app->cpp,
+				 "nfp dcbnl ieee setets ERROR:%d.",
+				 err);
+			return err;
+		}
+
+		dcb->rate_init = true;
+	}
+	nfp_nic_set_enable(nn, NFP_DCB_ALL_QOS_ENABLE, &update);
+	nfp_nic_set_trust(nn, &update);
+	err = nfp_net_mbox_lock(nn, NFP_DCB_UPDATE_MSK_SZ);
+	if (err)
+		return err;
+
+	nn_writel(nn, nn->tlv_caps.mbox_off + NFP_NET_CFG_MBOX_SIMPLE_VAL,
+		  update | NFP_DCB_MSG_MSK_TSA | NFP_DCB_MSG_MSK_PCT |
+		  NFP_DCB_MSG_MSK_PCP);
+
+	return nfp_net_mbox_reconfig_and_unlock(nn, cmd);
+}
+
+static int nfp_nic_dcbnl_ieee_getmaxrate(struct net_device *dev,
+					 struct ieee_maxrate *maxrate)
+{
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_dcb *dcb;
+
+	dcb = get_dcb_priv(nn);
+
+	for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
+		maxrate->tc_maxrate[i] = dcb->tc_maxrate[i];
+
+	return 0;
+}
+
+static int nfp_nic_dcbnl_ieee_setmaxrate(struct net_device *dev,
+					 struct ieee_maxrate *maxrate)
+{
+	const u32 cmd = NFP_NET_CFG_MBOX_CMD_DCB_UPDATE;
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_app *app = nn->app;
+	struct nfp_dcb *dcb;
+	u32 update = 0;
+	int err;
+
+	err = nfp_fill_maxrate(nn, maxrate->tc_maxrate);
+	if (err) {
+		nfp_warn(app->cpp,
+			 "nfp dcbnl ieee setmaxrate ERROR:%d.",
+			 err);
+		return err;
+	}
+
+	dcb = get_dcb_priv(nn);
+
+	dcb->rate_init = true;
+	nfp_nic_set_enable(nn, NFP_DCB_ALL_QOS_ENABLE, &update);
+	nfp_nic_set_trust(nn, &update);
+	nfp_nic_ets_init(nn, &update);
+
+	err = nfp_net_mbox_lock(nn, NFP_DCB_UPDATE_MSK_SZ);
+	if (err)
+		return err;
+
+	nn_writel(nn, nn->tlv_caps.mbox_off + NFP_NET_CFG_MBOX_SIMPLE_VAL,
+		  update | NFP_DCB_MSG_MSK_RATE);
+
+	return nfp_net_mbox_reconfig_and_unlock(nn, cmd);
+}
+
+static int nfp_nic_set_trust_status(struct nfp_net *nn, u8 status)
+{
+	const u32 cmd = NFP_NET_CFG_MBOX_CMD_DCB_UPDATE;
+	struct nfp_dcb *dcb;
+	u32 update = 0;
+	int err;
+
+	dcb = get_dcb_priv(nn);
+	if (!dcb->rate_init) {
+		err = nfp_fill_maxrate(nn, dcb->tc_maxrate);
+		if (err)
+			return err;
+
+		update |= NFP_DCB_MSG_MSK_RATE;
+		dcb->rate_init = true;
+	}
+
+	err = nfp_net_mbox_lock(nn, NFP_DCB_UPDATE_MSK_SZ);
+	if (err)
+		return err;
+
+	nfp_nic_ets_init(nn, &update);
+	writeb(status, dcb->dcbcfg_tbl + dcb->cfg_offset +
+	       NFP_DCB_DATA_OFF_TRUST);
+	nfp_nic_set_enable(nn, NFP_DCB_ALL_QOS_ENABLE, &update);
+	nn_writel(nn, nn->tlv_caps.mbox_off + NFP_NET_CFG_MBOX_SIMPLE_VAL,
+		  update | NFP_DCB_MSG_MSK_TRUST);
+
+	err = nfp_net_mbox_reconfig_and_unlock(nn, cmd);
+	if (err)
+		return err;
+
+	dcb->trust_status = status;
+
+	return 0;
+}
+
+static int nfp_nic_set_dscp2prio(struct nfp_net *nn, u8 dscp, u8 prio)
+{
+	const u32 cmd = NFP_NET_CFG_MBOX_CMD_DCB_UPDATE;
+	struct nfp_dcb *dcb;
+	u8 idx, tc;
+	int err;
+
+	err = nfp_net_mbox_lock(nn, NFP_DCB_UPDATE_MSK_SZ);
+	if (err)
+		return err;
+
+	dcb = get_dcb_priv(nn);
+
+	tc = dcb->prio2tc[prio];
+	idx = dcb->tc2idx[tc];
+
+	writeb(idx, dcb->dcbcfg_tbl + dcb->cfg_offset +
+	       NFP_DCB_DATA_OFF_DSCP2IDX + dscp);
+
+	nn_writel(nn, nn->tlv_caps.mbox_off +
+		  NFP_NET_CFG_MBOX_SIMPLE_VAL, NFP_DCB_MSG_MSK_DSCP);
+
+	err = nfp_net_mbox_reconfig_and_unlock(nn, cmd);
+	if (err)
+		return err;
+
+	dcb->dscp2prio[dscp] = prio;
+
+	return 0;
+}
+
+static int nfp_nic_dcbnl_ieee_setapp(struct net_device *dev,
+				     struct dcb_app *app)
+{
+	struct nfp_net *nn = netdev_priv(dev);
+	struct dcb_app old_app;
+	struct nfp_dcb *dcb;
+	bool is_new;
+	int err;
+
+	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP)
+		return -EINVAL;
+
+	dcb = get_dcb_priv(nn);
+
+	/* Save the old entry info */
+	old_app.selector = IEEE_8021QAZ_APP_SEL_DSCP;
+	old_app.protocol = app->protocol;
+	old_app.priority = dcb->dscp2prio[app->protocol];
+
+	/* Check trust status */
+	if (!dcb->dscp_cnt) {
+		err = nfp_nic_set_trust_status(nn, NFP_DCB_TRUST_DSCP);
+		if (err)
+			return err;
+	}
+
+	/* Check if the new mapping is same as old or in init stage */
+	if (app->priority != old_app.priority || app->priority == 0) {
+		err = nfp_nic_set_dscp2prio(nn, app->protocol, app->priority);
+		if (err)
+			return err;
+	}
+
+	/* Delete the old entry if exists */
+	is_new = !!dcb_ieee_delapp(dev, &old_app);
+
+	/* Add new entry and update counter */
+	err = dcb_ieee_setapp(dev, app);
+	if (err)
+		return err;
+
+	if (is_new)
+		dcb->dscp_cnt++;
+
+	return 0;
+}
+
+static int nfp_nic_dcbnl_ieee_delapp(struct net_device *dev,
+				     struct dcb_app *app)
+{
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nfp_dcb *dcb;
+	int err;
+
+	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP)
+		return -EINVAL;
+
+	dcb = get_dcb_priv(nn);
+
+	/* Check if the dcb_app param match fw */
+	if (app->priority != dcb->dscp2prio[app->protocol])
+		return -ENOENT;
+
+	/* Set fw dscp mapping to 0 */
+	err = nfp_nic_set_dscp2prio(nn, app->protocol, 0);
+	if (err)
+		return err;
+
+	/* Delete app from dcb list */
+	err = dcb_ieee_delapp(dev, app);
+	if (err)
+		return err;
+
+	/* Decrease dscp counter */
+	dcb->dscp_cnt--;
+
+	/* If no dscp mapping is configured, trust pcp */
+	if (dcb->dscp_cnt == 0)
+		return nfp_nic_set_trust_status(nn, NFP_DCB_TRUST_PCP);
+
+	return 0;
+}
+
+static const struct dcbnl_rtnl_ops nfp_nic_dcbnl_ops = {
+	/* ieee 802.1Qaz std */
+	.ieee_getets	= nfp_nic_dcbnl_ieee_getets,
+	.ieee_setets	= nfp_nic_dcbnl_ieee_setets,
+	.ieee_getmaxrate = nfp_nic_dcbnl_ieee_getmaxrate,
+	.ieee_setmaxrate = nfp_nic_dcbnl_ieee_setmaxrate,
+	.ieee_setapp	= nfp_nic_dcbnl_ieee_setapp,
+	.ieee_delapp	= nfp_nic_dcbnl_ieee_delapp,
+};
+
+int nfp_nic_dcb_init(struct nfp_net *nn)
+{
+	struct nfp_app *app = nn->app;
+	struct nfp_dcb *dcb;
+	int err;
+
+	dcb = get_dcb_priv(nn);
+	dcb->cfg_offset = NFP_DCB_CFG_STRIDE * nn->id;
+	dcb->dcbcfg_tbl = nfp_pf_map_rtsym(app->pf, "net.dcbcfg_tbl",
+					   "_abi_dcb_cfg",
+					   dcb->cfg_offset, &dcb->dcbcfg_tbl_area);
+	if (IS_ERR(dcb->dcbcfg_tbl)) {
+		if (PTR_ERR(dcb->dcbcfg_tbl) != -ENOENT) {
+			err = PTR_ERR(dcb->dcbcfg_tbl);
+			dcb->dcbcfg_tbl = NULL;
+			nfp_err(app->cpp,
+				"Failed to map dcbcfg_tbl area, min_size %u.\n",
+				dcb->cfg_offset);
+			return err;
+		}
+		dcb->dcbcfg_tbl = NULL;
+	}
+
+	if (dcb->dcbcfg_tbl) {
+		for (unsigned int i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+			dcb->prio2tc[i] = i;
+			dcb->tc2idx[i] = i;
+			dcb->tc_tx_pct[i] = 0;
+			dcb->tc_maxrate[i] = 0;
+			dcb->tc_tsa[i] = IEEE_8021QAZ_TSA_VENDOR;
+		}
+		dcb->trust_status = NFP_DCB_TRUST_INVALID;
+		dcb->rate_init = false;
+		dcb->ets_init = false;
+
+		nn->dp.netdev->dcbnl_ops = &nfp_nic_dcbnl_ops;
+	}
+
+	return 0;
+}
+
+void nfp_nic_dcb_clean(struct nfp_net *nn)
+{
+	struct nfp_dcb *dcb;
+
+	dcb = get_dcb_priv(nn);
+	if (dcb->dcbcfg_tbl_area)
+		nfp_cpp_area_release_free(dcb->dcbcfg_tbl_area);
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.c b/drivers/net/ethernet/netronome/nfp/nic/main.c
index aea8579206ee..f78c2447d45b 100644
--- a/drivers/net/ethernet/netronome/nfp/nic/main.c
+++ b/drivers/net/ethernet/netronome/nfp/nic/main.c
@@ -5,6 +5,8 @@
 #include "../nfpcore/nfp_nsp.h"
 #include "../nfp_app.h"
 #include "../nfp_main.h"
+#include "../nfp_net.h"
+#include "main.h"
 
 static int nfp_nic_init(struct nfp_app *app)
 {
@@ -28,13 +30,46 @@ static void nfp_nic_sriov_disable(struct nfp_app *app)
 {
 }
 
+static int nfp_nic_vnic_init(struct nfp_app *app, struct nfp_net *nn)
+{
+	nfp_nic_dcb_init(nn);
+
+	return 0;
+}
+
+static int nfp_nic_vnic_alloc(struct nfp_app *app, struct nfp_net *nn,
+			      unsigned int id)
+{
+	struct nfp_app_nic_private *app_pri = nn->app_priv;
+	int err;
+
+	err = nfp_app_nic_vnic_alloc(app, nn, id);
+	if (err)
+		return err;
+
+	if (sizeof(*app_pri)) {
+		nn->app_priv = kzalloc(sizeof(*app_pri), GFP_KERNEL);
+		if (!nn->app_priv)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void nfp_nic_vnic_free(struct nfp_app *app, struct nfp_net *nn)
+{
+	kfree(nn->app_priv);
+}
+
 const struct nfp_app_type app_nic = {
 	.id		= NFP_APP_CORE_NIC,
 	.name		= "nic",
 
 	.init		= nfp_nic_init,
-	.vnic_alloc	= nfp_app_nic_vnic_alloc,
-
+	.vnic_alloc	= nfp_nic_vnic_alloc,
+	.vnic_free	= nfp_nic_vnic_free,
 	.sriov_enable	= nfp_nic_sriov_enable,
 	.sriov_disable	= nfp_nic_sriov_disable,
+
+	.vnic_init      = nfp_nic_vnic_init,
 };
diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.h b/drivers/net/ethernet/netronome/nfp/nic/main.h
new file mode 100644
index 000000000000..7ba04451b8ba
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nic/main.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2023 Corigine, Inc. */
+
+#ifndef __NFP_NIC_H__
+#define __NFP_NIC_H__ 1
+
+#include <linux/netdevice.h>
+
+#ifdef CONFIG_DCB
+/* DCB feature definitions */
+#define NFP_NET_MAX_DSCP	4
+#define NFP_NET_MAX_TC		IEEE_8021QAZ_MAX_TCS
+#define NFP_NET_MAX_PRIO	8
+#define NFP_DCB_CFG_STRIDE	256
+
+struct nfp_dcb {
+	u8 dscp2prio[NFP_NET_MAX_DSCP];
+	u8 prio2tc[NFP_NET_MAX_PRIO];
+	u8 tc2idx[IEEE_8021QAZ_MAX_TCS];
+	u64 tc_maxrate[IEEE_8021QAZ_MAX_TCS];
+	u8 tc_tx_pct[IEEE_8021QAZ_MAX_TCS];
+	u8 tc_tsa[IEEE_8021QAZ_MAX_TCS];
+	u8 dscp_cnt;
+	u8 trust_status;
+	bool rate_init;
+	bool ets_init;
+
+	struct nfp_cpp_area *dcbcfg_tbl_area;
+	u8 __iomem *dcbcfg_tbl;
+	u32 cfg_offset;
+};
+
+int nfp_nic_dcb_init(struct nfp_net *nn);
+void nfp_nic_dcb_clean(struct nfp_net *nn);
+#else
+static inline int nfp_nic_dcb_init(struct nfp_net *nn) {return 0; }
+static inline void nfp_nic_dcb_clean(struct nfp_net *nn) {}
+#endif
+
+struct nfp_app_nic_private {
+#ifdef CONFIG_DCB
+	struct nfp_dcb dcb;
+#endif
+};
+
+#endif
-- 
2.30.2

