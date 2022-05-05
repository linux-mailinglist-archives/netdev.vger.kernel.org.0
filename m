Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E089851CAAD
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385896AbiEEUge convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 May 2022 16:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiEEUga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:36:30 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.109.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DB805FF17
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:32:49 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2104.outbound.protection.outlook.com [104.47.22.104]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-5-hE0yPdLyOlGPTVc5PkDvxw-1; Thu, 05 May 2022 22:32:46 +0200
X-MC-Unique: hE0yPdLyOlGPTVc5PkDvxw-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZRAP278MB0029.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:13::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Thu, 5 May 2022 20:32:45 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 20:32:45 +0000
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH net v1] net: phy: Fix race condition on link status change
Date:   Thu,  5 May 2022 22:32:29 +0200
Message-ID: <20220505203229.322509-1-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
X-ClientProxiedBy: MR2P264CA0114.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::30) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0462de1c-b34a-469b-9d15-08da2ed66969
X-MS-TrafficTypeDiagnostic: ZRAP278MB0029:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB0029569446183AA7D94DDCAFE2C29@ZRAP278MB0029.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: oW63PyF16PAU1Zkw4ZAkzIUjFAnBbOoQBeIZ9Bleum6qc3ZxXiOaD8NGwvydWlExrm0PtGK0P5wipZuBQLt3e68Jze0f/mLZkda8ITJqx66O97eLk5QgAYGZtiJgdZ5pRtgJmKhcVOzOfb25h0on4TxqKsv/8JZmCvr6TR6Ihh8Dos9xqA5/X7XyCU+KE/wRwXJJUZBFNyXS2smY98mRglsCKdD0i/Xp7lvxeoOYMxDzW3vZIrT49UsMcvVyVU1u9Cie7OGwHjHMNtsWGuo8ETQGQ044G+4ZxyBBeebswMakvpH1nrR+WQi5LSr0d1G37GD82y3qs9QYHCFlS4221VNbobVUCDLAoROOH0jDarffnsC4EmizCt8K7/Sj+RSuh49JQ8IlFZQU6jU5fUSs4KvJjutJY6i/3NQX+Xq1WnWwALu+iLNNt+RApT01dcCqF8uS0a0u6YrSjIaukaGgnlY3NvGxbfu2BStiM1A1mjo9WxpKsiHSx2dJrBsvk55VpoxijZBx96clH5gsH0kRVHrmpd3jysyvk1cecF6N9+Ua8fw/msd6Hp8Z5UoRRd1fuCBxvXfrS8NTkN7gwIWYH+OQ82nnKdQbvVwX8fQItJKr3FGs8oo24TMumx+gBE4mVfsHhFuvnL+f9Oa5y+1m+lJHq3EUXRkayzhz+grNGRyJVBOO57cii4jbt1yHO55LbCJ6bKJ2Rc6Ork9WASAWOB/H7337RFhNHYQPHDQ/YoupG+FtireR/tVVaijY4aldAQsF4ppeXLyNf36yy/YyvUhsfpFtgq1nl9ZgMyDTRFg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(376002)(39850400004)(366004)(346002)(396003)(136003)(38350700002)(38100700002)(36756003)(86362001)(6666004)(52116002)(6506007)(2906002)(966005)(316002)(5660300002)(1076003)(4326008)(6486002)(66476007)(2616005)(8676002)(110136005)(66946007)(66556008)(7416002)(508600001)(6512007)(26005)(44832011)(83380400001)(8936002)(186003)(45080400002)(54906003);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mcJZOEv6te4YXsz8BPvyAgPS0rJxFKwFpuewK8talSjN/ka8izgLY/qV/ItJ?=
 =?us-ascii?Q?0qEIgiJzLu3d8znjS3JWyKLaoGjRX7olNq+4VX4gPA3INpork4DRvAf7fS8T?=
 =?us-ascii?Q?dyy+2L5YTn6Foa5+9gc9FT9cM47MA9kcWFMmCUNtCQQpVcIC/f+AAX5sxDeT?=
 =?us-ascii?Q?fbOohwkJOTXloa6PfLOmWHWIySlyhbgBz1KeOWDB6cjYh4ce1zdInFM0yxns?=
 =?us-ascii?Q?ns/Nmj1GzXn1ErJRWFL2WqgCEGYzCYTvPyi38QouKcNndhoUEXQnM2gt3dpf?=
 =?us-ascii?Q?vkEB5YHVfSEKdT9LxQ0Uha4e1Aj7ck5ok97f9RGnoM6EYG9jrnolw7SxrAzu?=
 =?us-ascii?Q?UyLlOL5OOJLu3oAa8QaTeOqgRsGa1x/Gt7Dj/slCNqE5eNTcm0INIqsVS9Cc?=
 =?us-ascii?Q?bIU5qvthSos6JAjdBIttYwe+q6v6omuDQo0EpxuCZ9mydqP0KmXmna7mtRqS?=
 =?us-ascii?Q?nxNywPTF4wwP2z+3l28bb/nViOqj8NIU1omGC1y+AuLD2j8FRFU49aiKz6Al?=
 =?us-ascii?Q?Z2HKMgbQUGban3/IkMen5NLEsQyJJBHhNHkBaYkOPJ3Uvxb1coXVgr9E1Q/2?=
 =?us-ascii?Q?i5+5+qhmJx6PeqJrFoVCY8qlQM4ira3kkVnB9y2XLq1SUR5egaR6pLnOPVxr?=
 =?us-ascii?Q?rK9pETuhN+AJDoeTxsBEoAqjBx6lR+wZ9B9ujN06lIZ9YaOO7MZIy+CQwd8d?=
 =?us-ascii?Q?la4a1RgAYJ38KH854r1qrJ1i9LkgV1/PK7DfIx5gldiCIk5CH1SJFtI0gex4?=
 =?us-ascii?Q?dvWBaKERtHRy/htw388Y4bJZG+IO6owaHnkpYkSd2Lx/5LWy5P3VjvL814Hk?=
 =?us-ascii?Q?x//FRSjb2Jq1/yIKkmTdB2rV+jw2evzBLEdwxZIEqOVU8zox7zx6Bvj/sSFh?=
 =?us-ascii?Q?xiUEzNdgMpAZO1t+BGqe1mUfnAoIgeVOE9lNI806s/H00ulLYEFg2YfLJMYh?=
 =?us-ascii?Q?sje9JQF4k564Vso+FdJyH7293w5yTK25vCgfnfgmJFDWKE7ifRyRK2PC/I/P?=
 =?us-ascii?Q?2sF5XoO0jTQ3rGwK69lY5NhagUbWg/bU+UM+lDTfg6aEXd71vVCdgijxnblk?=
 =?us-ascii?Q?S5r6cFZbUCA+wsGGHwfRZTNsBiRqAoj9nOgsXwzHijk0BPHhzGep5Cv6Urvn?=
 =?us-ascii?Q?bG3pldApfPJAh/Q3pZGtstBFfQU3oNSyrVTeKgplQUpP+Mhn5X5CfgKBB7vB?=
 =?us-ascii?Q?OEO++qWcdhq+EtdhaJwPB+jv9U3iaEOQs78nGgiuHdqJ84tP4HMZiZZG2N2Z?=
 =?us-ascii?Q?hRlS5r+E0jSjx12r9dfsKbmoUhTZTmx3pjemXslKOtrW/gDWPqm1CE5t9/Gn?=
 =?us-ascii?Q?HYzI4WGVqy0W0Ccxnr2aBvLUDdv2s9uVjiQcR9ZC1j7lJ+dY6oZJM+5/tnZa?=
 =?us-ascii?Q?u/VJsa1KGZzD3MGc8DCrePv6kCwWwPHvN7QouPux0cwTtTndctIbfkBODP/K?=
 =?us-ascii?Q?SCohMWHuQ4W3LsmHJbH/KfAHzs55tYLO5ZyD4Vp0txynne6HNArbC/BPuPqQ?=
 =?us-ascii?Q?jsFyFkVr0pG08NoeOa3ML8A/MZbVlYJc0AZZfPaztoBrvslyfloN70wWM4s6?=
 =?us-ascii?Q?VDFmqSmXWoSlgZnE6g8wMqfs6X33S2DZAfwVLqEJaBDWsW6kp1AUYmIXRWzc?=
 =?us-ascii?Q?TVxaMU+YhTvPJsuZ/FGp8pzH5w6A8TUzcmBljYw2sS2G5ekDEmTOcm3gSna1?=
 =?us-ascii?Q?MGprpUUKsPBL0PT5g76yDpPEL7kic+ctKYWKxo3GyFdbkEXJjE6E9XvXxUtx?=
 =?us-ascii?Q?dFd0ck1z1ST+GP4TBrYbmfrBELpt7HE=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0462de1c-b34a-469b-9d15-08da2ed66969
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 20:32:45.3691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uWmCzJYBZzGJbEAI6MdzLmPgEyqlOH1lokdVk3OqxWzuv3ziEVtaHgH8ko+xX0quOM3qzzJA3Tg9kcxHgu6G2ZUjVhcxnkr6B5kFbFnDjRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0029
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the following error caused by a race condition between
phydev->adjust_link() and a MDIO transaction in the phy interrupt
handler. The issue was reproduced with the ethernet FEC driver and a
micrel KSZ9031 phy.

