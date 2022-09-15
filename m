Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5245B991E
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiIOKvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIOKvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:51:00 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B7263F3C;
        Thu, 15 Sep 2022 03:50:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ad/ubkFHwy5ZuEWKUZEBZ8sB1bil+ugIo3DeIugDQZeJnjn6UwN0EmkZI40CbukjzTLz6yRKPJMc6yd0PkpUvUq5UEMy2MlOLinmLhZVk1u/yLgQ4W19975nWiweEczkHuDTSwXDNUaun8/5z3wXHrz2ez0NoahkihhPKq5gRq8zf/EzU8WS0xLLWVhArokYWVy+ZlR9Kz8xEMlvM8wBagU/ZPAM0Ie+mHgfrv8mO8fpF78hjifURZKhiAgrm9lNwc/jbG7aJrxDzVFsIJdANlvp872uIuPSopVAgHvUMU1XyTn4GO3ou3NzI3sLea61DcZdRERaCrjUoNK4knkmlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUImJlkI0WDHLi+DJXfMOVuitWYZFw8H466nqffNUYE=;
 b=LuvRC7JiNfZ0xJpbz4VxD/sgWGkSzm/ubkKCXHk+yLvmUoQ7arzWefUiwCh6u8SczHev/Ml5NsGkFu+DMrqIewnYhJ3lG9evSKlZ4kdyoIQf6JaTFweln7P6+VTwdZmoJegIgJ860EZ3zwe0C+Nu1g6L9FjEivPI6Y1eXX6WWNc4s4IrMxAQFQ8IRBiD0JnDvrJgro0JHt5TetBeeYw7NkbUIJexa8SgGq8dV/Dc3EYGAc9Vz6+vkRPOzIyFXdS166Wc97EN8xHY6sDK5AhGejghHU8XXtMmLpLi0VDDJOcAkhyBwhcWf0jQbHOBwB5k/gIxJtG/nSVZXr16EyYpHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUImJlkI0WDHLi+DJXfMOVuitWYZFw8H466nqffNUYE=;
 b=EXLB9uAh7oP89vjUcm0xIOSuuHCF9NSd+1gVuY8ai50o61N2hfOg+/CnOWMHqwLDgBYGxRxDoxRSW84y6Kg75MlvcT86XR3Ws+Q2ie9+KBtNrpaMI9vN9pAh4bkZK4Jxq9IK93TwKA8TuPYC4WNw6jomF+AAVkdaeN4cNf9JXcA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7163.eurprd04.prod.outlook.com (2603:10a6:10:fe::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 10:50:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:50:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 0/7] Small tc-taprio improvements
