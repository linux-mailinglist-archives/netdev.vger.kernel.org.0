Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5546E6129CA
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 11:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiJ3KAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 06:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJ3KAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 06:00:53 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A011ABC84;
        Sun, 30 Oct 2022 03:00:51 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id v27so13749582eda.1;
        Sun, 30 Oct 2022 03:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PD19qtRId0wgZqZC6n5l/nsUISjoing8qSDhC2MYNqw=;
        b=D7HNuN4f1wLMv/sFwbmean7omz81GmftTJwj9TTIlGim1G5d569wGtwsHjY2HOuLtK
         DlExIruzXFLmeFyRlnJUePRJSnUPdjCXNDft5jkP5OFVuzI6bIUaTRC8kPNA8bDq2DZv
         wEJpV+2re9fAED82UcxXS0xilqWvxpaGBP6UkOb6QFgI880uEF2qebTGwJmcMy/jZnGf
         Oa1H5PjM/Gd6j5Rvxwp3GB2wdyYfcGlWv72IkPImI6rXNBU1oC/Pe7r//G+b+056HF13
         CWCbPdIcw17e7+K5rl8/btVd3e4ByOhUESapJp8Wd+79IAUGrof2gwYmvYiPxGA2x1Lj
         KnuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PD19qtRId0wgZqZC6n5l/nsUISjoing8qSDhC2MYNqw=;
        b=PznLZP4odKuw4RG8roQBTZG4LLAqrEipVQQlS2Z92t/CSdn+65g1FDr7oHxeF+T1j9
         38VhGCAWI8+n6yezhxFQuYULXbZxeWKbr7gMPcq3dvJpUWTILhBDJE6EOhr4roq77Bj0
         bptnK7KTCtvvcnulFeU02DT8a6Ls/SoXQr7VR52DC9zEwQYEfb+MqJkyqJak73mjpQEX
         dBPsVp1Yyz2ShhWIFRfwc8gmnbKNOALStKanAjoh8b380pqKp1h93qdZSXd8l+9iCgyu
         BZIJK5WuiHPJlKwIbkUOJTQzoA4vxAeHACjnz+N5ZWKpYsQhvr+VAe2O6V21P+tDorEk
         P0UA==
X-Gm-Message-State: ACrzQf2KgOrKMdw/fHfe01S9aYaYqmwNpxyuWvq6lUcpCOZVFjGkNXsD
        XEkbkcF0oqT05pMOvMTnJztd7zfxS4BTAywyyOw=
X-Google-Smtp-Source: AMsMyM5PpPa5JdHAKyUfDfORxVc2MTyXtbhr/mgz1RgVAbN2kKWy0R/912lzmozrlEVscNON9BEIP8YnTpWLKCb084I=
X-Received: by 2002:aa7:c58a:0:b0:461:fc07:a821 with SMTP id
 g10-20020aa7c58a000000b00461fc07a821mr8311448edq.19.1667124049739; Sun, 30
 Oct 2022 03:00:49 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Sun, 30 Oct 2022 18:00:13 +0800
Message-ID: <CAO4mrfd9SRMmB1VWcYh9L61ktiqamJ-QjwOCP+SeFx=08C2MBg@mail.gmail.com>
Subject: possible deadlock in l2cap_sock_teardown_cb
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered:

HEAD commit: 64570fbc14f8 Linux 5.15-rc5
git tree: upstream
compiler: gcc 8.0.1
console output:
https://drive.google.com/file/d/1Fb6AXVkfZDq0exhIBVf9oUp-dNgzjrHX/view?usp=share_link
kernel config: https://drive.google.com/file/d/1uDOeEYgJDcLiSOrx9W8v2bqZ6uOA_55t/view?usp=share_link

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

========================================================
WARNING: possible irq lock inversion dependency detected
5.15.0-rc5 #1 Not tainted
--------------------------------------------------------
kworker/1:7/6964 just changed the state of lock:
ffff8880105f8920 (device_state_lock){+.+.}-{2:2}, at:
l2cap_sock_teardown_cb+0x37/0x2e0
but this lock was taken by another, SOFTIRQ-safe lock in the past:
 (hcd_root_hub_lock){..-.}-{2:2}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(device_state_lock);
                               local_irq_disable();
                               lock(hcd_root_hub_lock);
                               lock(device_state_lock);
  <Interrupt>
    lock(hcd_root_hub_lock);

 *** DEADLOCK ***

