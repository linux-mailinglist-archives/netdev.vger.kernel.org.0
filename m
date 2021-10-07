Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167EF425852
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242843AbhJGQta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:49:30 -0400
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:18693
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242844AbhJGQtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:49:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHI2wJFOkym/V0xil00/KDYAJiDDfZUtlF1EIx3vcI1CvdX/N4AJZkcAeURYfy4Pgtw37mTVtKWZCcsFizrujwGi0EbuMPTtbe1zNif7Cr83PwQ8co6A1iLHF7PL8WEvz71yG7MgiCuMd+XRIdDzFTc/3Wyxyx5CPLCatyGyCRESTaRW7gTBulA2yz4Tx8Gfm/0QAnqX3Cvi5GyazsUO6TMQBhM8ODbj2nN7Ka8KIb2qT6RO3j7654dZDOEpVyl8X/hQ/+JUL5fn7bhkcWO5Qv5Q8x2/FGzgPZe2+EUIvuKO8M/xokMW4OkFxH2XXdD3UAPc8iW7opMrFVIQQZr1Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQBC75XjeZr9oKZRdO5APZgsv4m+klLFlFXUNncftps=;
 b=FZ/jYMOD8jSnE/HEbSpyko9k8rk1JNgA0PZGQIwip2uQkhLKiaxOYGTuxVx/Ifnzu22usGmFfU9GvcV0LoIIXLzeUPjJX21tZ2tOa8RnewQTBA7bxanx3dQNbNi0PglDmZqr0GXSSc2M8Dqlv0wDApr1Y43ZrjyKMWq1f73hYeIc+4LGKIku9/sgHDxMQ79W64ElBCFub/Mpi5iOZQZo2prc+YWbN0lVxMD95faGhGNOtA3Y9KyZFDrTnPqTK6ZO4gqRAHFgrEDWcsM764Dm2i1qnO2fj1OVnu0RdQ00gVCz0K/DvFpA8dGpJIRlkQbdaVu8gsWelLwxAC/TwdRPlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQBC75XjeZr9oKZRdO5APZgsv4m+klLFlFXUNncftps=;
 b=LlP4o+5vZW2+1xUGxhoRnsVZYO1mI5AUBAMDt+nl7hY/4uXZvmiDJBNr7FwLmttfAWMA+Mb5z01LTJazxEs5ahiUxR3JtwKYKN9mMVzezqLY1VRoXPfliuMvQWcDVa71+1ERdHHHxZdU4/jS9W/eFZz9LCiSOO4szf0Qp2g7fG0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Thu, 7 Oct
 2021 16:47:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 16:47:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v3 net 3/4] net: dsa: mv88e6xxx: keep the pvid at 0 when VLAN-unaware
