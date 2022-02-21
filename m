Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A4A4BEA2C
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiBUSFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:05:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiBUSDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:03:09 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6188065B3
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvMOAxedNMfBesJOXjha3h2Nj/0tkOytbuxXKR8KiN18KT+yknSkovoQ1sdBVphg+Dd9zBWHHjJNR+06Hn046NQWNFwakM/YN1VoeSmGxWWuCQBQp4C/iLA36UkKPeIbMjPKNqCIamU0TlUl6zkI1Xpl+/nqJ0twswUDc3+1gwT4bzqUuV6ck38vjokChUMeGKwblURIFvKZpRZXv0z5gut827//IhXXVsnrmnzpYtfB3Mr7s03WyXh6kcY5mCtiFlmY0c7bEmeIef/I91qfLeoW/9rsMhLGSlq8Vy7CiOzDb7rPivAc8lM1W3nlwTVKeeTDIHQAYUA0AumOYc/YRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0Ij1IW2iOF3KoEoy35y0lzDvg7yHK2umBYwSBWlavw=;
 b=d1TP60UojNcQRDfoFtInvEa/bGiy37vCml965sNyA4a5aALz73B2xH9xsUWJUUVtjNKc8mh6FzoHWgfx5qX/msRpAcKXSNOXfEtFin1+/8eJ+V7ggFSTCMiq0fneFcCk7K/BzLLUlxsFLkg+ACBlLbrSp6s9K4/DTZY4cZ85OCQwzhq8jsRXpN/2quCrroeM3bYYEvfIuS34qkxQVTgyRJjexqLshOXKo59S/wpFKkbexiANFWl53svr2TmsERqA6d3hWXudQINUSOkit5NJk/4C3SWlYl5Gj2fB13b8bCgA/KPNw1ohzj8hwefL1a3ZzPA16XebOyx6NCieoQBWmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0Ij1IW2iOF3KoEoy35y0lzDvg7yHK2umBYwSBWlavw=;
 b=YbkSi9X5IlW9T4YteJn7TPsAT7x/MUs/ZHc6PO38D/GxCweMj9LttLvrTnLS0jVgfQOD/ZiPHBBo+jbgedieGW6fywuS7rYlZBrdugrJyvC9VtWzfdl4B8+PsBMzn0eBsI2j6L1aO9Eo+NYAtWUnvVZHpcXVoeJ0Q8QSKn9fgzc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3693.eurprd04.prod.outlook.com (2603:10a6:803:18::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 17:54:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 17:54:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v3 net-next 08/11] net: dsa: remove "ds" and "port" from struct dsa_switchdev_event_work
