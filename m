Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7634C1DDF
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 22:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242952AbiBWVmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 16:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbiBWVmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 16:42:04 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A074913D77;
        Wed, 23 Feb 2022 13:41:34 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o8so2552023pgf.9;
        Wed, 23 Feb 2022 13:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EG+iB3dFwWjygwETyeLB9Os/1lUyeWVlILzRoMGRiFE=;
        b=jUTL1UK7tCThWjlmG8kcatM4NJsuIbOhe+O/CWvbejFwB9eyuk6oUgrQNU+IfMBAvj
         Jn6o//EtdGiBnmMFTZ8ZToAmm6+p2nQpAsLMpeSiR9WHwYxTQpdvpYHCzSTcUom/uniH
         E5HSrFxhgkWYdfeqVM+30IeiY/ARWDfckEv+HuBnx+3kjGh4ocHnPaR3CkqBpWPsxVhh
         SV63hRgTZKRTci4nT7rMAbzW5XcLKZzFNjusmo7RkHOVljd+lXCwNHuOK9mJDWfeLWpY
         XnJ+rDpsKXwX4aqOPOlg0YN8IBdP0izQCTWSwtLnfGiMDWmAmY0hENRNbBXyAvYR8j+V
         iDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EG+iB3dFwWjygwETyeLB9Os/1lUyeWVlILzRoMGRiFE=;
        b=24jZjUdVrbOFJElgkQFPvMfIYrWU5FdGFlfQmZ2AbCBK8gT04vpuDSlkJ0aUqpy/sX
         QgFBe+OIPKBNdr+nrAA8tb9sOq+aaQ5SHy4g7r/FgByXSfMV5Y/qHq86uPgzDgCrthR3
         bRaW7dwfxRf6efAWK5GSUrMua2cz59+oD3+VXXMJYfTqIkTvjhERSfdtiy9LgkUKKNln
         0Z8FObYMqzrjifLQuMbLyEozu3xWIUzhoshP4AiCYfKJgpbwqYC5uikgYUJ5T0+9mgGm
         xusf7lJ0RDQMGUuxdILY0bj8hiexmH03ERux2ixNUKZ6dvl5O225mLUDOx4qb+eC3ub5
         jExA==
X-Gm-Message-State: AOAM532Bhk1DKaFp6vCbGyNdq0PxZGqclxJG8sCJNk/C2hEQDSOOHkrI
        dY/rJZHkp1ETkJ3t04tNKRyQEEjw6ytqgp0Jw7kUIBycOko=
X-Google-Smtp-Source: ABdhPJwlZWzWiS/QIXthR8l+4QB/0GvALzT7M+6p+lqZhRcg1BQGGGOBSq4XVmwGku9vPHG1gY/gSHGJlip4bX5Q7qA=
X-Received: by 2002:a63:602:0:b0:373:efe4:8a24 with SMTP id
 2-20020a630602000000b00373efe48a24mr1221110pgg.287.1645652493978; Wed, 23 Feb
 2022 13:41:33 -0800 (PST)
MIME-Version: 1.0
References: <20220220134813.3411982-1-memxor@gmail.com> <20220220134813.3411982-9-memxor@gmail.com>
 <20220222070405.i6esgcf7ouqrmoef@ast-mbp.dhcp.thefacebook.com> <20220223031310.d2jh4uwffn3jzoy4@apollo.legion>
In-Reply-To: <20220223031310.d2jh4uwffn3jzoy4@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 23 Feb 2022 13:41:22 -0800
Message-ID: <CAADnVQLea9VtJ18FNwfFBUCyGN9ox9FhUw2ipR8z2ACLOA=wFA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 08/15] bpf: Adapt copy_map_value for multiple
 offset case
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
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

