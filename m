Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9265B8F78
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 22:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiINUGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 16:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiINUGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 16:06:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D2246224;
        Wed, 14 Sep 2022 13:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C94AB81208;
        Wed, 14 Sep 2022 20:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845FEC433D6;
        Wed, 14 Sep 2022 20:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663186004;
        bh=IW0lL6nPwj10l7SHvx4A+45oQBhv/wWsJR8P6cTBFKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E7j0qYFVH2t1zHjxAlzGTLvgddXXvwSqKUm14jSZisvk9lQUWLRDLsYeY6vBcLyNn
         YEoCLHbcelmzXKUE57UOLe/LP5WKByGt5He6+2zfQ+sEGLIbpR9t8zbOfwD4oDpojD
         WFQ8twXDxDZbEB5poiJjZSiLW0Q1TJDCG69S4o+W4UI21R1r84A7+9P5CL+Vr2XLBe
         s9iyqoDaXQCy5KsjqraUVK4bSCG2NWSLi8qeuCciOwAHF/9ajlyIJjXKAMviW17VjR
         2mtpvV5zq4tmuJfgM6GsZ/W+YrMFBtBeyoZOzwyvfPG6xQriAd0v3gdqMuEI9/kd2N
         h/Bo2QmsAnSYg==
Received: by pali.im (Postfix)
        id A51F77B8; Wed, 14 Sep 2022 22:06:41 +0200 (CEST)
Date:   Wed, 14 Sep 2022 22:06:41 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Regression: qca8k_sw_probe crashes (Was: Re: [net-next PATCH v5
 01/14] net: dsa: qca8k: cache match data to speed up access)
Message-ID: <20220914200641.zvib2kpo2t26u6ai@pali>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727113523.19742-2-ansuelsmth@gmail.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 27 July 2022 13:35:10 Christian Marangi wrote:
> Using of_device_get_match_data is expensive. Cache match data to speed
> up access and rework user of match data to use the new cached value.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca/qca8k.c | 35 +++++++++++------------------------
>  drivers/net/dsa/qca/qca8k.h |  1 +
>  2 files changed, 12 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
> index 1cbb05b0323f..64524a721221 100644

Hello! This commit is causing kernel crash on powerpc P2020 based board
with QCA8337N-AL3C switch.

