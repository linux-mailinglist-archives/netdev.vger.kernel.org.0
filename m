Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE89643AF0C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhJZJ3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:29:12 -0400
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:34234
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235082AbhJZJ2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:28:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHfifrh0kKbRYdSVsnG+36wG6jfCaNcSFMePnyV7HV0GbVL1oHzggs6cA1ahSJdw9766puCk9R8TtfmZR7b4WaqO7wjSC5wF3M9x4x0hUd76yES5ltp4amasiNXJGDYnRu49g2jMvwjvem8ihNlTn60Nk98Ovtq0ZRsq2XQbKmyUoBVdupZKOWAxQSKjLK1MObmHqdGQEh52yryEX67qOjivxpEIwMza1xuFxasgsLxMXLnccihTp6YbP9UGjwJz2cb0c5kYqwlPwV/Gk1RXnBl5EWRflPRbY5kEWtTUMj3d7Qb/6UbvtXR5L5OzZLg30C3LtM8w0FzC+kknp5LQ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8e13X8fboat1hrhjiCMAzrhx+PR3HChaeb5ulYolMaU=;
 b=TrrDXhWX17qra+e9kXohZ/c2m/LXM0xWkvokayeL9D/Hh6mJcQeldQfkUHwpsqroe3g/UyF4ZwtIXkhGgS7UH2fviYnY7alnFfyGTGMLtYdiFCJ/Xgwm8nJXT2Murz9ZpCZC693VIxw5EbM8f6MsCn+Du7/aUe/s+DsosWdV4wXDWlfahr83BTNj4SoOf+uH6UvFV7F+D9m798ROdiqLfxK9WuOghiB7qS5RlQZfMy3BrizVpQyU+lwyYBtvPJ5o478VHKtW4JLHrgGEhSgQR+hiUX+HJGW3Gs4V1UfUyNzSu4JBH9qXrADdYW3o1sfbneqrnN8H/MDJ2w8exRJIyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8e13X8fboat1hrhjiCMAzrhx+PR3HChaeb5ulYolMaU=;
 b=Xw1XHe7DYTC/gd4Zv8lrlzZRPe7CHFePXkOQr8cRkyMUA0adS89l4v/BDtVUJa7LXfG2ho2dhhVUIIuTtRNhmWDoMVnsKmTbGrfUn2FWEjlHDalp3UsY/dddEgr7E9NHrfEAYCXx+19+LQLv2n51PvY75Fz+G3HYejlRvxoL46A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4221.eurprd04.prod.outlook.com (2603:10a6:803:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 09:26:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 09:26:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: stop calling dev_hold in dsa_slave_fdb_event
Date:   Tue, 26 Oct 2021 12:25:56 +0300
Message-Id: <20211026092556.1192120-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026092556.1192120-1-vladimir.oltean@nxp.com>
References: <20211026092556.1192120-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0024.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM8P251CA0024.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:26:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a915a12-608b-4a54-4ecb-08d99862a853
X-MS-TrafficTypeDiagnostic: VI1PR04MB4221:
X-Microsoft-Antispam-PRVS: <VI1PR04MB42214B2C12C3CDB3F622BF0EE0849@VI1PR04MB4221.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJfvD5DIo/F8vAHIZWNG4lTmpcECIBunBBmVHhpUJ5txaHnh1mpVC5WzGxOobG6aaT2zj9CXFga5w0o42Lonx4Rfo3vMsAgqJQ+I1Ef0A+h1jjJ8FkKgqNXeu+pYpz2sIp38nEmFO1ck8mzmFFU3lkU48OVVKrECilgF6edd9lHQ3sgp2lxyD4wlXCG9UkSo/dnvvpruLGTJAjoSXBWx/mVmkxtjXYrM1KPd7Zp4STz82AZHOrCgmALoTKrSjFbAL0KBl8tEmqN0NbRaOEYtai7bSfUOOoVm4PcfQosFEa7Dt1n/ZJEIsZyz2MTLziHbV8hx4fp24jLz5PC02u9Urrz9tDiQdVo6BKPlLZQYNoO/2Aljkl6xnCP4/7SXS+CuepCP5q0D5a/rq1ymEr6EGkDfPh7mNrzY+MGKoyvd+A9m23tmJL+92xswOqpxlwqQwL5cbnEQqSodIZFHIVEB4K4mKDu5YiUv8m151mUNF7Nkm49lsJ1qW+yhIDB93LKK7vTA7AAxHyJs9ThxcCk6SDOpgcUEQMDEoXWOCBhvA66NeMgoadU0pnAX6R5TvIJdeO4y+CJG28M1/IWBxc9WBa5DR+i07Ftq3bl7KH+Jt7lHN0rX+QMcuiO0530/dLqkCxamW54U6kn+8at4sxKQYnxUpC/mGrCwNZJYl5X8TNLysHI06+P+z80OtM/QzCu9JEOJ7dgiLYhzxhLZXhqPN2DzAmH/S+hEHSN8X/iZF2A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(956004)(83380400001)(508600001)(5660300002)(186003)(44832011)(38350700002)(8676002)(8936002)(6486002)(26005)(36756003)(1076003)(6506007)(6666004)(66556008)(66476007)(38100700002)(110136005)(52116002)(66946007)(316002)(86362001)(54906003)(6512007)(4326008)(2906002)(60764002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UNRLAGbDniCSlpCYbcRvyqLA4FIIDB7AOzZQqdN++x5JcoAVDhX2iNmNYXKi?=
 =?us-ascii?Q?jhvjr9B2y3t2qixFxTfJVyW8b5Iyrfk21DyfbLRy2F1aejeoT2kE+2wSNrGS?=
 =?us-ascii?Q?9uicLD0GjJiCnsY4bpXWOh7824nDPc09efi8j1WSxbMVAIhrk9A7YPGbd0Cv?=
 =?us-ascii?Q?lcufeDpYw0Atta6hQDtzYXeAdGKZf655rgRJVfKHHb/eJjEIVu258JfWvCQh?=
 =?us-ascii?Q?rNzbUNjZr45/DzlJ9C9y+cSb+G6flLqMsQ+FWERnTKgJxSIABb3hzQuQPFGb?=
 =?us-ascii?Q?dbAhFw4OtPscYjIxkYy1UHDuaDZvbKuRbJB6lJ7Z2bdSGYIFXIh/6qY919Sy?=
 =?us-ascii?Q?Q2VC26IjHGrvur80C7lWigWgtlsQ82GtTE567/ZtrANRn6DTpN3qEdELvOsk?=
 =?us-ascii?Q?KH7cPXB24+GMNVxBgNgdPg+SuIgKEJODbE3GRY8UR3AJ2vG8542mjbrtEC5K?=
 =?us-ascii?Q?4BWOVYe9HQawKLvBlQ9du0t5stCw76yUT/R30FVr+84rpbvAHIfe4F8yvci+?=
 =?us-ascii?Q?IulBNnJr7X/vwFTqGsVRzIpUzC/HY67jgjIJhUY1xvEesOEjUQE92oF1W1aR?=
 =?us-ascii?Q?BTwmC4/WNCOpnD88y0vhOjZm/4q6M+jhzLCDHM7oCqUfIc37bSQ2YxZ3spar?=
 =?us-ascii?Q?/0xtKukx4/Du1uw7SHUpGoUOjfWcvAwQku5AXtwEvpQ07kn2VS1rgr41FAEU?=
 =?us-ascii?Q?/fU2VqCV6+a25PLG2Cw74lXaBVD8Q4mYE+S7OywsGjyyZlcPQ2/xKmFKBd6i?=
 =?us-ascii?Q?12XvAevRbksiq41BEm/JEWUClgCHx39plIAEGxaVocXCP9dTMV8boq2mtBku?=
 =?us-ascii?Q?/VKRO7ZLL9x1yrRq4JExBPbkd1QtoU/7Nb+IQVDepoq4w2AKmF6AcBzu19QP?=
 =?us-ascii?Q?amclR8JoW82nGkZONvfVG97z5HmkjYjy6OOtzaHfho2KaDznKaHW+9XwqC3Q?=
 =?us-ascii?Q?QtIm5b7Ap8QnL9DHTEgfM4t+XiOOn5rq1NgGOoNIGweHe6hlrQ27sOq80gh8?=
 =?us-ascii?Q?9053yESzGW4Ch38/xqK0abT2Zg71cbw7/kXfi/7KK8vCg8W//J0kNtdtwBOz?=
 =?us-ascii?Q?BFSQ0XzV41WPW8H9QNdH4RcL0Z3FxjCIQOEs4uFQsJyqxJM5pFWytPyO6BNo?=
 =?us-ascii?Q?oNtvE/vT488Z3+BUj75QPwV6S/Xc3XZzHVaUUtUsZ7qJXrTYBPdQsUALN/yD?=
 =?us-ascii?Q?ZJB1DjQTYbPXuv/Jdo89IWfmnRrSxYc184Jz4+TSPYNJI52jZai1wXy/r5Og?=
 =?us-ascii?Q?99UlqltNQTjZdBjGl6UDZwhohryB1fiP0bdxic41vMqN6J/y13Zqho1kxAZu?=
 =?us-ascii?Q?2qX2M7E5+cdvIBapEYCgMCu2+aG7P2cUF7UeaR55rheoQ3xMbZOvMyFoW2IR?=
 =?us-ascii?Q?jWGf+I0Bi2sWGf3WxXYtxjbztEfxoPnttFwjoUH5HOk3vyGMtdayUN6w3CfK?=
 =?us-ascii?Q?yAUO3FFJRf0LpEuHj/kH/b9yrMk3/u9M5wM+7ndcLR/UDx9HpEerYp5GPFEc?=
 =?us-ascii?Q?UtVj7dcCT0LaKYpePhSpS6P3jvEf41K4FUfalAGuDrtYHddjQFKs2sBVQfN1?=
 =?us-ascii?Q?jVqInecmGRroEVfLJyGXS7oO3SLS1m9fvgaklxCehUHXy59pWxbKlT9iQFq/?=
 =?us-ascii?Q?EAGiicqLNQfoLCQQbXPEIj0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a915a12-608b-4a54-4ecb-08d99862a853
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:26:14.9453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CM74NEjE1oZZyM9B4Wepvs6xQ+SLCMgFsqqMOep7saM3EIaFwxznC8ECbANsw8PSpsRVMU9AnQvN6C7ZST6m3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we guarantee that SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events have
finished executing by the time we leave our bridge upper interface,
we've established a stronger boundary condition for how long the
dsa_slave_switchdev_event_work() might run.

As such, it is no longer possible for DSA slave interfaces to become
unregistered, since they are still bridge ports.

So delete the unnecessary dev_hold() and dev_put().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index adcfb2cb4e61..dbda0e0fbffa 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2448,7 +2448,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		break;
 	}
 
-	dev_put(switchdev_work->dev);
 	kfree(switchdev_work);
 }
 
@@ -2521,8 +2520,6 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	switchdev_work->vid = fdb_info->vid;
 	switchdev_work->host_addr = host_addr;
 
-	/* Hold a reference for dsa_fdb_offload_notify */
-	dev_hold(dev);
 	dsa_schedule_work(&switchdev_work->work);
 
 	return 0;
-- 
2.25.1

