Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE52279B6D
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbgIZRcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:32:00 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:45635
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbgIZRb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6aw9zVta+mtInEnA6c5PqV6DfA8WSiNUyubVNW3TCdkCWlRFxC4uATWpG/kyu0Sip6GA73lBUt+J23quonvUDM0rIIhbOTBHaRQFAIheCIMwhJ3rBJ7GSdqA4cjz1L/Sof9vTlGUETRnVRwvse4bOqzdzvQDU+QSnsb0Mk0zVhyrk1zL8wTl0bkRHblGoVXzt84T6pLHXUcwkehAMzAeVnrHSPVLFXeLlw4buvZ0mtYWBrjqosuLZJRGZAHgsWkifr4MbWZBaDhPNLsWzrHZAG76Z/JfOEB4xc9eaU4QlJ8Lm9UaXxJxrd4jKHKB7I4ESp7wgSuxi1zzBh6zcDjvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54Ry9n45ZvViTd7bhTLlT/KP0jcruMPeWgGSMq9ybng=;
 b=aB8am2H2X/q0V2TwO3pyHFHNRgaapUYZD1Zy8C22cU/Xs4ZMwUcjFhnWZwi0hqAb2v2VFdRZSjuOVknjXIkQMzjk31NFlCBBY0haFbfGu44Nt5PULmoccjlL4sk+xO5lVqlWiTE6Cs0s5n+0vPelmG2z4i15VmkApxC0sUh82VuSjHMGGIJv6xMUcsseVxjO9EA/BwoFqK9KBNyg9QNIQlVBL5tKXNG/we/V9HwaZuyRJHHLO9aW8WOI98jMaZc+VvgbD5TB2Y7KGPnleRRjflNXRxbVq6vgszyyFuT5fh/eHCAFKBnEWPwTPSTp5NeeQ+saszKwJSckzLysliGLjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54Ry9n45ZvViTd7bhTLlT/KP0jcruMPeWgGSMq9ybng=;
 b=DUDzNthwBfTSV7RIbqzQZzZERJbx7+zwmC7fWgKVpUXVSQ12CTsj54FtrXJidnx/jArqZX4Dv/8hQAloBnSVY70VsqcwOySZvcO7csCuFDJwz9mX86QjMS9+QP/6nrikrkH5NiAzdGvvO77pRO8vUrz0ZrQiScl8uq6Qm1DN6+Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:22 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 02/16] net: dsa: allow drivers to request promiscuous mode on master
