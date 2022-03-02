Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA714CAE63
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244971AbiCBTPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244969AbiCBTPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:15:40 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBDD5749B
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:14:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lfx0yhNtAsg2rcABTOrB45IomY0dAVHc0R9h14DxTTriMuG/mJHmFUE1AF51RzI8snf5ifeviOJTiBuU/WaAQubhxby0QvBQvqYRizQjug1IDFza7FMopJXlGWVnSPf1nVCm1hGVzJOvQcyNtcoSujrITVjwJKVPkx2uE3MCMR42G6h+0gLYXuOWCaYbp8c56w9PdxSDypwYrzN/ki8s6jdEFQxiBDs1qWRJbxVaSbAMR1WB2/Ilach6aw6buSG9TLFbsro4nyqyW6U19xS30jrOrGV+XLsUP/6v/KWw8XHX7g39QASOyOb1sCX0rkxtqQa9nQ+d288TwllNjD2zAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vw5rzboa8boKdXYwei3bEaf6howw+5jM5qHM+dNHe4s=;
 b=nZmM3ewVM3i96U6ASqaHEJtj6Uivg2N/0sNKd4AZwBn8KVLLI/BXWGTZS2hEKJ8pMMEn1vwmMlxasbkyboly8pNnsEtGwQEqp9IOEnXyTZSjCp8Xdri7VW5n4HtWH/d6+3MPNERI98a0TJPyJfDNMntTsFgu5KYmVt/6syIpeB9G63/DZ+NhIzPu/G368gn3AX15B8ErPHVGZLSF+hq0f5dycAoH9Paqxj8c9OPYiR9URLQN2qtGiyq149xnBJncgqLlcITfSAhd42bjKceo0KZCv4+agsEBA3IHHufvpZIfPReWQTnJNlUbqykY/MqTCkLBj/kd4sN+BeNzyRUDYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vw5rzboa8boKdXYwei3bEaf6howw+5jM5qHM+dNHe4s=;
 b=Nkf8o34oCU//slFF4y48L1w8t1K99Bt6lo4gQ+IFOGXRKG8OFOk0w/GWlgS1EikEbIB97I21WDpQJb0YfiG/OWm6SRcvAbf0b+1Y25z7GPdIVA563BCpiXIJ8x+pwt9Jy88vwJNbCZkZYEe8O33duJxNDFMqgJ2ldz9o344wDgM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 19:14:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:14:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 01/10] net: dsa: remove workarounds for changing master promisc/allmulti only while up
