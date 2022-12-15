Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4805064D746
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 08:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiLOHcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 02:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLOHcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 02:32:21 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389A629361
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 23:32:19 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id n9so516662uao.13
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 23:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oNTsmDDapjb0QCUT4JkH1Ng5FzflwQuaskNm+11VdTk=;
        b=vqHWFXqELUHjDbSk+vYDLahdb4i32UuejLtj+4l8WUo/K33Y/ZAxTVank7ioT5M0ca
         sayjXOF1yfjIQbkWT6pFZ9OjK7XjtlZolwvI2v0bjZ1zon2GquHQaFwWtO+qEsHHSsJq
         42ed3hVIDEPAnjZnY37SYpOs2sWldqlYEaVIWOTQ0Dnem1HhrLJokKJy5fJfx9aBsHqY
         753qrHr4ePnTJdzA53mVSIhZ1EL5esAyfR8pT3g3PWRkFJfCEQhFk6IrosTkCWFcizYX
         YQzgHXLn2a0MeCV5XRhjY0glhwy98gGRqTYRprJEthVqG9UreYuH4BMKI8FymQkFaRHw
         7B0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oNTsmDDapjb0QCUT4JkH1Ng5FzflwQuaskNm+11VdTk=;
        b=XKgDb2k94oYW9FFjEe1maveuA1XFGbd8cL3VzjwOkbS00KGTHWMSNIAJdwRvlChZ1s
         USp9lu5J0dDF0qKImSuThSYw3A+0TjMfwzgSEr/ehk5N9b8U71m4K5k+/RtZaXsPLIr7
         UR7jc73d4MZ96UW6ZaPA1wNBq9k1Ps29HA+xCye9+d0HfLCUhJVjctRgw1Wr6ktLDPUo
         H8qzFNGDYTY2c05YpQLdJhHVVt9IhY2I5Bra71C0gqBMCSN1mGvwGn4VTWiy10CS0eDW
         Qp5kdnxi/ajCbWcOsKO94emUF84QMxphM0qimQ2j5XRxo7I9f38nlyIu2mnjQ76UL5CL
         Fx3A==
X-Gm-Message-State: ANoB5pmkwuzpdgExqraO+fO8xWMZ3vkZjcC8vgWX/1Rn9dmA9mI3TN82
        Oe2pD1MS1A3Ik5TP0xSc2TqeRyd8VAYyq19D5Mz7+A==
X-Google-Smtp-Source: AA0mqf4mdM8daze+jg4ROFvYJZKnrPNtRPcBLjJAbg0oDjwpKohqIP2iv63Iok517809CK6m38SKPozgHBA+karTyLI=
X-Received: by 2002:ab0:6201:0:b0:419:da15:be26 with SMTP id
 m1-20020ab06201000000b00419da15be26mr8686832uao.115.1671089537713; Wed, 14
 Dec 2022 23:32:17 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 15 Dec 2022 13:02:06 +0530
Message-ID: <CA+G9fYvcmmOh93nOti72+woKvE+XvLg7apCYDUfu6oKtjPkHKw@mail.gmail.com>
Subject: BUG: KCSAN: data-race in do_page_fault / spectre_v4_enable_task_mitigation
To:     open list <linux-kernel@vger.kernel.org>,
        rcu <rcu@vger.kernel.org>, kunit-dev@googlegroups.com,
        lkft-triage@lists.linaro.org,
        kasan-dev <kasan-dev@googlegroups.com>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Netdev <netdev@vger.kernel.org>, Marco Elver <elver@google.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Please ignore if it is already reported, and not an expert of KCSAN]

On Linux next-20221215 tag arm64 allmodconfig boot failed due to following
data-race reported by KCSAN.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

[    0.000000][    T0] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
[    0.000000][    T0] Linux version 6.1.0-next-20221214
(tuxmake@tuxmake) (aarch64-linux-gnu-gcc (Debian 12.2.0-9) 12.2.0, GNU
ld (GNU Binutils for Debian) 2.39) #2 SMP PREEMPT_DYNAMIC @1671022464
[    0.000000][    T0] random: crng init done
[    0.000000][    T0] Machine model: linux,dummy-virt
...
[ 1067.461794][  T132] BUG: KCSAN: data-race in do_page_fault /
spectre_v4_enable_task_mitigation
[ 1067.467529][  T132]
[ 1067.469146][  T132] write to 0xffff80000f00bfb8 of 8 bytes by task
93 on cpu 0:
[ 1067.473790][  T132]  spectre_v4_enable_task_mitigation+0x2f8/0x340
[ 1067.477964][  T132]  __switch_to+0xc4/0x200
[ 1067.480877][  T132]  __schedule+0x5ec/0x6c0
[ 1067.483764][  T132]  schedule+0x6c/0x100
[ 1067.486526][  T132]  worker_thread+0x7d8/0x8c0
[ 1067.489581][  T132]  kthread+0x1b8/0x200
[ 1067.492483][  T132]  ret_from_fork+0x10/0x20
[ 1067.495450][  T132]
[ 1067.497034][  T132] read to 0xffff80000f00bfb8 of 8 bytes by task
132 on cpu 0:
[ 1067.501684][  T132]  do_page_fault+0x568/0xa40
[ 1067.504938][  T132]  do_mem_abort+0x7c/0x180
[ 1067.508051][  T132]  el0_da+0x64/0x100
[ 1067.510712][  T132]  el0t_64_sync_handler+0x90/0x180
[ 1067.514191][  T132]  el0t_64_sync+0x1a4/0x1a8
[ 1067.517200][  T132]
[ 1067.518758][  T132] 1 lock held by (udevadm)/132:
[ 1067.521883][  T132]  #0: ffff00000b802c28
(&mm->mmap_lock){++++}-{3:3}, at: do_page_fault+0x480/0xa40
[ 1067.528399][  T132] irq event stamp: 1461
[ 1067.531041][  T132] hardirqs last  enabled at (1460):
[<ffff80000af83e40>] preempt_schedule_irq+0x40/0x100
[ 1067.537176][  T132] hardirqs last disabled at (1461):
[<ffff80000af82c84>] __schedule+0x84/0x6c0
[ 1067.542788][  T132] softirqs last  enabled at (1423):
[<ffff800008020688>] fpsimd_restore_current_state+0x148/0x1c0
[ 1067.549480][  T132] softirqs last disabled at (1421):
[<ffff8000080205fc>] fpsimd_restore_current_state+0xbc/0x1c0
[ 1067.556127][  T132]
[ 1067.557687][  T132] value changed: 0x0000000060000000 -> 0x0000000060001000
[ 1067.562039][  T132]
[ 1067.563631][  T132] Reported by Kernel Concurrency Sanitizer on:
[ 1067.567480][  T132] CPU: 0 PID: 132 Comm: (udevadm) Tainted: G
          T  6.1.0-next-20221214 #2
4185b46758ba972fed408118afddb8c426bff43a
[ 1067.575669][  T132] Hardware name: linux,dummy-virt (DT)


metadata:
  repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/?h=next-20221214
  config: allmodconfig
  arch: arm64
  Build details:
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20221214/

--
Linaro LKFT
https://lkft.linaro.org
