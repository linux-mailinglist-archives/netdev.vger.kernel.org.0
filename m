Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91888478DB1
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbhLQOXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:23:02 -0500
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com ([104.47.59.171]:28401
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234648AbhLQOWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:22:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXn2ZLZ9iIn684MDVJrXhKm7NgyA0tdBqcCOaORgF8ja/+9KJgziFqrUXuVLBIuQbPIs1J4hVOfWL2F2yG0Pi5jjKr6uk1keTlz6pk6OdUeS5ffIG4VaqR/qXrSqdOpN5vjp7qju9yuFs2wdmRbKiiX3pX3a5Mu78AC6BUOfPHtk25VNxIlAx6r32qYhyjILJCPxhL15weBWytQ2TtAaV4nxzUFZRbyLJgJKqmMWyrFcV9BLY0HkjIJ9yRG+s3v1i6UwuiwXo5vqfT8W79Ufjey8OfXS4mzO52X3j+k0///oOrP1P88Km37armZngeJauVpZqDbKr1J8sVMAL0rHBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPfU+Rnat6W5QW/UhiKUvJVvi9dDW8DWhD1LTx7oijg=;
 b=eiRMjEJFfQhGKSa/wd8R/uNtYksE5odcdteA7MCVl3NW5ydPFJ+WYp48Jmf9EChxQReMg9hpHI8kobiKpGEMRPGOLXVCo+KmAXimR+gga/dZ4bDt8WrJ4FbartkADRdVBXMo2L6bPvycYX5spS3cqfdXaGM/7DV6yLxeR20QhhjnomDP07a8h0A8X2sTvR5d7A/sH2jp0xdEHDpYpjQ/5N7JtaQvYnhxMNJR5lY7IjSlll+LmyhLr0nGuhRnTLD+Y4QCh8bU2fVmFq0WOEafASjKP82OzVSpP38o9AsZdenkon0rrCh/1kjPON/AVJ/vT396CfW1JxlCv2bFamy34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPfU+Rnat6W5QW/UhiKUvJVvi9dDW8DWhD1LTx7oijg=;
 b=lsM5Q+mYAYcDrbXQNceRiCCZUU9+CbjCB+FhabFDLChOtO6eXa3faSYNWSO/mkWcAh/oqy1YvF1Xwy++pGxk8CB5z9ebtoDnfF7XyGvzkgw8GAPUafL/wPLNoJfQ393YZmTvuBFDwTxKjezT+vadjr6wesxJL/Bu1XMPQQa1ST4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5595.namprd13.prod.outlook.com (2603:10b6:510:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:52 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v7 net-next 10/12] flow_offload: add reoffload process to update hw_count
Date:   Fri, 17 Dec 2021 15:21:48 +0100
Message-Id: <20211217142150.17838-11-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217142150.17838-1-simon.horman@corigine.com>
References: <20211217142150.17838-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0079.eurprd07.prod.outlook.com
 (2603:10a6:207:6::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bef68b1d-f2ed-4d23-ce0a-08d9c168b5fc
X-MS-TrafficTypeDiagnostic: PH7PR13MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB5595445989B94CB07F3C9B2DE8789@PH7PR13MB5595.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: udeyNiR2EzbKiQdu3avXLkdXciOKoNH9coWLRnbSOmKn6uhFqp951aCLJQ4Fkn9eplQp2ELJYBBnoJtoUfOGa64L2WKy++pwP9y9D9ciG+GQl8FvOnI+XzCrcMejSYcx3JS9UpBXD3rUfdtzx1cZH2iD758EmZocMTgJHtMKzhKUlBi+yJriKVZOiaogqVzQ6XQQszW17gm7MkwBlExSxhJXrQwbemszmNeWdlcf/1wQ0SV1nwZvMwbzhboAOnf6eGIVzku23uBUgg75XUYTMJhWudUL9DzKtI7CQ2sxktO1RAPQ+9UeWjLm95msszKGBegerlLvUdMHgq2RXWs1By+CpTeKf3CWNeRrHsEDR8RI7yGlP7KmL6Np1lMtpoeJ6UyeA0g9r+kJNU4NStUXoUfOI2YAf4AY0BFd9npNIRRIngu3J8Xbqqc8a6IH10zqj/XV6BxcDYCu5OkT/spPN3dH9bwJXVjTFqaJ5OsWYcM0YgCnaP8OvSnA8zNuOVxAiadlPENODRDp82Trm8dGh0grpIPxuN8334dUMlMx8+4QtX3GcRJBrsSlPsvBOdiOIjRhtwvzBwOJBb0WaybXm+gTdtetOJTGlN8iGJqH3WLIQlRWoPft6Pn4KZVRKevQTsKAxhYvERWj+0SkzLLEOd6qtBgA8qvYfWgRyNfO94mGf9Pr5PG/1IV7sJODwYLs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(39840400004)(346002)(376002)(136003)(110136005)(8936002)(54906003)(8676002)(316002)(66946007)(66476007)(7416002)(2906002)(66556008)(4326008)(30864003)(86362001)(38100700002)(107886003)(83380400001)(508600001)(1076003)(6486002)(36756003)(6506007)(2616005)(6666004)(52116002)(5660300002)(15650500001)(44832011)(186003)(6512007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hBQwU6zrIpYyUvRPPo5A8xrz5ae0toJA2DecYIBdoYhUjcIzLzw13XEAcQMo?=
 =?us-ascii?Q?VGonaI4aVItket4mQ8CVuMyTa8SD+vsCGUbJhbb3EuWEv2ntdsoEs7OS1jKg?=
 =?us-ascii?Q?szyaVORrZRb90QVEUCQ10mJ6rMM9TomSIpup2GMnWWGALTLCKWuXK+OYTu/p?=
 =?us-ascii?Q?sS5WZuX0DPKz3Jok3Q9XBSO1Fz5WODAL9LN6fPJQmIiGd1FTebfSHY4CJYM+?=
 =?us-ascii?Q?q74cheTGpsu/fA1O+gJl5t+bQ/5N+mtRnc6CZIdiwyuFKCgJ7jgjd/NQawtb?=
 =?us-ascii?Q?UuH5oYEr0m6/TYRe+MluFqXOuUbPS8YGb77J7hp/krCQhHAZHa35SLoxb7fU?=
 =?us-ascii?Q?lu6djIlxTHx3X0tPYjYxn3M3oQJWYFZ95ZeD9dr9cWrCeJ9ElYzV60O5Yndf?=
 =?us-ascii?Q?Lk8048Q2m7cSkz4ASxlE58v/viNFyn+5FK9uGT/MNZXssJfQoWqqwzSuy74W?=
 =?us-ascii?Q?CZ7ZyEt1PsfuprkauIxsBF1K61ZrPfl20xsK07iQkj/er8B43beqk8Tkgb5f?=
 =?us-ascii?Q?41d+pVKtunU9/72GFkz0qrNTRI/WCRvGkaBImL5GmP5MkQYX/vnDu55EbKXK?=
 =?us-ascii?Q?iHgqZLxiG81/0H6y5gGzRhW8j7qcjgkd0Pmz/CAw9fFshb4ua8nQEfmF+Ndh?=
 =?us-ascii?Q?i75eZjO4NApMApE/d34ftyU+DE9pFaoch+k/9LK+R8QWh+yK+FbfWPgLKHo8?=
 =?us-ascii?Q?/6uNSAY8ozsDeE5wlYIcXounwOPrlMVR4lxzURLOMR4GthdqQKGBV2/cOhv4?=
 =?us-ascii?Q?0Q0R7tCHsg+ZazoT87DAOk6E2GBcjk5xPRlXjWgcDG/QzHI0QZnm4mbQI748?=
 =?us-ascii?Q?VPTC5lNf4Ju3ZIQVdrKNxcQboLQGAAIUlQ6vfHxuVcRlYa4l2QIKhby2OBC1?=
 =?us-ascii?Q?TRnvk/nO8ayej2ITQxVSmA+AptV8/VBF+96/3dV28GbVOiGjbbLk3deZUQLi?=
 =?us-ascii?Q?RKBTPvJ/ewXdvt2pyqk9iDiEZLJ5sGRNZgyjJTjUbDe+EfvGgKtI187tS45F?=
 =?us-ascii?Q?XdvVBtYZAqX4ZUxnZgYeksCJyikX8XtQsW/pomAS7hxGXsX8ReU6cQgjvrFw?=
 =?us-ascii?Q?8cAEwW5u/FWEmkgfpx1tBlfQLNpU5S+BexqlhGQcJ8wksIlFhwJCony1pfx1?=
 =?us-ascii?Q?OrfhphitIOtkqw0QJm430qD4FIXHiOH4YAhsKLgin+s+EkvDsSVlFRHpw3tO?=
 =?us-ascii?Q?h5oraMV+pohln1MCA8u+GMB/VNxNDg/4PzA3svfmwUeGWxfOYWkF0nMztY8h?=
 =?us-ascii?Q?vO5923RlG/KdviVUe7Eu+mHQx2psky8CEeZ4r8V2CLBnLziNzfVzYK7gTtEg?=
 =?us-ascii?Q?WMPQ2a6YhOMo6XNG/ogXBfAtT9RTEjSuV93hXLqAQP4MgnxITE8/LF6Ipu2C?=
 =?us-ascii?Q?qGKAqrtqkLgmuCGCEghk70uPr2j9lNKIkuZ8EjN30KRgTBwJ/UdC9gS5Q7df?=
 =?us-ascii?Q?nD2DGo51cFfCoqRKidFBOVbmoZ0qrgqRIqjqDo2pcf/56F9P5VyjUli6ok0D?=
 =?us-ascii?Q?WeCdgyP7xqZ3Vxxfo9IPG3Rcl13tJ9HeqoAgdnBf/nBNJCM4hTrcJ53BC605?=
 =?us-ascii?Q?+P7B/8Ac7dJTZ5fYz6Je67vxKPSXz6vA/zf/oE326j4S1vsSlFoBFEOPQych?=
 =?us-ascii?Q?PWhmCy01RfRBRWNv/gltcZEy7VLgDVNnf6jXEuLgZe9/41q/pXLQeUiw7ono?=
 =?us-ascii?Q?zPc7goSWcu3pjJBj7zjb0qGDOaqW3r6lwvJpSzYllNBU6Uif4EewuDWI/API?=
 =?us-ascii?Q?fUL9eR020A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef68b1d-f2ed-4d23-ce0a-08d9c168b5fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:52.5889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ri6sYQTDMbVtNAdv0vvzJ5ki/MImdnKT1qeUHNRmBHTsW6SdqKJBaiqhGUBUkR71ZlEOBBCm2i6H+tt4yAqW28vX5/UIwoiyjYp8qe+3dE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5595
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add reoffload process to update hw_count when driver
is inserted or removed.

We will delete the action if it is with skip_sw flag and
not offloaded to any hardware in reoffload process.

When reoffloading actions, we still offload the actions
that are added independent of filters.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h   |  11 ++
 net/core/flow_offload.c |   4 +
 net/sched/act_api.c     | 252 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 250 insertions(+), 17 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 20104dfdd57c..0f5f69deb3ce 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -7,6 +7,7 @@
 */
 
 #include <linux/refcount.h>
+#include <net/flow_offload.h>
 #include <net/sch_generic.h>
 #include <net/pkt_sched.h>
 #include <net/net_namespace.h>
@@ -254,6 +255,8 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 
 int tcf_action_update_hw_stats(struct tc_action *action);
+int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+			    void *cb_priv, bool add);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
@@ -265,6 +268,14 @@ DECLARE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
 #endif
 
 int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
+
+#else /* !CONFIG_NET_CLS_ACT */
+
+static inline int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+					  void *cb_priv, bool add) {
+	return 0;
+}
+
 #endif /* CONFIG_NET_CLS_ACT */
 
 static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 022c945817fa..73f68d4625f3 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <net/act_api.h>
 #include <net/flow_offload.h>
 #include <linux/rtnetlink.h>
 #include <linux/mutex.h>
@@ -417,6 +418,8 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 	existing_qdiscs_register(cb, cb_priv);
 	mutex_unlock(&flow_indr_block_lock);
 
+	tcf_action_reoffload_cb(cb, cb_priv, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(flow_indr_dev_register);
@@ -469,6 +472,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
 	mutex_unlock(&flow_indr_block_lock);
 
+	tcf_action_reoffload_cb(cb, cb_priv, false);
 	flow_block_indr_notify(&cleanup_list);
 	kfree(indr_dev);
 }
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 75f34e6fdea0..0103e44e241f 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -137,6 +137,19 @@ static void offload_action_hw_count_set(struct tc_action *act,
 	act->in_hw_count = hw_count;
 }
 
+static void offload_action_hw_count_inc(struct tc_action *act,
+					u32 hw_count)
+{
+	act->in_hw_count += hw_count;
+}
+
+static void offload_action_hw_count_dec(struct tc_action *act,
+					u32 hw_count)
+{
+	act->in_hw_count = act->in_hw_count > hw_count ?
+			   act->in_hw_count - hw_count : 0;
+}
+
 static unsigned int tcf_offload_act_num_actions_single(struct tc_action *act)
 {
 	if (is_tcf_pedit(act))
@@ -183,9 +196,8 @@ static int offload_action_init(struct flow_offload_action *fl_action,
 	return -EOPNOTSUPP;
 }
 
-static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
-				  u32 *hw_count,
-				  struct netlink_ext_ack *extack)
+static int tcf_action_offload_cmd_ex(struct flow_offload_action *fl_act,
+				     u32 *hw_count)
 {
 	int err;
 
@@ -200,9 +212,37 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
 	return 0;
 }
 
-/* offload the tc action after it is inserted */
-static int tcf_action_offload_add(struct tc_action *action,
-				  struct netlink_ext_ack *extack)
+static int tcf_action_offload_cmd_cb_ex(struct flow_offload_action *fl_act,
+					u32 *hw_count,
+					flow_indr_block_bind_cb_t *cb,
+					void *cb_priv)
+{
+	int err;
+
+	err = cb(NULL, NULL, cb_priv, TC_SETUP_ACT, NULL, fl_act, NULL);
+	if (err < 0)
+		return err;
+
+	if (hw_count)
+		*hw_count = 1;
+
+	return 0;
+}
+
+static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  u32 *hw_count,
+				  flow_indr_block_bind_cb_t *cb,
+				  void *cb_priv)
+{
+	return cb ? tcf_action_offload_cmd_cb_ex(fl_act, hw_count,
+						 cb, cb_priv) :
+		    tcf_action_offload_cmd_ex(fl_act, hw_count);
+}
+
+static int tcf_action_offload_add_ex(struct tc_action *action,
+				     struct netlink_ext_ack *extack,
+				     flow_indr_block_bind_cb_t *cb,
+				     void *cb_priv)
 {
 	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
@@ -231,9 +271,10 @@ static int tcf_action_offload_add(struct tc_action *action,
 		goto fl_err;
 	}
 
-	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
+	err = tcf_action_offload_cmd(fl_action, &in_hw_count, cb, cb_priv);
 	if (!err)
-		offload_action_hw_count_set(action, in_hw_count);
+		cb ? offload_action_hw_count_inc(action, in_hw_count) :
+		     offload_action_hw_count_set(action, in_hw_count);
 
 	if (skip_sw && !tc_act_in_hw(action))
 		err = -EINVAL;
@@ -246,6 +287,13 @@ static int tcf_action_offload_add(struct tc_action *action,
 	return err;
 }
 
+/* offload the tc action after it is inserted */
+static int tcf_action_offload_add(struct tc_action *action,
+				  struct netlink_ext_ack *extack)
+{
+	return tcf_action_offload_add_ex(action, extack, NULL, NULL);
+}
+
 int tcf_action_update_hw_stats(struct tc_action *action)
 {
 	struct flow_offload_action fl_act = {};
@@ -258,7 +306,7 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 	if (err)
 		return err;
 
-	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
+	err = tcf_action_offload_cmd(&fl_act, NULL, NULL, NULL);
 	if (!err) {
 		preempt_disable();
 		tcf_action_stats_update(action, fl_act.stats.bytes,
@@ -277,7 +325,9 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 }
 EXPORT_SYMBOL(tcf_action_update_hw_stats);
 
-static int tcf_action_offload_del(struct tc_action *action)
+static int tcf_action_offload_del_ex(struct tc_action *action,
+				     flow_indr_block_bind_cb_t *cb,
+				     void *cb_priv)
 {
 	struct flow_offload_action fl_act = {};
 	u32 in_hw_count = 0;
@@ -290,16 +340,25 @@ static int tcf_action_offload_del(struct tc_action *action)
 	if (err)
 		return err;
 
-	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, NULL);
-	if (err)
+	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, cb, cb_priv);
+	if (err < 0)
 		return err;
 
-	if (action->in_hw_count != in_hw_count)
+	if (!cb && action->in_hw_count != in_hw_count)
 		return -EINVAL;
 
+	/* do not need to update hw state when deleting action */
+	if (cb && in_hw_count)
+		offload_action_hw_count_dec(action, in_hw_count);
+
 	return 0;
 }
 
+static int tcf_action_offload_del(struct tc_action *action)
+{
+	return tcf_action_offload_del_ex(action, NULL, NULL);
+}
+
 static void tcf_action_cleanup(struct tc_action *p)
 {
 	tcf_action_offload_del(p);
@@ -794,6 +853,59 @@ EXPORT_SYMBOL(tcf_idrinfo_destroy);
 
 static LIST_HEAD(act_base);
 static DEFINE_RWLOCK(act_mod_lock);
+/* since act ops id is stored in pernet subsystem list,
+ * then there is no way to walk through only all the action
+ * subsystem, so we keep tc action pernet ops id for
+ * reoffload to walk through.
+ */
+static LIST_HEAD(act_pernet_id_list);
+static DEFINE_MUTEX(act_id_mutex);
+struct tc_act_pernet_id {
+	struct list_head list;
+	unsigned int id;
+};
+
+static int tcf_pernet_add_id_list(unsigned int id)
+{
+	struct tc_act_pernet_id *id_ptr;
+	int ret = 0;
+
+	mutex_lock(&act_id_mutex);
+	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+		if (id_ptr->id == id) {
+			ret = -EEXIST;
+			goto err_out;
+		}
+	}
+
+	id_ptr = kzalloc(sizeof(*id_ptr), GFP_KERNEL);
+	if (!id_ptr) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+	id_ptr->id = id;
+
+	list_add_tail(&id_ptr->list, &act_pernet_id_list);
+
+err_out:
+	mutex_unlock(&act_id_mutex);
+	return ret;
+}
+
+static void tcf_pernet_del_id_list(unsigned int id)
+{
+	struct tc_act_pernet_id *id_ptr;
+
+	mutex_lock(&act_id_mutex);
+	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+		if (id_ptr->id == id) {
+			list_del(&id_ptr->list);
+			kfree(id_ptr);
+			break;
+		}
+	}
+	mutex_unlock(&act_id_mutex);
+}
 
 int tcf_register_action(struct tc_action_ops *act,
 			struct pernet_operations *ops)
