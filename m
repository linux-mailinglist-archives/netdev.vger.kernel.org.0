Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09896344CD
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 20:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiKVTrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 14:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbiKVTqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 14:46:55 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2397C46D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:46:53 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id l190so15485087vsc.10
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iJupukkEoGhIVTPDQgfM6MLu0R+8+aVVrcwFrJK3N0c=;
        b=M80awYn8ZIf5OKkEY2DksCS/pgDp0Vlt4QAZaq4A5dWXtc7g9jtLqRw15V+r5kecxR
         /g6Lj8CXkZVy7zj5+J/Cc/xEv8SWpgJ35wU15k/o0m8ZFMXBIER7TqbblSrplcRN65sR
         VxwfriTfukZdxbDBMuTOJFjHE2A+ElzVavRiL7FmEX7KHHkpvs3SqIsFOBqGCVKehTta
         ScsClvj3jyvRwzH4fXxNxd6i7CCG1ApRWrtTG2AOuJJGcKg+wVEXDN7llD2pWGD89ZY5
         uSk/LGsGE/YLh9rkKe4Wi/REyuTnDjbG4DfUktJJroFAofiZ6N9GbZ/mt7hhKHw+jX0V
         aPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJupukkEoGhIVTPDQgfM6MLu0R+8+aVVrcwFrJK3N0c=;
        b=fVpEtOS9a7Pu6BPj3D31IZO3MN3DPKQciZq1Kwxh8gmyP/b9Y6sw+GDhWrYkxzlCBk
         MfEhh5gy4vmQmUj2t+Jfm+dtarxdhluOY8w2Ap2AqWWi84Flf7SoIzefN/d8omiD63AG
         d574nUDvrbZm12iV9iQ/GEVD0G+ZBMcMxck6quaHhHKWyq0uLzopHB+hnOXB8Zo8e+Yc
         loE5dJI3q718PeoEF2nYjS6gwGKPg0XqzhzLvQsbTs+sc2EKSUIy3p4ccNtGFeeCb892
         Ed1FajJv8VrhC++6VhZVD6XPe8jfhrlo1gHNFIkd5Wc9Es5C/Oyi0qizhC6cEiVojkvl
         lBHQ==
X-Gm-Message-State: ANoB5pkj1FTyl8HItp3X5G3QVc1+dsbXV/glUWjOaTdCNcw/ZOITAF3g
        2I4vlku2Ud0KEIlmp6uWpCJFEn98UlSiEeECUBzdC3toO28=
X-Google-Smtp-Source: AA0mqf4zhuspzMASRV535xF+302qrJJOauH0NL+OEdJsr1TbABXo+Yhb9mLmDvugbzEMGniRMzfswCkaxQecYC7OQtc=
X-Received: by 2002:a67:c906:0:b0:3aa:f64:fbfd with SMTP id
 w6-20020a67c906000000b003aa0f64fbfdmr5403462vsk.15.1669146412036; Tue, 22 Nov
 2022 11:46:52 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
In-Reply-To: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Tue, 22 Nov 2022 12:46:15 -0700
Message-ID: <CAOUHufYd-5cqLsQvPBwcmWeph2pQyQYFRWynyg0UVpzUBWKbxw@mail.gmail.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 5:53 PM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> Hello,
>
> We have observed a negative TCP throughput behavior from the following commit:
>
> * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
>
> It landed back in 2016 in v4.5, so it's not exactly a new issue.
>
> The crux of the issue is that in some cases with swap present the
> workload can be unfairly throttled in terms of TCP throughput.
>
> I am able to reproduce this issue in a VM locally on v6.1-rc6 with 8
> GiB of RAM with zram enabled.
>
> The setup is fairly simple:
>
> 1. Run the following go proxy in one cgroup (it has some memory
> ballast to simulate useful memory usage):
>
> * https://gist.github.com/bobrik/2c1a8a19b921fefe22caac21fda1be82
>
> sudo systemd-run --scope -p MemoryLimit=6G go run main.go
>
> 2. Run the following fio config in another cgroup to simulate mmapped
> page cache usage:
>
> [global]
> size=8g
> bs=256k
> iodepth=256
> direct=0
> ioengine=mmap
> group_reporting
> time_based
> runtime=86400
> numjobs=8
> name=randread
> rw=randread

Is it practical for your workload to apply some madvise/fadvise hint?
For the above repro, it would be fadvise_hint=1 which is mapped into
MADV_RANDOM automatically. The kernel also supports MADV_SEQUENTIAL,
but not POSIX_FADV_NOREUSE at the moment.

We actually have similar issues but unfortunately I haven't been able
to come up with any solution beyond recommending the above flags.
The problem is that harvesting the accessed bit from mmapped memory is
costly, and when random accesses happen fast enough, the cost of doing
that prevents LRU from collecting more information to make better
decisions. In a nutshell, LRU can't tell whether there is genuine
memory locality with your test case.

It's a very difficult problem to solve from LRU's POV. I'd like to
hear more about your workloads and see whether there are workarounds
other than tackling the problem head-on, if applying hints is not
practical or preferrable.
