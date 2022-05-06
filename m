Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A6951D535
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 12:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358698AbiEFKOV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 May 2022 06:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245575AbiEFKOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 06:14:19 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.111.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BF2A15727
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 03:10:36 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2046.outbound.protection.outlook.com [104.47.22.46]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-14-IKsUfiojOpiF-QoH9BUrEw-1; Fri, 06 May 2022 12:10:33 +0200
X-MC-Unique: IKsUfiojOpiF-QoH9BUrEw-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GVAP278MB0054.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:24::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.18; Fri, 6 May 2022 10:10:32 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 10:10:32 +0000
Date:   Fri, 6 May 2022 12:10:31 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: phy: Fix race condition on link status change
Message-ID: <20220506101031.GA417678@francesco-nb.int.toradex.com>
References: <20220506060815.327382-1-francesco.dolcini@toradex.com>
In-Reply-To: <20220506060815.327382-1-francesco.dolcini@toradex.com>
X-ClientProxiedBy: MR2P264CA0090.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::30) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 721fd91e-5f3a-4599-e265-08da2f48a767
X-MS-TrafficTypeDiagnostic: GVAP278MB0054:EE_
X-Microsoft-Antispam-PRVS: <GVAP278MB0054DDB9120DAEBA4870E3F3E2C59@GVAP278MB0054.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: YP7VFgGKyt2m77JSe1kujUu+hIUrC7SBNYApNU7k2plEpR1OAqWMGtUXJgYMA1sHFJA5IK+/q6KrkLDPIygkvnvbOLjC8Z2TdAfu334fjSpudN83x+oqpAkiYdpjQl5c59nHRKaxO5KIPjfYx2WiTYnSAn2jXA4zIvkwmbXSJUeW9Q+Al9I3cgib3pJwlN+8U01FGHmps9Rtexv8ojn7bTKSlMc9U3pMXHBKVdhm2Wkm4qzuGjkkQebKlvJzRnpKzAmM/mN1e/1aZcwJnXdxdksHr6g5XmT0X4EJwaAmBlFGpsE83NLgOpi9HJyX4ckSfuf/rMgA63jV2yaOWW5t9RJ5CyueK1LYa7pUCzKqC4ycOecREAjwFjOpTYOCzSGV1gEsiKIYxBxUi4vBlVsC+nfRrwwZzCVFdAGsboc3eOpFDYr2jvaA5mA0gJ9BRNK8N0R/hhXnaiX6aTG7R+0uB4qybH0n59irn6N4c41s1sjo/UIjOm1A5soHMTBje53kIoLMiEcRv0KxSIye1oGOX6Q4AqJbJcRXT7CvJWcHKyGbCQ0c+XO9PwGz3lAmPg1fU5qft6DkxbPga8InZUNZUeIlS1/7ptct2j7c+zO5TYW1l9eCNclUz6sRlYDWythOFzjlC1ao6BhwPyskJLKVUD8Fm6xd8k0eqICi/nBttgPPxzYPJandCHeBL5PLd2h4NYPU59V29MfUqnVdJI1OkKPV59gJ8iXObPr6dkTROpcj5/Dma3Jin29bayONmyBTbhn6XSESQ0m6b9xrC8Kk7niAmc3pnXoMJ9kvel0cqRU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(366004)(396003)(39850400004)(376002)(346002)(8936002)(33656002)(508600001)(5660300002)(38100700002)(7416002)(38350700002)(83380400001)(45080400002)(966005)(6486002)(186003)(86362001)(66556008)(6506007)(6512007)(26005)(1076003)(2906002)(44832011)(110136005)(4326008)(52116002)(54906003)(316002)(8676002)(66476007)(66946007);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LRCV0VGPaQ5MtI5S2ECKgqpNnbK6fnRQr9vvo39FbI2eqpjyQUFZ91V1tB6q?=
 =?us-ascii?Q?BaaNdk+UNrRZSK0RDUGB+OvNH+3XYkHKoBQ8ebCxcSWPq23gptGlUho0bIav?=
 =?us-ascii?Q?M7jDUV1ZhO4VGHyPHxLGVUphTz03eonUrdHmPa130Wfc3lrvV3sQF5Dpsfjq?=
 =?us-ascii?Q?yE3XlP4nbBiJudkNs/hQBlWqwa4bx2ec4a+9C4idUxW8YlTdDKMZ78oomYjt?=
 =?us-ascii?Q?Ev6BoYOwQv4M12J1k9an7/R/VdDWBRBfIJocK+RTFfFVX05FWiiVt+NKvnHt?=
 =?us-ascii?Q?75QSNZpwNqysvYRYDxUJM+ZEN5JsHnlCXLzgrJG0F2xsGhPCRZJamg3XxObz?=
 =?us-ascii?Q?kgVA2+J9TdDur9G4STot9pkpFRPjvAvrnacruoB+vQYMzFgjJzpmDGeF1el0?=
 =?us-ascii?Q?K+7kQyJujF3N1+wsGd/ipFqOX7N3gFL12MFOqTadhZMZHietnlfSJ5eZyfyy?=
 =?us-ascii?Q?+gVgtOpKljIbsQU7+60rPOxA3sC5jmkQeJtFCd7DZJMSvzBgV+0ZNAvg+FDD?=
 =?us-ascii?Q?NzYGHS+py+R6nSme4kOeiipro6vclQBuECuiqvOonGI01WYTKGJjZSUDZB9M?=
 =?us-ascii?Q?8AvFVzYTufV1NexGICpHckhZZbJEqe2dBnDotDOwbGv/BjvoW+CO8/QFVg5+?=
 =?us-ascii?Q?BKVehTOADTB1EGov3YTcGYNe42vB/212FjiF9Eb3Dy7Tg/ft0CcHG3bdM6jk?=
 =?us-ascii?Q?VdzNev9Nqndq53uZELRQ8eQpqf7Sl5bsadfarGP/8iyNfazFPJXyXyyS9rbL?=
 =?us-ascii?Q?jlmewMQnxw4+ONR06Qq5Rd7AFtohY1wljadf4xjnZOD2CVzrrnWBEtmEe2hK?=
 =?us-ascii?Q?bAfy77n16hEvAeQZCviirUo6qdY7zGsjv7O3ub57G/+nCqr3a+vs1TTjpfUL?=
 =?us-ascii?Q?kweFYRZkrv9fBGr9z0JeI25aH5uTMvz9vCOjgqfpSMxhbBteCMsKOxvwACW2?=
 =?us-ascii?Q?lnpHneNy9k2Uxj6WpMzJq0Huf10ApsihumoM1tQVCnHTLHJKJYCOmfKSkTWE?=
 =?us-ascii?Q?khWli/6Sh4s7GRscs3BQD9e2sFA0MbUzqBlXZoFXk17JEUxYlNlTBFW63OOy?=
 =?us-ascii?Q?Dyuc16X0a1Oi7rs/yZhyQ1TYPzEBcaXyp0DH7ozbPAr3cTkcEVYUzyUoAxqm?=
 =?us-ascii?Q?qAEEyaCJp1ZLZP6CILTmBYtcxQpmK4TbKxOhddPrIadBE6G6x9Z5QOCebEty?=
 =?us-ascii?Q?tQLyLkNySh9lDgx79GiNtcyHg4r9cxHIou/xtccLx/VNutX+cAs+P67sPlls?=
 =?us-ascii?Q?h9lfjvuxaKxJq78035ESWfNWHaHK38ROTMFFqBexAqqQtqb4sPp3OGX8+O/4?=
 =?us-ascii?Q?Iyd4sHkS6TldlnyMXD1rG0oSEvDtjgN65ycKmbyLATiZvkMWh23Wqcqy05m4?=
 =?us-ascii?Q?pG6619MBNXzHOCTMP1SveAL75P6FkrPc3FA68RNyYQm1N5F8mI65edClUcgu?=
 =?us-ascii?Q?fH6i2Bz5ygQneamvRvYQALYkIS3JtnbxFTa0Ot92R6cKgIPX9t7mZZIN1qDS?=
 =?us-ascii?Q?m/NIlCytB70IYu0lV7JUUePl8InIZPiOjyX+35TG1sPB9wVMlNvKbnX4gH83?=
 =?us-ascii?Q?jIElImos1DsoVVw3kYRIbAXYD5Sb30IzFSAtZXu6QJu6fTiISszgqbxh8tst?=
 =?us-ascii?Q?z+XTZy3Wf2c1Q0KDnLFsZiBR/+Q7ypMH+YSgOO4NZNvh10F4KMuTGps8nm58?=
 =?us-ascii?Q?RyJMsOm9/zQcsi2p6Y/7o6abVS7az7ieABIx7Tl3iRO6LvbqEE26zo4dc4sO?=
 =?us-ascii?Q?Y1m2O05L6kQwDg0760jfZ1KDT6GEszg=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 721fd91e-5f3a-4599-e265-08da2f48a767
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 10:10:32.0350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SuzmcdhH6+/IOoLzwoQAO/ANh0LRTmD97A/LQG8CVHFmqldX+7NxPCDkIXCun31c+4sxWE/gV+z3bbPZnH1huAJUWwMHK+655mp42GObXyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0054
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I have one question about the process of patch/fixes backporting
to old stable kernel.

