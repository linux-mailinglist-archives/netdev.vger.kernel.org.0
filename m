Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F8921209D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgGBKJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:09:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46018 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727057AbgGBKJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 06:09:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593684551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1XoJCHWbAvd1q278HFyZF2XoClrLg3eVaSb7jGnSADY=;
        b=WO54+Gc83IRNtWC2Z1pWS5HSoM+AKbZ1OKqjXhcRciDHFwAYgYVmQUkiKgK22J4j9NJoLd
        iFJDLLsyj8nkGq+7MqRBjbfZ5NYMBY5IgOwmqjrkbGq0ZPhSh8sBaolAX7SfxsTAFVkVt2
        KZQMqlxOAXgrTJINHwKwNpe6L6q9bTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-7U8DlUR5N9uBvnK94CKN0Q-1; Thu, 02 Jul 2020 06:09:07 -0400
X-MC-Unique: 7U8DlUR5N9uBvnK94CKN0Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB77418FE86C;
        Thu,  2 Jul 2020 10:09:04 +0000 (UTC)
Received: from krava (unknown [10.40.195.148])
        by smtp.corp.redhat.com (Postfix) with SMTP id A8C205DC1E;
        Thu,  2 Jul 2020 10:09:00 +0000 (UTC)
Date:   Thu, 2 Jul 2020 12:08:59 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 bpf-next 07/14] bpf: Allow nested BTF object to be
 refferenced by BTF object + offset
Message-ID: <20200702100859.GC3144378@krava>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-8-jolsa@kernel.org>
 <CAEf4BzZA3QqA=f_E8CUASVajxEsThq+Ww2Ax6az82wibx1dgOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZA3QqA=f_E8CUASVajxEsThq+Ww2Ax6az82wibx1dgOg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 01:05:52PM -0700, Andrii Nakryiko wrote:
