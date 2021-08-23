Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721003F500D
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 20:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhHWSDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 14:03:55 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:4129
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229627AbhHWSDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 14:03:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQ7FGa5hNnfYZYKTFIhRM+pk5lTvPgJZr2ZAQqh3wOz7jNssxsnm9vgmGzkh9qxwW/7i/VuWBHZ69RckWA8K/8rB+Hi/0XDjGayGgCEtxs64XUJkx6l2D7V7p99+Up506V4PoZj3go8fFm3RvgV/9j2aANgBPsHQ5PUG4ZJPOHsBK/pjjZ4iHyPt71042oVAWxbjTe0RjZ65tANobp25bZU2A/CK1mod+WsLJh+Pfy0IE60lLykjoFmjrawP1JGkjsKDPEHGf2b63wCuUd8A0Ty2khMo3VSYX2VtMiPap03dmyhDVJ4Ftef9NVwsFZ0cKj98GidBVBAh49pgvaCnPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLDIOpjAgw5NTLJoX+Bey0u/s88Yv33FAfVPbLe8EE0=;
 b=Y2JcvqVFJDbh39KgGcf5wnz51fz04r5M+9TipUhwcB2Sob+d3LHf7ts1EPOj7E7tG8Y7JloIuUY73fzl+eQ/KxnIHrbhlX1p4v7vnJOMf1SEWPqfrSwxhSkzAOiFfaJ4EoVuIW2WGD44tkBPFyLvuIl4F/hs+XJlijkl5ubJTKTeX9TjujlGdgprIdPSlxKRJFfTjlipU76s9Inh54pcethCG4EC892U/vx5qIO1z8tyao78JZM/Yzhbq8ewCxVgYmkga5mpoxZqwJ6XSXe8raKi/mwhsQQVfkfSF38GBUhzCHAuHkVgYtipv5CYyCDP5lllNUs1bqxbsCqm79qCew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLDIOpjAgw5NTLJoX+Bey0u/s88Yv33FAfVPbLe8EE0=;
 b=nGZGRbYIYkPXA/ajAMYHnhPatoh2oNMd6GNy2LtsUX3qvvnwbT0sEBBWA1XOLdvFpYB0XOw8AUwAMCfaZj/cIbBFRACe6p4koo4Q+vTiu7BddXuKAP2K+/gRHXWGkMY9hZZYpH/Hxgi5uFUEKhasX2QPjqpEwdzrvpQCKRBEhR0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.23; Mon, 23 Aug
 2021 18:03:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 18:03:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 2/3] net: dsa: don't advertise 'rx-vlan-filter' when not needed
