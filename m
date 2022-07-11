Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6490F5700D8
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiGKLkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiGKLjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:39:51 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80103.outbound.protection.outlook.com [40.107.8.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF9C2CE01;
        Mon, 11 Jul 2022 04:28:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPF2yZSjNNDU4lU/dKtvMzwqG4YTFUXYCp/EkAZ8Qfjze3iSzPrFy4ZNgerjIAg4hQxPw8zNhWkhpCvqPLC+D3J76nptneXa/M+W6DVEn4eJJ66fXwsXMF2fKM/3+6amsPOlvgNuREfTNCTJLP1jPdnB7EbtDS4qx2AIADiZLZn8Wvbme7GGxhO8RoDognHbDS61cwD7Anlxp6nFlA0D8Y5ruTERRRB23fE+eVqCmyHhv+uZndfCjNlqtkK+zPMovrfzgJj6BtIqF2jiDz0GAlB8bhVdVkgiNIMTUUGoFCisD5XgF4uTTMHnccfKoJ3E9uMyVQBrx/bRJchybYbe/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68IzSpb7w0JKuLkV8lHJt5i2m9SiBK/jDh2xecdnZIc=;
 b=M7szJXzFkSiAdZiQorsuA82jrVGbhbOq4ghzS0S9/oGsxlNLnJlj/bzLa64vUBScdYYO7qNBX2qRsp2VUUznxeMTOPFpDvSyR40pvkNsLL3UcQeAkGDrM8S2DWLD/7yICOwhG01ToCRauQUzEbRRtB99gF418wEc4NBPEEuMiNcqehIQlIDncLlW/gI7SftES2HaXMolWmcmHiMlUjT41fAxesDLJj0JZi8narSPYUTV4opDyVg9AlRbnpUi5t2LPxPHbi1964UwKMp7+IC5aScI7KjR2/X2K8LBmJ7m7VEbkZFXNWeXYHjBaZF7s7UvSAZ3Yp75taedB1pdVgdTFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68IzSpb7w0JKuLkV8lHJt5i2m9SiBK/jDh2xecdnZIc=;
 b=LARGm2V7SFF264PnRqjdH1AjCH814yHyMPK/Etfju9UFSyEwc63MFgUXT0jOJ1mFvp3ZJ4nwA5uyusuXF11HfFczCuETlZIVqjHaQKe3i2BaIq9UuFw/TmSQVvFBY83EcRc1WH/CyuoR6rD2oyQkzjkWGEDwCYXiwTZa1telNBk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AS8P190MB1208.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2ef::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Mon, 11 Jul
 2022 11:28:45 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.023; Mon, 11 Jul 2022
 11:28:45 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V5 net-next 4/4] net: marvell: prestera: implement software MDB entries allocation
