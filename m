Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732693F4357
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 04:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbhHWCLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 22:11:49 -0400
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:24870
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234692AbhHWCLr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 22:11:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtlVjdSDhlYKCk7ulz6kvm8xT6wA5il6IuUvGuhDgjOnQdAwSBB5CaXVZtx/vY/k6I5bBbPNPDqUBxXQkylSrISq1zyFOCRDBa99o3ryZ7OYGNq6byucPPvx/koHS0ZnvEz+WDZb204Ek6lyTB9A5hS+OSvIKiy+ExQVq22VlnLKC9vFC+3dSU3Cqa6G60fr26ku4PDnBDNqLvVvhuocqJlrMd7+sYx5TUnqEHZfOHhx2+uhfpaa6UiLcp0t3K7qh3Fp0lf4ATR33f426ivMe/2d4IpNimFcst4EclaIFg+GEbmJvfDBIAKan/KIvXoQSY+hpLwXUMjl/EBihUnMkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OmkCD/gneWNH2iXR7MG+JtDIvl2BKDPpfM2eCZ4kLg=;
 b=LOJ0Gts4X4v+bmYC7aEFFVH+Qi+x1rO4As47XgAXph8rienMeyuNnxPr3AaHA1esij+Ck5C/E32OOILTSxIoMbK2auU3tlcu+sV58xjhgdVEHKo/Gzob5HjZ1fc44vX21gnkUIc6JsP4xQSni73F1p3VvIPPKBoQd3PXg5c+xryTqDSmmlDIApeKS9BXdjD6Tm51+PAb3uBZePFcv8/tJ/eoHdRxi5t0JclMUZ5b4KK5myUkjFd7HFqECIpjjA8CZuowGaBgRY3erLddGjYnlDuwzviMA9GzApu8QQZ8z0L2nOg3xDOR+aF0Ywxuf8RiVgxGrBn4v+RN58O2H3uPOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OmkCD/gneWNH2iXR7MG+JtDIvl2BKDPpfM2eCZ4kLg=;
 b=euq/llLmN+0lkAUAKY8KkQJdmkT/B6Kp1yVSe1trVsjeg+ZMQ/oNekp7T93MHbtgChWlcqxWljfqGj9WGP7nib4Gh3J3rTorKq7VIwUqLEzPVZqi266NBTarQF/lB8kqAXg81wepn5gm9o5SGVVCvWHFMJ303c082LSpbFQlxew=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 02:11:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 02:11:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next] net: dsa: properly fall back to software bridging