Date:   Thu,  7 Oct 2021 19:47:10 +0300
Message-Id: <20211007164711.2897238-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007164711.2897238-1-vladimir.oltean@nxp.com>
References: <20211007164711.2897238-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0105.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR08CA0105.eurprd08.prod.outlook.com (2603:10a6:800:d3::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 7 Oct 2021 16:47:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b205eaca-5fb2-41d7-0705-08d989b22580
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3549:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3549B3EDF2261036794AAC2BE0B19@VI1PR0402MB3549.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MozcDHBAseDWAc5paoqUmQYVo7OFj73tsGC1yrYZn8h8bRDEIOSYNsQ0YW67+yB0RLK39MYcEyLpdgGOTaCBGVnB7iy+aMlda17KApc5A80idolTDEaJ/8ZT6fS3FzgbYJbGXhBSlW65QenNH8mjTdjO0DMYgZ4LV4cJE1EH1FQNJ2EBLWlT9VVpKQWKTcwB/+aEiqmL6NW52UMHFhtllnUqswzEWUsFoTWpPUsfIEQ66ZWPNlkYNitg7xi2Jvy8stocjitrmIR1lMh6xkODoDS91RY5AK12IHX0T5lBX1JzYclAUYXBpJzkU4SuDNDK+ogn5CB+jLXzmvzxJxionxMlkWKzzM/Sd0GFog8wouxOzCmjNX9753QPBasbxE4BqNGp/8zyLxYf+3mlC3C9GmNkzICnCLTwbHv2LZqJytE7wWYGZh4LBW/PWh3i0IFuiFROawAbrlkn0hi1BhkPvjfu34lWzgV07Q0CEgD3jrBfHCquIWTEelR3/M91aBlfwuSgRio1jv/DfqkW1LaPDMN895U2YbuSZNR9Znvv+oVKuGnHdkz41NE87SSAITLvnJwJtRvb5AZXlnsk+uovgTc2IFaRb/RsCHelNs7/UhKovV18tB0IdqWN7oNqVTLqQDPHCxKJxsSkc/UDSgQNDvL8uSCN5FoooQhyttl/6eQFalEhICOol1TUaLEuY3BBoia0GBrxD8g0Y1V1kNrEtYt0rbndczlNTf0KYqMMY2pUCprwIcCGfrE2JBdk4XvaZbk48QdU7M+yL8nqN0kZGQFvDyOQccvcwTz1uK95Zbo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(83380400001)(966005)(38350700002)(5660300002)(316002)(2906002)(110136005)(66946007)(1076003)(54906003)(6512007)(66556008)(66476007)(38100700002)(2616005)(6486002)(956004)(8676002)(52116002)(4326008)(6506007)(508600001)(26005)(44832011)(186003)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8qeObv0QKVTfu7/kZmlSAbqxF0/UaLMxiW6sySgcKlobTjsv9tGUAtxYaN4b?=
 =?us-ascii?Q?HDrO1tMPKqPC110gpstTpAV9B5VK0TZIeavG+xC6Y0Afmq3a7pKH6sJSWaDT?=
 =?us-ascii?Q?iLL/9JB6LsWWg99/QDRgLN9N2T8Z2FpD0BVzYJZA0z0JO7t1Pd9Xc5LsbVrw?=
 =?us-ascii?Q?GsjnR3W0UthluNHeEeZJ9NdYa34Cvlfs1XwQ5gy4nNRTs0Dl586aVxXfpGjZ?=
 =?us-ascii?Q?g3a6SsvQHEcI3hQKeeWPRgDz74bqE+LS4OtkNHrnUZVaa5R95n1OcR0VroY1?=
 =?us-ascii?Q?KiFmGCUXRIMBIq6sivj6ZmtDTW7z775UFI2q9psoVWCIYdmI6IzY97TF0HFD?=
 =?us-ascii?Q?eMJx0L1Z65RU7rxikgxmVdt4FuoH34MSZ1iprYzwPxyDNyPBWKGUeJuJesvo?=
 =?us-ascii?Q?1MpSLQNedn/eNqA+dwn9+WrDGH7qWpMg8vkVQo8VFFZbOM8djmU97GHxG/zg?=
 =?us-ascii?Q?/TJ6MKrl/vGdVV2kaZGtWKoVcZ2fgTR+SPCpsjyKV4OAztC7lgXMplMSo8Y7?=
 =?us-ascii?Q?4x8RAySFqhETEljDGdtmMbUjpgbdDpL5WDkQWAzfaj7foojaqe0Kjgy/V6/d?=
 =?us-ascii?Q?XYcCINrGbzl8daiDnVFQSpLSh0REqqkmu3IsA4FMrYaKSd100NJlR0hoP+US?=
 =?us-ascii?Q?pjCw/cNQb2UEjZve65cIv0idrgHWQ5gCENd/CrPsbcSk0h0FuRRN8RB/j8hC?=
 =?us-ascii?Q?p9qk4OAhaRK0fVU1CVvbh/KnU566kl7XrPb2eRAy57TA7UynTkcLlGaME9RO?=
 =?us-ascii?Q?WBz/OMPJ5YrTuKaWjM94xVea4/HeBLb6VL7OeLqOcMRbBRCLohoovdFV3qmx?=
 =?us-ascii?Q?SYz9HKTkEp6JsLrBkHm9EdME9wUQbue1LRusrycdcMyys+ITdZztaot8su1+?=
 =?us-ascii?Q?4x8LSbTesGd7Ry89EnuH+4U2ArZ9xWq1UppH/WteRgs3fqjzE3bkosreL6Pp?=
 =?us-ascii?Q?AUlTYzxrmWzJ4wesvqWiTSR9QB3D8C4Be7jcGsfVWdln+vrAijFJifEEw/aR?=
 =?us-ascii?Q?OcGAqziVnP2Ny9luHt/efXCOBEHYfmEnt8+d6IPyFpgNbi6wb/JglcLVMxFC?=
 =?us-ascii?Q?UKDFNslhELM3dI8XNjmRjnJKDMZavcs+cfKiLJdCiObORjxiCclH0tPAqSdk?=
 =?us-ascii?Q?A/X3ZIc3ijAA2HloxrvC0IGY4nC5Mtr+UaOI1cb2u+Y++uPtjV4i9/9r5su6?=
 =?us-ascii?Q?Ll8NJSUadVGzpcDAoSjQt0VGYzoAI2FaoaIaj+s0a/oJDc4SPlgHp+J3QMVN?=
 =?us-ascii?Q?yNQ9gvASvKzpnlEjHOVmyEj41hg2vS0UmePi4pW/aBWjj0NIcFzDPvp4s88D?=
 =?us-ascii?Q?2AsEYb5ebwH81FPUNs9DmDw4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b205eaca-5fb2-41d7-0705-08d989b22580
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 16:47:27.7616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrmIUDpfcRFQgHB+2TQW8Rx9FsGjfJbR5leUFE+9CULDEsDaVqlXeab4vJKtQo9VOLJlsVD0+q/btKgZ71uPGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
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
v2->v3: none
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

