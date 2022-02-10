Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF74A4B0DEB
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241841AbiBJMwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241830AbiBJMwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:33 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E65264F
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqtzd0s+/4EtZYVu8Sa/c3FqFDbHH+CPYWYrsw9N7x/5yVBvHcCNRGhR1GP+BL0YOhiXnmXd4bmtyxFygY90psezRwuUpTOwfZBhCt6mf8cA+Yr75xcB2A4tQbuN1Rw+T/xHpie1r94Vs5euWwcg+ufW35N/6y1B5jYg0Pnw1P8db30+i3Ivi8GR3rhPxZgqv5cMySxL8tGw3lSs/aoXO05l6O34G0+wokDXcQAirmre7uAmfrb2RYwH//+IbVi5k+rvB2BDIxMDnMtw35uU3z/LW1V/0/ugNilH9QoPBXFdVDPPH1npHh0CIdOgF5pj+RcnKpx0lejRK2SAKrkCzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPflwoTs2wRabrKq5g2N58Wxs14N4onJ5rQHhiroxmk=;
 b=fq1DqEsJx1ZKgtaLafI2k24DyT9B+hoRVB30VOvuAjQzIcUCWs2qxnWkSOucP/WIP0GjeKhwkFSdeyBHMI9iB3TtTexk3/NwgDD1wK9s7YVVQxHaJiBat8R/f7tsKh7YcwDpo8v39GbJTMHAxJnbgxracanvACPPdhlC4yWyUr4AaM+OhR1vVi/IcaapmU0DTCTsCM+sM21ub9qdPkHvIMbeVjwnsYKAT5qVgH40ovR03DKrwp90uj/ZyzFf4BhFhWGRo0YPQB5LBjvsg1n/PAELdgcC1Y0CHhYXTA3IyRdAynTiRI0apqZnpTV4VGy/xbdtnNf7BifpGFJ7QVEUsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPflwoTs2wRabrKq5g2N58Wxs14N4onJ5rQHhiroxmk=;
 b=MTZi6JB1518CCP0DFq9/rc5cpAGeQ5iz09iA9nSnyQZVsnUrcZtS3sLt4t08SEROcVyoEvRCqfrfdwQhHl/gpSwXJLmQAFEvfr1ISV8BcqzhzF683e6QnBXSQWEQ31M1w8Hm++DXa08cy+gdTDR+Ei81tjYn8UiCPdib1p9dCLQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8806.eurprd04.prod.outlook.com (2603:10a6:10:2e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13; Thu, 10 Feb
 2022 12:52:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 10/12] net: dsa: refactor FDB event work for user ports to separate function
