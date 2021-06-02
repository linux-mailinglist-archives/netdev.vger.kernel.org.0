Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA5B3988BD
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhFBMCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:02:04 -0400
Received: from mail-dm6nam11on2100.outbound.protection.outlook.com ([40.107.223.100]:56833
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229665AbhFBMCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:02:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahbPa0dHLxxy+iK6pMFBx3FxS/5AwE+TL+MwIHehd2k1OW45dQdbHc4fYgJ3RkbCXb5gg9K+1noC5KJ7CcYPBssaaC7AHZC1XqhzlPAuRUkCtAGuyQyZsTg8mItAB/jyU1GNQYjvJHBIE7MV+wDO4pPNPzq5V1HPYN0ODpOauANwNEVhLSewVp0M8vN5uWH0Ygc7IPOQtjq4+WUtSeoBL7yyW4KcKrKH1uifNlhpOJGEC61gtFPPf51edQ6/cLctuDaNXLO95LLq9d6JCMAm3rEvH3QvX+5gW/6NJPNAhKcmhix8Z0f/rTs+EMIhoZPVwQa5l7BRdvvyx0NTCeEGWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cd/T3tgvy/Mkz4LJjfaKbDo3ToX4TqVnxVAQ3oq2AE=;
 b=BFLXhPW7+PbeVkGEHEmexKKAeQ2BaW5LPck5XMzbrHnUt5WFbCA+yCbx29xtyKhZHWA/uXiDG0Vwuxm/SdA++KGG9sexPQDT4B/VGsZuAC8QpAtsyht3gNjZ+/dDVFnvbn62szekt6wAL3fgNAgJRorwXYOFqzSq2GQdqZFEfa3w9WexDKXtVK1YVjcTN6in5bvHF6EzqtvmtCyZYwOBol5egRlxpo5xcpTgOBwRkKlOLRvQG9kf/v0hWCJWIdQjtdNkgOAH9V7aaUP36QF+33h9iu0YbSQyE/B6vc501NhTsvgsXoUQcDOXYKm8opOZzwxpfO9vJguAh7fg8E/LVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cd/T3tgvy/Mkz4LJjfaKbDo3ToX4TqVnxVAQ3oq2AE=;
 b=cMiurRpir0s50Q16wD+dohNfKUFHkrsN3Nj44PG9aOW8KmG/9Qq0udB98kvUz3+KujjKR5eYhHz3fO0z3nX1/wSw42KoAZLw01mzEgryTqrCzG1b4RRpMIiclL4mnn9sVWno0886TyL7AFIb9RO3ODSvBpMbFSw1W61X9yFnXg0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4986.namprd13.prod.outlook.com (2603:10b6:510:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Wed, 2 Jun
 2021 12:00:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.018; Wed, 2 Jun 2021
 12:00:16 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 2/8] nfp: flower-ct: add pre and post ct checks
Date:   Wed,  2 Jun 2021 13:59:46 +0200
Message-Id: <20210602115952.17591-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210602115952.17591-1-simon.horman@corigine.com>
References: <20210602115952.17591-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM9P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 12:00:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d09c6fe2-dea1-4f13-a7f4-08d925bdfc28
X-MS-TrafficTypeDiagnostic: PH0PR13MB4986:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4986E1E5B3BA01EA1AAD6BE6E83D9@PH0PR13MB4986.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N+bDig2+o8RMxhk1Nzqg2MpogHI5wjeOKtbwkD4qZmOx9lE1G9LgK+eFjDy45YzmjTGtYq46IkZgno/z+/UPZqU2PoNbeQ8P4WuDAeF6hj0GKEHRQzTGF6yTcrJiBNjiU4YIeP1hsnGGfAmiZ/+7WR4ZZsyIkqFWV765YF+oq7aQ3DUzg4if3NPG1gs/ty606k0tiov6KwHBKvhZrqk7iEQcrR9ojcuokErwxb1gPOVDx8L5M9/75w9RrpLd0GoyBmcsDiTjwqwEoA1TtUkrfiN5CssEihefMy1WWv9olurciDAnKAlLUvOg+fvrhzgLZyM6sesvRiiNWm1I0tzGqLMJgItBVLJMYDoHA3ToOemHgMdwbSVyeQjZasGKWyzDygpe+mpmqEVUvwzoOB4JGovlpnZqdQ1npWuhVxO+9R7MovKM8hieNbc9kg2WpyRBQ6N2ciU1D2xzf8yOOqAr0Lp53mLD5CoWVoYs0NFJ+wsxu1AS2aahwrpMlojrCw53FD38tu5cpAhsWAfyiTzDu8UXPAdCO9Nhats4udlIWPvz3NWvAqiIOL8qC3BVb3gE9tPg8ANx9pb0CVtv57WCRznLO7MXD8D9R5eAn707VCg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(396003)(39830400003)(5660300002)(44832011)(36756003)(66556008)(6486002)(107886003)(66946007)(38100700002)(1076003)(8676002)(52116002)(6512007)(6666004)(16526019)(4326008)(66476007)(86362001)(83380400001)(2906002)(8936002)(478600001)(186003)(2616005)(54906003)(110136005)(6506007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yqn/xi0Mf0LZx9nFPMqDfrifAIujRGEAYeM0KvGFzOX9QqQff0J61p5re50W?=
 =?us-ascii?Q?OMs9KL3rskyg7wH2Wt+BfK7x1VCgM0WhBgVUQu7IVSa0yH20s4haJ9GrR8J0?=
 =?us-ascii?Q?cuHBDDZMQgB0+bVbIkKaMXFlU/3zPi+yhO8HuvA+uEkOcsZjMmeb2uLedQgR?=
 =?us-ascii?Q?qi0mbCCBLxGFPgeKFZg+gcoFHaJnN8EIQWbl+Glta/Zjgy+ez0V29JLjRh5r?=
 =?us-ascii?Q?Ze7Nw6YXn3SJhOidBtSbtKRnKdtYIHUhMVFetCTkzbh0NP+3hV2QYCLItQix?=
 =?us-ascii?Q?e7sionIuOVqgruaosUSW+5uBzUTUcA6/ZEtJzHF26Q0TUP4KPgi0SBjj6ZyW?=
 =?us-ascii?Q?0rviJg55iJWXDPBcpYpS0MGmM8RELQWTpIewjpnI/JwkcsRarnzvkTK2GM2t?=
 =?us-ascii?Q?zTqpcpNhrPxakKoWIG56ix9dpSdqnWVkB0foqG615M+JodjPoUu81Om+qn4n?=
 =?us-ascii?Q?9nJ3Ygzy4HNtl2kqkAf/ATocLYHWNLkkxHr0Yf+KNkhTKdtgXkihGgiGqp0U?=
 =?us-ascii?Q?f0aOAIQqQtm0BvNQN+8wfeyO1w952VulOaZVYNS7o4QCDe0aOIiP+4JKcW5Z?=
 =?us-ascii?Q?rBpCX/rlW18bFeX68y3h8/RNOlzMNFfXHn4bqeCexmLRclx4QxSYB9/bURuL?=
 =?us-ascii?Q?jOTFvWVzphaGU+5sH+/U9Dvi7kKDE7/1XA+wmRg3nvleFsoVjVKJqheqwC/c?=
 =?us-ascii?Q?tBuO1siT6v9G6EtU1DJcZXfa1k1a7rnX2n7Viz80ygs3kzrBkKxSgFGHwi/b?=
 =?us-ascii?Q?CUjmHL1qnMua/w5VFoRLHoB8Jfi+23zzbl5zqIpyr5KROs7R9AEtVqYYiCjF?=
 =?us-ascii?Q?sBwfdG6rBXeY9UVqN0eDSqvuClh1PDg9HitjZrBhdoEVatAXFcy0OYWlFLnd?=
 =?us-ascii?Q?kqcw2qzYPhQMw6VP8kZiZGVZNhupLwTwFHtvtFt0CiF06F2ITv0tCaLw2w2v?=
 =?us-ascii?Q?WagAi+KCvOkxElyeyj3eR8QXimO8NtXoDQkWFrFTZj9ghAia5bzHRYkA/yyF?=
 =?us-ascii?Q?f/BjwFbnsG0fwnHes4zHFxGO9kBz9792j3MyYtaDRInpS22gvGHWDJhvyaMK?=
 =?us-ascii?Q?RF9mvzOKkth6LlM14h+AD9+3w6ppcqPJ95FI2yw5ZFKtXSDLhBuRS441kstD?=
 =?us-ascii?Q?DbkI3L+son8bUVK8zULo0STlVHcM5NeuiD/HSdt8ohsD4Ul7Io8VIv8oM/CB?=
 =?us-ascii?Q?4OkL7CiErEpXNS1D/IGF6VhgvPe4xxOjCETDr3nLCGd5aS4u3Ri/06lh9cxl?=
 =?us-ascii?Q?+1tXcbVyWxwRP10MRd8xQA4NUntxnRtJWs8kFPONMP0OlnPi9WneBmdfMUCo?=
 =?us-ascii?Q?YXlJ70ADE9tWaw2eux/tyjXwNP6shOQyauxVEN+98ZmcbK4GdhRRwzfiZfiV?=
 =?us-ascii?Q?t8lVwqScythS2ICQve0z3Yi2/STW?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d09c6fe2-dea1-4f13-a7f4-08d925bdfc28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:00:16.0439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bNmtPNaSfEsGaU0r1M2JJyeRV+hN18V1vEDFeJgbmALUZgMoJD4Mpd1/4vkl9mSavinVuMA9l/w2APr8t5Qf/dCj613LVzDkdtEbG+DuNME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4986
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

