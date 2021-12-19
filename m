Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DECC479F0C
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 05:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhLSEAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 23:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhLSEAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 23:00:45 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B30AC061574;
        Sat, 18 Dec 2021 20:00:45 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b22so924073pfb.5;
        Sat, 18 Dec 2021 20:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CgaCXZKUkJ+LRtZHi5u9VqE2TYTRmss2sqOJDyZtcEY=;
        b=cHoOLPEnrtnmx2bFvUkoqux1mq9N+/fqSdgCEEZJwxsSpMc7+74FVuyKiDm+cgv/vo
         LDHFvICVS2l5WQ9FhJJxJNEPEL1l+qXPeLiXOLjbg+4vJPFBGac5xpWrjzacxB03/ElY
         oSVkjeIrZ6qI/0j1MaDTGYosW/wvUl31TYtAWsf8zf+7e3nk5JIyfAiMhLbp9Rstb44l
         0MwwZw0i25+io6jayBw5eHWJMYZqYYfukjm0jVNv+20xjanqv/m0xuQhIHW6Ova5XBPd
         zpYwejX5OFja2xudoZDkVQ1FpRie8P6H/xWVYZr1A88PAjMRNSA/bi5cov+n6+wTgARZ
         5ssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CgaCXZKUkJ+LRtZHi5u9VqE2TYTRmss2sqOJDyZtcEY=;
        b=us/NNC+rcbf7xDKXcTuHQxJ33cRxEDm+XSthoA3wYA+oWrKE3xIxGprCJvvfJis1Ha
         NVMNa4Hjs6leKZ1kdZtijiFDFHr/YvrD1z5gnY1mN6HJgWUiSFAwZnOtabYFzJoUZV/D
         aJfkTS28JMZA2CSpvgLANaesWwNRwTfsZqdZyyN0SZBbV3d8AYO+2bpjtLDjrOhW2J18
         wMZSrJ/ab0Ol6h0Zmrhjq+HCt9Hfz3KX+v20LNQWl4A6tx/mU4SYc2EEn2nvyqEQjDdi
         quySMKj5crEZozTRI7MgQkIR3bYMwF3jObbAbXacAuriWVmah8IyWPMJnApYpF6+gs+A
         pgyw==
X-Gm-Message-State: AOAM532jLwOeXAD5/UO5XejFok2nIdtqD9Sje93tv4bY2Sk5ufyrRiIQ
        ZgLEk8bDkuy9yQmrJUjTs6bQNuHCszvWuWJlIE0=
X-Google-Smtp-Source: ABdhPJygGtgfguFBNN70M68qH+G5v1IDGneG/Z2FNkpo9rDXXhhFEGS1f3HW9Ta8SQ3ZfthENpjYJMmJ9n/Nf/WFwbU=
X-Received: by 2002:aa7:81c2:0:b0:4ba:81a8:645d with SMTP id
 c2-20020aa781c2000000b004ba81a8645dmr8846395pfn.77.1639886443791; Sat, 18 Dec
 2021 20:00:43 -0800 (PST)
MIME-Version: 1.0
References: <20211217015031.1278167-1-memxor@gmail.com> <20211217015031.1278167-7-memxor@gmail.com>
 <20211219022839.kdms7k3jte5ajubt@ast-mbp> <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
In-Reply-To: <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 18 Dec 2021 20:00:32 -0800
Message-ID: <CAADnVQJ43O-eavsMuqW0kCiBZMf4PFHbFhSPa7vRWY1cjwqFAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 06/10] bpf: Track provenance for pointers
 formed from referenced PTR_TO_BTF_ID
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 7:18 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sun, Dec 19, 2021 at 07:58:39AM IST, Alexei Starovoitov wrote:
> > On Fri, Dec 17, 2021 at 07:20:27AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> > > index b80fe5bf2a02..a6ef11db6823 100644
> > > --- a/include/linux/bpf_verifier.h
> > > +++ b/include/linux/bpf_verifier.h
> > > @@ -128,6 +128,16 @@ struct bpf_reg_state {
> > >      * allowed and has the same effect as bpf_sk_release(sk).
> > >      */
> > >     u32 ref_obj_id;
> > > +   /* This is set for pointers which are derived from referenced
> > > +    * pointer (e.g. PTR_TO_BTF_ID pointer walking), so that the
> > > +    * pointers obtained by walking referenced PTR_TO_BTF_ID
> > > +    * are appropriately invalidated when the lifetime of their
> > > +    * parent object ends.
> > > +    *
> > > +    * Only one of ref_obj_id and parent_ref_obj_id can be set,
> > > +    * never both at once.
> > > +    */
> > > +   u32 parent_ref_obj_id;
> >
> > How would it handle parent of parent?
>
> When you do:
>
> r1 = acquire();
>
> it gets ref_obj_id as N, then when you load r1->next, it does mark_btf_ld_reg
> with reg->ref_obj_id ?: reg->parent_ref_obj_id, the latter is zero so it copies
> ref, but into parent_ref_obj_id.
>
> r2 = r1->next;
>
> From here on, parent_ref_obj_id is propagated into all further mark_btf_ld_reg,
> so if we do since ref_obj_id will be zero from previous mark_btf_ld_reg:
>
> r3 = r2->next; // it will copy parent_ref_obj_id
>
> I think it even works fine when you reach it indirectly, like foo->bar->foo,
> if first foo is referenced.
>
> ... but maybe I missed some detail, do you see a problem in this approach?
>
> > Did you consider map_uid approach ?
> > Similar uid can be added for PTR_TO_BTF_ID.
> > Then every such pointer will be unique. Each deref will get its own uid.
>
> I'll look into it, I didn't consider it before. My idea was to invalidate
> pointers obtained from a referenced ptr_to_btf_id so I copied the same
> ref_obj_id into parent_ref_obj_id, so that it can be matched during release. How
> would that work in the btf_uid approach if they are unique? Do we copy the same
> ref_obj_id into btf_uid? Then it's not very different except being btf_id ptr
> specific state, right?
>
> Or we can copy ref_obj_id and also set uid to disallow it from being released,
> but still allow invalidation.

The goal is to disallow:
struct foo { struct foo *next; };

r1 = acquire(...); // BTF ID of struct foo
if (r1) {
        r2 = r1->next;
        release(r2);
}

right?
With btf_uid approach each deref gets its own uid.
r2 = r1->next
and
r3 = r1->next
will get different uids.
When type == PTR_TO_BTF_ID its reg->ref_obj_id will be considered
together with btf_uid.
Both ref_obj_id and btf_uid need to be the same.

But let's go back a bit.
Why ref_obj_id is copied on deref?
Shouldn't r2 get a different ref_obj_id after r2 = r1->next ?