4 locks held by kworker/1:7/6964:
 #0: ffff888009856738 ((wq_completion)events){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #1: ffffc90003b07e68
((work_completion)(&(&chan->chan_timer)->work)){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #2: ffff8880117c3ad8 (&conn->chan_lock){+.+.}-{3:3}, at:
l2cap_chan_timeout+0x45/0x160
 #3: ffff8880105ff520 (&chan->lock/1){+.+.}-{3:3}, at:
l2cap_chan_timeout+0x53/0x160

the shortest dependencies between 2nd lock and 1st lock:
 -> (hcd_root_hub_lock){..-.}-{2:2} {
    IN-SOFTIRQ-W at:
                      lock_acquire+0xd7/0x330
                      _raw_spin_lock_irqsave+0x33/0x50
                      usb_hcd_submit_urb+0x73b/0xf90
                      usb_submit_urb+0x4dc/0xb80
                      hub_resubmit_irq_urb+0x4c/0xc0
                      hub_irq+0x1ef/0x220
                      __usb_hcd_giveback_urb+0x114/0x240
                      usb_giveback_urb_bh+0xd2/0x140
                      tasklet_action_common.isra.15+0xb3/0xf0
                      __do_softirq+0xe2/0x56b
                      run_ksoftirqd+0x2d/0x60
                      smpboot_thread_fn+0x2a5/0x3d0
                      kthread+0x1a6/0x1e0
                      ret_from_fork+0x1f/0x30
    INITIAL USE at:
                     lock_acquire+0xd7/0x330
                     _raw_spin_lock_irq+0x32/0x50
                     usb_hcd_submit_urb+0x1a3/0xf90
                     usb_submit_urb+0x4dc/0xb80
                     usb_start_wait_urb+0x65/0x1e0
                     usb_control_msg+0xec/0x190
                     usb_get_descriptor+0x98/0x140
                     usb_get_device_descriptor+0x66/0x120
                     register_root_hub+0x67/0x297
                     usb_add_hcd.cold.37+0x588/0x805
                     dummy_hcd_probe+0xea/0x1d1
                     platform_probe+0x80/0x100
                     really_probe+0x12a/0x4d0
                     __driver_probe_device+0x195/0x220
                     driver_probe_device+0x2a/0x120
                     __device_attach_driver+0x102/0x1a0
                     bus_for_each_drv+0xb8/0x100
                     __device_attach+0x149/0x220
                     bus_probe_device+0xdb/0xf0
                     device_add+0x64f/0xd40
                     platform_device_add+0x1f0/0x390
                     init+0x454/0x856
                     do_one_initcall+0xa9/0x550
                     kernel_init_freeable+0x3ae/0x42b
                     kernel_init+0x17/0x1b0
                     ret_from_fork+0x1f/0x30
  }
  ... key      at: [<ffffffff866fc278>] hcd_root_hub_lock+0x18/0x40
  ... acquired at:
   _raw_spin_lock_irqsave+0x33/0x50
   usb_set_device_state+0x1d/0x220
   hcd_bus_resume+0x221/0x390
   usb_generic_driver_resume+0x66/0x70
   usb_resume_both+0x13a/0x280
   __rpm_callback+0x64/0x1f0
   rpm_callback+0xa8/0xc0
   rpm_resume+0x910/0xbf0
   __pm_runtime_resume+0x8e/0xf0
   usb_autoresume_device+0x1e/0x60
   usb_remote_wakeup+0x67/0xb0
   process_one_work+0x3fa/0x9f0
   worker_thread+0x42/0x5c0
   kthread+0x1a6/0x1e0
   ret_from_fork+0x1f/0x30

-> (device_state_lock){+.+.}-{2:2} {
   HARDIRQ-ON-W at:
                    lock_acquire+0xd7/0x330
                    lock_sock_nested+0x2d/0xa0
                    l2cap_sock_teardown_cb+0x37/0x2e0
                    l2cap_chan_del+0x5b/0x4a0
                    l2cap_chan_close+0x1df/0x3f0
                    l2cap_chan_timeout+0xcf/0x160
                    process_one_work+0x3fa/0x9f0
                    worker_thread+0x42/0x5c0
                    kthread+0x1a6/0x1e0
                    ret_from_fork+0x1f/0x30
   SOFTIRQ-ON-W at:
                    lock_acquire+0xd7/0x330
                    lock_sock_nested+0x2d/0xa0
                    l2cap_sock_teardown_cb+0x37/0x2e0
                    l2cap_chan_del+0x5b/0x4a0
                    l2cap_chan_close+0x1df/0x3f0
                    l2cap_chan_timeout+0xcf/0x160
                    process_one_work+0x3fa/0x9f0
                    worker_thread+0x42/0x5c0
                    kthread+0x1a6/0x1e0
                    ret_from_fork+0x1f/0x30
   INITIAL USE at:
                   lock_acquire+0xd7/0x330
                   _raw_spin_lock_irqsave+0x33/0x50
                   usb_set_device_state+0x1d/0x220
                   register_root_hub+0x46/0x297
                   usb_add_hcd.cold.37+0x588/0x805
                   dummy_hcd_probe+0xea/0x1d1
                   platform_probe+0x80/0x100
                   really_probe+0x12a/0x4d0
                   __driver_probe_device+0x195/0x220
                   driver_probe_device+0x2a/0x120
                   __device_attach_driver+0x102/0x1a0
                   bus_for_each_drv+0xb8/0x100
                   __device_attach+0x149/0x220
                   bus_probe_device+0xdb/0xf0
                   device_add+0x64f/0xd40
                   platform_device_add+0x1f0/0x390
                   init+0x454/0x856
                   do_one_initcall+0xa9/0x550
                   kernel_init_freeable+0x3ae/0x42b
                   kernel_init+0x17/0x1b0
                   ret_from_fork+0x1f/0x30
 }
 ... key      at: [<ffffffff866fbf18>] device_state_lock+0x18/0x200
 ... acquired at:
   __lock_acquire+0x3a5/0x1d60
   lock_acquire+0xd7/0x330
   lock_sock_nested+0x2d/0xa0
   l2cap_sock_teardown_cb+0x37/0x2e0
   l2cap_chan_del+0x5b/0x4a0
   l2cap_chan_close+0x1df/0x3f0
   l2cap_chan_timeout+0xcf/0x160
   process_one_work+0x3fa/0x9f0
   worker_thread+0x42/0x5c0
   kthread+0x1a6/0x1e0
   ret_from_fork+0x1f/0x30


stack backtrace:
CPU: 1 PID: 6964 Comm: kworker/1:7 Not tainted 5.15.0-rc5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
Workqueue: events l2cap_chan_timeout
Call Trace:
 dump_stack_lvl+0xcd/0x134
 mark_lock.part.54+0x32c/0x830
 __lock_acquire+0x3a5/0x1d60
 lock_acquire+0xd7/0x330
 lock_sock_nested+0x2d/0xa0
 l2cap_sock_teardown_cb+0x37/0x2e0
 l2cap_chan_del+0x5b/0x4a0
 l2cap_chan_close+0x1df/0x3f0
 l2cap_chan_timeout+0xcf/0x160
 process_one_work+0x3fa/0x9f0
 worker_thread+0x42/0x5c0
 kthread+0x1a6/0x1e0
 ret_from_fork+0x1f/0x30
================================================================================
UBSAN: array-index-out-of-bounds in kernel/locking/qspinlock.c:130:9
index 1046 is out of range for type 'long unsigned int [8]'
CPU: 1 PID: 6964 Comm: kworker/1:7 Not tainted 5.15.0-rc5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
Workqueue: events l2cap_chan_timeout
Call Trace:
 dump_stack_lvl+0xcd/0x134
 ubsan_epilogue+0xb/0x5a
 __ubsan_handle_out_of_bounds+0x93/0xa1
 __pv_queued_spin_lock_slowpath+0x30e/0x320
 do_raw_spin_lock+0xb6/0xc0
 lock_sock_nested+0x54/0xa0
 l2cap_sock_teardown_cb+0x37/0x2e0
 l2cap_chan_del+0x5b/0x4a0
 l2cap_chan_close+0x1df/0x3f0
 l2cap_chan_timeout+0xcf/0x160
 process_one_work+0x3fa/0x9f0
 worker_thread+0x42/0x5c0
 kthread+0x1a6/0x1e0
 ret_from_fork+0x1f/0x30
================================================================================

Best,
Wei
