Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5671B21909C
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgGHTcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgGHTcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:32:48 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F08C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 12:32:47 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l1so6323879ioh.5
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 12:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w8UvXoHb7y5X75MWtq77a+YH5kV5jqJT6G5G6UB3IBc=;
        b=vbK1QanA+tEIT+hWhI0BaTX26QB2jHPE2X5CkakE8tCDIHlcsWTaQHXEy0n/RZxfWI
         CIQbj7A3/AH1sYkzz0AvUi/6kjpuh2jcU3WxaNPSCYKrjnZ3GRpKvr21I7zjtgNjeQMD
         tSDBQe1nwTZoX1BsiWK3zvaUBesn4iEFfbLeo1j5Ix0QbZu0eltMP7Nl0UyLL0OKjnHj
         EfJ6osweHZvexzRPVC8PaucFYaYTlqYcCwjYuVcdLV5KC6mEOnhEdc64c8HOLUSpwshJ
         o3tQ/5JO76mWkiXO28IRR1SAhDsThC2wY7ZNoP9dau24SznTSBhA1SBUe2NCul/E1D5+
         IyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w8UvXoHb7y5X75MWtq77a+YH5kV5jqJT6G5G6UB3IBc=;
        b=SMao2A64cOTi9UnQEgEwNEbeF0sRcVbBdz1iSZ2jpJWT3VqAvTSo/930ChEuc925eP
         3a6xIJi2e+0kXBK0WjS4rMtbnOvDJIorItyZhCO3/rXxgkHrcsl5dT17ajXzNGFWUZ5v
         bYjJQj5HKQmMlamX8o+P7cqWP9oYx9IjNAvReOsUztFkzMhAh/hndOJMsaDOwfHby7Rw
         5Ka++VOw0aBZ7wHU7hBNYXj4G4EddIoR9QAAwUScP7vGMGCtLCu2UTrdZNubB3vePY08
         EVS+C1wiJx7G9JJjpq/tpRiA/bHleGiSlfEUpHM+Yculv541VtT6CMSVyYtYtmNPvjna
         lrQg==
X-Gm-Message-State: AOAM532B+iCUcKievMPQhTEQq7L4pa1GrtJFY8/T8y3lIjAS9dYfG8gx
        Vk/c9OFkL9vzBayV9LA9PgPCf4sivjFWSO+t53g=
X-Google-Smtp-Source: ABdhPJxNgrZdSwQF4+qFL3XcX/wEiGNcQ+zm21neDAiziNbmHIxYu6ND1loXuuUKfOQ78NdQYkiHC1wk1qrw5nmE7KA=
X-Received: by 2002:a05:6638:14b:: with SMTP id y11mr33338722jao.49.1594236767232;
 Wed, 08 Jul 2020 12:32:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200702185256.17917-1-xiyou.wangcong@gmail.com>
 <20200708153327.GA193647@roeck-us.net> <CAM_iQpWLcbALSZDNkiCm7zKOjMZV8z1XnC5D0vyiYPC6rU3v8A@mail.gmail.com>
 <fe638e54-be0e-d729-a20f-878d017d0da7@roeck-us.net>
In-Reply-To: <fe638e54-be0e-d729-a20f-878d017d0da7@roeck-us.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 8 Jul 2020 12:32:36 -0700
Message-ID: <CAM_iQpWWXmrNzNZc5-N=bXo2_o58V0=3SeFkPzmJaDL3TVUeEA@mail.gmail.com>
Subject: Re: [Patch net v2] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 12:07 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 7/8/20 11:34 AM, Cong Wang wrote:
> > Hi,
> >
> > On Wed, Jul 8, 2020 at 8:33 AM Guenter Roeck <linux@roeck-us.net> wrote:
> >> This patch causes all my s390 boot tests to crash. Reverting it fixes
> >> the problem. Please see bisect results and and crash log below.
> >>
> > ...
> >> Crash log:
> >
> > Interesting. I don't see how unix socket is any special here, it creates
> > a peer sock with sk_alloc(), but this is not any different from two separated
> > sockets.
> >
> > What is your kernel config? Do you enable CONFIG_CGROUP_NET_PRIO
> > or CONFIG_CGROUP_NET_CLASSID? I can see there might be a problem
> > if you don't enable either of them but enable CONFIG_CGROUP_BPF.
> >
>
> cgroup specific configuration bits:
>
> CONFIG_CGROUPS=y
> CONFIG_BLK_CGROUP=y
> CONFIG_CGROUP_WRITEBACK=y
> CONFIG_CGROUP_SCHED=y
> CONFIG_CGROUP_PIDS=y
> CONFIG_CGROUP_RDMA=y
> CONFIG_CGROUP_FREEZER=y
> CONFIG_CGROUP_HUGETLB=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CGROUP_CPUACCT=y
> CONFIG_CGROUP_PERF=y
> CONFIG_CGROUP_BPF=y
> # CONFIG_CGROUP_DEBUG is not set
> CONFIG_SOCK_CGROUP_DATA=y
> CONFIG_BLK_CGROUP_RWSTAT=y
> CONFIG_BLK_CGROUP_IOLATENCY=y
> CONFIG_BLK_CGROUP_IOCOST=y
> # CONFIG_BFQ_CGROUP_DEBUG is not set
> # CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
> CONFIG_NET_CLS_CGROUP=y
> CONFIG_CGROUP_NET_PRIO=y
> CONFIG_CGROUP_NET_CLASSID=y
>
> This originates from arch/s390/configs/defconfig; I don't touch
> any cgroup specific configuration in my tests.

Good to know you enable everything related here.

>
> > And if you have the full kernel log, it would be helpful too.
> >
>
> https://kerneltests.org/builders/qemu-s390-pending-fixes/builds/222/steps/qemubuildcommand/logs/stdio

It looks like cgroup_sk_alloc_disabled is always false in your case.
This makes the bug even more weird. Unless there is a refcnt bug
prior to my commit, I don't see how it could happen.

>
> Interestingly, enabling CONFIG_BFQ_CGROUP_DEBUG makes the problem disappear.

Yeah, I guess there might be some cgroup refcnt bug which could
just paper out with CONFIG_BFQ_CGROUP_DEBUG=y.

If you can test patches, I can send you a debugging patch for you
to collect more data. I assume this is 100% reproducible on your
side?

Thanks.
