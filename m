Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC14363C233
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbiK2OOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbiK2ONh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:37 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1f::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD3E63B96;
        Tue, 29 Nov 2022 06:13:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByQEX6GwHGrKLSOJHno01TP7iL2TXwAKZrT+8S0GPpbeX+O6HngwTOR4iBxC6f3Oy3mDfGtfs2ygXue8Nl/VoJimR4TP03fx2J/ZiC3+aD2pcjS6J3Wf2Jdm09tNwGFWiKiUuH39N+9HmF67+pxK73956L3Ajsj9Du9O+eaX+u9Z3rCSk2AupyJG/onj/B5/jUw60YiXRtXF3rtnUfxxgIDkEh4S9H9cu0xW3y5upha1DLvSVqgVdfMU7FEOzfP78ot1ZH/NjE6oI3vlus+5DjRAxoUT00qJhk6VUl7DmeRTaB7nbZ7+Huf8ncxgPybU2XA07yhrUvSc0ePUNpm52A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J8DlRisIiHnp2xiTwrVLeF21nY63Hu+T5ak0mf0tzrk=;
 b=nrYaGsffXbLXvGOZ0n8hFxU78nqhNygVHwCNY8l2aS5wFJpztRW1quDX9NgmGQg9erLpfWVzXUYYEr1jM114l/YrHz4aJCsTInrmStBA3NboJosfNHxakCtlzumL7EjaLClesJqZCO+4S+aVM3gqrNJAODaNocppxNHJM8lelHR2kMcK1HtumVKqiPnz828s9KOO9kx+AWET8EQ/q/HLmIQx3gT45dp6KimUNhxbXJsWGfJrv/l+GIqZUJ6AGALWdZHeMGaze0zkdHQSuUuCuYxaISB1UNVf1TcFjsSPvjqCNbelIooK92OZ8TpkaL/sWggZBhtujfKForTQSeryag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8DlRisIiHnp2xiTwrVLeF21nY63Hu+T5ak0mf0tzrk=;
 b=MDhAe1rTIiEDagb+tUzf5oFzLubmdWdp5aKXQSSwNlzqRwyHWQHbbDdjk8aEwSdwwEuc4Ho/eER7E+tfEggZ84RlYUQ46RdxhTgwSabWUaC6E5+4Hr+4H976wDA+pUlDiD2j25A9/0C26kzXZOtc31wZzXM6y/EMVyOO0WEhR/o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/12] Fix rtnl_mutex deadlock with DPAA2 and SFP modules
