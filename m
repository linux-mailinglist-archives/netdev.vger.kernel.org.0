Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6018A3D650B
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbhGZQTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:19:21 -0400
Received: from mail-eopbgr00065.outbound.protection.outlook.com ([40.107.0.65]:22840
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241871AbhGZQQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMfz+hsMVQ2/yrJqru5F8y4SLnX3IHGfCjU4pRnOWCUWIMdAebEoCWGKo1VsN+IobiULI00pKEv4HlKW3B2o5ud47sdKr7s+kocn6O6TM1iNLfdqJcgiGJJ1PsWlIC7cI/ZDY2MWt2XBOKhyhXou5bOI4Da0fy5JbCHqSakXD1riYOBZeMrEz64C78SQ7MpGL1FKz940qjDSUkGW3XmrCfll38heAULpfSC4QIc/gtAXAAt6VEWryYhsKqKtSiaegcpvtzhnItMlsxG888s8vPna7OmkI5UpUkeRIuIEwZsIZ+RJYwGtLr5IGWn9g/XZ32Yz3KBja3mJwEyqzsWhEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJm5zgrDZ4AWVwSFrnJ6qBdExjFZCEy2LCxl5fdv1II=;
 b=B5WY/0piemJ11P0BHzvJP0onJ2SHx/zV2ikzUoRee/PJt/ob2wZRFsQxkAxNQuSqN9HKnsQWHCJMheK0d5f2hlZN0SDhzO7OMnIPodk2Xm1xpqZi6TAW+unAgxfs9q7GCmQad+XV+gyJUbV5x1HmYqxJQ3IEaeUmOWbQ/OboqGwNp7BpiLJJ5sXIHb9QgIxOiuMsj+IX1HfnA1dFUSWFxPsgaNPCb3o+7fLXI+Jn/Ul8LZjQ34vOIOG2e0abthTTdm/ZeX7vyr230h2M66DqJWRWv3/OZ3VpYlvGoJmnW3rhbsS/pQM9RXlI54D27+/5aKEkx/SCoGK44IqjB6EbXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJm5zgrDZ4AWVwSFrnJ6qBdExjFZCEy2LCxl5fdv1II=;
 b=Aieq42KJ8eRI/D8Lv1elZXkn1m8ZKtbcHa+HZcNaarnk1kQiHJ9EIk+jrO6mGHeKuW9aA7q2bySe9JJI6myo4UyAMYX0WZoJ/6YNC3qFX/t3FA0dIf2lvqL2qad0/5zl+G01cyVQ+3Ba8acRug26RFH99wNWHYoHo6V9/tS6Mfo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 16:56:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 16:56:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 5/9] net: dsa: sja1105: deny 8021q uppers on ports
