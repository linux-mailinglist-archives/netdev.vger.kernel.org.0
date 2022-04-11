Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC974FC785
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350380AbiDKWVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 18:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345541AbiDKWVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 18:21:02 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721D424BD3;
        Mon, 11 Apr 2022 15:18:47 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 66so15354365pga.12;
        Mon, 11 Apr 2022 15:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IEdQJBXmcjU6YEno39ozSPApIGPia4bKwlR7lkXebJY=;
        b=KGEwF19//QJliPtuVAcd2Sw8+zMBSvTqjyCXsvJrN8dD+UKUVvqDlalD5d334nPdHt
         +sLNBktVPNcMf8RFcOUmcV9cnXq4wPlYTFX7H9bo6R8i1IiYHwC1iR+q9EPxL3gKFAqP
         8eAIwX6dQBAhecsXhOAxUl4k+Zo+n39P+XaxHlL2UPkURBYRjvDBGBguXi9yI2XWWInl
         so6pZ7nNSFAQQxskPbYXyuZiKRm6fszqB1tY+I3WgLq/ImTlx6YKYxB9g48ykte6/YS7
         hZ2z+5V2XqpaAapKnCEkLNoq0LZUwagyA8CmZMzsnBo0xSX8lbs+/GuvJKXnysI+G1jv
         m1hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IEdQJBXmcjU6YEno39ozSPApIGPia4bKwlR7lkXebJY=;
        b=hdPwZJfRo4ZVBGBHUl+vm1Lt6H9ZUQN+qzDNNBuEN7+fXce+W971hxixxiNE863AkG
         ltywNpPdN/cd+booDYyEf22+Gw0Aj3hzb14Wkibz943xFEth/6ZYr2TOP6fTs7P9XLmE
         rf8OAoPtjdKF5kSuDcoB98CGndo2mxPf/S1mYQDXVjBFlbqw8I6bzAXip1kCbh5Tbh/a
         KGZpp5spQKpNnAcVqfJj19j6XPlGR6tKODdDX/p3jwmngBw938W3V3/vc8PyJcbToC6l
         UuL6fyNTwRc/fJqjgIPxm32VCtGQKrL2mTOQejYUG8JIL3Gp7irM5l0FZ2uMVEn/25WU
         8xMw==
X-Gm-Message-State: AOAM533F0Z95akCBDk47Yle/NkD6FPfjp/XNku3vvbJFkIQ2ujLbdEqR
        zh/XDwl6IMEDWl1BkWEwfwDSurXfzF9mX1peOaI=
X-Google-Smtp-Source: ABdhPJyd826K+dtQD2yJvH0FJzM9op75/X1x7qI8sPyAxDg0rgehWUGi6qLhTQxBBOMpKxwpjA5nZlgjnFUfK61ld6k=
X-Received: by 2002:a05:6a00:8c8:b0:4fe:ecb:9b8f with SMTP id
 s8-20020a056a0008c800b004fe0ecb9b8fmr34655402pfu.55.1649715526927; Mon, 11
 Apr 2022 15:18:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220408232922.mz2vi2oaxf2fvnvt@MBP-98dd607d3435.dhcp.thefacebook.com>
 <YlHrdhkfz+IuGbZM@krava> <CAEf4BzYXHeM+m64cV6_5TU0_BjotDVo+iw_wpJEWLkU9gsvfXg@mail.gmail.com>
In-Reply-To: <CAEf4BzYXHeM+m64cV6_5TU0_BjotDVo+iw_wpJEWLkU9gsvfXg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 11 Apr 2022 22:18:35 +0000
Message-ID: <CAADnVQLQj-ixQo5xEJEZaJavoNpVdhizDmkqFm+pDJq97_Ecpw@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/4] bpf: Speed up symbol resolving in kprobe multi link
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 10:15 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Apr 9, 2022 at 1:24 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Fri, Apr 08, 2022 at 04:29:22PM -0700, Alexei Starovoitov wrote:
> > > On Thu, Apr 07, 2022 at 02:52:20PM +0200, Jiri Olsa wrote:
> > > > hi,
> > > > sending additional fix for symbol resolving in kprobe multi link
> > > > requested by Alexei and Andrii [1].
> > > >
> > > > This speeds up bpftrace kprobe attachment, when using pure symbols
> > > > (3344 symbols) to attach:
> > > >
> > > > Before:
> > > >
> > > >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> > > >   ...
> > > >   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
> > > >
> > > > After:
> > > >
> > > >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> > > >   ...
> > > >   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
> > > >
> > > >
> > > > There are 2 reasons I'm sending this as RFC though..
> > > >
> > > >   - I added test that meassures attachment speed on all possible functions
> > > >     from available_filter_functions, which is 48712 functions on my setup.
> > > >     The attach/detach speed for that is under 2 seconds and the test will
> > > >     fail if it's bigger than that.. which might fail on different setups
> > > >     or loaded machine.. I'm not sure what's the best solution yet, separate
> > > >     bench application perhaps?
> > >
> > > are you saying there is a bug in the code that you're still debugging?
> > > or just worried about time?
> >
> > just the time, I can make the test fail (cross the 2 seconds limit)
> > when the machine is loaded, like with running kernel build
> >
> > but I couldn't reproduce this with just paralel test_progs run
> >
> > >
> > > I think it's better for it to be a part of selftest.
> > > CI will take extra 2 seconds to run.
> > > That's fine. It's a good stress test.
>
> I agree it's a good stress test, but I disagree on adding it as a
> selftests. The speed will depend on actual host machine. In VMs it
> will be slower, on busier machines it will be slower, etc. Generally,
> depending on some specific timing just causes unnecessary maintenance
> headaches. We can have this as a benchmark, if someone things it's
> very important. I'm impartial to having this regularly executed as
> it's extremely unlikely that we'll accidentally regress from NlogN
> back to N^2. And if there is some X% slowdown such selftest is
> unlikely to alarm us anyways. Sporadic failures will annoy us way
> before that to the point of blacklisting this selftests in CI at the
> very least.

Such selftest shouldn't be measuring the speed, of course.
The selftest will be about:
1. not crashing
2. succeeding to attach and getting some meaningful data back.
