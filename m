Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB0A421B01
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 02:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhJEASG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 20:18:06 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:30119
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229876AbhJEASC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 20:18:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVB1bDXCZ9MFMnqYYnO4xmUsPRPUbxwSUehAX99huvlT6LuJMoNdyEISxnczwQ/jCPzVpEBGBGHEyo53ygkbBIGu0VrfagHIeaxFhWSZ790E4PjUwmVFx9PDKtPnGtzANMQbutsy7/IbxqhrOeI67mMOf0MIicPpTnuMQqceO5jTkjltkFVnXpF0r2DclEfQtCx5DQgZ0EDcta56F8IL4h1JCdaUAu5xIxLx9tcXqgSPJ/G4mc+Tw82z4nW3PLvw9SO5fl8RhkkihRpsjjysQO+rL8iiSyhof6lHT3pFRilDH/aGL0R0OECt5eYvO9e9C5zezU7cnyC8D+r/vkAPmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlHa4CxsQ5whcSTVpmyew8qsLJseskUQ5lidl1H/YA0=;
 b=iaKTz94Ntu8ARHQBc8dRPT/N7u3oLLQyzghVTffAIe+6FkFuThSXpV2V6oZhHYLNM6MGOkbFjah/+3Dx6xeN4q6lpuzgiGWMyNHdy4sU9RtGIX71jMYMgK9EQ08UvYfnTf2PC6C4Ap2mjin8UZ7WNlIXzdDe057YTUAE/g3SFusXm8pyfIx3Xq0PfufuW5oE901MMutVg7VzPUR7vnMMK8TTydrIdZrFH0dyK9/qE292ffvmP24L4/CGoS5V86sdLqFplYyDRk+cUigQuWupf6/i1h55z0wFGDDzw7DcxVDpXboraY+3KPClSlIq/E6grF/sdBAvRdqOMpeuWvqReg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlHa4CxsQ5whcSTVpmyew8qsLJseskUQ5lidl1H/YA0=;
 b=bjHOcznHgEqXjuPJJZAj/CqwcqzJtng8woMZdRJ89JE6427h+eTs5rE4yvd6sESOP9vI/S832eelNVfCfkmbxoiaUNUy5DSmhQ5lO9NNhncNEjmoYq7rDkURUllmp3uNyqEqj668qf4kVKXX3BJfaQhusMngzZZLhrCLngDfmqY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3615.eurprd04.prod.outlook.com (2603:10a6:803:9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 00:16:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 00:16:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v2 net 3/4] net: dsa: mv88e6xxx: keep the pvid at 0 when VLAN-unaware
