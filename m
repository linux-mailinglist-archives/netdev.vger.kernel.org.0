Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9314C1886
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242784AbiBWQYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242776AbiBWQYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:24:00 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2093.outbound.protection.outlook.com [40.107.223.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C6EC6207
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:23:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVGcfReSNH5F8ktNoI1cx4xMdDbVqFCtyh/7T5vTZvL/zFad0nHyCxNhWFdVN8iVgeEMtfWbx0pAGyxIqW1nwS8nDn2TWs3prXFUNx7LgGPBeEb4M0fuzxH7jtbiQoMSbzQ9H93ajeVaQ9VmzRGNPFdqTn5/bj18eS/YAz2yOqyBi2vKDg798ZMdKhFUYxKRcwi/zz9IiV3EB+0yIkRcDk7fWke/iX2u8qupHyF+IwfxpHPz6q2Fi9itnOIQOXLg3e+cN1/a1UORLUOyULUASnq9TT68/WAQhOz3mDMvkAs/bKrKvKa2+dl8XNnemYJ72Vj16cogoc9tEWILC6yl1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twy+hi4UeH2KG589OujV43A4nlRyM5YneZPPc4M++Hk=;
 b=HTnKsmke1T5SIlJbTxYPSh+gxDYBH9PjYwC9ssU3o5nv4ENZxA3DYdM8d9rDAwypnEdrxciENz/tnSxjXNOUsO8OmritmQYjuFR7BbvG3iZXQyFPIBIcD4WeLLJiPv/iky3WrRdp9LqlUCek5/4KicENhPwQ3t573Lshb9Ge4JHDsrj8eC9cTUOfIvOBZy4UVC2/zKlxYduu9PyVocBvU0j56+JnhjwprSiDIU34H9DqyU3kE0cYGkvnbqWz3tjkoVkUloShwkCgHcNVMNj29tLh3mMaix99ro9TVcNwk5H2wzYI7kASoyltpCH9IJ+ZhpWiD0z34PydKcHEqZRycw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twy+hi4UeH2KG589OujV43A4nlRyM5YneZPPc4M++Hk=;
 b=IKkuMCdlJKy3Vt6r1kupm56zERRUh2Dlw5LhvvAda4DOBP4M+Y/N2YgqJoDK7QP2vaP9zd/VlY7lvgn67XhNvZzmxVqzcDCb0Q+FJOtNiHqnXqgoDScfmPEpB3j90SZn4VRxisPYcd0hm1dH3F5ydjsc4eOszKsWd8Rlk867Ass=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1757.namprd13.prod.outlook.com (2603:10b6:300:132::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 16:23:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%6]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 16:23:26 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 2/6] nfp: add support to offload tc action to hardware
