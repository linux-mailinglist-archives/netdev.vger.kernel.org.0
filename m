Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEEF4BEA1F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiBUSEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:04:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiBUSDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:03:03 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140047.outbound.protection.outlook.com [40.107.14.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDF7B53
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZRZjO1yQLA58y2ScFOHwcBU2g2HbAG1xWzS4oFkjHyOmPl5+dBdzza+1qQuAjev3mKqhgbn4kBM5i5wJcs6PuXo3X2z6ExgndWWRxBAD1TNfDF8bRsuyKqI7U8SebR+GAiEiQS+gL5CmqZ+l/xpFqE7NwMDQAZ23Slsb6xomi3t4s1Oc2HYvag/XLclW55GxHh6DOXdh55skDqGhKLgSdyLwfqlLTBjCysxZIoupH4rKfPqzHZ/qjXeluxydHKllFLt1hqXda3zD9HVJRcV/D5PCrjMhWPATEQlU4YIz0VoBXfMEUjUx0zhUgr/Ffryl/7C9H4rwV/7HPV4IZV2BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bGnkVIuHO8L8oW+8lEyvQif3nMzzU7Rsdz+FuheivE=;
 b=BpPH7Te3rW0zX91jp0nA7rl1gLxyG1gJm+eTTuwAJXweQp+0UQs80StUGE34z96+PsSut2Y1WN/Pgu1nneY8IBV2fJBrAocB0UrBAWrXuzdjAE5xMzD1BoPtBAYeR3l3jHcCcx20lj+heboJ7GkHL0EpPXt7rhIXXTlqlnhaOAM8+jmiyZ3ZDnBwMR0+VPk0bi99/p1JPREhgsIpf7lRKKaNPVSlxwSP82IM1jhkVYK1kGP5lpwecjmd1BqcWuAwqJ1T5JzMJP/RGtRCKzzSJsemnvqOVwDFbfULpLoEpBDCVbLM7L8qwJDi4B8LwxhpNKzNp6vDdtE0+zokkYc8JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bGnkVIuHO8L8oW+8lEyvQif3nMzzU7Rsdz+FuheivE=;
 b=kLmi9C/zyNzsg+sjhM2Niz/YyVrt4lgi+j+omP6XC7JnpFlUBb5RHEt7gnt/hsRvKHa0sTpNdYCBre9+Y6XThyutNT9DID/3+ut8sasT7YkciVBfhnFqSK7iKMbjayrGsDsQijvKmbSPpXPi1Hw3Kp83N654m23ZeVi5MJEXpPs=
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
Subject: [PATCH v3 net-next 07/11] net: switchdev: remove lag_mod_cb from switchdev_handle_fdb_event_to_device
Date:   Mon, 21 Feb 2022 19:53:52 +0200
Message-Id: <20220221175356.1688982-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 719ba417-5487-4936-356b-08d9f5632b60
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB369301C9948E14C753F77889E03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mrq6aTJbxPLrdVQzRxVupm2ha/TK/+p5RdrR/TyhGNQfbFa4YExUZy8OaFlJeMrIeIcOqSmJ2QPT3+BNlN62iwNWIxFdAd5XEHguk5J6UwompkZSS6wOQzjiG1k2N0vEX/jz7J9581N/dg5A45rpAqMeF0qZbaWijQLMAns6yCGxQBR9DS15Tt4Nt7i3n48nUE5dTfQnXtYDKfTs/xDkx8S/3OqkgLR1LWvDuytHJ2q4vfY7StsR/s5zwUzKY0Bcg32ydyNgoMB/XNKXQrQeTQVP+aqZa4+ALvRtFZq9wpZYaudLwNMq3v8+Kw+JzC+L/orn4qH+i3Db2GwtgY4tnDEOEwC4y4X+0O/myxersIMJ5Pqgaw3poo2c0iyXT/OrBOEASMrSo4bD87bJiyH1Wfa7bV2SwPKScJEsC0GF9XOzVCTweeo8bEJwUPW89KiFUqcWBE4Juz8PH1u1qzJ2uNBx0cgqg8Kf+Z3o4TcAzYvugbJKoj0LAWhoN0QEG89PKNm38L8FF/OcZ91ZUKFwIo0kTN0CrvrHwRCjEpw3Ebqe97b4YJRgprFaez7T33sTIIAPm4jtbHfbw4C70/aLJ1RNXhW6h/yczM0W/QvkcXOkjFNwHFYPLD7jG1B+Su3C/1E4d2+T5Y6YXu2O8fCMxI/3jwHZSBeeskc2/Y/ckYpQPOiA0ZHra94mRCn9JMOkk9AMx2qbrrwT+AHeOK1v3sWnRIvBoxtjEt01NLPb+Bkx4S+cBdOs6bS5/VOF0GiBq+3/lWZBT/cBjfsrHZoqCy+oEHWjnPlFfCuAwJcz4g8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(54906003)(5660300002)(30864003)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(966005)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UjzcCCZw6x9/dQledgMgD550djlLia5kOeA5Pf3RJwJrlOTQfnHkbtVaJXcN?=
 =?us-ascii?Q?gBYcbaNy8KqOLK2GrPwCdAI2fw9ImY/kBWMJlANc0A2X4Sk/hD95c4wQm65r?=
 =?us-ascii?Q?e6O5K9ReeuCmndm2KvlAz/eugbdPbUKPKgcilXkj++G3i84aiIYdNFHdC2NQ?=
 =?us-ascii?Q?1HH0+/zvFJWfFBsAnlZboJJN3lu5RDBnBc59d/T66rjJ37cb4kIUTQAL/pcZ?=
 =?us-ascii?Q?DxJj+Qn6xmVdzXcT/JBKzjz+AQlAwUjvTgQ5Pvt4T/1wRMYnubbwtjqPp/u4?=
 =?us-ascii?Q?QluI+VLjfXwPP95/P/udacHkhJBDNP5Bfg3k5nmRz/f9t9mxPNU0H7O3S9/3?=
 =?us-ascii?Q?vVlCqnyjOXQlLeDT8inJUdtAnhEE2zeuwrjJ9kLNM3u9PwA2S4ARQVUsjL1d?=
 =?us-ascii?Q?fMovGlFInI0Odkq691Qmh4qBJr6FpYUFDp31TG79u16r4QaMKttuwsgLCqus?=
 =?us-ascii?Q?WSe2hShi93amuOkWjNSydi8mIf2CueyarSdIupPI8N/fU1jLI+RqwnDvgi/I?=
 =?us-ascii?Q?mZL6EBxnelmSSkqinBWzZh5v+TidDnHExTNhsIE9ELDb4a3GZrHZleoAc68d?=
 =?us-ascii?Q?FrwcpLT+MNj2V6zgONVJ97lJwL0DlmafBW3Yq55qHMN+G+UA93Y8/dKmNjjP?=
 =?us-ascii?Q?hzzEbRaX/lP/eIM+P729M6aT6vKeZGmoTMcBCX4AXp8BteOROY1RRUACOdv6?=
 =?us-ascii?Q?PTkpOveZTFnwFJJtNyDd5Ib/m25nHVSAbzxb4DAx3n5YXFs++R4hnRCgYcBI?=
 =?us-ascii?Q?tobDMuLJN54WdPJ0uzrbpC32dBAYF8m/xZCAYUAc55RGl//lIeFupFlwlKmj?=
 =?us-ascii?Q?HTjz3OTgfQKf38/ixt98AwCykd0QufBn+cdGlnLJHcCttNswK0edLo3NwQpB?=
 =?us-ascii?Q?oWBbBykedSG2jQwkngdf5QVwaHfbRzXXRP1LHez/BPVYo9geqtILf8kWivod?=
 =?us-ascii?Q?y0q7MnNlNjmJ1XBl+dJJqV3JOvXDUgW0qOjPeG+tm6IMpqEFMTo2L2DznWLJ?=
 =?us-ascii?Q?5/e4UtzewJtYhkvHVvRI4CUQ/NaI7GkS2i8KRPL4H8ZGHhTzC2ev0XFG2eMc?=
 =?us-ascii?Q?bUwTxbwIm2JmOZTEnO5IVaYhFmPJdM7brbDSkVZJ9iuUZOW57ihjOJgAvDkr?=
 =?us-ascii?Q?Va763xueHoeZ9moAYy+KHbqUJCulY63kQqs83P+HLdczaoMHO5satYT+jGHe?=
 =?us-ascii?Q?RIytN68c5xF/wwSvRoYn53eBKy/Ji+VrXbIk3z+Kxk/nKzsARjjEW59KXzcX?=
 =?us-ascii?Q?mjW6b6fgJDWR6dPWRW3RDMiP26ug5iIvxCu7Us8GAqrlP+V16jAghkEmyTJ1?=
 =?us-ascii?Q?ncVPM0GVQFI8pIJdn3RLRDgUO9Ai3Of7zqKFStJA1G7HQeckqxIQQSoGiEr0?=
 =?us-ascii?Q?ZuO5sHhkhHOkaZB3O8hZL2oh+fkwDo0OFBYcTkvvPH1HicrloJ/gqEI45/Tk?=
 =?us-ascii?Q?Sb/YEGsw8HpFS3zCD4Ypb4cXHii1wSBhTGxiYhrLGVLJnGZqPvUT+Gb/ezr+?=
 =?us-ascii?Q?T4/1kwzUNQCoo5qAGfFU278nKj51hd74KX+Us3CQFg53ntAzuQMlHAmso2cz?=
 =?us-ascii?Q?a8ODqBiNPz87uofQFIG87KR6q/C4xTxnJtfbCxKtpzMHAZPr/fCffsT7sEp7?=
 =?us-ascii?Q?ZsZ99pyJVI0J1Kj9CPklhGE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 719ba417-5487-4936-356b-08d9f5632b60
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:12.9491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6IXqZeiRFv7D5eWzlBZrMwtnF+kz1kxkZ/9QUgaK0n9asN+Z/wtMcfNl+YKfOvEL8N5bKuhXv4afB8N+1++bdw==
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

When the switchdev_handle_fdb_event_to_device() event replication helper
was created, my original thought was that FDB events on LAG interfaces
should most likely be special-cased, not just replicated towards all
switchdev ports beneath that LAG. So this replication helper currently
does not recurse through switchdev lower interfaces of LAG bridge ports,
but rather calls the lag_mod_cb() if that was provided.

No switchdev driver uses this helper for FDB events on LAG interfaces
yet, so that was an assumption which was yet to be tested. It is
certainly usable for that purpose, as my RFC series shows:

https://patchwork.kernel.org/project/netdevbpf/cover/20220210125201.2859463-1-vladimir.oltean@nxp.com/

however this approach is slightly convoluted because:

- the switchdev driver gets a "dev" that isn't its own net device, but
  rather the LAG net device. It must call switchdev_lower_dev_find(dev)
  in order to get a handle of any of its own net devices (the ones that
  pass check_cb).

- in order for FDB entries on LAG ports to be correctly refcounted per
  the number of switchdev ports beneath that LAG, we haven't escaped the
  need to iterate through the LAG's lower interfaces. Except that is now
  the responsibility of the switchdev driver, because the replication
  helper just stopped half-way.

So, even though yes, FDB events on LAG bridge ports must be
special-cased, in the end it's simpler to let switchdev_handle_fdb_*
just iterate through the LAG port's switchdev lowers, and let the
switchdev driver figure out that those physical ports are under a LAG.

The switchdev_handle_fdb_event_to_device() helper takes a
"foreign_dev_check" callback so it can figure out whether @dev can
autonomously forward to @foreign_dev. DSA fills this method properly:
if the LAG is offloaded by another port in the same tree as @dev, then
it isn't foreign. If it is a software LAG, it is foreign - forwarding
happens in software.

Whether an interface is foreign or not decides whether the replication
helper will go through the LAG's switchdev lowers or not. Since the
lan966x doesn't properly fill this out, FDB events on software LAG
uppers will get called. By changing lan966x_foreign_dev_check(), we can
suppress them.

Whereas DSA will now start receiving FDB events for its offloaded LAG
uppers, so we need to return -EOPNOTSUPP, since we currently don't do
the right thing for them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new, logically replaces previous patch "net: switchdev:
        export switchdev_lower_dev_find"

 .../microchip/lan966x/lan966x_switchdev.c     | 12 +--
 include/net/switchdev.h                       | 10 +--
 net/dsa/slave.c                               |  6 +-
 net/switchdev/switchdev.c                     | 80 +++++++------------
 4 files changed, 42 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 85099a51d4c7..e3555c94294d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -419,6 +419,9 @@ static int lan966x_netdevice_event(struct notifier_block *nb,
 	return notifier_from_errno(ret);
 }
 
+/* We don't offload uppers such as LAG as bridge ports, so every device except
+ * the bridge itself is foreign.
+ */
 static bool lan966x_foreign_dev_check(const struct net_device *dev,
 				      const struct net_device *foreign_dev)
 {
@@ -426,10 +429,10 @@ static bool lan966x_foreign_dev_check(const struct net_device *dev,
 	struct lan966x *lan966x = port->lan966x;
 
 	if (netif_is_bridge_master(foreign_dev))
-		if (lan966x->bridge != foreign_dev)
-			return true;
+		if (lan966x->bridge == foreign_dev)
+			return false;
 
-	return false;
+	return true;
 }
 
 static int lan966x_switchdev_event(struct notifier_block *nb,
@@ -449,8 +452,7 @@ static int lan966x_switchdev_event(struct notifier_block *nb,
 		err = switchdev_handle_fdb_event_to_device(dev, event, ptr,
 							   lan966x_netdevice_check,
 							   lan966x_foreign_dev_check,
-							   lan966x_handle_fdb,
-							   NULL);
+							   lan966x_handle_fdb);
 		return notifier_from_errno(err);
 	}
 
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index c32e1c8f79ec..3e424d40fae3 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -313,10 +313,7 @@ int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long e
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info));
+			      const struct switchdev_notifier_fdb_info *fdb_info));
 
 int switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
