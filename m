Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EDB63246D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiKUN4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiKUN4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:23 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976C7C1F7E
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnMDVXgqv9OcFvPPVlliLdup6PgEQH/7QYknvc7DTW+xW7jK69h4X1UT62KvJ0goZChkGmoN5MLkdIU1Ta1QfTbFYr232MkSrTsVmVku/eIT3sJopYfM3QMWHGy/muOEv94TsTPNSN6QfFd6UJz8xf03BOVs/HD3iQuls07nCOaFHwILv94DCoAoNyVmcJcSwRiBVI4v1rfvaZkWA+I1d0eI5kFV6WLmwH4De4DZHapadRC+qOt3aARY1q53Tzk9nrPat4Ehh2bUfGgOkiWu32qDsvMtP6Vxgke5pt5wKpwz/Dqm7InBEnkSKvYLtpZDNtsr41rmDUvoInAuAu93tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWqkGudtKSV4LI+klLeRXn8Ix13BrTUlMb7Fl3jQKSE=;
 b=kn408as+5VepeW2Adpvx5B+r0tOpjjHYjxHrJsN3zvx4QdKT09WkMhZ1vtLiuW4TUkhL+N1JYaBmpNkP/rTjL3ZUDWd98COyZ80oFqasvzHASRz4gWpVZhs3Nzx1RxzU7AgTWxb2+I3horSoAsSY65BdgMo/4TXK7KRQLTB4Zh8fHC5lcUnwbtnoMFOPh6rRjgKHkAEJ7r8tc91MbiNp4jyt4rwg1Na3eZUGPcUJwwXbhR56nTaoEWZaPOz3eNHKgpT3rXbZWzAIwto6GyBrBgzZhj9ZvKvD5Fs7hyp/xhUi9Gv6CuaZD/wKVARb3B5tx0Yg1EiMnaYgkOenetwAiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWqkGudtKSV4LI+klLeRXn8Ix13BrTUlMb7Fl3jQKSE=;
 b=GfElWm0Vos243cnwaawj+mYRklv6cN8X14wbPemGnyHfIqP0UE7KmLgazog4Y+t9h4oxFJR9YcseZ9ooMEWMvPgIjFHr2doVX+rvN9YU/QRK3lsTKGqt2FbQML6iDbNy8TpeULK7YKTh+X4W8zqqzYbgjZUxi+Mq+MJVoY4O8+o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 06/17] net: dsa: move headers exported by port.c to port.h
