Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059183E58F4
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240073AbhHJLUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:20:47 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:44879
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240053AbhHJLUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:20:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7tpPL22Ng4PC5/z9KNb1YCxLyi6Y8Y6UyvkBpe8Bx+0STYzGb3hqDpD6QpV9npEZZQ5Q7rfT6T31toIML5ZIy3q9b+MLmyb96tL+AUble8ILFOz8BxueVT4VjUGGp/a3VUtQNY+ZDA3fka1zswGizkAzgPg6q69QQPYayxzwEN6KTQ2ZNBwdLyinigo28T6LUlQ2juNoByzIepkNlDNj63cWx//bErX0YLheEx8tGofmHsSGyTa+M64OUtm2kAcEbw+uFoVnhcJGI7pQVW0vv87TVzDPZEEjD+E4+Pm3m6Lqgsg7YeiWeXarmYHToLpep/PdcR2yK6VCfysAa1P8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lT7Yw7hhMN81zeyHNJhagLmUm5mGgk2C+Vm7OKRrITc=;
 b=c6AZZLOoDKh3484Vl1I6Tgee9uv1BlSAYpsyXPQn0t8IA0IVf6Jn375Hjnu581xfK0Qs59yy1SR3paRA453m1srGm4bUu+P1jZH3Gxj0nBzlkqXusJteaE93RPNIzSUI//ybkP4s1yN2MR4nHTItTlF38Ufm0mFM25uezqK7VW9Lhd2gYSF7zkuLZW3rcSrEroEzE/QQG5mF5t2Nu4EVaX3rwk285ITsJ957Xdngaut6GVLNQ5etuP26KstWbyv7DbF6UWjO4eWVj1Yb4EJj6pSwZ4chjBzA3h1yXfLzDqpMfvOfTK+hEJGuczFu5n11oNzl60eG2Pp63CxsYHjrcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lT7Yw7hhMN81zeyHNJhagLmUm5mGgk2C+Vm7OKRrITc=;
 b=e+YWTtJhaL0tSpx+DkzybyjOzX34sQQxhrg8Lsvg3c7wfE/kjhLE688wgjIm816OjUxVS+uDdH8lH0Z0Z11YE4WOUu+xKkS4khpKC4GXaY6GhdqFrL2Iy/9DU6Dd9rNEclGtN1Xk+gDRSpXr51UzrpOyt+2b01t5QIQRNJN4UAc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 11:20:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 11:20:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>
