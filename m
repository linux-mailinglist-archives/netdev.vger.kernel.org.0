Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8576DCC48
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 22:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjDJUuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 16:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDJUuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 16:50:14 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2078.outbound.protection.outlook.com [40.107.8.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A0719AF;
        Mon, 10 Apr 2023 13:50:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFx0t7ZQBEoSMAhytrXePsw2neKs9azZ1zYqDHUeXPmnAWzO1N7s47H6jWy0bHK3UF2KvkfOhT/NgjPpaKUkQ+cixToIrH6qcXNed1Ngu5ne0dt3kwE8+k2LwVeOcXlREgu/eOUKeKImhXKRk0qcoaDeO4dMFXSIAZSBILvwrQnshBVLADt8MBW9ii0LUiS6vnAj6LWyB3dge6//2j8vcoU6McXjrbVI5gB51ofNGJWTaWCTQLoZbdagcj0D0DBcJiub0SBmls3VC98w1qPagHO+qgXykTZNjWVQHeypkT0PIoeijsG5qSY/GsocymY15Eq6ZmRT2SOSRdms6xeS1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fxf4yAEtHHLmy64jhw+OPMR4vwhn46p/00PFdZpyeo0=;
 b=mR5wmNOtrdnM43VSAM8rcSTXjtB2OtE9NLE2aeziLi+v7C5sEegHCHPIA8jrZoTbGvfPQVqmknYin/jSJ4+U718BC4u+EaS7tHzdVaEUZ8D3jJRWVL1whBB/azxKDJAMu0cDv2xRVcBcusZfGYD2LT2tdLX4p2bJfq0plYi0Tth+2utvngbRtcy/7XuglVAwuDoQiBwRZ1HS3jo8lBzezvfsXVMkl/AhavmGEPmgxw/wlOMhJ+GAOeq5WhAdOMT2pkTaWUNfRqEyH4v4tOxEKiTzUtHcit3FZ37eaRGF59cGVbQSuGCC2ldDZPwfg9h5ulYCRqIdgvKnQT6te6oUlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fxf4yAEtHHLmy64jhw+OPMR4vwhn46p/00PFdZpyeo0=;
 b=LPYSijAP2X9nwBdN++CPbOQzLLYyCJwChM/zLnkfM0aZ/89s/wYkP1g9kuQZyhXjXPOdb2WajZAw2+MaFkHdEpJl4It0TSnqGDTa2tPvZ+ZEeldAq4jb659Dg3HNgenZuLRvQKMC8qRcq464B2t4IlkQh7BsrB2ZTFj7Q+iAXMA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7960.eurprd04.prod.outlook.com (2603:10a6:20b:2a8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 20:50:09 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Mon, 10 Apr 2023
 20:50:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Arkadi Sharshevsky <arkadis@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: bridge: switchdev: don't notify FDB entries with "master dynamic"
Date:   Mon, 10 Apr 2023 23:49:51 +0300
Message-Id: <20230410204951.1359485-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0086.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::22) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7960:EE_
X-MS-Office365-Filtering-Correlation-Id: 81152dd6-c9fb-4022-480a-08db3a052bf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 41Cb3VnrH42lXo8102FoNNuqTS1qf6jrfBFXpaE9iRiDQlPn8bwDrnjihOk8Qt1dy3mMbYMHE+e+UOQZDfkJxj/M30lNYRft4X/REAX62ZVutkUBq5NvWPttNt0EyHDIh9ZAkyEc8RYrGPBC7O/9DIoQIdXI4FZj3BcNupUM73P+cUzq80SdnW0X0/BZ8ErRe5lkyaSBQqx6T75W1ZEdluoiVkzYSss93OkaSe/CyAsDBbOlwRN39urljj19laea6liOoY3XaQvrY9/1ZXLDpQ6XNNuJ/c73Jp/ru9xM4Umk2Qcgm2QCZF4qpRH3YDC7xb9e0CzQoGK90LGd1UDzAHRGajVOrVVrOD3YqCSw87I1X+v3HOH11VrnGLSNHevH2MubrxQw8j03r5kV+adxRYm2Pq4AVv1WcsteL6EcgBaMhVSkuyqNOF25H2/AB01Oxt97kE3j9L1sl9SVHtwNVA4spDFsvDgJq35gmN0M/+OWAUTG0hQFLSb+Z4w5qDPh/q2hafL6aUnORu2Jms95YKGSpiOtuOcvyYQ7QKnWD+9kKm8s7Z6qIJ/YoKpgnMw+SnFn9pUJ3rRTLD4OJEF5hV8bO1AZGJHOt8wfxEIMFkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199021)(54906003)(966005)(52116002)(6486002)(86362001)(6506007)(6512007)(478600001)(26005)(1076003)(5660300002)(36756003)(186003)(316002)(38350700002)(38100700002)(66946007)(66476007)(66556008)(4326008)(6916009)(6666004)(2616005)(41300700001)(2906002)(83380400001)(8936002)(8676002)(7416002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YRnWpRgSS4NXbdhQuQcF/czQgGMTuP9ntijXQdulDiF6gXs0oSXTf1nWY8ne?=
 =?us-ascii?Q?aUJDipdOlrxjuHQflnvdo7H/Vgfhl2rBkEAh6i/UO93GujjH//gM6BGh3u52?=
 =?us-ascii?Q?zGtOHiE55LLBAJ1arQ9Md8BIMWKdQLjCSJROhAvT2HUyCgcWn4+Z17ajGRNX?=
 =?us-ascii?Q?nwZkg1ACgEaMKCtA4fdAnPc7dkzNRufNlmq5T3VeZVPViqoU6ouhcfSN5rq+?=
 =?us-ascii?Q?I4ZKXKABYWgR1mvFsPLwsW4LYyQg5gFHOW7ZidQhyY3nmZ6cPUOeJK7/2b9f?=
 =?us-ascii?Q?JGNOYZL+VZ94q3v2EDHLGr3GFMov2YZlrqPQjkU4xH1HimSNGiSZ/ZvreU9h?=
 =?us-ascii?Q?RI4Cw/P+HHss1FvTiUxOFvMH3W5iUA8aTK5KALswl3hsjdomf/DzfRM3TCPD?=
 =?us-ascii?Q?/Bl58fyI08Je62p2ayICqDRja5zJL8duyPx+xOjya9GpGX1cp8BZm8Y0qrhS?=
 =?us-ascii?Q?7opZhdYEU9SkWMasds5DmKy+lYJe2JLAVca5ifEmU1BHAz/R3MBxO4WOmk2M?=
 =?us-ascii?Q?FO60ZENeuNwGUHxALmxa2IU/gcjALVDsNy8Of+whLySs3Xgvw16MEhMxIWHB?=
 =?us-ascii?Q?X9vWVqwsEZfoIwFBFI7MC+rvchtfR6OXYwJAm1tjtGZkDrXzWV3P44HImvxh?=
 =?us-ascii?Q?5JnPrLzCeRzaAkeHLQFZSLYXSYY70bKry7hZsRnfJ8L0h+p5qK3Wz+WcVcyE?=
 =?us-ascii?Q?HxU9sDCfpg+/SkPurrm19AYo0s1NQQD4VN1kKL1y072sbHDUAqvQvUzQnp+M?=
 =?us-ascii?Q?8+0pTGsSsO2qPV6i8YrCiSfC5TZ9st/50A4UfRfTYw2LW+dqDusGo6wlyGaf?=
 =?us-ascii?Q?a4TEKqpcHO2R35kMozMVX2EyWW1hhZzE8+qwnEsZb64KMmKqCvUhmYdHjrUt?=
 =?us-ascii?Q?TalxiYPmVqoLR73jybmdrwnR/+ur9HDB3FpFsHMzzrRbaBkk9Qhl9vN4mcGQ?=
 =?us-ascii?Q?pTww5wzaxzEJhYGnPRrVk0blCYJ4gjRj/MdEtdfJEieFIm43/YZp6wPOGKSt?=
 =?us-ascii?Q?PGPCi4VlgH8antyFrJd1xrOysDINaJaZGwXElKJ0SYGMlSNdAzFl2MhAFT/A?=
 =?us-ascii?Q?hl+XeWGKS7ocDpKAqcv90aIOzTPEXsPaZITilBiJjr4ojOaiDkhJhY1cpi7E?=
 =?us-ascii?Q?i0XLcOKuReFk3fyocUrI0mG2wf/vKf2FG6HT1JQLg3bYgqR3b1aZyIvSqflV?=
 =?us-ascii?Q?EdrRpP+ZlJnoZmXTuCRzzrjThw3GvwxItoKbOswMRNn//AgX9dSgfE4umiu+?=
 =?us-ascii?Q?lRe92rHNqJ0Zan5OZu0QJiJxXm50oecRftP8iLoYe00cerHpMTSlXxc/Z/rI?=
 =?us-ascii?Q?3r6LwrAc8yfCR4NMNiucyDVMfKdMPMLsv9idlOleXJ1FaV4vhLt9SceFY/EF?=
 =?us-ascii?Q?yyXPKQprZGXuD4xihBqsFFxuCeFEKKF8Z8yDsNXDODYbUXbXSXXz+T0S2XRq?=
 =?us-ascii?Q?Ac9Sm9vhMYowRnOU8aIRUsBpcNzLFOn7GPTjPrdCQiB0xvdhnbecay+hhy9c?=
 =?us-ascii?Q?PtIxAgO8z4Ho6HBjp/N/I7wF/B2wQ0bnfZwZQrZrF8U+XiqRg+TB+lsPNTct?=
 =?us-ascii?Q?mbzlwg4NupWryPaVdxcj6MtTgkUVqUP0n1XhmWvC/6GPsiWoTPoLxxFEkQ/0?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81152dd6-c9fb-4022-480a-08db3a052bf0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 20:50:09.1293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rkTnguh+hGVf/O9/oAJQEVz6FVRJvO7QsSvf1FMMdn46qOejF9QGH3i4bnjozwwSHT4WHU+uoPFGAW4dslhMcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7960
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a structural problem in switchdev, where the flag bits in
struct switchdev_notifier_fdb_info (added_by_user, is_local etc) only
represent a simplified / denatured view of what's in struct
net_bridge_fdb_entry :: flags (BR_FDB_ADDED_BY_USER, BR_FDB_LOCAL etc).
Each time we want to pass more information about struct
net_bridge_fdb_entry :: flags to struct switchdev_notifier_fdb_info
(here, BR_FDB_STATIC), we find that FDB entries were already notified to
switchdev with no regard to this flag, and thus, switchdev drivers had
no indication whether the notified entries were static or not.

For example, this command:

ip link add br0 type bridge && ip link set swp0 master br0
bridge fdb add dev swp0 00:01:02:03:04:05 master dynamic

causes a struct net_bridge_fdb_entry to be passed to
br_switchdev_fdb_notify() which has a single flag set:
BR_FDB_ADDED_BY_USER.

This is further passed to the switchdev notifier chain, where interested
drivers have no choice but to assume this is a static FDB entry.
So currently, all drivers offload it to hardware as such.

bridge fdb get 00:01:02:03:04:05 dev swp0 master
00:01:02:03:04:05 dev swp0 offload master br0

The software FDB entry expires after the $ageing_time and the bridge
notifies its deletion as well, so it eventually disappears from hardware
too.

This is a problem, because it is actually desirable to start offloading
"master dynamic" FDB entries correctly, and this is how the current
incorrect behavior was discovered.

To see why the current behavior of "here's a static FDB entry when you
asked for a dynamic one" is incorrect, it is possible to imagine a
scenario like below, where this decision could lead to packet loss:

Step 1: management prepares FDB entries like this:

bridge fdb add dev swp0 ${MAC_A} master dynamic
bridge fdb add dev swp2 ${MAC_B} master dynamic

        br0
      /  |  \
     /   |   \
  swp0  swp1  swp2
   |           |
   A           B

Step 2: station A migrates to swp1 (assume that swp0's link doesn't flap
during that time so that the port isn't flushed, for example station A
was behind an intermediary switch):

        br0
      /  |  \
     /   |   \
  swp0  swp1  swp2
   |     |     |
         A     B

Whenever A wants to ping B, its packets will be autonomously forwarded
by the switch (because ${MAC_B} is known). So the software will never
see packets from ${MAC_A} as source address, and will never know it
needs to invalidate the dynamic FDB entry towards swp0. As for the
hardware FDB entry, that's static, it doesn't move when the station
roams.

So when B wants to reply to A's pings, the switch will forward those
replies to swp0 until the software bridge ages out its dynamic entry,
and that can cause connectivity loss for up to 5 minutes after roaming.

With a correctly offloaded dynamic FDB entry, the switch would update
its entry for ${MAC_A} to be towards swp1 as soon as it sees packets
from it (no need for CPU intervention).

Looking at tools/testing/selftests/net/forwarding/, there is no valid
use of the "bridge fdb add ... master dynamic" command there, so I am
fairly confident that no one used to rely on this behavior.

With the change in place, these FDB entries are no longer offloaded:

bridge fdb get 00:01:02:03:04:05 dev swp0 master
00:01:02:03:04:05 dev swp0 master br0

and this also constitutes a better way (assuming a backport to stable
kernels) for user space to determine whether the switchdev driver did
actually act upon the dynamic FDB entry or not.

Fixes: 6b26b51b1d13 ("net: bridge: Add support for notifying devices about FDB add/del")
Link: https://lore.kernel.org/netdev/20230327115206.jk5q5l753aoelwus@skbuf/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_switchdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index de18e9c1d7a7..0ec3d5e5e77d 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -148,6 +148,10 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
 		return;
 
+	if (test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags) &&
+	    !test_bit(BR_FDB_STATIC, &fdb->flags))
+		return;
+
 	br_switchdev_fdb_populate(br, &item, fdb, NULL);
 
 	switch (type) {
-- 
2.34.1