Date:   Mon, 21 Nov 2022 15:55:44 +0200
Message-Id: <20221121135555.1227271-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: da37e2b1-3d6c-4880-4f2d-08dacbc828b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bxKfXgLpiVJOcNIyuasP3M+XaGa/AJF5dQ2cv8MWa7vdi0f3Tfo6/Sw8lYtC1iXUtoQateF7NdbHUeoSeCsvbgBs2UQl1wpXKqnUxyF0Ms4DbLk4Hmyk3qzz4Ay5dpIuEmm6FHq70vJlE3AK8Y1JbmVGVZRVMQuVcZcNHRHBEuROVKebF5PL5yGHazHDZR8ex9CTt9VDQBAawEhxVRTynfySdBu6d1b0xg+DOjWvtxJHIK1nxtsDpWybZTXhFSjA3B4aYRljECWtHIXKQkISwps6GP3d9VoDpfsgke8Lx9lEUnSqNUyXIPvwxcseBcmr4ZDx+aKsqZUNKaz6GhuZMLHWpDJ8Ul7Oemuhma0kHKS4VUvoFGpLzrLPAAi/UcU7AnI8GE+xAuvJjd/6w1M78yyYTa4yQKraYd60170NkPmg0Y4Zqs/bo9sELGVwtwi7rgy5jfjzUk/PL1gZsGvcAMVALGQRJDEan1aJxHbk+KfYzvxmPQjsGz6Tk/fYUmdeo04A/el5CBlOINdtFDF+S7CQe2nrLRrFBYM4gDiFTZp9g9sC+HPMa75hKHfXLBVRKEcyRN++hSPPDpjF4+PMDQJbLi1Xrs/QmXWtnImSi66K/BtVkxR6PGeC0AElULIWAWsk+1ughPGr8/ilrbcgom6FtgG92ycg1xvfdzq8Qr3qAeXQ7D8Vba5gVSnVTptA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(30864003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BGWtlytC9DiujRqvu+t5DDj2QYKwjqkeSXCQfzO4cScSJybzEf+YEA+iIGI9?=
 =?us-ascii?Q?g3hTA5ynF6N0AIeIY6Y2WUPJGklGj5OzC87C8f3AhCHDqNq8KMl8rC5wkUwr?=
 =?us-ascii?Q?ewEQD+QL48l8JU3HvQ2uI+0MEtzzc/jduieRtq+Mq59kU/UghmfvtJ1Sl+VI?=
 =?us-ascii?Q?8A0afsFQV4tjCKFjongknCtHDRo1gt2Oq/vhatwD6pe7Tic4Wwb6QCjB0/wc?=
 =?us-ascii?Q?kK130lxfLoEj0FmunEKY1IQZP/Z//waLTgamnwHtXaAUZ5SPNnXc95cQGnL2?=
 =?us-ascii?Q?hAlY+RIFDmnbT3dZRvTOnHoZL+O613XOcGQSxctodyBdmMvkn6F93+NTumfC?=
 =?us-ascii?Q?mc4cLIrV0cl+V/LSd3EQWvNHOkTIAt8ef7TIt941f8jXhG/uivDxw1dj09WQ?=
 =?us-ascii?Q?NJ9uvm3xknRhPeotc5hrzjl3Td3x9/1bRgylNrHZtkUiZL3pkRYmgW0QTb+B?=
 =?us-ascii?Q?WoE3PNlDyPqINvvbf7UHzuGPs82zcO+FW7UjDZLnnpa0TYjzfU31Eos+kVyF?=
 =?us-ascii?Q?QKIVblyVrb9J8iDc139Fwat/1IG41euGZTWEmCRn/Gwb6JYWkpNaLBLbf/B2?=
 =?us-ascii?Q?kJ0dPdA2EuUqnovC1wB/Ti2bdrwjmeYemyAJLP7lYfW1MVSEOws/igPJhFn+?=
 =?us-ascii?Q?IpaT5XaI/BSh5XZOR3HSduv5RHk8XVcrwF78ITsImabCoLzsXWoWfJAOaFUS?=
 =?us-ascii?Q?z/zSKAzh5qrkpxfT4kmjxXAML4F8uaep7GMmOmlfYeJBrxuxczeVLuf6wH8J?=
 =?us-ascii?Q?xU1Vn0BFs6L/w2y5TEDrl7B/Jgpnzn3yw2HtXyEyXZxmRZO1I5VRzBgYqSoE?=
 =?us-ascii?Q?i+Ok2Mmr1A/gFSGk8uYK/GZFBm6Kx/E7ImD5HUXqh39MQjaxL6xREqy8i/qx?=
 =?us-ascii?Q?AR+pm76xpw9I6XVSMNPpRLgsfWEuNV+LdzeNC9wHa57koohTBNVoHvMrme2o?=
 =?us-ascii?Q?hnqi1Qyb7snvwd2mCkdHEpfeO4omPZPUDjiM1Qkme2WCxnzXejWNiPxk8RNS?=
 =?us-ascii?Q?nZHnAbdzt6wd9zRg8eV0ITkLRuNjKmRVo9Gqj+XcNVH8/ksD2QQ93007QAjY?=
 =?us-ascii?Q?PRhH2lbuoWxt5XGOcrBM+c9wuAhuO/rdDYvXt5teYU3DVMuiWRx/4jM7h+5D?=
 =?us-ascii?Q?ecfgf4mIndsR3evfV3fOTbw0JgEjseekMa/XwsD6rnk3NyC3qCEA3gtQg89d?=
 =?us-ascii?Q?9aT634a2k0I45c1Ii2K3TsDhZyhVVt0S0N86s42O/5tUGXvArYxqBdQZSWMl?=
 =?us-ascii?Q?TmtfRjIuhg3oIUzWETIZQRnfA2N5KDZTroh9A1+2HDq1qEr94oft3Lko4zcx?=
 =?us-ascii?Q?sWDyfKYC6NnlzA/tCwdMovPxjvMXYiaAM+rpmdw/GqjUubZ+aqrXGshhn8jh?=
 =?us-ascii?Q?L1dL9z+rGRn0W5jhfWPihi2YSMLKGW+O6Q+CSCAv9LUK2YQZODWFa3eJvw8s?=
 =?us-ascii?Q?04ghZNOGsxP7IsZ4xUCPiALj2ImqhWJxhgmq+Thbh2h9NKsfmMPtcnKCyG74?=
 =?us-ascii?Q?OpK7SMwbGCnT2jOMQ6Gr9ha6pcihStk4UXOr3vWu7AmkX9blKYRAxL5Y5are?=
 =?us-ascii?Q?m6wO6wcQ2bi8eOAtDhbb/PnEaWst6hNWJvgsyVGpi/l7urUWPLmVxlq47OEL?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da37e2b1-3d6c-4880-4f2d-08dacbc828b8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:16.5755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbO6dXzB4EWAONOt3WNOE/ByqjxRSgY2bF7QTYW4qa++/3S4G4810NkCO2hLqSHRmyjugdnHu9fmzWXONw9wfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minimize the use of the bloated dsa_priv.h by moving the prototypes
exported by port.c to their own header file.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c      |   1 +
 net/dsa/dsa_priv.h  |  97 -------------------------------------
 net/dsa/master.c    |   1 +
 net/dsa/port.c      |   1 +
 net/dsa/port.h      | 114 ++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c     |   1 +
 net/dsa/switch.c    |   1 +
 net/dsa/tag_8021q.c |   1 +
 8 files changed, 120 insertions(+), 97 deletions(-)
 create mode 100644 net/dsa/port.h

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c0ef49d86381..5a9cf74a0166 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -19,6 +19,7 @@
 
 #include "devlink.h"
 #include "dsa_priv.h"
+#include "port.h"
 
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index c4ea5fda8f14..81ddc52feb94 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -286,103 +286,6 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 /* netlink.c */
 extern struct rtnl_link_ops dsa_link_ops __read_mostly;
 
-/* port.c */
-bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr);
-void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
-			       const struct dsa_device_ops *tag_ops);
-int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
-int dsa_port_set_mst_state(struct dsa_port *dp,
-			   const struct switchdev_mst_state *state,
-			   struct netlink_ext_ack *extack);
-int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
-int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
-void dsa_port_disable_rt(struct dsa_port *dp);
-void dsa_port_disable(struct dsa_port *dp);
-int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
-			 struct netlink_ext_ack *extack);
-void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br);
-void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
-int dsa_port_lag_change(struct dsa_port *dp,
-			struct netdev_lag_lower_state_info *linfo);
-int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
-		      struct netdev_lag_upper_info *uinfo,
-		      struct netlink_ext_ack *extack);
-void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
-void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
-int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
-			    struct netlink_ext_ack *extack);
-bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
-int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
-int dsa_port_mst_enable(struct dsa_port *dp, bool on,
-			struct netlink_ext_ack *extack);
-int dsa_port_vlan_msti(struct dsa_port *dp,
-		       const struct switchdev_vlan_msti *msti);
-int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu);
-int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid);
-int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid);
-int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
-				     const unsigned char *addr, u16 vid);
-int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
-				     const unsigned char *addr, u16 vid);
-int dsa_port_bridge_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-				 u16 vid);
-int dsa_port_bridge_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-				 u16 vid);
-int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-			 u16 vid);
-int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-			 u16 vid);
-int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
-int dsa_port_mdb_add(const struct dsa_port *dp,
-		     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_mdb_del(const struct dsa_port *dp,
-		     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_standalone_host_mdb_add(const struct dsa_port *dp,
-				     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_standalone_host_mdb_del(const struct dsa_port *dp,
-				     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
-				 const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
-				 const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
-			      struct switchdev_brport_flags flags,
-			      struct netlink_ext_ack *extack);
-int dsa_port_bridge_flags(struct dsa_port *dp,
-			  struct switchdev_brport_flags flags,
-			  struct netlink_ext_ack *extack);
-int dsa_port_vlan_add(struct dsa_port *dp,
-		      const struct switchdev_obj_port_vlan *vlan,
-		      struct netlink_ext_ack *extack);
-int dsa_port_vlan_del(struct dsa_port *dp,
-		      const struct switchdev_obj_port_vlan *vlan);
-int dsa_port_host_vlan_add(struct dsa_port *dp,
-			   const struct switchdev_obj_port_vlan *vlan,
-			   struct netlink_ext_ack *extack);
-int dsa_port_host_vlan_del(struct dsa_port *dp,
-			   const struct switchdev_obj_port_vlan *vlan);
-int dsa_port_mrp_add(const struct dsa_port *dp,
-		     const struct switchdev_obj_mrp *mrp);
-int dsa_port_mrp_del(const struct dsa_port *dp,
-		     const struct switchdev_obj_mrp *mrp);
-int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
-			       const struct switchdev_obj_ring_role_mrp *mrp);
-int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
-			       const struct switchdev_obj_ring_role_mrp *mrp);
-int dsa_port_phylink_create(struct dsa_port *dp);
-void dsa_port_phylink_destroy(struct dsa_port *dp);
-int dsa_shared_port_link_register_of(struct dsa_port *dp);
-void dsa_shared_port_link_unregister_of(struct dsa_port *dp);
-int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
-void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
-int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
-void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
-void dsa_port_set_host_flood(struct dsa_port *dp, bool uc, bool mc);
-int dsa_port_change_master(struct dsa_port *dp, struct net_device *master,
-			   struct netlink_ext_ack *extack);
-
 /* slave.c */
 extern struct notifier_block dsa_slave_switchdev_notifier;
 extern struct notifier_block dsa_slave_switchdev_blocking_notifier;
diff --git a/net/dsa/master.c b/net/dsa/master.c
index e24f02743c21..0d3ef591b3b4 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -7,6 +7,7 @@
  */
 
 #include "dsa_priv.h"
+#include "port.h"
 
 static int dsa_master_get_regs_len(struct net_device *dev)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 707bd854cea2..0708fe8d4736 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -13,6 +13,7 @@
 #include <linux/of_net.h>
 
 #include "dsa_priv.h"
+#include "port.h"
 
 /**
  * dsa_port_notify - Notify the switching fabric of changes to a port
diff --git a/net/dsa/port.h b/net/dsa/port.h
new file mode 100644
index 000000000000..9c218660d223
--- /dev/null
+++ b/net/dsa/port.h
@@ -0,0 +1,114 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __DSA_PORT_H
+#define __DSA_PORT_H
+
+#include <linux/types.h>
+#include <net/dsa.h>
+
+struct ifreq;
+struct netdev_lag_lower_state_info;
+struct netdev_lag_upper_info;
+struct netlink_ext_ack;
+struct switchdev_mst_state;
+struct switchdev_obj_port_mdb;
+struct switchdev_vlan_msti;
+struct phy_device;
+
+bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr);
+void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
+			       const struct dsa_device_ops *tag_ops);
+int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
+int dsa_port_set_mst_state(struct dsa_port *dp,
+			   const struct switchdev_mst_state *state,
+			   struct netlink_ext_ack *extack);
+int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
+int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
+void dsa_port_disable_rt(struct dsa_port *dp);
+void dsa_port_disable(struct dsa_port *dp);
+int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
+			 struct netlink_ext_ack *extack);
+void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br);
+void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
+int dsa_port_lag_change(struct dsa_port *dp,
+			struct netdev_lag_lower_state_info *linfo);
+int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
+		      struct netdev_lag_upper_info *uinfo,
+		      struct netlink_ext_ack *extack);
+void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
+void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
+int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
+			    struct netlink_ext_ack *extack);
+bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
+int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
+int dsa_port_mst_enable(struct dsa_port *dp, bool on,
+			struct netlink_ext_ack *extack);
+int dsa_port_vlan_msti(struct dsa_port *dp,
+		       const struct switchdev_vlan_msti *msti);
+int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu);
+int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+		     u16 vid);
+int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+		     u16 vid);
+int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
+				     const unsigned char *addr, u16 vid);
+int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
+				     const unsigned char *addr, u16 vid);
+int dsa_port_bridge_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+				 u16 vid);
+int dsa_port_bridge_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+				 u16 vid);
+int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid);
+int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid);
+int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
+int dsa_port_mdb_add(const struct dsa_port *dp,
+		     const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_mdb_del(const struct dsa_port *dp,
+		     const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_standalone_host_mdb_add(const struct dsa_port *dp,
+				     const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_standalone_host_mdb_del(const struct dsa_port *dp,
+				     const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
+				 const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
+				 const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
+			      struct switchdev_brport_flags flags,
+			      struct netlink_ext_ack *extack);
+int dsa_port_bridge_flags(struct dsa_port *dp,
+			  struct switchdev_brport_flags flags,
+			  struct netlink_ext_ack *extack);
+int dsa_port_vlan_add(struct dsa_port *dp,
+		      const struct switchdev_obj_port_vlan *vlan,
+		      struct netlink_ext_ack *extack);
+int dsa_port_vlan_del(struct dsa_port *dp,
+		      const struct switchdev_obj_port_vlan *vlan);
+int dsa_port_host_vlan_add(struct dsa_port *dp,
+			   const struct switchdev_obj_port_vlan *vlan,
+			   struct netlink_ext_ack *extack);
+int dsa_port_host_vlan_del(struct dsa_port *dp,
+			   const struct switchdev_obj_port_vlan *vlan);
+int dsa_port_mrp_add(const struct dsa_port *dp,
+		     const struct switchdev_obj_mrp *mrp);
+int dsa_port_mrp_del(const struct dsa_port *dp,
+		     const struct switchdev_obj_mrp *mrp);
+int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
+			       const struct switchdev_obj_ring_role_mrp *mrp);
+int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
+			       const struct switchdev_obj_ring_role_mrp *mrp);
+int dsa_port_phylink_create(struct dsa_port *dp);
+void dsa_port_phylink_destroy(struct dsa_port *dp);
+int dsa_shared_port_link_register_of(struct dsa_port *dp);
+void dsa_shared_port_link_unregister_of(struct dsa_port *dp);
+int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
+void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
+int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
+void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
+void dsa_port_set_host_flood(struct dsa_port *dp, bool uc, bool mc);
+int dsa_port_change_master(struct dsa_port *dp, struct net_device *master,
+			   struct netlink_ext_ack *extack);
+
+#endif
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 24d8ad36fc8b..b782a1788f5a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -23,6 +23,7 @@
 #include <linux/netpoll.h>
 
 #include "dsa_priv.h"
+#include "port.h"
 
 static void dsa_slave_standalone_event_work(struct work_struct *work)
 {
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index ce56acdba203..5ece5c5c2acf 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -13,6 +13,7 @@
 #include <net/switchdev.h>
 
 #include "dsa_priv.h"
+#include "port.h"
 
 static unsigned int dsa_switch_fastest_ageing_time(struct dsa_switch *ds,
 						   unsigned int ageing_time)
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 34e5ec5d3e23..a6617d7b692a 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -8,6 +8,7 @@
 #include <linux/dsa/8021q.h>
 
 #include "dsa_priv.h"
+#include "port.h"
 
 /* Binary structure of the fake 12-bit VID field (when the TPID is
  * ETH_P_DSA_8021Q):
-- 
2.34.1

