Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62864C188D
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242782AbiBWQYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241930AbiBWQYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:24:02 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2093.outbound.protection.outlook.com [40.107.223.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0540AC559D
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:23:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8wMCHWul8hg+Vja7iUYXzkS6yQD7CxZ1sCmN1rFgKCwIZifUoJDPpP3tvtM6eLK+Zu2lPeCnu3MyJbbyV1J6SP0gTVuiKZWhPGNbVFP6zxjLGsa1ptfRi0Vp7xSbphLfxGWBh/aTcGuQjYpfMPeEjumrvERZFzKVyLXPdf3KFjdRzubPGj/aNpsSNGmGMuXk4YnKYJ1EeXR1bqimTb+0zPnwu5yVuM8bwdNqPiZPzGQm82+wPwZUXBAxVavjqFf5JXGxzfikl4/QAGO9sQTH6yHxyIKjIuHBOZI1t2Z/Z5Ip1uy9PK/pPIfy24hhqT+NfKVdtiwktotcbAO5eUiJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEw+cHiitn4KCP6THSjan5dR4lU2L84GqqyStEHhsJQ=;
 b=NX+2NaC0B1cGSHPKnLZPSDW4KxG2YJkLr0YYwlYVzFJEuKk5G1/+MegitFNqZr5sn5MkxzUzAxY8CAZmm0A62CSBBYNrNyY1LDaM9Hw79Z06bYO2NZZ+WorudEBJpvebv/etPDgvS9yPLMgRyVLCyZpOXvNgMCdDaVVi/dHPMbhjDuLrSuFwLMKPekVmWTP235btDXcGHDTKRRElnJdKB2jYmBo8CkxHe8iT7a567aAi/HLDxRJBV6HrgYpNNOgzF+AdGozCgLKzmp2ZvdRss1bpFtq1V31+L1g0rtLADdFRyitFnuB7gODTAGEF52pB3WJvl2dXPNOXy5HpNRKd1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEw+cHiitn4KCP6THSjan5dR4lU2L84GqqyStEHhsJQ=;
 b=MGwIycW6bLPqcuymZ2HxUHIbXwkxArdCcjtdXOLLD1YM3d1Y2veOi0W2qhnEXpgkfKyonL0/ANV2qs6FmXO/4sDHrlf3GgnWKE41iX6AlzEmdUP1AA4fJiaaAXDXlUBM/jcci7gvDjuiqJtMqpYz44/EKN6M1qQTfJSIga406nM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1757.namprd13.prod.outlook.com (2603:10b6:300:132::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 16:23:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%6]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 16:23:31 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 4/6] nfp: add process to get action stats from hardware