Date:   Tue, 29 Nov 2022 16:12:09 +0200
Message-Id: <20221129141221.872653-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b4cb2be-4618-4d2a-025d-08dad213c28a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4LT1ItyFYSvQmQsAcUyAE0JN6MyQmXo1EGqhBDkCBltFn9w4RYWZRIwaSZe8XHTgldIoGxFTDC2R7bl5o+NYmH6f5dwT7p6MMIomuTY7e1OOjqdw6UVCQ3z19xWGeB6fHpxD+NQb+9EVMvT79OZ2yaPv+kaceI2REoppnkVuVwbBzAcjJuqIY6RblEcVLMxNveLc9gTwfqTWBwSy8qflG/efT6DONKvlPUklbOks1TonCVlwCuuKL381Td72hxXsbRlQp5tZiMc9kzC9mac53pmtFj9UhWM93t8U0PfE45SrnyetIbcGNeA93oQONDOg3oZFezvLxF5D3a+vJW8+CHX2kaSby06Awm2YDveCQI6ku1MEnB2hIi1tFudgJYX0+WnBHXvMVPN/AfudRzvfYaYmDdR5wpqI0MKa5utPd+bauGtgVK+kKo4ihRG0qbA1PMpd8vge8aCMqhjUvSmIM3mRGn0RzlfNAd6F46porfmjvCRA02AgHT/dSo7yK0z3RdcYGo6V4wPUjRQrXrMQAhAeknmtvB16E0JtJvKBX4KwAj5c+VReFLUe1qy/ZddgqN2P+fl41Hyizyc/SAFzOq3LfPW4p0agE+DD5IdAUvIqxns1jmgHpVM4Af6hHsI/VB/1DLoRiSSJPefc0vg9aJ2VQvRCOvpt/m2lv0nPOB4U+KWbcxHhNjorwZ7pQ4Qi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yxTrO2wEnt6Q2bKZcxqKdc+WPUx+6UtBTnxhiMXT6oA/2oCs0fmeq1ipEfim?=
 =?us-ascii?Q?v+XLKlVe/U3I1jCTpgeV0ABxBNLIfbMCQbtINydboZ9HuscOtTUWsnHZXuML?=
 =?us-ascii?Q?IakI47stT4s2vaW+GQP1qiaMY2+0ZxkSrHiGZYvvrS5pJWxWRWV0LyDfeg03?=
 =?us-ascii?Q?ZYsmfHc4+VSaHS5h0iAV46GJHSuct+ZyMlqA99ov1xhYkE0mSF+m0FA9lVTN?=
 =?us-ascii?Q?WwV7HAtsMwdEvlquHRcj5trUn7OEAkTr+STIgA1TRjHBwwCE6cp5Bs0wLw82?=
 =?us-ascii?Q?D2jNZdFgoUyMZ631yT7Jyeo5gvr4M+OIHuE3zSuO0aGLjE1Obvs0Jegbzkmb?=
 =?us-ascii?Q?OGiefmw4gIcDhq9QAHZc1G7r28rIe5An4FAicD+C9dyJdCDxnl590JmJh5d/?=
 =?us-ascii?Q?WkovPm0i43aqq6HDTSLAfwPyaHfOE2SJdDxftUJYwLQ2MRuUqs8SgikYa6wJ?=
 =?us-ascii?Q?JLixx9VgA+Nsvjv0WKAEvdQ69fjeyx3ETt+1/e3qJHH1AnFPxxxW9KRI2JsQ?=
 =?us-ascii?Q?D8Yx9+cBcF+3dbyTPh26QVwg9YK3gLJ2XsBEIZ9a/6QaJJqWnKLu+aEfu+06?=
 =?us-ascii?Q?kBw4kpQ50aGrekKxogY/GoPQtliaZE3SKvMzgNKA2j02cvZ324l5rfwLSCQA?=
 =?us-ascii?Q?UK2c84FA/yeA3+ZFED/To535DgWfUb9qcje6RiCeyNT4mJrr6gGXCB6BwmFT?=
 =?us-ascii?Q?QtPV72BzkVxRuF7bJxhAVkglvg5Qkvw9oajWFyMHXkjIueUsiPTSVOUIasS1?=
 =?us-ascii?Q?fXHa9TrKLwJivxbYgtuG3DBA8q+I5yaaa8y9CloGAFV+jZ5OQKgL7MsmMbF4?=
 =?us-ascii?Q?+vI902CsLNWMjzbHuUBS69Kv/n3xmeVSraqg/e824ja/1htcuEAEAAUnE9UC?=
 =?us-ascii?Q?rOvjKq3a9d3sUlxlT3aP/6JxGzYMZ1keXOCoZj+Gtsu9emMw4FuVv27Mtp3Z?=
 =?us-ascii?Q?+UmaYTth9vPNLI61zNvk3spn8c08io3B+uzzITvhtTtgofrbkzazZE0IUlcJ?=
 =?us-ascii?Q?+YqIJAOjR1ejEMu9NlsNi8iKNdPonTWwDPbgYij9krOUK0249WZtYz8T5+6a?=
 =?us-ascii?Q?zZ4sFIQswk2dQ4dcYY6i88FyLJdixc9+hagmRKTeTZHoEWeljZ9N7lvuJNfr?=
 =?us-ascii?Q?PFtN706KJr3X/LGv9tlGVFeE8qrQFo2VNtH4bYjNO2VJarTGVa05eVOUPIkZ?=
 =?us-ascii?Q?0At94qXnQksu5TovLkodja+F1bKgX1d7pIjl5SI3Jj44UIQp0zermW1AKRvt?=
 =?us-ascii?Q?qM/2Er9JgUfBOiPfPNpOFPb5tL/AJepYKQUWoVkrOu+SwvgiHAR/g5dZ8a0T?=
 =?us-ascii?Q?A8pbcmHJR8+LNq7TkQjIdbWRV+XvPl4G7P1akhtqpOlSIk2o40lhsbQ01bf0?=
 =?us-ascii?Q?MMD3JR7hQbsMT9nQ+6f1lcbObVnI5MUT+aEL/efx7Lc904SMvZuv+XNgXcCi?=
 =?us-ascii?Q?wKvC2WkgeoxV0M2RsWu7UXxZRubbQV4SQJ3wInP7cFOobRpc18Aa/MOmNQJP?=
 =?us-ascii?Q?RFxlsRhLfawokxgZ7SBoE6AH3GQxpaEge0nRcXp+W55feVOQwYg7N5Ria4A+?=
 =?us-ascii?Q?2BoqanGWSnykvrd2KX95F/YSAjjl2feCZyGCLnIr0ZebSQT+xKKWSSJnQk5Q?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4cb2be-4618-4d2a-025d-08dad213c28a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:33.8569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/TQ+ULxy6biWgpvpJerToEeIp7wTGxYUWq8gDPvp82fGQ736bfD61wXYmsHW5Azqkk8GxC5+YHfCjJH8vgQWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set deliberately targets net-next and lacks Fixes: tags due
to caution on my part.

While testing some SFP modules on the Solidrun Honeycomb LX2K platform,
I noticed that rebooting causes a deadlock:

============================================
WARNING: possible recursive locking detected
6.1.0-rc5-07010-ga9b9500ffaac-dirty #656 Not tainted
--------------------------------------------
systemd-shutdow/1 is trying to acquire lock:
ffffa62db6cf42f0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x1c/0x30