On Tue, Feb 22, 2022 at 7:13 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Tue, Feb 22, 2022 at 12:34:05PM IST, Alexei Starovoitov wrote:
> > On Sun, Feb 20, 2022 at 07:18:06PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > The changes in this patch deserve closer look, so it has been split into
> > > its own independent patch. While earlier we just had to skip two objects
> > > at most while copying in and out of map, now we have potentially many
> > > objects (at most 8 + 2 = 10, due to the BPF_MAP_VALUE_OFF_MAX limit).
> > >
> > > Hence, divide the copy_map_value function into an inlined fast path and
> > > function call to slowpath. The slowpath handles the case of > 3 offsets,
> > > while we handle the most common cases (0, 1, 2, or 3 offsets) in the
> > > inline function itself.
> > >
> > > In copy_map_value_slow, we use 11 offsets, just to make the for loop
> > > that copies the value free of edge cases for the last offset, by using
> > > map->value_size as final offset to subtract remaining area to copy from.
> > >
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  include/linux/bpf.h  | 43 +++++++++++++++++++++++++++++++---
> > >  kernel/bpf/syscall.c | 55 ++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 95 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index ae599aaf8d4c..5d845ca02eba 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -253,12 +253,22 @@ static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
> > >             memset(dst + map->spin_lock_off, 0, sizeof(struct bpf_spin_lock));
> > >     if (unlikely(map_value_has_timer(map)))
> > >             memset(dst + map->timer_off, 0, sizeof(struct bpf_timer));
> > > +   if (unlikely(map_value_has_ptr_to_btf_id(map))) {
> > > +           struct bpf_map_value_off *tab = map->ptr_off_tab;
> > > +           int i;
> > > +
> > > +           for (i = 0; i < tab->nr_off; i++)
> > > +                   *(u64 *)(dst + tab->off[i].offset) = 0;
> > > +   }
> > >  }
> > >
> > > +void copy_map_value_slow(struct bpf_map *map, void *dst, void *src, u32 s_off,
> > > +                    u32 s_sz, u32 t_off, u32 t_sz);
> > > +
> > >  /* copy everything but bpf_spin_lock and bpf_timer. There could be one of each. */
> > >  static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
> > >  {
> > > -   u32 s_off = 0, s_sz = 0, t_off = 0, t_sz = 0;
> > > +   u32 s_off = 0, s_sz = 0, t_off = 0, t_sz = 0, p_off = 0, p_sz = 0;
> > >
> > >     if (unlikely(map_value_has_spin_lock(map))) {
> > >             s_off = map->spin_lock_off;
> > > @@ -268,13 +278,40 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
> > >             t_off = map->timer_off;
> > >             t_sz = sizeof(struct bpf_timer);
> > >     }
> > > +   /* Multiple offset case is slow, offload to function */
> > > +   if (unlikely(map_value_has_ptr_to_btf_id(map))) {
> > > +           struct bpf_map_value_off *tab = map->ptr_off_tab;
> > > +
> > > +           /* Inline the likely common case */
> > > +           if (likely(tab->nr_off == 1)) {
> > > +                   p_off = tab->off[0].offset;
> > > +                   p_sz = sizeof(u64);
> > > +           } else {
> > > +                   copy_map_value_slow(map, dst, src, s_off, s_sz, t_off, t_sz);
> > > +                   return;
> > > +           }
> > > +   }
> > > +
> > > +   if (unlikely(s_sz || t_sz || p_sz)) {
> > > +           /* The order is p_off, t_off, s_off, use insertion sort */
> > >
> > > -   if (unlikely(s_sz || t_sz)) {
> > > +           if (t_off < p_off || !t_sz) {
> > > +                   swap(t_off, p_off);
> > > +                   swap(t_sz, p_sz);
> > > +           }
> > >             if (s_off < t_off || !s_sz) {
> > >                     swap(s_off, t_off);
> > >                     swap(s_sz, t_sz);
> > > +                   if (t_off < p_off || !t_sz) {
> > > +                           swap(t_off, p_off);
> > > +                           swap(t_sz, p_sz);
> > > +                   }
> > >             }
> > > -           memcpy(dst, src, t_off);
> > > +
> > > +           memcpy(dst, src, p_off);
> > > +           memcpy(dst + p_off + p_sz,
> > > +                  src + p_off + p_sz,
> > > +                  t_off - p_off - p_sz);
> > >             memcpy(dst + t_off + t_sz,
> > >                    src + t_off + t_sz,
> > >                    s_off - t_off - t_sz);
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index beb96866f34d..83d71d6912f5 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -30,6 +30,7 @@
> > >  #include <linux/pgtable.h>
> > >  #include <linux/bpf_lsm.h>
> > >  #include <linux/poll.h>
> > > +#include <linux/sort.h>
> > >  #include <linux/bpf-netns.h>
> > >  #include <linux/rcupdate_trace.h>
> > >  #include <linux/memcontrol.h>
> > > @@ -230,6 +231,60 @@ static int bpf_map_update_value(struct bpf_map *map, struct fd f, void *key,
> > >     return err;
> > >  }
> > >
> > > +static int copy_map_value_cmp(const void *_a, const void *_b)
> > > +{
> > > +   const u32 a = *(const u32 *)_a;
> > > +   const u32 b = *(const u32 *)_b;
> > > +
> > > +   /* We only need to sort based on offset */
> > > +   if (a < b)
> > > +           return -1;
> > > +   else if (a > b)
> > > +           return 1;
> > > +   return 0;
> > > +}
> > > +
> > > +void copy_map_value_slow(struct bpf_map *map, void *dst, void *src, u32 s_off,
> > > +                    u32 s_sz, u32 t_off, u32 t_sz)
> > > +{
> > > +   struct bpf_map_value_off *tab = map->ptr_off_tab; /* already set to non-NULL */
> > > +   /* 3 = 2 for bpf_timer, bpf_spin_lock, 1 for map->value_size sentinel */
> > > +   struct {
> > > +           u32 off;
> > > +           u32 sz;
> > > +   } off_arr[BPF_MAP_VALUE_OFF_MAX + 3];
> > > +   int i, cnt = 0;
> > > +
> > > +   /* Reconsider stack usage when bumping BPF_MAP_VALUE_OFF_MAX */
> > > +   BUILD_BUG_ON(sizeof(off_arr) != 88);
> > > +
> > > +   for (i = 0; i < tab->nr_off; i++) {
> > > +           off_arr[cnt].off = tab->off[i].offset;
> > > +           off_arr[cnt++].sz = sizeof(u64);
> > > +   }
> > > +   if (s_sz) {
> > > +           off_arr[cnt].off = s_off;
> > > +           off_arr[cnt++].sz = s_sz;
> > > +   }
> > > +   if (t_sz) {
> > > +           off_arr[cnt].off = t_off;
> > > +           off_arr[cnt++].sz = t_sz;
> > > +   }
> > > +   off_arr[cnt].off = map->value_size;
> > > +
> > > +   sort(off_arr, cnt, sizeof(off_arr[0]), copy_map_value_cmp, NULL);
> >
> > Ouch. sort every time we need to copy map value?
> > sort it once please. 88 bytes in a map are worth it.
> > Especially since "slow" version will trigger with just 2 kptrs.
> > (if I understand this correctly).
>
> Ok, also think we can reduce the size of the 88 bytes down to 55 bytes (32-bit
> off + 8-bit size), and embed it in struct map. Then the shuffling needed for
> timer and spin lock should also be gone.

We can probably make this copy_map_value_slow to be the only function.
I suspect
+       /* There is always at least one element */
+       memcpy(dst, src, off_arr[0].off);
+       /* Copy the rest, while skipping other regions */
+       for (i = 1; i < cnt; i++) {
+               u32 curr_off = off_arr[i - 1].off + off_arr[i - 1].sz;
+               u32 next_off = off_arr[i].off;
+
+               memcpy(dst + curr_off, src + curr_off, next_off - curr_off);
+       }
is faster than the dance we currently do in copy_map_value with a bunch of if-s.