Date:   Tue,  5 Oct 2021 03:14:13 +0300
Message-Id: <20211005001414.1234318-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005001414.1234318-1-vladimir.oltean@nxp.com>
References: <20211005001414.1234318-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0107.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM6P192CA0107.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 00:16:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d35a6ca-fa0f-4173-f02d-08d987955643
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3615:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3615AB478263D0170C5DE4DFE0AF9@VI1PR0402MB3615.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gdG6P3YKbO3xQ904KDsDgKdzLD6kfCavVq6FZshka8bEIMLXAkuOLuJxlEpr/zt2pCuF8/f5Gbav4Vwszz6W20ai6P/T4VW6+GtxrIuSkQVNEdTLZvkTW3Mqc/o1uo8jptuHKZFpO/J+1WQDTxGkY1KojJJnKrufnIuGrj/DTwZ+Gbe1UDlUR8XCEQsC5aJXaw95yhQEDRaYWuYL2oGNay5mklxid5d7odoRnAQVlsCrF4fknBhPLc8TYL6/7owODo0ZwhK5C7HbBivrKH2Et724rtlrnUftAXnqXwfCHe1jATpBCVMRP7uVBZU5vT6UbOqq1g8VW1h8Co73W+cSMhTiSomOrv3at4ui6mvQ9AAQelIoufkr8TH9Vdeh1gtyFCQi9F2fJBysc6RWfrY23G35Et4Ix55dxOYOrY5HcGDx5MpHeaWCVu8zcj6yoHRd3p0HLKqat3JBq2zaYqxT4/1Ztolp0QkOLxRAZn5c648p+b73H+DI1G+LIWJcOtnkMuk+3vNhq7tlJMe6zMinR0TlDtcBqBYaPfOFfdEXIDvyQsGbJvuvYywuSaQ/vvpYVojz+zU2QS6Mki4jpMAGr7yNjFVnWcNDe9sUhiM7c0Es42VCcoVuv+AYeyqvq82Sat12nwE6QBaj2Rfeu3m73iz8zGW/S/WAuoz91fI+5T6e8GuCek69Gryh8GdQe4ohCJBghp7EK+N7MKlpXH2AQsym0zdIsTYsnW/L/23Nr9vcOBJmdiWiIJ2y+YoO5lDJJrnv6WuCI5a82tvMvVZ9wN3R7n7YFxfoWrQqm8fDtQU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(38350700002)(110136005)(316002)(8936002)(4326008)(54906003)(83380400001)(956004)(2616005)(26005)(5660300002)(6486002)(8676002)(6512007)(66556008)(966005)(52116002)(66476007)(186003)(66946007)(1076003)(508600001)(44832011)(38100700002)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tej+BCV4X9OEo2Q6aYvzfcIILNYMKDAwkT7YOk3p+Z3Z+FBPMIRbAegqrQiz?=
 =?us-ascii?Q?wLczslVRsAEDCOMKFd1Wfr6r4b11SFvv+Emnj57kX4/MPfksA79gtwcbEO5R?=
 =?us-ascii?Q?QAOae6wnc92QcHNYtafhCIS83SSzlNMuOVYurX/gdCJISg+jbmVcinIOuC14?=
 =?us-ascii?Q?SQJbUuq1pTUhyNAQxjC1wv5Kyepmg38TzIRG8HWdwNpD3iaZs0iRHPkUyWnm?=
 =?us-ascii?Q?lzSxKSnRIMrcSUEVJqR+FpS3SHOMEOW4w6ovmkKD+Fc0sYmh4sVVS51lzzIk?=
 =?us-ascii?Q?0xQcjSpmT+V8GVEkBnoBue5eBBqbaX0YlXuOSPGl5nmZWDR6kS3Z5+cdymKP?=
 =?us-ascii?Q?zyqbjb2oCZZPMhmW9LseAzdwEEpoot8uGbQ0TYmaxsLSCzNZr81/6tL/XL76?=
 =?us-ascii?Q?jiOME+8SBqRDnm1mazlqI3LkI8oTdRA9LDrIQ0Ir4xjES6azE0MlWCwoRvwD?=
 =?us-ascii?Q?oy39c4e/l5euT4EI+K8mAsVwQaqA1ZuiT3TY13TW6C947PuiGGIl/1P0DKSm?=
 =?us-ascii?Q?TZP9DmYwQYwCSAm4qt749H3hov6Ef0Ei/HKK+VZ/S4d6LtAOhp3d0R9/FZpS?=
 =?us-ascii?Q?GLEnl62vjOyjgkd0rIC0RVCBStNClWy8vs4i0qv++/8/py2N8HkZJtK4YXOk?=
 =?us-ascii?Q?ycIYaLTSqUveliHjPWeaBmONYrzEFwL4zJaxi8SiNmRQfbnUFpq57xJEftYy?=
 =?us-ascii?Q?ySZFgc73kxzAUNolUipw7ZIjJQ5u+KZVospBp5jZXDH1YheU118WrhBbpnFi?=
 =?us-ascii?Q?5ppASKnY2POd0pkSXp5taIrz6arFM6pAXgnSEHeiod819sYNcQGiOAZXQED/?=
 =?us-ascii?Q?NYIsTxBolbC/kuRv+m1kMDA+eaYIpRTGpXvf+95xIrHs4E5dOYCaxjyc7v01?=
 =?us-ascii?Q?py3W47j5yR4XPbYu7i2vfSWq1UqcUzUMRCojSK+IK+aveUo+GezaQF+uGKvw?=
 =?us-ascii?Q?3R2fLu54jsnU6ZXjN3Q0VXv3OoO7ze1XPlVHpI0s18tT+spm2pyVD/Md8bbb?=
 =?us-ascii?Q?boQvETBgSumpt0kyiUFVK2YcXOgnOAA2cHPl8p06I+sjXBxOPg9wmtq5n67K?=
 =?us-ascii?Q?O3a/1EZPC+miN/rMCIIHNq8LNRHPxF1zDcanSL/WBBte9f5Mh5OWPK0bh34Y?=
 =?us-ascii?Q?neqJjgUHNWBAdojIEENfdA2Wk0eHt/LpIvTHoobz3DuM5lphFAp788rqZT0f?=
 =?us-ascii?Q?26TNU8ksyyxu6b3wrKoZWMRdfg+1xFa3TtdnMkXEuwspkDLUe/tdT7nX7Dr4?=
 =?us-ascii?Q?OZ3ls0RGd9GPmdciiZaTuq464ImfnrFXMjkAZoe+TA7GdR/k/jIw22ktC+wm?=
 =?us-ascii?Q?KWQecFseb2Fsw0LixJDGj4w+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d35a6ca-fa0f-4173-f02d-08d987955643
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 00:16:11.9104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6rYz4KjIEOx8sK0oWFKLhpikSfVvwatZkce1vu2OHivMRE+bx3zHFdjoqZBaO/MdPrcpsfE5zg912PiWIwR2BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3615
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VLAN support in mv88e6xxx has a loaded history. Commit 2ea7a679ca2a
("net: dsa: Don't add vlans when vlan filtering is disabled") noticed
some issues with VLAN and decided the best way to deal with them was to
make the DSA core ignore VLANs added by the bridge while VLAN awareness
is turned off. Those issues were never explained, just presented as
"at least one corner case".