Assuming the following patch will be deemed correct and applied it will
have to be eventually backported.

This patch will apply cleanly on v5.15+, but some work is needed to
backport to v5.10 or older.

Should I send a patch for the older kernels once the fix is merged?
Reading Documentation/process/stable-kernel-rules.rst it was not clear
to me what to do in this "mixed" situations.

Thanks a lot,
Francesco

On Fri, May 06, 2022 at 08:08:15AM +0200, Francesco Dolcini wrote:
> This fixes the following error caused by a race condition between
> phydev->adjust_link() and a MDIO transaction in the phy interrupt
> handler. The issue was reproduced with the ethernet FEC driver and a
> micrel KSZ9031 phy.
> 
> [  146.195696] fec 2188000.ethernet eth0: MDIO read timeout
> [  146.201779] ------------[ cut here ]------------
> [  146.206671] WARNING: CPU: 0 PID: 571 at drivers/net/phy/phy.c:942 phy_error+0x24/0x6c
> [  146.214744] Modules linked in: bnep imx_vdoa imx_sdma evbug
> [  146.220640] CPU: 0 PID: 571 Comm: irq/128-2188000 Not tainted 5.18.0-rc3-00080-gd569e86915b7 #9
> [  146.229563] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [  146.236257]  unwind_backtrace from show_stack+0x10/0x14
> [  146.241640]  show_stack from dump_stack_lvl+0x58/0x70
> [  146.246841]  dump_stack_lvl from __warn+0xb4/0x24c
> [  146.251772]  __warn from warn_slowpath_fmt+0x5c/0xd4
> [  146.256873]  warn_slowpath_fmt from phy_error+0x24/0x6c
> [  146.262249]  phy_error from kszphy_handle_interrupt+0x40/0x48
> [  146.268159]  kszphy_handle_interrupt from irq_thread_fn+0x1c/0x78
> [  146.274417]  irq_thread_fn from irq_thread+0xf0/0x1dc
> [  146.279605]  irq_thread from kthread+0xe4/0x104
> [  146.284267]  kthread from ret_from_fork+0x14/0x28
> [  146.289164] Exception stack(0xe6fa1fb0 to 0xe6fa1ff8)
> [  146.294448] 1fa0:                                     00000000 00000000 00000000 00000000
> [  146.302842] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [  146.311281] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [  146.318262] irq event stamp: 12325
> [  146.321780] hardirqs last  enabled at (12333): [<c01984c4>] __up_console_sem+0x50/0x60
> [  146.330013] hardirqs last disabled at (12342): [<c01984b0>] __up_console_sem+0x3c/0x60
> [  146.338259] softirqs last  enabled at (12324): [<c01017f0>] __do_softirq+0x2c0/0x624
> [  146.346311] softirqs last disabled at (12319): [<c01300ac>] __irq_exit_rcu+0x138/0x178
> [  146.354447] ---[ end trace 0000000000000000 ]---
> 
> With the FEC driver phydev->adjust_link() calls fec_enet_adjust_link()
> calls fec_stop()/fec_restart() and both these function reset and
> temporary disable the FEC disrupting any MII transaction that
> could be happening at the same time.
> 
> fec_enet_adjust_link() and phy_read() can be running at the same time
> when we have one additional interrupt before the phy_state_machine() is
> able to terminate.
> 
> Thread 1 (phylib WQ)       | Thread 2 (phy interrupt)
>                            |
>                            | phy_interrupt()            <-- PHY IRQ
>                            |  handle_interrupt()
>                            |   phy_read()
>                            |   phy_trigger_machine()
>                            |    --> schedule phylib WQ
>                            |
>                            |
> phy_state_machine()        |
>  phy_check_link_status()   |
>   phy_link_change()        |
>    phydev->adjust_link()   |
>     fec_enet_adjust_link() |
>      --> FEC reset         | phy_interrupt()            <-- PHY IRQ
>                            |  phy_read()
>                            |
> 
> Fix this by acquiring the phydev lock in phy_interrupt().
> 
> Link: https://lore.kernel.org/all/20220422152612.GA510015@francesco-nb.int.toradex.com/
> Fixes: c974bdbc3e77 ("net: phy: Use threaded IRQ, to allow IRQ from sleeping devices")
> cc: <stable@vger.kernel.org>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
>  drivers/net/phy/phy.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index beb2b66da132..f122026c4682 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -970,8 +970,13 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
>  {
>  	struct phy_device *phydev = phy_dat;
>  	struct phy_driver *drv = phydev->drv;
> +	irqreturn_t ret;
>  
> -	return drv->handle_interrupt(phydev);
> +	mutex_lock(&phydev->lock);
> +	ret = drv->handle_interrupt(phydev);
> +	mutex_unlock(&phydev->lock);
> +
> +	return ret;
>  }
>  
>  /**
> -- 
> 2.25.1
> 

