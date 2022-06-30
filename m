Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD41F5618EF
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbiF3LS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbiF3LSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:18:44 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2124.outbound.protection.outlook.com [40.107.21.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809FB4D4D6;
        Thu, 30 Jun 2022 04:18:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSgMB5ER5AaGBFk4ZfJmC6C06KpF8LL0rMiCRrYBlAOf9yoF5DMHGZyOC/MmunDC3tfMP/wMsKaqtd43VICsiXuz6UlbxdTZYP+jWQlPO41MsPLGEWONnCG52bctHZ/f3XxQIqETSn2eOliL2dJHoQR9i/OmaPbX4WyiVgm7Ia97HoQNzVunoMbOMeXaESofM9zcwXnA7hYziMYc+JL1lHM+Dcim9Lavo49g1GM+uWnmpSqdZ9/DVVwTPYN5Y9bEgfjiH5rUiCC0ob2m6G5BoPOhuA+ezAlL31+Swd6K8CVMYGHxXd4e0DGcr7qL7NUSRTqlptcOK82ufD2B2lBb4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8A8aYCRWA0FKlAWAeDvYgRsvaBt21Mm725cf6oIA6fg=;
 b=Dnodcw5acHJBo5yYKe3OleiRLk8DUd5Ro0zHoGN+RWIu6Dlm2WaTE674f32kie6HG2fehq4UolCjPelpQvL10lJCV6ITnXF06S5hsgifYZlqAwgH4jHktgcKGCm0C/EJ+W4VdsyIQvYSPmYXnLMYkID7hB5dXpK/Rah0GUJpyPE2FZclTcNv1ayhyy/Yrue11yXKPyHsmEHMysTBJul6dvT5xOpbOXiLbAfrkntKRaF4XJu8qF9UwPw3AcaxzsVi7Wx0sNrXa9SafPR2kN0kpb5lfIe6oXKMWGZ3L2KJgTMum+gyswSYurcsDv6nFndtdGHa2z/GDFbopy7bEhTyRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8A8aYCRWA0FKlAWAeDvYgRsvaBt21Mm725cf6oIA6fg=;
 b=EEDsQlk2SQbU4zRm/eo4PZ1EQsVYHQkqlJd9Msesgi9ZOaYY083XpNPgoT5L2F/aDPkiFDS7PkgMe3zt0hEmGxfd1QAXc00ilFkJUb5f/idBbcOSAH23iudUcTHIBx3ekj0cBydyeJOsuIeqXtnFB1hwTYJD8TS95yTqsjWmGWY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DB9P190MB1793.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:33d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 11:18:40 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 11:18:40 +0000
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
Subject: [PATCH V3 net-next 3/4] net: marvell: prestera: define and implement MDB / flood domain API for entries creation and deletion
Date:   Thu, 30 Jun 2022 14:18:21 +0300
Message-Id: <20220630111822.26004-4-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220630111822.26004-1-oleksandr.mazur@plvision.eu>
References: <20220630111822.26004-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::22) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b57652e2-d1b7-43b4-b2e7-08da5a8a48f4
X-MS-TrafficTypeDiagnostic: DB9P190MB1793:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FL+r/SEzH1p+E5PTzzwoyA/QwTouQd6Ft0eFMLcs04AAjfRzGpP1edspORFGl8EOvePimhO0ko0J5pnDI8Dq7zUYJ7vv+qgg3pSph7qeZvKqRH+xXVXBFcGtCmWEaLdsXN4kBM0ek0jR1uhYp6O9DIjoekeHWnGtZi7WeIiUzb1nDtvIoGkUs1O26Prb3PhlQ7NiGoRJ4xNhn6Osl2fQ/GfErfAGatC6QH39nHFaCkItQDceabF1ynpb6mHs/a4BT79AM27GZF9w7ct+t1y4JabUYR8Mo6boW73LrPbrzZbV2rfnSa9R4d/kKXZMXoygoQHdleAT62bz2dQoNsUmHPHqo9bz/pv6lMF71qBbZsynyrc4OtBwXMWCd4nt/+djAsn3NSE7D4tmPDY+MMSIcyh9AwJavu52jxnTDtDBkAZ7e+Yl2auhTkvaT2oUyAiLAqVml36DzW9mLZ0pW6CTLlTwGOjKMclwwaliJ0fZaj4ODjuAuTEMMZmjsnnWwQKadhWGCEIJTSKvjoDKu5OjdgSUYRnI86JvI3qsoxSJxquA57M8eAM1bVHRipsYcR5gZ93xRPgBpUWry/9T0pkGMcpqBwFxClet93n9PA7U3R+VXLFB/2GUX+N51oOhvPcfrvXwv2e9kyOgYFW0HERUfux87KjPhLZjpuxczfBMsnUIlMfdAH4p97GtzyfatUvz4nt5OELSfPbTUoLudq80SRbO1ZXTnzoz9T9TdhHZIP3Ym2SdqPF4Re09Be3oWhD0m+x/ueDkwsU9D4Ubab5mCNM1I4e+FpGPr/a1O7cYXcZYXe064lY2C3vpdWdDH66Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39830400003)(366004)(376002)(346002)(2616005)(86362001)(316002)(41300700001)(478600001)(36756003)(2906002)(38100700002)(110136005)(1076003)(66946007)(52116002)(38350700002)(66556008)(186003)(6512007)(8676002)(83380400001)(4326008)(44832011)(6486002)(5660300002)(26005)(66476007)(8936002)(6506007)(107886003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mehLJFXnCeO5VlQuwnJwZJMSgjgwMR0Dpp8ZVyOxHrTGH0vFb2C0HFRY8B4k?=
 =?us-ascii?Q?qpFj7QbtF8+crd4nlWz5LFB/5hl//w2mlIMxc6pK/m09UIryPV0G1hxKh55U?=
 =?us-ascii?Q?B2CJao9xyj90rhydbhxFiP3SFZ8tapdpD9KDU5NNMW0qWJUVqM/jFA8LZqms?=
 =?us-ascii?Q?QkKPKJufn4OOJm7Pwc0rVl5Vz5TV9aY80E8O9uog16zebzMi7U5+BrSeGkks?=
 =?us-ascii?Q?p+y++DGK4eowGCg5lhzcq6P4uP7g/mn8fAGW2RFVWNl5fP9u/yFMgv0WKfKr?=
 =?us-ascii?Q?t9LPuAuMdEo2f54Nza8nruujd5Uj0RL+SNV7iBqTWvxE4R3lj45c9pvkn9qI?=
 =?us-ascii?Q?nuJRv3Nc+s1mh/tfinfO7CvYkDNHSKpg+RyoidKyrEs/afYKB4L8Bs67n+xn?=
 =?us-ascii?Q?F7qEL2wn7Fvb3pog7JNqf+AnPs+IOsm3/q05ghcETIU1nhRokq4F1F8t0tUF?=
 =?us-ascii?Q?uBRgZE3TL2F+nuzBUX96CshQpMv3fsvwUMWexdxV/H1eEP4a8OejyhY3cpVs?=
 =?us-ascii?Q?aUCb/3zwPd9qAWLfeGYa4UB+M1+tgd/vL3eZKWc62zUMJFD0+fmYg8i3eAnf?=
 =?us-ascii?Q?A0hh9l8nBy8I8LCWQVSCJYqbufBWzOxbk0QAE6F036AUQspvmZQIbU+WsEmu?=
 =?us-ascii?Q?uHZYbPU0ZxzyYqFV/nw3FoBffibRLaUM5KwK+abMc7MJOR+8vMfoOzspokq5?=
 =?us-ascii?Q?mgPsBz78N2hZiu3F+0FCPtYTYRogEiiGfAAjvIhbkCSNf5sLZNfMrX9vJ/SQ?=
 =?us-ascii?Q?z/GMTfXz62ZKy7XQeMeWYRxsDuZUOkQ33nWv9CbWJ50qIITFRmxiv6BlLFd2?=
 =?us-ascii?Q?Q1iSbhcE5LcLUx/UZ/yV+mwrw6oBNGgxA/gCm0qZ6l+PDreiGxIi/I2GG51s?=
 =?us-ascii?Q?PONtZmQOozWBfc0P0LGuVd3K+m5VoGfR3ABWucyeO9jjY3rS4dBj7e8xygcw?=
 =?us-ascii?Q?Jz8W49nXVetrrajzM7aFcYoo6rXWyYS6A6D3tFiRURSrNNJ94bN4gtgMTJxX?=
 =?us-ascii?Q?ZkGenZOyvjZnJZ1UegLXnysowH1osv6/yEdeWO2PajRwPDXUQqgNOM6JrF4M?=
 =?us-ascii?Q?LLcJjWBvSlDymssSEoYxaCQKki2USyHmarSg12nql8pfdZ+s/HGOaT/VxTld?=
 =?us-ascii?Q?PWBFeNboBLEzzN8t1PW1kw/iYX1JCGTopl6o98n5KjeCpJLe1pjW7+LpIuHb?=
 =?us-ascii?Q?RmtZyASdHegxLId6gNC4UghyaiY28+0+2TdYwn5G+sOMtoT1uXzPAEO55dSr?=
 =?us-ascii?Q?d/cGLtApmyN9U79AcazJ1TLgaflvz/Vg3YVymiaro3wMfoi8LO/uZMQQnscu?=
 =?us-ascii?Q?/wolYqEBhbkUbgTYrMwF8YiwkMcMLVyoUXpZ62UTYcwfwEZKaEGTV8xhpiMF?=
 =?us-ascii?Q?xbc8k4+/3fkKYGuzno2O4SRa/h3PqAKtYxE8FTOCCnopgLjNAt3BGbgKAmxx?=
 =?us-ascii?Q?lF0Z6/JrmfzUGYonj/aYbA6R6kZagVmYIUf95pg1RFHP5dhnRQ5t0p162NZj?=
 =?us-ascii?Q?BwUrDmnM0frOgXwYiZgUddYj5HR6wk3C7mZ94Mcu4PL41AjCMz01LX/qk2b2?=
 =?us-ascii?Q?k6jSdDOhAvC6AJeeLnfptlFUQq5eWqtkYwqW0xTw6CaD4aFmYt0VuwO05VZ8?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: b57652e2-d1b7-43b4-b2e7-08da5a8a48f4
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 11:18:40.3422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YA0+uBLjKp+6nHzPsSmMop8Z0aDGL9rg1vHFxk95o8YsvzxIto7cLKsXqlD+LEZ5AKZ1zuIpb6Tt/6r3UtwYMd6HDHFT98ifGxZ4vHzrWzo=
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