Subject: [PATCH net 3/4] net: dsa: lantiq: fix broken backpressure in .port_fdb_dump
Date:   Tue, 10 Aug 2021 14:19:55 +0300
Message-Id: <20210810111956.1609499-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810111956.1609499-1-vladimir.oltean@nxp.com>
References: <20210810111956.1609499-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P195CA0007.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by PR3P195CA0007.EURP195.PROD.OUTLOOK.COM (2603:10a6:102:b6::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 11:20:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f8412b5-0944-4d20-dcd3-08d95bf0d1bb
X-MS-TrafficTypeDiagnostic: VI1PR04MB4686:
X-Microsoft-Antispam-PRVS: <VI1PR04MB46869B2446B02CD622B13582E0F79@VI1PR04MB4686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KngureqNTE/TxYHqKhIEH3OtW5R8WNgGyFbalk/MOVINf3En5+np7RfNSe0mvvpXnvstJJotiM8No+2Cp6mSTS9tlxuXXYWbV+KD35Yw6rsKRlBky0LTqP4shPL+vQEX2qpcUw4jjgVC3T+wWkpJm6LNgszWpy0sBDZV8tD/IPzo/cAIq+nq2Db6Fm+/Xq9mMYEQwTvDOaprI5bsn8TqiYRIATfZXJNXSoDp6KKj+LPpUvYp/mMX1TJbamKqE9e+iA3nPZFQ2r4HHD4vg8zKYGJRccAChch1RWHgtpCMDe201gaIiHvmUgeo046rsdgybrDQUB5NI/X0LC1Z9xLGy9smHRFGvx8srKbLKcWrP0w05mY/+08vRI9mF5QhPKF6R1KMm8qs1iC2Uf31QPK7fWqLnclO8DV3Ze7N3IuCxYTYHKUBvDrKQN2jPEMm4QmFGImz7NuC/3aXGDOYRd53osD84c4igMc3ooIHVFab4ED0MaSSC1xj6feDfnMdL2LyMxb+b4kd5p+6md8y2JwmIgsK0zku3GE/zC2jk1qC3qiqXSx6OBXZ/nqYHGb79PHGYPYHJ1MzvVeQizeSlyzEckCHWWiw40N7dGykeKk31RZ1EUKG6BmW8pIRa5yuvnm7APn+7KN483+PEpdUbt0JSLHaly9fDyJwKWJQz+r2sx0vXadqWl/u0v8VC4Eunx+komp2QXse6QMBCceeCgYhWTci4cZeNd6006+zNNvDIMs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(7416002)(86362001)(6486002)(6512007)(36756003)(956004)(44832011)(2616005)(8676002)(316002)(4326008)(6506007)(66476007)(52116002)(66556008)(66946007)(26005)(186003)(478600001)(38350700002)(38100700002)(2906002)(1076003)(8936002)(5660300002)(110136005)(54906003)(6666004)(83380400001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xEqu0bSa4XWTg2ILnpDTd/WyyhjzT58p8fly2O35E7nDd3zABonfqToz1T+U?=
 =?us-ascii?Q?jQ4cmRU6yra3uSh0W3sLspb3AyzL+BOkZZbkmSN0DEa9QGTTmHALR4mjiFi3?=
 =?us-ascii?Q?jl93oqADcWJfdv+Hksbl44MUgjtMXqTq+/RrUUYpjeaH7XTDQ8yKm1l6iRq9?=
 =?us-ascii?Q?ulbCJk/8WRaxkBjDUJ+1uLW2lUdDGUxxqeTE+mSjt5cBIA2OVHHch/X4neWP?=
 =?us-ascii?Q?ua2TPnKThc8lDxRzPYb/XzEBjUiDt66+rh3fAalmz3ogKFzgeaz1anh57DDq?=
 =?us-ascii?Q?9vt3w7Ml8QxCLVVfd3F8XuFH8tofvinL/2ydBDmXYP2jeQ2M599K73jlG62x?=
 =?us-ascii?Q?s1zIhH5wyMjHgZ3Z5+jQkpFyq4j3zhdv+OzXUHFvC01LWh2SLDp6rncPShUt?=
 =?us-ascii?Q?mB7NzmfmFcxbmjVyJquRWUqon/KUe4KoN6BOIuHoAAn7hAX3aJNAoBUhndY1?=
 =?us-ascii?Q?tLrTk8zoxY2KgYqCIGVh56WrXIbG9swpgGRl6U3HBGh2VnI+aFg6EVT+rjBr?=
 =?us-ascii?Q?vBhh5P9g8XMiWx27t9gKW1XppW6rzj2gk8gNdNPCL3JEnFD9hGojYzSKYwhF?=
 =?us-ascii?Q?KnFEfthfcYyVF+JRGSy0g7E7OhGSlLDV1BuWVjLFwgiIujPFc28FkzOUww2c?=
 =?us-ascii?Q?TTjA/xxovz+RyAiAXf5OAMhO+1AXJ+jLhRf4mET8re+sWHjvGJPCK65gCBqy?=
 =?us-ascii?Q?T/9UbWKbrHLvINLRvdZLmyuTG+3mG5CIRm48OqceeB8G+nor5dOHMETSurrh?=
 =?us-ascii?Q?iTSxGwfFAPwbIsU+wAjgwga2zHPNSujGHqqRRkxoC0/3hmLlBtZQWWa9t8j3?=
 =?us-ascii?Q?AcM6j+hV18805PoHug9o+8aJAJCY3w0bBDO1Di5d+IlARjPUHt/EZRYIISxg?=
 =?us-ascii?Q?nXc04nVfZezJvRPdvxncgxUO/iN/pxVaM6eabLftj/Hu7/j72STPOZr0PAXS?=
 =?us-ascii?Q?GkHNx1wNcrnk4NMIMZHVvqNm7PP43S0ZLqw+kImQCV9ZjxmRSVHs/4gFEC3E?=
 =?us-ascii?Q?6WVdgJpK0nih9gweKH9nGvY6Jc6GwKy7GjChgDUbcQJXk0ycNxa7PFSg3eK/?=
 =?us-ascii?Q?x0C+ucab/28v74f1XDDkt1u0ouHKeTiRFDPD7cr+ZiKQYzJvrJHX18PR82vg?=
 =?us-ascii?Q?6J/WplmyyOwd6VunJQVpWCAKmMWp0kb0EkA36d2gMNBHO1clKd9HYmYRD0bz?=
 =?us-ascii?Q?djuH88ovBI0UkkVEcKmQsO5O7k3Au99MvdydkAF+gOx1Px0loPp2RVudKF57?=
 =?us-ascii?Q?/3rei8a72eQ1jIkNFFuuQiVwtsaclUqWp76fPSCe9PN6QgB2Xw8+/SEThLEA?=
 =?us-ascii?Q?4wgO5+mrJ0b1kLmRSW1n41MJ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f8412b5-0944-4d20-dcd3-08d95bf0d1bb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:20:11.9913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NlzLV30EbpemotdsqNPlFrcMKvd9MKQcQqGD+rnd+VtDbqLrO6LyJ3QAljMGiv/4AHn1fy1rx5IHj5zhZyT5+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtnl_fdb_dump() has logic to split a dump of PF_BRIDGE neighbors into
multiple netlink skbs if the buffer provided by user space is too small
(one buffer will typically handle a few hundred FDB entries).

When the current buffer becomes full, nlmsg_put() in
dsa_slave_port_fdb_do_dump() returns -EMSGSIZE and DSA saves the index
of the last dumped FDB entry, returns to rtnl_fdb_dump() up to that
point, and then the dump resumes on the same port with a new skb, and
FDB entries up to the saved index are simply skipped.

Since dsa_slave_port_fdb_do_dump() is pointed to by the "cb" passed to
drivers, then drivers must check for the -EMSGSIZE error code returned
by it. Otherwise, when a netlink skb becomes full, DSA will no longer
save newly dumped FDB entries to it, but the driver will continue
dumping. So FDB entries will be missing from the dump.

Fix the broken backpressure by propagating the "cb" return code and
allow rtnl_fdb_dump() to restart the FDB dump with a new skb.

Fixes: 58c59ef9e930 ("net: dsa: lantiq: Add Forwarding Database access")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/lantiq_gswip.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 314ae78bbdd6..e78026ef6d8c 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1404,11 +1404,17 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
 		addr[1] = mac_bridge.key[2] & 0xff;
 		addr[0] = (mac_bridge.key[2] >> 8) & 0xff;
 		if (mac_bridge.val[1] & GSWIP_TABLE_MAC_BRIDGE_STATIC) {
-			if (mac_bridge.val[0] & BIT(port))
-				cb(addr, 0, true, data);
+			if (mac_bridge.val[0] & BIT(port)) {
+				err = cb(addr, 0, true, data);
+				if (err)
+					return err;
+			}
 		} else {
-			if (((mac_bridge.val[0] & GENMASK(7, 4)) >> 4) == port)
-				cb(addr, 0, false, data);
+			if (((mac_bridge.val[0] & GENMASK(7, 4)) >> 4) == port) {
+				err = cb(addr, 0, false, data);
+				if (err)
+					return err;
+			}
 		}
 	}
 	return 0;
-- 
2.25.1