@@ -443,10 +440,7 @@ switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
+			      const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	return 0;
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e31c7710fee9..4ea6e0fd4b99 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2461,6 +2461,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	bool host_addr = fdb_info->is_local;
 	struct dsa_switch *ds = dp->ds;
 
+	if (dp->lag)
+		return -EOPNOTSUPP;
+
 	if (ctx && ctx != dp)
 		return 0;
 
@@ -2526,8 +2529,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		err = switchdev_handle_fdb_event_to_device(dev, event, ptr,
 							   dsa_slave_dev_check,
 							   dsa_foreign_dev_check,
-							   dsa_slave_fdb_event,
-							   NULL);
+							   dsa_slave_fdb_event);
 		return notifier_from_errno(err);
 	default:
 		return NOTIFY_DONE;
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 28d2ccfe109c..474f76383033 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -458,63 +458,40 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
+			      const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	const struct switchdev_notifier_info *info = &fdb_info->info;
-	struct net_device *br, *lower_dev;
+	struct net_device *br, *lower_dev, *switchdev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev))
 		return mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
 
-	if (netif_is_lag_master(dev)) {
-		if (!switchdev_lower_dev_find_rcu(dev, check_cb, foreign_dev_check_cb))
-			goto maybe_bridged_with_us;
-
-		/* This is a LAG interface that we offload */
-		if (!lag_mod_cb)
-			return -EOPNOTSUPP;
-
-		return lag_mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
-	}
-
 	/* Recurse through lower interfaces in case the FDB entry is pointing
-	 * towards a bridge device.
+	 * towards a bridge or a LAG device.
 	 */