Date:   Thu, 10 Feb 2022 14:51:59 +0200
Message-Id: <20220210125201.2859463-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fd183bd-e441-46b8-9d5e-08d9ec94319f
X-MS-TrafficTypeDiagnostic: DU2PR04MB8806:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB880658C2001255ABC1FD4656E02F9@DU2PR04MB8806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: itGY09CrgsNLAfFRQWJftkwyqbS8njueJTaMJEAzz9gLjEDp6R+3cbpoQC+Z4CdN1zFDy4yaQl1jgUHM9mnRHF4+h3e9fLvO83NgQKBNSHXrxGMmKYjWkgvqJYv2REt9SrEzYAUN90PzZgsbh/1iRuoH2tO6atOD4xf6ksAon0e0iM5DHXKzS7xqjZtAZ8TS0YyXnBCWkxKOiR9ENryxderOScZiZCDxWtnya+aCLciGdVvQ+K9RCsiPd6MW5noqHsWBe264jLR6hINIMu3A+o2W3QtKCQCT/V3tVVFKpsFrYHyQMbO5M0TcTTocOr4qyIQgcXx8KaGIfaFG6msV+JScUuELvkQZ9FKuWcawVTrhLo9iZhIfNk9q0NeGcj2f1A5Lb0kTqCfIQNpjCRlUWFThna9hrGnmGsvt5P1+H/eFwfMlLqDyUGjGWiaz0oR239FJdGo99zAG9lLn5YfVf6+yMneb1eFqOypu7evCxcW6f3wDB2DuG1TfeLCN5AJKptygNlqKGmcDem9hQhazQH/g21iOuwCK14jxGInjSYtTdBu7GpUliT8vH5ibXnyqMtFEQK99HhvLN5RaXFkHo5zQ6ntqodcxRn+NmD3+3wtipTtRP6wSbDJGbyRym9WqQehC8X15KitayInT3BvksLxvQCe+2YIFKh5MGUed9kufY4YLosGrbdiPcFiFVC3CuaGyMNgTeH5g4Fn4QlBXig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(38100700002)(38350700002)(66946007)(6506007)(6666004)(6916009)(54906003)(8936002)(36756003)(6486002)(5660300002)(8676002)(66556008)(66476007)(4326008)(7416002)(52116002)(86362001)(2906002)(6512007)(44832011)(83380400001)(2616005)(1076003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kf54oHdSgX+hVumChGq+o0e+WGmGiFATCFbG+3zPu5vingyIPevmLeYCcKM/?=
 =?us-ascii?Q?BJcFDgmBhsMWWQCjA5/TMoVRo1oLiaMKQrq74Af7C6JMQxDDfKjAXQak8zCN?=
 =?us-ascii?Q?rM0bCRLWck5nEh1RNANYbxKkz6FUA17G0GXhAix0PexxGIhdGVJNaYCedl6c?=
 =?us-ascii?Q?7MYi1NXx9Oxho2nUCgYn959+nmJHr3fLsQfkU8FjzlZbb4XmVnKNZtOeC7fm?=
 =?us-ascii?Q?3e+ZF+J4qmo9OztYjlx542SpR0u1Nn5UFLbZmZXPB6lZjX2uOf/SUKEMIVOC?=
 =?us-ascii?Q?MXRvfgL2NX4/4k4Ou8uQyLLS2JVscucQwhepLVb505VAmoMVv/Gvxwzu9FOg?=
 =?us-ascii?Q?04RrDgjQMQ7R+7zsDs5Hog9zGzMAAXeBiP3TO+jM2s4vBfGxyzObDm6J9M1C?=
 =?us-ascii?Q?fPtHbLgYG1E39ZjJkbG4Ci1r5ypw5S9ymMlUEVbUrg50r++dfD6iHZQRBC/g?=
 =?us-ascii?Q?wc4NNbqwPu/JBRBShoKtlb+wgH4PV7ElU9GdaU5xNcqpwJnuX/RrBRCbi1IL?=
 =?us-ascii?Q?z/RXVDJ7xtXNMC/8OA3WrMxJRsQwRcY6KQJlWFHmj5+7aqwBjuXtiSgPLZut?=
 =?us-ascii?Q?Acq6QV5KQDtAjlo0/wwU0VyKblEh0gvpTFt3mSf3/aYzp51ii5p32/JsxZLW?=
 =?us-ascii?Q?aWxvKg9m7ssd0f6CR4Z4tdIrP59eWsKVCq5eumPHOf73rZloJtrDPWN462hZ?=
 =?us-ascii?Q?N+A7PaolZt4FyJvnOiNUUhZctqApay+3gBzS2oBKRW8ekyllsc1QCFhnDQ0N?=
 =?us-ascii?Q?lY6qZj1lkgZN3IfBANFG2VarsOOiNtX17uOXPc4ycNA0eALxYn07g9AnvLZh?=
 =?us-ascii?Q?3a3yZLDs8U7cXGZ6V7ZeKLr5zloxFQd3s4uw4j7DcW81LUn7mUJHPXZPuIW8?=
 =?us-ascii?Q?Ah4fdKgeX05eHnU5xB6EGwkZTp1ucTfRgdOzD79yFBwN2S/UmJzrAiVxzeHM?=
 =?us-ascii?Q?vf5yOL7jPSkGltS2rkVfypSwVnnkzN4/aWfUb/uLJW4t62Cgp0nTA3MsLdXR?=
 =?us-ascii?Q?XlsP+GjFQ4cD661FCcNNWjHHxiJ+9k8UNJfXPC67+SEl2Fg7ACo00Rob4ZaG?=
 =?us-ascii?Q?GP4ULDUvmdLR2+eBao6lMwrvqWF6s/EOC8vy3BGQ1mYGdGkutps0uWv3I5YU?=
 =?us-ascii?Q?q7Fheenlp2QOgLBDvVhdjQFeT4aE4TC9tl4iwGiT1vwuHRsfNY6w9R0ymWPB?=
 =?us-ascii?Q?salo6qBezH6JWQsh8dbayoAkEPla5XwAOtpHXvx//et8peVC1T8c053r9gLS?=
 =?us-ascii?Q?RqdBoDc+pRb2Mrr10nA0txQ2PQAlDOzlXqpDj68xDxEx3Ui1TRNa0FJoe+gK?=
 =?us-ascii?Q?SwaqGlMxPYCZzcQo947/ZbkBK17MDxTws10jF/RlHZbURnIQ9T+CtaycX6rL?=
 =?us-ascii?Q?6KXRJ4RwLk1EeCstueQPuOu/+5HiXKVS33RjwkS5FxfFkncJRd5p4CxGUXTT?=
 =?us-ascii?Q?gZf/p6Gee1UednmPiHbXK9xP3wmTMOpGhIa4MtI8zdeVr6olU5pMRda1jRIj?=
 =?us-ascii?Q?gYWAXjxj9IHzm94/YZwoKg5yIgk+tCTTCH4z5YjCHYxhEd1LV07JEdk3+Gq2?=
 =?us-ascii?Q?USNGP8HQAPIA8jA5rMQ+mmdPcw4IRBIwMRqRDEOdARZUS85dGHSu8bRHwRuJ?=
 =?us-ascii?Q?VyCIuP0WdAxweZyFQOwk+Ws=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd183bd-e441-46b8-9d5e-08d9ec94319f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:28.3057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1WCBjx7J2xpmktZpkH1InXxA7ubvyz1gWQM5E2drNQMcQ5ZDYG+Cs9LCfdPiByV7okQ7N2i9hGURyzFUsLBgLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The procedure for installing a FDB entry towards a LAG is different than
the one for a port. This patch refactors dsa_slave_switchdev_event_work()
into a smaller function that checks the net_device type, and if it's a
DSA slave interface (the only one supported for now), it calls the
current body of that function, now moved to dsa_slave_fdb_event_work().

As part of this change, the dsa_slave_fdb_event_work() and
dsa_fdb_offload_notify() function prototypes were also modified to take
the list of the arguments they need, instead of the full struct
dsa_switchdev_event_work that contains those arguments.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 71 ++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 273ae558ccd9..e5e22486a831 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2423,64 +2423,69 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static void
-dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
+static void dsa_fdb_offload_notify(struct net_device *dev,
+				   const unsigned char *addr, u16 vid)
 {
-	struct switchdev_notifier_fdb_info info = {};
+	struct switchdev_notifier_fdb_info info = {
+		.addr = addr,
+		.vid = vid,
+		.offloaded = true,
+	};
 
-	info.addr = switchdev_work->addr;
-	info.vid = switchdev_work->vid;
-	info.offloaded = true;
-	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 switchdev_work->dev, &info.info, NULL);
+	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, dev, &info.info,
+				 NULL);
 }
 
