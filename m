Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BBC5ED97A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbiI1Jw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiI1JwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:52:25 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD602A74D0;
        Wed, 28 Sep 2022 02:52:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtM6/7C61RdR+mHm+AJmJ9th6uP2Ls4FJ/mfMhO3F4R17QkZxKD7AXlreARSi9mPqbZ+xCcvaV/W4iKKgIrgWv3yfi89k99pnauvQFHJ5vgwX4/ybsc7UENmOQg4Al5cCjFzxo2kEQRzCRZhmCTqOLxiBnurfJwHcV7ZLH+oL8kmeUOKMfzuWosoN3ttA2I9DOOyRt2HH4zeSFN0+B+nqnXnkwxdg4ID2HiTjBCG/z66LT2ZVquKWAaSA2+h6JOwthxzmAGDMvDJizJi5ru5MsIu7xDSS3KmOOVLYfvnh+eaJemOVmtcm43mrQicJ7TqJSIzh+0ncITnSbvWV2H/Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZciRC3ey0/dvbnUtrOPp28lpOX8RMlg+4GVVRlV/yQ=;
 b=YoRU9DcyN99BYzRpSCkBGAc9kDMvfwaCUTEVnGs5pReYdzvqhmCWWoXANsYTQQEwojGUBCwIn81pb+bEXCKoPd1YhqhBE1PkdqsLyPS6jNY/ItHUK4J6J56OJ3vZ6M9W4bvfkJEYqt75ovTBikbtJV6mOvvrdyRUhkxHt6rP1vzdKbKNu8Wd3P8em8pgHshER264nuUnV2JVrVOs+hP26M3DqYdPZ6orNFhdNwx7fno2287qUGCtUdoraXQpRujyjwLY0raym0i2O0u3T1BnLpDSYgM6sZ7ivpgaTrvmgOsXJbpYJKn4IrVAueC08BOziELy99+1HClADmgDqGqWVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ZciRC3ey0/dvbnUtrOPp28lpOX8RMlg+4GVVRlV/yQ=;
 b=Yn9QAKZrA6NnKYFcv6AimcgEdw/CRSSTby/cYavmSWp0NfEJn6F8l4dEs2midgtl6Wa2qVFKRaO6Ptu1QUKPQT5DqgUW1h/4gt5A84sNuMZM7bG516DL0b+EkKqCLRUEFoNiCqF44+RKGtiUPlsIUs65np1LwakS6fsoVAdv3J0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7752.eurprd04.prod.outlook.com (2603:10a6:20b:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 28 Sep
 2022 09:52:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 09:52:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 1/8] net/sched: query offload capabilities through ndo_setup_tc()