-	if (netif_is_bridge_master(dev)) {
-		if (!switchdev_lower_dev_find_rcu(dev, check_cb, foreign_dev_check_cb))
-			return 0;
-
-		/* This is a bridge interface that we offload */
-		netdev_for_each_lower_dev(dev, lower_dev, iter) {
-			/* Do not propagate FDB entries across bridges */
-			if (netif_is_bridge_master(lower_dev))
-				continue;
-
-			/* Bridge ports might be either us, or LAG interfaces
-			 * that we offload.
-			 */
-			if (!check_cb(lower_dev) &&
-			    !switchdev_lower_dev_find_rcu(lower_dev, check_cb,
-							  foreign_dev_check_cb))
-				continue;
-
-			err = __switchdev_handle_fdb_event_to_device(lower_dev, orig_dev,
-								     event, fdb_info, check_cb,
-								     foreign_dev_check_cb,
-								     mod_cb, lag_mod_cb);
-			if (err && err != -EOPNOTSUPP)
-				return err;
-		}
+	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		/* Do not propagate FDB entries across bridges */
+		if (netif_is_bridge_master(lower_dev))
+			continue;
 
-		return 0;
+		/* Bridge ports might be either us, or LAG interfaces
+		 * that we offload.
+		 */
+		if (!check_cb(lower_dev) &&
+		    !switchdev_lower_dev_find_rcu(lower_dev, check_cb,
+						  foreign_dev_check_cb))
+			continue;
+
+		err = __switchdev_handle_fdb_event_to_device(lower_dev, orig_dev,
+							     event, fdb_info, check_cb,
+							     foreign_dev_check_cb,
+							     mod_cb);
+		if (err && err != -EOPNOTSUPP)
+			return err;
 	}
 
