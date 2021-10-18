Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35404322B7
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 17:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbhJRPYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 11:24:12 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:18150
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232248AbhJRPYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 11:24:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiqmQlUCBy7eOIJhr5c0jjKZMNeaIODrO3SVvyxZWPjr/d4wMoXo3128FQ2LbwmB/q0K+Od+XerzLqO7yZPRBGG6sJBMQntvq31qHc6aKSI16UTdVPekhBePOyxo+EKA28CONBPp02BaLrfO17BoG5pMSWLr28et1apuU3Jf+6nB6hoQdhzCq1j+Vhiw6HFA6kG/G9APTrPHPAlIlbWAs0hp1T5FOQSHneOAB1YwirdrFVA3lvzJ6LtOCH6ltCpYDMHNnf1HxCTq8dmduYb/udW9ofciM53MoRjMo0OP+o6dtoFensNBdWRcYzBYZ8Bf9CDh4vWebcle9DJeZxYsBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g62jgQ8NGg9gXhiPHbfhHQYjLRmTvQATxq2kGvOaffk=;
 b=QtaRIwWFyOAKwHfivLbG0pRaEdJifvM3THYQ93Dk61bcp5MwOSRh8EsVP42ZfNG86fz2X22hF4TWurDZEMECtCccHT2GZuvwCRvYxrFNHfFZi4/XFeHxDBAPtqr1jVGuqTpQbYZaKAIU+qfr1Tzfb9FUk6FtoY3d5oK5nmqYuHPp2zLL1FLa68zVQAJKS9j0j5yytEJXouRW9C6nAdxPSsf8torhjBvr0F00N6IwUhkm1m23L7ryB2Piv85A1yEo+i1bNqKfwccigWLcqxNbxRAFXttzupDwcCwRHBtzFm8qaRzb3/Z6xk5c/GVlbgve2kUx1vSpAmQ3ZmOULz08Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g62jgQ8NGg9gXhiPHbfhHQYjLRmTvQATxq2kGvOaffk=;
 b=QNWMX01E5mW72oSJBfwTLWPfD+4EEkLKCE+PSARVLuWhU3ihEGQcc8iqdflp1I1V/R3o9jnmd0dfWjsS6y/iXp9XaKRe94TExBWn8TTQ561g3K7A3NEC9KVmupUQx3vwe/BRCNNAGR9e5lVtNpOJELZxdEvOdeRmBVF4iwMB1iM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2688.eurprd04.prod.outlook.com (2603:10a6:800:59::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 15:21:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 15:21:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 1/7] net: dsa: introduce helpers for iterating through ports using dp