Date:   Mon, 23 Aug 2021 21:02:41 +0300
Message-Id: <20210823180242.2842161-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM9P193CA0007.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 18:02:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a85115a7-c52d-4153-e290-08d966603e9f
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-Microsoft-Antispam-PRVS: <VE1PR04MB663977096999BA7BB82E9719E0C49@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G33z+Sragdgpy1AKK9iH5Z2gpts/0RKEMhWJPZuLlSMX6BJDMslG1TOWOOXWKFo22fTl88gW9ghOfT+7MIWrNYJ63Cir16TrWKHtxSeGhnmv8OJNAQkdCfi7KlgnhZPQxWsN+UbSQFCcBpMQGIbtHDZ+KFfqre4bqv/6VZP14XyOQZ/HaKmC5QHpw7dLbiK44NLwGaeJY6lO6kAgsfOZvJFVIl/p4DmXkmAyGoRdONHDj/+dms4rxx1dC4hqJLqyYIDfUPlNYRgCdqsoNh+qu7tbDz6CYnl8aHVkZYn5AMwsMSlA1J40VLdFk6SU1sjVYQusrVhX9409za5Z/+Lz5E8nG0vVZQxrvu4j4WCOHvwLIIIGRzYI2ZKUndaI5U/wqlWOzJC3CPCCS17j7Dvin6YgxghHEWsq6oJWizuRq61Vz5rhpJffwcqmpqmC43jHV6VrvoA/4Oqrszb2gUyEs9wbSH9gbia7SjYRuNjsXgwMW04BnQChnHa94fRHzZ/F+erafIYqx7zmBxCN9qAXtxwPLRwNiitlPW/Kex+pgF3dQo2eNkk+YxJ4ybVFrMv/YBGRCmXxI8mZsLgRStIB3T4Lrsq2GcwIOqinbu5DQW+SRkWzey54XcFpvFncd+WbX/mVZzCNMcYGJHNj9x4U+vv+xGE4D6RpsRkaRCs4a3GupcDbHXKNPvWQ3xulcNS0DBEu3UcXWFg9f1iKA/hbRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(376002)(136003)(396003)(36756003)(478600001)(1076003)(5660300002)(66476007)(6512007)(6916009)(30864003)(6506007)(86362001)(38100700002)(38350700002)(26005)(66556008)(66574015)(83380400001)(2906002)(2616005)(316002)(54906003)(4326008)(6666004)(186003)(52116002)(8676002)(66946007)(8936002)(6486002)(956004)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlVtbmw2RmMwWDVMSW9QNnRUbnBYb0MrbjF6clVWZDJrYlpXTVE1dC93SVVq?=
 =?utf-8?B?TEJ2U1A2NTJZc3Q2dWZwNjc0WmxsNkNPeVBtN1FqWFF1MnFXTDR6WGtFS2FP?=
 =?utf-8?B?ZGpFekFEa1RpZEpDTGpUWWZQYi9pVXpOT1V1MTBXMFB4YXNzWGcrYnVhOWNw?=
 =?utf-8?B?dlJubjdveEs1V1krTkJ2a3B1NURoTitJdExCaGs1b2E4UEZHQW5aMEFwazd1?=
 =?utf-8?B?bmMzSVpkOU1OcmhtZUJXTGUzcjlLMTUzSUoyUXBGc21EUTY3bm4wK1BURmFh?=
 =?utf-8?B?OW85R1o3d3N1V0RabG9LbUpvQ0MzRXBWWVpDUzlMa2l6R3hmeE04ZDFUNFFZ?=
 =?utf-8?B?UVgwZGlIeVdXN2YxbC84MU1kRW5wS1N1UVcyd092c1ppWmkvbzNKSVVRYWls?=
 =?utf-8?B?SGoxczh0ZC9pTksrb0dRQytpeXdTMTExUGRlcXBNVHgxOGpkMlE1d0VFTno3?=
 =?utf-8?B?QmtndDVLWEU5STFLS2JRSzlGTncrMmJ2eUhlSkZPUjFqNjIwMk05Y0ZvWEtx?=
 =?utf-8?B?UTAzOTQ2QS9jbjR3R0UxczFBOVBHZDBBbndqRGZqVzM0MmcvVXpYQmhaME5h?=
 =?utf-8?B?QTZpRlhEZmZ1UVB4R3JKdHVQVG1IQ2xodFEvWnpPRDMrUTRLMkNMWGxJSEpa?=
 =?utf-8?B?YjQ1OXR5dmdwdGNac056TE1SU2hHc0ZCbGpXV1pNcjkvc2ZnRno2OHNFTXdB?=
 =?utf-8?B?MUFaaW4wS3dqVUR3ZlNvejNYSWprVURQOW9ONWpua25IVDMyVG1xaTVkeWgw?=
 =?utf-8?B?S3dSVXZ5TnZpa2tSaVpJMDJoZlNlNlhKV2JFUnVocUFxb1g5N1o3ZUNFUW1v?=
 =?utf-8?B?TTUwdldjdzhncDcxaU9LRFh4OUhFZFBiV29EajkxZFZpR1Q1TFRBZlUwcnpD?=
 =?utf-8?B?M3NSZUFmZlRPU0NtQmo1a0RWcno1eWhNZm1BQ3lUd1FUcUdSUVdhQ0Z3YS9k?=
 =?utf-8?B?c3BRYVVFQlhNK0dHN0hBRmIzaGdUZER1aVJGWEFMTDJ0RFNJMEZKamhhL0ww?=
 =?utf-8?B?UXdodlBSVmp4SmRMVVowZlpMQmJtbjgwWHRYbWdQRkRBa0RGaENHRVpXMXFC?=
 =?utf-8?B?N1drWHRIUm5CQXIxWGFzQkUrMCtJZDg4aWNWS3BvcFkrU3BRMkJkMEJnTmZ3?=
 =?utf-8?B?eW51cnVCM0NEWVBuVDVLeWhYTGNxTzVkQ05BTFNhT3k1ekRobitUaXFuSk5M?=
 =?utf-8?B?K0RSVkkwT1BxZklWVDFYS3A0Y0pWbDVORysyWFgvSUxzRWg1WlBwVDJkdE5R?=
 =?utf-8?B?c2R6NzR1eVdVYjdSSXprNXZjcjcvWWlmMnB0UXhDS01vR2xCQUxybHpnTzhm?=
 =?utf-8?B?YXdUMm1rQmM4OFE2K04zN0NSM2IxNnJDSFk0RFpjWktFMXErTUNvcWUxSWN3?=
 =?utf-8?B?dHU5eG1hYXk3R2FySUdhMkptTFg5b2twaTJPMXVKUkxEVVlIM2ZQZXFxNmxp?=
 =?utf-8?B?Skhhd2kxaFM1WlY5NElmSE9DODlZQzlmTG5tU3FUTUNydEJqVHpEQWdaR21F?=
 =?utf-8?B?Wk4weDhrMlRCY2VneEM2QmhlOGtDNXVxUklOc2FHRndPd3pOOHJ5cXlKUXBF?=
 =?utf-8?B?cTFSYUhKWjNnc3laYnpGeTR1RVUvQzBsLyszZldoKzloODA1NnFjSThBMVZF?=
 =?utf-8?B?RU9pd1RuaGJ5Q1FHU29aQldHWlZzTW92MVllTW9tM0cvOUs2UVJrNDZJcnhT?=
 =?utf-8?B?NmxxM2FyUHgxZHZqREZsNVlaelJpTE5iUm5KM2tBSldoNkx5ZVd5WGo0R3lG?=
 =?utf-8?Q?qyTfISyPa6Kd1SU/2zKQdKw5KkB0WreLtK8wrHo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a85115a7-c52d-4153-e290-08d966603e9f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 18:03:00.5293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjQXA+rdZuR9fxKlep4QTzdBGk3apVYT7rBFopxl+dZh5bt/bQJOkDLQhGqhmBv21NzzeaJpC+1pPjNvP9Kvfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
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
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 42 +++++++++++++++++++++++++--
 net/dsa/slave.c    | 71 ++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 111 insertions(+), 4 deletions(-)

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
index 4fbe81ffb1ce..a70b135dd078 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -576,6 +576,7 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack)
 {
+	bool old_vlan_filtering = dsa_port_is_vlan_filtering(dp);
 	struct dsa_switch *ds = dp->ds;
 	bool apply;
 	int err;
@@ -601,12 +602,49 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
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
index f785d24fcf23..cabfe3f9b2c6 100644
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
@@ -1816,8 +1885,6 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 	p->xmit = cpu_dp->tag_ops->xmit;
 
 	slave->features = master->vlan_features | NETIF_F_HW_TC;
-	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
-		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	slave->hw_features |= NETIF_F_HW_TC;
 	slave->features |= NETIF_F_LLTX;
 	if (slave->needed_tailroom)
-- 
2.25.1

