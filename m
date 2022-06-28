Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4D355C513
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245368AbiF1GJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 02:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245378AbiF1GJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 02:09:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7E92610A;
        Mon, 27 Jun 2022 23:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1976761874;
        Tue, 28 Jun 2022 06:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F93C341C6;
        Tue, 28 Jun 2022 06:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656396576;
        bh=TnPnSztZaMrJo3SBp024+cQ77bnVWMMq6znbAKHu1xI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mvMtZYJF9WFCY8+lH/0s1P9xyrfjb3ljM5CwNj5NpBh2WoNTfgjRLyKYL6AMz/bfv
         iPkewmoS7+wqdU+uAIVMrcZEZhXrL3sjUGSXUAclO7BYeK8UzQf2LpeCMpYBtwfGT1
         pFEQ6QvZRIkZDsV21PbxFlZrnojEeTb3hp/cGD/I=
Date:   Tue, 28 Jun 2022 08:09:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V6 RESEND] mwifiex: fix sleep in atomic context bugs
 caused by dev_coredumpv
Message-ID: <YrqbHWWKjoyBwMae@kroah.com>
References: <20220628014110.9183-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628014110.9183-1-duoming@zju.edu.cn>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 09:41:09AM +0800, Duoming Zhou wrote:
> There are sleep in atomic context bugs when uploading device dump
> data in mwifiex. The root cause is that dev_coredumpv could not
> be used in atomic contexts, because it calls dev_set_name which
> include operations that may sleep. The call tree shows execution
> paths that could lead to bugs:
> 
>    (Interrupt context)
> fw_dump_timer_fn
>   mwifiex_upload_device_dump
>     dev_coredumpv(..., GFP_KERNEL)
>       dev_coredumpm()
>         kzalloc(sizeof(*devcd), gfp); //may sleep
>         dev_set_name
>           kobject_set_name_vargs
>             kvasprintf_const(GFP_KERNEL, ...); //may sleep
>             kstrdup(s, GFP_KERNEL); //may sleep
> 
> The corresponding fail log is shown below:
> 
> [  135.275938] usb 1-1: == mwifiex dump information to /sys/class/devcoredump start
> [  135.281029] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:265
> ...
> [  135.293613] Call Trace:
> [  135.293613]  <IRQ>
> [  135.293613]  dump_stack_lvl+0x57/0x7d
> [  135.293613]  __might_resched.cold+0x138/0x173
> [  135.293613]  ? dev_coredumpm+0xca/0x2e0
> [  135.293613]  kmem_cache_alloc_trace+0x189/0x1f0
> [  135.293613]  ? devcd_match_failing+0x30/0x30
> [  135.293613]  dev_coredumpm+0xca/0x2e0
> [  135.293613]  ? devcd_freev+0x10/0x10
> [  135.293613]  dev_coredumpv+0x1c/0x20
> [  135.293613]  ? devcd_match_failing+0x30/0x30
> [  135.293613]  mwifiex_upload_device_dump+0x65/0xb0
> [  135.293613]  ? mwifiex_dnld_fw+0x1b0/0x1b0
> [  135.293613]  call_timer_fn+0x122/0x3d0
> [  135.293613]  ? msleep_interruptible+0xb0/0xb0
> [  135.293613]  ? lock_downgrade+0x3c0/0x3c0
> [  135.293613]  ? __next_timer_interrupt+0x13c/0x160
> [  135.293613]  ? lockdep_hardirqs_on_prepare+0xe/0x220
> [  135.293613]  ? mwifiex_dnld_fw+0x1b0/0x1b0
> [  135.293613]  __run_timers.part.0+0x3f8/0x540
> [  135.293613]  ? call_timer_fn+0x3d0/0x3d0
> [  135.293613]  ? arch_restore_msi_irqs+0x10/0x10
> [  135.293613]  ? lapic_next_event+0x31/0x40
> [  135.293613]  run_timer_softirq+0x4f/0xb0
> [  135.293613]  __do_softirq+0x1c2/0x651
> ...
> [  135.293613] RIP: 0010:default_idle+0xb/0x10
> [  135.293613] RSP: 0018:ffff888006317e68 EFLAGS: 00000246
> [  135.293613] RAX: ffffffff82ad8d10 RBX: ffff888006301cc0 RCX: ffffffff82ac90e1
> [  135.293613] RDX: ffffed100d9ff1b4 RSI: ffffffff831ad140 RDI: ffffffff82ad8f20
> [  135.293613] RBP: 0000000000000003 R08: 0000000000000000 R09: ffff88806cff8d9b
> [  135.293613] R10: ffffed100d9ff1b3 R11: 0000000000000001 R12: ffffffff84593410
> [  135.293613] R13: 0000000000000000 R14: 0000000000000000 R15: 1ffff11000c62fd2
> ...
> [  135.389205] usb 1-1: == mwifiex dump information to /sys/class/devcoredump end
> 
> This patch uses delayed work to replace timer and moves the operations
> that may sleep into a delayed work in order to mitigate bugs, it was
> tested on Marvell 88W8801 chip whose port is usb and the firmware is
> usb8801_uapsta.bin. The following is the result after using delayed
> work to replace timer.
> 
> [  134.936453] usb 1-1: == mwifiex dump information to /sys/class/devcoredump start
> [  135.043344] usb 1-1: == mwifiex dump information to /sys/class/devcoredump end
> 
> As we can see, there is no bug now.
> 
> Cc: stable@vger.kernel.org
> Fixes: f5ecd02a8b20 ("mwifiex: device dump support for usb interface")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> ---
> Changes in v6:
>   - Use clang-format to adjust the format of code.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
