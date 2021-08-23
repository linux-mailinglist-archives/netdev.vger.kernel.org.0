Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E493F52D2
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhHWVYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:24:14 -0400
Received: from mail-eopbgr30042.outbound.protection.outlook.com ([40.107.3.42]:5229
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232724AbhHWVYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 17:24:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeZGnL68QPSSEjCz1ajgJOCNGOQfXENVgwyqUwWGRPn67ST9p87+YeZKOsfCdIllDtPPmsKI0UOzCQnyR8WfIC6PtgztvNojjTooVT8WEQOf452NuRcT6L9Qj5TDLrgvhvZTZdGlu7mAAWz4rnYj/05woCH1txwb5DWbGcAUaRn5tBX9W0NLRotdK5oltcOcR5qIvpSTCIJvJaw7+dWA+d2i/sKVkf+F9aHu4IS/jiy1mxBZZdZTF5PmRmFIL4Ay+raqw6w6QiflpUj+WSnlno/NG80LmhqViuNe92/fFqNmxQarfD+anmns/YJtwh561rcecOsR6+bTfEEP/al0qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jV3mPb8PPAsAc846U6PNc4Qha/nVyXRJKB+MO1YCBQ=;
 b=LppSwtnkRcJD2xXBM+5rC6GmpKLs7R9qb7oh3j4EQl910Fdn5ATjIKGiOcRW6qcEB2ui9CDaXooqvKvnSUaTg0Phq9xymbPRVjWmAEhC/DtaobhaBxM3eI/5Ekj9VrnXIs94/ncFuT98LpD67q631D3w1eEa3REGNBcmfeh1dsJObjKTooYmZgxOh+69zJ7Z6XEqIFZtUkmsS9U1ZLLwiNEYCgm4zYFpvWU0UNFT2piQuujxxaOiu6y1wwbmsXxBYOBv9C+iAtwtC0I896NvEkcamAkOXBLEldtE/mbUI5JXIHIFYhkkZBrYHgL9XTz1Djbnq1dACGbUr/BMCjVoXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jV3mPb8PPAsAc846U6PNc4Qha/nVyXRJKB+MO1YCBQ=;
 b=XGh0uCRKgpoGTnwu2/geHWupgdgrfdXvX8vgurso5svMrwa6kcNQ7nm41LfR49986vWLatWLDk776ttfcCu4UATYGEMkuHmvoU222E1wqKYluMZ4TEnXPdxEaHhoxJSPq+w2LsDTSHa3yynNrhiOpMAKupVWjcJQrkhhBs2zu04=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2685.eurprd04.prod.outlook.com (2603:10a6:800:58::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 21:23:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Mon, 23 Aug 2021
 21:23:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next 2/4] net: dsa: properly fall back to software bridging
Date:   Tue, 24 Aug 2021 00:22:56 +0300
Message-Id: <20210823212258.3190699-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823212258.3190699-1-vladimir.oltean@nxp.com>
References: <20210823212258.3190699-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR05CA0150.eurprd05.prod.outlook.com
 (2603:10a6:207:3::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM3PR05CA0150.eurprd05.prod.outlook.com (2603:10a6:207:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Mon, 23 Aug 2021 21:23:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffc078a3-070c-4472-32aa-08d9667c37e6
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2685:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2685FFBCD8309D50FDCC4374E0C49@VI1PR0401MB2685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lal147Ysg8OR7a4Q6QawQDEwhmZkjPytwZkG9PGhMATvMTeDmI5IfRawFUoavNwrmrYzAbCzQGHXoKwUbATAWrezO6/soK4nzTJo6OVN/JPgKd4X5CtZ2wz6jJ7PyUIZECMCkOsjZSqhhQ0W0YUsn5w01G38Twv2c3rUrlgwkj3xfl2O+7tnybkgHQ58a91Yq1XBj1zDzEORrrTK8hO+YPAFK+iP4qO5MNjGh194s0t/cYePR1vpaLK2CLg3NJD8fE2z7kjDD0IBRc4ym4QD7+r4LmEhuomfySdkmNpoqSu2f+rC18PZOzM7Rjv/sWNZFOXl3ENX/PPm8wd42kevbJkYTI0rXQFxDoofSMjqfUv3eo6FpnupvTBi10O2vi6EveKGE1nQANJmPuoxhR1Er6+9pn9BDITD81IGjgnOGY5Yc+5rQ4Rw5VRC6MD2/bWpQSMX1JIMc9olv2aE9dJolZQ9BfrLAMXrslHnuaAjJMkJc3t0sTh0dOAgtUNTMe8/ToKQAXKvBxKwXQkzy8MK7FiKIDgnGh9eT+EXWo7W4tlEpqUFsqx8R16TdNMejK13Wi/vaRNClEZxKaZsRD3atZaoY9UG7PispAg0GjnVdx1sMZP1fKeRhHZVuTzlFgan+UCa07ddxGxKRkovmjo0+M6KjYBf+DLWzibcW++WMP3w/z2G1pDvI0xaaN+sAOvaW8RhGmB7YuW7iggPzqz04g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(366004)(346002)(396003)(136003)(86362001)(66476007)(66946007)(66556008)(316002)(6916009)(54906003)(478600001)(83380400001)(66574015)(38100700002)(2906002)(38350700002)(186003)(36756003)(5660300002)(1076003)(6512007)(8936002)(6506007)(2616005)(956004)(6666004)(4326008)(44832011)(52116002)(6486002)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWRZSUtNNzR0aUhwejJJekpGWmd3VXUxaTg4VE9FZ3pGa1FIbmR4UDJ4K1du?=
 =?utf-8?B?QW9Sd3J3c2ljaDdsdHdTTnc4bHVDTlhNLzRaV2JjRGN4S29MeGhzVXZyOFhZ?=
 =?utf-8?B?eXNLVkFBQnpUY0VaQ1NjME1OOTEyeDRPYzcyeHRhV2JmeWdoWHQ0UE1GWXZw?=
 =?utf-8?B?WDNqaThsTjcxb2U0SVpZOFNZV3pTN3hPZDRvUDNJNmU4cTJqcS9ndlBDZWJF?=
 =?utf-8?B?cFpQSm9Cdk43R1JyRHExa0toN09pa04rdm8yTUEyVWpWdGdzZWpWZmJjQWlx?=
 =?utf-8?B?NXZMdFdRbnNqUTZIdHUxVzNvUVlmUkhNTm50d1djOFZxZ21pNlQ2SWhEUTBt?=
 =?utf-8?B?NWt1bXRlWWQ0cDJHZ3IvMTJYbnlNeTVZS3kxSDZTRzFkeUZlVnRrVmMyQUo5?=
 =?utf-8?B?SUZ0UXZUT2c4L0l1ek11cFNOZVo5MGovemFtVGxKOW9vQkUrMHFVZU5RdnFY?=
 =?utf-8?B?VmRtZEUxNHBRMmN3UXBDdGxGTUpZMHB3VHZ6MTZIRlVJTUQ4bkpqeDczKy9F?=
 =?utf-8?B?bHNyL3NvK2FPU21SM3pSeDJqUVFhVEh4TzVRdzNiY0cyeElTYWRVSHA3dUpX?=
 =?utf-8?B?dHJtV2l0T3l5Yjgvb01tMEdsN3JHSmc3SlFFMVJNakVCZUtQS2FnOGNQV09i?=
 =?utf-8?B?a2lOTGM2VS9nVmliQ1VkeStFTk9uMU00WUhydWlGM29OY2RmQUdLZ3huaEc1?=
 =?utf-8?B?LzVnaFN2ZGNiWWdzQnJxQnVoTFovVm5nWXkrdUVFd2dLWHlIWXk5VHpLV3ln?=
 =?utf-8?B?U3BFWGNuUElha1gyNFVPN1V1L0xtUGJJdk9lRUZNS2RSMGZ4b2J3N1ZKTmxm?=
 =?utf-8?B?WUw1TzdzbDRHd2VVK0I1emFhNTBCb3hkZ09HU1BTL21DQjhxQlZjblVxVWJq?=
 =?utf-8?B?UitRVFdyZXhNSTVMbWlFK2dKR3JTR1k0Q0FoWjNJbHEwdkIwRWNZbFlHdlVh?=
 =?utf-8?B?KzNrNlRoYmlwSXFqMnNyZVErUXAwc2RZRU5hL3RlRzdzREMyelVicG45b3Rt?=
 =?utf-8?B?UXdzdTYveU9MT1ZYaHNOMENSSlVrcm94NmNJK2E0ZUFuaHdmTm5lc2J0M0Z3?=
 =?utf-8?B?c0tLODRLaGZsYyswbWlydlFSbzN4M01xZEp6b2ErSmFJd0d2Z2kwUzgyTTRB?=
 =?utf-8?B?YXlBUUpJZURaRTRsR2FKTS9JVlNjOElmaWVPUFNraUEwMVFZV0owaisyMitO?=
 =?utf-8?B?ZmZTZGV1b2Rpa1R0TkhwSGY3aDBHTTk5c1hiQkxQRGtJYVQ2MDBtbVdKeGV4?=
 =?utf-8?B?YStVdnBSOFFiT1pMVWlkbVR1QUppWGZ0aWZud1l2blUvVkoxSVEybkcyNitZ?=
 =?utf-8?B?bzR6REZHTlhEK2lacUR3Y1diaHN5UVV0bkMwWEZ2RlAzWFgzS3BacmNyYnNH?=
 =?utf-8?B?cGVUUk5lZERQR2pyZjYrSXBGWVR6RHFmMy9qY0FVSzFZMTUxUEVWSGxCRXI0?=
 =?utf-8?B?Z0pOdExoSU9qQVNXbXkzNU9FRmVLV2c0SzZnVzZqNFNBOFNDV2hsRU05MnVi?=
 =?utf-8?B?ZE5ZbkRWSDlBSWwvWENzdnUyakR3SGZkUVNNdUI2V0tsMURwWXhOaW9YZ2Fa?=
 =?utf-8?B?Z3JhN2VOWmJKMmtYZlBMSW93Rmo1UDY4eGgzWlU1TnEyVHc5RXBhTzVxbTBB?=
 =?utf-8?B?WThVMHdmdThxVk54Y1paeFdzODJMbDVsSXp5VFd2Qk9KRnozdTZkaGFscVJ5?=
 =?utf-8?B?K0xVR2o4MDVGcTByU0g5L0RURkcwdVQ2S0JqUnJxbVN1VmpNMnZCcHgxY2tS?=
 =?utf-8?Q?pVL/6AZW/E6no2Lqb7H/MYv4yuhzmBaAvYCAlHY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc078a3-070c-4472-32aa-08d9667c37e6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 21:23:15.1185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRSQYdTIjJp/zKjnG6R4AEzSXjmsGUWSg1jCny6YKn1K+Rg6u1GX+E6DK1MfPS24X5rXM10laHr08RlbJ2MM+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the driver does not implement .port_bridge_{join,leave}, then we must
fall back to standalone operation on that port, and trigger the error
path of dsa_port_bridge_join. This sets dp->bridge_dev = NULL.

In turn, having a non-NULL dp->bridge_dev when there is no offloading
support makes the following things go wrong:

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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: made a correction in the commit message about what's wrong:
"dp->bridge_dev is non-NULL" rather than "dp->bridge_dev is NULL".

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

