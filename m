Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7265700D6
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiGKLkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiGKLjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:39:41 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80103.outbound.protection.outlook.com [40.107.8.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBF427165;
        Mon, 11 Jul 2022 04:28:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+U//l+1//RJEVUM5W/wf+dYdpW3xu6i+IKh6BVIZmA8zwyAnWjxrgDdROuyu4SaLyK2b1fGCtN7GRstQB7IdHf9SDxLC8CHXHIjevcItgR+qV6KCyEDTb899eTsLo3cJhMa4o6PCMWdf4CNyvREYBpws9dOuk80YysDStzVgaf5gyj1VCeoTv5F6e2f97ceAie3rDJYD5rIWab/BPaH+A+OkIUBG2asWrwZNadwMMSXBGSi++QiQwOH6K+PO5ylwArUEWRkkhjMjoa0D2+mO9DlwzK5KiUXvZIOe7jhmAhhaBHlGtdoBDczfRB/gvIPX3g4caf0qGdViRFWVOKtLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8A8aYCRWA0FKlAWAeDvYgRsvaBt21Mm725cf6oIA6fg=;
 b=MaCf7VeTkpclVjMF1YI2VfNVUsHzds2tNCSpIMSWP2an9zSJaW0tuqnIMK9SRHcI4NAWOGW6yzgCU3BMvPgksDerF8MiDJKwIzcECNUJmYhHrmQVCul/g6YXZqdMNUi1J3tKpuoQZ2TXhfIMzVoWeL8kkfXuQks9f0Rkgtr85sT/pso8CZXHnVtIRGFW9AmMEZgbJWV/B4Tpa6lfjagyd26yeVUBeNtZ7ODosoRyjixHzA7EjF11pB0BpDaANuHnLb9IDCnMs18uVw51F8Jilvo0igA1a+o5KD6PeLkHh5pciofRDmH3JqKU8sUGldrD7yxxVommbQaI1yxExzO6Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8A8aYCRWA0FKlAWAeDvYgRsvaBt21Mm725cf6oIA6fg=;
 b=DAW9dUOEf/Irue/hxomO367eSMkZfjriPOvegEL3GUMZI4TFtIts9cgf1KW2XkejgdBhHKdqhtqzcMVEY/UptBO2TPha4JQmT6xiylyb6dTIIkTmKyU4OMutxZkb8+wkVyTV7wR/mRLq6wMUCg0Yqib2j3jht2v80tTBJRDm7fk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AS8P190MB1208.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2ef::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Mon, 11 Jul
 2022 11:28:43 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.023; Mon, 11 Jul 2022
 11:28:43 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V5 net-next 3/4] net: marvell: prestera: define and implement MDB / flood domain API for entries creation and deletion
