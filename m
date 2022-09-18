Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0D45BBF6C
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 20:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiIRS7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 14:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiIRS7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 14:59:23 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3F013E1C
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 11:59:21 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oZzVg-0005NW-6f; Sun, 18 Sep 2022 20:59:20 +0200
Message-ID: <f026b273-472a-8af9-c9be-c08be0f60d53@leemhuis.info>
Date:   Sun, 18 Sep 2022 20:59:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US, de-DE
To:     regressions@lists.linux.dev
Cc:     netdev@vger.kernel.org
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
 <20220914145317.GA1868385@roeck-us.net>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [REGRESSION] Re: [PATCH v2] net: fec: Use a spinlock to guard
 `fep->ptp_clk_on` #forregzbot
In-Reply-To: <20220914145317.GA1868385@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1663527562;a7724bf2;
X-HE-SMSGID: 1oZzVg-0005NW-6f
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

On 14.09.22 15:53, Guenter Roeck wrote:
> On Thu, Sep 01, 2022 at 04:04:03PM +0200, Csókás Bence wrote:
>> Mutexes cannot be taken in a non-preemptible context,
>> causing a panic in `fec_ptp_save_state()`. Replacing
>> `ptp_clk_mutex` by `tmreg_lock` fixes this.
>>
>> Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock is disabled")
>> Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
>> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
>> Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/
>> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
> 
> For regzbot:

Thanks for the report. To be sure below issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
tracking bot:

#regzbot ^introduced b353b241f1eb9b626
#regzbot title net: fec: backtrace: BUG: sleeping function called from
invalid context at drivers/clk/imx/clk-pllv3.c
#regzbot ignore-activity
#regzbot monitor:
https://lore.kernel.org/all/20220912073106.2544207-1-bence98@sch.bme.hu/
#regzbot monitor:
https://lore.kernel.org/all/20220912070143.98153-1-francesco.dolcini@toradex.com/

> This patch results in the following backtrace.
> 
> [   18.401688] BUG: sleeping function called from invalid context at drivers/clk/imx/clk-pllv3.c:68
> [   18.402277] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1, name: swapper/0
> [   18.402531] preempt_count: 1, expected: 0
> [   18.402781] 3 locks held by swapper/0/1:
> [   18.402967]  #0: c423ac8c (&dev->mutex){....}-{3:3}, at: __driver_attach+0x80/0x158
> [   18.404364]  #1: c40dc8e8 (&fep->tmreg_lock){....}-{2:2}, at: fec_enet_clk_enable+0x58/0x250
> [   18.404752]  #2: c1a71af8 (prepare_lock){+.+.}-{3:3}, at: clk_prepare_lock+0xc/0xd4
> [   18.405246] irq event stamp: 129384
> [   18.405403] hardirqs last  enabled at (129383): [<c10850b0>] _raw_spin_unlock_irqrestore+0x50/0x64
> [   18.405667] hardirqs last disabled at (129384): [<c1084e70>] _raw_spin_lock_irqsave+0x64/0x68
> [   18.405915] softirqs last  enabled at (129218): [<c01017bc>] __do_softirq+0x2ac/0x604
> [   18.406255] softirqs last disabled at (129209): [<c012eee4>] __irq_exit_rcu+0x138/0x17c
> [   18.406792] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G                 N 6.0.0-rc5 #1
> [   18.407131] Hardware name: Freescale i.MX7 Dual (Device Tree)
> [   18.407590]  unwind_backtrace from show_stack+0x10/0x14
> [   18.407890]  show_stack from dump_stack_lvl+0x68/0x90
> [   18.408097]  dump_stack_lvl from __might_resched+0x17c/0x284
> [   18.408328]  __might_resched from clk_pllv3_wait_lock+0x4c/0xcc
> [   18.408557]  clk_pllv3_wait_lock from clk_core_prepare+0xc4/0x328
> [   18.408783]  clk_core_prepare from clk_core_prepare+0x50/0x328
> [   18.408986]  clk_core_prepare from clk_core_prepare+0x50/0x328
> [   18.409205]  clk_core_prepare from clk_core_prepare+0x50/0x328
> [   18.409416]  clk_core_prepare from clk_core_prepare+0x50/0x328
> [   18.409631]  clk_core_prepare from clk_core_prepare+0x50/0x328
> [   18.409847]  clk_core_prepare from clk_core_prepare+0x50/0x328
> [   18.410065]  clk_core_prepare from clk_core_prepare+0x50/0x328
> [   18.410284]  clk_core_prepare from clk_core_prepare+0x50/0x328
> [   18.410513]  clk_core_prepare from clk_core_prepare+0x50/0x328
> [   18.410729]  clk_core_prepare from clk_prepare+0x20/0x30
> [   18.410936]  clk_prepare from fec_enet_clk_enable+0x68/0x250
> [   18.411143]  fec_enet_clk_enable from fec_probe+0x32c/0x1430
> [   18.411352]  fec_probe from platform_probe+0x58/0xbc
> [   18.411558]  platform_probe from really_probe+0xc4/0x2f4
> [   18.411772]  really_probe from __driver_probe_device+0x80/0xe4
> [   18.411983]  __driver_probe_device from driver_probe_device+0x2c/0xc4
> [   18.412203]  driver_probe_device from __driver_attach+0x8c/0x158
> [   18.412418]  __driver_attach from bus_for_each_dev+0x74/0xc0
> [   18.412631]  bus_for_each_dev from bus_add_driver+0x154/0x1e8
> [   18.412844]  bus_add_driver from driver_register+0x88/0x11c
> [   18.413055]  driver_register from do_one_initcall+0x68/0x428
> [   18.413271]  do_one_initcall from kernel_init_freeable+0x18c/0x240
> [   18.413502]  kernel_init_freeable from kernel_init+0x14/0x144
> [   18.413721]  kernel_init from ret_from_fork+0x14/0x28
> [   18.414036] Exception stack(0xd0825fb0 to 0xd0825ff8)
> [   18.414523] 5fa0:                                     00000000 00000000 00000000 00000000
> [   18.414792] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [   18.415032] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> 
> 
> 
> 
