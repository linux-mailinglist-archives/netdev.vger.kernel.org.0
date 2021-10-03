Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFC342044C
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 00:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhJCWZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 18:25:28 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:35009
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231835AbhJCWZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 18:25:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ir8QfTrXOFQR5NKwvJF5IkaEh6mDYHuyDTNMVIEGq6lnUnHVmBoGpInlU2ukZ2/tHFM8K+KD6s3h4h5k4Fw0ln0vBZwxAYUF8S405SfDoqDambMDNOoaAyIiQJcO4iSonsp80Pb9E/fEgRb5Q4jAA2ilwhd4kpu+j89WsgkcyKytYLym9lmQKQ0YfRWtcffUiRLLVqRZehvJrnyEdGCsm0pAMDhDgW2b0ll8J1pyCSeSxqrKVMBy6qdjU0Je2zdkMRMn3vuQa2aNvnZu3bg6O5m4ynIH0OQhTFN3GSGOK3siSuy0mdxEDiY6kK07fdhBGeL7PpBbm8MDv80taeHW6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+KKGaH0HwqP+qqDoHYDjjmLRXsEtBGe6LDFqnifKv4=;
 b=dEBQJ3LwVxr+VIUu48Ud0KDS9uJ2Ep9R9sGGUJYX6fmKDcZCRnc8kVagpSplC+KWCclJ6Dr6+rFsCNb73oqxOwgACLRg1jzo8Gm6AUsVvgDT2z1kNAQd02WDOLTxAw4Kay+BRRCrYL/NXq/Wx6mJTV22Qh/6ehIlOFQvsTE6zv6fQgAZQR0z8WFJnYIPDX0CcI0Xp6E3KWstkC9wMHPQ1FMKF/t+deNWNpt3h6mULlL3Qqp0vu2cl7qLxeVLpZnTRiuzrErELaL7JqYTyg+YZXCb1yyhmUrjRtIwFk+8zmvAM2r1kVh2gEbo7C1aR52iAj9gNa0YJ1gUaUIzn66ndg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+KKGaH0HwqP+qqDoHYDjjmLRXsEtBGe6LDFqnifKv4=;
 b=MQMSKmMv/2AosKTy4LC7rqrxe6qQpeGUDJE0cxbXbVl4YV8J1t1tNVfbJ+148GAs2ibXwIXk4EvM2n8NcNZrRHVxlUtJCEHT/HnrI1grXClEdAlqqeXP193TzBL41QHEgX0aoAleD8Lt9F5ByuE2w++WBV3YKSZSamPOvPcpsbU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4814.eurprd04.prod.outlook.com (2603:10a6:803:53::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Sun, 3 Oct
 2021 22:23:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 22:23:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net 2/2] net: dsa: fix bridge_num not getting cleared after ports leaving the bridge