Date:   Mon, 11 Jul 2022 14:28:22 +0300
Message-Id: <20220711112822.13725-5-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220711112822.13725-1-oleksandr.mazur@plvision.eu>
References: <20220711112822.13725-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::15) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09130a5b-7ad1-4fc5-d8a5-08da6330843c
X-MS-TrafficTypeDiagnostic: AS8P190MB1208:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLWbkkYyuTL4KAtSMcYykLuY8PoCwIUX4p5qwswESb7sFNctjLoRX6dZBZ/UHRcRxdlvvMFIKUZBmXXC36HuIIefYse1c+73rjPnGtzANeNrVdcaZ4/+eSHOD7czj/GQjUU1FgWcTD8zKtXKCH8coZK71hiAAtZTqcLyDafchLRT8slkPgKzFuqOBnNnAsIH+H7Sx6EAumXYt8E5OH9SR6wj75TXdwbYwnDv3pDzz9CftYlQmt+PLA/i8CuaDtaDcjM+Aaj8PQs+1oxCG/6684xzOJpLvoCfMjTHVS1nvt6iT9D2cGCdv49ZhUaCIeAXauz3cA238I6zKFEhKnBf9PGyHdM1PqDfpg92ddpNg+B1aThQiJgXelJbSbeTVwWTkvmVanZCI2eBhRHcgnrSnIiqtFNgzkXRr1IyMrYfrI0olPGQp3uJvMm+4GLohyOwXikmGYWX4g9HZmoK7OY/wWUZn8X7Crnq6neFaivSXDWnMk6biXlflUWhLhe3cajB7gMDv3VN2ZlF1cqrojM+bFLc02KoSEm+sF6IY6rLnhHaLfug01RzbGL6+SesKHDdGrkq/HVFSSQ2U0j1P+AoDLBg6Dd7az89EI/6+nwoax1OditsrSHJI6sylh2DyhO8jeDDZEJ28v6ZNHjS+HZ6Wt3cm41Jzo7QWaevZqbZio3+gNP9KortgrrfpzwdHoB5pcWPPeAzP+MV8iTdZrhvTaGxyGLc6qspBA2qxUHXzi+3st93tdOrvIumD2ghaBFQE4z2YTtCdvs8yVT3OFVAA8NXFJ/RyKmPqA6jYZYxpWLQLiRXHbh1eZ5zk75zbXqo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39840400004)(346002)(376002)(366004)(396003)(6916009)(6506007)(186003)(86362001)(107886003)(52116002)(478600001)(1076003)(6486002)(6512007)(26005)(36756003)(66476007)(8676002)(4326008)(5660300002)(8936002)(316002)(66574015)(66556008)(2906002)(66946007)(38350700002)(2616005)(6666004)(83380400001)(41300700001)(44832011)(30864003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TY8jPtyUon/UlyI2/Awt0KTAJWQ71x0fIhC50u6wzcvmNyh8kot1nUWIHuaw?=
 =?us-ascii?Q?6B7fMBXC0tVRHT/MWd6DSYeBsp4t2dVbTwBAM7QT2vrSA44WdzZTgdTVqj6L?=
 =?us-ascii?Q?piehzyUUO7z6sendDi/y9QkHLUwgS8rVxddc5iQxLDg8LzOX/pyUtc2t2gBx?=
 =?us-ascii?Q?VggNTQYkXHi40vaSbsF8nOyqLSREJFcXt99jDysJ3Lzttx2iYzsvJNCnFdGj?=
 =?us-ascii?Q?+TrYgq56OerBhQ/YN2KLiHpiQrTX0XeExNU3UDdZf+0yQOKMX2eBcMs5O2qe?=
 =?us-ascii?Q?nobUhwDgdOkRJjQ5qtt9fNFk3NGGZBKsvti0lmP3ROgGd/r/W9ElkMlUFxeI?=
 =?us-ascii?Q?+79EkIJ9LliCBPBYv6jJVqXVRfk317hxtq7uOJLTR1N3Z9T/iSq+zVC1gDOo?=
 =?us-ascii?Q?Yzs0kr0dbZ3O9JaHZDrmC4zR6dAVQ/WfUGAcpUpzxEpLCTKSOfxVa9FAd2lZ?=
 =?us-ascii?Q?XwcDc25KYMld0oW2X1hO49AAMVvt6OV0fRY9ngos2SBd/UMQEjut71gguCDz?=
 =?us-ascii?Q?mfNnrGPft9ws5iMEP37df1HGn1u6ELnenTQBO/3aKN9HPoxM8wL12OGBicJi?=
 =?us-ascii?Q?Y6q1lyoZ3yKxLtli0Clsv+04KUC8B3M8xq6j/JEAYaHmPtBZROgCaI7rYo22?=
 =?us-ascii?Q?nYhbm08Fh3GlcL3FqkQgP8YET6peA3j4EC0PJDtDdtC2031hJofMvcepJq+N?=
 =?us-ascii?Q?f2tJ/hbtN6a1sYeArdag39zFaS6ouoCUqBJWPddBEcbZLFg+PC2z/dA30h4n?=
 =?us-ascii?Q?lZzAyIXqvH/zAjVNg4heI0WbvkKDHJs9y2O2s5TO/Bc4lWEjjkXuoNy7tg2B?=
 =?us-ascii?Q?E6LxfT81AJXyLQSwCGXPDpOZUZuY/XogodmFFpeerHow55dtTdm13aULkOAM?=
 =?us-ascii?Q?QrVFUaGFn4uFzahxokhZzFz997bysfo+VumjPwnRsnnxEOhj5NnJMdH2NY4m?=
 =?us-ascii?Q?jxYgaHjFZsk+4vdhsXJ5yQ5lA49KIsZIjAkZxS+5uN2z1VO3C8dNoJ7ooiHL?=
 =?us-ascii?Q?Snza+C0Ia79Jyi7w2Z7NhA+PY3/npY4yvTgs4GsvuWeD19AhAg8FoYjWQS2A?=
 =?us-ascii?Q?PTVNaAv00wMHyU9vUKbd8j+oGA9cEJMGbb2qbAvLPMZktbiJhsBbh5ZilGC6?=
 =?us-ascii?Q?Qs1D74XtGRTyxOp3aEMjWvAhaVOQAY78lI6+6ay+WSSoYC+Ih8wRPRU4HIu8?=
 =?us-ascii?Q?9lqlFgOqEfy4Sv2Nb8Ss9Rx0iIfoW1MYWs2qccrz8+rMVLQ1IzOFpBNy6itE?=
 =?us-ascii?Q?CMONoIXKX8eo+PdqsiQLYDal+Akmidvc5MV2zw2VfVYwlT/oz4HfIgSlf5qQ?=
 =?us-ascii?Q?H0SKzNBbQniOjA0LUeejcnFBs/CQOi3u1W/NRVAWDj3y/P4LZH0WaAX1SwBw?=
 =?us-ascii?Q?Ljp0fdBAAsVL59In1nGEOM6K/a/GSVtsIbNYWgfZELlBn5/bmvp4kxlvlMz+?=
 =?us-ascii?Q?Sw0yTH+FVNoagBaJMYVqYBJzHHpToBJnsHz2W02sfXYP7Es7JwoxMyHaPBcd?=
 =?us-ascii?Q?hyOe4el19jp7WaEZ1Vji3SRLdZMjMVlV4s55RmKPi2b+lS4bmBv6BjNegZz+?=
 =?us-ascii?Q?Ddz2woJRr+nzsWVUqJcTokFGNiVshiRo+rT7012YhbA1byLwwslm1WJhNqT2?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 09130a5b-7ad1-4fc5-d8a5-08da6330843c
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 11:28:45.6550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tD9lBSRbZhmKr9PUsEyrKecGryhnh1Xy19WnGJPRqxslGxtBxb12yKldflB9V6DUUV7a4DUeTs7Bs0UByvFTdmCikfdaonB6IDUBmTOAekc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1208
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
 .../marvell/prestera/prestera_switchdev.c     | 627 +++++++++++++++++-
 3 files changed, 635 insertions(+), 2 deletions(-)

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
index 7002c35526d2..71cde97d85c8 100644
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
 
@@ -67,6 +72,20 @@ struct prestera_port_vlan {
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
 static struct workqueue_struct *swdev_wq;
 
 static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
@@ -74,6 +93,49 @@ static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
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
@@ -252,6 +314,70 @@ static int prestera_fdb_flush_port(struct prestera_port *port, u32 mode)
 		return prestera_hw_fdb_flush_port(port, mode);
 }
 
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
 static void
 prestera_port_vlan_bridge_leave(struct prestera_port_vlan *port_vlan)
 {
@@ -277,6 +403,8 @@ prestera_port_vlan_bridge_leave(struct prestera_port_vlan *port_vlan)
 	else
 		prestera_fdb_flush_port_vlan(port, vid, fdb_flush_mode);
 
+	prestera_mdb_flush_bridge_port(br_port);
+
 	list_del(&port_vlan->br_vlan_head);
 	prestera_bridge_vlan_put(br_vlan);
 	prestera_bridge_port_put(br_port);
@@ -328,8 +456,10 @@ prestera_bridge_create(struct prestera_switchdev *swdev, struct net_device *dev)
 	bridge->vlan_enabled = vlan_enabled;
 	bridge->swdev = swdev;
 	bridge->dev = dev;
+	bridge->multicast_enabled = br_multicast_enabled(dev);
 
 	INIT_LIST_HEAD(&bridge->port_list);
+	INIT_LIST_HEAD(&bridge->br_mdb_entry_list);
 
 	list_add(&bridge->head, &swdev->bridge_list);
 
@@ -347,6 +477,7 @@ static void prestera_bridge_destroy(struct prestera_bridge *bridge)
 	else
 		prestera_hw_bridge_delete(swdev->sw, bridge->bridge_id);
 
+	WARN_ON(!list_empty(&bridge->br_mdb_entry_list));
 	WARN_ON(!list_empty(&bridge->port_list));
 	kfree(bridge);
 }
@@ -438,6 +569,7 @@ prestera_bridge_port_create(struct prestera_bridge *bridge,
 
 	INIT_LIST_HEAD(&br_port->vlan_list);
 	list_add(&br_port->head, &bridge->port_list);
+	INIT_LIST_HEAD(&br_port->br_mdb_port_list);
 
 	return br_port;
 }
@@ -447,6 +579,7 @@ prestera_bridge_port_destroy(struct prestera_bridge_port *br_port)
 {
 	list_del(&br_port->head);
 	WARN_ON(!list_empty(&br_port->vlan_list));
+	WARN_ON(!list_empty(&br_port->br_mdb_port_list));
 	kfree(br_port);
 }
 
@@ -619,6 +752,8 @@ void prestera_bridge_port_leave(struct net_device *br_dev,
 
 	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 
+	prestera_mdb_flush_bridge_port(br_port);
+
 	prestera_br_port_flags_reset(br_port, port);
 	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
 	prestera_bridge_port_put(br_port);
@@ -730,6 +865,290 @@ static int prestera_port_attr_stp_state_set(struct prestera_port *port,
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
+			    br_mdb_entry_node) {
+		err = prestera_mdb_enable_set(br_mdb, enable);
+		if (err)
+			return err;
+	}
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
@@ -759,6 +1178,14 @@ static int prestera_port_obj_attr_set(struct net_device *dev, const void *ctx,
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
@@ -1057,20 +1484,162 @@ static int prestera_port_vlans_add(struct prestera_port *port,
 					     flag_pvid, extack);
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
 static int prestera_port_obj_add(struct net_device *dev, const void *ctx,
 				 const struct switchdev_obj *obj,
 				 struct netlink_ext_ack *extack)
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
@@ -1095,17 +1664,71 @@ static int prestera_port_vlans_del(struct prestera_port *port,
 	return 0;
 }
 
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
 static int prestera_port_obj_del(struct net_device *dev, const void *ctx,
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
-- 
2.17.1

