Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DC76DA621
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 01:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbjDFXbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 19:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjDFXbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 19:31:13 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2041.outbound.protection.outlook.com [40.107.8.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12219EC5
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:31:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTu+6ra3ABDlg9ocFrljMDM26fz6VsZhZ7NxN+Dl/pHpDQRSfy+yCEHr20nWdizdvBBsxHku5xgGfjh+ohR6XpWhTwGM7BTIWX+Xcx8v68OhkKRqC+3vkyzTjH0QmcsnsKRvUz8IQv2ZWfhRoWvGONsekkXyx+V4hm2WZhQyOJ8x+BoLuxA+6Mu+O4jK7jomL+TASLsAO3SEZRunrpU6NP+2MfSCmXsSxV6TE3HPIinYyRzeLaks1fNafqDhRpsz6pBDorJgiBdVpvWt9PyrJP7J0miP38xLQVuvLJAnyRg1m1ZFBUCoIJj1feLNuSoZadPp2KegtXyndFGyTCl/ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VopkhZfm5MTOY5VWLRZGBFYjIaXBvnZ2RP4kL+O3Lfk=;
 b=ajlYJTPs0YuqHUgslSBGwvHHKTUM+bM7oti1zYWW+9wcENQ0rp7t4180CeubvdQcNT6CL86jQY4MNIEhzp9rqdRKS3WE2CJKRSYSO2shMZ/7ev+EfFhz2f9n+Q7tq7t5NlhPGeqW/iCv7HtsNIqgzxP9CgyzmHMYNcECMyEgAWsQusyEucqzUHUWALf2kDbPOhFMsVgm6TCoEctojJmIwu99VrdPXzG6+7Q4bxWngb0jnKkJQm16pRNGHx3U4+oiBqLHlWEuyfOuXevBgCI6dZQju3pZK7lxpH15qdjdXDTeMlt/TtuLmZS6fMy81AWDVXnlaM8ieEmaei7rE8UUzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VopkhZfm5MTOY5VWLRZGBFYjIaXBvnZ2RP4kL+O3Lfk=;
 b=U+o+Tj4bQeJ4bKgb8jeLiKL1YPvCGiha1lNGZsfqk/PwGJtIT8whY8YIfFck0Q1gGWxNNzeKXNv0ZjdLiEMidIQ2UEJ7DMDr7qtFlWIUQo/wWomYA+0OcAb/ss1xAFrUWsf8hBGrpHqcYYJso+vm0A+foOZQRjfoykSzYseQOXk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB7507.eurprd04.prod.outlook.com (2603:10a6:20b:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 23:31:09 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Thu, 6 Apr 2023
 23:31:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: [RFC PATCH net] net: ipv4/ipv6 addrconf: call igmp{,6}_group_dropped() while dev is still up
Date:   Fri,  7 Apr 2023 02:30:58 +0300
Message-Id: <20230406233058.780721-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0075.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::23) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB7507:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bcde5de-6223-4609-f17a-08db36f6ffcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UQNYgxoMCWviljuRgqzkwEDFkQBy+hfV0SaU//TBTefaMf+b9gF5LmRFWcGFbPPb/L2xueaQbDHz4lZm4E6tTw73okgwNOLhNkrblxLT7ufzPsuSUsCf/gJ3J8cY6pX9IipKrQ8wl1tH4zq7pL2xl/qyjVla4QEasS1tp1xjJOZALxX91vK1M0JepplKjVysvY+gUEnCiSgmMr39QP+sVAXdgnKfbVf4Nmv4ixon7FZXkTJUctyiQ9g/grO/HpF1r6A9Vxhs6j1rnx+IknLItGiBd0hEUIZnR2gLAeKBCa4fGsMZ33V/Njr27RXo7z4eVTsbJUoHYOeSjYm/xZJsE6hx8Y2WSLq3lblWdL/qhkS2lXczQg8aFhAAkqxORrleFKOfCvIFIn9vAPBf2mPkcZDqupmvRTI/uL90t2efqOeIQfZwnMY685PXzimYjcB3XiaI3zvkq66vUWwqz+46nMpzm27/Zh6XpZ2ZDkyrHBalxMI3ycwhRnNdQYRvMw/WMWft4YM+NEt7yItzGtlWBinAJcWcvTusdi/pCrYLU+oEF2pWunaXzjPeBUOYy9VUu5vK1zGiyp1iozB53Dhf8Pr0EOCjFcGDlaOC6bCIman0iC6uFnX/X8pZnO/swumU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199021)(38350700002)(38100700002)(36756003)(2906002)(44832011)(4326008)(5660300002)(66476007)(8936002)(6916009)(66556008)(86362001)(8676002)(41300700001)(66946007)(6486002)(83380400001)(2616005)(186003)(6506007)(26005)(54906003)(6512007)(1076003)(6666004)(52116002)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JKukS5l6oe7zl3RZLK1dlZRVQezndxlv+595dqEIMLoCg5Uwr6gwMws8eTPK?=
 =?us-ascii?Q?0//A9Ifan+FXNDVBm7YD1PWUQ4Wk4hhV0sYDsWE2mDM3leLFzzK5m/s8tjPX?=
 =?us-ascii?Q?+3cV8SfCzfVilp24cG8dHoe80ixK/qilSnS+si2qjcUy23qdUsycLAWqzIIN?=
 =?us-ascii?Q?BtBcZlSLFNGEWGMzoNvGJKZP/juyyWNZi791UYcdeK85GQrni0TbxElMmktu?=
 =?us-ascii?Q?kOvDAgWG7q2Kx+7CcytyfWD9AldV/e7goWdkeo45vY6Ej5XjCjz4mgj7h+FW?=
 =?us-ascii?Q?K4xCLxAqIdQXu+JTNOJ3iNJkblD8WnUOYXKJ3c+n1fxROzN0vpSMsVTg650G?=
 =?us-ascii?Q?16/PUqG+UbNXKJs2AcvdBCCj4R/CsR7DLDxEwPMPRFRtPWAs2xlRJNHavy7f?=
 =?us-ascii?Q?WkZWbvVrWdC7EUBKhAHTTiY2RxexiZiq4lp0PFb06Pk30UeIujebZJyHiDGv?=
 =?us-ascii?Q?oKnYiVCb/bOgYdvu+GNmnLk3hrOq3RmyVfURRVtQgo1L+E0ooolVC6MzgQ4N?=
 =?us-ascii?Q?SyVSDa3bjyBULf8IQLg7ekAY58++Csy+3lysDqEw9UbOyLyXL500sg1Zn+OG?=
 =?us-ascii?Q?vVOPBPrn52xvFyXWbqAPoIvb7NavAgzlfD9B/shNLI3ynXCGtpfc3vHHUt8w?=
 =?us-ascii?Q?Dr5/bPm8ceexK6HCrGLY/45mbhbNR6LTJKem/Ie3wZN1I5XVnD9IXfCrGrPC?=
 =?us-ascii?Q?tSwRhzCzwOHqQe0eOLsshXSTSSBF6t0zVmVw5L+vcdlEUfvQhQUwiZQ0I3RH?=
 =?us-ascii?Q?0May9QqCZJatJ+YFZPSaKGXZT2EzFd55fUDuEvFyhF8+9GgIAmAZWdBZOIrh?=
 =?us-ascii?Q?+o4iinGfhiGOhhrXfX3NwnuzrEjSBg6oA1JwOClCin1j5sO2K/g6Z/H+F7FJ?=
 =?us-ascii?Q?BieAthXMOWZmU0LinRuf/AKLcqQVcEvHaA46YzCv2DpzKMON/AdZxD6W1E7R?=
 =?us-ascii?Q?LOEm6reny9FBAukUOZ7nfYiv74Im1xmPo/wqNGlm1Gews+fl8dNlrBljViPQ?=
 =?us-ascii?Q?lyRhrlVSRR3K+jZBmgFt1OizCJvzRVvSXndU1AgAxOV0ZGh0YkFhpe3Rws24?=
 =?us-ascii?Q?0HHWpEGB4Z94U4Yx9HNar5wnHhMJ85sIoIXcdYqu84pwjzd6oIBuuQgGJ9zD?=
 =?us-ascii?Q?2jWn19UomQd+Y9OPhGyTS/jLekuA3Ekpv4KpSpsYQ6TEusTUCO4LBnQEknzn?=
 =?us-ascii?Q?uKFmomngEljk+8r7BRb9e2OwOO6jhyiI+vLrqVgj68tZPyWTpUqGR3Fpkx59?=
 =?us-ascii?Q?UpCnNC7M3Oj6kpzy5lDxFcpvWdSjqLN/KCbatKl0Bh9eHPOSxkx9wlfLFyIc?=
 =?us-ascii?Q?RirMxuTQGlEA//KdXWywxj5j3Zpc87+WiyNH/tnydo/l40YVdHO+SoyrwD/b?=
 =?us-ascii?Q?bJ25hEjZojvaYKX66S6cgI/ya6hSnXZQ8QtOl+DX6C2mKS8w0BsN3uFoRVxI?=
 =?us-ascii?Q?ld0LKwgeNZ2Mv+ELNkVmilm7NbHBxx1pFJuVFezGVpdOruKVMmEn16rcG26V?=
 =?us-ascii?Q?c0QtcrpD4N/oGEmiJ6pgSrG9pVvyTmM655xkKzHXDUOmrcPPW2ukjwM883dz?=
 =?us-ascii?Q?zba+o90+GsiGNeKrQeD/vzFgaszBpjitIYiONEZVO5OyVppFQ5vyzu6IOAlw?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bcde5de-6223-4609-f17a-08db36f6ffcc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:31:08.7663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hN2LLHa/0tWdc99SsussQ8ATDQMzdiPf7I0Fgp2rQPAWn3DJxWFuTJvUbMOmuykmZrXwLVLto3flylCaWMj+5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7507
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipv4 devinet calls ip_mc_down(), and ipv6 calls addrconf_ifdown(), and
both of these eventually result in calls to dev_mc_del(), either through
igmp_group_dropped() or igmp6_group_dropped().

The problem is that dev_mc_del() does call __dev_set_rx_mode(), but this
will not propagate all the way to the ndo_set_rx_mode() of the device,
because of this check:

	/* dev_open will call this function so the list will stay sane. */
	if (!(dev->flags&IFF_UP))
		return;

and the NETDEV_DOWN notifier is emitted while the interface is already
down. OTOH we have NETDEV_GOING_DOWN which is emitted a bit earlier -
see:

dev_close_many()
-> __dev_close_many()
   -> call_netdevice_notifiers(NETDEV_GOING_DOWN, dev);
   -> dev->flags &= ~IFF_UP;
-> call_netdevice_notifiers(NETDEV_DOWN, dev);

Normally this oversight is easy to miss, because the addresses aren't
lost, just not synced to the device until the next up event.

DSA does some processing in its dsa_slave_set_rx_mode(), and assumes
that all addresses that were synced are also unsynced by the time the
device is unregistered. Due to that assumption not being satisfied,
the WARN_ON(!list_empty(&dp->mdbs)); from dsa_switch_release_ports()
triggers, and we leak memory corresponding to the multicast addresses
that were never synced.

Minimal reproducer:
ip link set swp0 up
ip link set swp0 down
echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind

The proposal is to respond to that slightly earlier notifier with the
IGMP address deletion, so that the ndo_set_rx_mode() of the device does
actually get called. I am not familiar with the details of these layers,
but it appeared to me that NETDEV_DOWN needed to be replaced everywhere
with NETDEV_GOING_DOWN, so I blindly did that and it worked.

Fixes: 5e8a1e03aa4d ("net: dsa: install secondary unicast and multicast addresses as host FDB/MDB")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Obviously DSA is not the only affected driver, but the extent to which
other drivers are impacted is not obvious to me. At least in DSA, there
is a WARN_ON() and a memory leak, so this is why I chose that Fixes tag.

 net/ipv4/devinet.c  |  7 ++++---
 net/ipv6/addrconf.c | 12 ++++++------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 5deac0517ef7..95690d16d651 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -392,7 +392,8 @@ static void __inet_del_ifa(struct in_device *in_dev,
 
 				rtmsg_ifa(RTM_DELADDR, ifa, nlh, portid);
 				blocking_notifier_call_chain(&inetaddr_chain,
-						NETDEV_DOWN, ifa);
+							     NETDEV_GOING_DOWN,
+							     ifa);
 				inet_free_ifa(ifa);
 			} else {
 				promote = ifa;
@@ -429,7 +430,7 @@ static void __inet_del_ifa(struct in_device *in_dev,
 	   So that, this order is correct.
 	 */
 	rtmsg_ifa(RTM_DELADDR, ifa1, nlh, portid);
-	blocking_notifier_call_chain(&inetaddr_chain, NETDEV_DOWN, ifa1);
+	blocking_notifier_call_chain(&inetaddr_chain, NETDEV_GOING_DOWN, ifa1);
 
 	if (promote) {
 		struct in_ifaddr *next_sec;
@@ -1588,7 +1589,7 @@ static int inetdev_event(struct notifier_block *this, unsigned long event,
 		/* Send gratuitous ARP to notify of link change */
 		inetdev_send_gratuitous_arp(dev, in_dev);
 		break;
-	case NETDEV_DOWN:
+	case NETDEV_GOING_DOWN:
 		ip_mc_down(in_dev);
 		break;
 	case NETDEV_PRE_TYPE_CHANGE:
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3797917237d0..9e484f829f1c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1307,7 +1307,7 @@ static void ipv6_del_addr(struct inet6_ifaddr *ifp)
 
 	ipv6_ifa_notify(RTM_DELADDR, ifp);
 
-	inet6addr_notifier_call_chain(NETDEV_DOWN, ifp);
+	inet6addr_notifier_call_chain(NETDEV_GOING_DOWN, ifp);
 
 	if (action != CLEANUP_PREFIX_RT_NOP) {
 		cleanup_prefix_route(ifp, expires,
@@ -3670,12 +3670,12 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 		}
 		break;
 
-	case NETDEV_DOWN:
+	case NETDEV_GOING_DOWN:
 	case NETDEV_UNREGISTER:
 		/*
 		 *	Remove all addresses from this interface.
 		 */
-		addrconf_ifdown(dev, event != NETDEV_DOWN);
+		addrconf_ifdown(dev, event != NETDEV_GOING_DOWN);
 		break;
 
 	case NETDEV_CHANGENAME:
@@ -3741,7 +3741,7 @@ static bool addr_is_local(const struct in6_addr *addr)
 
 static int addrconf_ifdown(struct net_device *dev, bool unregister)
 {
-	unsigned long event = unregister ? NETDEV_UNREGISTER : NETDEV_DOWN;
+	unsigned long event = unregister ? NETDEV_UNREGISTER : NETDEV_GOING_DOWN;
 	struct net *net = dev_net(dev);
 	struct inet6_dev *idev;
 	struct inet6_ifaddr *ifa;
@@ -3877,7 +3877,7 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 
 		if (state != INET6_IFADDR_STATE_DEAD) {
 			__ipv6_ifa_notify(RTM_DELADDR, ifa);
-			inet6addr_notifier_call_chain(NETDEV_DOWN, ifa);
+			inet6addr_notifier_call_chain(NETDEV_GOING_DOWN, ifa);
 		} else {
 			if (idev->cnf.forwarding)
 				addrconf_leave_anycast(ifa);
@@ -6252,7 +6252,7 @@ static void dev_disable_change(struct inet6_dev *idev)
 
 	netdev_notifier_info_init(&info, idev->dev);
 	if (idev->cnf.disable_ipv6)
-		addrconf_notify(NULL, NETDEV_DOWN, &info);
+		addrconf_notify(NULL, NETDEV_GOING_DOWN, &info);
 	else
 		addrconf_notify(NULL, NETDEV_UP, &info);
 }
-- 
2.34.1