Date:   Wed,  2 Mar 2022 21:14:08 +0200
Message-Id: <20220302191417.1288145-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0030.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b4904e2-e152-4621-0c83-08d9fc80ed7f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2911FFDC3784FAFB23B0499BE0039@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PbL3la5/JAnbqHZyzg2YCG7oYC9FuV4MHT4y/BiiOQddEXESdX3F2dGCJaxoIB4X4PuFKJVX5jc29mArLA3P77TV6vIKwemASoAUJnDm7Ikg0Vl3p84zP6BaaTiUvmYrKQjWrnxNkGu2QsRrOEx7GeBV1ED8seJ8+FkESpIJWEqe1d64zeHLJUD3iVMFNl+XwBODVDfN8ZNqrm2pL/OfNxRjRxOUPa3Hoh7jpUqeQtYi6MntP43pXSPgNUm1/+9Iu5qn0+UJFb55VjB+9J4vCz1SbJMoGkQ81GpP7Jfe3sEICH/x2NG91EHqwqZqwtAO+K3Qc8nzjXpfzc+IaU1XDiLY7KVBjAsySoR1sLITm232J9ZLGUXGbCpZuE3KBkcuNSL1aayJI0nG+xIQkrFL74A8ktrMFrBtckhXFwenFqXI2mT54BQfoutbdvO6OgQ8nx5pv6AD75rSXt7PbcVDp2tS2x7cSEm5Qw6CzOLceMM9zeW0f9X5132QFwXsKhUVd+dl593sw7fRXiRxdGZjKoSfa/PlpQXPCBnIV+7I5Nf6qO/Ou+pZCvqqWni1XwkDCgckC1ZryrZo9xIhr9afj12QvuyiyOmgM61fCBrdgMdxg9Tre+VpbmOsZQBKnTEGYqSmMk/SMFwGdMTHMnmTbzIl20WRVbRlm/jAQq1l6grgus71xeox+ym7F4Y+nrNeM8HbWEw7/MnUeKylqvk2zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6916009)(83380400001)(5660300002)(8676002)(4326008)(7416002)(66556008)(66476007)(44832011)(36756003)(54906003)(66946007)(52116002)(8936002)(38100700002)(6506007)(6512007)(6666004)(38350700002)(1076003)(2616005)(26005)(186003)(508600001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pYi/LsyOJaNGB0edc1DAQbFpkZXqF+mvI2K4uF9gtmJcUSpucAlCy7ddvw4F?=
 =?us-ascii?Q?RfONX7CX/VX0YQgnIH6dValYpog6Xze5bY4jWzUxavOXAAwgYazD+b1iBwak?=
 =?us-ascii?Q?v0W/fj51lO9YwlJ23Fp8CqdvUI3m3T0cmFEAvUA9Ag+GuHxVifmJ1Dps02Dz?=
 =?us-ascii?Q?0kvyb4cOP6Cf0+e4PCfAQlwwejZzK86CyZpvE6jnwUL0wsdGNiUreHCL1hF4?=
 =?us-ascii?Q?b98OF9szrTwboljdkCq/XtIBi3T8D7vqsdKhse6EtdmnJMdgt0ribbKiIkb6?=
 =?us-ascii?Q?XWk/qFY68kEOcy2DZWTnpOjy/yC1pL6Vc+bATuTjIp48Q+LuQrYxvv9HN80d?=
 =?us-ascii?Q?FdR4z2Y+DvS0NrnhvgKK/5ELV8iDEatn3jEmJ0uwbkClYkWCCuFGTGv7cAYs?=
 =?us-ascii?Q?IY7tjWmK9o6teBT05Ft/+plBB/QjrEFR+L2FpBO/jB2QTUGTHrYcWuf1prZO?=
 =?us-ascii?Q?a3GMRnKpn7B/gL3Yafv7fNlDg7tV6Z54RGpjBaYNIovjbN99rITwWp/JUQau?=
 =?us-ascii?Q?Vzcr2rQtwmUeJFcTtmlRDRMUV1dkV8sF3ppobIPtB2ORp/V9IFNjW7upUDoK?=
 =?us-ascii?Q?IXwc0WWcAP/nHIYzXy4yO2LyhOhB6HmaS5RpZz3pLGUbGHdZBS+HOpsuLHJY?=
 =?us-ascii?Q?hn1Gzr6mLZb6fdj5SValnSjLOWoEl2GAYXfBgUWnUOsqhvngIoCsZVxszNYG?=
 =?us-ascii?Q?BeeZjzwCFCHkDJSB55lc4nSryH4v36O/cpZhwsW7/w83ON+bKJz97sLOpMzG?=
 =?us-ascii?Q?PHq/r3V657LTXXe4/MMkQV2N3cR9Q2TeA48y7/vrDStMIjDkLmuCDIIApdIC?=
 =?us-ascii?Q?05dDWfqclnwoJW9nRrqnN1ISZb9Phw1dinAfvdSMHmQBW3/or3lMYG5cZApg?=
 =?us-ascii?Q?pL3rIplTFxlxuxna9niYE7iVTLpaBgXarPkz6rtEVBBHr6PTEhCa+1SCDmpd?=
 =?us-ascii?Q?FfdlojaIDRPJefaLR0w/KorQxJZucHb5KgWxvLkS4MMDCZe8O6ZQtRB06yhK?=
 =?us-ascii?Q?obql6Vmuzo8OHWajEDkhi9XYB6GfMEGIJAoJRKOivavIdl/t5PStTpD/edmx?=
 =?us-ascii?Q?hg4ZyxOPktDF/Y8fIswyI3lyEL3cNRRvmiCz7GUeXX8kH6mZf2jNTBdgvlXq?=
 =?us-ascii?Q?g5n0ssVlgdInrpWwUykzX8vygQKIoIiFxxNwnXvIYqVkz2sKjVV4hVQ5kw7Y?=
 =?us-ascii?Q?06ZBlLWBASBeItxp0hj64/XDq9YUVVX/KP07JmmUxFMqUi1KR0Cbo2gk2+zw?=
 =?us-ascii?Q?ARAa5p1X6f74DiT0VzNPcXZnyrGcZ33k5yUaBC7mpAzPxN+82XApc6ZYa8Mg?=
 =?us-ascii?Q?7Q/bFYVcCa1Wni8/eUj9bVnXs2vriDFbaafcErTeeZkAMAZxzNW6pX51ZuS1?=
 =?us-ascii?Q?BoFvUIUJAQDbER61L3W33gIuF/FKeFXLk+TprHsCM541IfOw6F+q6VfkQbl8?=
 =?us-ascii?Q?SzoC3ijfMHKv7FRoLiFvTivDhLA9rywx+CmP0oHem9sTUlL5RGSxu3zdVKPZ?=
 =?us-ascii?Q?EnuYyyBMWfiPlDtiu813d/dlhFL/sF8lFcwq9qUUKO2wbKIa9hN8KpLjEzvw?=
 =?us-ascii?Q?n4ei9FsG0ms1tHL9sxy/4pC8vLFTHqfR/J3TgI8i83L4Xaf8o3ki3kcl0PUw?=
 =?us-ascii?Q?9tJFE3DIzVxrv0m+sPw2mGU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4904e2-e152-4621-0c83-08d9fc80ed7f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:14:52.2050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyTeEyVk6f1Pci7VQSLYC3qqt3qmADD53nRLyaaqBJrogIZ0U9S0lGxErmK6KIo3NfmZX5GYexClLhw3BnPv6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lennert Buytenhek explains in commit df02c6ff2e39 ("dsa: fix master
interface allmulti/promisc handling"), dated Nov 2008, that changing the
promiscuity of interfaces that are down (here the master) is broken.

This fact regarding promisc/allmulti has changed since commit
b6c40d68ff64 ("net: only invoke dev->change_rx_flags when device is UP")
by Vlad Yasevich, dated Nov 2013.

Therefore, DSA now has unnecessary complexity to handle master state
transitions from down to up. In fact, syncing the unicast and multicast
addresses can happen completely asynchronously to the administrative
state changes.

This change reduces that complexity by effectively fully reverting
commit df02c6ff2e39 ("dsa: fix master interface allmulti/promisc
handling").

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 45 ++++++++-------------------------------------
 1 file changed, 8 insertions(+), 37 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 089616206b11..52d1316368c9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -81,29 +81,12 @@ static int dsa_slave_open(struct net_device *dev)
 			goto out;
 	}
 
-	if (dev->flags & IFF_ALLMULTI) {
-		err = dev_set_allmulti(master, 1);
-		if (err < 0)
-			goto del_unicast;
-	}
-	if (dev->flags & IFF_PROMISC) {
-		err = dev_set_promiscuity(master, 1);
-		if (err < 0)
-			goto clear_allmulti;
-	}
-
 	err = dsa_port_enable_rt(dp, dev->phydev);
 	if (err)
-		goto clear_promisc;
+		goto del_unicast;
 
 	return 0;
 
-clear_promisc:
-	if (dev->flags & IFF_PROMISC)
-		dev_set_promiscuity(master, -1);
-clear_allmulti:
-	if (dev->flags & IFF_ALLMULTI)
-		dev_set_allmulti(master, -1);
 del_unicast:
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr))
 		dev_uc_del(master, dev->dev_addr);
