Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F393E2718C4
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgIUALq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:11:46 -0400
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:15744
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726435AbgIUALl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 20:11:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkdVB1Wzsu21nwVD5KlAifdBo425x/7F/MqPZ3lgs4/qBySPGwwPH72oq3LeEJ8glijAfJIgDthwFMHHZPnNjw/eKxH9T7CWLqc9NoEsl6hHVMJ1eY8e/dDKmOrb/mgB93ae+XAYJl6Id4nB6Jn1p2QuRwQ+Jt2DvWBoYiElzdnEvBEmCeM/FBXSTNz1laV2+jHXao1GSjC+o4QQg15PCIDp1Xp6arPfq+nz2Bst3fAvki6ljmBIPAatsqHQMazhAoBYvpH+9PhdNPAK3dmSd27RziN5pYLoxqOM4v8mDTO6ZezsxCIePnJkkYPU6ZwIBMMjHAutDWqUgKt+aNwIhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qu0w2fo7i6VEMP5URPt3wgBvsq13R176E6w9IkzOCCY=;
 b=i57h2mP7Uo/+Gd3xPmSTaDZ+vDCx+4nXrBcCkUZY2TG5yyjQy3WgqcUyR3VpLBLfRYx1DdVBOHSKFGcYPO3rSuBAbtwgP7jnnA7oVYBpNX2gZsVUlqkOk7fVtS0KAzDanLeTOD3OFPc3mrwBOCBaeoBTgUJV1nfYTFScxdcpFnQt0kvhEa0LRMkA4nzqm3fNXWQtbKA2/80VmYUWXZyfqr7KkNAu+nxVm/ZbHrI2RhDQLT9dmRh/FyvjEeBWx7A66SqkwUY856C6pCBYBugR3jGcj5QEc68aQDd0MvU1mFJG6TaqpQVJMpz4ahtE+2ylEmZKXfkGejeCSqCb6LUuzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qu0w2fo7i6VEMP5URPt3wgBvsq13R176E6w9IkzOCCY=;
 b=VN+D2+iJbnRHdQPtU2prNv2KyYanG8nDLes3cr3OpmLkgai28loFV7LRYxwiGzpscVb8O1jGXBiqyOAVBwKLxtR2Q7Nhjh8CZf3ouxIM1Zg8vY6JURnTT2qWdaWYmgRlwUoPnd44OANfpXQsrY3w/eTkUTgvlJYKOrlWSQ+xk7M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 00:10:53 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Mon, 21 Sep 2020
 00:10:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [PATCH v2 net-next 8/9] net: dsa: tag_8021q: add VLANs to the master interface too
Date:   Mon, 21 Sep 2020 03:10:30 +0300
Message-Id: <20200921001031.3650456-9-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by VI1P195CA0048.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 00:10:52 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ff327e82-b9a6-4c34-a59a-08d85dc2cd9b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB5501666272235CB6A2175970E03A0@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T+F9rYNvG1s0o8gTDTr3mJYu7+n3QHwAElAOrQrYOqOd79Em3rIkzeMvMH+LLh7xszr9vOdwFkzNz222FmFJMVnXMzwKbKDHWblooyV/Pc/otKi6L9t0uIfRGRnBUD9eH92Mq/cM0uB1ZJlLAZUMnpTyVriafcHeUcbSBmR4llGHa8r4K12c59hcjgmZGJbsIKl/qLpakOIesCdJ8Jz7uUfRyAfBR5MfOTcYFcrvQ9mg3NbjbvYVBXtsJhj8ZKHNvZ83KmhH8Dbxfb/RNmCi2Ak813NONoBRMFDKh1Ka+wcJ5c62Rrtw3sBnwM8pt1B+Mkf5RMg3neUOpzMi/vyyLMWNvsciNP2KeHg4huMk6Re8+fFclvC9yq141Y1OoqP+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(16526019)(26005)(6666004)(186003)(44832011)(316002)(8676002)(5660300002)(8936002)(1076003)(6512007)(83380400001)(66556008)(66476007)(66946007)(86362001)(4326008)(956004)(52116002)(6486002)(36756003)(2616005)(2906002)(6506007)(69590400008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ET80nvAJ4qz55pZbJ6wGOlzVo6kPAxlG+b0uwYl7w2SEniGKORAbOlkYONcnLHAQGdgT+bQKFY9yc2QxpegcjnqTMH60X4w1RquNvv7M3j9Qz5NIQCaK81K4o1CPZ2VAgdj22bGkus65tMdsIyJ0dKan6E2oLZbfJQM1FhljJYP2noJxn53TGAT+SVDW/oHXV5ixpUTuCvWYKc7s840y5BaOm4Z48BFZ/4NM3yho2dilUkQ2HtXjTA6o+Z6lExgmElNLc624HibMIGIFJftcHd1YknwSHxnfJTtF4aKPocQhXMWOobKEnAptVrXp2gpfo/bG6bIqOiA56mLPNdRHfoHc18gt13TWn+TgSRW5pxR2uMto4nH3UuQLJ6I+94mh+wINyRlkiySdOMEJN8NVNpaTlC9ooJdCkX0GplWuvgGaKP+Y1XidL6kJf8IrQ8E6NmuqBptjtWAOw+YHJ9zFjnxUCoGruFAnrsNKbcllHhQUtLCQaFc2lT5cS4kZrdzCtyMtAnEgagLFRCz/r3WeZPtviTHtBMknISSJxPIu4xg9G5T8rH7kiDXkDkn3XADlYUt0wFnPdZOUiInek3mxeJHOBlpbXZoerOl7CzQEl1kruoZgExO5Qg3AzFRkMMn5S1bhsnWeSNvXKlUCybjVqg==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff327e82-b9a6-4c34-a59a-08d85dc2cd9b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 00:10:52.9232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SA+bZ7BQY1PjeCcMXAw5yBeVNbIFB9fzRVV7bkj0259CgEO0RvEGXEG2wRzWkwuFo6jZuyFdO9ctD8vuuukLjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

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