Date:   Wed, 23 Feb 2022 17:23:00 +0100
Message-Id: <20220223162302.97609-5-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8fd51c75-92fc-4ee1-0de2-08d9f6e8d373
X-MS-TrafficTypeDiagnostic: MWHPR13MB1757:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB1757BE35F314594205F81874E83C9@MWHPR13MB1757.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvCQwve9nHWY5wdC3SeawMRNlhd5o0pYyJ7zxNUMUsizaXDfOKLWLjWC5kdGjNZ1e97+oMcDvJijuEX+X9zealSDOlFQbM2C8MheukkV+iz3dQ7nvY4ocilzewpQTLxw0QCTpmL9WrUiJogRnOD/usTavBG14RM00UbBDMDVWwP3AKc+wGJE+VkLcKdqtXNNZJsXv53LeeLb+J3hrYM3jvLsSju3uyrDo7AcNcI2K95ohIPHEpCvZa89or+Yn+hmxGW2u56NjIFgXmU1YSWHho83UXsNnvgXBEUCRlWkyAzQbI0BKdUHaoeLi7uso7sRf3Sdy6tpo+HLKHTCUvkqOr5PXs1uR15KYAk/aPMxtB+ImUMj1UmuDB3wciDZWPOpwa4sKmiWVORuKP2zi2h60crM6sRZ8kyDHePOhNdBtOFhf1PILnvaUYgu5xDZyFOeym/eln5UyU1Qa7d1J+aM2z+W5uxPNykKFl/+ZAopGjT8gPiNPDnrKRF78RKL5KdpctSaXtaGo9UrjxsSsQ2f8wTfwqU7YrciRGkHoFlru+RiOB9dk9buanWz9MgJRLvqTZwxfTjzyoqyWLD10oj3kzmKZ5KwZdiX9kNcdoSoCvQomtSg5kvMHSoOMjsOdab17O4k2s3gJhShgcr0Ig1zFtHZzvVvvzqp0C+5pH333r8QtQd2KVUvj5ZBFbDty9FuUBJiqLShm79uxEekfvZqtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(136003)(366004)(396003)(39830400003)(8936002)(6506007)(86362001)(508600001)(52116002)(6486002)(36756003)(44832011)(2906002)(5660300002)(54906003)(110136005)(83380400001)(66476007)(1076003)(66556008)(8676002)(2616005)(316002)(66946007)(186003)(38100700002)(107886003)(6512007)(6666004)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5YEMuWHCTX/AqQHcOvqtEzvAwe4RghbRLOCWtdSqvtw0t3SuXriLmzlJ03UQ?=
 =?us-ascii?Q?BOrF+ojafxHboM+SOGUA73NFWEChYJEFTj6G6+Tc30rC369hzuwhkU7Rnv4R?=
 =?us-ascii?Q?jOdL+V70oMUJ+CJ1esXaD2kw5/8cnuLuTMdetLXGFaOorZQeFpJKyTiNdD5y?=
 =?us-ascii?Q?bl1Tab6Ngf3z4+EbMVjADrUe70+KSemXU/QEY8HEHAJgnv8WPY9AyCDjNGz4?=
 =?us-ascii?Q?DxKPmjKSdxUwaZe/4oV6RNWODadMqWCcAy3ve44PVKiKjamdh0RVVTiXrc2+?=
 =?us-ascii?Q?Rqaex87q3D4IQg1seSyf2rQsP6/E0QVW5gKfxcsZo9sOTwo4bHt6pR5JbPI2?=
 =?us-ascii?Q?QbOINnQJ/NI8T4fFF6DXEBzUWVO3zpdBd7eOGgUULldqiaF3QRiPkNRNJCQi?=
 =?us-ascii?Q?7ZXbQpSs+sHWoZHN5rg1e3cQUnO30oRnlEWEkDtK2dIipi1ZdcUD80W7lMDF?=
 =?us-ascii?Q?/wHfq9SfjHlWZc4f7PDXW8pezxUERsUe00eFkV3DV8VjeMYAxGxEq4mAVTlI?=
 =?us-ascii?Q?e5BhI9YwI4qci0a3Oarwg4M9Q9m9Z6GA1eG+XCnz+QTZ1vyZCyjEZSt31JPA?=
 =?us-ascii?Q?qjuHPug+3x54QaKueeztJZn6Qdb49isOQKpZDwysMhq9YZ50ASDPuhOUHGv9?=
 =?us-ascii?Q?pTwhPZgOpvIMzKVfMggrg2GrfThTBjBzi1Ec07dYdjX1OjtLyyAoUMnQKLC2?=
 =?us-ascii?Q?gPAPU6inlcqbwHvzXVsSWfBsyenrZ6FMDweOHwuASLyuVLX25tjH/c2Den7d?=
 =?us-ascii?Q?um2Y2Q/HILNwGONEM0Zsc/2vxx7yaJ7zIMOx12XW8c94nSnGDguu0hZaJi7+?=
 =?us-ascii?Q?PQrQJfQTf7B8H2z2HYf+Yi0CCmhUYPrNSvQJILJzRa0Y43Fs2izPTp7Dx1Di?=
 =?us-ascii?Q?8QeZlgDZ/XHMZGO9QZoeWzG656zSfBLLTgK9eOhNO6K8hNP3svLgqR+s3hUE?=
 =?us-ascii?Q?XrxIN8p5WpPzj64Pn07bvVvMDRrO7ZDcW7g/mAijKvGIz0F8GB6K82oAT2MV?=
 =?us-ascii?Q?1liyTtiuMnPrrvLBTDbCT5yEz1pF/9uR1LKZxiqHvPWVVEVig8u4+xPpXtGT?=
 =?us-ascii?Q?5KF30FQZqqjGZkgVNJVy+ewkiDp2J3KzDRTXSwuZsJbVxXLGBsSMIC/CxOvG?=
 =?us-ascii?Q?KEU997VzAR8oI0dkJARiyyGjmeP7GdWRH+BcjLcTaoW4nlX3hfrDkyiUxtr3?=
 =?us-ascii?Q?vZny+dq2I3Pm8PoASijJHY+Lgcuv8sDCF3xSEssMGU/ApvYSaINeIZg4XUfQ?=
 =?us-ascii?Q?JVgJMreMKhOq/YYJWngSFkZ/sOBRfg6DWiZtPJdZvjRE4m4IyaFsVrGjy/Na?=
 =?us-ascii?Q?8K5zKmfKJo9HQDlysfH/odWNNGIhydU2+FbYAd1yc9MporvnnlwJlCfu4VLJ?=
 =?us-ascii?Q?y0JBYMkDKroYFkqrrQjMCfMzpVtHnLw2p/njIxC/6qm9S7ZraM/lttmyTpnc?=
 =?us-ascii?Q?sLctmV/AhlW/psxIBFR/wCgIuVswnSCh2ZyQywsf4Q7yxs7fKrR9U5vvoMBh?=
 =?us-ascii?Q?syMlkUfnkQMW3AeURWZSLRkGDbotleuoL0W3WcyVwLl1oxVOfFEyP03Vn4Im?=
 =?us-ascii?Q?iJ0QN9306A1TA+ymzwT9ZuK7bB5HVW6s0QEQxvju0VlcjJFF6Dj/HsLWM9sF?=
 =?us-ascii?Q?wvZFAj36U2c+4x8LEQXzsv4vD6u+uMEAaCaeCs4MsiUOv+9NWo1chK2yEq88?=
 =?us-ascii?Q?WU8f7Nkyibv50hSUL6bHnkoYoP0RKJKDIohgh7FRUqBT+K70MC8SRchmjPCJ?=
 =?us-ascii?Q?OeV7gJ3AzA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd51c75-92fc-4ee1-0de2-08d9f6e8d373
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 16:23:29.1420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fhn6RBpo9L0RYVBGvlJTBuwlRtE/yj4QW6Wqa3Bag0GGkdPZ8HKYRxt7MIfzrqsrAdPYztd5yDnUpxT2Eet+7NpdMqoFcK5IX9vktmmV94Q=
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

