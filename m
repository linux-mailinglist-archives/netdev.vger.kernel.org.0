Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AB44B9DD0
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbiBQK5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:57:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbiBQK5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:57:34 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2125.outbound.protection.outlook.com [40.107.100.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FCB6589
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSof1ue5jMQe6FfZMxtPzypKRfmQaPbZ+rZ37aoetXhGFcOrQdt0LAhzyb6UfIXnD7Y4+a2Hr18JJeBWGCPZ29oW7PN7OstSjjQLqFwWyuvdRlf3vHgadIE5o3iY+FnnDMJmHfPd71XHRMVYH2IwnK3bJlD2WNDj8CkTHlzNnkx6FQsWuUnvudwfqrNP0WadfldgFjeYCM120fH5bXLkTf3iKClN7TZ5SEuvWaPCVOpJ+288cDTtvXTHdul+HIBm4ujvqepaAv6RoQBqYZZ90G9FGlNDmtp4U0mjAWaEpor5sXhyHmwnlVqBDZxI6RO0PeF0ooX8zIbaW2YeFdaOOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faMcEoGbYdrAHuaPuJoPeflXsHdX5yHik8mZ577dQqM=;
 b=DEeL/lrsMPNB7xZg89jXNxTkZUviHSJ3pO1aUcVLSQwKTKEAO6E2cnjxgDJmnEypENOrzCXklEv/Zo0Vw7xEby2Cycwkp80nl9JuPTSsy1at+FTOcF7OigmcSr2zUxQlQ8kyFpyG7vHp8Bmad0mahRmgK0wcjNOO0DqE5fl6/w6aZOAp3FHRrU6jxTxjUWo5ms2A1L17YLSy10yYh9nDCCFYjvudbiT00oqyMz7J++fvx4hQts7fu0zie5d8g+jYzYJGTub49vazvyXkYOjJpe3dkF0305rP6dKbcTC536WLe/5DbVAXufXf9sumcKegd1IJG+bB7VoB33C1OfaJYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faMcEoGbYdrAHuaPuJoPeflXsHdX5yHik8mZ577dQqM=;
 b=dgJ2xkVbfIcCHdiSmcRJM6Tmfgmei1XUaNGqGbpVu1RxdZtbPrlOnw/JDqc/GhcKvnRRakanJPjZ2Sm1etMJg5tKzuyR1zjyKNHlJPoG9tSoa/rI5md+Bnyx7dk2Cs4gXky5VHTp/uN/MDIBwunND5MqwaYYO5xifbeW60J0cZk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1397.namprd13.prod.outlook.com (2603:10b6:903:136::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Thu, 17 Feb
 2022 10:57:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.015; Thu, 17 Feb 2022
 10:57:18 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 4/6] nfp: add process to get action stats from hardware
Date:   Thu, 17 Feb 2022 11:56:50 +0100
Message-Id: <20220217105652.14451-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220217105652.14451-1-simon.horman@corigine.com>
References: <20220217105652.14451-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0081.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ace2d49f-0d1e-4af2-e0e7-08d9f20443e6
X-MS-TrafficTypeDiagnostic: CY4PR13MB1397:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1397B18C594191EF56F8F2D4E8369@CY4PR13MB1397.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:196;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62/w8u6s6yI5GjhZzqrr6hiRNvuJMoJCpFh0Wc9FBPDmMzY3ogKZxkJG8DbrVcyV53nj7kVzBA9/74Jhgl8sNWl3xbRSO/fJ1g+Xr3vEya+7O63xLPy/tcMHyzeRHiomC4V0wOFNOVqxAcCZGSn4QFfEb6qxpQgkm9s6fXptnf+PxBEk6CfK8e8lIo3H+lwvMFCicF1FhG3OkPoYEQ8IBQ/2WeXWS3wGeh1ia0UHQaBXTwLZpXBRDR0YaFMkiwawWXxp/HzoFgst5XvQrVBnS43p3WqHefkCcgKpqyd5QN4+HZ+Dl8gScIZPRfsHPlq/iXe7H7PSYCpC3F5LSNAxKPA5dbP7wmGgrVbeHvz+QH0q4C05rdidKQBWpv2CrwN8nwjFIPbENvBN6Yz/QeDsn0lF2Cggguzs2m+o/vmlUJugvQpD4lx8bSoJP0I/Q3rpEU4HfGJRedp2rK65140iYAW9In4oDGswaS89VDIgWINNvLSrYD/qz95hQZnAdZ5WbAqh8zP+9T6/9X3Eb+n04HMOYYpRLfxRUmd3lDadEaJt/x+kFCVWd9bpKWjnCK9C1ALg+OnCoMSHTFarTf7lLljJziGnkuKh+9oVDS7r0crSh6MYJoeA+oRbt3u7nWWkM7KFtMmMRW1E3PUfHGoiLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(39840400004)(136003)(396003)(376002)(366004)(8676002)(66476007)(316002)(1076003)(6666004)(6506007)(2616005)(54906003)(186003)(52116002)(38100700002)(6512007)(66946007)(66556008)(4326008)(86362001)(110136005)(6486002)(83380400001)(508600001)(107886003)(44832011)(36756003)(2906002)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ynacC6AGMgAgw1SbVjQzTn4I9DN/a/PJF9ms1mp6qdVTH9WWI3rf48+lx4HZ?=
 =?us-ascii?Q?2K9o4Jukp5DyM+KpN5ZnxY7SMC9N3+QEFVWgLVWtO0WWbVzbXc3lXs57/QvP?=
 =?us-ascii?Q?inPdB8EACrUlY5f3JmqH9ISdxefEKf/Ae5U2IxxE0kKhXU5QvFMb7JKromcg?=
 =?us-ascii?Q?pr4d0bSc/5rqyy4L1747aC6wX01/sPBzrMF0xRCCG5DH4+hL0oyDvCsPSm1T?=
 =?us-ascii?Q?f1Ava7BwLCG0IkBHmGD/EoV6EDiIxw0sZy4XoguGzH0Ga5zNOWyxm1Ry7I4Z?=
 =?us-ascii?Q?7dNylDzIEwmxtJlIuSnXbegqUytfqktZZ6xwgncE9ztBggRYHGIKHLXVDjF6?=
 =?us-ascii?Q?YCFbB9aSFG0xVfg7g0U0OKGlB6gBTez1Qy1h8gQ3SZvHvXpnz5xzt+HDz01d?=
 =?us-ascii?Q?ZnwfBoUP8r6dcaeBf/S8bxcKLoW/rjVHCc6Y9HREX8YeNohcvo1LQTyzeaCT?=
 =?us-ascii?Q?D5z2mrFIjvvzrTwLR53LzZfJeVyK8a9elSZw0sD0CRBCoCjCdJqa/88aVa3D?=
 =?us-ascii?Q?OJzSEcKz7vlYohvd0TLTk488YuJ0B/RPYfjrKtZbaNeFTHH0g85IxBW2xH7R?=
 =?us-ascii?Q?pbp0kuyg+t7E+kvTa7MtCgJ9TOuf0BkB5t8+fNNOYY9ekyo0UXv3sD1LTcdc?=
 =?us-ascii?Q?9OCZayJMFXQxcGToBECcvKokzDUaBhyr7w1dVqzyjhwCR3yxP9Few0B16FHl?=
 =?us-ascii?Q?JVTPG/FvSYK3jCx7Ex6iw68fDrYaMjVZG4MNLzl1XSGt+U7LpcGOA/zAokf8?=
 =?us-ascii?Q?TI1W7jkDV0E9vLdK0CVyEsKDla7yYCNbV7v5FTHrSOM5/bvu048FtdoiXZda?=
 =?us-ascii?Q?j3+KLmN3PUThEkfoeLk6ZXm7n5TRj+eno0xKuHJyZXa2i0rrLCjyNynHnmPk?=
 =?us-ascii?Q?GX8okssczqwfm3z346Syqgzus0VuPDuZHbVvTwbef5z6iS+AjgCbD2gv/ZKE?=
 =?us-ascii?Q?pVWhlsukhckk5zcnuMKPkIt2ktz7FdUFxUiTtYCAOwFQedJB/WR3Q8OFXX+z?=
 =?us-ascii?Q?sl07VoTPyNRVJRmBMrhTR57HKCAbLA15N5A4R+oGZtGQDB2ME2BOQ4PikFGj?=
 =?us-ascii?Q?AIuH845uWMaPhKPGmp+6yWYcoyffY7x+mkI++HvAdX7+x8WRC0a+cnMmukAA?=
 =?us-ascii?Q?Pe9qsIocSPpuoBijeJeqNfPZSG7RRDjzehw66NAHz4PzTkVzbbMeWRiaa1rY?=
 =?us-ascii?Q?WL1cupHs5hbSTr81UssIRg6zhxq9kV6VFQyJCVPuHsOjkpk9GXK72arF8D8K?=
 =?us-ascii?Q?RCtlKOFs/iYSk68Hk21pAI5OcYwz5cLco4gy3lw8G5+Yu3kq79o6Aps9zVq3?=
 =?us-ascii?Q?4PdKx9dr2QHHjd2SGlX1OayW7DAFMri2MIVvzQ3tU69/gFzznWDi0PIdR3qs?=
 =?us-ascii?Q?kkHkxptPXD3ZUnzaTh3R+bLUxE8RvN/lYoo0stfRYrtHP1vzQAs9Eq6W7J7w?=
 =?us-ascii?Q?MIsejMJkDMEy2Vo4J7yiN3NJwGop1C3FE3unHHgupiKd5Ryv+tEAiV6jAK6e?=
 =?us-ascii?Q?/AtDOtxexpXqTfWI7QQ7R9ALkv+i03/Y1usNp/OLI4F6OBl5dPkioRbSiuLF?=
 =?us-ascii?Q?gp+orJ1iTDUU2Qinf3zFZm029O/QpWTJsKB8+sJ4jrs9hToz6EYdgmRkliRe?=
 =?us-ascii?Q?VYPqjU6PLr3LtEZxpPYb41hUf28Cyd2NbLKspGdIs7HJUqcgxYdbm5mzS087?=
 =?us-ascii?Q?GNrJBdxU9UtW3EIEkZ+iK2s0YYNtFQS9thd7UiAS2fR8xWBk+O+62xjwH9o6?=
 =?us-ascii?Q?tr9fvS+lfTsj/aUlGY8u5yWV1/JFeCE=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace2d49f-0d1e-4af2-e0e7-08d9f20443e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 10:57:18.4974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FrfJSEu3lwayBxzsSyAzjpWwOh46Cd4bWTVh1MFvTHk26efk+tESnANhIzJ0ZPM7JrYI1JBppVxLocFAHQJf2yXZ8HVLETda4QsZYH74yII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1397
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
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 117 +++++++++++++++++-
 2 files changed, 115 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 0c28e3414b7f..73bb76a938a2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -606,7 +606,8 @@ nfp_flower_update_merge_stats(struct nfp_app *app,
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
index f9f9e506b303..632513b4f121 100644
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
 
@@ -607,6 +618,29 @@ int nfp_init_meter_table(struct nfp_app *app)
 
 	return rhashtable_init(&priv->meter_table, &stats_meter_table_params);
 }
+
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
@@ -706,6 +740,79 @@ nfp_act_remove_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
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
+		goto ret;
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
+ret:
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
+		goto ret;
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
+ret:
+	mutex_unlock(&fl_priv->meter_stats_lock);
+
+	return err;
+}
+
 int nfp_setup_tc_act_offload(struct nfp_app *app,
 			     struct flow_offload_action *fl_act)
 {
@@ -720,6 +827,8 @@ int nfp_setup_tc_act_offload(struct nfp_app *app,
 		return nfp_act_install_actions(app, fl_act, extack);
 	case FLOW_ACT_DESTROY:
 		return nfp_act_remove_actions(app, fl_act, extack);
+	case FLOW_ACT_STATS:
+		return nfp_act_stats_actions(app, fl_act, extack);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.20.1

