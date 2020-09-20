Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362AE2711B8
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 03:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgITBsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 21:48:31 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:7847
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbgITBs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 21:48:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJNdqvZJzqWL4pb6FbilDWBVCQe3SnZZxoEiGg61OEk9pXs0oHsyzoU+qMCl0oZIxZ51pCIjxDLTUl2OdPQ5v0HlADF+fqqGY7XYaMkLHskjparz4zda1Ff7D5JN2v4xaoODu4ZULUa+OA91IpOFWQ+jjrwqPPEVgdVworbmoNXdmzNY1Fab7URYtwjqNg3heg8go29YMipUdOvl2G+QL9BPiH4LFipqt6Q6CHLYDEjqaILwGER+cABU1XN+2UiPWxreTiKAk0EEiArb1fgkFkbzDPnAD3q49Cg8c4bf4h6DiQydnaWy1q3kKs626xs4CjFoYhoDVdbua4U5amBPtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khZNZRUo5+YSUbqIj7jbjPSWkQswW0iWUBEGb0av5pI=;
 b=h5Dmstr30xP4GFQy3RdP3VVeO4mJXb6S0ewmqbclMGelmwaZa+CDqp4oRnFhjtdP/4587xnJPbEFQ02lGozqA7Eh3cN8XU+KoOuD2q1MK4EQOI4P75eFqvuO9aNqyrz8KzZEqVdDH0x28oRSqPdVTWMyrEkzyG0vgsBy7VzxyVukOQCTITFBbv+lin+1CCOAK9TZ8wTGoqM9VqEL4PsdQeqBbI5ATOgwVmYQqSVdv9eHOL/jXfNCHJtxX2700lPWG+C30aaC6rvVJGTAXyVdycnbHoBMW8vMSbUXrnUCIkCJ4kK5eIurZjvMcOaAhV7wJuwQxvK8Geur2z0PdPRNNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khZNZRUo5+YSUbqIj7jbjPSWkQswW0iWUBEGb0av5pI=;
 b=Hhdc12CkEQ7OszVCORP9VunoGk5bBu7EaCfwntdk+Swj0WLbuUbE6j3yPv9WXYHNfdfrQQNvLUmlxkdZ0UQGJc4sC3xlc5cIhyHm/sxer3Hysr6zE+lxpwuOYbtM6C+cakueC2XoiaAUBiu0ZywhkO4d1gBBtjUBjxfj5DHqIx0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 01:48:13 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 01:48:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [RFC PATCH 8/9] net: dsa: tag_8021q: add VLANs to the master interface too
Date:   Sun, 20 Sep 2020 04:47:26 +0300
Message-Id: <20200920014727.2754928-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Sun, 20 Sep 2020 01:48:12 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8dcf3f0d-311c-415c-606e-08d85d073c49
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0401MB268613068E4E3910B4B1B247E03D0@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BVXe2oA8bdCuZmFwXNXBF4wvH997Qw2sFVEoAMntNh3FZWb8kPKG4fNDcNBzljZsiFxFoo3u8OvtJoCY6REPTxxnjQsdL6ikKZshxC5Kf/pnONHix3GubQ199rN8muClSzDK77KiM9m/937w+jI3llhl32U/spnytWLqc8FpmjfDO6LoviT/pb+DKMNNxAy3d/+YwrYAq0g4J0JHArNxPkGGVDFzKRSY2fJGYT69CKmAuUwt3G7dQzpaz38Q9peWGh96uzsXUuCC/NV93BvEAiNmOP+nUHC3flQx6wN1v3AZrMgFu1Ta1xN5qEsBexlKdNrqtsjmnsJnrG2jaCkj6B+8gTfVjRQXuLqUdpptrKWaLPD5jj1kuPlNd1oJwwRr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(4326008)(69590400008)(86362001)(66476007)(66946007)(66556008)(83380400001)(6506007)(2906002)(478600001)(2616005)(956004)(36756003)(6486002)(52116002)(8676002)(44832011)(186003)(16526019)(6512007)(26005)(1076003)(8936002)(6666004)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0Lu60aki5IEC4b2iDjMuB8ClxaIfAHVZCLcKaanetgihV9ykPGU/36aVdqoJzSkAe7hHbiDMrXrxt0OzfdxS9eBijUEreJoV1+VTKk1+k/Yyc5vCWrniAm/DyYrg5zO8xucQwysak2Nfoabc9ffoV6yo/I7RG26GZYEhMV777JYnGepdgEpV3eN994+uZ7zHE2sZ3RHqTsaPMz+QLTg8XEpOv6+iKrKtYmjdZthmllaous9GW7ZVm/N5fWzBOAnKUcMCIC0uh6F5yWnrvO1u64+CYTzVeVUe8rDdC64CV8rPC6PqZZYT3BD9a9XIhyUt6+J+TY8nWDxTNyS5NEzvQFlK6PK8CKk9sUCt+Rv+UulinybGLimthugqLVJXo/nFEdwYbK5qmxNfrELVHnFKPslZyN53Z39eL7tuDx0P20gJTFV4LygrZOoOhfLooOJMVlVlnPYueIHHTIc9n1oll49K8j1bbAyx+gyYu1jtCI+ahylYvk+I5T7Vn8f7GDRc/uLXr1HETWEcDUZoWfXLqosimiGMQKu4AP03ZZUBwwUxLWGLFqK+dgcFwc1upYlG6sq37O8qz8Ae+Nlb5Z6J4QVhgkz6baMCEI3zEj+PzXEI7iGKYDdi4Yj9/Qjdz6NjmzVBeSAGv0UxjBRo+nW1RQ==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dcf3f0d-311c-415c-606e-08d85d073c49
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2020 01:48:13.2460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRhgKH3vTiIHKbxwG2jvJCX3qChxYap9Lg+4S++7e0ULBCyuvuEba+1EthGVdPniAEUf61NublOh0mzkmS02KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The whole purpose of tag_8021q is to send VLAN-tagged traffic to the
CPU, from which the driver can decode the source port and switch id.