Add a process to update action stats from hardware.

This stats data will be updated to tc action when dumping actions
or filters.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |   3 +-
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 116 +++++++++++++++++-
 2 files changed, 114 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 7ecba013d2ab..c2888a3bac9a 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -605,7 +605,8 @@ nfp_flower_update_merge_stats(struct nfp_app *app,
 int nfp_setup_tc_act_offload(struct nfp_app *app,
 			     struct flow_offload_action *fl_act);
 int nfp_init_meter_table(struct nfp_app *app);
-
+void nfp_flower_stats_meter_request_all(struct nfp_flower_priv *fl_priv);
+void nfp_act_stats_reply(struct nfp_app *app, void *pmsg);
 int nfp_flower_offload_one_police(struct nfp_app *app, bool ingress,
 				  bool pps, u32 id, u32 rate, u32 burst);
 int nfp_flower_setup_meter_entry(struct nfp_app *app,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 160c3567ec99..286743de8ea4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -304,6 +304,9 @@ void nfp_flower_stats_rlim_reply(struct nfp_app *app, struct sk_buff *skb)
 	u32 netdev_port_id;
 
 	msg = nfp_flower_cmsg_get_data(skb);
+	if (be32_to_cpu(msg->head.flags_opts) & NFP_FL_QOS_METER)
+		return nfp_act_stats_reply(app, msg);
+
 	netdev_port_id = be32_to_cpu(msg->head.port);
 	rcu_read_lock();
 	netdev = nfp_app_dev_get(app, netdev_port_id, NULL);
@@ -335,7 +338,7 @@ void nfp_flower_stats_rlim_reply(struct nfp_app *app, struct sk_buff *skb)
 
 static void
 nfp_flower_stats_rlim_request(struct nfp_flower_priv *fl_priv,
-			      u32 netdev_port_id)
+			      u32 id, bool ingress)
 {
 	struct nfp_police_cfg_head *head;
 	struct sk_buff *skb;
@@ -346,10 +349,15 @@ nfp_flower_stats_rlim_request(struct nfp_flower_priv *fl_priv,
 				    GFP_ATOMIC);
 	if (!skb)
 		return;
-
 	head = nfp_flower_cmsg_get_data(skb);
+
 	memset(head, 0, sizeof(struct nfp_police_cfg_head));
-	head->port = cpu_to_be32(netdev_port_id);
+	if (ingress) {
+		head->port = cpu_to_be32(id);
+	} else {
+		head->flags_opts = cpu_to_be32(NFP_FL_QOS_METER);
+		head->meter_id = cpu_to_be32(id);
+	}
 
 	nfp_ctrl_tx(fl_priv->app->ctrl, skb);
 }
@@ -379,7 +387,8 @@ nfp_flower_stats_rlim_request_all(struct nfp_flower_priv *fl_priv)
 			if (!netdev_port_id)
 				continue;
 
-			nfp_flower_stats_rlim_request(fl_priv, netdev_port_id);
+			nfp_flower_stats_rlim_request(fl_priv,
+						      netdev_port_id, true);
 		}
 	}
 
@@ -397,6 +406,8 @@ static void update_stats_cache(struct work_struct *work)
 			       qos_stats_work);
 
 	nfp_flower_stats_rlim_request_all(fl_priv);
+	nfp_flower_stats_meter_request_all(fl_priv);
+
 	schedule_delayed_work(&fl_priv->qos_stats_work, NFP_FL_QOS_UPDATE);
 }
 
@@ -601,6 +612,28 @@ int nfp_init_meter_table(struct nfp_app *app)
 	return rhashtable_init(&priv->meter_table, &stats_meter_table_params);
 }
 