Date:   Sat, 26 Sep 2020 20:30:54 +0300
Message-Id: <20200926173108.1230014-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:21 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0e8a9961-1ccf-4140-e41a-08d86241fc79
X-MS-TrafficTypeDiagnostic: VE1PR04MB6640:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6640834658BF5E07379B4CDAE0370@VE1PR04MB6640.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fVPPqdrKrU3MNdgZowXPMGaeN62sze+wdzbKuEaMKgJe5s8QQEM4zV+sbpJHsbtS+5ktfp49S+qZs1OKMSSw51/c0jS8AIvzG693HciHmV3e3yuwpzd2ZITb6IMCGb6qQx+sM+Za7bUS8NxR7U4s9NScWa0AfYSOHQKR+aH8ltDLJklz8vITNXcOLAwjyyFO+HZWV8sZIDQ4UhQVpxqULrBqWFI/sqSUF6OQtEqjqbEVjnSnCgz/BeXiyhJaqyw8NNmUcx6VN20tzWwDWNRSgNjAqBWStVjuqCML42TM8uUYFUEyOCpR7GweVGacav+DlzowW7r3dd3pMUWFy7mgWvuPpfoXcX7WW12E9vR6sBSPFMrFGutxSTRvS+vmxxmcNN+W1Rr+2HgRt68vc8txHlbivEFnPovbvkH7JUj00zvSc1nDFfmPPqkOJ0JdVSbl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(956004)(8936002)(1076003)(6486002)(4326008)(5660300002)(52116002)(26005)(6506007)(66556008)(66476007)(2906002)(8676002)(36756003)(6666004)(44832011)(66946007)(316002)(16526019)(186003)(2616005)(478600001)(83380400001)(86362001)(6512007)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /hKWG44n/aMp4Rohxqi5RK8GEcf7xpV39zPoDEFyX7ulrB1wvPxECsJ2GQ1Bx15R+CJbDpYRYJpzO4dZnjBaPc7UlZ3iEjzwJV6omhMMHfOQUGH9Q0x2je42Q/f95dKj6OsgEmr2AKjMLl5ifkFxvmUELZ79O9fo2WipM5CTpqNtX+BegiBdiDKRJhI2of2gc5CLP0oyCNXpgqu7TbaNVsRpmbl81zK7GeT16HOREcYTDEOlERQf65hjtb74GRko6bIUQfyjUGw9Qc4lTKotLVzqiDT6Ht0MIKulXZ747NBexk0ex2alPxo8hqbL/FR0wNn+hMGN34OkEq3vv6mCWMO6RCQGmNnDO5wNgMYKt1bj/E9rBB0e0t8/g2sa+j54DctTWVB6GbwHKxczw8BFzobKjzhBdq009CDTQ3J6XWHahYmZRiJYZJVYnbR9whD173eO9b2cwfDKbMJN+xxWTuV8QoTEMWOa2XeDRIFGITMZonq4UbryD0h8Kuuxj2sjvPlv7tHyetN3w3UBaRhT5Ov9ov3drwZlodGtWP2NpSs9N5jU8Mntw4vvYLc3KT3cDLKrKaMJkQuNRumMlLbCTV5zwwQhJM1d8/WarrcLWlwIcpBUS8uUIL/Yygxghe4ENb5cJBZBcIqEZCrTcgMRGg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8a9961-1ccf-4140-e41a-08d86241fc79
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:22.3676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LmSCcHn2cI3CJE0FBG0PB4R/G3EH9eFaV7Rs5QnfRJ7VOuefjFcaF62dsl+qGguS5XnNk4oIxcPcHdarRAv0Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently DSA assumes that taggers don't mess with the destination MAC
address of the frames on RX. That is not always the case. Some DSA
headers are placed before the Ethernet header (ocelot), and others
simply mangle random bytes from the destination MAC address (sja1105
with its incl_srcpt option).

The DSA master goes to promiscuous mode automatically when the slave
devices go too (such as when enslaved to a bridge), but in standalone
mode this is a problem that needs to be dealt with.

So give drivers the possibility to signal that their tagging protocol
will get randomly dropped otherwise, and let DSA deal with fixing that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  7 +++++++
 net/dsa/master.c  | 21 ++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d16057c5987a..70571b179d05 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -317,6 +317,13 @@ struct dsa_switch {
 	 */
 	bool			mtu_enforcement_ingress;
 
+	/* Some tagging protocols either mangle or shift the destination MAC
+	 * address, in which case the DSA master would drop packets on ingress
+	 * if what it understands out of the destination MAC address is not in
+	 * its RX filter.
+	 */
+	bool			promisc_on_master;
+
 	size_t num_ports;
 };
 
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 61615ebc70e9..c12cbcdd54b1 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -259,6 +259,19 @@ static void dsa_netdev_ops_set(struct net_device *dev,
 	dev->dsa_ptr->netdev_ops = ops;
 }
 
+static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
+{
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	struct dsa_switch *ds = cpu_dp->ds;
+
+	if (!ds->promisc_on_master)
+		return;
+
+	rtnl_lock();
+	dev_set_promiscuity(dev, inc);
+	rtnl_unlock();
+}
+
 static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
 			    char *buf)
 {
@@ -314,9 +327,12 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	dev->dsa_ptr = cpu_dp;
 	lockdep_set_class(&dev->addr_list_lock,
 			  &dsa_master_addr_list_lock_key);
+
+	dsa_master_set_promiscuity(dev, 1);
+
 	ret = dsa_master_ethtool_setup(dev);
 	if (ret)
-		return ret;
+		goto out_err_reset_promisc;
 
 	dsa_netdev_ops_set(dev, &dsa_netdev_ops);
 
@@ -329,6 +345,8 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 out_err_ndo_teardown:
 	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
+out_err_reset_promisc:
+	dsa_master_set_promiscuity(dev, -1);
 	return ret;
 }
 
@@ -338,6 +356,7 @@ void dsa_master_teardown(struct net_device *dev)
 	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
 	dsa_master_reset_mtu(dev);
+	dsa_master_set_promiscuity(dev, -1);
 
 	dev->dsa_ptr = NULL;
 
-- 
2.25.1

