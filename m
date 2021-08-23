Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0343F433B
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 03:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbhHWB5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 21:57:31 -0400
Received: from mail-am6eur05on2043.outbound.protection.outlook.com ([40.107.22.43]:18787
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233258AbhHWB50 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 21:57:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMICNXiiisLnbdHbfdLhw1NUdB0Br/ASLBv4iN4HMNl68go0lZ2/Z+0FuxKuH/b635UWBN0hcjBDWcMXMucvm0hXmGmWbVzVP6CiVG8fPbe0lrsTSm2a2lsLqN26o2O8uqEZ1jywcpYlHLEhbTxNjGkFsb6acc69PObBzM1nULL3gyefoio/FAUUqu//26cOE/CdpMZjzcyeRcc9+Rxr9kZVmxKudn2y3KvhB7e+f3lGkgjlTFh+KVBV8O6dAu4TYbICAF64hLXJqlPRAnHoV7mwYbGVmGF0igtcSI9h17wGMesv6tecMnNwi7w2OCz2zCjGu4CWIt8bqwsBBesoyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ks2B929a6yqzlDOB+s0CkqfoQvNY6f862lSYf+lQaY=;
 b=S3wR9WpQtPkOCcJg/St9KjgdjHJsCEaITuBYHlMXhid3ivSIFNrP/649oAj6lEhsZB76/8Bid963DzshiHpp2JDfA/rUyQqiQ1laz/19hN+vhK1dE53TkXx8Sb5drGkrs+zPlXx2bbNRML8dtedGAHaaXlJ9Buf9w8556O4yZVlynXokx93vpgoikr5H9t4uY/slQqIMEBhQXY8YPPZSVZJplbgHHW4dgYx8NTURGHEYf5304QuJws3gFIeqQKWoZ2+yGjLLjsJrsbJKr5gHueoMMRPaigOGD1QWl4zkgzB9Yx+lbPEUzJjdRYW6kLE/xloRYhp8hHDOT2WVUyaVgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ks2B929a6yqzlDOB+s0CkqfoQvNY6f862lSYf+lQaY=;
 b=fuXoW9ErAX8V3jIYtQg3k/Nj3hLho4aFb28/UrBHKQ/6pEYEVKpN9fmuaq/nZBfBqNoVuJBFvXK2O35lTVCUZD9CugIqk6aXhEgQM7gqR8fQ2JBq7pY21ziU/DmuCqkvvzrpvpIi2QMIvR7BJesDMlA6L8dWlaDGDbygE9V8Da0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 01:56:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 01:56:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next] net: dsa: properly fall back to software bridging
