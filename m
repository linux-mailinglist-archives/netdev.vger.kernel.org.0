Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F02D3E58F5
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbhHJLUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:20:49 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:44879
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240097AbhHJLUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:20:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLjDm8LhuJ3jfWKtJqhJsLsHeNkjK1Hh4vC0KSp7280411gLzo0TJNZtjfMYRxxIQTBWWkxwA1H2M5BBOEYbmwuVVYogUWFjge14nGnfZ7YD9BGrYHw6X/C/11zwahWo77r0ROADcTw/5Yd17UsooBH0muOishZX1AfCk+1dNugm5xi9odJZwqOHCmvxAEv3dTmIABZiMGo6gXB/YpSzkrUa5HrvAY5LTyP72S1+Y+58x+Ryb82vZu3w0onWXAiV6YpVF5Mc74nuYoyklTEi20fSr0bobjQull/suStMgfoxu1rwcyH8Oan9mUNGq8EHpNtMsSPKMC7Z84nGujbnRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ku5GB2HPlyMDsnuwPhKSkeG6uXqiSsortsDuCb4OvnA=;
 b=aiORAersRSgo1PwqoHH4TKLhmFTG1Tv0cdXYqqWx9zR33ZwQnwbXFNN0y4abbNN9jdBtja4iCjrRzsB3tArqIPK3Q0wcSfsvmyc8J5TYLJSAV9u6QqUeD49E412+IMi4Oy83SVAdExXjlNTe2cubMVLoErfkKpSJs+EyyDz9Q65gSWHQusk35y3disCv5kzVHpV+WuUhedLIgQOt3xJUpThmolv2nl75ec71S+BincIAH5e7ymTPjnGY0Y9PQTGbzfawQIPuGH0SUYYcyzgHv3nTB8XWncD7YQ5/U8kOA+kIG8FHoGc/z08Ixp0gjG5bYZLhdoh5XOcHETBh3+NGSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ku5GB2HPlyMDsnuwPhKSkeG6uXqiSsortsDuCb4OvnA=;
 b=m+O3J4JuG62wMbBBI/dSrEWfiw4+24XIlf2L6JAfW6XenGLH9oHPKunkO/foDu6q7Gu/uv0oYIAySmWy6AOUqd7ZcW2MYRBkVWp/W0JF4lOdDNBgWMcaumEtX6oN5netp5GaB+9XggLfZujrjMk6ns97RLFBWLrqVHFxv+1OmQQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 11:20:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 11:20:13 +0000
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
Subject: [PATCH net 4/4] net: dsa: sja1105: fix broken backpressure in .port_fdb_dump
Date:   Tue, 10 Aug 2021 14:19:56 +0300
Message-Id: <20210810111956.1609499-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by PR3P195CA0007.EURP195.PROD.OUTLOOK.COM (2603:10a6:102:b6::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 11:20:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a4c1655-1691-4cd5-352e-08d95bf0d25d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4686:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4686BBABF717D635F768586DE0F79@VI1PR04MB4686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTlU4e6PlLMxQQqytFN6pGgdu/r2YwsE/656Avm1H4QleS85oKVNXuFvpOtiET09IBQXnVt/gVQ+F8ntf/9g0RV/b+AWxqyneVRS3KZmjqhTUs5fQh0p0ml0tE5ujrtwSY8McUCEI1XVC5DF/0GUazW/fUTJASQ4CpGw9N09o9grmi4t9oMJ0nwFr8CeFPztCVHekPcAVo14YjbgnEKetx6bjQmfPEJ00HLcagbYVsc+Lgbofjxh+E+Ht4JsRAaKtfQ6HAiPbaJLJFixjWqGhiOnU89vF5MQLjh40bOP7pRByQ//u3H0iNttVtxM7JR0Vx+GBVNWF6QHehUHP/CoL+b1mjgD4EXfQdbdrnu5VgXaI/JiWP5pMfu8/nYN/UskrT5AzjqNK8f87Qcpm68oZiRApO4KrEEgJZRrKpJNYEXw1ZBS6mWXYONB7UnliNF3XiL4z3A9fWyTS+POsgRG2RDCE44H8Y6KAMgj/Mwjo8X3+MedF1FYRZqRLrcnpTQoMpuNG63isaO1ZeBfz3g6Pf8xaTLI6Idd/PWtzQSwI2YqVP/ibSbvrEqKYp3TVocf0NFvnR2ME11lugNe7TMxi9h577whS9yGVjy50DrUP2B6YsbAwXJ6//1ciA5m9ANFN4kemMHPx0vcNJNSooVhP+amwT7ZlQGn0tyIk2Tg1qqz3rfGdB3FDmg/HyiJHK3jKUdob4Z50Wz1hpyL3yXvyjBSW5DZD9olnoIjaMWkE74=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(7416002)(86362001)(6486002)(6512007)(36756003)(956004)(44832011)(2616005)(8676002)(316002)(4326008)(6506007)(66476007)(52116002)(66556008)(66946007)(26005)(186003)(478600001)(38350700002)(38100700002)(2906002)(1076003)(8936002)(5660300002)(110136005)(54906003)(6666004)(83380400001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9lcRo2INjEfZTBF3CsK8/nDCjIaBets2lYASy8k1pSBkpP3a5QCCVA+sxG2e?=
 =?us-ascii?Q?PtZRbBVyut7VIkOp6xav8l2rZz5nvNVy5mN5FXAgK9XBpCGRSi5FHHdwYI/4?=
 =?us-ascii?Q?4mlaulUrJWAf+fnuY+Zb9gdJax53ALyCcasgyFc27BdklAx3LsIi6lx62jF4?=
 =?us-ascii?Q?nb6QDU98bZaO7/1OE4ZgkSH3xSt/vt03uSTMdUbohxxNMpq5fxNfR5cH+FKL?=
 =?us-ascii?Q?1EU6LN4yuhBuWh+4JMHnPbGlO2LqTh3SRfKJLZyu0V/RUiZtJpn1ZtBDgTXb?=
 =?us-ascii?Q?oGO1P9BgNqH6Em/w4BtZw4U5is5pTN8sLsCfjwCc0w3ze5oCWNXOJuMwyYCL?=
 =?us-ascii?Q?TCK5hyoXHvJmg0uiExCIeHZnNywoUVhiY3pw4315Evo39/q4wHmquuedxCX4?=
 =?us-ascii?Q?i01Dt53jA7ckOgNdVaW9PH2prFHVfp72zfTCTpNc08ojLxLerxUa2ng9E+aU?=
 =?us-ascii?Q?Nbhy9gJGSAzPVT69M/SwD2p/P31ySybgIMs2I6ob3fAnXSMX1mRI/nyJz5bc?=
 =?us-ascii?Q?+Rx0ElEO2rlmETCdu9c0YpItjjKKPZ4TVk4OS/7V4w8sq5qwyeHAoK3cpXYT?=
 =?us-ascii?Q?hpnAHrKlCmz/COxF8rjqEJSLJobuLiV87Utan21amE8cmU7q7hawJh8vVjgW?=
 =?us-ascii?Q?nsMfXfaYeB/5Qv7L7J8/cgbzVIepn0Q4NUCR5au88PRZN5ZoNePt1S7jMM8g?=
 =?us-ascii?Q?S1MRoBB8numCyL6y9wQAX5e5ZieOPUUkw2/KWNS5MV5QtMyZKa3UeGnRpwBv?=
 =?us-ascii?Q?bUOeefEfVXsPWIc/14KQk6MGqirqHljgl6KFg30UatsV5VKwLDO2Z86FBZhp?=
 =?us-ascii?Q?xO3osGuXf4GTnLSrMe2clgO/+akDlvJsUbH97OVfIH2lCgsNuexKVdQBuh0O?=
 =?us-ascii?Q?+GiVN+Lbv24zoictVS2pdSungE5/73Q2bVhFV/5lAstHP8M308y3yFDXGFrM?=
 =?us-ascii?Q?yd6H+kTYCOPrtEuEQW5AiMe3JaA7IoZhQ1c27w2livw3u1alv0wGVyDJQ5iU?=
 =?us-ascii?Q?EF+DYmD65pC+z0aTs6L2VSo6j4x4yp3lKqZn7M+yP1ww/R17oX7B7TiXg+3a?=
 =?us-ascii?Q?+hNUZiIXqhDWkLB9msolXf9KKo1GW6u1H1rqcoUhFuf4DPY5LcfUksxhifWa?=
 =?us-ascii?Q?/+JB/hdJGk2K0uUzbqZiAp4DwuI7t3h57BfL57Yknq6O4MBUJOExwpNQLtd1?=
 =?us-ascii?Q?T8rooT6ryH2Gx7wUMT56f6DD5J9DxVxPgMtl5MbKqcxAjeYneP6f1bLUHwMo?=
 =?us-ascii?Q?9mGKMh5CcKJeEFiPCoqTZJJvpZiQwKZ8D8FWwjT+2VyLfytr7aM34c9GWKLI?=
 =?us-ascii?Q?a/pDu6HaIQgGMygcArNlBYpS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4c1655-1691-4cd5-352e-08d95bf0d25d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:20:13.0517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dL5hw5DSK377DWIF/WqefcQjlBHxY59cuwEWYaNpwo2QB47sP4opn3I9mjfXZWNi4x0XTIP8Cx1HBcj0br1P2w==
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

Fixes: 291d1e72b756 ("net: dsa: sja1105: Add support for FDB and MDB management")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8667c9754330..b188a80eeec6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1635,7 +1635,9 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		/* We need to hide the dsa_8021q VLANs from the user. */
 		if (priv->vlan_state == SJA1105_VLAN_UNAWARE)
 			l2_lookup.vlanid = 0;
-		cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
+		rc = cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
+		if (rc)
+			return rc;
 	}
 	return 0;
 }
-- 
2.25.1