@@ -118,13 +101,6 @@ static int dsa_slave_close(struct net_device *dev)
 
 	dsa_port_disable_rt(dp);
 
-	dev_mc_unsync(master, dev);
-	dev_uc_unsync(master, dev);
-	if (dev->flags & IFF_ALLMULTI)
-		dev_set_allmulti(master, -1);
-	if (dev->flags & IFF_PROMISC)
-		dev_set_promiscuity(master, -1);
-
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr))
 		dev_uc_del(master, dev->dev_addr);
 
@@ -134,14 +110,13 @@ static int dsa_slave_close(struct net_device *dev)
 static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
-	if (dev->flags & IFF_UP) {
-		if (change & IFF_ALLMULTI)
-			dev_set_allmulti(master,
-					 dev->flags & IFF_ALLMULTI ? 1 : -1);
-		if (change & IFF_PROMISC)
-			dev_set_promiscuity(master,
-					    dev->flags & IFF_PROMISC ? 1 : -1);
-	}
+
+	if (change & IFF_ALLMULTI)
+		dev_set_allmulti(master,
+				 dev->flags & IFF_ALLMULTI ? 1 : -1);
+	if (change & IFF_PROMISC)
+		dev_set_promiscuity(master,
+				    dev->flags & IFF_PROMISC ? 1 : -1);
 }
 
 static void dsa_slave_set_rx_mode(struct net_device *dev)
@@ -161,9 +136,6 @@ static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	if (!(dev->flags & IFF_UP))
-		goto out;
-
 	if (!ether_addr_equal(addr->sa_data, master->dev_addr)) {
 		err = dev_uc_add(master, addr->sa_data);
 		if (err < 0)
@@ -173,7 +145,6 @@ static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr))
 		dev_uc_del(master, dev->dev_addr);
 
-out:
 	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
-- 
2.25.1