[    1.901926] Kernel attempted to read user page (38) - exploit attempt? (uid: 0)
[    1.909264] BUG: Kernel NULL pointer dereference on read at 0x00000038
[    1.915793] Faulting instruction address: 0xc079adec
[    1.920756] Oops: Kernel access of bad area, sig: 11 [#1]
[    1.926154] BE PAGE_SIZE=4K SMP NR_CPUS=2 P2020RDB-PC
[    1.931207] Modules linked in:
[    1.934260] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc2-0caacb197b677410bdac81bc34f05235+ #123
[    1.943576] NIP:  c079adec LR: c06b8920 CTR: 00000000
[    1.948626] REGS: c146f970 TRAP: 0300   Not tainted  (6.0.0-rc2-0caacb197b677410bdac81bc34f05235+)
[    1.957591] MSR:  00029000 <CE,EE,ME>  CR: 84228842  XER: 20000000
[    1.963786] DEAR: 00000038 ESR: 00000000 
[    1.963786] GPR00: c06b8920 c146fa60 c14a8000 00000000 00000000 00000000 c1c957fc 00000004 
[    1.963786] GPR08: c174f6e8 00000000 c1c95700 c18c2e40 84228848 00000000 c0004548 00000000 
[    1.963786] GPR16: 00000000 c174f600 00000000 fffff000 c0c06504 c0c05c3c efff8b9c efff8b9c 
[    1.963786] GPR24: 00000001 efff8bb0 efff8bac 00000000 00000000 c174f600 00000000 c1c95718 
[    2.001278] NIP [c079adec] of_device_get_match_data+0x10/0x38
[    2.007040] LR [c06b8920] qca8k_sw_probe+0x40/0x224
[    2.011927] Call Trace:
[    2.014368] [c146fa60] [c174f600] 0xc174f600 (unreliable)
[    2.019774] [c146fa70] [c06b8920] qca8k_sw_probe+0x40/0x224
[    2.025354] [c146faa0] [c06b2ef0] mdio_probe+0x40/0x8c
[    2.030497] [c146fac0] [c060ddb8] really_probe+0x250/0x340
[    2.035990] [c146faf0] [c060dfb0] driver_probe_device+0x44/0xfc
[    2.041916] [c146fb20] [c060e440] __device_attach_driver+0xa4/0x114
[    2.048190] [c146fb40] [c060b83c] bus_for_each_drv+0x8c/0xe8
[    2.053855] [c146fb70] [c060db04] __device_attach+0x110/0x164
[    2.059607] [c146fba0] [c060c8ec] bus_probe_device+0xb0/0xd4
[    2.065271] [c146fbc0] [c0609654] device_add+0x438/0x8c8
[    2.070595] [c146fc20] [c06b3018] mdio_device_register+0x48/0x70
[    2.076608] [c146fc40] [c06b4c98] of_mdiobus_register+0x310/0x398
[    2.082707] [c146fca0] [c06ba7d4] fsl_pq_mdio_probe+0x1f0/0x374
[    2.088636] [c146fd10] [c0610708] platform_probe+0x48/0xac
[    2.094129] [c146fd30] [c060dc40] really_probe+0xd8/0x340
[    2.099533] [c146fd60] [c060dfb0] driver_probe_device+0x44/0xfc
[    2.105459] [c146fd90] [c060e534] __driver_attach+0x84/0x154
[    2.111124] [c146fdb0] [c060b73c] bus_for_each_dev+0x88/0xe0
[    2.116789] [c146fde0] [c060cc80] bus_add_driver+0x1f0/0x22c
[    2.122453] [c146fe10] [c060eca8] driver_register+0x88/0x16c
[    2.128118] [c146fe30] [c0004150] do_one_initcall+0x80/0x284
[    2.133785] [c146fea0] [c10012d0] kernel_init_freeable+0x1f4/0x2a0
[    2.139973] [c146fee0] [c000456c] kernel_init+0x24/0x154
[    2.145289] [c146ff00] [c001426c] ret_from_kernel_thread+0x5c/0x64
[    2.151479] Instruction dump:
[    2.154444] 71290020 40820010 7d445378 38210010 4bffe068 38600000 38210010 4e800020
[    2.162211] 9421fff0 7c0802a6 7c641b78 90010014 <81230038> 80690018 4bffffad 2c030000
[    2.170156] ---[ end trace 0000000000000000 ]---
[    2.174770]
[    3.176268] Kernel panic - not syncing: Fatal exception
[    3.181497] Rebooting in 1 seconds..


> --- a/drivers/net/dsa/qca/qca8k.c
> +++ b/drivers/net/dsa/qca/qca8k.c

There is line:
	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
and after that follows chunk:

> @@ -3134,6 +3120,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  	if (!priv)
>  		return -ENOMEM;
>  
> +	priv->info = of_device_get_match_data(priv->dev);

So function of_device_get_match_data() takes as its argument NULL
pointer as 'priv' structure is at this stage zeroed, and which cause
above kernel crash. priv->dev is filled lines below:

>  	priv->bus = mdiodev->bus;
>  	priv->dev = &mdiodev->dev;
>  

I would propose following patch:

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 1d3e7782a71f..614950a5878a 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1887,13 +1887,13 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	 */
 	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	priv->dev = &mdiodev->dev;
 	priv->info = of_device_get_match_data(priv->dev);
 	priv->bus = mdiodev->bus;
-	priv->dev = &mdiodev->dev;
 
 	priv->reset_gpio = devm_gpiod_get_optional(priv->dev, "reset",
 						   GPIOD_ASIS);
 	if (IS_ERR(priv->reset_gpio))
 		return PTR_ERR(priv->reset_gpio);

which fixes above crash.
