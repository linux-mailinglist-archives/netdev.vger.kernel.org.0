Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3D16DDE7A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjDKOuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 10:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjDKOuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 10:50:13 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477BEDE
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 07:50:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XE0DSJXd3z8nPNwvhd6Y+DR15x8+7xRt4vP6PE/Nf8yegETbHkoZY+pCkKvs5e4qsQ7wT3XTQvV7WMo44dJOphfDoWjsSSXcg5wO++pd87Snz8JBPIznaKAH6lo66ulj3GNkphd2TtlyE/jrqIULQaba5mQcOtN7bx0KPK7fqsZOsM4mwXBj0V2SkMz1mF1ntGVX70TTZv+MlJrCmfNjnFW8dw2SIJM2JIidi/4UTobhzfeQePqK69ilkKW4+1389Wj6uS2DaVJzJeA9F50fJASfk8HLvVDDZtwVljpzK+biMyMsp4AIIUo1weLWZYK9lE1PzjH11kJVvzsBx0WL0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3HomBjnLzAVbwpD8xHSfOhVW0jY3pkoHmTnG0Rqwhq0=;
 b=chAtGS4bkx/4SKNf6xpJHCYxnjKfD+TxseWIqoeE5LFqNIKVPiS9oHtFW7Kq6uqoRX2QJTIzNWWz8A0v/81drn1QOmOilWi4sxa/J3XV7W3aNa17EM45ahu31F1syBt8PREYMIPAnxkwpXJ3FMpqjIJ/WYmsuy8kIdRpi9acgZI72DdYdgCLpmsK2HKXq3/0Li4mPlIL25It1Tg9J/2rpbfOWwlWgwOQvKkqncz/WpBX7hZ70kZoLsKO/gk/f2ZPAZ+Z5NIQfRXla7EFjPiqwt98jRLVgRaW+bDzEg2z6mS9EshEuX/3jodDmuxRhjemP/H7Qx91gPsH7VmgVu5CCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HomBjnLzAVbwpD8xHSfOhVW0jY3pkoHmTnG0Rqwhq0=;
 b=jx7+3JRAExrv3LToyFvXptsCMOA2BBmj6hCK7mn6jIUO0Qt1vM0hTM8ekRD/7x5GhU0u2HK2DodXg5nhSsGy/OTQh4vNjbnoGdDY9mFz87MGgLTch6OT/PzVoxPCu8f9Bhht4saeoWcnBzZL+znz01LssqSzzs4Ebavt/UAZ938=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS5PR04MB9972.eurprd04.prod.outlook.com (2603:10a6:20b:682::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 14:50:09 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Tue, 11 Apr 2023
 14:50:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH v3 net] net: ipv4/ipv6 addrconf: call igmp{,6}_group_dropped() while dev is still up