Date:   Mon, 23 Aug 2021 04:56:31 +0300
Message-Id: <20210823015631.2286433-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P193CA0002.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1P193CA0002.EURP193.PROD.OUTLOOK.COM (2603:10a6:800:bd::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 01:56:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d70347b8-c31b-49d9-27fa-08d965d94039
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-Microsoft-Antispam-PRVS: <VI1PR04MB569613F7A7ED6EBED9B4C48DE0C49@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jUVr3nnqX+XmNKXimWAfTihw1WeOusQ9OXplvnXY47RiAusdCH0GZN1LD91yq+Zs7ixdd4VemVKWz6Exg9Dqc7T19VXEjAFYAJVtLcydPvgKl/+7bbGE1AjKn/pobMvNFg4y+6wWRqHN1K0qRt2Bmq1KkTZb8w0VYQcC3evJxNRqPHl7Vf1c9b7N1StBh3QcSliPWfckLbz/5Keev11yXJFdEhCZwR9lvxhZuA9SxpHfNaXA/lPIwPJgl32qFjl+OTmMej8NDCxG35l8EbAn+YhQkRE7C2HcAxfGlvLuZ5fqd2YheAKb/S/Cc4gfYh9tB5bJ6Fg67En3KrTzSzA6dOH/0CAhurJSvHP/uVez6XZtRSiN2ySa3nW4aEKYhdPMIVTkKKB234mSY8LfEuvirgMTGa+GWeMl75kGI+lXxsdDCo+VSBkG5PGpgEigcKjgljCCoHL2baovsH0Lqp8vDyVKBkhyezkEePBDKagPWdbXl+GRao9NqV7T61x/fZInFp/52RYn8Vm48qCkXNhFwhwgimWAeJQbAsEPPXClPYumprrSAmh6ZBRRrp1z2PxLFpsN+ATeODZDHoAiNnzs3zZmvPkl//0GC1J+vrakIhwLkYie6QnRQsFexyaq8ZnTkDUoobqs1R4Ricts0b337fhR8DRc2KiLD07EA/Qf114GeIfd2bbRLcrm6ojHED1PdgDosq21UBkL9WnVgf9ElA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(8936002)(8676002)(6506007)(186003)(2906002)(54906003)(83380400001)(26005)(52116002)(86362001)(2616005)(956004)(38100700002)(44832011)(38350700002)(5660300002)(4326008)(36756003)(1076003)(478600001)(66946007)(6486002)(6666004)(66556008)(66574015)(66476007)(6512007)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bm41WmdFSjI3ZGNmQUlLek92RHM1NlZtbUpXSTJodlFlcHBWVFRrdDZCeVV3?=
 =?utf-8?B?VzBMVVV0SlcrQWhsclRhY1ZNOUhTNlpsKzhVQTJHYjJxSDBSWjl0SG1tMUll?=
 =?utf-8?B?NFByd0NIc2s0NWpqV01mNnRySXovTUdyUmNNaVVaZHBpTTMzZDdQWDRjL3dk?=
 =?utf-8?B?SjRQK0JNSUhJSk9SMXU0K1dUL1ByL3NQVEF1MW82bG1IVUw5eFFhQ2VMTnFR?=
 =?utf-8?B?bnBjejVpbFRDSi93YUZyTVpQc2E1ekc4d0VUMTBoKzV6THcxaW5seWNwdkNE?=
 =?utf-8?B?b2pqcE1BMlovT2V0NGVRYmMxdXVsM1lCbFc5aGhMRVg2WjFwdzVNM1NIOHZS?=
 =?utf-8?B?SDlBSnErOWpNN3pyUUFYL2h4N3F1blk1YVd3RUIzeUh0MlVvaURBajVxWEJW?=
 =?utf-8?B?QUZRNlQ3S1F0ZktLdVM1K0MzT2ZSVWNncXRKZzJGQUkzSDZoZ0h2ekoyYWxK?=
 =?utf-8?B?bVVvdTR5MzFSOTRWZW5haVRkTEJuYU5tTFRiMTJvSjNpRVJCa0trUy8wdC93?=
 =?utf-8?B?blhtRWNHWEhIQ3Nxek5NM2RocjRCZUVFVVNXbDZVZ1BpWEtVUmxTT2RxZkF5?=
 =?utf-8?B?dEc3WkVoZkpnb3JhMmNka01na0hQVVVZT0dMdTdvQXJhVXZxdzQrYUtIdHhn?=
 =?utf-8?B?YVhYRGRuYUtvM2Q2TVVsTnBKMmw0eHJZQ0NHR3BUNmI4ODZOK2pQcGVlZC80?=
 =?utf-8?B?dk9tNC9vNVZHVUQ0RUg1NzNTZkMyTGFyS1M2cmVZRFhGejIvQVV6dVBYQjFa?=
 =?utf-8?B?blozUFhWSVFxbnBaU0FMLzI2VUR3bUd5NUpVT3VTTlc1Tm1OcC84VGpHQ0No?=
 =?utf-8?B?VDJUSnhjdmo2M1FUNEtxVkhPSmRqaUNvOWx2d00rREl5ZXE3VnNFeU9IYTZG?=
 =?utf-8?B?amZFZFRYUXZ2N2c5clBVZkhVVGVNZHMzQlN2ODBNM3d0WE9mUTl3bXNGMVI3?=
 =?utf-8?B?ZHpybHBIMDBUVEVGOG5GSS93OGV4emFTNnNTWTEyb0liKzMwR2dDRUtuc0Jl?=
 =?utf-8?B?cTY1c1NCa1crb0JldUZ6NEp6bklZR3BmeWRxVzBFZXRlbGhCell0dlZSRVJM?=
 =?utf-8?B?TEJpUXdmc1V6NmxURmgwQTU0am1rdTRKRmgvN2lDNEsvaHAzNG00RDRTNi9R?=
 =?utf-8?B?Z0ZmeVFRdWFOaURRbjk2eDV5a1hRZlFkWFFYUnNmQzlGRTJ2RVFIcDdzaXNp?=
 =?utf-8?B?YWNPZ0M5UmNhZnorSEp4bFpkbmIyVGxPQzVoOXpnVFY4eEhYMlZlM0hUaE5P?=
 =?utf-8?B?dWVjV0l3N0xNR0ZkRTRRNytXNWc2TElScXRRMlJhck44V1dlR2E0M0FvZEpq?=
 =?utf-8?B?ZTBBV3BxWGFvTlBKZTZoWnZQUVJieDhvWEYwN0tDd2tRSlAyNFhqQzM1ZS9z?=
 =?utf-8?B?OGtQREltV3QxVWUyMXByOFVWVlZWWm9xR1VjamcvdkQxQmZkNUZxVFdlaU91?=
 =?utf-8?B?NkJXd3hNc1JJVG1SSFAzWmd1VGhRSHdNcXZmdXBmMVVHVXlrdDN1SU8vOWVI?=
 =?utf-8?B?MzNZVmxkVUJmOXArR2pRdWVkUDgrcnJmMlVjK1c4L0F5cUlCQ0kxSE81dEwz?=
 =?utf-8?B?c1dmc0c2aHRaZ2JmdWMvZG1pZHFrQkozNUwxTVRyb3dTV2svYVlKUXJnbWxG?=
 =?utf-8?B?S25vUTNySXNuVnVSLzhxSlRjVXZEejVLYkRhY2FoNDgwWU9LYk1BOEszTUJj?=
 =?utf-8?B?OEtKM3MveERqNjhUYW9vU2F6THRLUXpROS9FUGV5L3IxZXlKcFRza0VIVklv?=
 =?utf-8?Q?0k/h3yDlakYizlancZDmNsydTJkYlA037rMLia2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d70347b8-c31b-49d9-27fa-08d965d94039
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 01:56:41.1191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJMgrzBMWZENvgoXPksp4YuwqBX2vZP5f8PrimbY7MgLeDanEDIKELZUPqhXBDN9yldV7qRu/RamHhTdyVDy3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the driver does not implement .port_bridge_{join,leave}, then we must
fall back to standalone operation on that port, and trigger the error
path of dsa_port_bridge_join. This sets dp->bridge_dev = NULL.

In turn, having dp->bridge_dev = NULL makes the following things go wrong:

- dsa_default_offload_fwd_mark make the wrong decision in setting
  skb->offload_fwd_mark. It should set skb->offload_fwd_mark = 0 for
  ports that don't offload the bridge, which should instruct the bridge
  to forward in software. But this does not happen, dp->bridge_dev is
  incorrectly set to point to the bridge, so the bridge is told that
  packets have been forwarded in hardware, which they haven't.

- switchdev objects (MDBs, VLANs) should not be offloaded by ports that
  don't offload the bridge. Standalone ports should behave as packet-in,
  packet-out and the bridge should not be able to manipulate the pvid of
  the port, or tag stripping on egress, or ingress filtering. This
  should already work fine because dsa_slave_port_obj_add has:

	case SWITCHDEV_OBJ_ID_PORT_VLAN:
		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
			return -EOPNOTSUPP;

		err = dsa_slave_vlan_add(dev, obj, extack);

  but since dsa_port_offloads_bridge_port works based on dp->bridge_dev,
  this is again sabotaging us.

All the above work in case the port has an unoffloaded LAG interface, so
this is well exercised code, we should apply it for plain unoffloaded
bridge ports too.

Fixes: bea7907837c5 ("net: dsa: don't set skb->offload_fwd_mark when not offloading the bridge")
Reported-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c  | 5 +++++
 net/dsa/switch.c | 6 ++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 78c98882039e..c5715f9ec8b3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2151,6 +2151,11 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			err = dsa_port_bridge_join(dp, info->upper_dev, extack);
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
+			if (err == -EOPNOTSUPP) {
+				NL_SET_ERR_MSG_MOD(info->info.extack,
+						   "Offloading not supported");
+				err = 0;
+			}
 			err = notifier_from_errno(err);
 		} else {
 			dsa_port_bridge_leave(dp, info->upper_dev);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 92a07d96c0ac..d311cbfc7035 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -92,8 +92,10 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 	struct dsa_switch_tree *dst = ds->dst;
 	int err;
 
-	if (dst->index == info->tree_index && ds->index == info->sw_index &&
-	    ds->ops->port_bridge_join) {
+	if (dst->index == info->tree_index && ds->index == info->sw_index) {
+		if (!ds->ops->port_bridge_join)
+			return -EOPNOTSUPP;
+
 		err = ds->ops->port_bridge_join(ds, info->port, info->br,
 						info->bridge_num, info->extack);
 		if (err)
-- 
2.25.1

