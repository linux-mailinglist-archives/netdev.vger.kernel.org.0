Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634492D2A52
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgLHMJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:09:24 -0500
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:13187
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727650AbgLHMJX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:09:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVndl1q6QmfUjDWswp2B+8FR0gYLboRIEYCN+WzPdbJBTS26pJgqwH3CptRyezyn23MIyHWSYgRHA7Iyc7+Y7NwiHdr4LQpjwlHpkhjV6UbGHIEG7dl4OvicP62soAg5bENiPtG/VOi/jK4oHUfJi1XXy+D8N+R9TIrvKLcCcUOHQZ4HzgciBVaFf1UxJDUK2767lNyyEB1d7TCKjclhGv0GSKQWTs8TqyWJUST0X1Fqt9bopLhwPYzWGi8tclyE2IjogWiS0Vpc410nmaEljkeoVEqd9HFLByLcJFoUr8zo6lmbFBlON4NC9sVkGmP5WGpTyDo9N0gz+GRKvPl8gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mC+/LJuLGZhWWYdd19R01xP4ACEd3zBhKZBBPkbOsHk=;
 b=YVJSDcYtEQPV3IHFqHLK97cy23FMHdn4ERy0EoKv/L/BLfFUFu/uHFC9Y7ccluNv9sz+XaH0acQ+mmUlXW5O6jV4153PCgLB6P2sLGia5/1F8dGfh4e6ZKIUdTVYY8Bsr6KID8wxgdYG0l1kbXvbg0452zEUFYAqYQbljtzoYgK5cqjkRA7TGrbEhfhYxGBWCeHhXvjj2fbpPsT0UPl/Ny9b2JZ5LTZpbK2LEHL32Za1ZzT144+urnzk3Pe3zumPtN7x5B3FEobiILSP5nHAbvbk2xQuQg/xTj60GW4Ss41sF/H1+pOCjcVmrJj5Qfiaz2PRHD5wowM/tZr2lc8npQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mC+/LJuLGZhWWYdd19R01xP4ACEd3zBhKZBBPkbOsHk=;
 b=ARpAGtdePhJd27ZHM7xDHxLldwfINgcIsuUvCd4MrJ9PQi1UEuTBPgtxxnIMEhuijXzWjP540VyEIpKu4m9LkcyDRklsaKJ/7KfjyTYA1uoErNe9iQTugihLtK3gL9pjDAq802M7h9O8NU76I6W6XeSkBjUSriWO5y93OfMIVZE=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:22 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [RFC PATCH net-next 02/16] net: mscc: ocelot: allow offloading of bridge on top of LAG
