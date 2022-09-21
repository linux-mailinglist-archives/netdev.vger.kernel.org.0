Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3EE5E5370
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiIUSy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiIUSyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:54:51 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130079.outbound.protection.outlook.com [40.107.13.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B413A357C8
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:54:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g326MM/XNEqn8XOE77/9CljPuqlLLNNJweZCbt212xRH+icURpqRiNW89Kr8UnxHjSoaGgQwDJZptSCYweu/PyX7/AX1UTH+FnknpSzxCP5M7ZvHKtZTZcSMPi7ITZgTc0hFsxvvDfWzseOoEpHvXmUQ9YvllKvMzyvBKcApwKkbOSLIAauXNp5Ny5heSBY/mzPbeoGMM41OeoUQx6mEvrCmk99bOcyWdfoTQv0e2F0ie21vjZrQjpPiYad20/7ZS7qpqJW8OFExZaWvwIst3fjnkOti6n5zrGM2OiOeq8BxvludFi0jptlmhOTjgSCLLjiemYLudbGHXaNZvttarw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jrvXCdjEBSihiiWmvfEqFXxugIoemk9scmwrhC7dQW8=;
 b=IJAnsDwjuP9yEWZk+mA9bBQbDG+qMKg/DFKejL92bnYJDvXKCVE0EgpWlJl7z5hhQ0f1fV0sJT9Iq9IFmipz7mSn/KGq8e6qgjgRcC9jrrAA1N4EJpWo2TojL4UyfFeQ5kd0YtXPIPhvTxMCfvOGkUPvPR+G4shO1Cyq7TW/BUh58oqLudy6w2vQm8L/vITPrb/9y3TWCSCLkkItAzjYtWts6ov6LdW5ulTyfh0QWPWEOIBoofVtklHLQ60btpdPHBfWk7ESXNjn11u5yxSu9mcIVwFdArvPg7+p8ENSgFtVPUuOzw6cc1/EkStP/apDRI8f+kBA+1xifmRxAn3IOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrvXCdjEBSihiiWmvfEqFXxugIoemk9scmwrhC7dQW8=;
 b=BAVa0SFXAAfIYwvvLxlLIC0DBczndvd6z5+YmEhPkLXtXMQfDQNwxFFHub/klDbtte50HOo8gfIUpMmjFJCEhggAVs+F5CC4o3HEtb8CpcOAv5iSqRWigV5A7yfcMVle9nan+Y/b9qBTFC7EGnsnqbaydQ62KYzVO/Z78G6hKnU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6958.eurprd04.prod.outlook.com (2603:10a6:803:137::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 18:54:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 18:54:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] net: dsa: make user ports return to init_net on netns deletion
Date:   Wed, 21 Sep 2022 21:54:28 +0300
Message-Id: <20220921185428.1767001-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0190.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB6958:EE_
X-MS-Office365-Filtering-Correlation-Id: 5adbfd18-27de-40e4-833b-08da9c02be58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nbebJH0Ygz7HwgeEuukgM95mv1868wD8gAyKNb2175Q0dehgFS8/5+qEEWzxGXOfIQW36MdBSSAGJfkBwksPwd/opqP78yj71DyrccQOKax9l2Kob2xq647q9+GvNAxYR09sSzFtF5rkIN07UDb0cDu6U06RYtPMMLZEfRu+tmKbywWdcwhAU9eLDXb5koHaox40anDaulcn8zEeld8LWa1gvxIVO20AVDQ2ivYMRXpj/7Ks1/RvBk+Tw2AGR9s5Xe9SJi5ANM6DxNKuU87ByjTw56onUaMUbaT3MLyHB67nW3lih5oxj8GNy64jtnGhYPs9T12qEUPnZzjPlXOJken8VpYEOzbzRuntPOiBL+/sU69tsRV5p6paUv2wi0mvfhFkcKZRlwXuhQtBpeX3hZq6/SGVL/5qNZgMFa7sUnn/oqP5J3SNRedUROT2puUWOISv39AFVjF3PpXnyXU/HAx5cD5FgOIKYl9WOO2qBRQejhUOozPuWBUGJkhHcKQ6caDMumzKdlOq0DA17aS5yiusGUtWA5fP3N4OOyDtkbIwN4S6UIrqwO2rDqySHsgeoaLEKNbu2S+ERKFS4fzAx59CYrcYyhCHhsEIGQ47ISl+clIsYcoU1+zxvKOQG4tzHL9jWEyYE38lptJ/e5F1pBWMW3COruoW3nmlGqnunklpqptxlF9FObI7QLae6BQjlVBlcTQYnoyVXQvlawusOgA2fURXH9+ayovvr+KwkEYsQgYv9S5ovB5Z3+K8afmW3SNGF3+nqKz4wUFlhTgwzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199015)(478600001)(66556008)(6666004)(66476007)(54906003)(6916009)(4326008)(66946007)(8676002)(38100700002)(83380400001)(44832011)(38350700002)(36756003)(2906002)(86362001)(6506007)(316002)(26005)(52116002)(6486002)(5660300002)(6512007)(8936002)(41300700001)(2616005)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Al+sFRlYLhfebaNBSo65bgbDuAjbO0P48cWSusDKPj73eLCf8CFf3D9bDcj3?=
 =?us-ascii?Q?kNrQP0zzWCPFeD7QXQ/K91TyGYckZbq1eg8avgA+2oXU1htrN74T2Ffu5/5J?=
 =?us-ascii?Q?NujFvGlAt95z3g6pqROh2MmcANuMKPIHcUg2G2Erec5bVXORwGX0LaEpZ7fw?=
 =?us-ascii?Q?8wKhrhRWGr1HWKqQ4v4FGwSV9o6z1vstk1WyF4iQbuqVzo0weOw0FyN+QApf?=
 =?us-ascii?Q?pw+NTbIaHVPWQsM67KMj6gKeKhwZwp/738nWqArcm4sbFrllLvSHVVfB0Gxs?=
 =?us-ascii?Q?9NE7im8jxLk40BbkSCLBTrsbzt1H9bLciJRXk2bb0Sdu8Mz654y3hETSQxNf?=
 =?us-ascii?Q?9HzzILkVEcJdnAwVAQ6wwdjKVXs0lyj6alhKZuhs+f59eFhkUEu2bLC2ROu6?=
 =?us-ascii?Q?89lsDUNz21r2jMXIdEuoy8czvG3o6Bepecr68GWxTxHbLl6N3I1UkNKW8LkJ?=
 =?us-ascii?Q?pdM5Rav0m9Q5O+mVMyN5aACexBCvsXcQZinIIFTjMswCnjkZX0zpxFo0ZSgu?=
 =?us-ascii?Q?QD/4N/KVoac7YW0gCL0MV8H+zzbL384tJwsHKV5nYuER5mO/FUUxDEsQSWUE?=
 =?us-ascii?Q?a6NXWo0hqrsT1qbGPw8/6H2CF5LEUvf0cXD39SShZJYHE/uIc9nnMjVPxLgQ?=
 =?us-ascii?Q?emXE9FN47S6L0RULM0W+7d0Sn+JcMox4CX9Issjl4NFdMGpUoxKxrac/pQGr?=
 =?us-ascii?Q?E9igJXzaHkhA69ihuLXZjZ7HVZS5t1e3Aeq5Onfn3VlPiJwoT+D9DZWwThxv?=
 =?us-ascii?Q?RFJJSZ/BgsPR5de1sMRCdJusQZvG9iqIxCJb3RmEgB/E6eTDRUIVWaH7AnMR?=
 =?us-ascii?Q?txMqYJGVbqVfZVE1RkMB+mcKdmP6qNqt/EgZrSrJ5C9cwiVGKQQ4oBluwSaq?=
 =?us-ascii?Q?lyEi3EuSuNWxHNriY272EPxx+8C2NtulT13qkmxhgHuoJjhfk9e1/P19qwLt?=
 =?us-ascii?Q?Tyc1k9AmWQ46i45HLuuNLkCx9oIl8uysijStT8NpjSWjRkpq4xtNoTVjBOJO?=
 =?us-ascii?Q?5X0s4gFyseL+iIhv/wzg5bzPU+78InE8oonXEc1XQe9Ghp+Blf1MqFNSdZYi?=
 =?us-ascii?Q?l3RmClOohP/iw/6R+Bb2qDFcabVB+xb1KS3Qmye9EqO9KNDOAB8cTMcJpdPq?=
 =?us-ascii?Q?mYNI7pPY+B0mBCj+sKzJ/y7lOr/Kuzj612f7uCRAZ6nJJxuTYWP7ky6VkqjG?=
 =?us-ascii?Q?eCmywacqdy80dkxoM5fjJrj6ZelA+W6WcnTS27lc5h2vfvg2s40w6AXh7k07?=
 =?us-ascii?Q?mGlnNfUO+7sYA8sWU7KB5o7wM1i7lcUo6b2MBatlLarzIES7MyqShejV0zJz?=
 =?us-ascii?Q?xuzy2EnKHFH9Z9OsY/6KfBLknMmcQXaEPhUa/9cwcvpTPzyGgSzxQ5N5ADcY?=
 =?us-ascii?Q?VQKCNgO+GdUEN3IjgQEy0yQIpILTED/m0VExaVqc70RqTP4be1TswIz8YCHY?=
 =?us-ascii?Q?NT2j5flk94gXPXRPWXiE7rmZx8ojptS/Rz1nmilJqOjyzTQ482F45RKlVP64?=
 =?us-ascii?Q?U7K9hLPBUAidyrUOzZ1Ye0KZkPIy/uj5iU4RIvp5AgHdxCwXHQglpreTpMJ3?=
 =?us-ascii?Q?iI96JrbUxJM7MJA38EsUF1Q0Px+laf+5rNxEAueoKjJWjOF/24QAZXq3tYG/?=
 =?us-ascii?Q?4w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5adbfd18-27de-40e4-833b-08da9c02be58
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 18:54:42.7591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YvwLUpIe5uf6RLUXCWbtjZLXS78x7HSfbJVxOQcMFOJ3ZPjLJ5A/1w7DO1oxUe7VY9Ivxgpq63CGRD5Oquuwuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6958
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As pointed out during review, currently the following set of commands
crashes the kernel:

