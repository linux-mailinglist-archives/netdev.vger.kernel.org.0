Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9A4279C26
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbgIZTdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:10 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:17545
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730184AbgIZTdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDhAQ2t4FwO9tIThwK035rWOVEVXdn1NWrz2PMUHBF8bSiYuCBsydD9VyT6co1M/cMNuKxvbiJxOZ2SLo0UQQ6LNdL02odoruM3mp7yIdrWuNjaNRvHZ0rwDvIQz7IWKAmt9ludJ6uOvuOz4V1XkaTpqhuIpiJy9xY/wp2wZYA/faUlN9iqnb+NJR8G2/r6miODSmzEOWM0hjaNBoKw75k1FiUJfuQ7HN04mywkPQ84Y7NUvflMDpCGzC67IFVRXhk9DoFFJT0AFS1FfQ2e1Ywi/V3265tMot28+T9dX16ugsCah3r604hopKW622WGVwRTMzQPehEQXq6Hom0v8ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8Ifn74g0xoyrTSSLWN6zKDt9g3sxHQ3l0S+E13P7kM=;
 b=gxsQ2FxTAtCD0PdCFenu9f1Al+R5IwzrvYX0cwf1dZ+Q8PI9PWlqbI7Rk0CANiqoaIaoYlbGSLaj/vGqu768ac0JwP1p27tYVco4c41ehloX51qMyelzq6Q1luo4xJ8HVBLlhaiWhgZv6eULDlL2EqwnuEodBq/Q40nhEsKe7TXig4gTmWzri/r0gQ8w8iKpeluMWUl5QMmiQgOMvtGYUW6g7XjpcoDOJMxVAPh0lq1r/aGdkZEGOpjWN+YelJcYhSSKgULLBnfxl9BHrDThGgW7VoRrwGFZsEmlNIqi7TjACukhQ6ahPqT/9F76cjd2alTqDgLEqrMuJO9PmWXsug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8Ifn74g0xoyrTSSLWN6zKDt9g3sxHQ3l0S+E13P7kM=;
 b=Ypwp5MYaOaxnSR6rGssPUrIYBli48zdHnhDTPkviVn6hAqL6bMqcqr79mXQcl2Icv90TtUlYvZAkBG1IBGIOU0EnKo2mkbeREpaWhmfOm1GYxFf4baO23MbtIEz5FP0qZF4tHw9nC7DVyMBMam5eTF2/sOZ34uXtaACjzd2nWhk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:00 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 02/15] net: dsa: allow drivers to request promiscuous mode on master
