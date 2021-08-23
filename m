Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04903F52D3
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhHWVYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:24:17 -0400
Received: from mail-eopbgr30042.outbound.protection.outlook.com ([40.107.3.42]:5229
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232710AbhHWVYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 17:24:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EISrQn2smrs/9G8s1BzJJaaV+BRBfD7nXTFoKFdCgj/bmNGHdqlxohNLJeGJ1yupJRwZ37eWu2NxVWEgtL2SmrRYVMEvEJQS/1D/I/2C4lReMW5w8jnjIkCtvLFeG2SQsnAPCiXHDElqUI+IoY7ALOgKXBLJrtCaMFFK73SXTN1l0jDPyuU2ZXiovLMIfvueLpJvDGNbzjl5ESTI8yFZVfx6pxsu8qYMv1VuCohee1+kid8kc0CfujcjcaUdVJSPJnvhZf/2GoPqHAySAF110d7tkdIYiIKHBhz1+3ojZjbGwYUgaRG22ENWwl82fmriSF/5mJn2aOtL2HFtPhG85g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DCzFl+wsIOkdp1E7x0r6M7ukSr4/Zdk7L146xJ6ZIA=;
 b=VcyX57uzeK/giZG39tcadMlfMg70UaI6p6sPWs23tU5xF2hBFl1F0yliXL7FcUah1+zXHDwoebAydHh5zDAasxBRYXHiIPLTqTmo8qMkCvnfDXSBLQLik9YjdK2GtvAGezD7jUw0Ket2ErKrnjxG9A8Jkwi7eCnGSRVfFOtNPQobS+hL5PqGqU2G8/7i6dGzxtazLaWR8oOEEriv/0ovI8I9lbPMYoazqZnY+NIB6cSUNgzkq1Za+NzOFoXnqAi7yE/MQy5Ff9P0NbmLMPkXAq7XeMlzwAjAmtJdbWxHTXrt01m8lr+VUdtDhCWHW96PeLuIPYm/QQXBCPE+IKY52w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DCzFl+wsIOkdp1E7x0r6M7ukSr4/Zdk7L146xJ6ZIA=;
 b=m+vzD4FyVzfYr0+qyg3oikhl8LDtIgCeKkTdi3GIBf1JW/EBURAKaTzPgs7RAxW0SD1fKmW/l5GWVTiY4jqccqfnZmJq/zidRT6WEDs1pGr3kMNHAjK9VsuxY/NBDA6YRZkpnsLK1ThRjqBP+QrmVSwhjGzS20PkZzwJ9b1Jj3U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2685.eurprd04.prod.outlook.com (2603:10a6:800:58::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 21:23:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Mon, 23 Aug 2021
 21:23:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next 3/4] net: dsa: don't advertise 'rx-vlan-filter' when not needed
Date:   Tue, 24 Aug 2021 00:22:57 +0300
Message-Id: <20210823212258.3190699-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM3PR05CA0150.eurprd05.prod.outlook.com (2603:10a6:207:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Mon, 23 Aug 2021 21:23:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cd2cdc1-77d7-4f9d-d936-08d9667c3887
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2685:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2685CE4693635C0E1D3634FEE0C49@VI1PR0401MB2685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DTVzPXD7dR6/93dpTqJzOflkWNQyz9d4LDGKtsbf3ja1lncoJwvjJqCV1HgjJbI/4sZQykYcRhsxV2efYcA1NykbAUeDRj458k/U81b07BcHQJxOBB+pqhCSEncWcgCLUw5yANmXuT8L0fxOnB+gF1DHg8lN3TJAyu2l9HczeRcBgzWA7v6q44e2ErF2AG6wX9XYJmI22sGQFvZrhXU72N4iWA7baU/KQKg3jbJ/oIqhf8eh73+ixupoD4iXsoUy52fOxyab5sSPkmhyIM8APCcFkzMEeLA9dwhB66thYtKfafAiUDDJAOmK6THyXk6EO2S6bVIkamaN2rpVNFgZT7uU4D9Wi/HCgtNNfZMGB45Xk64x6bL2qHQKxHIty/PxGoHBmDHixy3glDO0oMthw9uQetRRrLv2jnRi4L+hufIJPcy0eGGRdZPx9/mkQxKE04+ScIYp4698OWdLlre9xupmm+vJpzRB4kyWaHca+HJWAOwG24No0qa9+XgLCHqz5NpcqQ/9E3ZhvCPCHGi/f5XXCf2XP5Y5ZKKT3xl83RLK1Bal2O6T9YkqJf+trYSRovk8C0tXGyTXQOrByYuK9+FFipjjUCpvDUK8Xb7+lYMTmkQlMQppHmegluaEQ577reBGEFv2QQA34LaO2+IabuQuA7rswOuD2LxYqm/Aa0UdIOjMjobLsBQzlcgaqLqRRvTW3Fh3jOgi1TSeMjgsOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(366004)(346002)(396003)(136003)(86362001)(66476007)(66946007)(66556008)(316002)(6916009)(54906003)(478600001)(83380400001)(66574015)(38100700002)(2906002)(38350700002)(186003)(36756003)(5660300002)(1076003)(6512007)(8936002)(6506007)(2616005)(956004)(6666004)(4326008)(44832011)(52116002)(6486002)(26005)(8676002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3hMZzQ4TmoyQURvMFFSbGFBTEVGS0s4WVY1SCtjd2dza29lcHVDenAvdGsz?=
 =?utf-8?B?bEZtMjB2eUViV3VsN1d4OFRoMlQyaTRxRUprSHhPYThZVEVQSUR6N2lxWm1i?=
 =?utf-8?B?bDZqRFp1S3dLZWJ2dDZXb0JTb2JXRGt2VUNZZ0FwWEdLRU1acE51ZU5TUzZP?=
 =?utf-8?B?MkpyejRtTktRV0RKUG5VMENuYUxFK2dGcldqVktqRU5qbWNuYzZYcHlFOUhi?=
 =?utf-8?B?SWdqZGVhYndkZStvOXFaUDJTSHJrc3FiWjNTZFR2Z28zSHU3MjdKRkg2dWg4?=
 =?utf-8?B?QXVOVDZpckhPMVRQN2RoeWF0VmE1d0k5dE5oa2ZuNDNuQWRhbFFjZk4wMENI?=
 =?utf-8?B?VEJEdkF6c3VmcU5BNWRGTnhzeWdudDJhbHRMV011YWVaazlSYWhyVFhVRnh1?=
 =?utf-8?B?WmUrejZtZWFtQkFEZ3BRMkZENTE2OGtxSlBWYkFNZU13OVQ3cVh4dEg2TGls?=
 =?utf-8?B?U25XTjRxN0hhVnpyaEdxdGJZOGFyeDJJVUZHZGJLVlBsVU9aeUoxQUo5S3Yy?=
 =?utf-8?B?d1RNUE1ENWM3Ynh6YTFQR1JzL09iSDZ1N0srdTd4TmpOOVZvcUsyMW5VNG02?=
 =?utf-8?B?bTY2Mjg0Ullucnl1QTJJWXFsUmpwOGVhclYvT2pJSWJtSWlTT0ZLUEJ2Wmc1?=
 =?utf-8?B?MkN0eFFZK1JvU09lU2ZLRkRLS0EyVXFheXVBV2gySXJsQjNBaGkyNVpqRnpC?=
 =?utf-8?B?NGV4MDNQK1BFRitCeUUyT3dJSkI3Y0IyWE9qbkRVUS8wSEtCclQrU2liWGpn?=
 =?utf-8?B?ZnZsZnRUWVM2YzhYbVVoZHE0ekJhNkdIbDF0VUtGTkNRSENPS05PeEMyTzFN?=
 =?utf-8?B?VnBTbzBsd1ZlQ3NxTk55ZEN0L2c3c1UyMnBBRytxcll5dnJwUDljWTI1U0pH?=
 =?utf-8?B?L1daVEJ2RkM5aUxXVU1YUUpBVDRsNFlCQWNQR1dNSFVUbWxuMjZFWU4wVmhI?=
 =?utf-8?B?N096TVI4T21DYVdEc0dkdjIxbDJkUEVyT3lEMUIzL2Y0R3A4ZEx0ZlhXS01E?=
 =?utf-8?B?MDlsTkE2Tzg2cWRGdzhUOEJGY3pwY0UzWms0OXJqYlE2ODd6dGdNOTdqMzFj?=
 =?utf-8?B?eHdxd2MxMUxOSC9rWmFWSXNCU2w3MGYzc3dtY0YrWFZnK2xHUVIxOTZ3MTJ5?=
 =?utf-8?B?WGZWcG9XWm1zSjZURExLVEFsd0hJWXZlemRuNWdPZVNmS2FDaEZTR243RG04?=
 =?utf-8?B?YjZ6TDEyNlIzYmlPYWMvNlpjMk54eUJ3d2t4MzZqemFqcXQ0YzIwSFA4U0Jq?=
 =?utf-8?B?alBTcnB5ZU5EcUtwZFhzLzVOaUJuN0xlWnFLWWI5dWNxNUJLNkYwamIwbFJC?=
 =?utf-8?B?ZStncEltc0NvY1pPWGorT3FOYXM3MVE0bzRXUlhUL2lMNzkwS3o4Zm9yc1BE?=
 =?utf-8?B?ZmVaK2xqL2pscUZNZnd0YWtwNGJRR1JHdnFUV3Z4TnNNNTI1MGJ2RENyUkNU?=
 =?utf-8?B?UGJ3Q3YrQktHZHE2SDNCRWx6VWxBSTF5dW15ZnliQWFzVzVQQktpV3VGRGpx?=
 =?utf-8?B?RmFFWDlpcTJBZk0vT0p4MDJxYllTc1laMFdFMTQ3VGlRQVc1K1FlUFVaOFd3?=
 =?utf-8?B?MkdBQ1oxV2QzZTF6dFo0NmkxME5iWjhVNFpJUDBuTzlrcG5ZN1Y1N29qdzc4?=
 =?utf-8?B?QTc5UmhkaUlFUFJjRUxtSmZmU0tVSTMwYVczQ2twT3BUdkRvdlpEd1A0bTht?=
 =?utf-8?B?REZEejlkNkE0MVg0Sm1WMkxNUy8yOW9LUkd0dVA4WEpKOVRtZEU3UlVFZlpl?=
 =?utf-8?Q?tXohdFAoaA0G/ehieXqsIWemwOh0Bh8Qh9IGYDY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd2cdc1-77d7-4f9d-d936-08d9667c3887
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 21:23:16.1989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 34nikoQ95rcLrQVASPygA/S9Be20JivygmQERh+kh107puqzR4VqM3Z2JgL9wO8rb4mkIG0DqQF6fuok6hzaaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There have been multiple independent reports about
dsa_slave_vlan_rx_add_vid being called (and consequently calling the
drivers' .port_vlan_add) when it isn't needed, and sometimes (not
always) causing problems in the process.

Case 1:
mv88e6xxx_port_vlan_prepare is stubborn and only accepts VLANs on
bridged ports. That is understandably so, because standalone mv88e6xxx
ports are VLAN-unaware, and VTU entries are said to be a scarce
resource.

Otherwise said, the following fails lamentably on mv88e6xxx:

ip link add br0 type bridge vlan_filtering 1
ip link set lan3 master br0
ip link add link lan10 name lan10.1 type vlan id 1
[485256.724147] mv88e6085 d0032004.mdio-mii:12: p10: hw VLAN 1 already used by port 3 in br0
RTNETLINK answers: Operation not supported

This has become a worse issue since commit 9b236d2a69da ("net: dsa:
Advertise the VLAN offload netdev ability only if switch supports it").
Up to that point, the driver was returning -EOPNOTSUPP and DSA was
reconverting that error to 0, making the 8021q upper think all is ok
(but obviously the error message was there even prior to this change).
After that change the -EOPNOTSUPP is propagated to vlan_vid_add, and it
is a hard error.

Case 2:
Ports that don't offload the Linux bridge (have a dp->bridge_dev = NULL
because they don't implement .port_bridge_{join,leave}). Understandably,
a standalone port should not offload VLANs either, it should remain VLAN
unaware and any VLAN should be a software VLAN (as long as the hardware
is not quirky, that is).

In fact, dsa_slave_port_obj_add does do the right thing and rejects
switchdev VLAN objects coming from the bridge when that bridge is not
offloaded:

	case SWITCHDEV_OBJ_ID_PORT_VLAN:
		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
			return -EOPNOTSUPP;

		err = dsa_slave_vlan_add(dev, obj, extack);

But it seems that the bridge is able to trick us. The __vlan_vid_add
from br_vlan.c has:

	/* Try switchdev op first. In case it is not supported, fallback to
	 * 8021q add.
	 */
	err = br_switchdev_port_vlan_add(dev, v->vid, flags, extack);
	if (err == -EOPNOTSUPP)
		return vlan_vid_add(dev, br->vlan_proto, v->vid);

So it says "no, no, you need this VLAN in your life!". And we, naive as
we are, say "oh, this comes from the vlan_vid_add code path, it must be
an 8021q upper, sure, I'll take that". And we end up with that bridge
VLAN installed on our port anyway. But this time, it has the wrong flags:
if the bridge was trying to install VLAN 1 as a pvid/untagged VLAN,
failed via switchdev, retried via vlan_vid_add, we have this comment:

	/* This API only allows programming tagged, non-PVID VIDs */

So what we do makes absolutely no sense.

Backtracing a bit, we see the common pattern. We allow the network stack
to think that our standalone ports are VLAN-aware, but they aren't, for
the vast majority of switches. The quirky ones should not dictate the
norm. The dsa_slave_vlan_rx_add_vid and dsa_slave_vlan_rx_kill_vid
methods exist for drivers that need the 'rx-vlan-filter: on' feature in
ethtool -k, which can be due to any of the following reasons:

1. vlan_filtering_is_global = true, and some ports are under a
   VLAN-aware bridge while others are standalone, and the standalone
   ports would otherwise drop VLAN-tagged traffic. This is described in
   commit 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid
   implementation").

2. the ports that are under a VLAN-aware bridge should also set this
   feature, for 8021q uppers having a VID not claimed by the bridge.
   In this case, the driver will essentially not even know that the VID
   is coming from the 8021q layer and not the bridge.

3. Hellcreek. This driver needs it because in standalone mode, it uses
   unique VLANs per port to ensure separation. For separation of untagged
   traffic, it uses different PVIDs for each port, and for separation of
   VLAN-tagged traffic, it never accepts 8021q uppers with the same vid
   on two ports.

If a driver does not fall under any of the above 3 categories, there is
no reason why it should advertise the 'rx-vlan-filter' feature, therefore
no reason why it should offload the VLANs added through vlan_vid_add.

This commit fixes the problem by removing the 'rx-vlan-filter' feature
from the slave devices when they operate in standalone mode, and when
they offload a VLAN-unaware bridge.

The way it works is that vlan_vid_add will now stop its processing here:

vlan_add_rx_filter_info:
	if (!vlan_hw_filter_capable(dev, proto))
		return 0;

So the VLAN will still be saved in the interface's VLAN RX filtering
list, but because it does not declare VLAN filtering in its features,
the 8021q module will return zero without committing that VLAN to
hardware.

This gives the drivers what they want, since it keeps the 8021q VLANs
away from the VLAN table until VLAN awareness is enabled (point at which
the ports are no longer standalone, hence in the mv88e6xxx case, the
check in mv88e6xxx_port_vlan_prepare passes).

Since the issue predates the existence of the hellcreek driver, case 3
will be dealt with in a separate patch.

The main change that this patch makes is to no longer set
NETIF_F_HW_VLAN_CTAG_FILTER unconditionally, but toggle it dynamically
(for most switches, never).

The second part of the patch addresses an issue that the first part
introduces: because the 'rx-vlan-filter' feature is now dynamically
toggled, and our .ndo_vlan_rx_add_vid does not get called when
'rx-vlan-filter' is off, we need to avoid bugs such as the following by
replaying the VLANs from 8021q uppers every time we enable VLAN
filtering:

ip link add link lan0 name lan0.100 type vlan id 100
ip addr add 192.168.100.1/24 dev lan0.100
ping 192.168.100.2 # should work
ip link add br0 type bridge vlan_filtering 0
ip link set lan0 master br0
ping 192.168.100.2 # should still work
ip link set br0 type bridge vlan_filtering 1
ping 192.168.100.2 # should still work but doesn't

As reported by Florian, some drivers look at ds->vlan_filtering in
their .port_vlan_add() implementation. So this patch also makes sure
that ds->vlan_filtering is committed before calling the driver. This is
the reason why it is first committed, then restored on the failure path.

Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
Reported-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: remove the unused "ds" variable from dsa_slave_setup_tagger

 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 42 +++++++++++++++++++++++++--
 net/dsa/slave.c    | 72 ++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 111 insertions(+), 5 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 88aaf43b2da4..33ab7d7af9eb 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -320,6 +320,8 @@ int dsa_slave_register_notifier(void);
 void dsa_slave_unregister_notifier(void);
 void dsa_slave_setup_tagger(struct net_device *slave);
 int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
+int dsa_slave_manage_vlan_filtering(struct net_device *dev,
+				    bool vlan_filtering);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3b775d7adee2..616330a16d31 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -580,6 +580,7 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack)
 {
+	bool old_vlan_filtering = dsa_port_is_vlan_filtering(dp);
 	struct dsa_switch *ds = dp->ds;
 	bool apply;
 	int err;
@@ -605,12 +606,49 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 	if (err)
 		return err;
 
-	if (ds->vlan_filtering_is_global)
+	if (ds->vlan_filtering_is_global) {
+		int port;
+
 		ds->vlan_filtering = vlan_filtering;
-	else
+
+		for (port = 0; port < ds->num_ports; port++) {
+			struct net_device *slave;
+
+			if (!dsa_is_user_port(ds, port))
+				continue;
+
+			/* We might be called in the unbind path, so not
+			 * all slave devices might still be registered.
+			 */
+			slave = dsa_to_port(ds, port)->slave;
+			if (!slave)
+				continue;
+
+			err = dsa_slave_manage_vlan_filtering(slave,
+							      vlan_filtering);
+			if (err)
+				goto restore;
+		}
+	} else {
 		dp->vlan_filtering = vlan_filtering;
 
+		err = dsa_slave_manage_vlan_filtering(dp->slave,
+						      vlan_filtering);
+		if (err)
+			goto restore;
+	}
+
 	return 0;
+
+restore:
+	ds->ops->port_vlan_filtering(ds, dp->index, old_vlan_filtering, NULL);
+
+	if (ds->vlan_filtering_is_global)
+		ds->vlan_filtering = old_vlan_filtering;
+	else
+		dp->vlan_filtering = old_vlan_filtering;
+
+	return err;
 }
 
 /* This enforces legacy behavior for switch drivers which assume they can't
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f785d24fcf23..f71d31d3aab4 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1409,6 +1409,75 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	return 0;
 }
 
+static int dsa_slave_restore_vlan(struct net_device *vdev, int vid, void *arg)
+{
+	__be16 proto = vdev ? vlan_dev_vlan_proto(vdev) : htons(ETH_P_8021Q);
+
+	return dsa_slave_vlan_rx_add_vid(arg, proto, vid);
+}
+
+static int dsa_slave_clear_vlan(struct net_device *vdev, int vid, void *arg)
+{
+	__be16 proto = vdev ? vlan_dev_vlan_proto(vdev) : htons(ETH_P_8021Q);
+
+	return dsa_slave_vlan_rx_kill_vid(arg, proto, vid);
+}
+
+/* Keep the VLAN RX filtering list in sync with the hardware only if VLAN
+ * filtering is enabled. The baseline is that only ports that offload a
+ * VLAN-aware bridge are VLAN-aware, and standalone ports are VLAN-unaware,
+ * but there are exceptions for quirky hardware.
+ *
+ * If ds->vlan_filtering_is_global = true, then standalone ports which share
+ * the same switch with other ports that offload a VLAN-aware bridge are also
+ * inevitably VLAN-aware.
+ *
+ * To summarize, a DSA switch port offloads:
+ *
+ * - If standalone (this includes software bridge, software LAG):
+ *     - if ds->vlan_filtering_is_global = true AND there are bridges spanning
+ *       this switch chip which have vlan_filtering=1:
+ *         - the 8021q upper VLANs
+ *     - else (VLAN filtering is not global, or it is, but no port is under a
+ *       VLAN-aware bridge):
+ *         - no VLAN (any 8021q upper is a software VLAN)
+ *
+ * - If under a vlan_filtering=0 bridge which it offload:
+ *     - if ds->configure_vlan_while_not_filtering = true (default):
+ *         - the bridge VLANs. These VLANs are committed to hardware but inactive.
+ *     - else (deprecated):
+ *         - no VLAN. The bridge VLANs are not restored when VLAN awareness is
+ *           enabled, so this behavior is broken and discouraged.
+ *
+ * - If under a vlan_filtering=1 bridge which it offload:
+ *     - the bridge VLANs
+ *     - the 8021q upper VLANs
+ */
+int dsa_slave_manage_vlan_filtering(struct net_device *slave,
+				    bool vlan_filtering)
+{
+	int err;
+
+	if (vlan_filtering) {
+		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+
+		err = vlan_for_each(slave, dsa_slave_restore_vlan, slave);
+		if (err) {
+			vlan_for_each(slave, dsa_slave_clear_vlan, slave);
+			slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+			return err;
+		}
+	} else {
+		err = vlan_for_each(slave, dsa_slave_clear_vlan, slave);
+		if (err)
+			return err;
+
+		slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	}
+
+	return 0;
+}
+
 struct dsa_hw_port {
 	struct list_head list;
 	struct net_device *dev;
@@ -1802,7 +1871,6 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 	struct dsa_slave_priv *p = netdev_priv(slave);
 	const struct dsa_port *cpu_dp = dp->cpu_dp;
 	struct net_device *master = cpu_dp->master;
-	const struct dsa_switch *ds = dp->ds;
 
 	slave->needed_headroom = cpu_dp->tag_ops->needed_headroom;
 	slave->needed_tailroom = cpu_dp->tag_ops->needed_tailroom;
@@ -1816,8 +1884,6 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 	p->xmit = cpu_dp->tag_ops->xmit;
 
 	slave->features = master->vlan_features | NETIF_F_HW_TC;
-	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
-		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	slave->hw_features |= NETIF_F_HW_TC;
 	slave->features |= NETIF_F_LLTX;
 	if (slave->needed_tailroom)
-- 
2.25.1

