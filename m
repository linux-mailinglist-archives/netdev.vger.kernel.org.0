Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF3F58A2CC
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 23:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbiHDVlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 17:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiHDVlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 17:41:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ECE4AD5B
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 14:41:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4714617BE
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 21:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AAAC433D6;
        Thu,  4 Aug 2022 21:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659649265;
        bh=mTsRiEdIa1ObokDk0oHObWmIZroK8IwEG9VIBnGiDaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdlSgAeh4bhU9eRQ3aAwhdZt/Djz7lCC4nBBlOO7OBCg0DGYqKlh5GSYMv1q53OtK
         5PXAZl4RDGcmfhc0jGrXXs3wNjcKRJiFcWr043YMeNgRSrCApBk2a90t/74BeVrOQT
         dJbWOAmKfMcDURcrpoVaetMmLT2TeaIwDzwT9MiLXvUnlUVKYQo4E/gmfbeZswlIRW
         TT16ZQ8oVW4CrO5iUDp+ck7pDYNmVMgcjVy8bmbjRTM4Ckv+27YAxsHvWNiowLWUOf
         +/Qqt+xiJHwM+MTQ5mSdHEEcKzhiA2Pkb6VzB4CCLK1Q+Kv7wPFWu2j1KQcrEPAIux
         6gYVCeB70QeUw==
From:   James Hogan <jhogan@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] I225-V (igc driver) hangs after resume in igc_resume/igc_tsn_reset
Date:   Thu, 04 Aug 2022 22:41:01 +0100
Message-ID: <1838555.CQOukoFCf9@saruman>
In-Reply-To: <e8f33b45-380f-e73e-3879-0e1a478262e9@molgen.mpg.de>
References: <4752347.31r3eYUQgx@saruman> <3198206.44csPzL39Z@saruman> <e8f33b45-380f-e73e-3879-0e1a478262e9@molgen.mpg.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 4 August 2022 14:27:24 BST Paul Menzel wrote:
> Am 04.08.22 um 15:03 schrieb James Hogan:
> > On Thursday, 28 July 2022 18:36:31 BST James Hogan wrote:
> >> On Wednesday, 27 July 2022 15:37:09 BST Vinicius Costa Gomes wrote:
> >>> Yeah, I agree that it seems like the issue is something else. I would
> >>> suggest start with the "simple" things, enabling 'CONFIG_PROVE_LOCKING'
> >>> and looking at the first splat, it could be that what you are seeing is
> >>> caused by a deadlock somewhere else.
> >> 
> >> This is revealing I think (re-enabled PCIE_PTM and enabled
> >> PROVE_LOCKING).
> >> 
> >> In this case it happened within minutes of boot, but a few previous
> >> attempts with several suspend cycles with the same kernel didn't detect
> >> the same thing.
> > 
> > I hate to nag, but any thoughts on the lockdep recursive locking warning
> > below? It seems to indicate a recursive taking of rtnl_mutex in
> > dev_ethtool
> > and igc_resume, which would certainly seem to point the finger squarely
> > back at the igc driver.
> 
> I hope, the developers will respond quickly. If it is indeed a
> regression, and you do not want to wait for the developers, you could
> try to bisect the issue. To speed up the test cycles, I recommend to try
> to try to reproduce the issue in QEMU/KVM and passing through the
> network device.

Unfortunately its new hardware for me, so I don't know if there's a good 
working version of the driver. I've only had constant pain with it so far. 
Frequent failed resumes, hangs on shutdown.

However I just did a bit more research and found these dead threads from a 
year ago which appear to pinpoint the issue:
https://lore.kernel.org/all/20210420075406.64105-1-acelan.kao@canonical.com/
https://lore.kernel.org/all/20210809032809.1224002-1-acelan.kao@canonical.com/