Date:   Mon, 11 Jul 2022 14:28:21 +0300
Message-Id: <20220711112822.13725-4-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220711112822.13725-1-oleksandr.mazur@plvision.eu>
References: <20220711112822.13725-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::15) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cad0088c-da20-4c66-da0e-08da63308324
X-MS-TrafficTypeDiagnostic: AS8P190MB1208:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /9POu66x8IWpClAf+n/eAN6LzEDnOFs6tUW+EnFLAZRBAWNclkB9Um5rFnyVa/WRJ/hOu2dAkVIhf9rVcrKBVeeR9dzF61OZKW4RgDHvz+it3yuzvTg8E3ko8isG3ZK+o8Nc2E3mDctW8GtG+qqrsxi36icDnZEpe0yM8DzLIJ4eh5OPvgxPKEX95ld9vzYvosFZdBLYfJglhDalbm1VUQglGuDL3g7AeT6XgdcarezBprAxg3spJ2qg2cjSTgFaW/YURaIE6H1tsVr5casujHZnimVBE7cpeEVo4mmxaK6EapeQuWqMVu9XTZbaf8w5yi1Y7BugrVrEKax29KcsafderB5uQNd7w45Z1RfcIBJS8i1S/sUDORbVslSVkeEIL/e1nkghtYzT3mXADoRmVxf07aCYmytVfvU501+n1pNUwxQ8ki2c/o+eOT+XPyGByYROYFoqR5WkoBwAxsJPI8BQ3VlNYHgaZ1u+nHcGMzl/jtOPXgxFSfHjrGD2N7BM2ohWOaWBCV88kUDUPvpYrHSfAFlAy9GLmncxxVUNmvNsxxfmqD84cpHMraezdNxdVx/Y2niLxJvGk0x+/c1HJnm3ZrhU3wK7StNRqejg/Pf17WMjMG2MVkMXDKpy7RN+xLdWuRiWdrOEfOz5POy85CLVzql9NF0b8MaKlU+EdNVait2MXXKkeXhdUrl2AaluT4EufiUBjdXiU8cYa/1RmWy41xdIEw2LGGNb8qBHR4faP2aOeCIJIUUmCbcNlveDJcyFWT/lEtwK7BuXvtw1HGngNq405WJTdoWE5vGMdyC4pafcY3ZC91NqVwKIavoc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39840400004)(346002)(376002)(366004)(396003)(6916009)(6506007)(186003)(86362001)(107886003)(52116002)(478600001)(1076003)(6486002)(6512007)(26005)(36756003)(66476007)(8676002)(4326008)(5660300002)(8936002)(316002)(66556008)(2906002)(66946007)(38350700002)(2616005)(6666004)(83380400001)(41300700001)(44832011)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ov/Z8UIOMMJb9qq1O3zMNYkwIV/yAjKBzmtP/1zn347pMVjKKB8ILZVirZ5W?=
 =?us-ascii?Q?GPHZFLBhfKZ0AFHXEsUislkW9Z3c59vFNuFUx3Mx4apbXTzatm0DPxqetBcm?=
 =?us-ascii?Q?c7iqTZBCqa14C7LsS31xYTVYDR0fyohsTX7CvkXGv2WrMY8jgXwWHUCVQm5N?=
 =?us-ascii?Q?JmFvGx5B6IrQS0yg+9KzTFzGph7A2Quf/Wxh2H0koalZ4xOzRr8qm9YMdMPM?=
 =?us-ascii?Q?4BilYNilgbRlrlVGAnON0+p4tK72l2KlNKN8Y6RRczr6+sdiNvKEH8JwW0SZ?=
 =?us-ascii?Q?aiNaL/WYahIvHV2Zk/80n+Z6+fSlzdS0cjxdq/1drS+M6p2VzLXcVBvVbj+i?=
 =?us-ascii?Q?lIRVC5udmrZ23ETb/3NZz8PTieYaojrzcuCJXB0Z4JHNX8t0d6qLI3cdGzvx?=
 =?us-ascii?Q?OuCCvefmdsV5+WGnxqpTTuyzJjdS8QJ7VNgnE+p95LdsHnBwIpJ/qjQsd1JK?=
 =?us-ascii?Q?nyAhEimjBTng+x50J8Gy2H8nbYUQMFRlk/J29oYPkEVntY0RdxJ4xCwv2gMV?=
 =?us-ascii?Q?p+4lcBI2BvCnRhLtjk8d7OkuQpL7+c/XNd/fYtq8ciHbFT6IABZTpRU08kDl?=
 =?us-ascii?Q?uteP5TWNZcJBKc2WgLU0+sGHzREAHZXpus4yMuP4JIosOLJbW8WYehIFOnV0?=
 =?us-ascii?Q?wlIK/QzTCsz3ZiQ1EBU3EZAkWibzo1U+sZ3RfXXO7bzCwk7r0BMuR+vc19xN?=
 =?us-ascii?Q?ofYRV8f1UDSDr8ENucv2cGRlsxJD8C/waO+uryn6FJROZCiZSWkKUzpsTzxB?=
 =?us-ascii?Q?LscBcOVz9gh4hFKuLpcbSwURLBPu6BLsrSkBWN9AVYf4mbAQcZovYzUy9Y8X?=
 =?us-ascii?Q?zG12SSSGMLGkFD3rlcIOn9K80WRy8cx/rAySmNpdzWEuon8AsuBgJ0ZGzNlU?=
 =?us-ascii?Q?t//XMRUHrF4oj+Z+6E0rH1Xx29nZ6I5Pe1VRDYLZViRNAANpEBHjsUkVwIlW?=
 =?us-ascii?Q?LpZ77Dt6gfwT0srcZeHQcQM+5ULQJCinDLpW6MOKQhKYnrOxiABMC/3i5vhr?=
 =?us-ascii?Q?LaLr+lmYdJydTVUMub6GHOhNcbnIPIG7kQ3/03t0LvILrs/i4T55UDvrsilN?=
 =?us-ascii?Q?ErL1dnxdcjx+SsA4Ob4iJdddPcKSr3XIKLFyGl6l1J5xcj8vfcMIZ4zpvwVr?=
 =?us-ascii?Q?7nxZfu6304kXsu/La5AIZ34zWMzep9NSBxkTB92ohI55crKcX2BOo4mBR8Xt?=
 =?us-ascii?Q?zKbFbOZGDpJpydwNMnzyu1ZaeUHGGcUZSKAjbG7zWL9Sv24OyEN7xU+8Ze4N?=
 =?us-ascii?Q?CspynNAFRqq8dDKssHdT3OMLbioZp1zPYFXxWt1b9HbOgKZgMFzQ8R5mUOxp?=
 =?us-ascii?Q?Uwer7EbbmqC/I6hLAX8iCKmrdTyUFUPxsui55xKYK+lVEVQPGVAYEtg+azfT?=
 =?us-ascii?Q?Vr584D/BWjiw4r0oPUThe2i8UlqYTZo1aCnZlYtbPS2lDZ6yM5Ci1SjFjrGy?=
 =?us-ascii?Q?JH74krbe5mzmigS7ysnCrGJrO1+RkSJ3V1QpyoFXm0x2s/v3czyIV8CxIeZI?=
 =?us-ascii?Q?ZxVfACM0g66HP/KGyUe5s4ULa2aJgpg9SUrQKBebfHR4P3RcgL26GRAqli5S?=
 =?us-ascii?Q?Xu6ncLzOYGP9xZmuJztyBOj+awRADpKaHz8PjcK3qX1OybZXdjnGVIeRGyjb?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: cad0088c-da20-4c66-da0e-08da63308324
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 11:28:43.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dzfPkdm88gQ1IVjzVJq3/JU23IcVLRl09fc+KhHEwsacHERaPGjgMdgriYKE3loUO3GgIGhXLe+U3bYBrVHNCsWHIEjPtfWf423sKnyU7E=
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

