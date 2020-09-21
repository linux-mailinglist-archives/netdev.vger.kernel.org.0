Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F0A2718C1
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgIUALi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:11:38 -0400
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:15744
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726417AbgIUALg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 20:11:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KhMPSzMFy4ezvTJDqzHHKQkUy0BRnNMcub2moPvv8B30NJLoaHuwYudyf+cGO3NY2q4ZwqaRDYS0T0kwxq22paEcGkKIOH39+98UnVQVSk7NQ7eKQ60lN6B8Fwz3lTTRwe2/dWfjemIYOAXnTdja2vShT/7dYAhMTXVsVyhWwpdvToFkOssHbtyIRLpZpr3IT5O0gJN3mWa/QZz8VL6TDosDxTD6qd3kNrogJjA2Znn32PlYQ3CWq26V3fYjaWowv7qkvWvTa4GCYCQit8H6o9SFD0e830/czrqIBc98AF4VeJn2Ult6mCW+OpJ1QESbkn486ovkeeK9nrOUZO2xZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUuIP61KFPzmBzd0qvUvp9OBY6Z52DMNyCMUm5mOwDM=;
 b=Smb9iJvgD1n3oRga25i7xX1tkGzxfEiy70WOoBoRX3h+H1BK3Q0wrhST8DXXoN8eRrpdmOxGW7+3ET5kFIkBjDc0RnRF5W4jDk68LfSCFTUpQ4FtZoYZ4ld0b5fnuazxdGOodMwBinZ7ilwQocJsqbvakAG36JpNRDJ1+EUepFQzsLgNIjGxPTQM5U/pljzARG+Am8QugxoNS1P1Sw4o4Cv+exR6ZV+3rtLCvrlKNPTehSQzJTZF/pSlYmPcMdPPEDlqm/0iR9WosKmCke0kd3KfOsugDNNbXchAYDppKbq2iP3fl/yInEYHr6mxQTYwzHCH04YO40HkJ1r/n78HBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUuIP61KFPzmBzd0qvUvp9OBY6Z52DMNyCMUm5mOwDM=;
 b=aQvds2rkTHdAsqFapshs54moCW4cRFQGgiQzC3uJX6uXE1kLCgpRUfhMShv3QRnMYaKHFt8HnlXptCIeMztoNXU0AYxB5yVuvtXQYoDEvwdtzuTfHK/mZG/KdoXZiglJuk4Cs6HptOb0Wa+bc5hBbS9cepxJYCr3smEHZsp7+s0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 00:10:51 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Mon, 21 Sep 2020
 00:10:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [PATCH v2 net-next 6/9] net: dsa: allow 8021q uppers while the bridge has vlan_filtering=0
Date:   Mon, 21 Sep 2020 03:10:28 +0300
Message-Id: <20200921001031.3650456-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
References: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0048.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1P195CA0048.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 00:10:51 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8745dc7a-f9e7-435b-ada5-08d85dc2cce9
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB550166AADA6ECBCC1E8E3F10E03A0@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WxQr3V9ZamS46Bvkpi7X9M/IdWVlrwLdkFibpPZwVJ/yj3VAljsfJ9zwwL41iCycRUV7tk3TNsmgV43R9nesKNruEx/6Hb+evPaNVCfj0FkSsMD7oP/ejDDVzwKf8al2ERYx3c4ZY4HvsfCV/v8HutBnbyTAHz0heDAxmPuI8/zqsKXzKs7tdsYFknW8rpkIAQKeZGSMfrLP/MNRdE1N/PhUl+vw4xhWMjLQWvA+OQSAvxTxbXcsqO0CBIuK0X/IsGo95It0N9wY7D/aNXGdeki2Hc6LYTjV3dm/VJlIzQKwnI8kEcD7jWDMsgVFItlAo+foRQ3jeLzLrTnhosZJ5UasHCULlR66Pt0SRpPpIzaM7jjqLpTfxujhNApoOWOi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(16526019)(26005)(6666004)(186003)(44832011)(316002)(8676002)(5660300002)(8936002)(1076003)(6512007)(83380400001)(66556008)(66476007)(66946007)(86362001)(4326008)(956004)(52116002)(6486002)(36756003)(2616005)(2906002)(6506007)(69590400008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TL/RiJV0nklrTNa7p68LXEXpw7Cbfzm+UYqjH3Qj7lK6ZkkWO2E+ZE01MZhAlrZFplVeQSKbU4TjJYE4k+uodUrSYqM3369/nwXODamOJPMXU1lLPCsncJjp75DULejm1mpIHw6UC9V2yATm+zHvhRMB9ty9PdrllV6ZH3XMKWcGaUCXP1XI3frWEOrM9A4W40rtKOMISFtmqA0gCqu7EpG8FmGLgXAjOxo6rTdLPY1EelDW5cXV3XlfiRaedz0S7yzVkF20upN93FTUEPlIhi2wZl/bB9A0ysvOoJ8h1U39qQv86t0MVX8Rwa9oFqJkFANiwJ410OiUPpLUOf4YbS0BB+BNF3e1+rqK3r7XpA4gMtAOzVwVUJ0IBihytfaehQdZpBXZzmZtkuqo4WIEXDJGydmrPrttmR7xsI9DkzGWrca4Hm7WjFv5+MvyiUGi7ZI0O6yIh5DSchaS0vZ8LxTnvywFxr4e+uOsBHHQVUnJzisy7e6VzKPTTDih2KEJf/ocrqkEBkHzAbG3wbufPlEo+LfFIh2y4c8KYYTuc60gZvVXC5iJntm3EuKGtshOeCdoqILnZo0ZhGwJdEPj9KcbvSxmEbWyeMLeF8WqJh+beS/N3ZUBNaLZbcmkPexZy/QTHTyJwGYe6rw/X0nqyQ==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8745dc7a-f9e7-435b-ada5-08d85dc2cce9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 00:10:51.7469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0HASK/Ns642t34XOtdbMdTsgvk81eXXTNgyMO8fX9HyvrpaaSBwQqEQvikxU9ZpaYLIrtXTisYQ72iooPMooUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the bridge has VLAN awareness disabled there isn't any duplication
of functionality, since the bridge does not process VLAN. Don't deny
adding 8021q uppers to DSA switch ports in that case. The switch is
supposed to simply pass traffic leaving the VLAN tag as-is, and the
stack will happily strip the VLAN tag for all 8021q uppers that exist.

We need to ensure that there are no 8021q uppers when the user attempts
to enable bridge vlan_filtering.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 net/dsa/port.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 net/dsa/slave.c |  4 ++--
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 794a03718838..9a4fb80d2731 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -193,11 +193,44 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 }
 