Date:   Mon, 23 Aug 2021 05:10:50 +0300
Message-Id: <20210823021050.2320679-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0501CA0047.eurprd05.prod.outlook.com
 (2603:10a6:800:60::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0501CA0047.eurprd05.prod.outlook.com (2603:10a6:800:60::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 02:11:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7851802c-2c36-4c9e-fcb6-08d965db4114
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5501FC71CDB4B2CE058CFD5BE0C49@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hXYftoBZ3Nx9Qe8AdmHO41ATzF9NrxE4g3ACtE0okIsP5zyC4S0JyKiejMNM386rWFqeMQw3f7eVyyyJYCW9tGZRGNQslCPKVmEz0QQHe8+3CCxZ1eICJcA8Au5eNFv53c4BnIP8GCjPvvIkt8+HRq2uiLTyvyy1CYQ8aqcH8oOS2KdfdIYgwGGnm38LxZLVTZy/kh9J7VN0AvxebG9n7KWQEDDEPLvxNNFcv5kStpBTdHk4wdmgemVAz5JwZcsuNXg5pA6sdg584C3DC5DSS6SsrT+asIACoZoXWC6SHuUaRcnqPZWjkESoQPlG9xBuJSuvVnascJLgrSZaTcTZ+yugevs76qLGwoVdeA8q9uEdAGLQu2vGarfRYzLNshbNyOZAeA02aKWvFDhA6pyEPFiHOJhs6WxM0nHJrjcgZkcI1Txz65Z8TTzdp7ylK2r4SWqjNL1jup4Z9821qV7gb/whVR80SGO9Q5h+rwLYDiAWEZNiGI88rnfryxGjfucavusA/VhiKNoNX4moQgiLau3mFVG08rEZVR0JFAcn+JJuK9/mpuqlPs35wwLq+BvOlr2bH+KFiCfpWEVkx22tvF/gjQyBUntV+GKHZaNU6FNDSzTRQcEsq5jptfrykcedqtiM6hCLGziakpb5AbkAQxLZ0MZcoVhBwSHKu/84YIb2oi9ndvj7EM/jlTu3GDotfdWnxa6WraGYWjZDPW2JRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(54906003)(36756003)(478600001)(956004)(316002)(8676002)(8936002)(26005)(4326008)(1076003)(6916009)(186003)(38100700002)(38350700002)(2616005)(44832011)(5660300002)(66946007)(2906002)(83380400001)(6666004)(86362001)(6486002)(66476007)(66556008)(52116002)(6506007)(6512007)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1ZaU2RoQ0Z2eGEyaXNtU1poeitOZFRMNWkyY3ZFUkdXbnFqaVM5N2lDOVFE?=
 =?utf-8?B?VkJtTFJlckIzbUhYVVNkMjliQS9URWRzNDdWaFhlN01YZFJ1QVVKS29sMmVo?=
 =?utf-8?B?dlpQM2w5ODRvd29EM1FwQnVQWE5hZWZxeWpSK0xZYm5JdkxuZEZCV2hLUXRn?=
 =?utf-8?B?d3UxekpJajc3MEV1YTM4dXoxT1E4VVU1L1p6alp0YzBKTGExN1NHNDVBeHBQ?=
 =?utf-8?B?RmJLbkpSTHBYajNQdXplL1lEaUJTQ2hlRXllNE9lUTMrb2srSFE4Wkx4aGlF?=
 =?utf-8?B?S0xvRUM0Tk1ENHRZVmZCbFlyQnN1YWlxaVlCZThQWjVkVUx3MWZPN2FpOU5v?=
 =?utf-8?B?QStLMkRDTFdTdk0zN1dRSThvMnVaZDFUc1RnM2E0c0dJWjcyUjVveSt0dGUr?=
 =?utf-8?B?MnlCWk1kYktvTGoxNEU2SitHN3pVc0hlVXdpSldPUXFBc2tiWkRucVhTaVJv?=
 =?utf-8?B?cEs2QlFtQnlXMjRRUkREMDRuVDZxSU9yUytvZVFQTW9OVTdHUjh5Z1RFTkt1?=
 =?utf-8?B?VEZCRHZMNER2blBwYlFZdzZiVGRVWUpGWSsxMVE5aWxLOEtlZ09KckMrbUcx?=
 =?utf-8?B?NDJDdkR0ekxucVJiMmVURGdOd3IyQ2R3dkY4K2JQQUx1Wm5CajlGSlVLL2kv?=
 =?utf-8?B?ekF0SnRaRmFZK2ZsVGpFa0ZjM3R4UEVtZktwMFlxTFJzQTMzQlFwb0h3MTRC?=
 =?utf-8?B?NVpZblhvTFozUDBNWm1nUEpjclo2K3hLa1YrMUlnL0VPMFFnZEhIOXhNYkF5?=
 =?utf-8?B?cWhYeHhSd0NnWmRhUGZwTTgzTWptUit6aHJ3SWFBa0xaTHVhSXNsa3dUWFhi?=
 =?utf-8?B?TGZoeC83Qi9mQXpBOHdseHBjVmZoMm1iNkY2cnZGSFRGR3JCaExpbGpxTGpv?=
 =?utf-8?B?cjR6bDE2YnhJSUhWS0IwaHhJblhYTVg2SFU4bzkvbXVmQWozMzIyMjZYUDNP?=
 =?utf-8?B?bWVaTHVINmJjd3VEN0VVTmE2TjZtU0E3NHVRRGFLYWQ4bjVLczFjNE4vcHZi?=
 =?utf-8?B?QWoyZnJRejhUNm90RHhwQlJuTGp2U21hZDVQK3hkYkFScTUvMnRMdlBBZEFK?=
 =?utf-8?B?SWh6TUdlaTdKNUdVRnczYUorU2pCK21ubXBjNnprWmdJTThHVnhnRDdCZGph?=
 =?utf-8?B?T0RrdXNDT3h1cVczbDVWWHBTUm1Zb1RhMFpBNlhGb0JHellmSjU2NlJSUW9h?=
 =?utf-8?B?T2JFaWE4QU9QZDJLdWM1TDk2K3JYMHBxYTEyRmZnTk5lbWZGUUxPaHloOFRr?=
 =?utf-8?B?Z2VwVkFpWUJBSm11Y2hKZ2dMbmdKS2RvTTVjaEVvYWpsSG81WldsQmhNci9v?=
 =?utf-8?B?RWptNTNZWDlxQzBYRXdqSHV5YjR1RkNjczJrRlBNdFVIbkZDR1FvTFJOd05I?=
 =?utf-8?B?eFRETTI3TzBybVhLRTNrSXlYL1UyOFhPcHdPRlh2QTNRc05HM09jSHpQS1Fs?=
 =?utf-8?B?bHhiYzMvL1hBRzVQRGpnaTBUT0kzSlRMQk1KMnVtQnBESlVvaitmK2xtaDVk?=
 =?utf-8?B?bGVKRm8xQkJlYXlKOHJnRy9Jb2lzckdUcjdqN3hDT2tLcDdXUlBQVVlDc0pJ?=
 =?utf-8?B?cGR6ckhaUmJkL0ZOZlZUOUdydkdBN1VsOUNzVmM2RjZvZVhmdTVZUHRURUJl?=
 =?utf-8?B?NHNuTHVaMTZBVlI0L0Q5OUZpZ3lMUnh0c0IzUk05WVVLV29lMFhRUkdlSTZn?=
 =?utf-8?B?OVVuRFhaMTBwYmkwS2dhVUhsTytOdWVNcFZCN0YwMmYrWmRXU1plejRRRzA0?=
 =?utf-8?Q?llzYEqaz/7hezR1WRfT9ou0+O24dTDwlJhUJ2Mn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7851802c-2c36-4c9e-fcb6-08d965db4114
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 02:11:01.4972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLf/O6WVI2nF/VGufKN33KIRPbi0haXa49YEJuksiFwjFzoyqAltP8kOtWa99N4NOfwEXBvEJmUcNx6PSLEgtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
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