Date:   Mon, 18 Oct 2021 18:21:30 +0300
Message-Id: <20211018152136.2595220-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
References: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 15:21:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4f58472-4565-436b-64cc-08d9924b0459
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2688:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB268872E7CFCD8BFFF800D6A7E0BC9@VI1PR0401MB2688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sxf98T1XnfSVfthkl8/soyX7DBiNBCNqw3lwycY9WxGRyUR55lrMJKcbhRL2ljI5D20ktvHTCNwQqHVofiFe6tDshbjzr4KvXFmd4NfH+oNdZWmFNdhFYjYl2TXW8JCKBwMznPd/b2/jAbNXkmtE2cGQsLaS/Sh/vGH/zpqiDo4zvQ12zUhSKTQoVXLRmbJA65JCLxSYf34QzpHR1ZrFx3xVIY4fT4Xq+RFLtz9HF0rZa0A7x5VgtSOabrWTW7S1VFtgEuthEBfhl/d6uwcf4wh2VBdgfJ4sGFvw4ciuvBVpDZISd8RvaEqtHh3xi+kGUPJ624i43EtHNR2eryHqzDGhIRIlRBF8tiqL3Qrpt+TkYIZQIh1+9HwsJAwc5rVpTEOA1ptGFyvKx1PUPDPHrYsbvT5HK2GJ3Vi2A2bHk84iXrI1WoHqywpdzCEA5I+TABGn0+p1NOA+mvd78TG24H7pJ9HmG/cLHbG/GYG3h5SIa1kpsyOiXj8ieCtfftrVm2XqPR6CGmjrEMGhM1Qy/8H48Jk65p+17GjD8nVouVUgPzYNHeyK8OFdsnek5RUbUAnjMnTDL73H44ZqympwnG3eArudQrhqMYpLv341sxCccZxmVfuDEkdi+Od+XtkEAa3bsBR8HcLmIWCVYmi2ZpPHJKzumlB+3zabFGSC+7ytG+sJf/oq7afNVTN3+0NSoinjuBRhweHyz7ioyiMZtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(110136005)(956004)(2616005)(316002)(1076003)(54906003)(66476007)(8676002)(66946007)(66556008)(6512007)(508600001)(6506007)(6666004)(36756003)(2906002)(44832011)(6486002)(86362001)(38100700002)(52116002)(38350700002)(186003)(26005)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yMWVa7+WE0o20sDRpHx/Dpfza+d8KlMZ77kE/5Xy1/FWA8CYwqEeiq6h3r4g?=
 =?us-ascii?Q?SvswuYLXrU6wQS0jPWD5wUsQMyB6S3iOexjz6828p3XKoAOocs1JqIhVR4WK?=
 =?us-ascii?Q?O7bA1D25wOkgU+IDjocNmk5tqyqOImQM6yrRPBDeXY9+7piH46XjiiehygQ3?=
 =?us-ascii?Q?hQRo+RsvXyvTEUKsAiOfWFQ9AqyBNnstMPZ901NprROKu74uiaJan0TQUxT0?=
 =?us-ascii?Q?HodyCLTM3XvZd6CFvBk2dXpx46wOSWIV7UD10gGPl/6C31PMSU3Exad+FnfQ?=
 =?us-ascii?Q?XszokXrQE51aod9Qu4NBbEOaXhhUjumiLC+1sWCqVG+xg82mMJ/EdkZceTHM?=
 =?us-ascii?Q?WDU6ZKaeB2dskX8HpCEtJHDjYVzLyFbUbUxc2ycY/jQbPdQEkNIyi9jZtvId?=
 =?us-ascii?Q?wRlKO6p7L6UbDeiGTbLOUKZvjha2HDa1WJzk7Z8os0kjsUEfcR1ZzlXddLt9?=
 =?us-ascii?Q?7xN8tIqEhV5WY0lk1diKDPkRRUzyB/Oi37E1ycXtd3BpCttq2uJ5vy/AYWrM?=
 =?us-ascii?Q?zFEHw1QTFKtsL3UemVt7GcYMG5r99lvS7j29batzD8feboeGIh6ntqZc5fpF?=
 =?us-ascii?Q?pjZIVoBTKJqXAXbM3hT8q2R0zyfB9tt1kswwmj9NLROz5e9zBgQFM95RB3Tr?=
 =?us-ascii?Q?vMPd8afT5OFDtBOcktNiFeN/b5Lurt+4ufCs/6v5xoeC6DNYEqYVbbuVzC4T?=
 =?us-ascii?Q?5k4FrAuLv/bP8buZw/0+eMWQU1wuFWaE4mjQNUhs4A2qzY17/Ci/a61agu8H?=
 =?us-ascii?Q?2K9Wwx+QIhLaYBskCI7p0RDhf9hKlJfO7VUaJFOwiSjWa8q1wB5gnaISet8d?=
 =?us-ascii?Q?D85dCqQK/jqyZwXzZuTNpyWOAtT8q+TCCtnV1qAaNN7gkHGOfTOPDPDIjoDh?=
 =?us-ascii?Q?H1xPyyIMHE18uJNq9mwFzZMJIXamKU2I8BpGbOOqKiRflKLdjPPESz9fZeu+?=
 =?us-ascii?Q?A1VqGieHbjRb+Kzlj16YCds+NW1nNx0KJQ8RWtMc0AkszUnp41fwVmRTkGsI?=
 =?us-ascii?Q?8LBM/iM/tW5fxkHAjOlXOi4pYl72h2I86szQ7i6P4OYSbkIHKSPK80qIPQ1l?=
 =?us-ascii?Q?dHITCldeavXLKIRzppscc0gdx7nz6Oghopn8WbLiXjrnsvo0p2rKOVpDsCKo?=
 =?us-ascii?Q?qb1OHcCmcpj4hMfsmFHccW5A84e/Xk3oSk3rtJs39DCo4Qso3GIhjps9zbRo?=
 =?us-ascii?Q?6XPI7k5QIP0YriFZaHbxmQs4NxK+WudoLwylZbgbeFgLceVE5j5g+3KhmfeA?=
 =?us-ascii?Q?DMNsBTbTKvwkpKkkPhCbr0iUhT3NHWyRggSGEPkWj+lqTzYMCdyU9Y3MhDmj?=
 =?us-ascii?Q?xd9RCrPAKvGZqabgwm5LJu6n?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f58472-4565-436b-64cc-08d9924b0459
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 15:21:54.4035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: feqqbwiJEMDPH14vM2c3wjdH/zRxuSOns7ByN6N8YU4C7LHOXCmfBAvlekVtMHbTtZfTOQYPTVfld2IkWOGLWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the DSA conversion from the ds->ports array into the dst->ports
list, the DSA API has encouraged driver writers, as well as the core
itself, to write inefficient code.

