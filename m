Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C284351FB
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhJTRwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:52:31 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:48103
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230179AbhJTRwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:52:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIB6dgo9rcuWMGDC80aEicSksETHqXUK2mDE6P0cPegU70nAtTCkMQFkujdVWjLUKn/gklxDIXIv24B8Ks2JfmdX1Ol2hdQMtxwvA2i72yXqN2jz7keyEdp4ibhLoiSLnDLkBYTYBzHLe3IOhjcmqlr1bRvUa+zRWRIMRP/sK57mx84fn1qpIyPUETUjfAdmgo7h515uvz5bOUkAv/A610psP7DQFhZ8ZQ8vyFlLFv6Y1BQgS71RrQ7ejV32nA9QQnIDP+PBRRlzqNnvYbfCxiERguqd0SgSA6KTtgQPdH7jr380vM7cKIisOTiLXvnMcZIAOfs+PoWkV5Y2rYQuUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g62jgQ8NGg9gXhiPHbfhHQYjLRmTvQATxq2kGvOaffk=;
 b=IQx0GwAKVe8mS9iG3ferdwYcCIkpwkKA+Owa50I6tQz/SbB43eZinm02qWgAh5/1bYgxjYkfNgO0WdzGM2lWgi2I2ihCZQVP6TEqy9HkdvNEHOUMiugALGZggNwAY5U6Aj+30PhXGp7tuPf2UzMQavOaElZ/5IuTxneVNHeGfIDBWpsbbb7MNZydsCWwD2Tm2MzN8uxucU2cyegJoKWLFpuCVK1wjZBiZs4YkqomPSUWSa5QmTQIA00UaTHe4utA3yJgIiujCEEcW+gummuJJXxHrq8IG9taiMmRoqN5RPJxJrMWZvSs8MFTUyAbeDSx3UeygpOYflXnbkGtF8kMZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g62jgQ8NGg9gXhiPHbfhHQYjLRmTvQATxq2kGvOaffk=;
 b=sqMj+UIHy0EVf2kbgxLFJaA7x0801v+EuNP6FhxKVh9F0+N2/H1Ga3L4OaCU5htX9X5ao7duom79hH68NziWMdLL2eusT12S01xbVJwEWaARcvhGFGD3Ouzaeav78sNTS1LpNUZjfJOQ5vNX/elTt9VqcBG4ZKTGlUd45xcvt9E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 17:50:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:50:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RESEND v3 net-next 1/7] net: dsa: introduce helpers for iterating through ports using dp
