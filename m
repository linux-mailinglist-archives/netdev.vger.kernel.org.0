Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314065618F0
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbiF3LS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiF3LSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:18:46 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2124.outbound.protection.outlook.com [40.107.21.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67CF4D4DD;
        Thu, 30 Jun 2022 04:18:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyMn+mbXoaZrIiDMaqNp8yztgAOkYZIjb2571kNWKNlgbrwY90bVn3em7dpYx8I4SNrp3V+0pf3zgk7tcir6VBay0NijrkREiSghVqPOimSS90RExg1G55fmSqM+nPLuUQl/6BNcA8Qqj6FQrDcfxrn+h23GI6XyM+41TW/CxYNINIE6Z3IiAg8BeaqivrsDmQuVXhGk6e3PWBy4hrVJsTuEoGCYKHdmLhvQnOg++lP14Ch4yUl2NMmPjAFtqghq2GxOK3y66wjDgq2fOOUqgoU0FtQBbNEg0Zdbib39lhTuGVgSXw4EkwfXttIHGlPa5P3ljPX1fBU9aUITRveopw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7i6VyPo//sqIxslRKpAlUjfBZ2XYWujD1XvkWQw5irg=;
 b=kley2j1XiSko4KO7Y6rT0ofueLKKQ4Hk4n7bhyvL62ujm6ExkRyv+5Nxd1GKWXOeiry9AHjNB68iD6CN4ikGI1sdUBjRn29zFAoYXsOq7VL5+XF5HISkF+jbOPh2wZ4oYBqyI03B1eDAMnL1AlYvZ8FyyfwWPZ0XOw6T4ykBPog8wxZQEow8JLYwh2r5KzjSG458CT7jURCENfvn+3C1rJvirPWffe30uVaz2ZCV11KutAsggwyC+xk057RCvpaTK62bppEey2RU9rh7XPhz6Nq5LtvUzPVgBKta+sGWqy8kwUVFyzOZOWDljGWBPgk9YRQFiD7liZh7uEyLS5KeDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7i6VyPo//sqIxslRKpAlUjfBZ2XYWujD1XvkWQw5irg=;
 b=d4lg0loOAZmm3QyMZnD2bcuvO0vUe1eYAP+9vJa+bPu3ZB3zH84CILA3DOa20UcUvQUKXk3o1pgHE3lrF0VsKVkYvkivzaVuthl1CT3YYAg33fTxXrNYWvs0YxTKipH6+wZU0TwfNBerGD7XsBVPrrkdu3dQ6WCVMfqti3jEQ48=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DB9P190MB1793.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:33d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 11:18:42 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 11:18:42 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, oleksandr.mazur@plvision.eu,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Cc:     lkp@intel.com, linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V3 net-next 4/4] net: marvell: prestera: implement software MDB entries allocation
