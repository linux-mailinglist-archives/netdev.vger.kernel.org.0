Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE09587F29
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 17:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbiHBPlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 11:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbiHBPku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 11:40:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C571F2A958
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 08:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9D11B8199C
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 15:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F88C433C1;
        Tue,  2 Aug 2022 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659454823;
        bh=RNqwM80d30vuRjuOcqHv46Z5Hlwtwa2R3PG2ASC3MRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pTp7ywjUPS5qLxigfx32cz7V5NNQWgpNm6qXRjcBAzXwYEKuTmz0l6+N+TjNkUcgB
         jVcz2XZzFRCy0+qhAEV5wHpCp806x5hf0D4AAPTlgvxfPYrPIf8qoaIOVKjDdawIhO
         cT1rrlKtzbDsj09i0pE+B2CgkSx0LESMVBRYXo9UjIs2U6tXLr2mIVllkCc7hLDX26
         qKuwSua9DtjEjG1GwvG7ZruEsS7i3EQ5S3kryC3iPY02UHF42xmHBHg/rEd2W5AchB
         dG6fSUAWWDMkEEDv4HqQ5CzFXyTQ7EmYz2BXheWs+msHkl1vWwTzMtQ4Gytdo5GDjm
         ULRdWyKBkTYsg==
Date:   Tue, 2 Aug 2022 08:40:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Message-ID: <20220802084021.2ee26764@kernel.org>
In-Reply-To: <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
References: <20220722235033.2594446-1-kuba@kernel.org>
        <20220722235033.2594446-8-kuba@kernel.org>
        <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Aug 2022 17:54:01 +0300 Tariq Toukan wrote:
> Hi Jakub,
> 
> The device offload flow got broken, we started getting the call trace 
> below in our regressions tests.
> 
> Bisecting points to this one as the offending commit.
> 
> I taking a look, but I'm less familiar with this change.
> Probably you have a direction?

Sorry about that, I'll take a look. Would you be able to run it thru
decode_stacktrace before I get to the office and start digging?

>   [  407.560799] rcu: INFO: rcu_sched self-detected stall on CPU
>   [  407.561734] rcu: 	1-....: (5248 ticks this GP) 
> idle=51b/1/0x4000000000000000 softirq=41347/41347 fqs=2625
>   [  407.563101] 	(t=5250 jiffies g=65669 q=4492 ncpus=10)
>   [  407.563859] NMI backtrace for cpu 1
>   [  407.564430] CPU: 1 PID: 45266 Comm: iperf Not tainted 
> 5.19.0-rc7_for-upstream_min-debug_5f35d2896553 #1
>   [  407.565766] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
> BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>   [  407.567319] Call Trace:
>   [  407.567772]  <IRQ>
>   [  407.568168]  dump_stack_lvl+0x34/0x44
>   [  407.568763]  nmi_cpu_backtrace.cold+0x30/0x70
>   [  407.569462]  ? lapic_can_unplug_cpu+0x70/0x70
>   [  407.570146]  nmi_trigger_cpumask_backtrace+0xef/0x100
>   [  407.570897]  trigger_single_cpu_backtrace+0x24/0x27
>   [  407.571635]  rcu_dump_cpu_stacks+0xa0/0xd9
>   [  407.572278]  rcu_sched_clock_irq.cold+0x111/0x2d3
>   [  407.573004]  update_process_times+0x5b/0x90
>   [  407.584227]  tick_sched_timer+0x88/0xa0
>   [  407.584855]  ? tick_sched_do_timer+0xf0/0xf0
>   [  407.585515]  __hrtimer_run_queues+0x139/0x290
>   [  407.586199]  hrtimer_interrupt+0x10e/0x240
>   [  407.586844]  __sysvec_apic_timer_interrupt+0x56/0xd0
>   [  407.587575]  sysvec_apic_timer_interrupt+0x6d/0x90
>   [  407.588293]  </IRQ>
>   [  407.588699]  <TASK>
>   [  407.589118]  asm_sysvec_apic_timer_interrupt+0x16/0x20
>   [  407.589886] RIP: 0010:tls_device_decrypted+0x7a/0x2e0
>   [  407.590641] Code: 83 e7 01 45 0f b6 e7 41 83 f7 01 48 85 d2 45 0f 
> b6 ff 74 1b 0f b6 82 83 00 00 00 48 8b 12 c0 e8 06 41 21 c4 83 f0 01 41 
> 21 c7 <48> 85 d2 75 e5 8b 05 d3 71 ca 00 85 c0 0f 8f 4b 01 00 00 48 8b 85
>   [  407.593152] RSP: 0018:ffff8881a113bb60 EFLAGS: 00000202
>   [  407.593927] RAX: 0000000000000003 RBX: ffff88810e2d6000 RCX: 
> 0000000000000000
>   [  407.594913] RDX: ffff8881792b80d8 RSI: ffff88814ef46800 RDI: 
> ffff8881792b8000
>   [  407.595904] RBP: ffff88814ef46800 R08: 7fffffffffffffff R09: 
> 0000000000000001
>   [  407.596907] R10: ffff888105cd2200 R11: 0000000000022dd1 R12: 
> 0000000000000000
>   [  407.597901] R13: ffff888108f45000 R14: ffff8881792b8000 R15: 
> 0000000000000001
>   [  407.598897]  ? tls_rx_rec_wait+0x225/0x250
>   [  407.599539]  tls_rx_one_record+0xe4/0x2d0
>   [  407.600169]  tls_sw_recvmsg+0x380/0x910
>   [  407.600773]  ? 0xffffffff81000000
>   [  407.601336]  inet6_recvmsg+0x47/0xc0
>   [  407.601932]  ____sys_recvmsg+0x109/0x120
>   [  407.602554]  ? _copy_from_user+0x26/0x60
>   [  407.603171]  ? iovec_from_user+0x4a/0x150
>   [  407.603803]  ___sys_recvmsg+0xa4/0xe0
>   [  407.604394]  ? mlx5e_ktls_add_rx+0x349/0x430 [mlx5_core]
>   [  407.605262]  ? mlx5e_ktls_add_rx+0x3af/0x430 [mlx5_core]
>   [  407.606082]  ? tls_device_attach+0x60/0xe0
>   [  407.606721]  ? tls_set_device_offload_rx+0x11b/0x220
>   [  407.607464]  __sys_recvmsg+0x4e/0x90
>   [  407.608050]  do_syscall_64+0x3d/0x90
>   [  407.608631]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>   [  407.609400] RIP: 0033:0x7f7a41f856dd
