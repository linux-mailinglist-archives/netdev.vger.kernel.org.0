Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB064289CFF
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 03:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgJJBUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 21:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729362AbgJJBFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 21:05:43 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D718C0613D8;
        Fri,  9 Oct 2020 18:05:43 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x20so8613330ybs.8;
        Fri, 09 Oct 2020 18:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CDAY/7V9d5a7TL2mDtUE2UAJHlprFRYTnmIGetlHh7M=;
        b=cMkrqUiyczNoV4Ux0HYlsBbl36CDwl8Dd3u1u6omjmMbYNwQv3bo5HhYljg+oMLnzr
         7iDGRViynYjaPORf0NINnszA3DkBxie3QmHdt1w1eWb7wcvFdo5WVmERtmItGAYyaq+F
         TVNBAOXMYnsRcOKetl0gJNsbjDlSAemW34tnvizWxP4pKjc4VAvogK97dRiQZhEKJUHz
         pYMp7MtpXBy6A6BHKB2qLOOrWmRJj8chMxLGhZj6/dK9DlleikbqMyYnTcQxMDPzjEHL
         U/BKY/ZTAU0xEBkuvvErdhsFcI3dOdXMXrQrxKIwFOvFcg3/9Jh6ktakIsZbJAVtpuQO
         oVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CDAY/7V9d5a7TL2mDtUE2UAJHlprFRYTnmIGetlHh7M=;
        b=fjLxeTZqQV7Y7HqtEtCuX9ohpSPeFS30Be9TrkyE+osPOZVpnKbonhXuJvI1orl6IH
         evRsiZuiPvBg8ehjXdeze93wSuJ6lGl+JumrAXbzZk6DD2KkQZ9Z3u0O3XSDh5V0dG4F
         T7/y8kFdWaPf9oOlyznt2bQ4Rc9Rhgne1zIofRxTIut8eQmFstKHBzXgvOO9xg6vUei4
         Y9ROEVc/+q/L2sLZrU+ZLPi0AAIFT7l1paAIJV5hujm/X0Rm6LqQSYyeVClDVEFGYNoH
         zDJBCegZej76NIGmZygx0lXvbfs1NEdNJh//+1EBXr0ngcEfmnGayBrcIQ9luNiibatM
         60pA==
X-Gm-Message-State: AOAM531Cp5JfsXGeUrkirZur/qI7yE478ODJEcxs1U/8+nzYX6aYY06G
        hOoiUOEw2+o1KKBafDqHo62cbftiR3pZHps3NzM9aFecImU=
X-Google-Smtp-Source: ABdhPJxD91j+JNyWq3pOl19fnwsYO++XTbn1+WKJAsFFzionf0414c874P4s74lGSzqWO3U4mNYE2lUjlCv2PILFQAY=
X-Received: by 2002:a25:cbc4:: with SMTP id b187mr21859998ybg.260.1602291942742;
 Fri, 09 Oct 2020 18:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <20201009224007.30447-1-daniel@iogearbox.net> <20201009224007.30447-4-daniel@iogearbox.net>
 <CAEf4BzYHRi3zBWcVYo=1oB2mcWaW_7HmKsSw6X2PU1deyXXaDw@mail.gmail.com> <f89ec10b-c0b8-8449-f820-730026ca0f3a@iogearbox.net>
In-Reply-To: <f89ec10b-c0b8-8449-f820-730026ca0f3a@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 9 Oct 2020 18:05:31 -0700
Message-ID: <CAEf4BzZz03sNVmBxVuUzapm2VwgGkoFZx9rCb2bs5mQx8pBTJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/6] bpf: allow for map-in-map with dynamic
 inner array map entries
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 5:10 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/10/20 1:01 AM, Andrii Nakryiko wrote:
> > On Fri, Oct 9, 2020 at 3:40 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> [...]
> >>          *insn++ = BPF_ALU64_IMM(BPF_ADD, map_ptr, offsetof(struct bpf_array, value));
> >>          *insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
> >>          if (!map->bypass_spec_v1) {
> >> @@ -496,8 +499,10 @@ static int array_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
> >>   static bool array_map_meta_equal(const struct bpf_map *meta0,
> >>                                   const struct bpf_map *meta1)
> >>   {
> >> -       return meta0->max_entries == meta1->max_entries &&
> >> -               bpf_map_meta_equal(meta0, meta1);
> >> +       if (!bpf_map_meta_equal(meta0, meta1))
> >> +               return false;
> >> +       return meta0->map_flags & BPF_F_INNER_MAP ? true :
> >> +              meta0->max_entries == meta1->max_entries;
> >
> > even if meta1 doesn't have BPF_F_INNER_MAP, it's ok, because all the
> > accesses for map returned from outer map lookup will not inline, is
> > that right? So this flag only matters for the inner map's prototype.
>
> Not right now, we would have to open code bpf_map_meta_equal() to cut out that
> bit from the meta0/1 flags comparison. I wouldn't change bpf_map_meta_equal()
> itself given that bit can be reused for different purpose for other map types.
>
> > You also mentioned that not inlining array access should still be
> > fast. So I wonder, what if we just force non-inlined access for inner
> > maps of ARRAY type? Would it be too bad of a hit for existing
> > applications?
>
> Fast in the sense of that we can avoid a retpoline given the direct call

Ah, ok, then probably an extra flag is necessary.

> to array_map_lookup_elem() as opposed to bpf_map_lookup_elem(). In the
> array_map_gen_lookup() we even have insn level optimizations such as
> replacing BPF_MUL with BPF_LSH with immediate elem size on power of 2
> #elems as well as avoiding spectre masking (which the call one has not),
> presumably for cases like XDP we might want the best implementation if
> usage allows it.
>
> > The benefit would be that everything would just work without a special
> > flag. If perf hit isn't prohibitive, it might be worthwhile to
> > simplify user experience?
>
> Taking the above penalty aside for same sized-elems, simplest one would have
> been to just set inner_map_meta->ops to &array_map_no_inline_ops inside the
> bpf_map_meta_alloc().
