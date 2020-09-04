Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D26825CEA5
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 02:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgIDADY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 20:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgIDADX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 20:03:23 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B4AC061244;
        Thu,  3 Sep 2020 17:03:22 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mm21so2328790pjb.4;
        Thu, 03 Sep 2020 17:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cj3+cdRjrtuvAOlnzoorb+VXke8olHrY8VsdlX1pr7Q=;
        b=vBVFoYncSg1VNMXbjAmP480Fgjk2zYZEEUFIiJE+I92q2KGmVI+plyP1qtuJBQ8bVz
         +/G1Ub3CsFWTdtpHL/Qtq7z2IL30gbLQjJNymEK26JOBS7if53okL2wvnEypnLeRoqWv
         +mbEqulIjcUVLt4xSTF6u5DfuJCd5fSD7CvY2uz4BLtKBh6yV2n4Pkod7d26/hl+CTj6
         xM6T60S8ovsCbEwoLEyewq53ujSHeGyJVhkAiCZKqy2cOchiamEKpe3npZgWA9buAApH
         CJM40Fr7gErNcWLuXxLTpxGE3CEMW3z85Ll6ZWRrbFq1FMBDJdK/LWoZ1hEF+qY3UY+w
         eDvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cj3+cdRjrtuvAOlnzoorb+VXke8olHrY8VsdlX1pr7Q=;
        b=CFXR00NDc/slJrRSFnfraetNkFGS5aDf/Osogfvf5kPW1gy5ipJEeM0UQG36Dw7geR
         lpZXh5LnaU9wQb4g/KvXoef/EJjdJ6+FSg5p2iZnzt3JBEdbZO0wr8kDoVCn5UOd1g5S
         3F864lpq2Mh4Zig1Qj914CT0OaYpCgT/KLMPQMVwMmJ1jnjArY3WEt2wziO7q5qIgriV
         aJOue6QiabY08hy2Z+KO9KVQN8NSrX2SB0FL5gn/OhY7YIuXiIDCZjie4A3eo9RPsAuv
         DKmtJPwfCiwHmmpBVzQXuLUmmYcD4DN3BbWKexqI05ugb13oFeTQYVn30XlzxIVaeAA0
         0pRw==
X-Gm-Message-State: AOAM53007vtVe/HP7U0Z3vloJ/opCIsO567zpged0a+EDiKCgYd29Wp+
        6ABayzft8wH1VVGYdiyHJDE=
X-Google-Smtp-Source: ABdhPJy3XQhU/TIvlOj0y9muYNElxYKFRvQBDX4sMCq2XL0k+r/7CQ9Jf58zUomrXciFa1vF50tW7g==
X-Received: by 2002:a17:90b:715:: with SMTP id s21mr5267731pjz.113.1599177801607;
        Thu, 03 Sep 2020 17:03:21 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8159])
        by smtp.gmail.com with ESMTPSA id x4sm4368098pfm.86.2020.09.03.17.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 17:03:20 -0700 (PDT)
Date:   Thu, 3 Sep 2020 17:03:18 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf 1/2] bpf: do not use bucket_lock for hashmap iterator
Message-ID: <20200904000318.2fvn22kwfpsoq7kd@ast-mbp.dhcp.thefacebook.com>
References: <20200902235340.2001300-1-yhs@fb.com>
 <20200902235340.2001375-1-yhs@fb.com>
 <CAEf4BzaBxaPyWXOWOVRWCXcLW40FOFWkG7gUPSktGwS07duQVA@mail.gmail.com>
 <f93015c5-5fed-4775-93c3-6b85a8e7c0da@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f93015c5-5fed-4775-93c3-6b85a8e7c0da@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 07:44:34PM -0700, Yonghong Song wrote:
> 
> 
> On 9/2/20 6:25 PM, Andrii Nakryiko wrote:
> > On Wed, Sep 2, 2020 at 4:56 PM Yonghong Song <yhs@fb.com> wrote:
> > > 
> > > Currently, for hashmap, the bpf iterator will grab a bucket lock, a
> > > spinlock, before traversing the elements in the bucket. This can ensure
> > > all bpf visted elements are valid. But this mechanism may cause
> > > deadlock if update/deletion happens to the same bucket of the
> > > visited map in the program. For example, if we added bpf_map_update_elem()
> > > call to the same visited element in selftests bpf_iter_bpf_hash_map.c,
> > > we will have the following deadlock:
> > > 
> > 
> > [...]
> > 
> > > 
> > > Compared to old bucket_lock mechanism, if concurrent updata/delete happens,
> > > we may visit stale elements, miss some elements, or repeat some elements.
> > > I think this is a reasonable compromise. For users wanting to avoid
> > 
> > I agree, the only reliable way to iterate map without duplicates and
> > missed elements is to not update that map during iteration (unless we
> > start supporting point-in-time snapshots, which is a very different
> > matter).
> > 
> > 
> > > stale, missing/repeated accesses, bpf_map batch access syscall interface
> > > can be used.
> > > 
> > > Signed-off-by: Yonghong Song <yhs@fb.com>
> > > ---
> > >   kernel/bpf/hashtab.c | 15 ++++-----------
> > >   1 file changed, 4 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> > > index 78dfff6a501b..7df28a45c66b 100644
> > > --- a/kernel/bpf/hashtab.c
> > > +++ b/kernel/bpf/hashtab.c
> > > @@ -1622,7 +1622,6 @@ struct bpf_iter_seq_hash_map_info {
> > >          struct bpf_map *map;
> > >          struct bpf_htab *htab;
> > >          void *percpu_value_buf; // non-zero means percpu hash
> > > -       unsigned long flags;
> > >          u32 bucket_id;
> > >          u32 skip_elems;
> > >   };
> > > @@ -1632,7 +1631,6 @@ bpf_hash_map_seq_find_next(struct bpf_iter_seq_hash_map_info *info,
> > >                             struct htab_elem *prev_elem)
> > >   {
> > >          const struct bpf_htab *htab = info->htab;
> > > -       unsigned long flags = info->flags;
> > >          u32 skip_elems = info->skip_elems;
> > >          u32 bucket_id = info->bucket_id;
> > >          struct hlist_nulls_head *head;
> > > @@ -1656,19 +1654,18 @@ bpf_hash_map_seq_find_next(struct bpf_iter_seq_hash_map_info *info,
> > > 
> > >                  /* not found, unlock and go to the next bucket */
> > >                  b = &htab->buckets[bucket_id++];
> > > -               htab_unlock_bucket(htab, b, flags);
> > > +               rcu_read_unlock();
> > 
> > Just double checking as I don't yet completely understand all the
> > sleepable BPF implications. If the map is used from a sleepable BPF
> > program, we are still ok doing just rcu_read_lock/rcu_read_unlock when
> > accessing BPF map elements, right? No need for extra
> > rcu_read_lock_trace/rcu_read_unlock_trace?
> I think it is fine now since currently bpf_iter program cannot be sleepable
> and the current sleepable program framework already allows the following
> scenario.
>   - map1 is a preallocated hashmap shared by two programs,
>     prog1_nosleep and prog2_sleepable
> 
> ...				  ...
> rcu_read_lock()			  rcu_read_lock_trace()
> run prog1_nosleep                 run prog2_sleepable
>   lookup/update/delete map1 elem    lookup/update/delete map1 elem
> rcu_read_unlock()		  rcu_read_unlock_trace()
> ...				  ...

rcu_trace doesn't protect the map. It protects the program. Even for
prog2_sleepable the map is protected by rcu. The whole map including all
elements will be freed after both sleepable and non-sleepable progs stop
executing. This rcu_read_lock is needed for non-preallocated hash maps where
individual elements are rcu protected. See free_htab_elem() doing call_rcu().
When the combination of sleepable progs and non-prealloc hashmap is enabled
we would need to revisit this iterator assumption.