Date:   Mon, 21 Feb 2022 19:53:53 +0200
Message-Id: <20220221175356.1688982-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
References: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 907a6fc6-10fa-4872-cb28-08d9f5632bd9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB36939E8C0B5AE3C7995890D8E03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GqK5LFeV0+x2xcFLkAVFdAKXFzoBU/MYlL7/+1UW7l3T+mkpzLVQTOFV8Et72yvrA/WvXwQvMlaytwWonoWhk+dQMys6ZkFES8PuFYBi9+zYbb20cB+1vKIvfEhACIb4QCdw+ppiK7N0XgiDpZ8vhCXd0Q7dwrrF++4xM7AsL5cdgNAHine3R16SBqvjG0bsxKZ77lKCkYHdDMs8jhDQd69O6CsLnUKICgtx3clZaBUEkQpqe85gLrV0Ctku6tFI2/nkwxPym3XlQcDk3uvzxv8KnPG9IJeKQTNCl7+SE7llGzxlZAu5oyWpLtlfrrKgeuBoern6ciba+4IV6nR2KDPdnVaUIpaaLYJ1YhChNtB2PvvNadSoi15xjEEoNgKbBBf57l4UmtlTgGiaXsnmWYlIkY7HE7s6BFcxnIb5nU6nAPuTganRAHPCR+a5xaUEZz8B3OMushjSk3xPvi3WHZwn1qU42veMi7+0d6Ibs6SRnZrcUgcDCLGPlbgWmDLZ/n2JHbH14fL3QRBsyuFjbhbbyTEZ7UvPLqllTNmF4CROO1xRvE0RGkjJdOgBHO98Hw+SIHZLXuYj7csvXtCTUwj8gb5nobbJ3VMsblM/HUD54xFq3ko2GQkdjMBN6E0oPKyl/XGzB6dOOUlLe4QgD2G/WtVM76ALdzF9ioJXIroMn39j5/al6/ASBROM8FCfVw2slaaEU8maBQV+yv0/wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(54906003)(5660300002)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m5T+6AwTOjqEVGr6jz5unckXW5AlxD6icv8hMfBXO3uia8tRpZXRanw4a0dL?=
 =?us-ascii?Q?8KOSvTK1sJuJVzmcuUTRhpvGkHBr8k9V7hEdnh0FjCBGQu7wyA6AsCe+KPhb?=
 =?us-ascii?Q?kgUvuMmNeGlDrCX9h3r9qHfs+3bbk3cvu78YdAoxdWiulZpXJgFaKZhNdxgV?=
 =?us-ascii?Q?GUIp1A/pWAHP+AwQ8LGrOoXl2AP8/yt805R9OxjUDg/h3kgiMmeEPAMsK+I5?=
 =?us-ascii?Q?kfLBVWYS2Zqu/AZ8lpDdM/CKjyQRoPSYF/XF6NBqVeEUKKrJLcRUJKzVPehf?=
 =?us-ascii?Q?e6XJikn2bEEZxwgjuN2th0JcawA9wFvtlYjIFBiv5a79xFcn0CGtDZbo4Qer?=
 =?us-ascii?Q?r127Dakui94rFHZunaUnX7tJ2EE+ooEGTz3gQZHpCFxcgX7WQQvyGEPrnqRu?=
 =?us-ascii?Q?3oNVhM4LUX9nRklm3tVjIwYM1Q51OfdSfKi3npTZxnXVesLwG8ba4sxIXrHq?=
 =?us-ascii?Q?I2Uh4FTMcW8/S4i4uFY0TpK/kcsVaN4kFjF5Jke0YsjXn18qJOTgvTDqoPXU?=
 =?us-ascii?Q?VQMDfnX9A6x6IPhto5VRZQ4/i3mn2QnwzA3mExZGY3hdrvuKg7eJaRP5Ze9N?=
 =?us-ascii?Q?w5eqw62UDOqyl6+GuqRwdkTAvqNW4vwig9W1LKwwdNzI1Zr89SqYmJbAB0ys?=
 =?us-ascii?Q?Hqe4IxG0XtxSD6yMw3m3Ptc8dynylaZnmRFG9F9UdftWMC+oPQtTOjv9or1Z?=
 =?us-ascii?Q?IZJcm9jvDtghlCV3wR7E5yZNvbOpZ+WShWKGQ4yR/LiI5qZoqxVZ05sr/wky?=
 =?us-ascii?Q?RKv9PUY5GD4lvXFmvr9copRrlZijoq66FHfSwLM7mXOCT3JFHxAJbIkvSCv3?=
 =?us-ascii?Q?klpsXLFID/q7GrJb5jrJ0JvtvYOh02Zld8AP2vGeuBqwEhp97v7S8XceeXX4?=
 =?us-ascii?Q?T5WTAThJJcoCJ533TFfuovxPBGcLowcvm44TuJA88E5mAuYhoyl9Zs4x8gaI?=
 =?us-ascii?Q?KpZe2j68fokarZmF6WqLvTgfYjYx2Strx5808QPF+f+jxiRPJXl8aa1QZPXd?=
 =?us-ascii?Q?+m/HMWq9EZZPHaPEprGOzbAwdxcP1rJSjVleFEytSdJnmZn8psOgpRikLwXx?=
 =?us-ascii?Q?R0AbPz1XpWXxDfO9s+yOCVIZD1kLp/s/5Q4KVO/dPzR8J1re295reRyDea7L?=
 =?us-ascii?Q?9HQWXiGdFLbhabn/nU+L2uscN1+Fe5gPTo0kmdegEdRdoLDgRsZPG6PSd148?=
 =?us-ascii?Q?XJxaB80k8OJB5pUjjYLSd337uIDoUtTAfBzmfZ2eCxFieo5l82FWGpVbgPEP?=
 =?us-ascii?Q?P/RWF61Jd/U8tBrcvZ6iHTMM1EM6wDVUOUL7Dct4GD/MDcuO4idhqVYXKsZI?=
 =?us-ascii?Q?5w+hM995fzBcXM1H9+XeaNTTi7D4g3jwqGEvd0GpIqqae+5wNfJrC+V2DO/Z?=
 =?us-ascii?Q?TBApcE6X1RUAlpjiunvh5N7XYfHN+h9D8KouZ7o+0xWpZXuljGAKKaeaffve?=
 =?us-ascii?Q?HSOPmWqaNr99YWGaempNKKXPezHm103a6lyndLj5YID/jCoX8kfucVNBOWvr?=
 =?us-ascii?Q?99u6ZWSqB93GpCB0qdJhcPRelK6iUcNYgznxJ4GLz98oQiLmqfuO6w528SvM?=
 =?us-ascii?Q?EcE6NW3Bkt1p769GuQiaBXIylzXy9G67kCRJYGoqFnounn91hg7FkXqrJh8T?=
 =?us-ascii?Q?UW4jqqjKV60+b+xPHgihelg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 907a6fc6-10fa-4872-cb28-08d9f5632bd9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:13.7459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWjJsX9m3dGDA668RcOTDtU0iOeKOKH0yHuKyOuZmApeb3R/NLNYU1YIkeJkmubzxxhhaSm9Ecoj+jAU5mVOMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3693
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By construction, the struct net_device *dev passed to
dsa_slave_switchdev_event_work() via struct dsa_switchdev_event_work
is always a DSA slave device.

