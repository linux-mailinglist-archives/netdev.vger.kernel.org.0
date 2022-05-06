Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A1151D10C
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 08:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389354AbiEFGMM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 May 2022 02:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354088AbiEFGML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 02:12:11 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.109.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E5276542C
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 23:08:28 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2044.outbound.protection.outlook.com [104.47.22.44]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-31-eACQi15YNqu9j5xQodTIjw-1; Fri, 06 May 2022 08:08:25 +0200
X-MC-Unique: eACQi15YNqu9j5xQodTIjw-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GVAP278MB0391.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:3b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.18; Fri, 6 May 2022 06:08:24 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 06:08:24 +0000
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
Subject: [PATCH net v2] net: phy: Fix race condition on link status change
Date:   Fri,  6 May 2022 08:08:15 +0200
Message-ID: <20220506060815.327382-1-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
X-ClientProxiedBy: MR1P264CA0133.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:51::18) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 530d80b9-1555-4507-72a1-08da2f26d42b
X-MS-TrafficTypeDiagnostic: GVAP278MB0391:EE_
X-Microsoft-Antispam-PRVS: <GVAP278MB0391BF8E46A03AA11CED12E4E2C59@GVAP278MB0391.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Xivc2U+lzsPBZZcjGVrtKDLwxANPUuo4AOnYZSwRbX297HUpNpDIKB3x1jUQlpSqrv8u+S2onx1Q5jPBtrQUfc8qDNWlUgLrR4XXd52m9QIKmgw9BQKN13H3W4kDSE7nuWh8nBgCw7ssXNvN5AJmOIhrwuEeuyKlpYc7DYcqXiQE7CwoXmjuiOzMn6MHHWa4d1QbE3Oz34Gy9fgnSwkjfqU5EfMRyNYBQyOQIPNuA+lhnP9VW7EMt7hBLRzsTAD5CI5BJUD+EN5ZHQc3qstflVvE9VBv+Wv7l4roOKdVrukq0gKeGQNEn+l+WICl1xw1Pm+IAgg2J+wcfUBJs9lKGW97gHHqS8Ir+updSQdtcG1ld+yrvxzXS/rwEn5VKOF64Xxcbv9Q24/clcBYulKYIXiVoV1PhOBtL5EL9hu3ByranwYl0yE72FZDH+GcvZC0MXpN9457GYmvHryQrlDlzF77DYmN90wqZT/wJpTzM/1fHyz4yUjZfXrt5QCF686sDQ+iRVPojBsK/UDRlhY2E9LJRGCJ1h1Zj214pInm2xZN3g+l8LutdpG/M6uUUsynDlzi9SEoIoYMioirJrzrGAppwCcUru1YUQ6DGJE4+J+BffB0CR21UY/o47u43z7KEeIaau+XqSbiuWcuy5eIZav5+iK7YcIItqhvXV8UPA3hcL3aPCEwYWyew+j/G8QvdzgybGV1UDrZacGwZ9nm7lDJrQKvVm9h0Vm50J0majUL+Ktiz/uV7b1cyisJTe2piOmKP60sb5Cpybe+NA2VbNHbGmG4oOAM/MKaDuwZXhA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(346002)(366004)(396003)(376002)(39850400004)(36756003)(6486002)(186003)(2906002)(83380400001)(44832011)(8936002)(4326008)(66946007)(66476007)(6506007)(8676002)(66556008)(6512007)(26005)(86362001)(966005)(7416002)(2616005)(5660300002)(38100700002)(38350700002)(1076003)(316002)(52116002)(45080400002)(508600001)(110136005)(54906003)(6666004);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B4JgSeN+y+1kLkXqqEhH3gsEF+FRJHKiR5xwRJgBebshK0RTVBO66NfObrAW?=
 =?us-ascii?Q?VxFq+2gNhRDdkNMUzBotFETdWHVsSyaw7kz+f4lKWEgI5Cb+UuO3mZECtHoY?=
 =?us-ascii?Q?V5NayYLjRViWM0o3LjRRCtoWn46veNczPDKoJpMXsYCfa+mZt7Rkj2/HjCkt?=
 =?us-ascii?Q?qmdsFM0SjPyxn645cmWlbztH/Zu2QWa2apzgh2Mu3bKThSPONxzJ+sDJFZlV?=
 =?us-ascii?Q?mrohyKygDBfeWClK2XG6w9x3kxMa/kByEZ6f4sCRomT5X9YRtQ9d0Gnhkn2f?=
 =?us-ascii?Q?skIcbqxHWpbj0ezrJ5Gol394qIWFG1CnPMxc1KMU4AIqFo7RqTtPB7YCcyFf?=
 =?us-ascii?Q?a2aKl4DiHndHucZVw1U+c1rNGZH11KR+ZKfsSTs8fV+hcjO2I7qw+knc/VQq?=
 =?us-ascii?Q?p8QlrKXYEQDw0z9oPnbBnrSHkwtb0N7sgPaMdAdhIwJT0p7MD6oTMZc7Mwnp?=
 =?us-ascii?Q?Ax1rs5YQSo9iodYyqumO7yvLKeG2NGmJZcCY8ih5TywXxloZXH1u/Enjn+B6?=
 =?us-ascii?Q?OW1kEBVmojJzZNIf+UyMWAnLW3d2amTCPSqbbkuY+wYb0LdjPuySxFKR3sWu?=
 =?us-ascii?Q?t6KYVDbPm1PlQhqnXgjTs164jLUp0Z9ZiEO9uxkmkGSnqMIRb1SZvLW7/XaD?=
 =?us-ascii?Q?NhmvxjpbmbBxcOPh9wqDCyw++I6o3sSg90YjXcEtEGQctHDX98qybzMgbUGB?=
 =?us-ascii?Q?7SJPKEPzDTBcIrItjqH1NGTF4GHlV6pAHHrKw+8PdEGkWdguZtMvw6asWvFD?=
 =?us-ascii?Q?3hAe8YL8n/aGLvJ2riSc65H/IHkdSFf6TIkIr8YxSq0cWhXJ+uIwVSdVbVIT?=
 =?us-ascii?Q?BYn5ij/mNSHGOuCPrf2bSBFjhYfEfP/JD/IgxtYk1gV7ZTxUhQkz+QQeh4NF?=
 =?us-ascii?Q?hVKaEFWSpYk+X0Tpe4aXDjD21r9KtiXXvO8KkAybdvj7I8MQr5gRl7iQdjTs?=
 =?us-ascii?Q?gk8pvHF/YY50qs5oTZOfeYPVPMMSOao+osoMquhEMqx2dncW9WY6z9w2iYjm?=
 =?us-ascii?Q?E8f4esP+FL0Sd+cDX8Orj6OF7zym0LrbnHCKMm5Ncmxeh4diOz5hXFkSvWvm?=
 =?us-ascii?Q?L0cjUsezw+vTnSx7uVAO5rAWiQedTrY1kdygjMWb2FfeWj/HqZYFNalDkb4M?=
 =?us-ascii?Q?zuffjYXmjvdg+SxuCXaX2PapbSYgxnZYOyGj3g8+o41nI0dfwXrrjHCzudxH?=
 =?us-ascii?Q?Xfn1XYC3fOxV2G9lBHIHrTPJ4lBjcODCqy97M1C/m0BMiQq7QVpcgDdHrKZ/?=
 =?us-ascii?Q?+CJ6a3j7U9q+hR6OzNmsHDfXZfc0eWjHXlnUyDzKgcpkymAvJeL+vp8pCrfm?=
 =?us-ascii?Q?0ex2eZey7c5ex+ISkrUiNun5jA+MKevAy4oMx3qyl/QLFFK9Y6zV1BOn9GAi?=
 =?us-ascii?Q?3fn+LVel6RJMkCBsLtapFQRLqJ8/b0dFTe27smpA6c8yxoVN1ExOHfcV5Ws0?=
 =?us-ascii?Q?12bCqE+8OYjg8TWG2uYRWyKPk7rIWvMTeT5AK1Uj8UmiCnTmGsH9Epeb1+kY?=
 =?us-ascii?Q?3yFdUSmuqWmVjmLt4uGp0yPLo7h8YpjBcbNqKo2LbgsBYZINHk7ny6l5wGt7?=
 =?us-ascii?Q?1bb5IB02oZ8prqPltNdoXQhD4EpWE2aawQWUIT1nce0tTx8MlPdmvKXhFGlu?=
 =?us-ascii?Q?I2TcJIhsSx/Pcec9PsM7DtUIFj3tK39zle7vwYbpcCzwVP8Y5LLZZ7t+2aW8?=
 =?us-ascii?Q?ajSgKT4AdNIP15ourfYXeCEpa4B1IT5p/mGFy8T0ZK+wzMd8ulVj5ys4BPKk?=
 =?us-ascii?Q?X2/8FNLIYde0OrLt2CVyWpH8CqxZrN4=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 530d80b9-1555-4507-72a1-08da2f26d42b
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 06:08:24.2319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dfPcImkV4S7rsvNkWjzul0UZSSL+64MukO3Xdqwr3mwgjJ2WJ42thTwcJ9DNtkHbIalF9aNJWUukBo2CHftQlkt6rlGYkj6irdIapRVPTgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0391
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
Fixes: c974bdbc3e77 ("net: phy: Use threaded IRQ, to allow IRQ from sleeping devices")
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

