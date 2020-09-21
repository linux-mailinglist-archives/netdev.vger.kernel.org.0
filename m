Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F292718C3
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgIUALq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:11:46 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:51024
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726430AbgIUALk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 20:11:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I88RkxQZei90SNxKqzqKJEpsW5rseLCBDBanIUbAJN6GN+j+CtvQ3SEJ2bUoQhEi7QijCiqw3x4V91Snj598CH4ON4g2Lz6D3PapP0rS+qqamNywQM1xBn+/PdyeH213XTXZ23k8kKslJE6ksEidw/TWPMtMvjnlmcQHcYoTgdmnOLxViluSWg8mqhlTyMiszq14hNXBsiQT7zD7N1EGLcnsdensnt2ebBgv+l5YdnsH3K2Mwz2qluWwF/h5kfWCCQXe6p7BEk93837cRR8yRfqo0V6Wqu8d7rprNrMYYs44vgsxYcIkN10sIFQl55T0Al+SwNensuVTfSKL3EHhtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbCjpDecYhWobdO44MmAwICRyLYdgYspBp4nLJN3/zE=;
 b=GAq6PVgfOoLI3dnGmXnkZtOTkAvl2E88ixaLu+rbLvHJRgnJMv0mi7NgcP9tATXLqDZZxgatj8wz0+Co1HzA7GDevldcNpMOXCanEdrmqeFVb7z8KlG8U2DQLzO5tImsYos+7YbHwuY9hN+N1+bO2EO7qoXUcrC6vTMyX7/LRrTzK1oirT/7aMpVwxay433AU9BUV2zcDOhJcyZlhA1dqfSjjsStqDnWWLtysl/53JhcJvD3yyN4oMeJ5KRwNGyB8X3aBkIucnCnB703plyZouimNcoSfTQqMWOjLYb9QEIdTqrzrAtpYXv72/mjdR2ZyNAHLvVFHWvK1YmlPwykfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbCjpDecYhWobdO44MmAwICRyLYdgYspBp4nLJN3/zE=;
 b=KugjLjs/OvQ7NIUUwxKS9bYdWJ6FGkVV0CcDvlVjOgmp3cJguvP0KF4Z2wqei5DxK8PSQ6HYPJ0cTQu3eVFAOQ3F9AMWAWL3ldEaZ8M2ZzTWWSIt1uDqX8ZsR/Qjr2OV3iWvDZndiMsk/UAun/9KOOJZngW5WE2QJXfBW5f+JLQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 00:10:52 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Mon, 21 Sep 2020
 00:10:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [PATCH v2 net-next 7/9] net: dsa: install VLANs into the master's RX filter too
