Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3513F5B1291
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 04:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiIHChn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 22:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIHChm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 22:37:42 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C10C6526;
        Wed,  7 Sep 2022 19:37:40 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id bn9so18229780ljb.6;
        Wed, 07 Sep 2022 19:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=7xfo1t0Mjz7JHwVeDqy2RVRwxIGPpSh2U8isoMwE4RM=;
        b=KEtUU7pliz21rp1lhfBEiM0Cbjd3FGNGwWUs94BdDhRfJX4Rg7Bb6438/dyEBJjDpm
         L9ep6h9h0SeW6QhSXcnKU7AFZovBkpZgIu7PDvCOE6euFRb+hgaoXyQU6farRWdFCOmo
         n8bIuS4vS14N+te+6ip/Q7e1kgsImF6P33OBEQbZy8qHbqwE+2ePOtq8S096fmKirqtL
         rNhx+t4j5UpvOMCg9EhUbuaKhNfs1b87a8tBGddVwcbfS1sAZ7v8XnxVGeyqFm91hgqh
         oqp1UmqH9FJi5seXCLUPzB8m02DeHDv2LiXI9ySAMvCt/JPETAcntavsX9t9AOZNM71k
         qVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=7xfo1t0Mjz7JHwVeDqy2RVRwxIGPpSh2U8isoMwE4RM=;
        b=UYZUxhQ/XIzHCn7v9bNUPoOAfY+cQNR3aPOrnPi6G/ZDKGMX/77orfDzUxMTKrwcHW
         lc11B8jjiFC031FiXjUxR977v6p6eLD5MpF0PfbWQ7Y6PICB7BSPrvqPuJC9ffHllZqY
         OdMU6nxybITueuf6QRqiUTGneDhctBPtAN1X1UGeTHDEGa0GAc2vo1qEZLg+4H6wvjJ+
         Mex/7N/I/EbDFpguObmQtdo6VPQkR6ozBltevXt20/ts6q4JGA3iQByxfl8GJdqC+CdN
         z4ukFuX4qBFgHTtuqnhKG3+Nk53IT4tUo0TahIyRyup+pzn9etl7epUeZwZysShkQdau
         ZZhg==
X-Gm-Message-State: ACgBeo3+nWoVsPnEEby7eoaJino1Vtggj50Len2MzxmFpj6I2MMbYQqZ
        V/8wdDxsGFOotbvbffcb0lE744HVunHeb+BbZWg=
X-Google-Smtp-Source: AA6agR5wLhRP7P8RVkSNKMnybd00BQQnFi0JKo5dM7rfchYrLrBRpybhTeqEvt/5VFWe8433KIL3bXS4wbC9yU5L7Cc=
X-Received: by 2002:a05:651c:211d:b0:266:20b6:ae57 with SMTP id
 a29-20020a05651c211d00b0026620b6ae57mr1745525ljq.108.1662604658953; Wed, 07
 Sep 2022 19:37:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car>
In-Reply-To: <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 8 Sep 2022 10:37:02 +0800
Message-ID: <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Tejun Heo <tj@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
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

On Thu, Sep 8, 2022 at 6:29 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> > Hello,
> >
> > On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> > ...
> > > This patchset tries to resolve the above two issues by introducing a
> > > selectable memcg to limit the bpf memory. Currently we only allow to
> > > select its ancestor to avoid breaking the memcg hierarchy further.
> > > Possible use cases of the selectable memcg as follows,
> >
> > As discussed in the following thread, there are clear downsides to an
> > interface which requires the users to specify the cgroups directly.
> >
> >  https://lkml.kernel.org/r/YwNold0GMOappUxc@slm.duckdns.org
> >
> > So, I don't really think this is an interface we wanna go for. I was hoping
> > to hear more from memcg folks in the above thread. Maybe ping them in that
> > thread and continue there?
>

Hi Roman,

> As I said previously, I don't like it, because it's an attempt to solve a non
> bpf-specific problem in a bpf-specific way.
>

Why do you still insist that bpf_map->memcg is not a bpf-specific
issue after so many discussions?
Do you charge the bpf-map's memory the same way as you charge the page
caches or slabs ?
No, you don't. You charge it in a bpf-specific way.

> Yes, memory cgroups are not great for accounting of shared resources, it's well
> known. This patchset looks like an attempt to "fix" it specifically for bpf maps
> in a particular cgroup setup. Honestly, I don't think it's worth the added
> complexity. Especially because a similar behaviour can be achieved simple
> by placing the task which creates the map into the desired cgroup.

Are you serious ?
Have you ever read the cgroup doc? Which clearly describe the "No
Internal Process Constraint".[1]
Obviously you can't place the task in the desired cgroup, i.e. the parent memcg.

[1] https://www.kernel.org/doc/Documentation/cgroup-v2.txt

> Beatiful? Not. Neither is the proposed solution.
>

Is it really hard to admit a fault?

-- 
Regards
Yafang
