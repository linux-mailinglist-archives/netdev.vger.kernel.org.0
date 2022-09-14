Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3955B8C1C
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiINPmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiINPmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:42:38 -0400
X-Greylist: delayed 1498 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Sep 2022 08:42:37 PDT
Received: from gateway34.websitewelcome.com (gateway34.websitewelcome.com [192.185.150.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF131D7
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 08:42:36 -0700 (PDT)
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id A815A471F2
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 09:53:22 -0500 (CDT)
Received: from 162-215-252-169.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id YTlSosdUISQZkYTlSoLHMp; Wed, 14 Sep 2022 09:53:22 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yc4GbKCmfz1uq0X2PP3ip3zWoSdSKRh1Q7yx/y5ppGU=; b=DfXKRlMrMK5BK1o7cjMY16YfUH
        UYERFMkgkHcsLlcYiyBB0pgBbpw7+ETkPzlTU0inw1+3DOQpzs/6csZLXgp/1i+QvqAg+C3knxy82
        FovLEaIfNuo+T0xexJhch4shpNs3h3CPMOID5Va3LMayy19x91FSXOGtW5/tmP4mMxSsmOSwvaxAx
        pnUkhFg+QniGLzq3r6rcYfJqqL38lNW8xzPcf6HFifIB4BklKkHI+ym85Q+v2X/bX9S7WOlE2XQdd
        bUqiNQ2OCK8ur6FEOLg5N0ptMcm1azVFt+2p2R4gRrQHAg33MNJo7ocu0VMhc41u8d7gqU8SzuEWt
        SOctVMJQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:39164 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <linux@roeck-us.net>)
        id 1oYTlR-002cQR-FB;
        Wed, 14 Sep 2022 14:53:21 +0000
Date:   Wed, 14 Sep 2022 07:53:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        regressions@lists.linux.dev
Subject: [REGRESSION] Re: [PATCH v2] net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`
Message-ID: <20220914145317.GA1868385@roeck-us.net>
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220901140402.64804-1-csokas.bence@prolan.hu>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1oYTlR-002cQR-FB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:39164
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 27
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 04:04:03PM +0200, Csókás Bence wrote:
> Mutexes cannot be taken in a non-preemptible context,
> causing a panic in `fec_ptp_save_state()`. Replacing
> `ptp_clk_mutex` by `tmreg_lock` fixes this.
> 
> Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock is disabled")
> Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/
> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>

For regzbot:

This patch results in the following backtrace.

[   18.401688] BUG: sleeping function called from invalid context at drivers/clk/imx/clk-pllv3.c:68
[   18.402277] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1, name: swapper/0
[   18.402531] preempt_count: 1, expected: 0
[   18.402781] 3 locks held by swapper/0/1:
[   18.402967]  #0: c423ac8c (&dev->mutex){....}-{3:3}, at: __driver_attach+0x80/0x158
[   18.404364]  #1: c40dc8e8 (&fep->tmreg_lock){....}-{2:2}, at: fec_enet_clk_enable+0x58/0x250
[   18.404752]  #2: c1a71af8 (prepare_lock){+.+.}-{3:3}, at: clk_prepare_lock+0xc/0xd4
[   18.405246] irq event stamp: 129384
[   18.405403] hardirqs last  enabled at (129383): [<c10850b0>] _raw_spin_unlock_irqrestore+0x50/0x64
[   18.405667] hardirqs last disabled at (129384): [<c1084e70>] _raw_spin_lock_irqsave+0x64/0x68
[   18.405915] softirqs last  enabled at (129218): [<c01017bc>] __do_softirq+0x2ac/0x604
[   18.406255] softirqs last disabled at (129209): [<c012eee4>] __irq_exit_rcu+0x138/0x17c
[   18.406792] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G                 N 6.0.0-rc5 #1
[   18.407131] Hardware name: Freescale i.MX7 Dual (Device Tree)
[   18.407590]  unwind_backtrace from show_stack+0x10/0x14
[   18.407890]  show_stack from dump_stack_lvl+0x68/0x90
[   18.408097]  dump_stack_lvl from __might_resched+0x17c/0x284
[   18.408328]  __might_resched from clk_pllv3_wait_lock+0x4c/0xcc
[   18.408557]  clk_pllv3_wait_lock from clk_core_prepare+0xc4/0x328
[   18.408783]  clk_core_prepare from clk_core_prepare+0x50/0x328
[   18.408986]  clk_core_prepare from clk_core_prepare+0x50/0x328
[   18.409205]  clk_core_prepare from clk_core_prepare+0x50/0x328
[   18.409416]  clk_core_prepare from clk_core_prepare+0x50/0x328
[   18.409631]  clk_core_prepare from clk_core_prepare+0x50/0x328
[   18.409847]  clk_core_prepare from clk_core_prepare+0x50/0x328
[   18.410065]  clk_core_prepare from clk_core_prepare+0x50/0x328
[   18.410284]  clk_core_prepare from clk_core_prepare+0x50/0x328
[   18.410513]  clk_core_prepare from clk_core_prepare+0x50/0x328
[   18.410729]  clk_core_prepare from clk_prepare+0x20/0x30
[   18.410936]  clk_prepare from fec_enet_clk_enable+0x68/0x250
[   18.411143]  fec_enet_clk_enable from fec_probe+0x32c/0x1430
[   18.411352]  fec_probe from platform_probe+0x58/0xbc
[   18.411558]  platform_probe from really_probe+0xc4/0x2f4
[   18.411772]  really_probe from __driver_probe_device+0x80/0xe4
[   18.411983]  __driver_probe_device from driver_probe_device+0x2c/0xc4
[   18.412203]  driver_probe_device from __driver_attach+0x8c/0x158
[   18.412418]  __driver_attach from bus_for_each_dev+0x74/0xc0
[   18.412631]  bus_for_each_dev from bus_add_driver+0x154/0x1e8
[   18.412844]  bus_add_driver from driver_register+0x88/0x11c
[   18.413055]  driver_register from do_one_initcall+0x68/0x428
[   18.413271]  do_one_initcall from kernel_init_freeable+0x18c/0x240
[   18.413502]  kernel_init_freeable from kernel_init+0x14/0x144
[   18.413721]  kernel_init from ret_from_fork+0x14/0x28
[   18.414036] Exception stack(0xd0825fb0 to 0xd0825ff8)
[   18.414523] 5fa0:                                     00000000 00000000 00000000 00000000
[   18.414792] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   18.415032] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000