-maybe_bridged_with_us:
 	/* Event is neither on a bridge nor a LAG. Check whether it is on an
 	 * interface that is in a bridge with us.
 	 */
@@ -522,12 +499,16 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 	if (!br || !netif_is_bridge_master(br))
 		return 0;
 
-	if (!switchdev_lower_dev_find_rcu(br, check_cb, foreign_dev_check_cb))
+	switchdev = switchdev_lower_dev_find_rcu(br, check_cb, foreign_dev_check_cb);
+	if (!switchdev)
 		return 0;
 
+	if (!foreign_dev_check_cb(switchdev, dev))
+		return err;
+
 	return __switchdev_handle_fdb_event_to_device(br, orig_dev, event, fdb_info,
 						      check_cb, foreign_dev_check_cb,
-						      mod_cb, lag_mod_cb);
+						      mod_cb);
 }
 
 int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event,
@@ -537,16 +518,13 @@ int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long e
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
+			      const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	int err;
 
 	err = __switchdev_handle_fdb_event_to_device(dev, dev, event, fdb_info,
 						     check_cb, foreign_dev_check_cb,
-						     mod_cb, lag_mod_cb);
+						     mod_cb);
 	if (err == -EOPNOTSUPP)
 		err = 0;
 
-- 
2.25.1