Date:   Thu, 30 Jun 2022 14:18:22 +0300
Message-Id: <20220630111822.26004-5-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220630111822.26004-1-oleksandr.mazur@plvision.eu>
References: <20220630111822.26004-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::22) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95aeb0d6-84a9-4698-6b5a-08da5a8a49ea
X-MS-TrafficTypeDiagnostic: DB9P190MB1793:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GXZ33BnFP0S7/Qo5u9LuWCMH1uMCYSjZnWGGrqyhNrZfIZ/5KYz4i9/FB5FJjdFapdmp8BmwTwdS0p8jgWBQEmvP0KmTK7MpMK9niuJsTLE3GQXEKBMchQPRnL1qot2pOv/Gd5Df6VLfJauXHQoLfAe+Y0Lma9wCu4HsZEKDRtoj2kir3IErSw1hN/yOWL7AxLCchUCBDiiHQPsUoWp1I6bnnGpRXg3OoO2Y62U7BHEiG3B4liIcmvXDsNQhXJFTnE/fwg5MmY2gmk6l39HCMh1++LOSfw2o9CNTKdUIYcDyUsb47Et+ebEVwg+paFRq5bL/ZUI529Fkn+YkNfNabdyAUhU+Ka2jJwFi5rVuPiTUlMBLOdOB/y4V4drWqYtuluUoTBXPclgUQJXWb3Wrg10tzDWxFrjBqZ3KT7CmRLZzG6TlbPyT7bHBs4fB0TIdejqweBLjat5WnJaj6K3zSl7DEAIfI5WU0zTbHasMTGb+nF+UKqHnBHLvrM1ARLAg6Pm0NHomjJgXchvN1mDZg9DHqDd4SYvOVUb31EbnRMpf1GDB064v8PNbp8/3brtlE5KmmIlYNcAIREyuJTNt94PiweUZLGYnT5dvG+xaFOoDPmh+nQvZrCppcsDfz4vXQTYtfUxrcpp2lWr+MqaOd3I8cqjlLJb3ftR7QkY+Md/3GuGmE34JGsmF/T7BWCMSMgXyebJJGmOwYaBYtvVupjiO1GuCJXL0Zjl3lGBs38ButwHEgbf35KDGuTA0TtmF923+Lhu75gwqPup7KMkD03lxc2WGMnHrJ9D0EfzccgBhj5MXckaKse5mOJ4dK7VS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39830400003)(366004)(376002)(346002)(2616005)(66574015)(86362001)(316002)(41300700001)(478600001)(36756003)(2906002)(38100700002)(110136005)(1076003)(66946007)(52116002)(38350700002)(66556008)(186003)(6512007)(8676002)(83380400001)(4326008)(44832011)(6486002)(5660300002)(26005)(66476007)(30864003)(8936002)(6506007)(107886003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uzjXiTG0oyVPJGl7Sio+Iez+NvntIP5uColEirIQGf116I6xpQHb9D3pCd1z?=
 =?us-ascii?Q?f/SA+kNSjChsBxpbfnsHl0iBshojAGiKI+8yCIrl9riPlXT2kd9RE7p0H1k0?=
 =?us-ascii?Q?u62Z+LwlluKynNP8+WHKHnbXmqj24zTylxK+2GrtYCD5BDfURz5Ie5wkG5Jm?=
 =?us-ascii?Q?rnTztYuGV36JPHBxKSejaELA4dRANdrobRzlAGNXzDWv5cSApR0xxr7yCOk8?=
 =?us-ascii?Q?x5wa2b84wofgMnn1sYTFLXrcMgzSOPUeqFHLABLiFfUcpG25wA/yFhkHM6fU?=
 =?us-ascii?Q?D/K5FWp/aDRNrP1RN7V46/NMB47qaa+oQ5hCqiHj/A08ac9PtkmbXxQh+GUw?=
 =?us-ascii?Q?zee9jpEZeAaD9dlmBkEnCbiF+Tag1tvB8BQwsVLuLNTG+iXP45TkYuxR1QHZ?=
 =?us-ascii?Q?PaARmcjncIrvfEGB3kkpN7tozlpeofLa0c0onCVG5ROvckT6ZpcS7TzYLXyy?=
 =?us-ascii?Q?65s+NhGqqan/KoIkLcjW+ntJeNZUHGW48+d7fBsN/0QWccR5e9CqublE/xoB?=
 =?us-ascii?Q?Saa0jVMr/hFU5MVNKrgt7QYBi+eo3Ud/gxE+Oe3mj6sgZRzkN2mA+tEEsqva?=
 =?us-ascii?Q?yE7rwSdCxEsGQMRlluEpI276L+q/MsoAoi3v8cuZ2SSpLMOgvu02g/1Xb61I?=
 =?us-ascii?Q?ADmguWqaJFpc0kYr/yGV57/DbRaxJmAxwQLCJtk9O73t8gh5iog0rQRmxopG?=
 =?us-ascii?Q?yDFsmCTj8dRosJbOUNr9GnISd+0pn7u+YNGLnB0q6L5XB7b6/zOCcX8NSBLB?=
 =?us-ascii?Q?6IKSn4Rok1JPQmLr2RwBl0hvAh2GXz7i9lyjWYSuPkT5k5CsFP1jDe5yD14w?=
 =?us-ascii?Q?RygKFNLtc7bepye5fdpV1eLplKEoAvL/RSurHsoASUh3dKGl6Cso5+bgOZGo?=
 =?us-ascii?Q?SEeqlHsimjpleVjIsa0RJhnystjBKp/KcEDdYxP0nAeZcdJ7J/zijcMP01SC?=
 =?us-ascii?Q?MhzwhtkGhlJna7kx7mRKIvO5VbDr185MNmp7u80YeEMLX2witzJuOh/a8pPd?=
 =?us-ascii?Q?0WuXbNza0n00wgC1IOA09NPHuhb85r+F/U4tnwFSJHTPm0YytvaEj4qOn78V?=
 =?us-ascii?Q?w009z+62Ptns1yvaKPhkRZAoFF/30tm9vRZIWLYbXBoc3JUJHERlY24CnM1O?=
 =?us-ascii?Q?rTDub1dRhxGaPfm0puDPiYxKnV1nQ1N2WjL9HJQjQuEfUHSkwXLlbN0reCub?=
 =?us-ascii?Q?9kmRhdXG4hDulwk9KkNiQnlxgq3JkkwJX6L1LhhcKVHpnP4puWMqj9oD+3xk?=
 =?us-ascii?Q?jHl3hcLAmeSx/Ov+saFQ35tE7/xuQ6Fvvn8bxtEqtcVd4ALSQwfP+wC6Ymua?=
 =?us-ascii?Q?bke7IiwkB/NoLA4XxEthQIA1TgDXSXAzP8du0rH1y5O4Mfd5d5WKFs7zQ20E?=
 =?us-ascii?Q?tPCRFRmDujEQ8rybRhDluYDnJA50arKWUTZmsIifMLFUKkg6OmC80Y+080/6?=
 =?us-ascii?Q?1yn0ZC+OrkeF6ldJNNNCgF2MPgso31UExQWFRFqsr4EtMTmXxfXdThdNOLTX?=
 =?us-ascii?Q?j8FSaX5WCx2qI4orCTjRrd9VIPYDCQ0vORYts9av89NegdE7x4NtVgAk+V7U?=
 =?us-ascii?Q?6aQlNudkNUYnF49xv+vZ9sVw4bLyGlApF5rNzzirrELTzIejvKycLOBg06sa?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 95aeb0d6-84a9-4698-6b5a-08da5a8a49ea
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 11:18:41.9995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NhYZaBQ7MhCENG7e/2dJVMh7eKnrf3Q35ChfTADKOFbfYexIBEdv/E3s6+qCMOBO8TKPKtcDJL//W3V0bReuEhc9A6KnhUYWAIMxdtmuF2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P190MB1793
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define bridge MDB entry (software entry):
  - entry that get's created upon receiving MDB management events
    (create/delete), that inherently defines a software entry,
    which can be enabled (offloaded to the HW) or disabled (removed
    from HW).
    This separation is done to achieve a better highlevel
    management of HW resources - software MDB entry could exist,
    while it's not necessarily should be configured on the HW.
    For example: by default, the Linux behavior would not replicate
    multicast traffic to multicast group members if there's no
    active multicast router and thus - no actual multicast traffic
    can be received/sent. So, until multicast router appears on the
    system no HW configuration should be applied, although SW MDB entries
    should be tracked.
    Another example would be altering state of 'multicast enabled' on
    the bridge: MC_DISABLED should invoke disabling / clearing multicast
    groups of specified bridge on the HW, yet upon receiving 'multicast
    enabled' event, driver should reconfigure any existing software MDB
    groups on the HW.
    Keeping track of software MDB entries in such way makes it possible
    to properly react on such events.
Define bridge MDB port entry (software entry):
  - entry that helps keeping track (on software - driver - level) of which
    bridge mebemer interface joined any give MDB group;

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   2 +
 .../ethernet/marvell/prestera/prestera_main.c |   8 +
 .../marvell/prestera/prestera_switchdev.c     | 648 +++++++++++++++++-
 3 files changed, 656 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index f22fab02f59c..bff9651f0a89 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -341,6 +341,8 @@ void prestera_router_fini(struct prestera_switch *sw);
 
 struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id);
 
