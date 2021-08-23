Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBC23F500B
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 20:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhHWSDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 14:03:47 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:4129
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230382AbhHWSDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 14:03:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEVfV4kAYghwySgpTkgQXY23LG+7kLrsn7Ltm+MEeSFBzILonCSsG/pJVkY9wKzDJMzjtmWPhxayti/sJx5U5/mvwvjxhcdIsc9BXE+ypfmuFtm2sFj+G4xvC34N2rGda0bR457X+v7Zzb1hS/JLhIS3SLtgpXyPDmr1Dntd5TX6zXJLAHNUiwtCxnQjdFKukh2cHbGo9pMcBan6tBkU2tYb1wE3A3PVsd6/A5GawLAqFI11S7asIMazUXW0Ilc2XCNq/zcvAetm1oObWZ3ZE2w5q0X8VHSkjjPIKcr4bgu1trj9TCuddfX1n0yeCErBqMM/bByKNQr55J8BT7EZZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=030Z5IStRDMRx2CKoVf7FsHUQTu+sfJrc1sCy5YfcGY=;
 b=iLSoK1/QtaIilz5QfTBzlwvWvvGrn1/Ap7/mRaxV9cNttwurV4goAUBDPn4CURpsGQghcF2BOtqSQIwWeWxPayFEAOp3Nr0kio8YyfDNnkM39J5lO9y9MwsVCW6f45RfvgPkcBgw8xuj/Y1rNWLvN2mYenkO3vgoG0jpgS50fyMR768QsHalJp1bj1+fZ7mSnd2N/QKyP2YAhpZ+YVCjyqfYnzLkfKgO8UDSe5+bAFcs2jzunFJwae0i+oc+As3lmTn7xq7AOStE36dJ7SKBR3bHyStYSHDwVINYkVCYTx9BqeIKBPoRuaVdqwXj863CXwZ9tYtIXb4iRzdPRPfCtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=030Z5IStRDMRx2CKoVf7FsHUQTu+sfJrc1sCy5YfcGY=;
 b=E6smhaLpiQQfT0VqDlGyicIjRRYL3OD/Og92OyQDWcWhAZvhwMkf7jJTL9cQ/yp26l/wqeNg53TbOkdfPNKidnxiHgf/HiCA1y0/q4d539m4VviK1uHqpSKfqtnq0LaY0bMifN4bpNnFDX2DH8BK+CD5XBhGQLavwo97Gh7RqrU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.23; Mon, 23 Aug
 2021 18:02:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 18:02:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 1/3] net: dsa: properly fall back to software bridging