[  146.195696] fec 2188000.ethernet eth0: MDIO read timeout
[  146.201779] ------------[ cut here ]------------
[  146.206671] WARNING: CPU: 0 PID: 571 at drivers/net/phy/phy.c:942 phy_error+0x24/0x6c
[  146.214744] Modules linked in: bnep imx_vdoa imx_sdma evbug
[  146.220640] CPU: 0 PID: 571 Comm: irq/128-2188000 Not tainted 5.18.0-rc3-00080-gd569e86915b7 #9
[  146.229563] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[  146.236257]  unwind_backtrace from show_stack+0x10/0x14
[  146.241640]  show_stack from dump_stack_lvl+0x58/0x70
[  146.246841]  dump_stack_lvl from __warn+0xb4/0x24c
[  146.251772]  __warn from warn_slowpath_fmt+0x5c/0xd4
[  146.256873]  warn_slowpath_fmt from phy_error+0x24/0x6c
[  146.262249]  phy_error from kszphy_handle_interrupt+0x40/0x48
[  146.268159]  kszphy_handle_interrupt from irq_thread_fn+0x1c/0x78
[  146.274417]  irq_thread_fn from irq_thread+0xf0/0x1dc
[  146.279605]  irq_thread from kthread+0xe4/0x104
[  146.284267]  kthread from ret_from_fork+0x14/0x28
[  146.289164] Exception stack(0xe6fa1fb0 to 0xe6fa1ff8)
[  146.294448] 1fa0:                                     00000000 00000000 00000000 00000000
[  146.302842] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  146.311281] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  146.318262] irq event stamp: 12325
[  146.321780] hardirqs last  enabled at (12333): [<c01984c4>] __up_console_sem+0x50/0x60
[  146.330013] hardirqs last disabled at (12342): [<c01984b0>] __up_console_sem+0x3c/0x60
[  146.338259] softirqs last  enabled at (12324): [<c01017f0>] __do_softirq+0x2c0/0x624
[  146.346311] softirqs last disabled at (12319): [<c01300ac>] __irq_exit_rcu+0x138/0x178
[  146.354447] ---[ end trace 0000000000000000 ]---