+struct prestera_switch *prestera_switch_get(struct net_device *dev);
+
 int prestera_port_cfg_mac_read(struct prestera_port *port,
 			       struct prestera_port_mac_config *cfg);
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 04abff9b049d..ea5bd5069826 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -106,6 +106,14 @@ struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id)
 	return port;
 }
 
+struct prestera_switch *prestera_switch_get(struct net_device *dev)
+{
+	struct prestera_port *port;
+
+	port = prestera_port_dev_lower_find(dev);
+	return port ? port->sw : NULL;
+}
+
 int prestera_port_cfg_mac_read(struct prestera_port *port,
 			       struct prestera_port_mac_config *cfg)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 7002c35526d2..8ef9fbcf6050 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -39,7 +39,10 @@ struct prestera_bridge {
 	struct net_device *dev;
 	struct prestera_switchdev *swdev;
 	struct list_head port_list;
+	struct list_head br_mdb_entry_list;
+	bool mrouter_exist;
 	bool vlan_enabled;
+	bool multicast_enabled;
 	u16 bridge_id;
 };
 
@@ -48,8 +51,10 @@ struct prestera_bridge_port {
 	struct net_device *dev;
 	struct prestera_bridge *bridge;
 	struct list_head vlan_list;
+	struct list_head br_mdb_port_list;
 	refcount_t ref_count;
 	unsigned long flags;
+	bool mrouter;
 	u8 stp_state;
 };
 
@@ -67,6 +72,43 @@ struct prestera_port_vlan {
 	u16 vid;
 };
 
+struct prestera_br_mdb_port {
+	struct prestera_bridge_port *br_port;
+	struct list_head br_mdb_port_node;
+};
+
+/* Software representation of MDB table. */
+struct prestera_br_mdb_entry {
+	struct prestera_bridge *bridge;
+	struct prestera_mdb_entry *mdb;
+	struct list_head br_mdb_port_list;
+	struct list_head br_mdb_entry_node;
+	bool enabled;
+};
+
+static int
+prestera_mdb_port_addr_obj_add(const struct switchdev_obj_port_mdb *mdb);
+static int
+prestera_mdb_port_addr_obj_del(struct prestera_port *port,
+			       const struct switchdev_obj_port_mdb *mdb);
+
+static void
+prestera_mdb_flush_bridge_port(struct prestera_bridge_port *br_port);
+static int
+prestera_mdb_port_add(struct prestera_mdb_entry *br_mdb,
+		      struct net_device *orig_dev,
+		      const unsigned char addr[ETH_ALEN], u16 vid);
+
+static void
+prestera_br_mdb_entry_put(struct prestera_br_mdb_entry *br_mdb_entry);
+static int prestera_br_mdb_mc_enable_sync(struct prestera_bridge *br_dev);
+static int prestera_br_mdb_sync(struct prestera_bridge *br_dev);
+static int prestera_br_mdb_port_add(struct prestera_br_mdb_entry *br_mdb,
+				    struct prestera_bridge_port *br_port);
+static void
+prestera_mdb_port_del(struct prestera_mdb_entry *mdb,
+		      struct net_device *orig_dev);
+
 static struct workqueue_struct *swdev_wq;
 
 static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