> On Thu, Jun 25, 2020 at 4:49 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding btf_struct_address function that takes 2 BTF objects
> > and offset as arguments and checks whether object A is nested
> > in object B on given offset.
> >
> > This function will be used when checking the helper function
> > PTR_TO_BTF_ID arguments. If the argument has an offset value,
> > the btf_struct_address will check if the final address is
> > the expected BTF ID.
> >
> > This way we can access nested BTF objects under PTR_TO_BTF_ID
> > pointer type and pass them to helpers, while they still point
> > to valid kernel BTF objects.
> >
> > Using btf_struct_access to implement new btf_struct_address
> > function, because it already walks down the given BTF object.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/bpf.h   |  3 ++
> >  kernel/bpf/btf.c      | 67 ++++++++++++++++++++++++++++++++++++++-----
> >  kernel/bpf/verifier.c | 37 +++++++++++++++---------
> >  3 files changed, 87 insertions(+), 20 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 3d2ade703a35..c0fd1f3037dd 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1300,6 +1300,9 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >                       const struct btf_type *t, int off, int size,
> >                       enum bpf_access_type atype,
> >                       u32 *next_btf_id);
> > +int btf_struct_address(struct bpf_verifier_log *log,
> > +                    const struct btf_type *t,
> > +                    u32 off, u32 id);
> >  int btf_resolve_helper_id(struct bpf_verifier_log *log,
> >                           const struct bpf_func_proto *fn, int);
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 701a2cb5dfb2..f87e5f1dc64d 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -3863,10 +3863,22 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >         return true;
> >  }
> >
> > -int btf_struct_access(struct bpf_verifier_log *log,
> > -                     const struct btf_type *t, int off, int size,
> > -                     enum bpf_access_type atype,
> > -                     u32 *next_btf_id)
> > +enum access_op {
> > +       ACCESS_NEXT,
> > +       ACCESS_EXPECT,
> > +};
> > +
> > +struct access_data {
> > +       enum access_op op;
> > +       union {
> > +               u32 *next_btf_id;
> > +               const struct btf_type *exp_type;
> > +       };
> > +};
> > +
> > +static int struct_access(struct bpf_verifier_log *log,
> > +                        const struct btf_type *t, int off, int size,
> > +                        struct access_data *data)
> >  {
> >         u32 i, moff, mtrue_end, msize = 0, total_nelems = 0;
> >         const struct btf_type *mtype, *elem_type = NULL;
> > @@ -3914,8 +3926,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >                         goto error;
> >
> >                 off = (off - moff) % elem_type->size;
> > -               return btf_struct_access(log, elem_type, off, size, atype,
> > -                                        next_btf_id);
> > +               return struct_access(log, elem_type, off, size, data);
> 
> hm... this should probably be `goto again;` to avoid recursion. This
> should have been caught in the original patch that added this
> recursive call.
> 
> >
> >  error:
> >                 bpf_log(log, "access beyond struct %s at off %u size %u\n",
> > @@ -4043,9 +4054,21 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >
> >                         /* adjust offset we're looking for */
> >                         off -= moff;
> > +
> > +                       /* We are nexting into another struct,
> > +                        * check if we are crossing expected ID.
> > +                        */
> > +                       if (data->op == ACCESS_EXPECT && !off && t == data->exp_type)
> 
> before you can do this type check, you need to btf_type_skip_modifiers() first.
> 
> > +                               return 0;
> >                         goto again;
> >                 }
> >
> > +               /* We are interested only in structs for expected ID,
> > +                * bail out.
> > +                */
> > +               if (data->op == ACCESS_EXPECT)
> > +                       return -EINVAL;
> > +
> >                 if (btf_type_is_ptr(mtype)) {
> >                         const struct btf_type *stype;
> >                         u32 id;
> > @@ -4059,7 +4082,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >
> >                         stype = btf_type_skip_modifiers(btf_vmlinux, mtype->type, &id);
> >                         if (btf_type_is_struct(stype)) {
> > -                               *next_btf_id = id;
> > +                               *data->next_btf_id = id;
> >                                 return PTR_TO_BTF_ID;
> >                         }
> >                 }
> > @@ -4083,6 +4106,36 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >         return -EINVAL;
> >  }
> >
> > +int btf_struct_access(struct bpf_verifier_log *log,
> > +                     const struct btf_type *t, int off, int size,
> > +                     enum bpf_access_type atype __maybe_unused,
> > +                     u32 *next_btf_id)
> > +{
> > +       struct access_data data = {
> > +               .op = ACCESS_NEXT,
> > +               .next_btf_id = next_btf_id,
> > +       };
> > +
> > +       return struct_access(log, t, off, size, &data);
> > +}
> > +
> > +int btf_struct_address(struct bpf_verifier_log *log,
> > +                      const struct btf_type *t,
> > +                      u32 off, u32 id)
> > +{
> > +       const struct btf_type *type;
> > +       struct access_data data = {
> > +               .op = ACCESS_EXPECT,
> > +       };
> > +
> > +       type = btf_type_by_id(btf_vmlinux, id);
> > +       if (!type)
> > +               return -EINVAL;
> > +
> > +       data.exp_type = type;
> > +       return struct_access(log, t, off, 1, &data);
> > +}
> > +
> >  int btf_resolve_helper_id(struct bpf_verifier_log *log,
> >                           const struct bpf_func_proto *fn, int arg)
> >  {
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 7de98906ddf4..da7351184295 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -3808,6 +3808,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >         struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
> >         enum bpf_reg_type expected_type, type = reg->type;
> >         enum bpf_arg_type arg_type = fn->arg_type[arg];
> > +       const struct btf_type *btf_type;
> >         int err = 0;
> >
> >         if (arg_type == ARG_DONTCARE)
> > @@ -3887,24 +3888,34 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >                 expected_type = PTR_TO_BTF_ID;
> >                 if (type != expected_type)
> >                         goto err_type;
> > -               if (!fn->check_btf_id) {
> > -                       if (reg->btf_id != meta->btf_id) {
> > -                               verbose(env, "Helper has type %s got %s in R%d\n",
> > +               if (reg->off) {
> > +                       btf_type = btf_type_by_id(btf_vmlinux, reg->btf_id);
> > +                       if (btf_struct_address(&env->log, btf_type, reg->off, meta->btf_id)) {
> > +                               verbose(env, "Helper has type %s got %s in R%d, off %d\n",
> >                                         kernel_type_name(meta->btf_id),
> > +                                       kernel_type_name(reg->btf_id), regno, reg->off);
> > +                               return -EACCES;
> > +                       }
> > +               } else {
> > +                       if (!fn->check_btf_id) {
> > +                               if (reg->btf_id != meta->btf_id) {
> > +                                       verbose(env, "Helper has type %s got %s in R%d\n",
> > +                                               kernel_type_name(meta->btf_id),
> > +                                               kernel_type_name(reg->btf_id), regno);
> > +
> > +                                       return -EACCES;
> > +                               }
> > +                       } else if (!fn->check_btf_id(reg->btf_id, arg)) {
> > +                               verbose(env, "Helper does not support %s in R%d\n",
> >                                         kernel_type_name(reg->btf_id), regno);
> >
> >                                 return -EACCES;
> >                         }
> 
> Ok, I think I'm grasping this a bit more. How about we actually don't
> have two different cases (btf_struct_access and btf_struct_address),
> but instead make unified btf_struct_access that will return the
> earliest field that register points to (so it sort of iterates deeper
> and deeper with each invocation). So e.g., let's assume we have this
> type:
> 
> 
> struct A {
>   struct B {
>     struct C {
>       int x;
>     } c;
>   } b;
>   struct D { int y; } d;
> };
> 
> Now consider the extreme case of a BPF helper that expects a pointer
> to the struct C or D (so uses a custom btf_id check function to say if
> a passed argument is acceptable or not), ok?
> 
> Now you write BPF program as such, r1 has pointer to struct A,
> originally (so verifier knows btf_id points to struct A):
> 
> int prog(struct A *a) {
>    return fancy_helper(&a->b.c);
> }
> 
> Now, when verifier checks fancy_helper first time, its btf_id check
> will say "nope". But before giving up, verifier calls
> btf_struct_access, it goes into struct A field, finds field b with
> offset 0, it matches register's offset (always zero in this scenario),
> sees that that field is a struct B, so returns that register now
> points to struct B. Verifier passed that updated BTF ID to
> fancy_helper's check, it still says no. Again, don't give up,
> btf_struct_access again, but now register assumes it starts in struct
> B. It finds field c of type struct C, so returns successfully. Again,
> we are checking with fancy_helper's check_btf_id() check, now it
> succeeds, so we keep register's BTF_ID as struct C and carry on.
> 
> Now assume fancy_helper only accepts struct D. So once we pass struct
> C, it rejects. Again, btf_struct_access() is called, this time find
> field x, which is int (and thus register is SCALAR now).
> check_btf_id() rejects it, we call btf_struct_access() again, but this
> time we can't really go deeper into type int, so we give up at this
> point and return error.
> 
> Now, when register's offset is non-zero, the process is exactly the
> same, we just need to keep locally adjusted offset, so that when we
> find inner struct, we start with the offset within that struct, not
> origin struct A's offset.
> 
> It's quite verbose explanation, but hopefully you get the idea. I
> think implementation shouldn't be too hard, we might need to extend
> register's state to have this extra local offset to get to the start
> of a type we believe register points to (something like inner_offset,
> or something). Then btf_struct_access can take into account both
> register's off and inner_off to maintain this offset to inner type.
> 
> It should nicely work in all cases, not just partially as it is right now. WDYT?

I think above should work nicely for my case, but we need
to keep the current btf_struct_access usage, which is to
check if we point to a pointer type and return the ID it
points to 

I think it's doable with the functionality you described,
we'll just check of the returned type is pointer and get
the ID it points to.. which makes me think we still need
functions like below (again bad names probably ;-) )

  btf_struct_walk
    - implements the walk through the type as you described
      above.. returns the type we point to and we can call
      it again to resolve the next type at the same offset

  btf_struct_address
    - calls btf_struct_walk and checks if the returned type ID
      matches the requested BTF ID of the helper argument if not
      and the returned type is struct, call btf_struct_walk again
      to get the next layer and repeat..

  btf_struct_access
    - calls btf_struct_walk repeatedly until the returned type is
      a pointer and then it returns the BTF ID it points to

thanks,
jirka