Date:   Sat, 26 Sep 2020 22:32:02 +0300
Message-Id: <20200926193215.1405730-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:32:59 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d652801f-f381-40b2-910a-08d86252fa67
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295318047EEFB59F4A6EA14E0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+cbec6hnEdVAw37PV0hODwNmnd79XvVays7IrXM3M0yDuu7I56RsmRlPfXL3BM2fTYkGTiuIIZTQqIObxdksubtoE3pNYnZRwcXvrkOpO4VXSG+nd94GaoKDnZ+OZs1Qa4JjRth1reZL/cO9foVtyVCJqOFOj2Cb/vQbSED8GvIn5GofVITWmOr7A3iZr72O95NIvteJgwb3w5TCSlJdQbLHVN+5zMqsxiap2XCqmxTm7U1c42qTMVU2FMPEZ0iXPsr61N6su5ca0FzfVPzSWYPbAq5VzyDEpxJjITnshUEsGRJFWpU17HOc7ub+LQbiB5qaqDbQJKRJT2gndWvU6ZcIav4rFn1ki3tLWBFJVmthF4e3CMKYCJ+1QYn1GARL9it4sbroiSfCW+qidtOEf1Af6yrjSnn4bdVWhsUlanL6JW3E4VocLsF0/Z12Y8Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(4326008)(69590400008)(66946007)(6666004)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cWmYohUcpC4Jv9X+ZSiZidcc2c9gT41s5qfbQx8SmA+NZDsT55HjQyzZ9RJWBV++5//TMwwNbPPiqcr9W5o4IofA1oaAUXaInNZ22Tq97LM1auIXY7DKeheKofPeyJA4KFY7sCikb1F1yZv2JiuMOiVW5AQTIoauVO0VWDkRSjPHacbKLjE6GK+m3uv4Q6wJakUDsUjdFzC54NwyE5E9GHE9qDyO9nJLffPDS61hZ0TYyDFM10x9gUecfhK7pN8H5svl6/xCYyS3zOMff6fLJmwJgP4LTuNGYYLQEWhy5v3KlBpC4jnx9goiLMYfHsWpYPvUmrNvJ8ReMrS6uWAVuCluvJUK773AcLZ+V2Rtp9PeWJBiVuoGscs5agULnY3wOqc0l3TI/UXAWSiMCiGBlcV4yyH1JY9CV+5GNNKBCJ6Td7OAUHdG+nF7jXoS10CuDOe+GCkb3pcsHhdzesJns5BeanVqnK1ImAJLXf10rAla6Swps55D5ZNrX2+XdjMrUA6clSvfyYcnRhFb6n11FRgOAOWWgJbVMAY2Od9kpcLWHKs3icYPFN4Z95lCZFjeyw8nB4pNjjghldvwoP9AhtKq+EoMHMhD5QZKhmkfvbd+na6fhbNkpBl3jCS4MsOEU+jPo3DxQg/LWHL7lqFD9A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d652801f-f381-40b2-910a-08d86252fa67
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:00.2565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /N9fmjDJL4yfzyQnWSHWglcdRdd1Xt4O+4bwcqVo7KYB5Fvls3OjLWbC5syLV5qaP3r17g3KqT9TOUSh9EsSIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently DSA assumes that taggers don't mess with the destination MAC
address of the frames on RX. That is not always the case. Some DSA
headers are placed before the Ethernet header (ocelot), and others
simply mangle random bytes from the destination MAC address (sja1105
with its incl_srcpt option).

Currently the DSA master goes to promiscuous mode automatically when the
slave devices go too (such as when enslaved to a bridge), but in
standalone mode this is a problem that needs to be dealt with.

So give drivers the possibility to signal that their tagging protocol
will get randomly dropped otherwise, and let DSA deal with fixing that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Make "promisc_on_master" a tagger property.

 include/net/dsa.h |  6 ++++++
 net/dsa/master.c  | 20 +++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d16057c5987a..46019edc32cb 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -84,6 +84,12 @@ struct dsa_device_ops {
 	unsigned int overhead;
 	const char *name;
 	enum dsa_tag_protocol proto;
+	/* Some tagging protocols either mangle or shift the destination MAC
+	 * address, in which case the DSA master would drop packets on ingress
+	 * if what it understands out of the destination MAC address is not in
+	 * its RX filter.
+	 */
+	bool promisc_on_master;
 };
 
 /* This structure defines the control interfaces that are overlayed by the
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 61615ebc70e9..c91de041a91d 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -259,6 +259,18 @@ static void dsa_netdev_ops_set(struct net_device *dev,
 	dev->dsa_ptr->netdev_ops = ops;
 }
 
+static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
+{
+	const struct dsa_device_ops *ops = dev->dsa_ptr->tag_ops;
+
+	if (!ops->promisc_on_master)
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
@@ -314,9 +326,12 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
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
 
@@ -329,6 +344,8 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 out_err_ndo_teardown:
 	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
+out_err_reset_promisc:
+	dsa_master_set_promiscuity(dev, -1);
 	return ret;
 }
 
@@ -338,6 +355,7 @@ void dsa_master_teardown(struct net_device *dev)
 	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
 	dsa_master_reset_mtu(dev);
+	dsa_master_set_promiscuity(dev, -1);
 
 	dev->dsa_ptr = NULL;
 
-- 
2.25.1