Date:   Mon, 21 Sep 2020 03:10:29 +0300
Message-Id: <20200921001031.3650456-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5a1dfbfa-f4ff-4901-6f0d-08d85dc2cd42
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB55019BEB24EE6E1248E8BE85E03A0@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yWmYJn3lQSLn+YZNj0FwBKYY6DqCCxiW58rAqwlPfdrmXAh354aI65L1WXkNk6S9kpyuYM25QNa+BOgQOcpOT7wPdeq0uE4lfHe2nnFpFX4mTEeRoqFSX0bnjIKdTpVocBZ87/aSM3xrbuw8eqBIqEvWdIiKHmBrLbVpKfZMCYlOOBnpVrdhduqDqfGGykL+FlhHXFHaFCE2zz99SHcJ0PhpdjY9TgFqXD3VcoK0+3AFKSqx6vSSzYv4qlmGaArVTjCF0IRBTTa+dFlFmtmqLF8PGxO4v+6Co6YoZTZpypBSM3dZ04tvseEKxJrZ+LzEs8AzrZJCol3Zc1YGagb8yO4Vu3CSBwurRQBW6H5TrekUHhkpGO1+isOm8xvyDJ6Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(16526019)(26005)(6666004)(186003)(44832011)(316002)(8676002)(5660300002)(8936002)(1076003)(6512007)(83380400001)(66556008)(66476007)(66946007)(86362001)(4326008)(956004)(52116002)(6486002)(36756003)(2616005)(2906002)(6506007)(69590400008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jTG2xomaJo+GL77JVUgPqiqkZVt6ajjFpIB6Pddp3LEBucv1Hz/bOjHQljVBzbtI5P9sc3u0uiVkhMIk1s7+HToVJnLmkFjjm1UljokMRq6ClLZduZNabM+VVFoBAsGUh7Rf/20A/f3IvQa4EDQJS6iGf1t/TLTl9if99lUIW8ZEZhR4habE2xegAZqeAKQlMJ1KCeWyRnghYfWKp5rCQiMxEfthaVb9qWF9teLXWV0WXIfeDsIL3aCRIchfi1HaoLiklG8AuG1QqvD8AqQgA3VUHHbcJnf628LjGCelBOi7B6l7kWz4ESP6alAyzXgbpGKnQXME22Hd2bnpDfyzNf14tKuLVRPTVfX8+86COefmNEckPwVblVlMOSBXXT89CQ1WllOXZZOpF5L+4Tlsj9UgX+EU/Pvtlv8JN3cGoDUzq+2Iku5F10TFtKAg5FyZCrtlra/qXLYFzFYpwfh+HCDSh40QhfbbIEsamJSFbYu24asaIxB+sKYN4a7wxSPF1XlAgFMWAcM4FaViLg2060MOhS6AEniVajmfzxIiXEgmxTxsxt6+RNpbDlMSAPdi292GqtmoAxCyvv4xinsExy1L90IeiIfCJX2YKxpSI/biP/fVeukbNI4CKmg3I9YoKxAvtfB4uq5v7TsMSozx7g==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1dfbfa-f4ff-4901-6f0d-08d85dc2cd42
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 00:10:52.3295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9xeY9AyF/optEX1Ei1SNCcmlFlt93yElfdug5mGY32fI9Bx+lViQ/iyCWocXMfYnbnMTa7HWFLrs3Df7X2QoXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most DSA switch tags shift the EtherType to the right, causing the
master to not parse the VLAN as VLAN.
However, not all switches do that (example: tail tags, tag_8021q etc),
and if the DSA master has "rx-vlan-filter: on" in ethtool -k, then we
have a problem.

Therefore, we could populate the VLAN table of the master, just in case
(for some switches it will not make a difference), so that network I/O
can work even with a VLAN filtering master.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 net/dsa/slave.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 034f587d2b70..e7c1d62fde99 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -329,9 +329,10 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 			      const struct switchdev_obj *obj,
 			      struct switchdev_trans *trans)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan;
-	int err;
+	int vid, err;
 
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
@@ -366,6 +367,12 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (err)
 		return err;
 
+	for (vid = vlan.vid_begin; vid <= vlan.vid_end; vid++) {
+		err = vlan_vid_add(master, htons(ETH_P_8021Q), vid);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -409,7 +416,10 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 static int dsa_slave_vlan_del(struct net_device *dev,
 			      const struct switchdev_obj *obj)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan *vlan;
+	int vid, err;
 
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
@@ -417,10 +427,19 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;
 
+	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
+	err = dsa_port_vlan_del(dp, vlan);
+	if (err)
+		return err;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++)
+		vlan_vid_del(master, htons(ETH_P_8021Q), vid);
+
+	return 0;
 }
 
 static int dsa_slave_port_obj_del(struct net_device *dev,
@@ -1265,6 +1284,7 @@ static int dsa_slave_get_ts_info(struct net_device *dev,
 static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				     u16 vid)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
@@ -1298,12 +1318,13 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	if (ret)
 		return ret;
 
-	return 0;
+	return vlan_vid_add(master, proto, vid);
 }
 
 static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 				      u16 vid)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
 		.vid_begin = vid,
@@ -1311,11 +1332,18 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
+	int err;
 
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vlan_del(dp, &vlan);
+	err = dsa_port_vlan_del(dp, &vlan);
+	if (err)
+		return err;
+
+	vlan_vid_del(master, proto, vid);
+
+	return 0;
 }
 
 struct dsa_hw_port {
-- 
2.25.1