Date:   Thu, 15 Sep 2022 13:50:39 +0300
Message-Id: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0052.eurprd09.prod.outlook.com
 (2603:10a6:802:28::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: bc279002-8b23-4a42-5e65-08da97082adc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iH1yb2Q8tXg6PAUxsI6ct8r92tl3XaayQ+DGD+CKu0xyT3amSsp9qd2fTV5aL6LcU6DvRL6KuPCaZ1r1RWiROGvRSDZGXkqV3AoJiz9hU8DF2I3p0Cqf/e4qcJl0UGmfPNV8X9viAqG88PKQsbWe1dndq0lG+a2WtnNUKZDYrga/Ra3O7gbOX+la9Ez79zfcyZJIY9jZG4OX35q7ySr7oGDcWK/cPJU4eoDtBV0SMPiRPaAWIEV564tdoAGNUS+wV5HkydBv7OMuC8vh2gwUSy8PcSrKPOhn6YQudRiDVJ7mAIzMF0pdwE4zU48AwtrXaDBdWq/kkL8onlrRANcEKTTZeD5I3H66/BHXAmS48O82RoQ97sO9ezpK4s9pcbg5+uH4TQ2q62F6uSCqfnoe35/m0pkPuJ10K3uwChu6cp3aRYk90L7c+w3tnZFwWolTfeO1A4I2RpRfLwydpyYXSrv//jSGb2eMkN6v13sxCVPKekcWgP4YRqxlR43SMeS1SmOfhX5tfVDSYMy1TzWIayZzpqx5cg+tOwyp2aGx0c7ZvQIXr/vBdCwQsM4lNNEm44n7Q4W3i4oWCTatxo2Jg9GTa5zEqmTTfnh2ZAzRTvE217BVVohMeTM5+rz28rlP8T5OAopsLsIuxATaQAFDj/Wm5rEnxBNUiD/e3QgkzbkwngAcdIjPMWyg5n0q4Zw7DJhpQ0yBevDRCPHYvL9hCgen0UrgR5c4ck8u0fexnGWC8cjIM7S1tz/4TBGDRRtHmSOaQVjXxJmHxE8fRoAkjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(6916009)(5660300002)(6486002)(7416002)(2906002)(478600001)(66476007)(36756003)(54906003)(44832011)(38350700002)(8676002)(38100700002)(6666004)(316002)(2616005)(83380400001)(1076003)(186003)(66946007)(41300700001)(6512007)(86362001)(4326008)(6506007)(8936002)(66556008)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/XxfKwH8QNk8+f/qG1paEFTB19HNHRfGtxAkd+yy9Q4IKwSx+kEKNmeimeNV?=
 =?us-ascii?Q?zBpbBhUL1vQV6uKhNh4DDM2fr6kgMkGV3APmu8IXpUPRPGcZGwU530ThCAmF?=
 =?us-ascii?Q?gta6xBc+VGlQavzR+l4ZmgJMKBlP3PdT4muDIKvTHBnq+szXOfa208rQWlnl?=
 =?us-ascii?Q?EaE7hMOLJfxdu4NJMFySHhibMzeNtAS1Xf8nXvE/SMFEgHGuEMNWK0jLpDsL?=
 =?us-ascii?Q?jylt/Yjf6SH0NPTNaVQg1VlwoswfgTUY+grw5nzMN45xceQC7c3WLSTlmgCo?=
 =?us-ascii?Q?80FdGU1r3XC1LSrmLBbwS45F12hCjn51btdtFrAi7KumQ9FPcX1zUC/gc++P?=
 =?us-ascii?Q?3JtXsSLyVWDC5uaHb3MLL8NKB8YrV13Rx2d9b4GSq573E9m4G04E67c/D5R3?=
 =?us-ascii?Q?ESjRWKcxquguofNGXbpOWqjcd4497way7Z88RHjvaqKssYmYGB6tUaktJgaC?=
 =?us-ascii?Q?Ea2RJwjoNfJv26+9ZYoPnTd49odASE7NpIJovjEg5CYiZ7p58v1wQMsW/Rwk?=
 =?us-ascii?Q?jhD3Ju3HuRfCyQ0zyCsIjmT5oPydIPQXUAagNMFXvbQWfs25e+sx4NfuQ/m+?=
 =?us-ascii?Q?jB/w6zrg0aUH2Y6Y1K/hUcTwNANYmRPLBq+c6i1Fe2DFXzCaLsgslGNXFu0G?=
 =?us-ascii?Q?7zrUOKKB5jZDx/aSMkTUFc/dUbUhlXZ/NkoqpghR7zVVkuJmX8zs9zdUuwDt?=
 =?us-ascii?Q?VJU4P1pXytzIxKfmKIFfwyYau9mlMQqGWcWQw+rP2GSA09sUWYqNSUdrkgfZ?=
 =?us-ascii?Q?55254K5FxNOJtLO7cdGP4hNRCo7pUPQrZSStjSQEFUT1l1gGvc/W+qfklxmS?=
 =?us-ascii?Q?z+034QgxbZoMvO3Y8jyxu4b1TfRZJqn3FBqnDh8ECTQtUxcHumR1i9v7cVRw?=
 =?us-ascii?Q?QgkwdMxvPctrngbisDIautd0/fAJoEtg1Vu3apTk5zu4bpSoOzGtJCzmFJHv?=
 =?us-ascii?Q?8rjQTylLubc4SeXiaQS2qOn4rHKD4UOB8h7xtoSR79gldFgMmMh2AZqJcp8J?=
 =?us-ascii?Q?WRYVcwoL539qbzhovJIPM1U8HJEo6MdCfrkLZRndU83SOjNUS+98Hc9oeH7s?=
 =?us-ascii?Q?jrEtNUwtBllM/oUXCPr9DgeWe6N6GhPJIh8HTpohrdQEBshBkMgGUjQw3MeG?=
 =?us-ascii?Q?zrx6t+e3qOa0l233JcBOExYfPZsUj5l868sChGeA9W0GDmuR9akns9q/ODJT?=
 =?us-ascii?Q?uflHO4GpCeBKFWd3Xk+xT16NKw5j4Dx9bl9B4a3quykNtD373YiKX6Hz8Zkn?=
 =?us-ascii?Q?+v2yYsFSTBL9ReFvCA2CYdt4DkdaZhGEb2j/iflboiW+U7U1N+2sH+SgVpfy?=
 =?us-ascii?Q?aOFJe7fM4aZBEFt3H2YlAqfKTHKLlFZTkhP0X24Q3fTcAqXlHfy1IDqdB0bg?=
 =?us-ascii?Q?L0U7uOhQ4H8G36CFIvOD2QGY7TatzNAe/0ctv/ZLZZc5ipXoBeYgT0Nb2oRV?=
 =?us-ascii?Q?+NS0mQzNjQN6ovRAvDDAt8jpXyeWmXthsSTSEmAUiUQXgNmu92r9t4KlvfQq?=
 =?us-ascii?Q?7zjKbkeXGYLZYYQhOuQ+3r+fnURuEkH97u7ywvo0ZZEEPfnARkn18GIR5LlQ?=
 =?us-ascii?Q?T7GdY3dXh3WiSH3FpeJMEKTPeU3SAk2IHux1ZK2ni0NOVfTPDCR7k89IMqLp?=
 =?us-ascii?Q?hg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc279002-8b23-4a42-5e65-08da97082adc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:50:56.2682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NVTTOrqbh9Aemg3AG84gpjlHpUub1jr8ZcODxT7ZYl1o1eJ2Qd6gOLpMt0oLx+dpF+Q/yxdJKrfjH1jcMa9DTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains:
- the proper protected variant of rcu_dereference() of admin and oper
  schedules for accesses from the slow path
- a removal of an extra function pointer indirection for
  qdisc->dequeue() and qdisc->peek()
- a removal of WARN_ON_ONCE() checks that can never trigger
- the addition of netlink extack messages to some qdisc->init() failures

These were split from an earlier patch set, hence the v2.

Vladimir Oltean (7):
  net/sched: taprio: taprio_offload_config_changed() is protected by
    rtnl_mutex
  net/sched: taprio: taprio_dump and taprio_change are protected by
    rtnl_mutex
  net/sched: taprio: use rtnl_dereference for oper and admin sched in
    taprio_destroy()
  net/sched: taprio: remove redundant FULL_OFFLOAD_IS_ENABLED check in
    taprio_enqueue
  net/sched: taprio: stop going through private ops for dequeue and peek
  net/sched: taprio: add extack messages in taprio_init
  net/sched: taprio: replace safety precautions with comments

 net/sched/sch_taprio.c | 112 +++++++++++++----------------------------
 1 file changed, 34 insertions(+), 78 deletions(-)

-- 
2.34.1