Date:   Wed, 28 Sep 2022 12:51:57 +0300
Message-Id: <20220928095204.2093716-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
References: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0006.eurprd05.prod.outlook.com
 (2603:10a6:800:92::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: d7fe7d57-6eec-4de5-9b83-08daa1372281
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gNFxZcq5BkMCfbV/hJn7opBc1yVn2vug4r8JkG1Ngyb1oZHaaePNzYqrfvET7mTYiCV7dQEayjfmRaeUR54I5W4sdY0OmVacKIxE+8JB4EW3cPBNDxAyyO/IWWsl1sfEajonnOfoQeMWetqm+M32re/MILoZVd4bFXUdSaKSGdFp9utuIMeplfigL1uhxBLJ1ptYU+xCSC3WnGh+fPDoTuT92xpaMdsiylIwURluR/b6u262+GJpywNetMWxyFKF5Z4iFpSvdly0PGZpW2bbuEngJBg2dHJyX5gFrgeOD9t90cePetI9GmVeBfrONy0c+03+0JfSxEdmmxaocP8AUtzPHUnDrrIvHr8l5qGyoSN9ay0sYtgcHOFUUBzBI+OwxqP49qUjOi41oUxQYgFk5g0lvNmN0WuxUWTdPONGtHU4zUAL1r+fhK5niWQjwMr5pwkce8sx0WxZfB//8ltCvpSAYKjSH04WCcupDnc/SVxLTELQQy1jFCQda5KKAiMfqBljEoSUJZDdW+d/d0tGcHTW7t6DpoROicGo30Fmtxlfhy0BvTHKVG5iGr67cYnZIgKJejKz0bhEEWxJBuvtKTelI6XBEg80xqdShPJAD24ReXo1pScZBsROCOuqxvzoIo+QjHDPdP3Zy3do8krHwy9qkPT43McsbqJZG4vXEJj2vtNIlhuU0dqZhcIDVV7OUUZGYGkBVEj6plDeu/cTRU5L7CG/4G+ciKP3K7xD3cXpkrxOCCdQS2sgdMgz0yZ9lpF1g6X788c5DX48T2I55i88T180iD1V97tj+f4ysp0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(38350700002)(38100700002)(5660300002)(6506007)(52116002)(6666004)(6512007)(8936002)(7416002)(2906002)(41300700001)(44832011)(36756003)(6486002)(478600001)(966005)(86362001)(54906003)(6916009)(26005)(4326008)(83380400001)(1076003)(186003)(8676002)(66476007)(66946007)(66556008)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?beFq7bAqsSYqx+OEW3GidxYjD3eCHAFlw9+tFoO37X58o/95uhDFrxmW6xHA?=
 =?us-ascii?Q?vtxDXVYlYdQuAxHMxL5YPNawaYF+UaSr9dcf+N14T/W22aBNRnqHtWX7eIiX?=
 =?us-ascii?Q?ZunCpsd0by+Hgbnsk01QlBU+B3G6gyJ+PhGA1MNes93N3sanoU/8i7XAPflc?=
 =?us-ascii?Q?5u5814mIrJdv1hHZVobti0kzUgE8aUfCKMBL6jLJe2X6/dfXuhZkVa6cR7+8?=
 =?us-ascii?Q?qIdrvRnuh0GeqLasF++lOQVN8KM6cdsyZfyr34jYVX/LS6JOHZe99EWDgmKh?=
 =?us-ascii?Q?982v6vl0HiRsosCgfte6psYq8VhY8POBbfhjPOOZsM2q3Y5KGTDt23B5/oSz?=
 =?us-ascii?Q?REmDDgv879vB5fnsyK7MbTB6jhyCbJdy9MzEXOXHeWTfdR+XulL45CrJYJcR?=
 =?us-ascii?Q?FONSYyGdMiLx0KzZDviCIKhtwGlXCKDGLV/h64HGkyz6uxebpmxNx37avE99?=
 =?us-ascii?Q?8CGFGxJdHlWd6cIAHEifP4/o4kefGXJFZqm9KLT86xYU4odoXdvdt4AFXXHJ?=
 =?us-ascii?Q?dMHcBdc8ib8elwEkf0yPQVIqQMfW2BulpFesEaP9r5hE5x4imiE9ueOt6Q/n?=
 =?us-ascii?Q?PjlMEiOJwlzn0oMoH5nRDGHHrndtsZKru8VGpXQi7n9P0QG/JBgTn+pLELxn?=
 =?us-ascii?Q?+EZ2MAXq7Bzjqd/PP4XMJrdOazU1L/VjBZjAzw/s7BeeaZ0S5ePk00Rd+Nhn?=
 =?us-ascii?Q?cgGWV7Pkpl40Fxk2klNv3nv7ESf+k8/k1wyR/XlmdnKg9nh+EMwak37yiPYa?=
 =?us-ascii?Q?R6ly0dQ5EmgCxJYMHqVQCimSfM5QxnJT7na9+bV5g27EhcTb7hCHsaCwn+1H?=
 =?us-ascii?Q?rg1EPNiSjntZlIAtdQWO5++PhRKXF5hmAJWWCSD5Pq5KB9aEKX4JhzFGhwZ8?=
 =?us-ascii?Q?7FtZHBXLzj4bS0D5n3vcy1mj35NdV8s98F+PfEhStLlnsWwK2TDX3eJDTN0V?=
 =?us-ascii?Q?QfW2LfC5yO9SeYKk0hrhvOvqggoZjLPkM15tdDG8830YaGSRQGk3b2lVwpis?=
 =?us-ascii?Q?DAnGY4Qw9ewh6Bo9D8fTG2mROZkCc9lnLv45RXzpXKj32dhR0T+3lieqmwpu?=
 =?us-ascii?Q?jbWzT/20GGPi5IxqdCN1BqHO9VKz4LI3YnQ5vzjzuMhbv3Ig+ucBErbMVEFK?=
 =?us-ascii?Q?xaXGQ0o7ZIntbUcT5IraiXhqzS1UhL61YjDM7G8utW5qgj63EfIpSk0t7yaV?=
 =?us-ascii?Q?54ieBhhR6UV1jkne9Tu9L2wteYp6w93lWw0ghv/oxr29pOkjkEGWS8bnKRGu?=
 =?us-ascii?Q?wkxS3X8YJ6rME6nGcEKCoSswX+hkOBgIfT6Wfy05CRZq1AO1eOxAy0EfPiOL?=
 =?us-ascii?Q?QCXTyQMynZ893oBgkxsqg2Ukd5x81jWupBc6200xfQJEC8iXamwK42pk/Kai?=
 =?us-ascii?Q?tirhNq/ELVy9NucDi6gXl3V7nxJSM96hURYqvh15W0uOLOTZOS2XemjxBq+N?=
 =?us-ascii?Q?qnBjtypOTPHZ3U6gXzL7gv/6o6FNyCg33o7ansBegck51soG0wRGUzo5cHGj?=
 =?us-ascii?Q?SDgHLMkw07mhuznFaLfU07wo3vJLsulSM/plblmXglYlQBPS2lNavsPMgHtQ?=
 =?us-ascii?Q?2zAkD4jqjw13edlWErlmTK7HOQ3l5EHWSjtjM2oZ2XbBhXkDu9q4RLbSBv9T?=
 =?us-ascii?Q?3w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7fe7d57-6eec-4de5-9b83-08daa1372281
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 09:52:20.2726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWYwyqt2NQ3x6J/PxBD0LAGjljchBfIJYtScJE6PDLIfglPRCmTOOsi0hHg/OuAImPicaf274Y8NbOfy24k8ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7752
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding optional new features to Qdisc offloads, existing drivers
must reject the new configuration until they are coded up to act on it.

Since modifying all drivers in lockstep with the changes in the Qdisc
can create problems of its own, it would be nice if there existed an
automatic opt-in mechanism for offloading optional features.

Jakub proposes that we multiplex one more kind of call through
ndo_setup_tc(): one where the driver populates a Qdisc-specific
capability structure.

First user will be taprio in further changes. Here we are introducing
the definitions for the base functionality.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220923163310.3192733-3-vladimir.oltean@nxp.com/
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Co-developed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new
v3->v4: none

 include/linux/netdevice.h |  1 +
 include/net/pkt_sched.h   |  5 +++++
 include/net/sch_generic.h |  3 +++
 net/sched/sch_api.c       | 17 +++++++++++++++++
 4 files changed, 26 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9f42fc871c3b..b175d6769f72 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -940,6 +940,7 @@ struct net_device_path_ctx {
 };
 
 enum tc_setup_type {
+	TC_QUERY_CAPS,
 	TC_SETUP_QDISC_MQPRIO,
 	TC_SETUP_CLSU32,
 	TC_SETUP_CLSFLOWER,
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 2ff80cd04c5c..34600292fdfb 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -141,6 +141,11 @@ static inline struct net *qdisc_net(struct Qdisc *q)
 	return dev_net(q->dev_queue->dev);
 }
 
+struct tc_query_caps_base {
+	enum tc_setup_type type;
+	void *caps;
+};
+
 struct tc_cbs_qopt_offload {
 	u8 enable;
 	s32 queue;
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 32819299937d..d5517719af4e 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -677,6 +677,9 @@ qdisc_offload_graft_helper(struct net_device *dev, struct Qdisc *sch,
 {
 }
 #endif
+void qdisc_offload_query_caps(struct net_device *dev,
+			      enum tc_setup_type type,
+			      void *caps, size_t caps_len);
 struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 			  const struct Qdisc_ops *ops,
 			  struct netlink_ext_ack *extack);
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index db1569fac57c..7c15f1f3da17 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -868,6 +868,23 @@ void qdisc_offload_graft_helper(struct net_device *dev, struct Qdisc *sch,
 }
 EXPORT_SYMBOL(qdisc_offload_graft_helper);
 
+void qdisc_offload_query_caps(struct net_device *dev,
+			      enum tc_setup_type type,
+			      void *caps, size_t caps_len)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_query_caps_base base = {
+		.type = type,
+		.caps = caps,
+	};
+
+	memset(caps, 0, caps_len);
+
+	if (ops->ndo_setup_tc)
+		ops->ndo_setup_tc(dev, TC_QUERY_CAPS, &base);
+}
+EXPORT_SYMBOL(qdisc_offload_query_caps);
+
 static void qdisc_offload_graft_root(struct net_device *dev,
 				     struct Qdisc *new, struct Qdisc *old,
 				     struct netlink_ext_ack *extack)
-- 
2.34.1