but task is already holding lock:
ffffa62db6cf42f0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x1c/0x30

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(rtnl_mutex);
  lock(rtnl_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

6 locks held by systemd-shutdow/1:
 #0: ffffa62db6863c70 (system_transition_mutex){+.+.}-{4:4}, at: __do_sys_reboot+0xd4/0x260
 #1: ffff2f2b0176f100 (&dev->mutex){....}-{4:4}, at: device_shutdown+0xf4/0x260
 #2: ffff2f2b017be900 (&dev->mutex){....}-{4:4}, at: device_shutdown+0x104/0x260
 #3: ffff2f2b017680f0 (&dev->mutex){....}-{4:4}, at: device_release_driver_internal+0x40/0x260
 #4: ffff2f2b0e1608f0 (&dev->mutex){....}-{4:4}, at: device_release_driver_internal+0x40/0x260
 #5: ffffa62db6cf42f0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x1c/0x30

stack backtrace:
CPU: 6 PID: 1 Comm: systemd-shutdow Not tainted 6.1.0-rc5-07010-ga9b9500ffaac-dirty #656
Hardware name: SolidRun LX2160A Honeycomb (DT)
Call trace:
 lock_acquire+0x68/0x84
 __mutex_lock+0x98/0x460
 mutex_lock_nested+0x2c/0x40
 rtnl_lock+0x1c/0x30
 sfp_bus_del_upstream+0x1c/0xac
 phylink_destroy+0x1c/0x50
 dpaa2_mac_disconnect+0x28/0x70
 dpaa2_eth_remove+0x1dc/0x1f0
 fsl_mc_driver_remove+0x24/0x60
 device_remove+0x70/0x80
 device_release_driver_internal+0x1f0/0x260
 device_links_unbind_consumers+0xe0/0x110
 device_release_driver_internal+0x138/0x260
 device_release_driver+0x18/0x24
 bus_remove_device+0x12c/0x13c
 device_del+0x16c/0x424
 fsl_mc_device_remove+0x28/0x40
 __fsl_mc_device_remove+0x10/0x20
 device_for_each_child+0x5c/0xac
 dprc_remove+0x94/0xb4
 fsl_mc_driver_remove+0x24/0x60
 device_remove+0x70/0x80
 device_release_driver_internal+0x1f0/0x260
 device_release_driver+0x18/0x24
 bus_remove_device+0x12c/0x13c
 device_del+0x16c/0x424
 fsl_mc_bus_remove+0x8c/0x10c
 fsl_mc_bus_shutdown+0x10/0x20
 platform_shutdown+0x24/0x3c
 device_shutdown+0x15c/0x260
 kernel_restart+0x40/0xa4
 __do_sys_reboot+0x1e4/0x260
 __arm64_sys_reboot+0x24/0x30

But fixing this appears to be not so simple. The patch set represents my
attempt to address it.

In short, the problem is that dpaa2_mac_connect() and dpaa2_mac_disconnect()
call 2 phylink functions in a row, one takes rtnl_lock() itself -
phylink_create(), and one which requires rtnl_lock() to be held by the
caller - phylink_fwnode_phy_connect(). The existing approach in the
drivers is too simple. We take rtnl_lock() when calling dpaa2_mac_connect(),
which is what results in the deadlock.

Fixing just that creates another problem. The drivers make use of
rtnl_lock() for serializing with other code paths too. I think I've
found all those code paths, and established other mechanisms for
serializing with them.

Vladimir Oltean (12):
  net: dpaa2-eth: don't use -ENOTSUPP error code
  net: dpaa2: replace dpaa2_mac_is_type_fixed() with
    dpaa2_mac_is_type_phy()
  net: dpaa2-mac: absorb phylink_start() call into dpaa2_mac_start()
  net: dpaa2-mac: remove defensive check in dpaa2_mac_disconnect()
  net: dpaa2-eth: assign priv->mac after dpaa2_mac_connect() call
  net: dpaa2-switch: assign port_priv->mac after dpaa2_mac_connect()
    call
  net: dpaa2: publish MAC stringset to ethtool -S even if MAC is missing
  net: dpaa2-switch replace direct MAC access with
    dpaa2_switch_port_has_mac()
  net: dpaa2-eth: connect to MAC before requesting the "endpoint
    changed" IRQ
  net: dpaa2-eth: serialize changes to priv->mac with a mutex
  net: dpaa2-switch: serialize changes to priv->mac with a mutex
  net: dpaa2-mac: move rtnl_lock() only around
    phylink_{,dis}connect_phy()

 .../freescale/dpaa2/mac-phy-support.rst       |  9 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 87 ++++++++++++-------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 11 +--
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 70 ++++++++++-----
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 16 +++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  | 10 ++-
 .../freescale/dpaa2/dpaa2-switch-ethtool.c    | 45 ++++++----
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 59 +++++++++----
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  9 +-
 9 files changed, 212 insertions(+), 104 deletions(-)

-- 
2.34.1

