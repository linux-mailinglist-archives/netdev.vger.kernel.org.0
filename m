Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3EB354F51C
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381757AbiFQKPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381752AbiFQKPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:15:42 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130094.outbound.protection.outlook.com [40.107.13.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25BE6A076;
        Fri, 17 Jun 2022 03:15:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzNoD/M5LTu5OCqBFePAXyD1CB1DCqhsfj6tGC6gQdcMr876X7Y+FR0Il8bcjBGxN1zET3pREyE7YG1iC3OUz6TusG4VOBDg7BiPSt9BjHqZSpxdrwTJw/NQRnTm+rCde5TfmvSq8l7A+hHyO3ZDg5QghoYKKUrZt98xaPnSZZG79wbrPbebaz+ErPjWvm+M9iGm1f9ipe3ckiiB0nup8XZv77BfpI1O6a45w2q5ChcwNkAw1iwfi9aXP+/1La30/Uz4APresJuC8K8xnAZ0TB4kNGkbwoInPfjPcYALuLiCIpxJ+gS6JiWuOXJE5ScY5YL1/rGGFF7QEvEd6G9Mag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WQSVQXTsQyXX/wrhcNhWDYosdRleV9DrjfH+hjjW5d0=;
 b=lEw2bQpH7DphOjY78qW6mFI/uYrzdHqMGFQ0vWMiptPshfwGa7EycNMwXyq6Vbla20DUxG03Ex5ekgCjB1EN10sEfc782iYelJE4ZW9ZM1y464+LwPu25axVCqHeLLYbcOycWkRh4pUJzDTislEo6rgNe5PNH/pHlJvLexQotTEIMDVAcaygkDZ8Zef28Qi2G276CF9h6draOBGdb0YkXb5bYtFq/bFMiHPB+mVgqre841R9+kow0DJbZdlsUr0Gf2dQ71IE9peeNITx8P4BU070AwFb+g3qB3R9RvKlby069HjyhAHU04iq5UScRm9Zup4YPga5ytY11N3B3LxZRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQSVQXTsQyXX/wrhcNhWDYosdRleV9DrjfH+hjjW5d0=;
 b=ffLaZIjjMqSIBZoG3rJZ3WsTmh5/9AeA0XKd6DJHaKSDTLAUsqhyfqQ8XBTb0rjlw4T8wnIYgK59LBN8pYC59ChQpjHXXpDUO/lJRKucCQTC9l3zPk+/nuLfyIlxm4dVI5OJWbQQrxl1igELN3bOlLf5pfGpMW6NaEdpCguxqrc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AM4P190MB0051.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:5b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Fri, 17 Jun
 2022 10:15:38 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 10:15:38 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V2 net-next 3/4] net: marvell: prestera: define and implement MDB / flood domain API for entires creation and deletion
Date:   Fri, 17 Jun 2022 13:15:19 +0300
Message-Id: <20220617101520.19794-4-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220617101520.19794-1-oleksandr.mazur@plvision.eu>
References: <20220617101520.19794-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::15)
 To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01da3fe5-67fe-4172-4ea3-08da504a5337