Date:   Wed, 23 Feb 2022 17:22:58 +0100
Message-Id: <20220223162302.97609-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220223162302.97609-1-simon.horman@corigine.com>
References: <20220223162302.97609-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 728a265f-f9f3-4fb1-cb13-08d9f6e8d149
X-MS-TrafficTypeDiagnostic: MWHPR13MB1757:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB1757CD976E6B32EAE4037B93E83C9@MWHPR13MB1757.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cI8RR6ZKyEYYef7utGFgiVh1bJP/bRMu/NsPEFkBljOsE7IreN4X//Qotf8pYQCw7dCYqcbmPMmIYN4QfFSjWNAT63Z/0UwT0IJxTDBeZKMywtsFlUdZD+stgguQCi2BcRMNl5/TPxkuoMXI5U4ZVCs/cHBi6hMmN0yuy3qWlFKghmgQe6GGoiYn5v6GEZ+y/P8sBx/BhvRrG0l4fFwSLvLaK11/r4mN3jp0Z/wwt2avhdpa0bFGCM/eduY6c/zt4OJATew4YznW+RRbiyc7mpfN/h7Ui5/pUncG4cBqtbBxfCGKM5ZMNuQ7rgjrW5S1XpNSxrEYVPs5zbG2u9fBOYIcXG3NSsAEmGTLKsdWcw/jM90+hVCqAocjYgVI3cuRlkW+y/4CIrcFIM/zbxswxAWJfwWnlaVPNaiDTQYckPeYiYPTr0g472dYTeBz2+gCozqV/OMLS7FoFeaTHRl22rgjvXuHEXFjnIrMyRqr6qwwCLYExA8eltJyBs2Wj4LpTZd0f3s+fm26VoYe4TrHJ6Lj2llc7j5pXHYvZ6CkmoIkd1CVXvcioIKcKvoBiFcR9OjXEYFals2nbkjcqY1wGbvywi/5CGJRQT2LqqPVqKm15zmQ4iMkePiQKyXn5rizLezFbZRwGQI3Mhj38oYbnI43y9qyQy3jU2Nui+67xJ0jFGuVLnwR/VGgdPMoJ6JBLLUCnI48TQmbBeAf/cMOrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(136003)(366004)(396003)(39830400003)(8936002)(6506007)(86362001)(508600001)(52116002)(6486002)(36756003)(44832011)(2906002)(5660300002)(54906003)(110136005)(83380400001)(66476007)(1076003)(66556008)(8676002)(2616005)(316002)(66946007)(186003)(38100700002)(107886003)(6512007)(6666004)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LHbu6DmevRX5gHe2HZ55rdxtH9MuntUFsU4PQ8fJFw8vPklurQlGFuiV7MUR?=
 =?us-ascii?Q?Re0FzfHq5JhWsshpVhY3evpJesfr0Zj7RQbS99tQPUfymNUTkwgce1hphD3h?=
 =?us-ascii?Q?8zLqVxYA0gXt8salVBfU0yUvGL2xgcKWPRP+W2eWXFc/BI6e0oOBKUlVk2Tn?=
 =?us-ascii?Q?NrreTAkhTjp03ceUXNrghRKMkYCS3Kc04WqMHeK4OqCUaINsOvAHmUHEZOja?=
 =?us-ascii?Q?ef9OoskuP9OZxR3N6hoAYyf/VbQiD3szMNd+ch5phkzRoO3645wdERDQq3kT?=
 =?us-ascii?Q?VklWl+ZfTgkjfauQUbYDMPQijjCwpj/9ZT1qzEIYJTVRFbR0mLBGIdAEBKOq?=
 =?us-ascii?Q?jDb7Dykbx0oEwSO2GJ96rMa/SNa6ndR2+59sm/qKg/Zo2NNCEerfQwdpEk2w?=
 =?us-ascii?Q?lRc7/wWjZQuqyxDvztXp2ySw4+aRLXyevcGyASRDc4rX06uilu5V8bX90AZk?=
 =?us-ascii?Q?txqD69erBXDj367+p8qtS9Y/o/L5ecR2NfOHEBxABMXhwB/O0dw82ZbCCGmD?=
 =?us-ascii?Q?eBAMznt8RefZhX/q/k9xRDJNvD8rQC/GYQAlNYncsPceOrCkzjoPpp1StiLZ?=
 =?us-ascii?Q?iQPAoRODlIWgxMdXl9Q9ukVq06AsUphl1E9IxIESGNTEkmboWsAelwIubetF?=
 =?us-ascii?Q?mbaifVRfBCnJWV5oDvkepTq4cJR3U8oVR2rXPjA5fINxGRGE5Ubm/aPMdc+/?=
 =?us-ascii?Q?/lbOg4MY0d24yhK/SgXPHnEFEVVajNpSNbGzFn7IFgqc/ad5vwhNtL98VNKW?=
 =?us-ascii?Q?oRcUwhN0jFA+FSuI5Fbj5ZIiD1h8kgGz/QApiJPY9czj2R4mUhcG0zbtMn/v?=
 =?us-ascii?Q?rd7lzpKQVQ1lI3mQ1ry4fPCNg7ycAw2zHNH3IlQM7NCIQJQRbzh73lcNVfJ+?=
 =?us-ascii?Q?qsffRdX/phQf7VI9VNbuaFSE1bcCRGm1cPsQ99W6GiB8316ZdZ/TRWXtJLLj?=
 =?us-ascii?Q?bXRJC24n0XPFzMIn2G74xNVjFEDiXYAyUMzeRCJUgfDivqlVpLAV9pAboK6u?=
 =?us-ascii?Q?Smf2EoRtdT2XGCz083y97HRNqL29fVqiy68C6LS5qwdBh5GlNm/Tao05PLXb?=
 =?us-ascii?Q?BhkPQnEbEtj0CeY11hzQqrfpYOR6bP8TzNaMAPe/AW7pRhWJp4TiFILwdVS6?=
 =?us-ascii?Q?qvb9bU2Jy+dijp6YUxw57+liy+hw4Y2OLRbd/Xb41WJoBzOQIZ63AylNiq+8?=
 =?us-ascii?Q?IY0BenMD9leQ3dUfsljN1Wp1KXwCHa7NfK3a72lvzBTo0vRnHyNXo3ogplSl?=
 =?us-ascii?Q?e4g+OE9rS0z2GVylLgSEt+vhQ3lBVRhYd27krjkF9YCxjZgraEqiOiHQ8yAa?=
 =?us-ascii?Q?fhU/s2GweRmAoIGTBrsTPAdrVteMElNgIE9IRrc3FllwiZzMHRlz948bI0rA?=
 =?us-ascii?Q?B6kIzT3PqmjJyKXIF2NpQ1iZkduLOOld39t3t8tkhx4EDWVXTwgTQZVO0q6s?=
 =?us-ascii?Q?6W8OnEz2USHephL9ug0CP9RwKSpE0xiiMoJCFzg/BU7N5SXRpmmnvIsI/I2T?=
 =?us-ascii?Q?1QZyqVsWq5ZA3dUglljTSiatJqKJeFVnYgq7N+kvmgMj+0krB5CKg+QsM64+?=
 =?us-ascii?Q?sCc3YYZ8CbkO+QDA823s9JYujVSTrLttRFok2dC2HWnjojAyvzjnLPfixHtV?=
 =?us-ascii?Q?SQ42yQHxNwZyz0BQL8AvK2j1Dy7jyxsnl1q/oyr1po24HW7U3Sg8aTSlKC/Z?=
 =?us-ascii?Q?5mqyVE7b7bHlKeOwmg+8/B0Rwji+ssAsht6ypou8MOJUHZaQtqWFb65tLtrx?=
 =?us-ascii?Q?XiaKCFhXRA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 728a265f-f9f3-4fb1-cb13-08d9f6e8d149
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 16:23:25.6255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x8gzPjViBPJqaiTrstq/B8TBjXXCtcsJVonEsOrFA97H0TUVeCz4d09PkOdIKBEJefoCI5ORrVGLrFaHJklQDYR9KIDls5LZzFGTIg+twK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1757
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add process to offload tc action to hardware.

