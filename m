Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D115394458
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbhE1Oos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:44:48 -0400
Received: from mail-dm6nam10on2097.outbound.protection.outlook.com ([40.107.93.97]:62452
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235271AbhE1Ook (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:44:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBAZtYOX9ekrVFPoZ1+ggwjk/bWUo/yBXK6OhI1pm+fLekFHvN64KrAV6wS2jGFlPElvLqQ6/uXLxLj5y4EI4fmGgbOXRMAESARbKOub2Yirop0rZRq/WGFXwwwxytlse+XjNd80eJXAVRnSddelKXBUqDq2zyBThfZXTTCjY6qJUSebecix4cnaHmix67ZTD9EJ6JR4JVyuEpnn7AExbFVOB7sJKCwU52tj/Z+abqX8TOjyjN1ympKE6boinD/QhwhKQ1YDZviwUHpPkEquCSxWyesVUwWCPhc3jgpJBws0O0Zg24Jds1nZZKP+0tdTfNOwO+cVt0DYJ+0fTm6dmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cd/T3tgvy/Mkz4LJjfaKbDo3ToX4TqVnxVAQ3oq2AE=;
 b=G7U+tj6IA4BqY5/y6+EKXKY8jhrTTgFTVa96llzdnj+8n1vBFwe137Wrw6OD/kTuWGJCstoWsXwJ1JX2e6wEEGH95hQgmYkmGi/3L99QMBgASKAfrMdoIMaV0iC12aS6E3nP7A9GXf6K1tpy5EKVi5F3ovOUVDTKpNUovMPnqPYkZ6NAqNToaXmtI49xE5RbpBFz+TUqTQs2qrXR9+scc6M/EJywSXaWNj20VySbb8NoCEg5ylKoHesVVxZCl8ooBm80OBbcS839TFCPxrnizd60PYksTIhlPO4qs6B0DB2q5dQVl4/195un573rd7jPfZRiu8gfGUZu/7mupe6THw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cd/T3tgvy/Mkz4LJjfaKbDo3ToX4TqVnxVAQ3oq2AE=;
 b=JZYMQGogHBklmsYuBzGAY1ASPNFoE2YR4TJKzm7++ZiC+SYExFUI76S8EVEYlBV0Uj/hJ+r+grfAMehFtkirhcXGhY8IT5PFpnIv3MUvMxvlN7aVJiZIZXwxoNqyeFdt8bppTanOcHYeCtHzcpSDLCaRqJVN0d5AgOuurvo6goU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5033.namprd13.prod.outlook.com (2603:10b6:510:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Fri, 28 May
 2021 14:43:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4173.020; Fri, 28 May 2021
 14:43:04 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 2/8] nfp: flower-ct: add pre and post ct checks
Date:   Fri, 28 May 2021 16:42:40 +0200
Message-Id: <20210528144246.11669-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210528144246.11669-1-simon.horman@corigine.com>
References: <20210528144246.11669-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM0PR01CA0164.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM0PR01CA0164.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 14:43:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54eb6f0a-f0af-464a-de87-08d921e6e634
X-MS-TrafficTypeDiagnostic: PH0PR13MB5033:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB50337AEF9E96397E92A78280E8229@PH0PR13MB5033.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: byq5SHiIuoWRKVDk3IEo1PDn0+frFBL0xH78B8jp2JkG4dYBHwmCfOI01pKp4fk51/B8kMfVdbf/bNs6JvI4Zrm1HUVdppnyxAkaFSmWgVOxeOwwbbDEBMcszQWrEEtRr1DT7gEmNqD9fk2EU6z2L5Pp6DE0d7MJP+jEjCvv5BlxEAlfYiuSHzytBRIV+tqlXF34YMrehIOCzVdaZBDHbWwG+Apl3KvLSchqt+3GgEDa3uaADlMGWB8RpfwrB71OnaVLdqzo1CLQrprSNfcFN8g0gpxRJYWrRBoBSC3BxF+MGqDfYwOq2whrm4Knrmpej3B5H7+Io8PVLwY7TPgZ0lhJTXQCJuLjOWHKoN2DlBd9gdnpUPjLU/1ZmphM3agQdSf56nJrsF0oJKj4ccKMtI53DpVnhqAjDImbeREJBOBZYIU7A7+h+0GqsGEtjUSo/4MYPWCfNn4+MKGQ7An0ptIQyZ0zcKP1ZtXwr1xLqXbQOfCSaSeF2zKraZb+s62yK5IuvG3Sc9cEIgFy2aQYRiSBm2noJ9WqBifjHIfVz2rEvRk2LWNMKDHQCJGNpyPvMh+4nDwdU/+1uTdFrJQI6jfvyAgDf8x41MzuvrTdo9A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39830400003)(16526019)(44832011)(186003)(5660300002)(6666004)(8936002)(6506007)(86362001)(36756003)(4326008)(107886003)(6512007)(8676002)(66476007)(83380400001)(66556008)(2616005)(316002)(54906003)(110136005)(52116002)(478600001)(6486002)(2906002)(66946007)(38100700002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AK0hFTODbX30gxtszMkaNC7HYsVoJsxr+3kcrB7+XvyAT/ZzLqPa7DbsmToO?=
 =?us-ascii?Q?d7iJXisdWdO4XEc5ZikHyJjOiWtWSoU69CYhPshKZsx4hpf2bup94AWxuBK6?=
 =?us-ascii?Q?OWdlTVQBvLx6hk/xNZEexqxfwDcieAcCgU0b0JPU8ssa3Q+NkovBSbXjsGFX?=
 =?us-ascii?Q?OfjzJvRmTIYGnlwZoy6Neo9lVesOG+Ay4l6kgI1l56zewHxIGaZ6jXm9XBCl?=
 =?us-ascii?Q?Rv6eXiZA7RYokOP9mAgpHNMFjwJGMr/0m2dG+uZ7Slypft5+bK4/4iRBV3KX?=
 =?us-ascii?Q?s1d4y2dlu1bP1W3P027wpOaufQXI9YMRfteIAIXaMYMazuTLuYJY0sR+a1g0?=
 =?us-ascii?Q?J0TxUXmtQRoJXyDtIBAJvByq++z2NSYNJV1QHnNGMV65GZLr5R5m7UlknAUt?=
 =?us-ascii?Q?3n9SycRBU7+2Z4IdAgT8EOZcpffqjVDePhzE8QsAHkyAVnxApSec9226qpzX?=
 =?us-ascii?Q?xPiXookDXvyZAtr3JpNMnhH5E5DvNYWll+h4sygT9jkYjgOmsTdTxne1q2uD?=
 =?us-ascii?Q?3NvDRdvBFjTSUCuBVDBec+0Ena8FcsKdoxskNUji1OG3CyJd/ZgTFDKQsaof?=
 =?us-ascii?Q?6p4LUUjBCo0zEd4b3LclEb/y6VY2pB72vneVfCGiSc0at+4upAEI3SCqu1vH?=
 =?us-ascii?Q?g+Er0KzgesSSYv7cMqB6gg2ks3t1MDuTGL2Knc0leGkqbXyHIlzlv4ZrUfr7?=
 =?us-ascii?Q?8Cy0d2Hm4Yw3tHSap4TLS21TD2+Q1VWsQ4/xv4QdnJJOIrnxvNi0VGvgpbFP?=
 =?us-ascii?Q?BypSGILVlSWzgyF7g8GVMhZcPopmQFhESphGvm4z4kCaJA4GFXV+pu1NyE2U?=
 =?us-ascii?Q?MzjiuS9es1jMQRYDnTyaIZd8sOjwGvY5AjDGlRJWRcj8aEBCvBXdQQqEl5Eb?=
 =?us-ascii?Q?BKxpmY2MCWPjDBQgARTnidPi+E3CewDyc6X3OpNB2jnar7l+xrlFui1VyDBQ?=
 =?us-ascii?Q?Nk5aT/v7kq54hsuBy5Un5IX2gruIY9BnMs+GlBmAThGjRN2Jo/AoN+9UN+2r?=
 =?us-ascii?Q?M/Y9b4SYxn6mqDZnD7YHPxeTnRtmf+Ye2yjIsYVpgHztiiuDRUdHbgYEpDLb?=
 =?us-ascii?Q?qLol8BWI7RrtwaZOIFLciDnM16HiVAp4aVvz5J8cyu3yiMH1S6h8aIiSnyYe?=
 =?us-ascii?Q?d/RcHCMmPkEjB7kQV+FSo1ze5nbYZnJcXQNOSFyd8Y4MTCt7EWb/SkZIQiyH?=
 =?us-ascii?Q?naN/w3FjgnbfujgKAMwlDusKr0MUNz5DN/NnGQa64ElstrpjwI6WEAA6Sd3n?=
 =?us-ascii?Q?IKGdHMQnYRtsYXIKse8uGLnPEGdgmIY5gexj6+sSIi+9f/E+nThVFen8JV2s?=
 =?us-ascii?Q?StdUjSuU6hcKPLl+jHTQR3vBWzd6S2cA1TQ94ALtNoHRqz7Pff0Fdtq2UweG?=
 =?us-ascii?Q?+H3m7Zf10T/s96X4abfhiRDavwGL?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54eb6f0a-f0af-464a-de87-08d921e6e634
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:43:03.9249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BnUcwLMtSSVfy6/a9bLmjPrXo60N/MPOMqBcMMFy87T/8pB1GJ1s+lEFrpyvfoqq7k2i0KZLrCQsN4BOHfhZ6kVwdKXBdUY6LnHG61stVcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5033
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add checks to see if a flow is a conntrack flow we can potentially
handle. Just stub out the handling the different conntrack flows.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/Makefile   |  3 +-
 .../ethernet/netronome/nfp/flower/conntrack.c | 48 +++++++++++++++++++
 .../ethernet/netronome/nfp/flower/conntrack.h | 45 +++++++++++++++++
 .../ethernet/netronome/nfp/flower/offload.c   |  7 +++
 4 files changed, 102 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.h

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index d31772ae511d..9cff3d48acbc 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -51,7 +51,8 @@ nfp-objs += \
 	    flower/metadata.o \
 	    flower/offload.o \
 	    flower/tunnel_conf.o \
-	    flower/qos_conf.o
+	    flower/qos_conf.o \
+	    flower/conntrack.o
 endif
 
 ifeq ($(CONFIG_BPF_SYSCALL),y)
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
new file mode 100644
index 000000000000..aeea37a0135e
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2021 Corigine, Inc. */
+
+#include "conntrack.h"
+
+bool is_pre_ct_flow(struct flow_cls_offload *flow)
+{
+	struct flow_action_entry *act;
+	int i;
+
+	flow_action_for_each(i, act, &flow->rule->action) {
+		if (act->id == FLOW_ACTION_CT && !act->ct.action)
+			return true;
+	}
+	return false;
+}
+
+bool is_post_ct_flow(struct flow_cls_offload *flow)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
+	struct flow_dissector *dissector = rule->match.dissector;
+	struct flow_match_ct ct;
+
+	if (dissector->used_keys & BIT(FLOW_DISSECTOR_KEY_CT)) {
+		flow_rule_match_ct(rule, &ct);
+		if (ct.key->ct_state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED)
+			return true;
+	}
+	return false;
+}
+
+int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
+			    struct net_device *netdev,
+			    struct flow_cls_offload *flow,
+			    struct netlink_ext_ack *extack)
+{
+	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: Conntrack action not supported");
+	return -EOPNOTSUPP;
+}
+
+int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
+			     struct net_device *netdev,
+			     struct flow_cls_offload *flow,
+			     struct netlink_ext_ack *extack)
+{
+	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: Conntrack match not supported");
+	return -EOPNOTSUPP;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
new file mode 100644
index 000000000000..e8d034bb9807
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2021 Corigine, Inc. */
+
+#ifndef __NFP_FLOWER_CONNTRACK_H__
+#define __NFP_FLOWER_CONNTRACK_H__ 1
+
+#include "main.h"
+
+bool is_pre_ct_flow(struct flow_cls_offload *flow);
+bool is_post_ct_flow(struct flow_cls_offload *flow);
+
+/**
+ * nfp_fl_ct_handle_pre_ct() - Handles -trk conntrack rules
+ * @priv:	Pointer to app priv
+ * @netdev:	netdev structure.
+ * @flow:	TC flower classifier offload structure.
+ * @extack:	Extack pointer for errors
+ *
+ * Adds a new entry to the relevant zone table and tries to
+ * merge with other +trk+est entries and offload if possible.
+ *
+ * Return: negative value on error, 0 if configured successfully.
+ */
+int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
+			    struct net_device *netdev,
+			    struct flow_cls_offload *flow,
+			    struct netlink_ext_ack *extack);
+/**
+ * nfp_fl_ct_handle_post_ct() - Handles +trk+est conntrack rules
+ * @priv:	Pointer to app priv
+ * @netdev:	netdev structure.
+ * @flow:	TC flower classifier offload structure.
+ * @extack:	Extack pointer for errors
+ *
+ * Adds a new entry to the relevant zone table and tries to
+ * merge with other -trk entries and offload if possible.
+ *
+ * Return: negative value on error, 0 if configured successfully.
+ */
+int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
+			     struct net_device *netdev,
+			     struct flow_cls_offload *flow,
+			     struct netlink_ext_ack *extack);
+
+#endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 16ef960a150d..7e4ad5d58859 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -7,6 +7,7 @@
 
 #include "cmsg.h"
 #include "main.h"
+#include "conntrack.h"
 #include "../nfpcore/nfp_cpp.h"
 #include "../nfpcore/nfp_nsp.h"
 #include "../nfp_app.h"
@@ -1316,6 +1317,12 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 	if (nfp_netdev_is_nfp_repr(netdev))
 		port = nfp_port_from_netdev(netdev);
 
+	if (is_pre_ct_flow(flow))
+		return nfp_fl_ct_handle_pre_ct(priv, netdev, flow, extack);
+
+	if (is_post_ct_flow(flow))
+		return nfp_fl_ct_handle_post_ct(priv, netdev, flow, extack);
+
 	if (!offload_pre_check(flow))
 		return -EOPNOTSUPP;
 
-- 
2.20.1