Define and implement prestera API calls for managing MDB and
  flood domain (ports) entries (create / delete / find calls).

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  19 +++
 .../ethernet/marvell/prestera/prestera_main.c | 144 ++++++++++++++++++
 2 files changed, 163 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index bf7ecb18858a..f22fab02f59c 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -369,4 +369,23 @@ struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id);
 
 u16 prestera_port_lag_id(const struct prestera_port *port);
 
+struct prestera_mdb_entry *
+prestera_mdb_entry_create(struct prestera_switch *sw,
+			  const unsigned char *addr, u16 vid);
+void prestera_mdb_entry_destroy(struct prestera_mdb_entry *mdb_entry);
+
+struct prestera_flood_domain *
+prestera_flood_domain_create(struct prestera_switch *sw);
+void prestera_flood_domain_destroy(struct prestera_flood_domain *flood_domain);
+
+int
+prestera_flood_domain_port_create(struct prestera_flood_domain *flood_domain,
+				  struct net_device *dev,
+				  u16 vid);
+void
+prestera_flood_domain_port_destroy(struct prestera_flood_domain_port *port);
+struct prestera_flood_domain_port *
+prestera_flood_domain_port_find(struct prestera_flood_domain *flood_domain,
+				struct net_device *dev, u16 vid);
+
 #endif /* _PRESTERA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 4b95ef393b6e..04abff9b049d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -915,6 +915,150 @@ static int prestera_netdev_event_handler(struct notifier_block *nb,
 	return notifier_from_errno(err);
 }
 