X-MS-TrafficTypeDiagnostic: AM4P190MB0051:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB00518972F8C19BA9DC5D9C10E4AF9@AM4P190MB0051.EURP190.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2nij6OoOWMa0NX13aT9P2LmBa/LIbtX/Ed4h+tjnGgBJh/pJnMCI6pcbqYZSaqUql4ugicg/YuD1RkrNkX1xvffr+kzEbXuqpcXdvBzrFtdPzeqN9s12GaQxcHMfp/gCuOcEdhGItlZY9jMmOOISmEOQtWnpUd9MCSvkfGL6I3UGpde7bgDE+NkVpJFZ+BgD7QTjI4hVmnv/TvZ06D853SEKEA6R7BjAyEqdrZHipNaiRtj8gW2y0v4/EfFTiH3zwPRzqS/brVDHGlTPyh0W0awZX9JjGHe/R3LtYEhpOvQ6pl379ku6QRdlxj9LVfrOE4EBHeXGrtK6CfqGK5bIlt5DRt16grh/rKuY+U7QmaQdC/edtod2uOCUvlH9nlz3183v4VKGpEsSOly9nDhGCnGAIbX7PH4S6MJXOWVXTcDtd9AEnazEBcddvcBmfQ2xsbEBSBJJwc1Ns5GhurtLtXusLB7FTGK6uKgVQ3a18mfE7XqNQVm+cveB10Z8cCuXxKJhMEwRszUMckW2F3cu6EOXG4VenBKUJ2pgaCLYk9ZdDe/hcw1HLZJnTh2/X9HpJJCHQ9VaHZa2R7aJF7m4Z2YjANfHUAMPcsJ+2QxtS4lGu/wFQZd7aabr3EAPLIFdUxE8518i5wNdsZjdYeyUe2aelGj7u17k1OvYpw6hvJw4sPui03+MuLvPkEgY2f9S7CaS8Jl4AxTUQE5KzYgGLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39830400003)(366004)(44832011)(8936002)(26005)(41300700001)(83380400001)(186003)(6486002)(5660300002)(508600001)(1076003)(107886003)(52116002)(6512007)(86362001)(66556008)(66476007)(2906002)(4326008)(2616005)(66946007)(6506007)(316002)(110136005)(38100700002)(54906003)(36756003)(8676002)(6666004)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rCr5d5ugs/Xbhnyd0p/LBHIVrwnHflRq9Z4KbqY8S4FEvUCxHXPmJ+G1apQ/?=
 =?us-ascii?Q?vx8XEx7UsyJWLJ8wckNUPvXmLgTEgM0rwN21GiCAeQLAWLHB/nVqMJkRz7A4?=
 =?us-ascii?Q?X5J+grMDSuONkq7LcpbjhEbVklvWgIFA/2VU37xLEl0G79tHHN2p0g2nssfb?=
 =?us-ascii?Q?z6HDTAWlBHJA2seBh7M2RzPr899o4H2uZvf8LHdwYMareGKRSoHEwP+OYE7A?=
 =?us-ascii?Q?FGWOxcV1BxV1PBwctgsZ4hTyL2YCT8Fa4d0jjzJKzlfe0zwBIQnGMLcB3x8P?=
 =?us-ascii?Q?s0H7eanswOrJ5yy2CcqB3L/NOFaEW8vHvEjZiWsqMh0h7pZoOi6Ol5xwgwWi?=
 =?us-ascii?Q?1OB8nDeH4W6s8Giw2R26EpiKB/qOdAvIViDldN7Ygq3JEkHJjr6nIG9SWSkQ?=
 =?us-ascii?Q?WyzwhVr6Lg1uHdcalSfm59TnE2IPIilwSB+aY8QNiVZ15iszSXbHdHXbt9NX?=
 =?us-ascii?Q?/t7/Ybh+DDWtXKdDVqogfgca8T+k3kFlEi1XOLWUpMzmGJ7xHQ+LYiD0UllA?=
 =?us-ascii?Q?HtpKeFN3/1AHDMBTHxmghF+HI51cLvY1x1tgx3xNkXBmKLTyDv9Px2pwvmlb?=
 =?us-ascii?Q?h5oQ1n2/HD52QM/nmsUMS+xucH+9xywD+lWDlzJfIacrIxSKuDZtj27FtO1u?=
 =?us-ascii?Q?axsAM0OF85Vc6O0EAkg58kFNxW4wD6AiDhJchLOcYONFmzJDh1//kbuT5fA6?=
 =?us-ascii?Q?HGaifoBtzPzYTsRNMxhOElmcDGDCGpQGqqUFZqbL9SS5CHJYC8ivM7Btcsnx?=
 =?us-ascii?Q?7RL9yc0Q/vxEhKj2HDl8UWitTryeJd0WWdg8+28nSuAbYoROCtVxPGKw6IOf?=
 =?us-ascii?Q?C4FhGAa7Dzje7qPdDXDo7pVAbimfemdiDDojkihZIoZZoWY0Dh6AcUhTHfME?=
 =?us-ascii?Q?s0Tea/YbGtcmruB8pNNzrsY5IEVcRJhO57a7Sn1wzc5ZlVmC1QnYKoMsr0J6?=
 =?us-ascii?Q?Qtk9Fm+ywsXJ8AOd+ljAaslx+3je7SE23A1NqVEW86QvkUpKMPvhQDQNIeL8?=
 =?us-ascii?Q?RRD6Ai8n4N6I9ZKBdTxUn19I65fDRrwajZbrtKqWvenzNqZF3YgmLZLLJJ8a?=
 =?us-ascii?Q?d4oA8IskcnRd/jX6uCDy3r27+sZuASkt8uqdeDAJCwWly+V2Y1U8lPETS+SG?=
 =?us-ascii?Q?uvcX+qH8MiiSRymkBS/pwNHmq6C0eUaLmttaYC3aJH75OqSYYPVAlte7bRkp?=
 =?us-ascii?Q?Cl295WpTEbuIbka6aNC4VHJkJin0IvBl9BAkCd2hRY3yhMoc9hkMY/qirY6z?=
 =?us-ascii?Q?0F6SZGVWTnQxJ2X7cPQsKzdjirf/7SBbuMEnG1uVVe78C8c4Gjle7zD9f0MZ?=
 =?us-ascii?Q?4MewOy5RkN4w1B/av4uirg9OMfSkMf8WEWqmbJ83YugI7vN/t+4KDqhvC+tK?=
 =?us-ascii?Q?eXHc11DI2eDBaqjpvY1d+KH434XV2+BGSA7TME8Jz7D4Yr00pfGvdqGAnPJB?=
 =?us-ascii?Q?VF7vjaaJgoPPqH5+OFp+PKo+5WD0F/8I9/PQbf4vZHTFzcYFBlIyxr0CdZ+7?=
 =?us-ascii?Q?Y1yqfWmhPpOs5DAuY3srih65D7eDULjajm9pzZw6dcFGBYtHbYJ0i0zjOuHF?=
 =?us-ascii?Q?g0gqcOlBpNpSL9DfKImPFN4PHlBVvsb6OD5Q3yibDrdvJDi/u0IoNw7tZHVJ?=
 =?us-ascii?Q?rYlpdm3KJ9a21SAKXLc3I9U9/GqDNib2xl1smnRjqHB4EohqMTLCg5JEbhqg?=
 =?us-ascii?Q?gprs0dYVc0tCHGwM2ZAlc5rR9LJUWuRMU/senysnUq1xgbFmCbdFUZvOHxc5?=
 =?us-ascii?Q?OMNAyrwdnx9bS8mR8xpjevq+9Pk//oI=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 01da3fe5-67fe-4172-4ea3-08da504a5337
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 10:15:38.1375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mE3al8ku7CSHRocNE0AdWbvxz9zHLiCvKwhWo4FDqyZOtI2KXLIhbMS6Im4Xf7m7WN+GZcHROji7cxtA62cZaNbm25yj7opL5+4DBpUYQqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0051
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
index 9c7d59fbbc83..9b109ae563d1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -368,4 +368,23 @@ struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id);
 
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

