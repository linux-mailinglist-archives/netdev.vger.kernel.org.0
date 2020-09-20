Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679A82711B7
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 03:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgITBsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 21:48:25 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:7847
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726880AbgITBsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 21:48:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TH0R7pD0gX6E4m45lD6eHRj/bfQgSnRvOGzWUTHWAZCeSUtMpk0uai8zFgDo3CVYca/h4bkcDQ8JdJxEtnaIW7hngcaeqUmULRrOJindZniPdq3mJb0uncLIdzxXTu2pn0BjB/qIDnAfLfikh7EaG4JF9QUfbqFOThOQYVKkpoMyP7Ov1rZ5YqaehZrEucuNl9ZSEXCmupyzs5fQI14lEYof4GbGtY4O5SYNMabOeKiy4FIaYxi8xGrD7S8rYUydnZgNzxPRVneppCTAwx4S0A0vO4DJFCsHTYEGnKDi/hW3yQ//12tfiEjrvLf3nio9876r2Ng1uLRrQpLxwDWGwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpiVlSp0HoeMKf2L0Jk4VpDJZXO2MmuiX3kbhBxnS1w=;
 b=iN7oELsZSGZ8Jw9MwlW/P4kEiXyS6oxgTLLj1LthboSYIZlRFiTLUU6ks8HVf+GuHSoioyCkrZQjmqcZicJmAQ/FTskwe+ME7APrrW7oVqrsCzFCr3PYZKU+1aghKkTerjYTVM5iy8/SjCGCiDYsYWgRIP9JQCvSsQDn61SeDkpMglc8nw5NoOkmrCbZW6g2NnqabH0NZCGzou6gKeixHbBSR63QAlokKRH4rq/rcvJKii6hlS4aDSVhgMzPiG4TqoqD0seqTnTngRjFwRTZGXfDAKsearFUJKbqdVFNCPUZemPJqqr7jWhPgwM+D2Q7utLBWvQSwr2A9jeLD/TB9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpiVlSp0HoeMKf2L0Jk4VpDJZXO2MmuiX3kbhBxnS1w=;
 b=EBBfM9kztmMPENZXTdyFImTGF3620WHfdZTKmlQkBpUk+njPl5MYYcx3ym+utY6VoFNlhNGu7Wmo9C6+bcpN7+DLWrKbVIVD0oQ/NsmTrPg/9NsVNUiajizPL54HzYo9bzA0c+JUa7Nw/HgzR8bDDknuUplEvnaVstNP7y1jvtA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 01:48:11 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 01:48:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [RFC PATCH 6/9] net: dsa: allow 8021q uppers while the bridge has vlan_filtering=0
Date:   Sun, 20 Sep 2020 04:47:24 +0300
Message-Id: <20200920014727.2754928-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Sun, 20 Sep 2020 01:48:09 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 991a5bcc-9c1e-4ca6-0cd5-08d85d073add
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0401MB268642BA11F52B2E75223414E03D0@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BkCIR5AE48O4d81h0uKjOID2OuvL1Ya46+jqWYTS7hOyTtqHJ9uFEzRtgFGPI7aB/w8Ae8r9w4w1JpUM5ZQ6rm6Ae1yywAItLV9lfAPwGKoE9VtjgP+RKbjzwd91ejmGP9txkYbV9wJGro4dp5Bl3MJ66m7z2oFOgD+J3S/F0ja2/EE9jMaVCzaxFnjcSQSHyxYMn3nlojxLF1Wl1JfoTqi43cGIZxJKiOoit5tuZtp913ktnkLwEnsgzCYPmJjDuVUzMGce5ooq/AjkZZlsfBAJcnydxP5xw2DCscP66BX6Zghm1gpcgby4GQuwvgQMMrOCeYWGPjMKIGG5q6rE1/i+KNxt0VxWvLodAfdal7V8Lo6sUIKQ4tyiY2rtmwWn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(4326008)(69590400008)(86362001)(66476007)(66946007)(66556008)(83380400001)(6506007)(2906002)(478600001)(2616005)(956004)(36756003)(6486002)(52116002)(8676002)(44832011)(186003)(16526019)(6512007)(26005)(1076003)(8936002)(6666004)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: X6jx95jVmSZVpQ6L6kTiFgH/URbZMYwx6Yli8UEkHcHr1E2iEHdoa4ebBEASrMkFkDXY6Y926qvkXzouFg6rT/5M2XdROx20ul50hPBFg2U3L5CvR/QLJd4c9fcnykQh/T5y44kcAbfeXNYcfAtW/J67Bz997m0jo9NK8CEhuBhkPnoqAwEK/BKs66CYpRptK5VkS+hs48U8To76yS2SlqTBYCyBOwLPKCqlBCfQ1f6I+wiTb3IHUHZQhJHzLQGV39dHO1pkhclonODkLjQjesQc2is54bm1O929Xf7b5IcIjfHl1Vrt8jh1v0d6cF4fR3Zwzj190yRMdLwqmZD2oybYsLv+0phoaWANjtqpIMzCbpn/UQhppHPi2KJWmCJd0dX6fSoU68A7EWGXVA4K+jcZvb20lr4hHT7+L/I3qQKm2uTqiJn8iMRP1lBUyH2dPYHh6XS4ad3k1KAc2QP2LS5sN5HLLQ125X3mbeWtfMxPRzgbQ8dfreV66JK8VSu7rM8H6KaMzo71pvDE9e61XJaceZzmDaJE75WlMtaj/J/FHg1xr8KZWsiRIWJO/quzanv5FyTijZmCfwSUy+lvcA3aVXjS8xw/QWT1S8h+5Cqo36r6XO63Fank7njt9tu7ydcrEnIFy5P35/sKaKgzzQ==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 991a5bcc-9c1e-4ca6-0cd5-08d85d073add
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2020 01:48:10.8383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICBMO6UjBg3JMaZ4uc8C94zqt0FzuDmH0Qk1/DdrVY9byMpSRX1Ix2Zvcbk0fwlXwzXSUGFtKImNVMhc9zj4lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
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
---
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
index b88a31a79e2f..2de0ff18f2f5 100644
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

