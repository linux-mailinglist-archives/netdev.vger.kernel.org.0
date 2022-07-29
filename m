Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302485856B6
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 00:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiG2WAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 18:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238807AbiG2WAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 18:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C77DB86E;
        Fri, 29 Jul 2022 15:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5C29B829BD;
        Fri, 29 Jul 2022 22:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E15FC43140;
        Fri, 29 Jul 2022 22:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659132013;
        bh=iyYGqy13R342VAPQwy7FCLlKnAZ2eElGJIoLmaJapO4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jwmBCXLQddeAFnFB6X1aN/ZM1TKGDV++bzKLqIt6/L7YPkG4WDpOcU2vJlIrPPJWN
         Vilqsdqq1Wh46rhgMRUNV9c55DA3raY9eD03PtTF7tsoUZ5uNJKpY6eN3jn638BblA
         UGbXWRWI1G92YdNQGWYTSsJJfp3DxQs/goaP9um7aHjVWirmnyrtcybFkBAPf2T8ok
         oJNxWY3z1KyQou1R7uGsZyLuq5mVCQxAROCTpl04PMUaSfxWqBH3ECaJsxNVtYKvuK
         SHy3XroCEwS5LgByl3D3tMANB0SJ7/uaw6ieS//JmlIGfqmuEJEzuz4cxO/ZM/LmfE
         huYk259+BO8PA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 438D7C43143;
        Fri, 29 Jul 2022 22:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Fix NULL pointer dereference when registering
 bpf trampoline
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165913201327.10268.511163628131580428.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 22:00:13 +0000
References: <20220728114048.3540461-1-xukuohai@huaweicloud.com>
In-Reply-To: <20220728114048.3540461-1-xukuohai@huaweicloud.com>
To:     Xu Kuohai <xukuohai@huaweicloud.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bgoncalv@redhat.com,
        song@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 28 Jul 2022 07:40:48 -0400 you wrote:
> From: Xu Kuohai <xukuohai@huawei.com>
> 
> A panic was reported on arm64:
> 
> [   44.517109] audit: type=1334 audit(1658859870.268:59): prog-id=19 op=LOAD
> [   44.622031] Unable to handle kernel NULL pointer dereference at
> virtual address 0000000000000010
> [   44.624321] Mem abort info:
> [   44.625049]   ESR = 0x0000000096000004
> [   44.625935]   EC = 0x25: DABT (current EL), IL = 32 bits
> [   44.627182]   SET = 0, FnV = 0
> [   44.627930]   EA = 0, S1PTW = 0
> [   44.628684]   FSC = 0x04: level 0 translation fault
> [   44.629788] Data abort info:
> [   44.630474]   ISV = 0, ISS = 0x00000004
> [   44.631362]   CM = 0, WnR = 0
> [   44.632041] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000100ab5000
> [   44.633494] [0000000000000010] pgd=0000000000000000, p4d=0000000000000000
> [   44.635202] Internal error: Oops: 96000004 [#1] SMP
> [   44.636452] Modules linked in: xfs crct10dif_ce ghash_ce virtio_blk
> virtio_console virtio_mmio qemu_fw_cfg
> [   44.638713] CPU: 2 PID: 1 Comm: systemd Not tainted 5.19.0-rc7 #1
> [   44.640164] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
> [   44.641799] pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   44.643404] pc : ftrace_set_filter_ip+0x24/0xa0
> [   44.644659] lr : bpf_trampoline_update.constprop.0+0x428/0x4a0
> [   44.646118] sp : ffff80000803b9f0
> [   44.646950] x29: ffff80000803b9f0 x28: ffff0b5d80364400 x27: ffff80000803bb48
> [   44.648721] x26: ffff8000085ad000 x25: ffff0b5d809d2400 x24: 0000000000000000
> [   44.650493] x23: 00000000ffffffed x22: ffff0b5dd7ea0900 x21: 0000000000000000
> [   44.652279] x20: 0000000000000000 x19: 0000000000000000 x18: ffffffffffffffff
> [   44.654067] x17: 0000000000000000 x16: 0000000000000000 x15: ffffffffffffffff
> [   44.655787] x14: ffff0b5d809d2498 x13: ffff0b5d809d2432 x12: 0000000005f5e100
> [   44.657535] x11: abcc77118461cefd x10: 000000000000005f x9 : ffffa7219cb5b190
> [   44.659254] x8 : ffffa7219c8e0000 x7 : 0000000000000000 x6 : ffffa7219db075e0
> [   44.661066] x5 : ffffa7219d3130e0 x4 : ffffa7219cab9da0 x3 : 0000000000000000
> [   44.662837] x2 : 0000000000000000 x1 : ffffa7219cb7a5c0 x0 : 0000000000000000
> [   44.664675] Call trace:
> [   44.665274]  ftrace_set_filter_ip+0x24/0xa0
> [   44.666327]  bpf_trampoline_update.constprop.0+0x428/0x4a0
> [   44.667696]  __bpf_trampoline_link_prog+0xcc/0x1c0
> [   44.668834]  bpf_trampoline_link_prog+0x40/0x64
> [   44.669919]  bpf_tracing_prog_attach+0x120/0x490
> [   44.671011]  link_create+0xe0/0x2b0
> [   44.671869]  __sys_bpf+0x484/0xd30
> [   44.672706]  __arm64_sys_bpf+0x30/0x40
> [   44.673678]  invoke_syscall+0x78/0x100
> [   44.674623]  el0_svc_common.constprop.0+0x4c/0xf4
> [   44.675783]  do_el0_svc+0x38/0x4c
> [   44.676624]  el0_svc+0x34/0x100
> [   44.677429]  el0t_64_sync_handler+0x11c/0x150
> [   44.678532]  el0t_64_sync+0x190/0x194
> [   44.679439] Code: 2a0203f4 f90013f5 2a0303f5 f9001fe1 (f9400800)
> [   44.680959] ---[ end trace 0000000000000000 ]---
> [   44.682111] Kernel panic - not syncing: Oops: Fatal exception
> [   44.683488] SMP: stopping secondary CPUs
> [   44.684551] Kernel Offset: 0x2721948e0000 from 0xffff800008000000
> [   44.686095] PHYS_OFFSET: 0xfffff4a380000000
> [   44.687144] CPU features: 0x010,00022811,19001080
> [   44.688308] Memory Limit: none
> [   44.689082] ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: Fix NULL pointer dereference when registering bpf trampoline
    https://git.kernel.org/bpf/bpf-next/c/3b317abc7159

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


