Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099FB4C977A
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbiCAVFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236415AbiCAVF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:05:29 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6005679383
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 13:04:47 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id f37so28945937lfv.8
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 13:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jpkBhqMELpJRUkOoHFKbzsupAYwAnlqKB8gXhGz5QEA=;
        b=gAEAIwp5TiyGoTgh4JNV+tH2eEHsDrzmeuag0zysI+PtG0mBbTlY+GQ2Irys79Qi+L
         cwZSjxBpwdC2wHTKgnSPUDEg4jG5Iqs6jc/4r4BP55ON/wZvI6SvnOqgbVfnTZXuNlCj
         Sko4sfN5Hk+tcMgzt8aDx7pTJ2JptgMqAsdqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jpkBhqMELpJRUkOoHFKbzsupAYwAnlqKB8gXhGz5QEA=;
        b=McECQWUOrmq2HeWYecevovJ1j8MNW4AOmgGsmA+z7nQghLf0o/g2qrmU1hXYsrj44O
         B+G99Uzir8oSIPRKHJmjRv/xguGq886ntceA8GTJF1k0jd5bnybH5xgoSOtrNsPv2+c4
         DM+xSXdyl3Gfd2/lMZ9ZhheNgYs5gJ3grbLlpb9v1t9Rq0OBfMlHSS06piur+xX88NVJ
         z198nnYqOCJ+Hym8rNDqVA9Kh1YorTvdXzGtR6GOQf0Rx6p+FswEuPM9hEYtoPJxYaQm
         J+9tgzslcq5NDPIBHudslNw1gDJMOXEzjuTY0Afb5h8LjH6CajofmcE3RKfiEEkbCLHj
         RW+A==
X-Gm-Message-State: AOAM532m5x4TlEN0xjZyJ2WncsLW5UmJv7eRQhK0Hki4Iz2NiC1T0Q1/
        Z69+iQkqHBjTISWDW9nKXbiUyk0lPqeF67yDma0=
X-Google-Smtp-Source: ABdhPJxu4EyjD/sCc7GjrMdYwhWVfhgegfYvdS5xo4pkbmz+urbG9Uu7Ag+zQ5Y5KfMEKVFY+wXCrQ==
X-Received: by 2002:a19:ee17:0:b0:443:5f2c:289e with SMTP id g23-20020a19ee17000000b004435f2c289emr17014290lfb.57.1646168684235;
        Tue, 01 Mar 2022 13:04:44 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id o3-20020a2ebd83000000b002461808adbdsm2088425ljq.106.2022.03.01.13.04.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 13:04:43 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id v22so23566063ljh.7
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 13:04:42 -0800 (PST)
X-Received: by 2002:a2e:bc17:0:b0:246:32b7:464 with SMTP id
 b23-20020a2ebc17000000b0024632b70464mr18195828ljf.506.1646168682597; Tue, 01
 Mar 2022 13:04:42 -0800 (PST)
MIME-Version: 1.0
References: <20220301075839.4156-2-xiam0nd.tong@gmail.com> <202203020135.5duGpXM2-lkp@intel.com>
 <CAHk-=wiVF0SeV2132vaTAcL1ccVDP25LkAgNgPoHXdFc27x-0g@mail.gmail.com> <CAK8P3a0QAECV=_Bu5xnBxjxUHLcaGjBgJEjfMaeKT7StR=acyQ@mail.gmail.com>
In-Reply-To: <CAK8P3a0QAECV=_Bu5xnBxjxUHLcaGjBgJEjfMaeKT7StR=acyQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 1 Mar 2022 13:04:26 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiFbzpyt1-9ZAigFYU7R8g9mEgJho3w7yGYe0h-W==nsw@mail.gmail.com>
Message-ID: <CAHk-=wiFbzpyt1-9ZAigFYU7R8g9mEgJho3w7yGYe0h-W==nsw@mail.gmail.com>
Subject: Re: [PATCH 1/6] Kbuild: compile kernel with gnu11 std
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     kernel test robot <lkp@intel.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        kbuild-all@lists.01.org, Jakob Koschel <jakobkoschel@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 1, 2022 at 12:54 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> gcc-11 only shows the one line warning here.

What an odd warning. Not even a filename, much less a line number?

> The source is
>
> /* PCI CFG04 status fields */
> #define PCI_CFG04_STAT_BIT      16
> #define PCI_CFG04_STAT          0xffff0000
> #define PCI_CFG04_STAT_66_MHZ   (1 << 21)
> #define PCI_CFG04_STAT_FBB      (1 << 23)
> #define PCI_CFG04_STAT_MDPE     (1 << 24)
> #define PCI_CFG04_STAT_DST      (1 << 25)
> #define PCI_CFG04_STAT_STA      (1 << 27)
> #define PCI_CFG04_STAT_RTA      (1 << 28)
> #define PCI_CFG04_STAT_RMA      (1 << 29)
> #define PCI_CFG04_STAT_SSE      (1 << 30)
> #define PCI_CFG04_STAT_PE       (1 << 31)
> #define KORINA_STAT             (PCI_CFG04_STAT_MDPE | \
>                                  PCI_CFG04_STAT_STA | \
>                                  PCI_CFG04_STAT_RTA | \
>                                  PCI_CFG04_STAT_RMA | \
>                                  PCI_CFG04_STAT_SSE | \
>                                  PCI_CFG04_STAT_PE)
> #define KORINA_CNFG1            ((KORINA_STAT<<16)|KORINA_CMD)

Yeah, looks like that "<< 16" is likely just wrong.

I'm guessing that that KORINA_CNFG1 thing either ends up not
mattering, or - probably more likely - nobody really used that
platform at all. It has had pretty much zero updates sinced 2008.

               Linus