Date:   Mon, 23 Aug 2021 21:02:40 +0300
Message-Id: <20210823180242.2842161-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823180242.2842161-1-vladimir.oltean@nxp.com>
References: <20210823180242.2842161-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P193CA0007.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM9P193CA0007.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 18:02:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fdbf7b0-b7ae-4cc2-f3c1-08d966603de9
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-Microsoft-Antispam-PRVS: <VE1PR04MB66394E45573BA425899E24F8E0C49@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /FDF5rlkZsl5H2BpRimyIua3k+d9tub8v7ccANRNUfvO/yokBMDOICC+p+7xBqSNXIvT0tqnKsBAgu6dOMQPIjFzbXsG0UFZvPHCmwgjP4AK3oHxzldAKRA70fvm4+0ehgcSXRl0NGL+xpQj+AegvK+KuRKRNcK+XORa48oTNNGlJZoKDr6rPC8Uy0WI2S9upPvPmNjsYKYLzAvcFjH4gQYJzoM48Zs+ZWg1lNYxT1qiJtRM1i0WcHXaA7o7nPvNqrRbSc8n3sJwDYx6KtVIP74CA1+J7RAJ5Iz4mlBcOXPnbOlpWNwlN35mTcU8QtoEeoYUfmGKTOP7T3a/wu2WgPX/8g3o90pVkNz75ez3OsdTdTklFFsB29buS/qFLwaEiIqJAfa5fI3o6pUe+FkqAZMES9vNMUsrBf/N1FS0bORQcbVGEdbZ6lRQ9/JKIzmF8rgSi8Koz0eJ03anu3N4ETXSeSf2LYtwdPeWWWQS2qmOBi6qGkKEqtK3MrzsXkzcsSuqgo44nzKBDiH8z7C6DOGxqkd0I4HMdwa29Y46hKIZN1f34ccr7M/iLggX7RqxAFGRqZ62aCdu5XHRqXPobAyIgZosZ0G/hyjRulHvoJbF4+ALpoNAfSiXNuK/z2lgLjeKKtTxMuoUC5LcsI3H7uq4+5+QPTipasuVFCMmP45x85OnuqP+56KQbHnuwqXbX0eDQXMDyNISfhhXT1JYPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(376002)(136003)(396003)(36756003)(478600001)(1076003)(5660300002)(66476007)(6512007)(6916009)(6506007)(86362001)(38100700002)(38350700002)(26005)(66556008)(66574015)(83380400001)(2906002)(2616005)(316002)(54906003)(4326008)(6666004)(186003)(52116002)(8676002)(66946007)(8936002)(6486002)(956004)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWpjaFU5anUxU0paQ1Ywb0VHV3FJQVhxdHFtWlV1NHpodzdoekFkUzRUNGRQ?=
 =?utf-8?B?T1Z0MUZIV1RZeVB4b2FSZUFwa0MrTFpKaTNKc09JdkdRU3VwY3BNbWc1TnhL?=
 =?utf-8?B?eWJXNXF6TjFJZ1BjM3dZQmhsMkxzUUkyRHhPR3lBazYzOCszcmdMemk5em5P?=
 =?utf-8?B?MUdpaTQ0NEJTYjdOWFpEN0lFR0xEcTN3ZXRBSDF4aTQyZ1MyU3NjLzVoTHUz?=
 =?utf-8?B?MVRHQmpNUHA2SVROL1JiampHeFE3bEtWaUVHMFFCQnlrSmR5NU44NTFSbmZt?=
 =?utf-8?B?SVluZ1drSDRuODVtaURENDlUUzlISTJYWGplUmNYSDlGOEpoeFJEM3IzSUd6?=
 =?utf-8?B?dWhhbTlySmFlaHdFKzlXSFBXaXJkNWU5eC9GM0ZzNXVhRk5HM3h3U2xYcVdj?=
 =?utf-8?B?MGcwUWlEeWYyNlFZbU8vSXVabE9qTEhLMzFuUWRmQ0J4MjZibzl5Y3VCRXc0?=
 =?utf-8?B?T3YxZVBZa1d3ZGh6c2NYbXhtQ1RlSTdEc1ZMbWcvcWNFZjUrN3pXaGJaNEoz?=
 =?utf-8?B?UjJYOEtvSnF5dE9paFV6RkpHQnVxSFZnTEpDc0xUV0Q5c3o4YVJKMytrTHdJ?=
 =?utf-8?B?T3ZSWW5JSHRMOHJQQzg5a3U1Z1h2UENrVGIxRkZQNXl6V29qK3laajlEVWVo?=
 =?utf-8?B?SlJJY3hqUWxNc2hjN1dVMFhNQ1VtUTRXMGFPWUErSjhNZCtKcW5zaWVDRzNj?=
 =?utf-8?B?MTZJUlI3Y21VV2JLQk9qYWVmZXNoMnZoTU1zQjhiTVJlVWRIc3BndklQRFZp?=
 =?utf-8?B?bkY5cmRzeks1MCtTQUYvNzY0RkVPQ3JrdU9KdHhESGN3dlJwVVNGNkdkSDBI?=
 =?utf-8?B?MUJ0SlF4R0Nab0VYSkhFR1JkL3FMbmt2V0hHOUFtME9ESkJqT3lyNEpQdzFa?=
 =?utf-8?B?NnJRektNMkw5RnZFQzZHN1I4STU0QVRUOTZha2pHa2JLNGhxTVpVamJNQTlm?=
 =?utf-8?B?dGl2OXRMVDJGdTlKbWZoRnh1bWE2WlFjd0RUSWJRdDB4dUlVNEMzK3VRT0Fp?=
 =?utf-8?B?a3hGZ21wL1preDVTblFBR3R4ZXp5SjdKaWZsc1JkZFBVL0tWb04zZkg5V3dP?=
 =?utf-8?B?cUJmSzVXWUY1Skd3SDZDVkQxcHZHSFhaSXFVYnZGZUhsQlFnUGJwUkgxSmdq?=
 =?utf-8?B?TlB3bzV1ZWE0MlZlN0NqS3B2aDhmSndJR002VUowaXQreHFyVnVKaE1YOWdv?=
 =?utf-8?B?dDFNZ1FMSTJxK2cwREJSeDQvb1ZYcXMrYmk0b3pOVWVrL0JuckY5M1BiY2tG?=
 =?utf-8?B?TlZPRE90U01HVUpGUld1WmdXYmtmaEdOODBnajFoM3lPR1J2M1hGL0lucFIz?=
 =?utf-8?B?VEhWM2llRVhHMnAyazJhSGZEYmc1VmJuOXFiNmthN3NkS0I1a2tSTElPU1Vy?=
 =?utf-8?B?Rzd5bG8zbFdoN0Rtb0hZbUtmcWk3cDhkV1ZKdkh0SW96czlLeE85NlJtQ0Zj?=
 =?utf-8?B?clh0eHlLVVREZVQzRmhyTVdlSitQK2swOTh6SllvdEVsU05NVnBxZjYrYkJj?=
 =?utf-8?B?YWlaaGZoWFRjM2VEUnpSUHZXbWVEdmx5QzB0czJNN3p5bm5nd0o0dHFpUmxJ?=
 =?utf-8?B?WVFwMlQ5UmxuU3NjTUp6K0Urd3ZvamRjTzYxMEgxai9IZzNLQThwcWJoUUQr?=
 =?utf-8?B?bTVQWVlFMG4wSFlUMmJnWDV3VSt4TlNvZ2xOYjVrOVhwNXA2VmhoWEhhcUhQ?=
 =?utf-8?B?US8vUG1YRFNaeXlkdWNjbnE2cG1EekdLdTBHeVp3SWYvUWhwcU9TM0c1VGh4?=
 =?utf-8?Q?+LsPQUKmRYGcVdQNuoZuPq6YmjFpUkFFMU4yAID?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fdbf7b0-b7ae-4cc2-f3c1-08d966603de9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 18:02:59.4400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIJ3h3paxao2REptJCqEWQrnVGXTJJkcV1dgLYqlDgct/7LxnlOaOKfcrkwQ3EcbQcyHHsJgPW1Ho5ERlm9WwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
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

Reported-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c  | 5 +++++
 net/dsa/switch.c | 6 ++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index eb9d9e53c536..f785d24fcf23 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2009,6 +2009,11 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			err = dsa_port_bridge_join(dp, info->upper_dev, extack);
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
+			if (err == -EOPNOTSUPP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Offloading not supported");
+				err = 0;
+			}
 			err = notifier_from_errno(err);
 		} else {
 			dsa_port_bridge_leave(dp, info->upper_dev);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index fd1a1c6bf9cf..dd042fd7f800 100644
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
 		err = ds->ops->port_bridge_join(ds, info->port, info->br);
 		if (err)
 			return err;
-- 
2.25.1

