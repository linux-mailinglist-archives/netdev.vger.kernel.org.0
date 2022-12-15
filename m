Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC9F64D7CF
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 09:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiLOIdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 03:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiLOIdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 03:33:04 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D61421E3A
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 00:33:03 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3b5d9050e48so32058677b3.2
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 00:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zw/RhO20UZoC9G6TTtJdTuGGtmTIwLpJWlVSECXA/JQ=;
        b=gcsIYuVB82zmxWO/jv48MxPYs/gdG0Rzgpy4wX731BSR6Ttm6idl29NDWcRjsNF2Fw
         KM3t76IuqbWGol7of0hQGE0hHket69xGNdMfpqVWd8Ec4c4wIcV7CylfuKzhKOHKg6yh
         pK4VsYzt/CuGw0wlVvfQWeImLnu1VtMQGODFp3UUiLMGJ1WdH8+umfjBSGtNUSYss9rV
         vYX4NRdzDPMvtbcC3HpAotwqT86gCotG5RM1KTgPGSmadSZoriXzdSpdmODGSEm4YDD/
         892saize8LGzjzv2uXxazAbI7+oio/WylRwWh/5jhPzLnzLYa/CSjiTyWhSCd2R2NglO
         MDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zw/RhO20UZoC9G6TTtJdTuGGtmTIwLpJWlVSECXA/JQ=;
        b=rRLooc6o9YZtTnhqcuuVOkQsNXCxgdhUpKZwlpPs8sRy/LAtGSAV+yYPRm05Y87dqf
         7vlTiZB4NaCJfGkrSW0EYB8kyUWrqaX8RX8KR08bLrNxjSshemAqOwYdAVE233kTW57I
         2OOtGr5PLcYYGEExWHByDY/kDKZb04GD7bxj0ievlb6YVC7GufyOhZ9D19hhg5TEBxkV
         ajT5HzTtDu9gKJC2xIUbf34iOMzIGlfbs3fLvZ+3Mk2rcnRQfdFHTrDslX49daCdlXd6
         TcTyV/mFX5U3rU9DmyNKX9pK9tV3oOdL4KIAem/i/i7HdRTgHHg7fuEeg20nPZB4Dp8E
         R7NQ==
X-Gm-Message-State: ANoB5pmvjv0pioshgatPi1nXGobFUAEQ9jrhPl68p9mXOYrFQORChDyL
        icnxXOBUupE5VAlRgZ7kFKDjqgtunPeI02PGxIR24w==
X-Google-Smtp-Source: AA0mqf6cRDw1YzTC3hDYy0SnSaLdyQgBIFRKlD+OEaTHlI7sxKEzblretR0JoOMFb3J2KB25ISksl50/IuhdDqdsXRM=
X-Received: by 2002:a81:9188:0:b0:379:3bb4:596f with SMTP id
 i130-20020a819188000000b003793bb4596fmr26819268ywg.238.1671093181145; Thu, 15
 Dec 2022 00:33:01 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvcmmOh93nOti72+woKvE+XvLg7apCYDUfu6oKtjPkHKw@mail.gmail.com>
In-Reply-To: <CA+G9fYvcmmOh93nOti72+woKvE+XvLg7apCYDUfu6oKtjPkHKw@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 15 Dec 2022 09:32:24 +0100
Message-ID: <CANpmjNOwsvfnJXzaFOUCYFRT_TM-z1YWqHv-nx3DY_V2f3xBhg@mail.gmail.com>
Subject: Re: BUG: KCSAN: data-race in do_page_fault / spectre_v4_enable_task_mitigation
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        rcu <rcu@vger.kernel.org>, kunit-dev@googlegroups.com,
        lkft-triage@lists.linaro.org,
        kasan-dev <kasan-dev@googlegroups.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Netdev <netdev@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Dec 2022 at 08:32, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> [Please ignore if it is already reported, and not an expert of KCSAN]