Currently we only support to offload police action.

Add meter capability to check if firmware supports
meter offload.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |   6 ++
 .../ethernet/netronome/nfp/flower/offload.c   |  16 ++-
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 100 ++++++++++++++++++
 3 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 7720403e79fb..a880f7684600 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -12,7 +12,9 @@
 #include <linux/rhashtable.h>
 #include <linux/time64.h>
 #include <linux/types.h>
+#include <net/flow_offload.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tcp.h>
 #include <linux/workqueue.h>
 #include <linux/idr.h>
@@ -48,6 +50,7 @@ struct nfp_app;
 #define NFP_FL_FEATS_IPV6_TUN		BIT(7)
 #define NFP_FL_FEATS_VLAN_QINQ		BIT(8)
 #define NFP_FL_FEATS_QOS_PPS		BIT(9)
+#define NFP_FL_FEATS_QOS_METER		BIT(10)
 #define NFP_FL_FEATS_HOST_ACK		BIT(31)
 
 #define NFP_FL_ENABLE_FLOW_MERGE	BIT(0)
@@ -569,6 +572,9 @@ nfp_flower_xmit_flow(struct nfp_app *app, struct nfp_fl_payload *nfp_flow,
 void
 nfp_flower_update_merge_stats(struct nfp_app *app,
 			      struct nfp_fl_payload *sub_flow);
+
+int nfp_setup_tc_act_offload(struct nfp_app *app,
+			     struct flow_offload_action *fl_act);
 int nfp_flower_offload_one_police(struct nfp_app *app, bool ingress,
 				  bool pps, u32 id, u32 rate, u32 burst);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index f97eff5afd12..92e8ade4854e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1861,6 +1861,20 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct Qdisc *sch, str
 	return 0;
 }
 
