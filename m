Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2886451504D
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378824AbiD2QIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378793AbiD2QIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:08:10 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F7F8A9F2;
        Fri, 29 Apr 2022 09:04:51 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id r8so8971447oib.5;
        Fri, 29 Apr 2022 09:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MQcZ21ZXrJjtfh7JWVyd82OFreqrUf57vyzG9uXB95s=;
        b=NQuHjq75yTcETqoe5MFxchlZ/6p7R23s4Uh/eK6M8cjCLKjgK4aZLK94enM9k42z9z
         9olN5ZP+vAQmeXTs3TpSIt0NzvMdqABegG4qz96TEt/HS/xzZxrOdtT3s38HXa8rxQCC
         //y1nGWR49pl0bI4BXJikvhyEOuRN9x7yyhQG6wmlGrFanhXAWznrpMOX2TZU06+jYUn
         nIWU94QXvKkXMgCPv2tcj5gD6bKy2psqRCjrFUOKa8Bl/tDHLN4JOX0rshY1mFgS6Dj8
         yb9QNW2JBzYk707yzx4X/QadG8x7UesXEXLRQ21ibqXwVr/gFDYqh338pCxNErks0fTt
         i5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MQcZ21ZXrJjtfh7JWVyd82OFreqrUf57vyzG9uXB95s=;
        b=ImG0b922h0BGihPj///MaVbRZvAolGPsyuh2B8Q3a9yKpb4uQOCum5BFgkmNgdF++e
         j/8RfsytsruzhkBVSgtDQoXZLtBpmZ6IuA18UWvbLV+caztIRM2pdrKZM3L0BYU0miJl
         7/ARfkWnnwsrin8gW1LKtit4R3YTMJSDlf9ZRmPkbNHeH2Zoh71BAYSLu/HllkL7qpdB
         s2FuJmY/kpbvxvph34sx6dlXvlrzpWpB5kQofP568xXtSx09Bg6O5233/Yj36Hb5Qb3n
         WJE40RcziDeQooRhlMxyXK6qo0K1pcjErY48WCV7AUL5jr43OxtABN6gAU2YcEbr2T9T
         cm0g==
X-Gm-Message-State: AOAM530kXIbtar/LUIG6hVjRN4hJVSVRepFgn9+MQiVSIVh2UW+0wiMp
        6IRC56tgdGIC4Uy1pbkodofFB/LwWlLjwe1lBKs=
X-Google-Smtp-Source: ABdhPJysHLlZfOKGv6xFakU0zwsYHpphdLaC+QwvkTPAsD1DKrMZHBdjgWt7xXjXQ23jsIbpf+qT2AhQ4uRAgVD8DGA=
X-Received: by 2002:a05:6808:1202:b0:2f9:c7b4:fd56 with SMTP id
 a2-20020a056808120200b002f9c7b4fd56mr15139oil.55.1651248290317; Fri, 29 Apr
 2022 09:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220427224924.592546-1-gpiccoli@igalia.com> <20220427224924.592546-22-gpiccoli@igalia.com>
In-Reply-To: <20220427224924.592546-22-gpiccoli@igalia.com>
From:   Max Filippov <jcmvbkbc@gmail.com>
Date:   Fri, 29 Apr 2022 09:04:39 -0700
Message-ID: <CAMo8BfKzA+oy-Qun9-aO3xCr4Jy_rfdjYqMX=W9xONCSX8O51Q@mail.gmail.com>
Subject: Re: [PATCH 21/30] panic: Introduce the panic pre-reboot notifier list
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, bhe@redhat.com,
        Petr Mladek <pmladek@suse.com>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org,
        "open list:ALPHA PORT" <linux-alpha@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org,
        "open list:PARISC ARCHITECTURE" <linux-parisc@vger.kernel.org>,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>, netdev <netdev@vger.kernel.org>,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        "open list:SPARC + UltraSPAR..." <sparclinux@vger.kernel.org>,
        xen-devel@lists.xenproject.org,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>, d.hatayama@jp.fujitsu.com,
        Dave Hansen <dave.hansen@linux.intel.com>, dyoung@redhat.com,
        feng.tang@intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de,
        Kees Cook <keescook@chromium.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, paulmck@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        stern@rowland.harvard.edu, Thomas Gleixner <tglx@linutronix.de>,
        vgoyal@redhat.com, vkuznets@redhat.com,
        Will Deacon <will@kernel.org>, Alex Elder <elder@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Chris Zankel <chris@zankel.net>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Corey Minyard <minyard@acm.org>,
        Dexuan Cui <decui@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        James Morse <james.morse@arm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matt Turner <mattst88@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Richard Henderson <rth@twiddle.net>,
        Richard Weinberger <richard@nod.at>,
        Robert Richter <rric@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Wei Liu <wei.liu@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 3:55 PM Guilherme G. Piccoli
<gpiccoli@igalia.com> wrote:
>
> This patch renames the panic_notifier_list to panic_pre_reboot_list;
> the idea is that a subsequent patch will refactor the panic path
> in order to better split the notifiers, running some of them very
> early, some of them not so early [but still before kmsg_dump()] and
> finally, the rest should execute late, after kdump. The latter ones
> are now in the panic pre-reboot list - the name comes from the idea
> that these notifiers execute before panic() attempts rebooting the
> machine (if that option is set).
>
> We also took the opportunity to clean-up useless header inclusions,
> improve some notifier block declarations (e.g. in ibmasm/heartbeat.c)
> and more important, change some priorities - we hereby set 2 notifiers
> to run late in the list [iss_panic_event() and the IPMI panic_event()]
> due to the risks they offer (may not return, for example).
> Proper documentation is going to be provided in a subsequent patch,
> that effectively refactors the panic path.

[...]

>  arch/xtensa/platforms/iss/setup.c     |  4 ++--For xtensa:

For xtensa:
Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
