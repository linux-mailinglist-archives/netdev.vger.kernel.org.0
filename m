Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D3251988B
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345696AbiEDHud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241137AbiEDHuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:50:32 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9C213F08
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:46:55 -0700 (PDT)
Received: from [2a02:8108:963f:de38:1b3c:6996:5378:f253]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nm9il-0004C0-JH; Wed, 04 May 2022 09:46:53 +0200
Message-ID: <7ca81e6b-85fd-beff-1c2b-62c86c9352e9@leemhuis.info>
Date:   Wed, 4 May 2022 09:46:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: [regression] dpaa2: TSO offload on lx2160a causes fatal exception in
 interrupt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1651650415;582c049d;
X-HE-SMSGID: 1nm9il-0004C0-JH
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

Ioana, I noticed a regression report in bugzilla.kernel.org that afaics
nobody acted upon since it was reported about a week ago. The reporter
*suspects* it's caused by a recent change of yours. That's why I decided
to forward it to the lists and all people that seemed to be relevant
here. To quote from https://bugzilla.kernel.org/show_bug.cgi?id=215886 :

>  kernelbugs@63bit.net 2022-04-25 18:15:38 UTC
> 
> Network traffic eventually causes a fatal exception in interrupt. Disabling TSO prevents the bug. Likely related to recent changes to enable TSO?
> 
> Crash:
> [  487.231819] Unable to handle kernel paging request at virtual address fffffd9807000008
> [  487.239780] Mem abort info:
> [  487.242570]   ESR = 0x96000006
> [  487.245620]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  487.250974]   SET = 0, FnV = 0
> [  487.254025]   EA = 0, S1PTW = 0
> [  487.257170]   FSC = 0x06: level 2 translation fault
> [  487.262050] Data abort info:
> [  487.264921]   ISV = 0, ISS = 0x00000006
> [  487.268748]   CM = 0, WnR = 0
> [  487.271747] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000830fd000
> [  487.278449] [fffffd9807000008] pgd=100000277c353003, p4d=100000277c353003, pud=100000277c352003, pmd=0000000000000000
> [  487.289110] Internal error: Oops: 96000006 [#1] SMP
> [  487.293985] Modules linked in: rfkill fsl_dpaa2_ptp ltc2978 lm90 pmbus_core at24 ptp_qoriq fsl_dpaa2_eth pcs_lynx at803x phylink xgmac_mdio i2c_mux_pca954x i2c_mux sfp mdio_i2c qoriq_thermal qoriq_cpufreq layerscape_edac_mod vfat fat auth_rpcgss fuse sunrpc dpaa2_caam fsl_mc_dpio caam_jr nvme rtc_pcf2127 caamhash_desc mmc_block xhci_plat_hcd caamalg_desc regmap_spi dpaa2_console crct10dif_ce libdes ghash_ce nvme_core dwc3 caam sdhci_of_esdhc ulpi error sdhci_pltfm rtc_fsl_ftm_alarm udc_core sbsa_gwdt ahci_qoriq i2c_imx sdhci gpio_keys
> [  487.341467] CPU: 7 PID: 1772 Comm: sshd Tainted: G        W        --------  ---  5.18.0-0.rc3.20220422gitd569e86915b7f2f.31.fc37.aarch64 #1
> [  487.354061] Hardware name: SolidRun LX2160A Honeycomb (DT)
> [  487.359535] pstate: a0400005 (NzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  487.366485] pc : kfree+0xac/0x304
> [  487.369799] lr : kfree+0x204/0x304
> [  487.373191] sp : ffff80000c4eb120
> [  487.376493] x29: ffff80000c4eb120 x28: ffff662240c46400 x27: 0000000000000001
> [  487.383621] x26: 0000000000000001 x25: ffff662246da0cc0 x24: ffff66224af78000
> [  487.390748] x23: ffffad184f4ce008 x22: ffffad1850185000 x21: ffffad1838d13cec
> [  487.397874] x20: ffff6601c0000000 x19: fffffd9807000000 x18: 0000000000000000
> [  487.405000] x17: ffffb910cdc49000 x16: ffffad184d7d9080 x15: 0000000000004000
> [  487.412126] x14: 0000000000000008 x13: 000000000000ffff x12: 0000000000000000
> [  487.419252] x11: 0000000000000004 x10: 0000000000000001 x9 : ffffad184d7d927c
> [  487.426379] x8 : 0000000000000000 x7 : 0000000ffffffd1d x6 : ffff662240a94900
> [  487.433505] x5 : 0000000000000003 x4 : 0000000000000009 x3 : ffffad184f4ce008
> [  487.440632] x2 : ffff662243eec000 x1 : 0000000100000100 x0 : fffffc0000000000
> [  487.447758] Call trace:
> [  487.450194]  kfree+0xac/0x304
> [  487.453151]  dpaa2_eth_free_tx_fd.isra.0+0x33c/0x3e0 [fsl_dpaa2_eth]
> [  487.459507]  dpaa2_eth_tx_conf+0x100/0x2e0 [fsl_dpaa2_eth]
> [  487.464989]  dpaa2_eth_poll+0xdc/0x380 [fsl_dpaa2_eth]
> [  487.470122]  __napi_poll.constprop.0+0x40/0x1a0
> [  487.474645]  net_rx_action+0x310/0x3d4
> [  487.478384]  __do_softirq+0x23c/0x6b4
> [  487.482036]  __irq_exit_rcu+0x104/0x214
> [  487.485862]  irq_exit_rcu+0x1c/0x50
> [  487.489339]  el1_interrupt+0x38/0x70
> [  487.492907]  el1h_64_irq_handler+0x18/0x24
> [  487.496993]  el1h_64_irq+0x68/0x6c
> [  487.500384]  __ip_finish_output+0x138/0x220
> [  487.504558]  ip_finish_output+0x40/0xf4
> [  487.508384]  ip_output+0xfc/0x2fc
> [  487.511689]  __ip_queue_xmit+0x1c0/0x5e0
> [  487.515601]  ip_queue_xmit+0x20/0x30
> [  487.519166]  __tcp_transmit_skb+0x3c0/0x7cc
> [  487.523339]  tcp_write_xmit+0x310/0x8ac
> [  487.527164]  __tcp_push_pending_frames+0x48/0x110
> [  487.531857]  tcp_push+0xbc/0x19c
> [  487.535075]  tcp_sendmsg_locked+0x2ac/0xad4
> [  487.539247]  tcp_sendmsg+0x44/0x6c
> [  487.542639]  inet_sendmsg+0x50/0x7c
> [  487.546117]  sock_sendmsg+0x60/0x70
> [  487.549595]  sock_write_iter+0x98/0xe0
> [  487.553333]  new_sync_write+0x124/0x130
> [  487.557159]  vfs_write+0x1c8/0x210
> [  487.560550]  ksys_write+0xd8/0xec
> [  487.563854]  __arm64_sys_write+0x28/0x34
> [  487.567766]  invoke_syscall+0x78/0x100
> [  487.571506]  el0_svc_common.constprop.0+0x68/0x124
> [  487.576287]  do_el0_svc+0x30/0x90
> [  487.579592]  el0_svc+0x60/0x1a4
> [  487.582723]  el0t_64_sync_handler+0x10c/0x140
> [  487.587070]  el0t_64_sync+0x190/0x194
> [  487.590723] Code: 8b130293 b25657e0 d34cfe73 8b131813 (f9400660) 
> [  487.596807] ---[ end trace 0000000000000000 ]---
> [  487.601413] Kernel panic - not syncing: Oops: Fatal exception in interrupt
> [  487.608276] SMP: stopping secondary CPUs
> [  487.612206] Kernel Offset: 0x2d1845400000 from 0xffff800008000000
> [  487.618287] PHYS_OFFSET: 0xffff99fe40000000
> [  487.622457] CPU features: 0x100,00004b09,00001086
> [  487.627150] Memory Limit: none
> [  487.630196] Rebooting in 1 seconds..
> 
> Mitigation:
> ethtool -K ethX tso off
> 
> [reply] [−] Comment 1 kernelbugs@63bit.net 2022-05-02 01:37:06 UTC
> 
> I believe this is related to commit 3dc709e0cd47c602a8d1a6747f1a91e9737eeed3
> 

That commit is "dpaa2-eth: add support for software TSO".

Could somebody take a look into this? Or was this discussed somewhere
else already? Or even fixed?

Anyway, to get this tracked:

#regzbot introduced: 3dc709e0cd47c602a8d1a6747f1a91e9737eeed3
#regzbot from: Unkown <kernelbugs@63bit.net>
#regzbot title: net: dpaa2: TSO offload on lx2160a causes fatal
exception in interrupt
#regzbot link: https://bugzilla.kernel.org/show_bug.cgi?id=215886

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.

-- 
Additional information about regzbot:

If you want to know more about regzbot, check out its web-interface, the
getting start guide, and the references documentation:

https://linux-regtracking.leemhuis.info/regzbot/
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md

The last two documents will explain how you can interact with regzbot
yourself if your want to.

Hint for reporters: when reporting a regression it's in your interest to
CC the regression list and tell regzbot about the issue, as that ensures
the regression makes it onto the radar of the Linux kernel's regression
tracker -- that's in your interest, as it ensures your report won't fall
through the cracks unnoticed.

Hint for developers: you normally don't need to care about regzbot once
it's involved. Fix the issue as you normally would, just remember to
include 'Link:' tag in the patch descriptions pointing to all reports
about the issue. This has been expected from developers even before
regzbot showed up for reasons explained in
'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst'.

