Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFBF563DC4
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 04:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiGBCbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 22:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGBCbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 22:31:21 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB4A443E5;
        Fri,  1 Jul 2022 19:31:19 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id w187so3940534vsb.1;
        Fri, 01 Jul 2022 19:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hx6C0REYOyh4lsLIj1klc5VkK2ngiLm4+Ug0oOhVfVI=;
        b=N/xaDT/wzFPhyxF+16AqxggfF4dnog15barsEoFeoKLkGFg/s95fDBLxusbgE383MC
         Q+ttVlrgdDNFvwyl30r4f4a7XQwEuVVM4qdzm6nxyudvks+twBVYVgsMeayMUbXwq2rV
         XnobeFpBLJ+s3LSfvQCpytlmwW33ZcliwsSpUQqYS5L2XqyGH0USDXAFkO1s42qA1yRr
         uvHgVSTTeqEiDnAzjCTqNUMSrFna8VkwCsNEoDZZZoBFRcGO1j3eX5pO7S2Hk4MvhkEl
         jH1UrmLT2AVz14qYYy2H3Z/a+yPcBrGmRN6+lBL9BMtV8+vM1gkOpo/WzJrJ27h1+Ing
         CkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hx6C0REYOyh4lsLIj1klc5VkK2ngiLm4+Ug0oOhVfVI=;
        b=qHXtkNJb+mBhBA1rgE0ansvT6rDC4eGn5N8vH1PrWBHjaOeZhpheWHBHs8HJfi9ljo
         RDtalYbRVZ+pVGskyYmioupdJH31vjdFLywCzU2TLWTnVTareCGaj+u8Xwtn6GCR7Tlo
         Fa5kCcStR/JLof1srdRudood8+b4tQyHsiyPDDH3OkrH0/iG+EJiDdiyXCW21uhICeAd
         6sXtKeaHwhvizM4bYSrzqkvijgFR8yUZD4ovFcMY73MQkLECfDx94mOqjoj5D4YD8Zjx
         NUprebw1qNHEWLYGkv6edXrWayIqEThCprd7JjBjEtfqmwTPORhL23ow0HSOgaBLRZas
         9lQA==
X-Gm-Message-State: AJIora9PXcm8gLBrERb4v/3qJlcy7SIHjCqxPgBcDxP9w/sgOU3dnhI/
        SUysDkEa/8XmIeozGpxZHfUJTf8E5e6FKWYABH0=
X-Google-Smtp-Source: AGRyM1udqb0j9PlWG6deTNLBZy2thLWnJLzENdVb4BoRAayOCw9ACazUqZNnS5ek90feEfe0L1DkKl3T2zgWSrYOZl0=
X-Received: by 2002:a05:6102:3d28:b0:354:5e75:7031 with SMTP id
 i40-20020a0561023d2800b003545e757031mr13147162vsv.35.1656729078527; Fri, 01
 Jul 2022 19:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220629154832.56986-1-laoar.shao@gmail.com> <20220629154832.56986-2-laoar.shao@gmail.com>
 <ede2c8ea-693d-fe70-12a2-bf8ccca97eb0@iogearbox.net>
In-Reply-To: <ede2c8ea-693d-fe70-12a2-bf8ccca97eb0@iogearbox.net>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 2 Jul 2022 10:30:41 +0800
Message-ID: <CALOAHbCt88Y1xfXCPby+OwBXnR6chocC8Cefn_YNbuN4S9+Trw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: Make non-preallocated allocation low priority
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>
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

On Fri, Jul 1, 2022 at 5:47 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi Yafang,
>
> On 6/29/22 5:48 PM, Yafang Shao wrote:
> > GFP_ATOMIC doesn't cooperate well with memcg pressure so far, especially
> > if we allocate too much GFP_ATOMIC memory. For example, when we set the
> > memcg limit to limit a non-preallocated bpf memory, the GFP_ATOMIC can
> > easily break the memcg limit by force charge. So it is very dangerous to
> > use GFP_ATOMIC in non-preallocated case. One way to make it safe is to
> > remove __GFP_HIGH from GFP_ATOMIC, IOW, use (__GFP_ATOMIC |
> > __GFP_KSWAPD_RECLAIM) instead, then it will be limited if we allocate
> > too much memory.
> >
> > We introduced BPF_F_NO_PREALLOC is because full map pre-allocation is
> > too memory expensive for some cases. That means removing __GFP_HIGH
> > doesn't break the rule of BPF_F_NO_PREALLOC, but has the same goal with
> > it-avoiding issues caused by too much memory. So let's remove it.
> >
> > __GFP_KSWAPD_RECLAIM doesn't cooperate well with memcg pressure neither
> > currently. But the memcg code can be improved to make
> > __GFP_KSWAPD_RECLAIM work well under memcg pressure.
>
> Ok, but could you also explain in commit desc why it's a specific problem
> to BPF hashtab?
>

It should be a specific problem to non-preallocated BPF maps.
BPF program has its special attribute that it can run without user
application, for example, when it is pinned.
So if the user agent exits after pinning the BPF program, and if the
BPF maps are not preallocated, the memory allocated by the maps will
be continuously charged to a memcg. Then it may happen that the memcg
will eventually be filled with kernel memory. That is not a usual case
for other memcg users. Finally the memcg can't limit it because it can
force charge.

Regarding the preallocated BPF maps, it doesn't have this problem
because all its memory is allocated at load time, and if the memory
exceeds the memcg limit, it won't be loaded.

> Afaik, there is plenty of other code using GFP_ATOMIC | __GFP_NOWARN outside
> of BPF e.g. under net/, so it's a generic memcg problem?
>

I haven't checked all other GFP_ATOMIC usage yet.
But per my understanding, the net/ code should have user applications,
and if it exceeds the memcg limit, the user applications will be
killed and then it will stop allocating new memory.

[ + Shakeel, Johannes ]

This issue can be fixed in the memcg charge path.  But the memg charge
path is fragile.
The force charge of GFP_ATOMIC was introduced in
commit 869712fd3de5 ("mm: memcontrol: fix network errors from failing
__GFP_ATOMIC charges") by checking __GFP_ATOMIC, and then got improved
in
commit 1461e8c2b6af ("memcg: unify force charging conditions") by
checking __GFP_HIGH (that is no problem because both __GFP_HIGH and
__GFP_ATOMIC are set in GFP_AOMIC).
So it seems that once we fix a problem in memcg, another problem may
be introduced by this fix. So, if we want to fix it in memcg, we have
to carefully verify all the callsites. Now that we can fix it in BPF,
we'd better not modify the memcg code.  But maybe a comment is needed
in memcg, in case someone may change the behavior of GFP_ATOMIC in the
memg charge path once more, for example,

nomem:
+   /* Pls, don't force charge __GFP_ATOMIC allocation if
+    * __GFP_HIGH or __GFP_NOFAIL is not set with it.
+    */
    if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
        return -ENOMEM;
force:


> Why are lpm trie and local storage map for BPF not affected (at least I don't
> see them covered in the patch)?
>

I haven't verified lpm trie and local storage map yet.
I will verify them.

-- 
Regards
Yafang