Date:   Mon,  4 Oct 2021 01:23:12 +0300
Message-Id: <20211003222312.284175-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003222312.284175-1-vladimir.oltean@nxp.com>
References: <20211003222312.284175-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0502CA0068.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::45) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM6PR0502CA0068.eurprd05.prod.outlook.com (2603:10a6:20b:56::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Sun, 3 Oct 2021 22:23:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c27bae2c-cdc4-4ecb-8fc5-08d986bc7023
X-MS-TrafficTypeDiagnostic: VI1PR04MB4814:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4814D9668CD13333CF40BAA3E0AD9@VI1PR04MB4814.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0jxvcN84wgKj907jW+eFqAOQ0J1tWnH5VDLhYp4CLOv9Uca0Xij3TnwSA/naqF4YGkILS/X5+m62uIgvNE2v+5rF83utzNhw7FF27hiep0jvNlg+49q4MqrXmC5ZKJyIUwbRqrJtWTkN5TPQwWJHG79t39qUHLRzCQTc5bjHTop9jxft378C1sC85l8s7Z6SmvDr/nWahCBwAMtbs4zvtweYmyXHHok9scNyOYzUSwwcEldtDTF/W6r5PFc9tL1ZpnO2K73ORfbNKynPnNlq41ndq9jpE9WvOr1ioQqCnOSGiqRyCA/kihu+4330oZo0ck7r1DNubioawxbDe01W2J8FQPXtyPyiJ9mltj1VbQ+Z9/+MZ2P4Eh9QUlEJVYWI5oMdTXUotkJ9LZMXqwaULgVCQs/6RN+ihQEI8atTlz7FBLyAchnR+QRCxP2+ODKFGmEU5ukhDmk6DEl79ZwRXeovG/KdKy0HArFJSycc/VrRprGl9iXNrD2XmgNFJd50IUsCg1ZZr9YS8xF5XY74AXkRbLAGW2HIlgKyRhkqYuOt/Hq16gwtliLwYkFFHw0+5L1RN/l108uS2akTRTINHqrVH64he/yC4wRh2E5nU2K9p5ByRaiJqMKa1ARlWvMJfRn+tEZ39+JPpDgtMxOsNAYhLMW+NEaeRgx+MwtuxZ7Rg20OoFXxLShB/Ow3+obF4Gi/BJoS/YCWQKEjZDVvzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(5660300002)(38350700002)(1076003)(8676002)(38100700002)(44832011)(54906003)(316002)(508600001)(6666004)(8936002)(36756003)(66476007)(66556008)(186003)(6506007)(956004)(83380400001)(4326008)(2906002)(26005)(6486002)(110136005)(86362001)(2616005)(52116002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yKezDXDHxAeUHjKqRNr7eLYPtDLSqorEtdlhM7wEAwKpTmrri8YB8hrCRNLj?=
 =?us-ascii?Q?W9Pr4eFapd0M1jtzA23wljX59qa6iDE1lW96xloQxzSrKfrv/APhSB3wl2GT?=
 =?us-ascii?Q?2XQ3MAvK0WeGXXpQM5bV0T9buJV9LSsaal1xwmr3C0cDj04jbEFaqNgwbgab?=
 =?us-ascii?Q?fmn8+1VUbHMXfI5vVDb8qcZiSZdFp/bnOpkN7BQslEgs7nBQYSCEbaOfdAUQ?=
 =?us-ascii?Q?LTNhtvwO+7hO87mHHQ7OObJ0/xHw8/WqSaW4ut6v6+mXNFWeTnzJBoLUIJs1?=
 =?us-ascii?Q?0q2T70NPNRPGEeqM9gwPGKeeNqFEO7QRsstt34RzevF2WqmUaMCPJ8hFLJ75?=
 =?us-ascii?Q?aH9RrWq9UX5P0M/m+DbnDbVdmPm5SkpS3IHGstMuRx69Mae2BaVXz5ZJLr5K?=
 =?us-ascii?Q?KKCERPN050QuAdqc3L2O7TJPMRZ8nHAO2epttjymqjXwaPpx51aeOAk3bedH?=
 =?us-ascii?Q?nC6v8tvd/HtkvoA759iNRWlVCzHVOkxGKO74Le22LZCgQloGZx3/xaFjWAmm?=
 =?us-ascii?Q?cGuiz9DLO4QjyehidS7uwGNPakPVBYXLb6GpD4pBdvcLqNgeWWHs5jsQ3MlY?=
 =?us-ascii?Q?T4BeUxkUuMdB8Gj9OMi3Kx6vncSsK7uYCOj7htsITep/e+l3wQsClhAOfNiH?=
 =?us-ascii?Q?jkC5zyxTiF9x8TiqiNZUdaKW4zj9wc+qi0j6xWeHuWTmysuuDPyH33SLhzWf?=
 =?us-ascii?Q?h0uIxsXgLiGsB2B/AwE8n7LSzNPJFlJlDQaCanV8/dKGp0nu+In+lHchd89H?=
 =?us-ascii?Q?k/J46N5WiZI9siNULImvbq+l+gdmah4291BvZSDHMXDRjOu82xE+u/A9h6GN?=
 =?us-ascii?Q?ywISBJwTBmgdz1YP7hsoJ6/rZfOSqVdqm1xiGQvLTbCbXSHEpkd28aWo4Hjl?=
 =?us-ascii?Q?NFOjaCNVVzaVNHepN2PUEkZH0c4j/BgIfjXw+XqSo4+arg0p570BGV/48CIN?=
 =?us-ascii?Q?j5cor1PBVs23BlHTA1n0+weBnX2wQr+akf59wQxOOC6e/KfNqT+LO+h3Xirf?=
 =?us-ascii?Q?0zjnpEwfG0wx78I1Dck1xk9M2F/lWW/vvZmaC3jPKEM2nE/c6RLNyuSZ7B8n?=
 =?us-ascii?Q?/LOXUcCcD5VrqgwVwOL6HKLU3ONSQL8aA5m9kQZcFbZtIrCgMuE11GC73Sk7?=
 =?us-ascii?Q?GifT+iwrMxqH+iFqu1qLlQi0YRK8PLtwuAr8mwf4lGHev66moXR6hlFdvyek?=
 =?us-ascii?Q?OObPv9PjPOuStvC8BMGm6I4Kql/KZDmHhYjGPkmTIrS2vaaWDUyubhjfIq+y?=
 =?us-ascii?Q?gNnVbmqGw5k11WddvZ0e5vZOWRjHPWmPg0joIhDGIzTrvfQP4+fU4rO46aqv?=
 =?us-ascii?Q?B9fkh0dN4ZEunUe3Gu2XQj15?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c27bae2c-cdc4-4ecb-8fc5-08d986bc7023
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2021 22:23:34.4887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMEkENz0A45WvRxBC9LtK9gzg7N14O7NvcWENKrjW3RNUmI5gbNLIKTtsDG0onxmDjHSCmii9llFrCrh42CSMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4814
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dp->bridge_num is zero-based, with -1 being the encoding for an
invalid value. But dsa_bridge_num_put used to check for an invalid value
by comparing bridge_num with 0, which is of course incorrect.

The result is that the bridge_num will never get cleared by
dsa_bridge_num_put, and further port joins to other bridges will get a
bridge_num larger than the previous one, and once all the available
bridges with TX forwarding offload supported by the hardware get
exhausted, the TX forwarding offload feature is simply disabled.

In the case of sja1105, 7 iterations of the loop below are enough to
exhaust the TX forwarding offload bits, and further bridge joins operate
without that feature.

ip link add br0 type bridge vlan_filtering 1

while :; do
        ip link set sw0p2 master br0 && sleep 1
        ip link set sw0p2 nomaster && sleep 1
done

This issue is enough of an indication that having the dp->bridge_num
invalid encoding be a negative number is prone to bugs, so this will be
changed to a one-based value, with the dp->bridge_num of zero being the
indication of no bridge. However, that is material for net-next.

Fixes: f5e165e72b29 ("net: dsa: track unique bridge numbers across all DSA switch trees")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b29262eee00b..6d5cc0217133 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -170,7 +170,7 @@ void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num)
 	/* Check if the bridge is still in use, otherwise it is time
 	 * to clean it up so we can reuse this bridge_num later.
 	 */
-	if (!dsa_bridge_num_find(bridge_dev))
+	if (dsa_bridge_num_find(bridge_dev) < 0)
 		clear_bit(bridge_num, &dsa_fwd_offloading_bridges);
 }
 
-- 
2.25.1