@@ -74,6 +116,49 @@ static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
 static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
 				     u8 state);
 
+static struct prestera_bridge *
+prestera_bridge_find(const struct prestera_switch *sw,
+		     const struct net_device *br_dev)
+{
+	struct prestera_bridge *bridge;
+
+	list_for_each_entry(bridge, &sw->swdev->bridge_list, head)
+		if (bridge->dev == br_dev)
+			return bridge;
+
+	return NULL;
+}
+
+static struct prestera_bridge_port *
+__prestera_bridge_port_find(const struct prestera_bridge *bridge,
+			    const struct net_device *brport_dev)
+{
+	struct prestera_bridge_port *br_port;
+
+	list_for_each_entry(br_port, &bridge->port_list, head)
+		if (br_port->dev == brport_dev)
+			return br_port;
+
+	return NULL;
+}
+
+static struct prestera_bridge_port *
+prestera_bridge_port_find(struct prestera_switch *sw,
+			  struct net_device *brport_dev)
+{
+	struct net_device *br_dev = netdev_master_upper_dev_get(brport_dev);
+	struct prestera_bridge *bridge;
+
+	if (!br_dev)
+		return NULL;
+
+	bridge = prestera_bridge_find(sw, br_dev);
+	if (!bridge)
+		return NULL;
+
+	return __prestera_bridge_port_find(bridge, brport_dev);
+}
+
 static void
 prestera_br_port_flags_reset(struct prestera_bridge_port *br_port,
 			     struct prestera_port *port)
@@ -277,6 +362,8 @@ prestera_port_vlan_bridge_leave(struct prestera_port_vlan *port_vlan)
 	else
 		prestera_fdb_flush_port_vlan(port, vid, fdb_flush_mode);
 
+	prestera_mdb_flush_bridge_port(br_port);
+
 	list_del(&port_vlan->br_vlan_head);
 	prestera_bridge_vlan_put(br_vlan);
 	prestera_bridge_port_put(br_port);
@@ -328,8 +415,10 @@ prestera_bridge_create(struct prestera_switchdev *swdev, struct net_device *dev)
 	bridge->vlan_enabled = vlan_enabled;
 	bridge->swdev = swdev;
 	bridge->dev = dev;
+	bridge->multicast_enabled = br_multicast_enabled(dev);
 
 	INIT_LIST_HEAD(&bridge->port_list);
+	INIT_LIST_HEAD(&bridge->br_mdb_entry_list);
 
 	list_add(&bridge->head, &swdev->bridge_list);
 
@@ -347,6 +436,7 @@ static void prestera_bridge_destroy(struct prestera_bridge *bridge)
 	else
 		prestera_hw_bridge_delete(swdev->sw, bridge->bridge_id);
 
+	WARN_ON(!list_empty(&bridge->br_mdb_entry_list));
 	WARN_ON(!list_empty(&bridge->port_list));
 	kfree(bridge);
 }
@@ -438,6 +528,7 @@ prestera_bridge_port_create(struct prestera_bridge *bridge,
 
 	INIT_LIST_HEAD(&br_port->vlan_list);
 	list_add(&br_port->head, &bridge->port_list);
+	INIT_LIST_HEAD(&br_port->br_mdb_port_list);
 
 	return br_port;
 }
@@ -447,6 +538,7 @@ prestera_bridge_port_destroy(struct prestera_bridge_port *br_port)
 {
 	list_del(&br_port->head);
 	WARN_ON(!list_empty(&br_port->vlan_list));
+	WARN_ON(!list_empty(&br_port->br_mdb_port_list));
 	kfree(br_port);
 }
 
