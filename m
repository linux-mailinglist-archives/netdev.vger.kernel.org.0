Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2559C29D5EA
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgJ1WIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730312AbgJ1WHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:07:52 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655D8C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:07:51 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c6so454746qkg.12
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=18t2/9BUdXVT3FrRrj2981btsIjhV7OAUvBATF+KIB0=;
        b=k3loYIPiIcMAoy/iHvUGwPZSy6eOYNJ5ySXU0mvomWoI8EVBixJPtTbiWWBENmojE5
         HVounQUUhJcyiFj7vRWtbUM0vAIfmxfoxhTzD2jeeXblPYr/B+osGTlY4zvfmrD6Dnc2
         n83Xx/LHBU1ayGXESahM9ZnAAw9Fdj53NGBECTVEmklZqM9Xb2xEs5zD75v/PypwlJB/
         zQGS3lerJaQ67/a9WmO4MKWNdjWOhBJPu0D2q/jYeP9OkxLfi668ZRRKRh4YoJEL5yoo
         eB1ImiKGtkzeQrcRULLBMrp8KvKMjDePmGhAVk4lQ03OclTMTS+1OgAhqygAOUp4e6dD
         wnfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=18t2/9BUdXVT3FrRrj2981btsIjhV7OAUvBATF+KIB0=;
        b=rFa8uodhHqFCmfkcmy9zdx6BlwfogXRZpyFkkav2EalkPoLSZSU0Th7i0afMthR2YO
         G/4rcX5dGXii63afi3v9Z4znpVNYvPwq49Cc3eD4o30Lkk+F7gVRwh0t0mg9Nb9AqFLd
         LDBHGpY9rzqBgdV3lkQAd9rAnwO0oidFSNPsvB4YhsN4dba7Wiw5NaOBEi+vQtCDE3+h
         5oojgE3xrHpYR9GGaWLFwXkdgxVUGG15K9qE6/HCSNbM9Ah8HhV9wIuvbGnU4kXG6Xi9
         sYbxCthpyCpWClfOvG7eScZt9/A8mxfMn9lWuO685XyuXOOkgRCXyTekofEMwXv3UtU9
         eATw==
X-Gm-Message-State: AOAM531OSYlyZ2AUU+GMfnAYyrGovruuYTG8B4MjQxNXWC6oqjq1C+zA
        dZO5jHI/u0V4Oo+iTWcowsUuMZQG7m6YLkfyUVFkOfl4cjcuEQ==
X-Google-Smtp-Source: ABdhPJzaNeVHtbW1lh9ufGbWPWDwwPouKVzBfung1oI4AWTnRzs2nfDWv2Ui3GTcr/CHWTwh7/sk06XVd1vyJ5wCV6I=
X-Received: by 2002:aed:2f67:: with SMTP id l94mr4880669qtd.101.1603844962246;
 Tue, 27 Oct 2020 17:29:22 -0700 (PDT)
MIME-Version: 1.0
References: <20201023032944.399861-1-joshdon@google.com> <20201023104853.55ef1c20@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023104853.55ef1c20@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Josh Don <joshdon@google.com>
Date:   Tue, 27 Oct 2020 17:29:11 -0700
Message-ID: <CABk29NsiTvSqJjyayHSc26gMoQ8fLtjdEY6wY7bK8v6KKjMm5A@mail.gmail.com>
Subject: Re: [PATCH 1/3] sched: better handling for busy polling loops
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Xi Wang <xii@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 10:49 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 22 Oct 2020 20:29:42 -0700 Josh Don wrote:
> > Busy polling loops in the kernel such as network socket poll and kvm
> > halt polling have performance problems related to process scheduler load
> > accounting.
> >
> > Both of the busy polling examples are opportunistic - they relinquish
> > the cpu if another thread is ready to run.
>
> That makes it sound like the busy poll code is trying to behave like an
> idle task. I thought need_resched() meant we leave when we run out of
> slice, or kernel needs to go through a resched for internal reasons. No?
>

The issue is about the kernel's ability to identify the polling cpu,
such that it _could_ send a task to that cpu and trigger a resched.

> > This design, however, doesn't
> > extend to multiprocessor load balancing very well. The scheduler still
> > sees the busy polling cpu as 100% busy and will be less likely to put
> > another thread on that cpu. In other words, if all cores are 100%
> > utilized and some of them are running real workloads and some others are
> > running busy polling loops, newly woken up threads will not prefer the
> > busy polling cpus. System wide throughput and latency may suffer.
>
> IDK how well this extends to networking. Busy polling in networking is
> a conscious trade-off of CPU for latency, if application chooses to
> busy poll (which isn't the default) we should respect that.
>
> Is your use case primarily kvm?

Good point, we do make use of the networking portion but this might be
less applicable to users in general for that reason.  KVM is the
primary use case.