>
> On Linux next-20221215 tag arm64 allmodconfig boot failed due to following
> data-race reported by KCSAN.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> [    0.000000][    T0] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
> [    0.000000][    T0] Linux version 6.1.0-next-20221214
> (tuxmake@tuxmake) (aarch64-linux-gnu-gcc (Debian 12.2.0-9) 12.2.0, GNU
> ld (GNU Binutils for Debian) 2.39) #2 SMP PREEMPT_DYNAMIC @1671022464
> [    0.000000][    T0] random: crng init done
> [    0.000000][    T0] Machine model: linux,dummy-virt
> ...
> [ 1067.461794][  T132] BUG: KCSAN: data-race in do_page_fault /
> spectre_v4_enable_task_mitigation
> [ 1067.467529][  T132]
> [ 1067.469146][  T132] write to 0xffff80000f00bfb8 of 8 bytes by task
> 93 on cpu 0:
> [ 1067.473790][  T132]  spectre_v4_enable_task_mitigation+0x2f8/0x340
> [ 1067.477964][  T132]  __switch_to+0xc4/0x200

Please provide line numbers with all reports - you can use the script
scripts/decode_stacktrace.sh (requires the vmlinux you found this
with) to do so.

It would be good to do this immediately, because having anyone else do
so is nearly impossible - and without line numbers this report will
very likely be ignored.

Thanks,
-- Marco

> [ 1067.480877][  T132]  __schedule+0x5ec/0x6c0
> [ 1067.483764][  T132]  schedule+0x6c/0x100
> [ 1067.486526][  T132]  worker_thread+0x7d8/0x8c0
> [ 1067.489581][  T132]  kthread+0x1b8/0x200
> [ 1067.492483][  T132]  ret_from_fork+0x10/0x20
> [ 1067.495450][  T132]
> [ 1067.497034][  T132] read to 0xffff80000f00bfb8 of 8 bytes by task
> 132 on cpu 0:
> [ 1067.501684][  T132]  do_page_fault+0x568/0xa40
> [ 1067.504938][  T132]  do_mem_abort+0x7c/0x180
> [ 1067.508051][  T132]  el0_da+0x64/0x100
> [ 1067.510712][  T132]  el0t_64_sync_handler+0x90/0x180
> [ 1067.514191][  T132]  el0t_64_sync+0x1a4/0x1a8
> [ 1067.517200][  T132]
> [ 1067.518758][  T132] 1 lock held by (udevadm)/132:
> [ 1067.521883][  T132]  #0: ffff00000b802c28
> (&mm->mmap_lock){++++}-{3:3}, at: do_page_fault+0x480/0xa40
> [ 1067.528399][  T132] irq event stamp: 1461
> [ 1067.531041][  T132] hardirqs last  enabled at (1460):
> [<ffff80000af83e40>] preempt_schedule_irq+0x40/0x100
> [ 1067.537176][  T132] hardirqs last disabled at (1461):
> [<ffff80000af82c84>] __schedule+0x84/0x6c0
> [ 1067.542788][  T132] softirqs last  enabled at (1423):
> [<ffff800008020688>] fpsimd_restore_current_state+0x148/0x1c0
> [ 1067.549480][  T132] softirqs last disabled at (1421):
> [<ffff8000080205fc>] fpsimd_restore_current_state+0xbc/0x1c0
> [ 1067.556127][  T132]
> [ 1067.557687][  T132] value changed: 0x0000000060000000 -> 0x0000000060001000
> [ 1067.562039][  T132]
> [ 1067.563631][  T132] Reported by Kernel Concurrency Sanitizer on:
> [ 1067.567480][  T132] CPU: 0 PID: 132 Comm: (udevadm) Tainted: G
>           T  6.1.0-next-20221214 #2
> 4185b46758ba972fed408118afddb8c426bff43a
> [ 1067.575669][  T132] Hardware name: linux,dummy-virt (DT)
>
>
> metadata:
>   repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/?h=next-20221214
>   config: allmodconfig
>   arch: arm64
>   Build details:
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20221214/
>
> --
> Linaro LKFT
> https://lkft.linaro.org
