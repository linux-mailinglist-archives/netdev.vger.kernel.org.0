Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B08636ACB
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbiKWUS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239170AbiKWUSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:18:41 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486248CB8A;
        Wed, 23 Nov 2022 12:18:32 -0800 (PST)
Message-ID: <20221123201306.823305113@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669234710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=o8uOQEGEwvYxhWAaMgeou6hbxri/lpOsubwv/Uf38Z0=;
        b=COYcMAmIbivJBidbwe5beja4+qO+a8aJL86E1O0/FC6ijE5U4SgaE/VYSfjK4v7VfrER/J
        M4MstFRQiuExyavyhsazBJbyu+2tFMasg5J6K2w6oi/OsbbAzRgb8qMwL5wU68MrHpcypC
        a/Nvi55H+MhuHqZkybiRUsEzuljxPjl3ERCezh2xJQVERdFWebqYjomIfazUdve5gRYFSA
        RiN2gkIN3/kB08rJU/bbijrSpJxM9kNP8ihnMFPOZpdhFPMsUPm7i//XZUbTY1fAPNqhy7
        La6O7XCVTG67CO/ivKTpbhr744TC66Yj9zAp0GAQxonXXREmYwdutqyDhNHt5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669234710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=o8uOQEGEwvYxhWAaMgeou6hbxri/lpOsubwv/Uf38Z0=;
        b=tWkPr6RffzWLQkTR/NQ0KmNfRRYOB5CnJ78EApPCdOd2hKEEecFYpI3ioY7Zg39XeXnDkQ
        gfsHlazd7+HNAdAQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [patch V3 00/17] timers: Provide timer_shutdown[_sync]()
Date:   Wed, 23 Nov 2022 21:18:29 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the third version of the timer shutdown work. The second version
can be found here:

  https://lore.kernel.org/all/20221122171312.191765396@linutronix.de

Tearing down timers can be tedious when there are circular dependencies to
other things which need to be torn down. A prime example is timer and
workqueue where the timer schedules work and the work arms the timer.

Steven and the Google Chromebook team ran into such an issue in the
Bluetooth HCI code.

Steven suggested to create a new function del_timer_free() which marks the
timer as shutdown. Rearm attempts of shutdown timers are discarded and he
wanted to emit a warning for that case:

   https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home

This resulted in a lengthy discussion and suggestions how this should be
implemented. The patch series went through several iterations and during
the review of the last version it turned out that this approach is
suboptimal:

   https://lore.kernel.org/all/20221110064101.429013735@goodmis.org

The warning is not really helpful because it's entirely unclear how it
should be acted upon. The only way to address such a case is to add 'if
(in_shutdown)' conditionals all over the place. This is error prone and in
most cases of teardown like the HCI one which started this discussion not
required all.

What needs to prevented is that pending work which is drained via
destroy_workqueue() does not rearm the previously shutdown timer. Nothing
in that shutdown sequence relies on the timer being functional.

The conclusion was that the semantics of timer_shutdown_sync() should be:

    - timer is not enqueued
    - timer callback is not running
    - timer cannot be rearmed

Preventing the rearming of shutdown timers is done by discarding rearm
attempts silently.

As Steven is short of cycles, I made some spare cycles available and
reworked the patch series to follow the new semantics and plugged the races
which were discovered during review.

The patches have been split up into small pieces to make review easier and
I took the liberty to throw a bunch of overdue cleanups into the picture
instead of proliferating the existing state further.

The last patch in the series addresses the HCI teardown issue for real.

The series is also available from git:

   git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git timers

Changes vs. V2:

  - Fixed up change logs and comments (Anna-Maria)

  - Picked up Reviewed-by tags

Thanks,

	tglx
---
 Documentation/RCU/Design/Requirements/Requirements.rst      |    2 
 Documentation/core-api/local_ops.rst                        |    2 
 Documentation/kernel-hacking/locking.rst                    |   17 
 Documentation/timers/hrtimers.rst                           |    2 
 Documentation/translations/it_IT/kernel-hacking/locking.rst |   14 
 Documentation/translations/zh_CN/core-api/local_ops.rst     |    2 
 arch/arm/mach-spear/time.c                                  |    8 
 drivers/bluetooth/hci_qca.c                                 |   10 
 drivers/char/tpm/tpm-dev-common.c                           |    4 
 drivers/clocksource/arm_arch_timer.c                        |   12 
 drivers/clocksource/timer-sp804.c                           |    6 
 drivers/staging/wlan-ng/hfa384x_usb.c                       |    4 
 drivers/staging/wlan-ng/prism2usb.c                         |    6 
 include/linux/timer.h                                       |   35 
 kernel/time/timer.c                                         |  425 +++++++++---
 net/sunrpc/xprt.c                                           |    2 
 16 files changed, 405 insertions(+), 146 deletions(-)