Currently this only works if the VLAN filtering on the master is
disabled. Change that by explicitly adding code to tag_8021q.c to add
the VLANs corresponding to the tags to the filter of the master
interface.

Because we now need to call vlan_vid_add, then we also need to hold the
RTNL mutex. Propagate that requirement to the callers of dsa_8021q_setup
and modify the existing call sites as appropriate. Note that one call
path, sja1105_best_effort_vlan_filtering_set -> sja1105_vlan_filtering
-> sja1105_setup_8021q_tagging, was already holding this lock.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c |  7 ++++++-
 include/linux/dsa/8021q.h              |  2 ++
 net/dsa/tag_8021q.c                    | 20 +++++++++++++++++++-
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index cb1b0b6a63f3..4892ad4b0e86 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3038,7 +3038,11 @@ static int sja1105_setup(struct dsa_switch *ds)
 	 * default, and that means vlan_filtering is 0 since they're not under
 	 * a bridge, so it's safe to set up switch tagging at this time.
 	 */
-	return sja1105_setup_8021q_tagging(ds, true);
+	rtnl_lock();
+	rc = sja1105_setup_8021q_tagging(ds, true);
+	rtnl_unlock();
+
+	return rc;
 }
 
 static void sja1105_teardown(struct dsa_switch *ds)
@@ -3539,6 +3543,7 @@ static int sja1105_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	priv->dsa_8021q_ctx->ops = &sja1105_dsa_8021q_ops;
+	priv->dsa_8021q_ctx->proto = htons(ETH_P_8021Q);
 	priv->dsa_8021q_ctx->ds = ds;
 
 	INIT_LIST_HEAD(&priv->dsa_8021q_ctx->crosschip_links);
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 2b003ae9fb38..88cd72dfa4e0 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -31,6 +31,8 @@ struct dsa_8021q_context {
 	const struct dsa_8021q_ops *ops;
 	struct dsa_switch *ds;
 	struct list_head crosschip_links;
+	/* EtherType of RX VID, used for filtering on master interface */
+	__be16 proto;
 };
 
 #define DSA_8021Q_N_SUBVLAN			8
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 5baeb0893950..8e3e8a5b8559 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -215,7 +215,8 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 	int upstream = dsa_upstream_port(ctx->ds, port);
 	u16 rx_vid = dsa_8021q_rx_vid(ctx->ds, port);
 	u16 tx_vid = dsa_8021q_tx_vid(ctx->ds, port);
-	int i, err;
+	struct net_device *master;
+	int i, err, subvlan;
 
 	/* The CPU port is implicitly configured by
 	 * configuring the front-panel ports
@@ -223,6 +224,8 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 	if (!dsa_is_user_port(ctx->ds, port))
 		return 0;
 
+	master = dsa_to_port(ctx->ds, port)->cpu_dp->master;
+
 	/* Add this user port's RX VID to the membership list of all others
 	 * (including itself). This is so that bridging will not be hindered.
 	 * L2 forwarding rules still take precedence when there are no VLAN
@@ -261,6 +264,19 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 		return err;
 	}
 
+	/* Add to the master's RX filter not only @rx_vid, but in fact
+	 * the entire subvlan range, just in case this DSA switch might
+	 * want to use sub-VLANs.
+	 */
+	for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++) {
+		u16 vid = dsa_8021q_rx_vid_subvlan(ctx->ds, port, subvlan);
+
+		if (enabled)
+			vlan_vid_add(master, ctx->proto, vid);
+		else
+			vlan_vid_del(master, ctx->proto, vid);
+	}
+
 	/* Finally apply the TX VID on this port and on the CPU port */
 	err = dsa_8021q_vid_apply(ctx, port, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED,
 				  enabled);
@@ -285,6 +301,8 @@ int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled)
 {
 	int rc, port;
 
+	ASSERT_RTNL();
+
 	for (port = 0; port < ctx->ds->num_ports; port++) {
 		rc = dsa_8021q_setup_port(ctx, port, enabled);
 		if (rc < 0) {
-- 
2.25.1