+struct prestera_mdb_entry *
+prestera_mdb_entry_create(struct prestera_switch *sw,
+			  const unsigned char *addr, u16 vid)
+{
+	struct prestera_flood_domain *flood_domain;
+	struct prestera_mdb_entry *mdb_entry;
+
+	mdb_entry = kzalloc(sizeof(*mdb_entry), GFP_KERNEL);
+	if (!mdb_entry)
+		goto err_mdb_alloc;
+
+	flood_domain = prestera_flood_domain_create(sw);
+	if (!flood_domain)
+		goto err_flood_domain_create;
+
+	mdb_entry->sw = sw;
+	mdb_entry->vid = vid;
+	mdb_entry->flood_domain = flood_domain;
+	ether_addr_copy(mdb_entry->addr, addr);
+
+	if (prestera_hw_mdb_create(mdb_entry))
+		goto err_mdb_hw_create;
+
+	return mdb_entry;
+
+err_mdb_hw_create:
+	prestera_flood_domain_destroy(flood_domain);
+err_flood_domain_create:
+	kfree(mdb_entry);
+err_mdb_alloc:
+	return NULL;
+}
+
+void prestera_mdb_entry_destroy(struct prestera_mdb_entry *mdb_entry)
+{
+	prestera_hw_mdb_destroy(mdb_entry);
+	prestera_flood_domain_destroy(mdb_entry->flood_domain);
+	kfree(mdb_entry);
+}
+
+struct prestera_flood_domain *
+prestera_flood_domain_create(struct prestera_switch *sw)
+{
+	struct prestera_flood_domain *domain;
+
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		return NULL;
+
+	domain->sw = sw;
+
+	if (prestera_hw_flood_domain_create(domain)) {
+		kfree(domain);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&domain->flood_domain_port_list);
+
+	return domain;
+}
+
+void prestera_flood_domain_destroy(struct prestera_flood_domain *flood_domain)
+{
+	WARN_ON(!list_empty(&flood_domain->flood_domain_port_list));
+	WARN_ON_ONCE(prestera_hw_flood_domain_destroy(flood_domain));
+	kfree(flood_domain);
+}
+
+int
+prestera_flood_domain_port_create(struct prestera_flood_domain *flood_domain,
+				  struct net_device *dev,
+				  u16 vid)
+{
+	struct prestera_flood_domain_port *flood_domain_port;
+	bool is_first_port_in_list = false;
+	int err;
+
+	flood_domain_port = kzalloc(sizeof(*flood_domain_port), GFP_KERNEL);
+	if (!flood_domain_port) {
+		err = -ENOMEM;
+		goto err_port_alloc;
+	}
+
+	flood_domain_port->vid = vid;
+
+	if (list_empty(&flood_domain->flood_domain_port_list))
+		is_first_port_in_list = true;
+
+	list_add(&flood_domain_port->flood_domain_port_node,
+		 &flood_domain->flood_domain_port_list);
+
+	flood_domain_port->flood_domain = flood_domain;
+	flood_domain_port->dev = dev;
+
+	if (!is_first_port_in_list) {
+		err = prestera_hw_flood_domain_ports_reset(flood_domain);
+		if (err)
+			goto err_prestera_mdb_port_create_hw;
+	}
+
+	err = prestera_hw_flood_domain_ports_set(flood_domain);
+	if (err)
+		goto err_prestera_mdb_port_create_hw;
+
+	return 0;
+
+err_prestera_mdb_port_create_hw:
+	list_del(&flood_domain_port->flood_domain_port_node);
+	kfree(flood_domain_port);
+err_port_alloc:
+	return err;
+}
+
+void
+prestera_flood_domain_port_destroy(struct prestera_flood_domain_port *port)
+{
+	struct prestera_flood_domain *flood_domain = port->flood_domain;
+
+	list_del(&port->flood_domain_port_node);
+
+	WARN_ON_ONCE(prestera_hw_flood_domain_ports_reset(flood_domain));
+
+	if (!list_empty(&flood_domain->flood_domain_port_list))
+		WARN_ON_ONCE(prestera_hw_flood_domain_ports_set(flood_domain));
+
+	kfree(port);
+}
+
+struct prestera_flood_domain_port *
+prestera_flood_domain_port_find(struct prestera_flood_domain *flood_domain,
+				struct net_device *dev, u16 vid)
+{
+	struct prestera_flood_domain_port *flood_domain_port;
+
+	list_for_each_entry(flood_domain_port,
+			    &flood_domain->flood_domain_port_list,
+			    flood_domain_port_node)
+		if (flood_domain_port->dev == dev &&
+		    vid == flood_domain_port->vid)
+			return flood_domain_port;
+
+	return NULL;
+}
+
 static int prestera_netdev_event_handler_register(struct prestera_switch *sw)
 {
 	sw->netdev_nb.notifier_call = prestera_netdev_event_handler;
-- 
2.17.1