-static void dsa_slave_switchdev_event_work(struct work_struct *work)
+static void dsa_slave_fdb_event_work(struct net_device *dev,
+				     unsigned long event,
+				     const unsigned char *addr,
+				     u16 vid, bool host_addr)
 {
-	struct dsa_switchdev_event_work *switchdev_work =
-		container_of(work, struct dsa_switchdev_event_work, work);
-	struct net_device *dev = switchdev_work->dev;
-	struct dsa_switch *ds;
-	struct dsa_port *dp;
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
 	int err;
 
-	dp = dsa_slave_to_port(dev);
-	ds = dp->ds;
-
-	switch (switchdev_work->event) {
+	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_add(dp, switchdev_work->addr,
-						    switchdev_work->vid);
+		if (host_addr)
+			err = dsa_port_host_fdb_add(dp, addr, vid);
 		else
-			err = dsa_port_fdb_add(dp, switchdev_work->addr,
-					       switchdev_work->vid);
+			err = dsa_port_fdb_add(dp, addr, vid);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to add %pM vid %d to fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
+				dp->index, addr, vid, err);
 			break;
 		}
-		dsa_fdb_offload_notify(switchdev_work);
+		dsa_fdb_offload_notify(dev, addr, vid);
 		break;
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_del(dp, switchdev_work->addr,
-						    switchdev_work->vid);
+		if (host_addr)
+			err = dsa_port_host_fdb_del(dp, addr, vid);
 		else
-			err = dsa_port_fdb_del(dp, switchdev_work->addr,
-					       switchdev_work->vid);
+			err = dsa_port_fdb_del(dp, addr, vid);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to delete %pM vid %d from fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
+				dp->index, addr, vid, err);
 		}
 
 		break;
 	}
+}
+
+static void dsa_slave_switchdev_event_work(struct work_struct *work)
+{
+	struct dsa_switchdev_event_work *switchdev_work =
+		container_of(work, struct dsa_switchdev_event_work, work);
+	struct net_device *dev = switchdev_work->dev;
+
+	if (dsa_slave_dev_check(dev))
+		dsa_slave_fdb_event_work(dev, switchdev_work->event,
+					 switchdev_work->addr,
+					 switchdev_work->vid,
+					 switchdev_work->host_addr);
 
 	kfree(switchdev_work);
 }
-- 
2.25.1