Therefore, it is redundant to pass struct dsa_switch and int port
information in the deferred work structure. This can be retrieved at all
times from the provided struct net_device via dsa_slave_to_port().

For the same reason, we can drop the dsa_is_user_port() check in
dsa_fdb_offload_notify().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v3: none

 net/dsa/dsa_priv.h |  2 --
 net/dsa/slave.c    | 16 +++++-----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 8612ff8ea7fe..f35b7a1496e1 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -119,8 +119,6 @@ struct dsa_notifier_master_state_info {
 };
 
 struct dsa_switchdev_event_work {
-	struct dsa_switch *ds;
-	int port;
 	struct net_device *dev;
 	struct work_struct work;
 	unsigned long event;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4ea6e0fd4b99..7eb972691ce9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2373,29 +2373,25 @@ static void
 dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
 {
 	struct switchdev_notifier_fdb_info info = {};
-	struct dsa_switch *ds = switchdev_work->ds;
-	struct dsa_port *dp;
-
-	if (!dsa_is_user_port(ds, switchdev_work->port))
-		return;
 
 	info.addr = switchdev_work->addr;
 	info.vid = switchdev_work->vid;
 	info.offloaded = true;
-	dp = dsa_to_port(ds, switchdev_work->port);
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 dp->slave, &info.info, NULL);
+				 switchdev_work->dev, &info.info, NULL);
 }
 
 static void dsa_slave_switchdev_event_work(struct work_struct *work)
 {
 	struct dsa_switchdev_event_work *switchdev_work =
 		container_of(work, struct dsa_switchdev_event_work, work);
-	struct dsa_switch *ds = switchdev_work->ds;
+	struct net_device *dev = switchdev_work->dev;
+	struct dsa_switch *ds;
 	struct dsa_port *dp;
 	int err;
 
-	dp = dsa_to_port(ds, switchdev_work->port);
+	dp = dsa_slave_to_port(dev);
+	ds = dp->ds;
 
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
@@ -2497,8 +2493,6 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 		   host_addr ? " as host address" : "");
 
 	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
-	switchdev_work->ds = ds;
-	switchdev_work->port = dp->index;
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
 
-- 
2.25.1