Currently, code that wants to filter by a specific type of port when
iterating, like {!unused, user, cpu, dsa}, uses the dsa_is_*_port helper.
Under the hood, this uses dsa_to_port which iterates again through
dst->ports. But the driver iterates through the port list already, so
the complexity is quadratic for the typical case of a single-switch
tree.

This patch introduces some iteration helpers where the iterator is
already a struct dsa_port *dp, so that the other variant of the
filtering functions, dsa_port_is_{unused,user,cpu_dsa}, can be used
directly on the iterator. This eliminates the second lookup.

These functions can be used both by the core and by drivers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 05ebdd8d5321..440b6aca22c7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -474,6 +474,34 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_USER;
 }
 
+#define dsa_tree_for_each_user_port(_dp, _dst) \
+	list_for_each_entry((_dp), &(_dst)->ports, list) \
+		if (dsa_port_is_user((_dp)))
+
+#define dsa_switch_for_each_port(_dp, _ds) \
+	list_for_each_entry((_dp), &(_ds)->dst->ports, list) \
+		if ((_dp)->ds == (_ds))
+
+#define dsa_switch_for_each_port_safe(_dp, _next, _ds) \
+	list_for_each_entry_safe((_dp), (_next), &(_ds)->dst->ports, list) \
+		if ((_dp)->ds == (_ds))
+
+#define dsa_switch_for_each_port_continue_reverse(_dp, _ds) \
+	list_for_each_entry_continue_reverse((_dp), &(_ds)->dst->ports, list) \
+		if ((_dp)->ds == (_ds))
+
+#define dsa_switch_for_each_available_port(_dp, _ds) \
+	dsa_switch_for_each_port((_dp), (_ds)) \
+		if (!dsa_port_is_unused((_dp)))
+
+#define dsa_switch_for_each_user_port(_dp, _ds) \
+	dsa_switch_for_each_port((_dp), (_ds)) \
+		if (dsa_port_is_user((_dp)))
+
+#define dsa_switch_for_each_cpu_port(_dp, _ds) \
+	dsa_switch_for_each_port((_dp), (_ds)) \
+		if (dsa_port_is_cpu((_dp)))
+
 static inline u32 dsa_user_ports(struct dsa_switch *ds)
 {
 	u32 mask = 0;
-- 
2.25.1