Date:   Wed, 20 Oct 2021 20:49:49 +0300
Message-Id: <20211020174955.1102089-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
References: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0034.eurprd03.prod.outlook.com
 (2603:10a6:208:14::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0034.eurprd03.prod.outlook.com (2603:10a6:208:14::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:50:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5a85296-505a-40cc-9f34-08d993f21147
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2861DDFBA9FD8C304C6D288AE0BE9@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dpGIAuookINv5fQhKyuOpU2EhT0tdqnSiiCXgJ4znKwp9sLNY9Ie2/t4FSnQ2Lxb5B51TWobYhwQBk5AnmmZRfB4ZzfHDUFKxGzTi4+u/O7iLJWA7ywfjpyPK3k5AfN5RcOC6IDzVfOTkubbO7tuz5RUUSXuo4YI7CUXkuT3SAbil63JPAJJ0df3Ky4GqsabBkzipnucGROiR3XOxvOhu/CMfnx9A2d9PeH+SezzE1umocJ914mRm3lhpRLyG9SsEhy2UgtEH3xb5b/KwSPUb4Bl+28pghyqLjRiUNd25ADpUHXnlNYmuVK9E1i11ojykLvIA3WLV3tiJ4c5L6tEPNnDBXtyfTF3rnPOkdbeiTXFbkBGlwXfwwTuTWHe0SXEWNn7wr7rPcRlIz3kl4X0posM89Yu2/UpGltGDXowUdoDHFBVaPXUAauyaHKOo237RcU0qhl0VFJXmR0Y0xUAGwLOFv0ywzEgCpqY4cqZk+bzOCaHqozy9I25Hp6v9OvdNTb9vxdoj97rEuS5/eR2oG/x6aA494THFoSDUMYFvzLXBoKPpg4f6pmcWcTUJ1bDdbU4pBwk/HpNb3vZ7crZz3kXBRXbZHQXzdwlc3f2Si3/F1E1wts+rd6txcPfHHdAFYnyRmArodizgo3sx0iGrCMfAXkGbl1ETvXOoybPq4VCPQBOFb8Os7BBnbmCYONK5Gt7TxmKWBqNdb5qchVpjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6506007)(8936002)(316002)(110136005)(54906003)(2906002)(6666004)(5660300002)(38350700002)(38100700002)(86362001)(1076003)(6486002)(956004)(44832011)(2616005)(66476007)(6512007)(36756003)(66556008)(66946007)(8676002)(508600001)(52116002)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pC7Jw4VKoEh47VG8xQvJ7Bdx1x+YSE+ug+ZKuzWEWKEp+D0WcJW9JOrZcBVm?=
 =?us-ascii?Q?xiR2NhhFGEtIaG9+4gXj65GQy/m9eemiZX3kYAfEJKXEKei3PlvZEz3DPsNa?=
 =?us-ascii?Q?q4Q57IHbO/BUHE9BhmkQ5MhtmFLvFGmTH4nJDWl2iXTQonQjfnLR3p8Yr2s7?=
 =?us-ascii?Q?FKT5s0d+ZPYuiWqDenHdH8X5okGwrv+DAGZHrHink6FPQauVN+pSVVtICZ+B?=
 =?us-ascii?Q?d05NQalc+tncSCoN87OwlJ+gegcHrkTfFSJMjwbIMusNdGyVv3rU133UoXhW?=
 =?us-ascii?Q?GrlJRdNVYfdOwC8+l/4FpmzBhBTolCgpsS5pDOGNfW0VXD//Ihi+ywBf9Coh?=
 =?us-ascii?Q?i2DoPdhSqXKXjYOeo1LhmEs3cyr27zK6JJpMf5zORA7ugk/wtLewRvygMT2A?=
 =?us-ascii?Q?xc9RbuRri/C9dFhKpertR5wRSk7XF3tjaRx9d87tq4S+A+EjJWVOV7zc17Nl?=
 =?us-ascii?Q?NOzx3U0eghzzzO3pYGLLPPDFSbCM1mz3lKW5g+KrEJCETx1caKVG4QV1u5hh?=
 =?us-ascii?Q?Cw4bH58t7O9dyTyCrc0n0Xwh/7TBeuCyRYnqX8dMykRtDa0oCWD2Rid8zT3s?=
 =?us-ascii?Q?1xjyrosir29IX92RlQc+1sosYaJxXFlNtxOzk+leV6JPGDvhENawvCNkUdAL?=
 =?us-ascii?Q?b3tKfU7yw6PFVfH7SgO51HkOWOwDjG2IOg0A8dp3Mn6aKGVMr5Q6Xk7nJdZU?=
 =?us-ascii?Q?xHPze/3OfeK9q4ITc+t9NJMG9UG0WLm6ODnmS+46tSHtXVu4cI0f+xqdtvzH?=
 =?us-ascii?Q?R6RjOEvtWRiqRi4pYZ/aMqmORfHrYPko2BzsYixS8iK44rbvHNvIoyUyyfiG?=
 =?us-ascii?Q?ZLxX/BAXQTXXEiC8iVFwiLPH5w/JTIo7TcouIATKcApn43LsNTidMKxwao/u?=
 =?us-ascii?Q?e+ySAEfUSqRz875mLDXd2ASDtW14QL1kpzK6TjjvPoLsU22UdTaRRumaZnT5?=
 =?us-ascii?Q?h5iZZs9NFZTdmyf5qHV0uIoVXwbMa33/gyJ37Dyowog5gaDigcn4A5dwMqn4?=
 =?us-ascii?Q?5l8hosdklyH8uWqiwYJIycnx7SrQyllfwIZ2T844Kak2813+Yw2xAgXPapfN?=
 =?us-ascii?Q?RtrvwIAIhIB9rHKqYu3hpLKKSZl6wkIHzzSxc91Mz0iJNJVQ4hvL4F/Rdhqz?=
 =?us-ascii?Q?V+KopR5vFCHpe6kCJWytR86OasiI9dUOjfiH1w3Vn0JTK/xWSpxAjb1FSpKy?=
 =?us-ascii?Q?B1mbQ3DLwGxGJFIkNxnAs5upYHbilrxDLMBKv/tjSudPamvPpGOEC35AxCSE?=
 =?us-ascii?Q?vaMpryAsQpQMGKbm43WKCNIZT4h2b4TyjKYTx4h0fjDfMAjFQvDh+d295/fn?=
 =?us-ascii?Q?iWaTq3nhAxgi2H32ISKgXJOf?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a85296-505a-40cc-9f34-08d993f21147
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:50:13.2510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kv4dxlOSngN7ZVo0AuW7571TpqCdvycMBsStd7ThsWxO45VLuzgHaCCqBhbWTggWsNgK4Ff0jiV9kT9EUO1KnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
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