$ ip netns add ns0
$ ip link set swp0 netns ns0
$ ip netns del ns0
WARNING: CPU: 1 PID: 27 at net/core/dev.c:10884 unregister_netdevice_many+0xaa4/0xaec
Workqueue: netns cleanup_net
pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : unregister_netdevice_many+0xaa4/0xaec
lr : unregister_netdevice_many+0x700/0xaec
Call trace:
 unregister_netdevice_many+0xaa4/0xaec
 default_device_exit_batch+0x294/0x340
 ops_exit_list+0xac/0xc4
 cleanup_net+0x2e4/0x544
 process_one_work+0x4ec/0xb40
---[ end trace 0000000000000000 ]---
unregister_netdevice: waiting for swp0 to become free. Usage count = 2

This is because since DSA user ports, since they started populating
dev->rtnl_link_ops in the blamed commit, gained a different treatment
from default_device_exit_net(), which thinks these interfaces can now be
unregistered.

They can't; so set netns_refund = true to restore the behavior prior to
populating dev->rtnl_link_ops.

Fixes: 95f510d0b792 ("net: dsa: allow the DSA master to be seen and changed through rtnetlink")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/netlink.c b/net/dsa/netlink.c
index 0f43bbb94769..ecf9ed1de185 100644
--- a/net/dsa/netlink.c
+++ b/net/dsa/netlink.c
@@ -59,4 +59,5 @@ struct rtnl_link_ops dsa_link_ops __read_mostly = {
 	.changelink		= dsa_changelink,
 	.get_size		= dsa_get_size,
 	.fill_info		= dsa_fill_info,
+	.netns_refund		= true,
 };
-- 
2.34.1

