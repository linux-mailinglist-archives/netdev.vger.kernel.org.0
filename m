Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043863E58F1
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240068AbhHJLUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:20:36 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:44879
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240053AbhHJLUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:20:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9EKKMvKO77SxZdgk4iHHWzBDLhy4DXPmwERUE+8RQdQ78mbr+ODVyUSfH6vF2TkOOEawOu3oXurBkhM5pyYIcNPqzD11NcIG7/NGaX9Lst00usBB+6JmAqFDVIDrcgsVsphLpy1q0lQMxBVgq0U0oPkRdbBFJ3jWxD12fEEcgEILccgnwmIEM2hLAOVkH8sVH7apQpD6JS727Uc5fkuz+spvLNrK0YvQQtJNxnWkCpfRxDPhhG8YXfqrIlOWaRAqE4ojAOmI+CQ2ycraxMjC7KzhAdJ0xe0lFFqx3upJafRFBAVUxU9TJBsECUghOcdt0r/rGDKBUrDtXrv+kphQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xozynu+D2mDU37kAO0NgF3bD5/BRinI/yT64NY2kb+c=;
 b=Uw81D/sqhikT6USNtn1YayFZT3P3LtTwoc0FJsPy1Vf44NYEFM1804obHR9mom41iDieujJ7x3L+L4u1nDP3f78m+KW1RmPZC2j8tdDWY+Hu1FYInExAo1U9um90fjRoXcL3GCgQuOjgpuCLR5s/CJosP/GRsdGu6DktYYycZ69zMgl1iA4d8h8Loz95rah02sKGf64Cm7k5yVpoTQqHxM5AW20ZDDiglL+Zel5raq6u5AVV2V0P98/1bZnhGJ75f9EvFBkuP9hDcpJArqJKG+MFmiWZ6yw5gqSttc2KBbBFj4CAwjFGI2nOwWeXJmSeeFRYytKeZ7iRbJCeBIilpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xozynu+D2mDU37kAO0NgF3bD5/BRinI/yT64NY2kb+c=;
 b=ION9eGCqocInhR0B8p9FBUdTT3d5aUrQg2rhHXr7+8ysCZVUZjLn27oxs0Y+Odi006URGQb2HBuaPyfg23F5SQoGzWrFs3WPLQlOmQKcpUNyTa0LD0bqVWwJsFCy0esXS3Ca70H6omVwZbrHTB29tqfMegEso+vRBML3DyOVzZo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 11:20:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 11:20:10 +0000
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
Subject: [PATCH net 1/4] net: dsa: hellcreek: fix broken backpressure in .port_fdb_dump
Date:   Tue, 10 Aug 2021 14:19:53 +0300
Message-Id: <20210810111956.1609499-2-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by PR3P195CA0007.EURP195.PROD.OUTLOOK.COM (2603:10a6:102:b6::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 11:20:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a4ce1f2-97f3-42c4-4122-08d95bf0d081
X-MS-TrafficTypeDiagnostic: VI1PR04MB4686:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4686086816460CBF53CB662EE0F79@VI1PR04MB4686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2NEUgdArmYUEHaeV6d5zeWnXkAeCeRH6JkKlaZMlyMYDETLQykp7n0dMseJkHqHvPx0j9Ur9OLVf0qXkuPBRCQ+sk2wGtKWI4sPZIL4h6+HUZkodVzH7WWkiApOPNigqyuV7035mMEt2L+VQYmCaSetfTECyL4qHDnioBGkjKpePnBcde7jaompoCghDX4U7lbN6VLJa3uNvO1Lc006vABqR1C689zHa5sdAsFS0xarDZdxcHhe4OxozuSVb2VQbn30aPei2w12rQ0LjMG/o03KPWbvtc2/qnIyKaX4koTC+OBRxek77LeRECTy1V4P1wHP/Lx2lT98DfgQYIA7immba4Ig6yKSYUIi/lJQ49vc/GJgp8hO9e7vNeTLAsP/eTxnW89RQBMkKjdeQPX0SMVjLcWFxVqyxVO9zinZmVdUSOZjfiGAA00QeEEYMw4lrMN7LNWsJr7js/M3FeBLkIRO8W6a0Ju4sjYzXl4xQplv2EKfUBoPGb55q9tke+v1QS0nJlHVyI28edApCfJhANLbQpkXuGow5ub3+m9GgENRpDZ8uhHaTcWxdeHl2SSryEnhp+THVGDP4WQsKgwDpq9Jo4m2tCF/Y/frnpGz9GO/ZBYVDwigNEUIx8bdamYfXbdMT1ae0UjHjQAu+LmPC1N9eXpVxLD736pqoGV1cLg3vbZfTooLuW+/xev9ZhhM0lXq9UQctbiwmx9ENzkwHXHs7572I1UqPqvAl0gYRSZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(7416002)(86362001)(6486002)(6512007)(36756003)(956004)(44832011)(2616005)(8676002)(316002)(4326008)(6506007)(66476007)(52116002)(66556008)(66946007)(26005)(186003)(478600001)(38350700002)(38100700002)(2906002)(1076003)(8936002)(5660300002)(110136005)(54906003)(6666004)(83380400001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4vWT74iwzzbOqjwPdzsqr3WbdZwCcV0zo26A/Z3ECie5zzWFErB0weEOs2t6?=
 =?us-ascii?Q?xACHaXOcTcqPUYO2KdLXm4LLIBuNiTFBgSGDWgUWMPTBH2l/Q4kO1iyjtU9T?=
 =?us-ascii?Q?5oiN9j/1ZrU7igP/xlUO2e/PIPo8szW8ZbVNPVkD4L8jI+qXhpbQHgCnxAnd?=
 =?us-ascii?Q?uK9OVDMc8j6oRTuHsVOH+evF9MYRBgF7CKDRgclRGBF/5p/VdGbXOpggp3P+?=
 =?us-ascii?Q?V0pTCZL3kFivy887BJpXS6h6JdvXaTR1MTZQpndBZmldSGWDCUPG/VaRQ0dj?=
 =?us-ascii?Q?6FDasHiq0i3vguQid+OIXH5M0vOR9LbuIY8m/Ffifm8EsCRP39IBKt8zgrRD?=
 =?us-ascii?Q?4oVQe248McyPcgEDnOlr9z4bZz+BI+K/+GHVYlUMR+qffw1mSeUbi1fdW+fK?=
 =?us-ascii?Q?Dop82azCl9T5pyRfuGQgO831ueaHWlqVyiDgvbu1nTL+uY97MqKJYCj3Fo0q?=
 =?us-ascii?Q?U6akvneLuWJTAe4YnW+B0vAwL6VhBSkgFFNauk+SCYingS8eMm2E2tscPgkP?=
 =?us-ascii?Q?xnyHLQ1RMQYbY3S0nm6v0h2MtxX3lHgg9ArH89KJGrjUUZxwsOcMA6jZNn94?=
 =?us-ascii?Q?XjZqe7XfLgEZMRVP//fTZiO+7pJilXPVU2YfslokUfnFky6B2cxevU7CDSg1?=
 =?us-ascii?Q?2Tt9jOus4wamaXmbnXE8nOKShO91KXwMXzvUQAXTah3DFFp7tf1ag30Pvfbx?=
 =?us-ascii?Q?MfsuA+ynahsfSahkzMo11GD6J+wdDj5ffr4kDEk92JNIY9bGAeVy/CNF+hda?=
 =?us-ascii?Q?URQm+mBYUE2HubWWVbkhU9de9Gb31ilSkU+VkaD+S4BtN5OwVeN6PPW2kPgd?=
 =?us-ascii?Q?wO08tvx+nCjHfwdle1vBG61oa8AT8pY4y4sLMwReW8f1UtAMQoGYOzBpsoDh?=
 =?us-ascii?Q?Tq6Q/OEAHRzJdIA6SC1lJ8sLdSwefM9WKs9V9eyCCK3pPq34BDXLFDRvj5EN?=
 =?us-ascii?Q?4m2vN+YmJFQi24nmia75bX172QVvEB/rnv6c/zEcL/eAxZ3o1Z3W9X7Etf3V?=
 =?us-ascii?Q?3VUtGmakrZnt2DdHWdX8Q/3+beVEifqEF8sCDxAtwhoooiLEXvizcBCtnDNH?=
 =?us-ascii?Q?nu4hGbOpv87M5tWxTwhp8FleX6Ng5NTaa11gJvwtBQZ440rZRA3ZPwOMdw6Z?=
 =?us-ascii?Q?f2g7X06ZIrGn7xKHcDqAQD3d4Y27tbFLlvhnd4draWL4Ujj94lIbCvXbqfhO?=
 =?us-ascii?Q?No06n6o+LMIEyfHDK/Y/jkgMBknGF8GXY4gqQkMnwM8BXNdzYQ56ngEyHviO?=
 =?us-ascii?Q?8IiWLWmVJckqhWOzblR6WxGXAerw/KLps2Xu8lAlcbfJDT+RdUpSwPFnzeAI?=
 =?us-ascii?Q?ZKBaP4De3qIRvjGb0F6X7eTz?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a4ce1f2-97f3-42c4-4122-08d95bf0d081
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:20:09.9345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXplRmD7NXzQIe0eAqpa4mhNtS6nct2bPOEcRhcDIeAdHJu6r5iVe6d4bIPNDiUxh7JPjAQ+nYe4w5g9OFqnxA==
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

Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 9fdcc4bde480..5c54ae1be62c 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -912,6 +912,7 @@ static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
 {
 	struct hellcreek *hellcreek = ds->priv;
 	u16 entries;
+	int ret = 0;
 	size_t i;
 
 	mutex_lock(&hellcreek->reg_lock);
@@ -943,12 +944,14 @@ static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
 		if (!(entry.portmask & BIT(port)))
 			continue;
 
-		cb(entry.mac, 0, entry.is_static, data);
+		ret = cb(entry.mac, 0, entry.is_static, data);
+		if (ret)
+			break;
 	}
 
 	mutex_unlock(&hellcreek->reg_lock);
 
-	return 0;
+	return ret;
 }
 
 static int hellcreek_vlan_filtering(struct dsa_switch *ds, int port,
-- 
2.25.1