@@ -619,6 +711,8 @@ void prestera_bridge_port_leave(struct net_device *br_dev,
 
 	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 
+	prestera_mdb_flush_bridge_port(br_port);
+
 	prestera_br_port_flags_reset(br_port, port);
 	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
 	prestera_bridge_port_put(br_port);
@@ -730,6 +824,269 @@ static int prestera_port_attr_stp_state_set(struct prestera_port *port,
 	return err;
 }
 
+static int
+prestera_br_port_lag_mdb_mc_enable_sync(struct prestera_bridge_port *br_port,
+					bool enabled)
+{
+	struct prestera_port *pr_port;
+	struct prestera_switch *sw;
+	u16 lag_id;
+	int err;
+
+	pr_port = prestera_port_dev_lower_find(br_port->dev);
+	if (!pr_port)
+		return 0;
+
+	sw = pr_port->sw;
+	err = prestera_lag_id(sw, br_port->dev, &lag_id);
+	if (err)
+		return err;
+
+	list_for_each_entry(pr_port, &sw->port_list, list) {
+		if (pr_port->lag->lag_id == lag_id) {
+			err = prestera_port_mc_flood_set(pr_port, enabled);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+static int prestera_br_mdb_mc_enable_sync(struct prestera_bridge *br_dev)
+{
+	struct prestera_bridge_port *br_port;
+	struct prestera_port *port;
+	bool enabled;
+	int err;
+
+	/* if mrouter exists:
+	 *  - make sure every mrouter receives unreg mcast traffic;
+	 * if mrouter doesn't exists:
+	 *  - make sure every port receives unreg mcast traffic;
+	 */
+	list_for_each_entry(br_port, &br_dev->port_list, head) {
+		if (br_dev->multicast_enabled && br_dev->mrouter_exist)
+			enabled = br_port->mrouter;
+		else
+			enabled = br_port->flags & BR_MCAST_FLOOD;
+
+		if (netif_is_lag_master(br_port->dev)) {
+			err = prestera_br_port_lag_mdb_mc_enable_sync(br_port,
+								      enabled);
+			if (err)
+				return err;
+			continue;
+		}
+
+		port = prestera_port_dev_lower_find(br_port->dev);
+		if (!port)
+			continue;
+
+		err = prestera_port_mc_flood_set(port, enabled);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static bool
+prestera_br_mdb_port_is_member(struct prestera_br_mdb_entry *br_mdb,
+			       struct net_device *orig_dev)
+{
+	struct prestera_br_mdb_port *tmp_port;
+
+	list_for_each_entry(tmp_port, &br_mdb->br_mdb_port_list,
+			    br_mdb_port_node)
+		if (tmp_port->br_port->dev == orig_dev)
+			return true;
+
+	return false;
+}
+
+/* Sync bridge mdb (software table) with HW table (if MC is enabled). */
+static int prestera_br_mdb_sync(struct prestera_bridge *br_dev)
+{
+	struct prestera_br_mdb_port *br_mdb_port;
+	struct prestera_bridge_port *br_port;
+	struct prestera_br_mdb_entry *br_mdb;
+	struct prestera_mdb_entry *mdb;
+	struct prestera_port *pr_port;
+	int err = 0;
+
+	if (!br_dev->multicast_enabled)
+		return 0;
+
+	list_for_each_entry(br_mdb, &br_dev->br_mdb_entry_list,
+			    br_mdb_entry_node) {
+		mdb = br_mdb->mdb;
+		/* Make sure every port that explicitly been added to the mdb
+		 * joins the specified group.
+		 */
+		list_for_each_entry(br_mdb_port, &br_mdb->br_mdb_port_list,
+				    br_mdb_port_node) {
+			br_port = br_mdb_port->br_port;
+			pr_port = prestera_port_dev_lower_find(br_port->dev);
+
+			/* Match only mdb and br_mdb ports that belong to the
+			 * same broadcast domain.
+			 */
+			if (br_dev->vlan_enabled &&
+			    !prestera_port_vlan_by_vid(pr_port,
+						       mdb->vid))
+				continue;
+
+			/* If port is not in MDB or there's no Mrouter
+			 * clear HW mdb.
+			 */
+			if (prestera_br_mdb_port_is_member(br_mdb,
+							   br_mdb_port->br_port->dev) &&
+							   br_dev->mrouter_exist)
+				err = prestera_mdb_port_add(mdb, br_port->dev,
+							    mdb->addr,
+							    mdb->vid);
+			else
+				prestera_mdb_port_del(mdb, br_port->dev);
+
+			if (err)
+				return err;
+		}
+
+		/* Make sure that every mrouter port joins every MC group int
+		 * broadcast domain. If it's not an mrouter - it should leave
+		 */
+		list_for_each_entry(br_port, &br_dev->port_list, head) {
+			pr_port = prestera_port_dev_lower_find(br_port->dev);
+
+			/* Make sure mrouter woudln't receive traffci from
+			 * another broadcast domain (e.g. from a vlan, which
+			 * mrouter port is not a member of).
+			 */
+			if (br_dev->vlan_enabled &&
+			    !prestera_port_vlan_by_vid(pr_port,
+						       mdb->vid))
+				continue;
+
+			if (br_port->mrouter) {
+				err = prestera_mdb_port_add(mdb, br_port->dev,
+							    mdb->addr,
+							    mdb->vid);
+				if (err)
+					return err;
+			} else if (!br_port->mrouter &&
+				   !prestera_br_mdb_port_is_member
+				   (br_mdb, br_port->dev)) {
+				prestera_mdb_port_del(mdb, br_port->dev);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int
+prestera_mdb_enable_set(struct prestera_br_mdb_entry *br_mdb, bool enable)
+{
+	int err;
+
+	if (enable != br_mdb->enabled) {
+		if (enable)
+			err = prestera_hw_mdb_create(br_mdb->mdb);
+		else
+			err = prestera_hw_mdb_destroy(br_mdb->mdb);
+
+		if (err)
+			return err;
+
+		br_mdb->enabled = enable;
+	}
+
+	return 0;
+}
+
+static int
+prestera_br_mdb_enable_set(struct prestera_bridge *br_dev, bool enable)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+	int err;
+
+	list_for_each_entry(br_mdb, &br_dev->br_mdb_entry_list,
+			    br_mdb_entry_node)
+		if (prestera_mdb_enable_set(br_mdb, enable))
+			return err;
+
+	return 0;
+}
+
+static int prestera_port_attr_br_mc_disabled_set(struct prestera_port *port,
+						 struct net_device *orig_dev,
+						 bool mc_disabled)
+{
+	struct prestera_switch *sw = port->sw;
+	struct prestera_bridge *br_dev;
+
+	br_dev = prestera_bridge_find(sw, orig_dev);
+	if (!br_dev)
+		return 0;
+
+	br_dev->multicast_enabled = !mc_disabled;
+
+	/* There's no point in enabling mdb back if router is missing. */
+	WARN_ON(prestera_br_mdb_enable_set(br_dev, br_dev->multicast_enabled &&
+					   br_dev->mrouter_exist));
+
+	WARN_ON(prestera_br_mdb_sync(br_dev));
+
+	WARN_ON(prestera_br_mdb_mc_enable_sync(br_dev));
+
+	return 0;
+}
+
+static bool
+prestera_bridge_mdb_mc_mrouter_exists(struct prestera_bridge *br_dev)
+{
+	struct prestera_bridge_port *br_port;
+
+	list_for_each_entry(br_port, &br_dev->port_list, head)
+		if (br_port->mrouter)
+			return true;
+
+	return false;
+}
+
+static int
+prestera_port_attr_mrouter_set(struct prestera_port *port,
+			       struct net_device *orig_dev,
+			       bool is_port_mrouter)
+{
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *br_dev;
+
+	br_port = prestera_bridge_port_find(port->sw, orig_dev);
+	if (!br_port)
+		return 0;
+
+	br_dev = br_port->bridge;
+	br_port->mrouter = is_port_mrouter;
+
+	br_dev->mrouter_exist = prestera_bridge_mdb_mc_mrouter_exists(br_dev);
+
+	/* Enable MDB processing if both mrouter exists and mc is enabled.
+	 * In case if MC enabled, but there is no mrouter, device would flood
+	 * all multicast traffic (even if MDB table is not empty) with the use
+	 * of bridge's flood capabilities (without the use of flood_domain).
+	 */
+	WARN_ON(prestera_br_mdb_enable_set(br_dev, br_dev->multicast_enabled &&
+					   br_dev->mrouter_exist));
+
+	WARN_ON(prestera_br_mdb_sync(br_dev));
+
+	WARN_ON(prestera_br_mdb_mc_enable_sync(br_dev));
+
+	return 0;
+}
+
 static int prestera_port_obj_attr_set(struct net_device *dev, const void *ctx,
 				      const struct switchdev_attr *attr,
 				      struct netlink_ext_ack *extack)
@@ -759,6 +1116,14 @@ static int prestera_port_obj_attr_set(struct net_device *dev, const void *ctx,
 		err = prestera_port_attr_br_vlan_set(port, attr->orig_dev,
 						     attr->u.vlan_filtering);
 		break;
+	case SWITCHDEV_ATTR_ID_PORT_MROUTER:
+		err = prestera_port_attr_mrouter_set(port, attr->orig_dev,
+						     attr->u.mrouter);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
+		err = prestera_port_attr_br_mc_disabled_set(port, attr->orig_dev,
+							    attr->u.mc_disabled);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 	}
@@ -1063,14 +1428,25 @@ static int prestera_port_obj_add(struct net_device *dev, const void *ctx,
 {
 	struct prestera_port *port = netdev_priv(dev);
 	const struct switchdev_obj_port_vlan *vlan;
+	const struct switchdev_obj_port_mdb *mdb;
+	int err = 0;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 		return prestera_port_vlans_add(port, vlan, extack);
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+		err = prestera_mdb_port_addr_obj_add(mdb);
+		break;
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		fallthrough;
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		break;
 	}
+
+	return err;
 }
 
 static int prestera_port_vlans_del(struct prestera_port *port,
@@ -1099,13 +1475,22 @@ static int prestera_port_obj_del(struct net_device *dev, const void *ctx,
 				 const struct switchdev_obj *obj)
 {
 	struct prestera_port *port = netdev_priv(dev);
+	const struct switchdev_obj_port_mdb *mdb;
+	int err = 0;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		return prestera_port_vlans_del(port, SWITCHDEV_OBJ_PORT_VLAN(obj));
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+		err = prestera_mdb_port_addr_obj_del(port, mdb);
+		break;
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		break;
 	}
+
+	return err;
 }
 
 static int prestera_switchdev_blk_event(struct notifier_block *unused,
@@ -1239,6 +1624,265 @@ static void prestera_switchdev_handler_fini(struct prestera_switchdev *swdev)
 	unregister_switchdev_notifier(&swdev->swdev_nb);
 }
 
+static struct prestera_br_mdb_entry *
+prestera_br_mdb_entry_create(struct prestera_switch *sw,
+			     struct prestera_bridge *br_dev,
+			     const unsigned char *addr, u16 vid)
+{
+	struct prestera_br_mdb_entry *br_mdb_entry;
+	struct prestera_mdb_entry *mdb_entry;
+
+	br_mdb_entry = kzalloc(sizeof(*br_mdb_entry), GFP_KERNEL);
+	if (!br_mdb_entry)
+		return NULL;
+
+	mdb_entry = prestera_mdb_entry_create(sw, addr, vid);
+	if (!mdb_entry)
+		goto err_mdb_alloc;
+
+	br_mdb_entry->mdb = mdb_entry;
+	br_mdb_entry->bridge = br_dev;
+	br_mdb_entry->enabled = true;
+	INIT_LIST_HEAD(&br_mdb_entry->br_mdb_port_list);
+
+	list_add(&br_mdb_entry->br_mdb_entry_node, &br_dev->br_mdb_entry_list);
+
+	return br_mdb_entry;
+
+err_mdb_alloc:
+	kfree(br_mdb_entry);
+	return NULL;
+}
+
+static struct prestera_br_mdb_entry *
+prestera_br_mdb_entry_find(struct prestera_bridge *br_dev,
+			   const unsigned char *addr, u16 vid)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+
+	list_for_each_entry(br_mdb, &br_dev->br_mdb_entry_list,
+			    br_mdb_entry_node)
+		if (ether_addr_equal(&br_mdb->mdb->addr[0], addr) &&
+		    vid == br_mdb->mdb->vid)
+			return br_mdb;
+
+	return NULL;
+}
+
+static struct prestera_br_mdb_entry *
+prestera_br_mdb_entry_get(struct prestera_switch *sw,
+			  struct prestera_bridge *br_dev,
+			  const unsigned char *addr, u16 vid)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+
+	br_mdb = prestera_br_mdb_entry_find(br_dev, addr, vid);
+	if (br_mdb)
+		return br_mdb;
+
+	return prestera_br_mdb_entry_create(sw, br_dev, addr, vid);
+}
+
+static void
+prestera_br_mdb_entry_put(struct prestera_br_mdb_entry *br_mdb)
+{
+	struct prestera_bridge_port *br_port;
+
+	if (list_empty(&br_mdb->br_mdb_port_list)) {
+		list_for_each_entry(br_port, &br_mdb->bridge->port_list, head)
+			prestera_mdb_port_del(br_mdb->mdb, br_port->dev);
+
+		prestera_mdb_entry_destroy(br_mdb->mdb);
+		list_del(&br_mdb->br_mdb_entry_node);
+		kfree(br_mdb);
+	}
+}
+
+static int prestera_br_mdb_port_add(struct prestera_br_mdb_entry *br_mdb,
+				    struct prestera_bridge_port *br_port)
+{
+	struct prestera_br_mdb_port *br_mdb_port;
+
+	list_for_each_entry(br_mdb_port, &br_mdb->br_mdb_port_list,
+			    br_mdb_port_node)
+		if (br_mdb_port->br_port == br_port)
+			return 0;
+
+	br_mdb_port = kzalloc(sizeof(*br_mdb_port), GFP_KERNEL);
+	if (!br_mdb_port)
+		return -ENOMEM;
+
+	br_mdb_port->br_port = br_port;
+	list_add(&br_mdb_port->br_mdb_port_node,
+		 &br_mdb->br_mdb_port_list);
+
+	return 0;
+}
+
+static void
+prestera_br_mdb_port_del(struct prestera_br_mdb_entry *br_mdb,
+			 struct prestera_bridge_port *br_port)
+{
+	struct prestera_br_mdb_port *br_mdb_port, *tmp;
+
+	list_for_each_entry_safe(br_mdb_port, tmp, &br_mdb->br_mdb_port_list,
+				 br_mdb_port_node) {
+		if (br_mdb_port->br_port == br_port) {
+			list_del(&br_mdb_port->br_mdb_port_node);
+			kfree(br_mdb_port);
+		}
+	}
+}
+
+static int
+prestera_mdb_port_add(struct prestera_mdb_entry *mdb,
+		      struct net_device *orig_dev,
+		      const unsigned char addr[ETH_ALEN], u16 vid)
+{
+	struct prestera_flood_domain *flood_domain = mdb->flood_domain;
+	int err;
+
+	if (!prestera_flood_domain_port_find(flood_domain,
+					     orig_dev, vid)) {
+		err = prestera_flood_domain_port_create(flood_domain, orig_dev,
+							vid);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void
+prestera_mdb_port_del(struct prestera_mdb_entry *mdb,
+		      struct net_device *orig_dev)
+{
+	struct prestera_flood_domain *fl_domain = mdb->flood_domain;
+	struct prestera_flood_domain_port *flood_domain_port;
+
+	flood_domain_port = prestera_flood_domain_port_find(fl_domain,
+							    orig_dev,
+							    mdb->vid);
+	if (flood_domain_port)
+		prestera_flood_domain_port_destroy(flood_domain_port);
+}
+
+static void
+prestera_mdb_flush_bridge_port(struct prestera_bridge_port *br_port)
+{
+	struct prestera_br_mdb_port *br_mdb_port, *tmp_port;
+	struct prestera_br_mdb_entry *br_mdb, *br_mdb_tmp;
+	struct prestera_bridge *br_dev = br_port->bridge;
+
+	list_for_each_entry_safe(br_mdb, br_mdb_tmp, &br_dev->br_mdb_entry_list,
+				 br_mdb_entry_node) {
+		list_for_each_entry_safe(br_mdb_port, tmp_port,
+					 &br_mdb->br_mdb_port_list,
+					 br_mdb_port_node) {
+			prestera_mdb_port_del(br_mdb->mdb,
+					      br_mdb_port->br_port->dev);
+			prestera_br_mdb_port_del(br_mdb,  br_mdb_port->br_port);
+		}
+		prestera_br_mdb_entry_put(br_mdb);
+	}
+}
+
+static int
+prestera_mdb_port_addr_obj_add(const struct switchdev_obj_port_mdb *mdb)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *br_dev;
+	struct prestera_switch *sw;
+	struct prestera_port *port;
+	int err;
+
+	sw = prestera_switch_get(mdb->obj.orig_dev);
+	port = prestera_port_dev_lower_find(mdb->obj.orig_dev);
+
+	br_port = prestera_bridge_port_find(sw, mdb->obj.orig_dev);
+	if (!br_port)
+		return 0;
+
+	br_dev = br_port->bridge;
+
+	if (mdb->vid && !prestera_port_vlan_by_vid(port, mdb->vid))
+		return 0;
+
+	if (mdb->vid)
+		br_mdb = prestera_br_mdb_entry_get(sw, br_dev, &mdb->addr[0],
+						   mdb->vid);
+	else
+		br_mdb = prestera_br_mdb_entry_get(sw, br_dev, &mdb->addr[0],
+						   br_dev->bridge_id);
+
+	if (!br_mdb)
+		return -ENOMEM;
+
+	/* Make sure newly allocated MDB entry gets disabled if either MC is
+	 * disabled, or the mrouter does not exist.
+	 */
+	WARN_ON(prestera_mdb_enable_set(br_mdb, br_dev->multicast_enabled &&
+					br_dev->mrouter_exist));
+
+	err = prestera_br_mdb_port_add(br_mdb, br_port);
+	if (err) {
+		prestera_br_mdb_entry_put(br_mdb);
+		return err;
+	}
+
+	err = prestera_br_mdb_sync(br_dev);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int
+prestera_mdb_port_addr_obj_del(struct prestera_port *port,
+			       const struct switchdev_obj_port_mdb *mdb)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *br_dev;
+	int err;
+
+	/* Bridge port no longer exists - and so does this MDB entry */
+	br_port = prestera_bridge_port_find(port->sw, mdb->obj.orig_dev);
+	if (!br_port)
+		return 0;
+
+	/* Removing MDB with non-existing VLAN - not supported; */
+	if (mdb->vid && !prestera_port_vlan_by_vid(port, mdb->vid))
+		return 0;
+
+	br_dev = br_port->bridge;
+
+	if (br_port->bridge->vlan_enabled)
+		br_mdb = prestera_br_mdb_entry_find(br_dev, &mdb->addr[0],
+						    mdb->vid);
+	else
+		br_mdb = prestera_br_mdb_entry_find(br_dev, &mdb->addr[0],
+						    br_port->bridge->bridge_id);
+
+	if (!br_mdb)
+		return 0;
+
+	/* Since there might be a situation that this port was the last in the
+	 * MDB group, we have to both remove this port from software and HW MDB,
+	 * sync MDB table, and then destroy software MDB (if needed).
+	 */
+	prestera_br_mdb_port_del(br_mdb, br_port);
+
+	prestera_br_mdb_entry_put(br_mdb);
+
+	err = prestera_br_mdb_sync(br_dev);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 int prestera_switchdev_init(struct prestera_switch *sw)
 {
 	struct prestera_switchdev *swdev;
-- 
2.17.1