Date:   Tue,  8 Dec 2020 14:07:48 +0200
Message-Id: <20201208120802.1268708-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d7cd39a-416d-40f0-b22f-08d89b71f547
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5693526FD671AB31A3899471E0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HT/9yn2F8zWA0TpGX7DNibyz62ujBDaDJayPOBSPTKrs8zOqTzNWSArbwA6UFiqfdy1voobWncrZ8kbvSEMhd8pyuCZh8nGHX7bgNtbAqz7TisMstKC6r+MYrvm8NXDqxCYMYEjRqMZXrVnMawdA/WsHEMSjmUa0U2DH8RQ+VDuxMzFQe3YucEAbcciLeku7oxKGtGXT/geuJ9/LSYy5vRvxRq8EfuB6IA9GNU/V+V/BUczikhVa1RWi7N+rD/hVOrDMPqAOy6KtxoALYqQvX3enBAWF8ry6/QTuX2DemEl9fiEd0H8cUkTvHhvBbVyCRnQEz4vbwCYujXUWOqIshzdc86rlmLN4X0e8nkqXDuSBkL/PfxH7AeIiY8zSTIl+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3dJVLdDicMVh349M2qCpmV7+79ohK+xkBkuNYY0x8P4phFESBB1T6yZifqOE?=
 =?us-ascii?Q?rls6zMlml0lt+xijBGfu1aYmK4oI9MuwFFH3XIxttvQbqrZi7DXs3wHdNR8o?=
 =?us-ascii?Q?MKkoj0gKjO/9wv74cfbVgXv3TbEvQYU7lfCJePNryDAYVlvNo8aqi8J1fNvl?=
 =?us-ascii?Q?PFy5qll8xa9uEhGFWxQ7bwqBxinvoT2dxU6lS9pV+OPqF6ee0O/jo7Ugzblx?=
 =?us-ascii?Q?1UyF/hLrFmHuZTWKcQnFa114zwPeKdF6whFINHmiHDwyBY+b3yHlDlxgyU8Z?=
 =?us-ascii?Q?dBnhWqZR9KmHTUfKjByHoDbsaF3/SgC5gqb7I/JKs2TVFLPeW5rHK9yHLWZH?=
 =?us-ascii?Q?393+UPbZZyGOG758tRV8ul3K1+M67RjHzgqR9HsDNQc0LBohUdHgNd4j7CRq?=
 =?us-ascii?Q?FiKJsObQ6fjo/n9P1HT++tRXiU0/Sp7rfmNuns5WWNxPYwxHL4ayKbHuu4wi?=
 =?us-ascii?Q?wlN194AtYxLp7rZss94WxYcMSOwv+wJbXa2EOGdDLFxkQ0dINdhD927tiPO3?=
 =?us-ascii?Q?DSWxoLcrVGJtmGWmjwKXWlg9Kd154cM3ZTOVxlRNRZ6M7KYKJnTp4veyPhwN?=
 =?us-ascii?Q?HQmU5yoXz59Jr/8HBgHDYSlbtl00MwH1IY0wOeHtGTaABd1bCqps5l8nxJ52?=
 =?us-ascii?Q?7J7m7+4Wtp61EdxemoNr5Qlwi1GEpJ8dv77YUsQ1dqMNls37PJyu+vgKoy9N?=
 =?us-ascii?Q?Cwz5/wIbDNuU4VgsrOtrG+yHMNa3CM7+26VXQbUDWBOCg08yyx1M+ONS5B5R?=
 =?us-ascii?Q?7hN7h/rq8EvSQmVaUU1i60QArq7VlsIyMuT+7sfW92Mr0s4yM6PAdtsUjQt5?=
 =?us-ascii?Q?x2uqBNKhPYT9q+0qDfF9+7j5+RnF0YsC6M7jWr2hxeAixSUjTbAIgNbGgXsN?=
 =?us-ascii?Q?wvTLgc5DKwcnpeoAKUYo5r74ROvgZiHtqzjLvXeyDuKYsq6v7vMQJdVDY10R?=
 =?us-ascii?Q?mtUOgrZPCAXIFadjjHAN+Lplxcu/gt//Xha5SFpz2aS/5P5xJKeIKIy7fLRw?=
 =?us-ascii?Q?4ULG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7cd39a-416d-40f0-b22f-08d89b71f547
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:22.4399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a1o/Nzb1ePNM3CPCBzfOZfogfqySLcYBCw3GoOR0xf6LPTQy/iWCSB5HXvmbULSNHEj5vRvT+YFtu/bqdhDweA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7afb3e575e5a ("net: mscc: ocelot: don't handle netdev events for
other netdevs") was too aggressive, and it made ocelot_netdevice_event
react only to network interface events emitted for the ocelot switch
ports.

In fact, only the PRECHANGEUPPER should have had that check.

When we ignore all events that are not for us, we miss the fact that the
upper of the LAG changes, and the bonding interface gets enslaved to a
bridge. This is an operation we could offload under certain conditions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 93ecd5274156..6fb2a813e694 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1047,10 +1047,8 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	int ret = 0;
 
-	if (!ocelot_netdevice_dev_check(dev))
-		return 0;
-
 	if (event == NETDEV_PRECHANGEUPPER &&
+	    ocelot_netdevice_dev_check(dev) &&
 	    netif_is_lag_master(info->upper_dev)) {
 		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
 		struct netlink_ext_ack *extack;
-- 
2.25.1