With the FEC driver phydev->adjust_link() calls fec_enet_adjust_link()
calls fec_stop()/fec_restart() and both these function reset and
temporary disable the FEC disrupting any MII transaction that
could be happening at the same time.

fec_enet_adjust_link() and phy_read() can be running at the same time
when we have one additional interrupt before the phy_state_machine() is
able to terminate.

Thread 1 (phylib WQ)       | Thread 2 (phy interrupt)
                           |
                           | phy_interrupt()            <-- PHY IRQ
	                   |  handle_interrupt()
	                   |   phy_read()
	                   |   phy_trigger_machine()
	                   |    --> schedule phylib WQ
                           |
	                   |
phy_state_machine()        |
 phy_check_link_status()   |
  phy_link_change()        |
   phydev->adjust_link()   |
    fec_enet_adjust_link() |
     --> FEC reset         | phy_interrupt()            <-- PHY IRQ
	                   |  phy_read()
	 	           |

Fix this by acquiring the phydev lock in phy_interrupt().

Link: https://lore.kernel.org/all/20220422152612.GA510015@francesco-nb.int.toradex.com/
cc: <stable@vger.kernel.org>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
 drivers/net/phy/phy.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index beb2b66da132..f122026c4682 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -970,8 +970,13 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 {
 	struct phy_device *phydev = phy_dat;
 	struct phy_driver *drv = phydev->drv;
+	irqreturn_t ret;
 
-	return drv->handle_interrupt(phydev);
+	mutex_lock(&phydev->lock);
+	ret = drv->handle_interrupt(phydev);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
 }
 
 /**
-- 
2.25.1