@@ -812,18 +924,31 @@ int tcf_register_action(struct tc_action_ops *act,
 	if (ret)
 		return ret;
 
+	if (ops->id) {
+		ret = tcf_pernet_add_id_list(*ops->id);
+		if (ret)
+			goto err_id;
+	}
+
 	write_lock(&act_mod_lock);
 	list_for_each_entry(a, &act_base, head) {
 		if (act->id == a->id || (strcmp(act->kind, a->kind) == 0)) {
-			write_unlock(&act_mod_lock);
-			unregister_pernet_subsys(ops);
-			return -EEXIST;
+			ret = -EEXIST;
+			goto err_out;
 		}
 	}
 	list_add_tail(&act->head, &act_base);
 	write_unlock(&act_mod_lock);
 
 	return 0;
+
+err_out:
+	write_unlock(&act_mod_lock);
+	if (ops->id)
+		tcf_pernet_del_id_list(*ops->id);
+err_id:
+	unregister_pernet_subsys(ops);
+	return ret;
 }
 EXPORT_SYMBOL(tcf_register_action);
 
@@ -842,8 +967,11 @@ int tcf_unregister_action(struct tc_action_ops *act,
 		}
 	}
 	write_unlock(&act_mod_lock);
-	if (!err)
+	if (!err) {
 		unregister_pernet_subsys(ops);
+		if (ops->id)
+			tcf_pernet_del_id_list(*ops->id);
+	}
 	return err;
 }
 EXPORT_SYMBOL(tcf_unregister_action);