+void
+nfp_flower_stats_meter_request_all(struct nfp_flower_priv *fl_priv)
+{
+	struct nfp_meter_entry *meter_entry = NULL;
+	struct rhashtable_iter iter;
+
+	mutex_lock(&fl_priv->meter_stats_lock);
+	rhashtable_walk_enter(&fl_priv->meter_table, &iter);
+	rhashtable_walk_start(&iter);
+
+	while ((meter_entry = rhashtable_walk_next(&iter)) != NULL) {
+		if (IS_ERR(meter_entry))
+			continue;
+		nfp_flower_stats_rlim_request(fl_priv,
+					      meter_entry->meter_id, false);
+	}
+
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+	mutex_unlock(&fl_priv->meter_stats_lock);
+}
+
 static int
 nfp_act_install_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 			struct netlink_ext_ack *extack)
@@ -697,6 +730,79 @@ nfp_act_remove_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 	return 0;
 }
 
+void
+nfp_act_stats_reply(struct nfp_app *app, void *pmsg)
+{
+	struct nfp_flower_priv *fl_priv = app->priv;
+	struct nfp_meter_entry *meter_entry = NULL;
+	struct nfp_police_stats_reply *msg = pmsg;
+	u32 meter_id;
+
+	meter_id = be32_to_cpu(msg->head.meter_id);
+	mutex_lock(&fl_priv->meter_stats_lock);
+
+	meter_entry = nfp_flower_search_meter_entry(app, meter_id);
+	if (!meter_entry)
+		goto exit_unlock;
+
+	meter_entry->stats.curr.pkts = be64_to_cpu(msg->pass_pkts) +
+				       be64_to_cpu(msg->drop_pkts);
+	meter_entry->stats.curr.bytes = be64_to_cpu(msg->pass_bytes) +
+					be64_to_cpu(msg->drop_bytes);
+	meter_entry->stats.curr.drops = be64_to_cpu(msg->drop_pkts);
+	if (!meter_entry->stats.update) {
+		meter_entry->stats.prev.pkts = meter_entry->stats.curr.pkts;
+		meter_entry->stats.prev.bytes = meter_entry->stats.curr.bytes;
+		meter_entry->stats.prev.drops = meter_entry->stats.curr.drops;
+	}
+
+	meter_entry->stats.update = jiffies;
+
+exit_unlock:
+	mutex_unlock(&fl_priv->meter_stats_lock);
+}
+
+static int
+nfp_act_stats_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
+		      struct netlink_ext_ack *extack)
+{
+	struct nfp_flower_priv *fl_priv = app->priv;
+	struct nfp_meter_entry *meter_entry = NULL;
+	u64 diff_bytes, diff_pkts, diff_drops;
+	int err = 0;
+
+	if (fl_act->id != FLOW_ACTION_POLICE) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "unsupported offload: qos rate limit offload requires police action");
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&fl_priv->meter_stats_lock);
+	meter_entry = nfp_flower_search_meter_entry(app, fl_act->index);
+	if (!meter_entry) {
+		err = -ENOENT;
+		goto exit_unlock;
+	}
+	diff_pkts = meter_entry->stats.curr.pkts > meter_entry->stats.prev.pkts ?
+		    meter_entry->stats.curr.pkts - meter_entry->stats.prev.pkts : 0;
+	diff_bytes = meter_entry->stats.curr.bytes > meter_entry->stats.prev.bytes ?
+		     meter_entry->stats.curr.bytes - meter_entry->stats.prev.bytes : 0;
+	diff_drops = meter_entry->stats.curr.drops > meter_entry->stats.prev.drops ?
+		     meter_entry->stats.curr.drops - meter_entry->stats.prev.drops : 0;
+
+	flow_stats_update(&fl_act->stats, diff_bytes, diff_pkts, diff_drops,
+			  meter_entry->stats.update,
+			  FLOW_ACTION_HW_STATS_DELAYED);
+
+	meter_entry->stats.prev.pkts = meter_entry->stats.curr.pkts;
+	meter_entry->stats.prev.bytes = meter_entry->stats.curr.bytes;
+	meter_entry->stats.prev.drops = meter_entry->stats.curr.drops;
+
+exit_unlock:
+	mutex_unlock(&fl_priv->meter_stats_lock);
+	return err;
+}
+
 int nfp_setup_tc_act_offload(struct nfp_app *app,
 			     struct flow_offload_action *fl_act)
 {
@@ -711,6 +817,8 @@ int nfp_setup_tc_act_offload(struct nfp_app *app,
 		return nfp_act_install_actions(app, fl_act, extack);
 	case FLOW_ACT_DESTROY:
 		return nfp_act_remove_actions(app, fl_act, extack);
+	case FLOW_ACT_STATS:
+		return nfp_act_stats_actions(app, fl_act, extack);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.30.2

