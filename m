Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245FE395AD7
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhEaMsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:48:19 -0400
Received: from mail-bn7nam10on2126.outbound.protection.outlook.com ([40.107.92.126]:16736
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231582AbhEaMsL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 08:48:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFHgax293c1z6FQ5HzuNsiZt3QoXySgbKWZ4z9Fd9p46iI5e02MzhxwRfU4ZsAv1Tk8CDfXy8NcDoSjUPqOuMER4wS0QmBaaByM13zwMAy9/51ghn2Ze9CmY3qM/9pFh+oH+EP61JbksinZPhiA4VDpU8jIlPKvGpBHtRbKf3UKghGG1LtYlcuExcEVIY4VgOlk71kCSMeKrr/5reOFrWUObNc3B9VWexINdiyASJJ7h5SpR/2OdhnhfbZAQN0rdFLHS0+NyFlWPzpqOMp/VacROrrxW/vv4lH5dMntkK9wKEJ23bmCHfaj7cHsXGWwOpkxqdgBH+8sN2Bp5fpu0qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cd/T3tgvy/Mkz4LJjfaKbDo3ToX4TqVnxVAQ3oq2AE=;
 b=af2rQzdoe4lv+JnJXYdoLgNj/h12E9UWooi8U2lsgzE27khQrOCfD2XRuAg27Fej9SaCpixQUfe1cYAv4rUm5mhwYNa2ag3nrJqbonWcdQtnJnlY3tNeZ9gqgNHkGCtzjj80qOVGws4Vtpb16M9UILw0QH7UtsRHI+gQp1XAKSzUhGeku09H3+B6OHkHypSPQw+YC9aVgGH2rnUk1mdKNhOgSQz6JMokICCMwpk/uebPScpdLHT/t+ZEuFJtqweKlxyk95Z+CqhM+UfRoJjM21nRkSslecTFWT/Ju6DGHxwRy/eah8S+qfQRZ0/Jma9ljRkSfE3eZIn6dOdGvPTdUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cd/T3tgvy/Mkz4LJjfaKbDo3ToX4TqVnxVAQ3oq2AE=;
 b=PsVauvgCTo5N+VwiYzgPHirDDV2l86OsV4IMeg2q1Q4ovvhUaWupc06eB1+hRRkvybTZGsO28XccbHNLrw1caw9Z/H7BdkVh1wvdL8UJtIFodduS0R+sWFOXoznCDZqXCGDqSsyVjoV5k7v8K7GIEljIYeLfBMLRIRI4YQ2m/uw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4876.namprd13.prod.outlook.com (2603:10b6:510:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.17; Mon, 31 May
 2021 12:46:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.016; Mon, 31 May 2021
 12:46:29 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 2/8] nfp: flower-ct: add pre and post ct checks
Date:   Mon, 31 May 2021 14:46:01 +0200
Message-Id: <20210531124607.29602-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210531124607.29602-1-simon.horman@corigine.com>
References: <20210531124607.29602-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 12:46:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dee05a29-0d79-4a62-4bde-08d924321c93
X-MS-TrafficTypeDiagnostic: PH0PR13MB4876:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4876FCF4F818282C4D9E2DA4E83F9@PH0PR13MB4876.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XpeC3cVQ+SMyo/ljpeVjgwJ0u7Mx6tJ8QtAE/H+llH0PFY+jnsiCVUyYCoWp7MMfG6X+0Tck/VHHzIn8T2JDHsRGSxo7C1tLUARMaE/cAdJzMafi5hj3J8DusJ5VPn4b/j/rtN/2Mcv3UM+XeT/mz/hgRR3USrJZjJk0ntRKhw7JXdecdL6E83V89MUrkuNbSWv35uCh3JxkzSwCIlhoJoinmCED22Il5loen7qWKKvrcK+6UxeLgzOTPllFmwI/uFIZtus2N3jU2KOIQAFYCUUZ2sa5bV57rnRi4KuVDLnT5PEvRmo6j0VFWoSzld24ASbckFJeP3ZWJy9QF+H3LqZib6yJx+X4AsX6qbJSvdXlrZYpadolkYzJPdE3u7FArsfcw6AOXKdWecE/6CEoZT+P56HMatwBjUQhwMoGa4naqu6WwwVpAp8dZ7LHPRsOv5f8iT5dh6ktwNpgzj2B0lrJVZs6FtZ5hYjfPrxjwt6rKd59IMUfO2+9xa4Md8Lwvz5BgN9B1GuuS/TOa5LMSw6Ewb34mlUxijCSHkf/CX1r3ov7i2omNcIOOd9GHvaHrglyiW+vh1sCCocASS3S1I1+cijRE3pzSrGUmva66g4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39830400003)(136003)(396003)(366004)(2616005)(6512007)(5660300002)(6486002)(1076003)(186003)(86362001)(36756003)(8936002)(4326008)(478600001)(6666004)(16526019)(8676002)(2906002)(66476007)(66556008)(44832011)(107886003)(54906003)(83380400001)(316002)(110136005)(52116002)(38100700002)(66946007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sjjdXKuUxaVEoCXRoqKuVsuOh5A+JHP+ShMeyLP00otLrQ5z8BmfkTxyL77j?=
 =?us-ascii?Q?jmJNarRn+G1S7l7MJTk2B1x8pTxK73MkYZDODxcChQXTC7CuL4QT8S76o3cY?=
 =?us-ascii?Q?srWlpAcHKIHPfBY+9WLranHIi8lasK5pLv+tvwd+bLuIFtMzvod2GMmP+ECH?=
 =?us-ascii?Q?9Xnkhb3uwd4ceTfC/YV/AnrZBl/1Q+zRBSQ4RLPtnmaCSefPfX2dYU/3rznT?=
 =?us-ascii?Q?x0E5jWXBgFat6qeddSf0ZIcWFSNnD7yIRRpIncVPts5gAUIzkfS9fPO/OrQu?=
 =?us-ascii?Q?EqT9J96DV54jlg8qEixbESlk29IVaYLWS44A12frn8SVsVG30KLLAjnJ+5kR?=
 =?us-ascii?Q?RoWK49ba7eC7I231HLrLs3LRcFCUnB7XmwG5gMS6E2V6g2kD8CFyuxXcfxIS?=
 =?us-ascii?Q?c6fzf2k04gbMxQKHq+ns7BEElohpT1VhghtWJimYAOBCT+cFi+xC+aDZ03xb?=
 =?us-ascii?Q?+J3mSq/fXBTiNuU8bp6wbCKqJdXzOG1NPXtDprpqjEcGCWUu/zBiN8fpHXWh?=
 =?us-ascii?Q?Je6Fb9lS8b2yiEmEgGc7KGwiicq4viak9uyiZ+6ZsGF/DptaRhE4slbzFS8t?=
 =?us-ascii?Q?z9VZOEpNOefmykDYOUeDFtjVcsaBq9QMIOD5FcnuE0cQF0iBy5a4l6/YaaNz?=
 =?us-ascii?Q?7JpbrwoPtb6IFmem7qYIe5UNVBhHlxrimUELfzW82bF2rNKNg0SA8dGZhpua?=
 =?us-ascii?Q?JFF4Xce5qpa1qycwRVNzFsBEiS2QbrnVBPK60f019ZZO4xwAxuGTbQwzGy7B?=
 =?us-ascii?Q?uD5HbCbsW17JmW3yiwVAxuYF/I2OlrJ4t5RDoA9byr5MQP/+sZB/LZXYB1Ub?=
 =?us-ascii?Q?xm1hXB/KRxzLQ5P73Q43dBKHadeZuFvQPyb7A6I9FITeAIDJqsbxG8oQHv7T?=
 =?us-ascii?Q?YUEe/pYjTofwQCWwRcV7zz/MHFBvJfq+Yfgs5YK2wbw/Ue5Sb6IDRRcWmcXV?=
 =?us-ascii?Q?bHkyarYKj6BtIEXh4nd0cQ/d0QHbFV3DO+V7kXmqKPjLtNcPEmK+3opVH3nU?=
 =?us-ascii?Q?ZeYCv2jDeIyNypgbi4FmnIJbTc9CtOuZzBAdMzqKNIEfG/tjNG82nG2LSjfe?=
 =?us-ascii?Q?e9Rfil2RRyKwGCezYJadr6j/KA7lVP/kDRSTN2kJLXTeCZFYuREdp9LxlRm1?=
 =?us-ascii?Q?lgQoRjTATOITanDrzcP/i1rMFSlnWuJJMqQzfLP+XlEZq+txn/IDbwg1oINK?=
 =?us-ascii?Q?Egmw4+Bh88BbwE+ew1F3ibXsY0KMJY3XsguOCI0AHpA+//casVmy6ka8D/Ql?=
 =?us-ascii?Q?hvaTUUzgq8ubpTJV9a5JA2vD0qbpLbM9Kw8heeVNww1VzzCkDUPgfasCpjCq?=
 =?us-ascii?Q?HVyDAaKwMPdnX7aAPuyyQ59IyQYskMbdiF529rtLxkJRJNhZ3H/dUJYhXDVX?=
 =?us-ascii?Q?UScgWblG3P6MrfN6r+/IfNcNyJc0?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dee05a29-0d79-4a62-4bde-08d924321c93
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 12:46:29.8425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ieI/ZZaQMqVXRELzfc3KDBlmGpYPk9g4XpsL5LeaN56c8o3dxPkiAilcTnyIqDQtAMacd2beelK4Hx7A3q3SGm8Pp5y0/nDY6NT9kY4acgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4876
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