@@ -1595,6 +1723,96 @@ static int tcf_action_delete(struct net *net, struct tc_action *actions[])
 	return 0;
 }
 
+static int
+tcf_reoffload_del_notify(struct net *net, struct tc_action *action)
+{
+	size_t attr_size = tcf_action_fill_size(action);
+	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
+		[0] = action,
+	};
+	const struct tc_action_ops *ops = action->ops;
+	struct sk_buff *skb;
+	int ret;
+
+	skb = alloc_skb(attr_size <= NLMSG_GOODSIZE ? NLMSG_GOODSIZE : attr_size,
+			GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
+	if (tca_get_fill(skb, actions, 0, 0, 0, RTM_DELACTION, 0, 1) <= 0) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	ret = tcf_idr_release_unsafe(action);
+	if (ret == ACT_P_DELETED) {
+		module_put(ops->owner);
+		ret = rtnetlink_send(skb, net, 0, RTNLGRP_TC, 0);
+	} else {
+		kfree_skb(skb);
+	}
+
+	return ret;
+}
+
+int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+			    void *cb_priv, bool add)
+{
+	struct tc_act_pernet_id *id_ptr;
+	struct tcf_idrinfo *idrinfo;
+	struct tc_action_net *tn;
+	struct tc_action *p;
+	unsigned int act_id;
+	unsigned long tmp;
+	unsigned long id;
+	struct idr *idr;
+	struct net *net;
+	int ret;
+
+	if (!cb)
+		return -EINVAL;
+
+	down_read(&net_rwsem);
+	mutex_lock(&act_id_mutex);
+
+	for_each_net(net) {
+		list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+			act_id = id_ptr->id;
+			tn = net_generic(net, act_id);
+			if (!tn)
+				continue;
+			idrinfo = tn->idrinfo;
+			if (!idrinfo)
+				continue;
+
+			mutex_lock(&idrinfo->lock);
+			idr = &idrinfo->action_idr;
+			idr_for_each_entry_ul(idr, p, tmp, id) {
+				if (IS_ERR(p) || tc_act_bind(p->tcfa_flags))
+					continue;
+				if (add) {
+					tcf_action_offload_add_ex(p, NULL, cb,
+								  cb_priv);
+					continue;
+				}
+
+				/* cb unregister to update hw count */
+				ret = tcf_action_offload_del_ex(p, cb, cb_priv);
+				if (ret < 0)
+					continue;
+				if (tc_act_skip_sw(p->tcfa_flags) &&
+				    !tc_act_in_hw(p))
+					tcf_reoffload_del_notify(net, p);
+			}
+			mutex_unlock(&idrinfo->lock);
+		}
+	}
+	mutex_unlock(&act_id_mutex);
+	up_read(&net_rwsem);
+
+	return 0;
+}
+
 static int
 tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 	       u32 portid, size_t attr_size, struct netlink_ext_ack *extack)
-- 
2.20.1