Date:   Mon, 26 Jul 2021 19:55:32 +0300
Message-Id: <20210726165536.1338471-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
References: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR05CA0078.eurprd05.prod.outlook.com (2603:10a6:208:136::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 16:56:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50112ec6-0c90-4b92-e836-08d9505640f6
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB732817685F8722446D4BD590E0E89@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8VLT5A/ZrIGq1XWcH+uqUr2C3bK/HTKqNFCH7HbG5PKHt89zkbuigf/0E48s/ug/Jq+A9u01Jm+4GckHgSwb8wTU3s26c55PJkICckvGG+YOr3zlyHWGPJH1gF0U/CmbBtUSnZyUlL0O8Dl3tLXqMIofe9AOe5OyKd39WPynSY5tAXf5c/sOwjN6K22yBIrGVkAAg10plUr0J6Zdhd/v64tML8xq3+k30kIwwCjtSUnezw3MZM+tG+mK6SB7AoNyUoLTqhGBEQ49gt6YidGeHfhzJkwUc98suK4GCBnrJKJvd8QUFRNggizRcSBK1tV7GMGlzK7cu16zofuAaugRUaF8eM20LLdR188WsNnII2pAccqhDGz9+TO9NMfcERNYYhQ+t5g4JVvIdctrs/VGttSzUmLtC1iNvQ6MzNgJ3OLF8PHfcSzkS95y1WUSvdQsDAR63n0fj7kHMFD/Xg6Ih3giZftzwC0xszwZb7ALIQUAvDs1qLKAbL0J6QH+VH2B6Srjv9iuVyY4uPCQTJs2AwV2hfuwpw71CH6MhCXDRWmfRldhthy6xbk4e628ciFydUdBHf08CZwaqqdlP6LfacS185Iz7AJDWpWfQ/SC7T/GVZ9OC2YYfVSZkdGOxvdfCWwzC12YSdtKi2S9HIC/NcsaLCB54lli97/+YMFttGiWPIgLyoV9f9NT/y6BF2L1zDeFARdwZnA1o4TaDiEHMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(36756003)(38350700002)(38100700002)(478600001)(44832011)(956004)(6666004)(86362001)(2616005)(2906002)(52116002)(8676002)(8936002)(66556008)(5660300002)(66946007)(54906003)(110136005)(66476007)(316002)(26005)(6512007)(6506007)(186003)(1076003)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x/Y4l7qlHP6fbvbr61J19UAh3uLVbLEzVpjAGyGJaSzItGG5u54QB20P8G5Y?=
 =?us-ascii?Q?5xA/TU8MyTlAPjXpUO1Vnn4scMNLiilSv7wb7mp4UezDJrJWLH/l1Qv+XXGJ?=
 =?us-ascii?Q?n43mKAsYbHZegKQq0e6O4APlrOAu5y7dF0m/MqOBHQ2IuBwBJBEwAeqdcqiT?=
 =?us-ascii?Q?eeIzntuBAXVZ7yy1R692lM/QmkJkW3KjZdnk8REaWC70EcgmwGcl5+uWvwbf?=
 =?us-ascii?Q?1uDH+CGfOUlZ30zlqEldJjTujoNYNHFti5TrKWFGiB/SnuUUtnPR60svYWMm?=
 =?us-ascii?Q?LYFl1XGaIGPp11yCcJJnorh21HVEuvYB4PEpmw6YFF6DL8bP3pOvpb7FfLgP?=
 =?us-ascii?Q?bg7wIpz5YXHs03JppPgxxdSIaq4Q4IJsIh1zTPITrjQvwAbwLJ6cHk4wqH00?=
 =?us-ascii?Q?b1Bss+X9IGDph/VTRSta50qQqhZkw3yNSPJha3oAw87G54kZT+MovbJEHNbj?=
 =?us-ascii?Q?hqJ7iqjcbFF2XTgUbqwd/u6awQ8cXliraTeS9YMIrKUMLoqyhhWuVWTBtJkO?=
 =?us-ascii?Q?SWgDXvLE1ku8ojM9K6Vh6Mv1ZcgpBm5d21pIh4/Fon1xLew7PzfnifVQkuVc?=
 =?us-ascii?Q?cIjt8Wa/thR47Dq+41YdHmn0S4FFEf8JgZv9ckpQmPkJoYp/pq/GCNNNR9Io?=
 =?us-ascii?Q?EPOgrNWaUPxsSfTZHv4faetnHFaeY624kxmE5nRoQuKas8ZBaqcC32BqetSf?=
 =?us-ascii?Q?L4Xx+mkYIYY1DOaV/ZptI8ZHBD4G8Pyr2La7tWqzNSlCSjBcazlkPxCsRJCr?=
 =?us-ascii?Q?89mkz9w7bePss7aKrvaZdIG2YGRjlhTv6FwvVrhufbBlep5pNdnz52qsnezQ?=
 =?us-ascii?Q?y7yLXqgN2w8whYXUmwo371L649icv1gaKwWm2461NlmSuBaCEoYhfanvNh7L?=
 =?us-ascii?Q?U0mSxa8asdu9DYzsltt5Wi+vKPVSWX1Wo1jIoKFf/ROwt5KGBQzl/Ze4foFQ?=
 =?us-ascii?Q?1iQcjOln1S8TQxtNRALUsIpCknsQJmejsWAK33PYm1w3ILedi+KHAJ+7WY/r?=
 =?us-ascii?Q?xJIFpQS0fz3CF6HacGxE+v+xVrB5D/0p1AgIPxM2o41eHoU2muTJ1FRGRIGG?=
 =?us-ascii?Q?Jv5i9FkBmD/zpki6elUMvvjuk5qb8l/qdOElHO0yEb3t6lwBXg9jHbcb3iH9?=
 =?us-ascii?Q?Uj4J/htXVLtl6fJNi+DLwIiyHS61lfsrhaBb2oE12yWagaVr8vt5cnVEdb80?=
 =?us-ascii?Q?D9/ZswmobHDUEBz+cUTlBXbSWDISUD9CXDTwgdY78L3P8eBSVrtFtMA9vFro?=
 =?us-ascii?Q?9nVL1TuOX6aosOZ+h4P+cjuR79ZBgiT/vXt5pQKhlRAZQ83VwguZwK4oqeIC?=
 =?us-ascii?Q?ivHY/scoiGmvnRhMIM6rBocI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50112ec6-0c90-4b92-e836-08d9505640f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 16:56:03.8547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P6uGv6WXYMRCQDQNhA2cmcea2rK5R3SiSsBZUhuEZTe3MyGQ6Awup0YM6g2hds4/QDHW9sTHM6RiprkSvKCj/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that best-effort VLAN filtering is gone and we are left with the
imprecise RX and imprecise TX based in VLAN-aware mode, where the tagger
just guesses the source port based on plausibility of the VLAN ID, 8021q
uppers installed on top of a standalone port, while other ports of that
switch are under a VLAN-aware bridge don't quite "just work".

In fact it could be possible to restrict the VLAN IDs used by the 8021q
uppers to not be shared with VLAN IDs used by that VLAN-aware bridge,
but then the tagger needs to be patched to search for 8021q uppers too,
not just for the "designated bridge port" which will be introduced in a
later patch.

I haven't given a possible implementation full thought, it seems maybe
possible but not worth the effort right now. The only certain thing is
that currently the tagger won't be able to figure out the source port
for these packets because they will come with the VLAN ID of the 8021q
upper and are no longer retagged to a tag_8021q sub-VLAN like the best
effort VLAN filtering code used to do. So just deny these for the
moment.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 309e6a933df7..a380f37fd22d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2252,6 +2252,20 @@ static int sja1105_dsa_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
 	return sja1105_vlan_del(priv, port, vid);
 }
 
+static int sja1105_prechangeupper(struct dsa_switch *ds, int port,
+				  struct netdev_notifier_changeupper_info *info)
+{
+	struct netlink_ext_ack *extack = info->info.extack;
+	struct net_device *upper = info->upper_dev;
+
+	if (is_vlan_dev(upper)) {
+		NL_SET_ERR_MSG_MOD(extack, "8021q uppers are not supported");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
 /* The programming model for the SJA1105 switch is "all-at-once" via static
  * configuration tables. Some of these can be dynamically modified at runtime,
  * but not the xMII mode parameters table.
@@ -2846,6 +2860,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.devlink_info_get	= sja1105_devlink_info_get,
 	.tag_8021q_vlan_add	= sja1105_dsa_8021q_vlan_add,
 	.tag_8021q_vlan_del	= sja1105_dsa_8021q_vlan_del,
+	.port_prechangeupper	= sja1105_prechangeupper,
 };
 
 static const struct of_device_id sja1105_dt_ids[];
-- 
2.25.1

