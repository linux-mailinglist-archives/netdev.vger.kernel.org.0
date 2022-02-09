Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD1D4AF12E
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbiBIMPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiBIMPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:15:31 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80083.outbound.protection.outlook.com [40.107.8.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76703E032ABE
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:04:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0k0dmMQ7ozO03QFIWY7hzgRiDuDN6p5d0EuYKCRipxVyzGQfqDLiKNRhYETarrmWSoV644x13P1TgSmv5DXuMKoSMSAVniYAP/NdpxBXEy0Svy6lbBuJyBoxSJRVov62cP0p4Rwa29QaEp0dM54LjHJhnXMRZfkAbn25/7FeQne1DzycMd4cIPun9/UGgFmVrpRSwpp+UFSSLd2nj2vQqf/8Ll2lj3SJ8Rv4DYthNpF4MUNWqtzn8jljFXBfo3BiGA0N5a/waxyBBXRJq4y3dUtRWiLlFWYPgxwbIVJVjFpfoyr3F7wezAMvhxsckNSmlpdfHZmhaUl2QhhHCVavA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0fqnLdcQadiPz/ntuCBxJtpd2ai6kCJZeQU0QqT9Xt0=;
 b=Q1mt/XccUk+csHdCFeLoPt401/qBAfx/cv/L2ZQFXmkAwwApkNkykcXfHeU2FJ1vtvL43wF2Td0NT8VvwMG1U86KakgMtmNJTvcbBruxOWhB9MGUJh+lG1kVvmJ4FdpLHQGyqbiIsTQ40af9xKAZv1X8Mt3Xonhywk/sMuZytO1MHtyeE5ulbg+xeDVQ4mzXzwa4unYem5oOHvXDIX9pusx+nZbtH7lwFaDZPAB+IE1RCfoZKNZA5VE5D7cAiVMpECSrZvgSK8eIFlYzr+nqFogljYsGZ5FPJGsBo/r9Rf5ZtiWwrdHfn3eXk8vEqvOkqAVLuzx/xlDjOOykQohs2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fqnLdcQadiPz/ntuCBxJtpd2ai6kCJZeQU0QqT9Xt0=;
 b=QLtLyWzNyiOtznZtZZts38C0S/lMvm9iumK2UhwNl4ICsfQwVf1K4TE3tCGCn7FR9O14jZ3oDVv8kXJF/yLzc9/b69gT/909IY48i3oweSiHu+t8a9hT6RzlCvINEhKmLy3+DV7FcBeS0HljxHX669tjiQCMgHPE9ThnSokgOXU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5732.eurprd04.prod.outlook.com (2603:10a6:208:125::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 12:04:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 12:04:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH net] net: dsa: fix panic when DSA master device unbinds on shutdown
Date:   Wed,  9 Feb 2022 14:04:33 +0200
Message-Id: <20220209120433.1942242-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0161.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93db56bd-4e31-4c00-4a09-08d9ebc45c26
X-MS-TrafficTypeDiagnostic: AM0PR04MB5732:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB5732469738CE1AAF27C12920E02E9@AM0PR04MB5732.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DNCX3ah1jwF2RauI7193iTXAqRnz8dmfE8rmG04CYH+7imCVzwODKykH39/ctoXowWW2Yp0/XH9+5L7uildGoEcjCq5RsVh6eCCen33uh7/NtUiPMu7kGbOKHm2RjeeOK6HyeK6Ks3rSz5Pm7cqy9SGyAytG8DD+1U5AQZ+kytV0Bs00EYTsLQmSqPl7w3UXqT8CLtwjzGTrrwRwQgkU4PNwjUnFbw8qNtN79HKwU2DJJb7Kje8YKD4mJ8NCgzojKfEXu0U4tfN1WT9R7HanWvl2MpGBbb3H3b3phHanRvGDVHYsxT+awb4Qhf7QF6zBpp9XB+1jHyarLtpDVD9iouCM8UIclQH8mKNyhI2YIzhk4WXGylutoFCnX3LNRTRLUZmJBAXGjfANRErzneBs+78Ui/Nu1LJVO1+4HpiDUojt+OTpsSeHnoRrdWV6ow6v4yS6FfC+avLN72Br0DMjfpABwmEj7VO6dJxom3cHFaqvTBACKjcquCftYEmrNcpsOFYTaHjOE/wUue4g33cl3sKqadkv+4uqxgauI//vrWv7F+xC5NHVXJMzA236rseXZwxmJ+Cc58mkSE2gNO/P63egdCTxV4rAxG2hlDEfUF1BqnQCryrad+hFhweVhXhpjaBf7NXXevs5EYfO20gmhFaXh1B22Z2/1UMeFv07e8zWLD+iA+r53CnB/346JTgk1BXmCwSFnI3kVnscHg9WGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(5660300002)(6916009)(6506007)(52116002)(316002)(6666004)(86362001)(6512007)(54906003)(8676002)(66476007)(66946007)(66556008)(4326008)(83380400001)(36756003)(2906002)(508600001)(6486002)(26005)(186003)(7416002)(2616005)(1076003)(44832011)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YkySxnT2CgWgD1PSaZqiOcCUfExpwG3afkxg3U0ulXAuwrnAif7qzfSg0dFx?=
 =?us-ascii?Q?lDbwi/TY4MVVyjM4fPXM0JtVSnk7OaNCwuxA0fm+lKSYdqIUGqDXl8pK8oHQ?=
 =?us-ascii?Q?rgjy1at8M0WNZVy0NxNDec6vbSVKFqSAQcFBtuK5R8mCiUeKLZotkACKFKak?=
 =?us-ascii?Q?W8F2HSGoakGjrWrsiBKX1JF5/J4k63v6ynkJ1raDYqAR67GZgYRyvHdaNqRc?=
 =?us-ascii?Q?81Wd+RzMieSC9GENZdxG5KFPV+hit06FUzR6a1qFvt+CSL/eq5DljsUZWG/O?=
 =?us-ascii?Q?OZursgFeIk+GPqTWQkh746vF4E2t5y5R8ckcCp1h/CbdwMgYvow2EOMW1XwD?=
 =?us-ascii?Q?o1VIiBjpRkPTZnj0UvYdRMntlQOznZVVqrQCxpj2rHXnTHED7M9wTlixkLiQ?=
 =?us-ascii?Q?UJC72QE+ULFCWqV/bdon/fzIGXb+BlDlJyZKXf21BZYx6G2Mfc2oZ1I5d1D+?=
 =?us-ascii?Q?/mgpgsh83hsdptKOR3Uos38mRzBk1ZJ6uBUUM1X2s6aW6Kp3W+dA1cal66NN?=
 =?us-ascii?Q?dUO7VWTosVCQLEoWdb4glk/LBsgtXXuJsc8KnwUgIHw48/eIRHuP/w+AjfxQ?=
 =?us-ascii?Q?IVq1t9iUf8zlSZHcFfDEgihXlIdMiNQLwbLDoSrs5zCx7gAYoE6TVmclY4Lo?=
 =?us-ascii?Q?J98/BJ6otTCJFHj6aBDfIFA+no/3IZHIKR2rNcgbS3ub72Ny/YwAre4SHfct?=
 =?us-ascii?Q?j8vomDxymVAsQKQCR2FDJRbg1v1WiNOlr9k8A6VojYY1ZqIHgBQXmTFSbFh3?=
 =?us-ascii?Q?ZK6il1mq153WqUT5tMqzsYWVCXhMOapfHFR7iPdSrJbgPOx3NeW0a4pq/krU?=
 =?us-ascii?Q?W37MJ4D7X1YXCsPagwY2MVofldC4dridmvBmCLxLQMaeuChqAoopJyWIkErH?=
 =?us-ascii?Q?ixrQq2Aw+tssVhmFRd3/+ZMPmBEzSh4SgYTgbLsuhMk1/9FziMRnTWUAhmJb?=
 =?us-ascii?Q?6xGjgU3prvQKU/BPiYeisu2+c2C7ehz3s4TquMVrieBJegwIgXW8DJWUikBC?=
 =?us-ascii?Q?jXNdgTKqpaXs9FDAnemRXwvLE8vVZfKTqLQXMEhSIQ22GjTUodaxMC9gK9rz?=
 =?us-ascii?Q?p2yfignvd4t+YICkqL5FzDSvQvqPDeS8Ed7Tr0Qx+zg6UOpEgXghy9SIiOrr?=
 =?us-ascii?Q?uapokCLCnldrtz9KbQlalj2hx7W48MyyQ01gphGPExJuxyTf8QGz8sHwZJgm?=
 =?us-ascii?Q?s6JDkr7WnsW8TrWQ+QB2jfem6l8KKMWx6xYSWWukdbDVKxlPAaQUC8gk1lQ+?=
 =?us-ascii?Q?b18AdhOnHCUMkznTQq6F8IYnJ7BSYXFL0U0F+ashazwRIE2k0MGFoHYjBERi?=
 =?us-ascii?Q?aRZt8+RcFkFBMU8Ntgf5kAqaTsx2ISgNmGUkLaerpNNfQQeSnGPVAo7n6/wU?=
 =?us-ascii?Q?2b/UlIUxpCNsx5hG7jHkJG4rS2i6BXkWcAPC6WZ6zSs7ixG2jMLT9S4knVxj?=
 =?us-ascii?Q?NrWJW84UcBl+m9BfwPQkiB/+veFdzX06UaH+xx1qQdwzc3H75jdxFu0ycHAi?=
 =?us-ascii?Q?K5+9Q35TqZAs3731Fh81CFgM5EhBrzk915wCyD5Aq5pJnQQJNfV/uKjb/B6T?=
 =?us-ascii?Q?/cUbLVDokzWHXiB0aijnPEcs18tjJd2DuG0mzKliJU0uGpfwSrIJ9XyKqLdM?=
 =?us-ascii?Q?RkZKyxV9Cgey6IlJ6Zkbim8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93db56bd-4e31-4c00-4a09-08d9ebc45c26
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 12:04:44.3953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kAHwhESv877IjXPkCG03ymgeuaCS5fOw0bTz+LVMganE0VY7f5deLCahoeUvL/UXJyITbdcypJcSUA9UNY4fgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5732
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rafael reports that on a system with LX2160A and Marvell DSA switches,
if a reboot occurs while the DSA master (dpaa2-eth) is up, the following
panic can be seen:

systemd-shutdown[1]: Rebooting.
Unable to handle kernel paging request at virtual address 00a0000800000041
[00a0000800000041] address between user and kernel address ranges
Internal error: Oops: 96000004 [#1] PREEMPT SMP
CPU: 6 PID: 1 Comm: systemd-shutdow Not tainted 5.16.5-00042-g8f5585009b24 #32
pc : dsa_slave_netdevice_event+0x130/0x3e4
lr : raw_notifier_call_chain+0x50/0x6c
Call trace:
 dsa_slave_netdevice_event+0x130/0x3e4
 raw_notifier_call_chain+0x50/0x6c
 call_netdevice_notifiers_info+0x54/0xa0
 __dev_close_many+0x50/0x130
 dev_close_many+0x84/0x120
 unregister_netdevice_many+0x130/0x710
 unregister_netdevice_queue+0x8c/0xd0
 unregister_netdev+0x20/0x30
 dpaa2_eth_remove+0x68/0x190
 fsl_mc_driver_remove+0x20/0x5c
 __device_release_driver+0x21c/0x220
 device_release_driver_internal+0xac/0xb0
 device_links_unbind_consumers+0xd4/0x100
 __device_release_driver+0x94/0x220
 device_release_driver+0x28/0x40
 bus_remove_device+0x118/0x124
 device_del+0x174/0x420
 fsl_mc_device_remove+0x24/0x40
 __fsl_mc_device_remove+0xc/0x20
 device_for_each_child+0x58/0xa0
 dprc_remove+0x90/0xb0
 fsl_mc_driver_remove+0x20/0x5c
 __device_release_driver+0x21c/0x220
 device_release_driver+0x28/0x40
 bus_remove_device+0x118/0x124
 device_del+0x174/0x420
 fsl_mc_bus_remove+0x80/0x100
 fsl_mc_bus_shutdown+0xc/0x1c
 platform_shutdown+0x20/0x30
 device_shutdown+0x154/0x330
 __do_sys_reboot+0x1cc/0x250
 __arm64_sys_reboot+0x20/0x30
 invoke_syscall.constprop.0+0x4c/0xe0
 do_el0_svc+0x4c/0x150
 el0_svc+0x24/0xb0
 el0t_64_sync_handler+0xa8/0xb0
 el0t_64_sync+0x178/0x17c

It can be seen from the stack trace that the problem is that the
deregistration of the master causes a dev_close(), which gets notified
as NETDEV_GOING_DOWN to dsa_slave_netdevice_event().
But dsa_switch_shutdown() has already run, and this has unregistered the
DSA slave interfaces, and yet, the NETDEV_GOING_DOWN handler attempts to
call dev_close_many() on those slave interfaces, leading to the problem.

The previous attempt to avoid the NETDEV_GOING_DOWN on the master after
dsa_switch_shutdown() was called seems improper. Unregistering the slave
interfaces is unnecessary and unhelpful. Instead, after the slaves have
stopped being uppers of the DSA master, we can now reset to NULL the
master->dsa_ptr pointer, which will make DSA start ignoring all future
notifier events on the master.

Fixes: 0650bf52b31f ("net: dsa: be compatible with masters which unregister on shutdown")
Reported-by: Rafael Richter <rafael.richter@gin.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 909b045c9b11..e498c927c3d0 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1784,7 +1784,6 @@ EXPORT_SYMBOL_GPL(dsa_unregister_switch);
 void dsa_switch_shutdown(struct dsa_switch *ds)
 {
 	struct net_device *master, *slave_dev;
-	LIST_HEAD(unregister_list);
 	struct dsa_port *dp;
 
 	mutex_lock(&dsa2_mutex);
@@ -1795,25 +1794,13 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 		slave_dev = dp->slave;
 
 		netdev_upper_dev_unlink(master, slave_dev);
-		/* Just unlinking ourselves as uppers of the master is not
-		 * sufficient. When the master net device unregisters, that will
-		 * also call dev_close, which we will catch as NETDEV_GOING_DOWN
-		 * and trigger a dev_close on our own devices (dsa_slave_close).
-		 * In turn, that will call dev_mc_unsync on the master's net
-		 * device. If the master is also a DSA switch port, this will
-		 * trigger dsa_slave_set_rx_mode which will call dev_mc_sync on
-		 * its own master. Lockdep will complain about the fact that
-		 * all cascaded masters have the same dsa_master_addr_list_lock_key,
-		 * which it normally would not do if the cascaded masters would
-		 * be in a proper upper/lower relationship, which we've just
-		 * destroyed.
-		 * To suppress the lockdep warnings, let's actually unregister
-		 * the DSA slave interfaces too, to avoid the nonsensical
-		 * multicast address list synchronization on shutdown.
-		 */
-		unregister_netdevice_queue(slave_dev, &unregister_list);
 	}
-	unregister_netdevice_many(&unregister_list);
+
+	/* Disconnect from further netdevice notifiers on the master,
+	 * since netdev_uses_dsa() will now return false.
+	 */
+	dsa_switch_for_each_cpu_port(dp, ds)
+		dp->master->dsa_ptr = NULL;
 
 	rtnl_unlock();
 	mutex_unlock(&dsa2_mutex);
-- 
2.25.1