+static int
+nfp_setup_tc_no_dev(struct nfp_app *app, enum tc_setup_type type, void *data)
+{
+	if (!data)
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_ACT:
+		return nfp_setup_tc_act_offload(app, data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int
 nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *cb_priv,
 			    enum tc_setup_type type, void *type_data,
@@ -1868,7 +1882,7 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	if (!netdev)
-		return -EOPNOTSUPP;
+		return nfp_setup_tc_no_dev(cb_priv, type, data);
 
 	if (!nfp_fl_is_netdev_to_offload(netdev))
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 68a92a28d7fa..95bc71b4421c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -475,3 +475,103 @@ int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 		return -EOPNOTSUPP;
 	}
 }
+
+/* offload tc action, currently only for tc police */
+
+static int
+nfp_act_install_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
+			struct netlink_ext_ack *extack)
+{
+	struct flow_action_entry *paction = &fl_act->action.entries[0];
+	u32 action_num = fl_act->action.num_entries;
+	struct nfp_flower_priv *fl_priv = app->priv;
+	struct flow_action_entry *action = NULL;
+	u32 burst, i, meter_id;
+	bool pps_support, pps;
+	bool add = false;
+	u64 rate;
+
+	pps_support = !!(fl_priv->flower_ext_feats & NFP_FL_FEATS_QOS_PPS);
+
+	for (i = 0 ; i < action_num; i++) {
+		/*set qos associate data for this interface */
+		action = paction + i;
+		if (action->id != FLOW_ACTION_POLICE) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "unsupported offload: qos rate limit offload requires police action");
+			continue;
+		}
+		if (action->police.rate_bytes_ps > 0) {
+			rate = action->police.rate_bytes_ps;
+			burst = action->police.burst;
+		} else if (action->police.rate_pkt_ps > 0 && pps_support) {
+			rate = action->police.rate_pkt_ps;
+			burst = action->police.burst_pkt;
+		} else {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "unsupported offload: unsupported qos rate limit");
+			continue;
+		}
+
+		if (rate != 0) {
+			pps = false;
+			if (action->police.rate_pkt_ps > 0)
+				pps = true;
+			meter_id = action->hw_index;
+			nfp_flower_offload_one_police(app, false, pps, meter_id,
+						      rate, burst);
+			add = true;
+		}
+	}
+
+	return add ? 0 : -EOPNOTSUPP;
+}
+
+static int
+nfp_act_remove_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
+		       struct netlink_ext_ack *extack)
+{
+	struct nfp_police_config *config;
+	struct sk_buff *skb;
+	u32 meter_id;
+
+	/*delete qos associate data for this interface */
+	if (fl_act->id != FLOW_ACTION_POLICE) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "unsupported offload: qos rate limit offload requires police action");
+		return -EOPNOTSUPP;
+	}
+
+	meter_id = fl_act->index;
+	skb = nfp_flower_cmsg_alloc(app, sizeof(struct nfp_police_config),
+				    NFP_FLOWER_CMSG_TYPE_QOS_DEL, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	config = nfp_flower_cmsg_get_data(skb);
+	memset(config, 0, sizeof(struct nfp_police_config));
+	config->head.flags_opts = cpu_to_be32(NFP_FL_QOS_METER);
+	config->head.meter_id = cpu_to_be32(meter_id);
+	nfp_ctrl_tx(app->ctrl, skb);
+
+	return 0;
+}
+
+int nfp_setup_tc_act_offload(struct nfp_app *app,
+			     struct flow_offload_action *fl_act)
+{
+	struct netlink_ext_ack *extack = fl_act->extack;
+	struct nfp_flower_priv *fl_priv = app->priv;
+
+	if (!(fl_priv->flower_ext_feats & NFP_FL_FEATS_QOS_METER))
+		return -EOPNOTSUPP;
+
+	switch (fl_act->command) {
+	case FLOW_ACT_REPLACE:
+		return nfp_act_install_actions(app, fl_act, extack);
+	case FLOW_ACT_DESTROY:
+		return nfp_act_remove_actions(app, fl_act, extack);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
-- 
2.30.2