They would appear to point to this commit as the one which triggered the 
breakage:
bd869245a3dc ("net: core: try to runtime-resume detached device in 
__dev_open")

Cc'ing Sasha and Aleks (they were added to the latter thread).
Also cc'ing netdev, since it seems to relate to interaction with common code?

Cheers
James


> >> NetworkManager[857]: <info>  [1659028974.1752] device (enp6s0): state
> >> change: activated -> unavailable (reason 'carrier-changed',
> >> sys-iface-state: 'managed')
> >> 
> >> ============================================
> >> WARNING: possible recursive locking detected
> >> 5.18.12-arch1-1 #2 Not tainted
> >> --------------------------------------------
> >> NetworkManager/857 is trying to acquire lock:
> >> ffffffff9f9e9048 (rtnl_mutex){+.+.}-{3:3}, at: igc_resume+0xf6/0x1d0
> >> [igc]
> >> 
> >> but task is already holding lock:
> >> ffffffff9f9e9048 (rtnl_mutex){+.+.}-{3:3}, at: dev_ethtool+0xaf/0x3080
> >> 
> >> other info that might help us debug this:
> >>   Possible unsafe locking scenario:
> >>         CPU0
> >>         ----
> >>    
> >>    lock(rtnl_mutex);
> >>    lock(rtnl_mutex);
> >>   
> >>   *** DEADLOCK ***
> >>   May be due to missing lock nesting notation
> >> 
> >> 1 lock held by NetworkManager/857:
> >>   #0: ffffffff9f9e9048 (rtnl_mutex){+.+.}-{3:3}, at:
> >>   dev_ethtool+0xaf/0x3080
> >> 
> >> stack backtrace:
> >> CPU: 0 PID: 857 Comm: NetworkManager Not tainted 5.18.12-arch1-1 #2
> >> 369425cead7bf2331cd4c5d2279465ad4a0fc21f Hardware name: Micro-Star
> >> International Co., Ltd. MS-7D25/PRO Z690-A DDR4(MS-7D25), BIOS 1.40
> >> 
> >> 05/17/2022 Call Trace:
> >>   <TASK>
> >>   dump_stack_lvl+0x5f/0x78
> >>   __lock_acquire.cold+0xd4/0x2e5
> >>   ? __lock_acquire+0x3b2/0x1fd0
> >>   lock_acquire+0xc8/0x2d0
> >>   ? igc_resume+0xf6/0x1d0 [igc beed6d83546b18fcf82fbbfaeea59871823bceeb]
> >>   ? lock_is_held_type+0xaa/0x120
> >>   __mutex_lock+0xb6/0x830
> >>   ? igc_resume+0xf6/0x1d0 [igc beed6d83546b18fcf82fbbfaeea59871823bceeb]
> >>   ? lockdep_hardirqs_on_prepare+0xdd/0x180
> >>   ? _raw_spin_unlock_irqrestore+0x34/0x50
> >>   ? igc_resume+0xf6/0x1d0 [igc beed6d83546b18fcf82fbbfaeea59871823bceeb]
> >>   ? igc_resume+0xf6/0x1d0 [igc beed6d83546b18fcf82fbbfaeea59871823bceeb]
> >>   igc_resume+0xf6/0x1d0 [igc beed6d83546b18fcf82fbbfaeea59871823bceeb]
> >>   pci_pm_runtime_resume+0xab/0xd0
> >>   ? pci_pm_freeze_noirq+0xe0/0xe0
> >>   __rpm_callback+0x41/0x160
> >>   rpm_callback+0x35/0x70
> >>   ? pci_pm_freeze_noirq+0xe0/0xe0
> >>   rpm_resume+0x5eb/0x820
> >>   __pm_runtime_resume+0x4b/0x80
> >>   dev_ethtool+0x128/0x3080
> >>   ? lock_is_held_type+0xaa/0x120
> >>   ? find_held_lock+0x2b/0x80
> >>   ? dev_load+0x57/0x140
> >>   ? lock_release+0xd4/0x2d0
> >>   dev_ioctl+0x155/0x560
> >>   sock_do_ioctl+0xd7/0x120
> >>   sock_ioctl+0x103/0x360
> >>   ? __fget_files+0xd2/0x170
> >>   __x64_sys_ioctl+0x8e/0xc0
> >>   do_syscall_64+0x5c/0x90
> >>   ? do_syscall_64+0x6b/0x90
> >>   ? lockdep_hardirqs_on_prepare+0xdd/0x180
> >>   ? do_syscall_64+0x6b/0x90
> >>   ? lockdep_hardirqs_on_prepare+0xdd/0x180
> >>   ? do_syscall_64+0x6b/0x90
> >>   ? asm_sysvec_apic_timer_interrupt+0xe/0x20
> >>   ? rcu_read_lock_sched_held+0x40/0x80
> >>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >> 
> >> RIP: 0033:0x7f2c35d077af
> >> Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89
> >> 44
> >> 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0
> >> ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00 RSP:
> >> 002b:00007ffd7319afd0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010 RAX:
> >> ffffffffffffffda RBX: 00007ffd7319b2c0 RCX: 00007f2c35d077af
> >> RDX: 00007ffd7319b0f0 RSI: 0000000000008946 RDI: 0000000000000012
> >> RBP: 00007ffd7319b270 R08: 0000000000000000 R09: 00007ffd7319b2c8
> >> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> >> R13: 00007ffd7319b0f0 R14: 00007ffd7319b0d0 R15: 00007ffd7319b0d0
> >> 
> >>   </TASK>