That approach had problems of its own, presented by
commit 54a0ed0df496 ("net: dsa: provide an option for drivers to always
receive bridge VLANs") for the DSA core, followed by
commit 1fb74191988f ("net: dsa: mv88e6xxx: fix vlan setup") which
applied ds->configure_vlan_while_not_filtering = true for mv88e6xxx in
particular.

We still don't know what corner case Andrew saw when he wrote
commit 2ea7a679ca2a ("net: dsa: Don't add vlans when vlan filtering is
disabled"), but Tobias now reports that when we use TX forwarding
offload, pinging an external station from the bridge device is broken if
the front-facing DSA user port has flooding turned off. The full
description is in the link below, but for short, when a mv88e6xxx port
is under a VLAN-unaware bridge, it inherits that bridge's pvid.
So packets ingressing a user port will be classified to e.g. VID 1
(assuming that value for the bridge_default_pvid), whereas when
tag_dsa.c xmits towards a user port, it always sends packets using a VID
of 0 if that port is standalone or under a VLAN-unaware bridge - or at
least it did so prior to commit d82f8ab0d874 ("net: dsa: tag_dsa:
offload the bridge forwarding process").

In any case, when there is a conversation between the CPU and a station
connected to a user port, the station's MAC address is learned in VID 1
but the CPU tries to transmit through VID 0. The packets reach the
intended station, but via flooding and not by virtue of matching the
existing ATU entry.

DSA has established (and enforced in other drivers: sja1105, felix,
mt7530) that a VLAN-unaware port should use a private pvid, and not
inherit the one from the bridge. The bridge's pvid should only be
inherited when that bridge is VLAN-aware, so all state transitions need
to be handled. On the other hand, all bridge VLANs should sit in the VTU
starting with the moment when the bridge offloads them via switchdev,
they are just not used.

This solves the problem that Tobias sees because packets ingressing on
VLAN-unaware user ports now get classified to VID 0, which is also the
VID used by tag_dsa.c on xmit.

Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process")
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20211003222312.284175-2-vladimir.oltean@nxp.com/#24491503
Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/dsa/mv88e6xxx/chip.c | 53 ++++++++++++++++++++++++++++----
 drivers/net/dsa/mv88e6xxx/chip.h |  6 ++++
 drivers/net/dsa/mv88e6xxx/port.c | 21 +++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  2 ++
 4 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 03744d1c43fc..d672112afffd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1677,6 +1677,26 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int mv88e6xxx_port_commit_pvid(struct mv88e6xxx_chip *chip, int port)
+{
+	struct dsa_port *dp = dsa_to_port(chip->ds, port);
+	struct mv88e6xxx_port *p = &chip->ports[port];
+	bool drop_untagged = false;
+	u16 pvid = 0;
+	int err;
+
+	if (dp->bridge_dev && br_vlan_enabled(dp->bridge_dev)) {
+		pvid = p->bridge_pvid.vid;
+		drop_untagged = !p->bridge_pvid.valid;
+	}
+
+	err = mv88e6xxx_port_set_pvid(chip, port, pvid);
+	if (err)
+		return err;
+
+	return mv88e6xxx_port_drop_untagged(chip, port, drop_untagged);
+}
+
 static int mv88e6xxx_port_vlan_filtering(struct dsa_switch *ds, int port,
 					 bool vlan_filtering,
 					 struct netlink_ext_ack *extack)
@@ -1690,7 +1710,16 @@ static int mv88e6xxx_port_vlan_filtering(struct dsa_switch *ds, int port,
 		return -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
+
 	err = mv88e6xxx_port_set_8021q_mode(chip, port, mode);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_port_commit_pvid(chip, port);
+	if (err)
+		goto unlock;
+
+unlock:
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -2123,6 +2152,7 @@ static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	struct mv88e6xxx_port *p = &chip->ports[port];
 	bool warn;
 	u8 member;
 	int err;
@@ -2156,13 +2186,21 @@ static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	}
 
 	if (pvid) {
-		err = mv88e6xxx_port_set_pvid(chip, port, vlan->vid);
-		if (err) {
-			dev_err(ds->dev, "p%d: failed to set PVID %d\n",
-				port, vlan->vid);
+		p->bridge_pvid.vid = vlan->vid;
+		p->bridge_pvid.valid = true;
+
+		err = mv88e6xxx_port_commit_pvid(chip, port);
+		if (err)
+			goto out;
+	} else if (vlan->vid && p->bridge_pvid.vid == vlan->vid) {
+		/* The old pvid was reinstalled as a non-pvid VLAN */
+		p->bridge_pvid.valid = false;
+
+		err = mv88e6xxx_port_commit_pvid(chip, port);
+		if (err)
 			goto out;
-		}
 	}
+
 out:
 	mv88e6xxx_reg_unlock(chip);
 
@@ -2212,6 +2250,7 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 				   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_port *p = &chip->ports[port];
 	int err = 0;
 	u16 pvid;
 
@@ -2229,7 +2268,9 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 		goto unlock;
 
 	if (vlan->vid == pvid) {
-		err = mv88e6xxx_port_set_pvid(chip, port, 0);
+		p->bridge_pvid.valid = false;
+
+		err = mv88e6xxx_port_commit_pvid(chip, port);
 		if (err)
 			goto unlock;
 	}
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 59f316cc8583..33d067e8396d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -246,9 +246,15 @@ struct mv88e6xxx_policy {
 	u16 vid;
 };
 
+struct mv88e6xxx_vlan {
+	u16	vid;
+	bool	valid;
+};
+
 struct mv88e6xxx_port {
 	struct mv88e6xxx_chip *chip;
 	int port;
+	struct mv88e6xxx_vlan bridge_pvid;
 	u64 serdes_stats[2];
 	u64 atu_member_violation;
 	u64 atu_miss_violation;
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 451028c57af8..d9817b20ea64 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1257,6 +1257,27 @@ int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,
 	return 0;
 }
 
+int mv88e6xxx_port_drop_untagged(struct mv88e6xxx_chip *chip, int port,
+				 bool drop_untagged)
+{
+	u16 old, new;
+	int err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &old);
+	if (err)
+		return err;
+
+	if (drop_untagged)
+		new = old | MV88E6XXX_PORT_CTL2_DISCARD_UNTAGGED;
+	else
+		new = old & ~MV88E6XXX_PORT_CTL2_DISCARD_UNTAGGED;
+
+	if (new == old)
+		return 0;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, new);
+}
+
 int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port)
 {
 	u16 reg;
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index b10e5aebacf6..03382b66f800 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -423,6 +423,8 @@ int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			      phy_interface_t mode);
 int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
 int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
+int mv88e6xxx_port_drop_untagged(struct mv88e6xxx_chip *chip, int port,
+				 bool drop_untagged);
 int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
 int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 				     int upstream_port);
-- 
2.25.1