+/* Must be called under rcu_read_lock() */
 static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 					      bool vlan_filtering)
 {
 	struct dsa_switch *ds = dp->ds;
-	int i;
+	int err, i;
+
+	/* VLAN awareness was off, so the question is "can we turn it on".
+	 * We may have had 8021q uppers, those need to go. Make sure we don't
+	 * enter an inconsistent state: deny changing the VLAN awareness state
+	 * as long as we have 8021q uppers.
+	 */
+	if (vlan_filtering && dsa_is_user_port(ds, dp->index)) {
+		struct net_device *upper_dev, *slave = dp->slave;
+		struct net_device *br = dp->bridge_dev;
+		struct list_head *iter;
+
+		netdev_for_each_upper_dev_rcu(slave, upper_dev, iter) {
+			struct bridge_vlan_info br_info;
+			u16 vid;
+
+			if (!is_vlan_dev(upper_dev))
+				continue;
+
+			vid = vlan_dev_vlan_id(upper_dev);
+
+			/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
+			 * device, respectively the VID is not found, returning
+			 * 0 means success, which is a failure for us here.
+			 */
+			err = br_vlan_get_info(br, vid, &br_info);
+			if (err == 0) {
+				dev_err(ds->dev, "Must remove upper %s first\n",
+					upper_dev->name);
+				return false;
+			}
+		}
+	}
 
 	if (!ds->vlan_filtering_is_global)
 		return true;
@@ -233,10 +266,19 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 	int err;
 
 	if (switchdev_trans_ph_prepare(trans)) {
+		bool apply;
+
 		if (!ds->ops->port_vlan_filtering)
 			return -EOPNOTSUPP;
 
-		if (!dsa_port_can_apply_vlan_filtering(dp, vlan_filtering))
+		/* We are called from dsa_slave_switchdev_blocking_event(),
+		 * which is not under rcu_read_lock(), unlike
+		 * dsa_slave_switchdev_event().
+		 */
+		rcu_read_lock();
+		apply = dsa_port_can_apply_vlan_filtering(dp, vlan_filtering);
+		rcu_read_unlock();
+		if (!apply)
 			return -EINVAL;
 
 		return 0;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a1b39c6ddf4d..034f587d2b70 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -344,7 +344,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
 	 * the same VID.
 	 */
-	if (trans->ph_prepare) {
+	if (trans->ph_prepare && br_vlan_enabled(dp->bridge_dev)) {
 		rcu_read_lock();
 		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
 		rcu_read_unlock();
@@ -1950,7 +1950,7 @@ dsa_slave_check_8021q_upper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	u16 vid;
 
-	if (!br)
+	if (!br || !br_vlan_enabled(br))
 		return NOTIFY_DONE;
 
 	extack = netdev_notifier_info_to_extack(&info->info);
-- 
2.25.1