Date:   Tue, 11 Apr 2023 17:49:55 +0300
Message-Id: <20230411144955.1604591-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS5PR04MB9972:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ca2c0e2-1cd3-4044-5d27-08db3a9c0c1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXOcx2CuRreUB2Yr2LEXW/LeVxCj7qZT2dtQ/BBZdwqJYQmp1Pxu/GwqwTZSMGzUHU4qO8G7FPE7kxGLoEcyA5r5pwOcpsVZlENS/OKXWb6MlIlajhSBvNXLUZTOI37Rl3O55Lftg2K5lnIRpg9Eo9RCQ+VQ68KZzUinEcXAjM1E8NlnIF6vHev/NqnGg+HTZXzg2Uf+vlbiueePfwTMuFcru0hfYGYBoWdHzBzc0LKRoG/6FEPSk0zd9ibMzkR1T/gbau3EW53lxJ8u2Z6yQxzUFmgOjdi8Lpa2GlPS6WhK/hqUyt9tY4SdcHSdPIjdDadSzEugYdrOpcuCcfPY84lM2groWDt2zrhBYDIqiK7oefW4I8geD9EWZLdfwgkbe/D3KyXg7AVuej9bDoQTmgrWuBvkZEvikrlpEywMeIiU77S85ZapXrUS2Wb1QC1a5xzSKr1bG5uXHL4fr9iUbVIMs01LJi572xzwc8RWb5SwrMJNjbZlHi5X2sSbSPUJF3U7tsEz0l/OOZBHZhXovf2xFWKHlTSqvVRGLfE36OUcdhqlyZx32TA2+LbX1ne7vry+U9j/z3ns53JdPjLE1irM1VKrsg+TIVcjmaWeS9w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199021)(478600001)(52116002)(86362001)(83380400001)(36756003)(38350700002)(2616005)(38100700002)(6486002)(2906002)(966005)(6512007)(1076003)(316002)(26005)(54906003)(6506007)(186003)(44832011)(66476007)(41300700001)(8676002)(6666004)(6916009)(66556008)(8936002)(4326008)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r4PnUSTPDaRTYJxNO4/UjFVKk4EapCXJf/kzgZ/yGnnT1zIzT8PFjFzq3vrV?=
 =?us-ascii?Q?HleSfNFqj8hglBsnGAXMqDhGdmyEuP/qCxAC2XiN1pYx9lWmE1iX303rP8P2?=
 =?us-ascii?Q?zNQcgprrCjDzXhbvEGU8SxJpIOgW1Mw8oyCsQG62EONeydtm5MXkjISXvXu4?=
 =?us-ascii?Q?Et4fF6lV17LLlrYOzPTTabXIWXmeX4f/RjGWdvFxzLmMxLatn7+kteSs8WCo?=
 =?us-ascii?Q?Pv9e/azL0qN28fyWyOzmH6xHmqwue+7z3nW24pLEMyCSbITL+rAhWkVzMIef?=
 =?us-ascii?Q?ktLmfXFqLNP633uao5h4SUolBgu/dlUZMm5qjex66ngJndjPcI8a73YLddQv?=
 =?us-ascii?Q?DtmveRwClZA0BouyAPZdu432UWgIcCOC2QCxVZt159ALmTI6//1OC3N7JicC?=
 =?us-ascii?Q?BkDhdt9P+WuPUYKgKvt67RKBPlF0zd9hqOkN8qopYhvqE77s3xG+UKPXVbZM?=
 =?us-ascii?Q?vLOJrm2hIvbJdncx9hNGJIPxe27R9bYd2Xd9Dj+zXirrmId4dLVbTNQSH7Vx?=
 =?us-ascii?Q?4qTAmRbQlxalP+FySquDQ+DZ9wgcmNhDkOY/CDoIlbNZOkdl/yGeGNvABgjJ?=
 =?us-ascii?Q?JkxSqFhRmWqPMnOPUSTGVzPhSCfTsHnYeUp/gjbJd1v4BB6ZLXEYOptsWtM9?=
 =?us-ascii?Q?RO645Ha+ZB0iiNhtpafnNL1IgJcAvf0/IwVTAvvbtCCdh6k+bXBiP6/DCyLO?=
 =?us-ascii?Q?gxXfu9jLJgGWEngZqsORinQ0MGKg0Z/tdLmSoI1lFvR+CofpNsfD89xOuLzu?=
 =?us-ascii?Q?6mrNMw1ZtAWCUUqe0EOs4XxnCm1XWcJQH5CtGGCQ1yHDkmhi9tRv7/JNd66c?=
 =?us-ascii?Q?5FTY1DkNwsFMh0UOOxjVgyilXrTQDd4ZuX8/Vm5z4E1kq0ymg2ZqldbPwp4n?=
 =?us-ascii?Q?FHXOCx10SBdWkNP/U+TZIZirY5cTIW1r/g8D0qyAU17hFTNPCVCDDdYchfmY?=
 =?us-ascii?Q?24wRhMYVSr5l4o6faFkhylYcHoHVA4JImbiIFGtCyazs6sVHO/6WLUdBtHwl?=
 =?us-ascii?Q?AfKoXP/IE2EhAxBKpqT0iUqSF/NWGviIpKGI+evWzLwU5RrvzHlStw1JH+Us?=
 =?us-ascii?Q?mNTN9cudswvJLF/vEHy5bth33IhwPFcACjG9eEpvFxwE2s04Lz8BgHK8w8IA?=
 =?us-ascii?Q?T42mthdpQ4RZ54Grw5yaLzrQFbpy3Qma53XrKoYBSzc09nEG7pdcy+XfoxTu?=
 =?us-ascii?Q?XXaJCaovHiViYl5Ozm7CLUHljpwdbVFtmyRNonFSMppd2whwsxaMnLK0C9GR?=
 =?us-ascii?Q?bbs6wIQklSYBASBNvuuksw6Lh06PafnpnkYXAxFktvEgSQldYemYTAFVRL/i?=
 =?us-ascii?Q?oJOQjxE4lqAnCK0C9yb0igfGofaNsUOtpfAbzcujfj0y4iWUnLzs5VSbxkeY?=
 =?us-ascii?Q?MTVr3BfuxrOenxFrQfZ63/vFXvGXKf5iKGEo7BfE4sP91HfWzbfVmZ6WE/TG?=
 =?us-ascii?Q?CaRNRM+RREtqox9iBhNQ32wKk4qSmKkQiZzR/2+1au81IfnNMi4XeHLE9AMH?=
 =?us-ascii?Q?+eicHqVaSnWIIcpU0HLHI3+jFLy5r3MSiROswdKVmT/f7ZxmghOFIpR5XH4Q?=
 =?us-ascii?Q?hlYnpiw0XOZK1BlHyG2HHPY8IgJbkCHwMS9r70lTCJVG1AZaykiG9PryEK4U?=
 =?us-ascii?Q?Hg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ca2c0e2-1cd3-4044-5d27-08db3a9c0c1e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 14:50:09.8137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IcU8ofU6904Hw+hr51EuxDi59Sr8vX/GsabPz1itwxODiPLQv5k19fhn6mGq7GT2PIWVuouyS9RZMraUAtu1nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9972
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
actually get called.

Fixes: 5e8a1e03aa4d ("net: dsa: install secondary unicast and multicast addresses as host FDB/MDB")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
Returned to the original strategy, with Ido's modification applied
(to only touch the netdev notifier values, not the inetaddr notifier
values).

v2 at:
https://patchwork.kernel.org/project/netdevbpf/patch/20230410195220.1335670-1-vladimir.oltean@nxp.com/

 net/ipv4/devinet.c  | 2 +-
 net/ipv6/addrconf.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 5deac0517ef7..679c9819f25b 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1588,7 +1588,7 @@ static int inetdev_event(struct notifier_block *this, unsigned long event,
 		/* Send gratuitous ARP to notify of link change */
 		inetdev_send_gratuitous_arp(dev, in_dev);
 		break;
-	case NETDEV_DOWN:
+	case NETDEV_GOING_DOWN:
 		ip_mc_down(in_dev);
 		break;
 	case NETDEV_PRE_TYPE_CHANGE:
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3797917237d0..f4a3b2693d6a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
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

