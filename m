Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3AC8129BB8
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 00:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLWXFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 18:05:21 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43045 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfLWXFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 18:05:21 -0500
Received: by mail-qt1-f193.google.com with SMTP id d18so13960630qtj.10;
        Mon, 23 Dec 2019 15:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mqig9b83gxfcXIMXK/a+UH1YQaFrRLRBEAu5SztV+e8=;
        b=sdeGOIqd5gKReVHdtiazD+MT3E4s1di+nU4iEQM+eUFcwbv2o96SLX0ZuCMcUJndNn
         Xxk4wo3DcUBm9HNKZRfvNpmTMKaDNNtS307sNQG6rcE9jrLXA22HX7j4DKVpBcJYMbmW
         Exuaj2OfPrt6ymeI9ZexT05lVJPPHxSORT93CVnIw9hivWo08VLzKghRoyYbcj9Qieg3
         IvL6VCT8nMlvwONa5UPiPgIVlTIUodLJEZpv0bNl2ixroBzkn9O5V47ipCxvnNfjNxYR
         J9nXidMflMwOXJYT5juDc+vw9Z8DO1/ZS3nSpYGabZrs/ONPc3Ykf26Hac2ok3zyTVRp
         TOMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mqig9b83gxfcXIMXK/a+UH1YQaFrRLRBEAu5SztV+e8=;
        b=Ol6wbWYNrGs6kYA3U1U4+EfhzkgDphk8NDe39ixiFrNzRJuD8d2lDw1OvFIE92TfXw
         tuGuCpHasotjiABEtQtwNtdxCxuOwIwNElW3SNusVu7Sg3kAnlvGWt/dJFW/clAikRbZ
         ivyv+P0IUsOjkfVHrx1DNzA53La11MpoV6z5RklyHqPuDA12qSJbZ+Fao8uwv80vFNV9
         +r+p5mvVv4fM26wYsN0Jb6unhVIQb68gZVXg/6lEJR3BzwPeibvXzADQ5rmZ/pUiH8qQ
         ynL8gWiGISq6k69QF4s8C8495gGt6Vvt1It90VWH+mLPnq9N6Gzm1guQHkEzZpLblcnR
         Y7Jg==
X-Gm-Message-State: APjAAAWTPk7mR1F/t1k7IphxXFlHD64wzylekN1Zr5q5PDQDIxyinMwM
        cr9GQXHFEhiGCyOHkz4s/NSN2yTJWMQ6rGtCrCI=
X-Google-Smtp-Source: APXvYqyuKExO8yQkzYEW4CwRIhcAGYvV0y3mRdBj8lk1lUoFL4QpEKj4A+fFD0snL9vGnmS71733zc+SqjzCIkZkZsM=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr24285560qtl.171.1577142319848;
 Mon, 23 Dec 2019 15:05:19 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062608.1183091-1-kafai@fb.com>
In-Reply-To: <20191221062608.1183091-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Dec 2019 15:05:08 -0800
Message-ID: <CAEf4BzZ0fb5ecoCJTt+7j2rxoP3QnVBivHjg8GDLofR4sLFU7w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The patch introduces BPF_MAP_TYPE_STRUCT_OPS.  The map value
> is a kernel struct with its func ptr implemented in bpf prog.
> This new map is the interface to register/unregister/introspect
> a bpf implemented kernel struct.
>
> The kernel struct is actually embedded inside another new struct
> (or called the "value" struct in the code).  For example,
> "struct tcp_congestion_ops" is embbeded in:
> struct bpf_struct_ops_tcp_congestion_ops {
>         refcount_t refcnt;
>         enum bpf_struct_ops_state state;
>         struct tcp_congestion_ops data;  /* <-- kernel subsystem struct here */
> }
> The map value is "struct bpf_struct_ops_tcp_congestion_ops".
> The "bpftool map dump" will then be able to show the
> state ("inuse"/"tobefree") and the number of subsystem's refcnt (e.g.
> number of tcp_sock in the tcp_congestion_ops case).  This "value" struct
> is created automatically by a macro.  Having a separate "value" struct
> will also make extending "struct bpf_struct_ops_XYZ" easier (e.g. adding
> "void (*init)(void)" to "struct bpf_struct_ops_XYZ" to do some
> initialization works before registering the struct_ops to the kernel
> subsystem).  The libbpf will take care of finding and populating the
> "struct bpf_struct_ops_XYZ" from "struct XYZ".
>
> Register a struct_ops to a kernel subsystem:
> 1. Load all needed BPF_PROG_TYPE_STRUCT_OPS prog(s)
> 2. Create a BPF_MAP_TYPE_STRUCT_OPS with attr->btf_vmlinux_value_type_id
>    set to the btf id "struct bpf_struct_ops_tcp_congestion_ops" of the
>    running kernel.
>    Instead of reusing the attr->btf_value_type_id,
>    btf_vmlinux_value_type_id s added such that attr->btf_fd can still be
>    used as the "user" btf which could store other useful sysadmin/debug
>    info that may be introduced in the furture,
>    e.g. creation-date/compiler-details/map-creator...etc.
> 3. Create a "struct bpf_struct_ops_tcp_congestion_ops" object as described
>    in the running kernel btf.  Populate the value of this object.
>    The function ptr should be populated with the prog fds.
> 4. Call BPF_MAP_UPDATE with the object created in (3) as
>    the map value.  The key is always "0".
>
> During BPF_MAP_UPDATE, the code that saves the kernel-func-ptr's
> args as an array of u64 is generated.  BPF_MAP_UPDATE also allows
> the specific struct_ops to do some final checks in "st_ops->init_member()"
> (e.g. ensure all mandatory func ptrs are implemented).
> If everything looks good, it will register this kernel struct
> to the kernel subsystem.  The map will not allow further update
> from this point.
>
> Unregister a struct_ops from the kernel subsystem:
> BPF_MAP_DELETE with key "0".
>
> Introspect a struct_ops:
> BPF_MAP_LOOKUP_ELEM with key "0".  The map value returned will
> have the prog _id_ populated as the func ptr.
>
> The map value state (enum bpf_struct_ops_state) will transit from:
> INIT (map created) =>
> INUSE (map updated, i.e. reg) =>
> TOBEFREE (map value deleted, i.e. unreg)
>
> The kernel subsystem needs to call bpf_struct_ops_get() and
> bpf_struct_ops_put() to manage the "refcnt" in the
> "struct bpf_struct_ops_XYZ".  This patch uses a separate refcnt
> for the purose of tracking the subsystem usage.  Another approach
> is to reuse the map->refcnt and then "show" (i.e. during map_lookup)
> the subsystem's usage by doing map->refcnt - map->usercnt to filter out
> the map-fd/pinned-map usage.  However, that will also tie down the
> future semantics of map->refcnt and map->usercnt.
>
> The very first subsystem's refcnt (during reg()) holds one
> count to map->refcnt.  When the very last subsystem's refcnt
> is gone, it will also release the map->refcnt.  All bpf_prog will be
> freed when the map->refcnt reaches 0 (i.e. during map_free()).
>
> Here is how the bpftool map command will look like:
> [root@arch-fb-vm1 bpf]# bpftool map show
> 6: struct_ops  name dctcp  flags 0x0
>         key 4B  value 256B  max_entries 1  memlock 4096B
>         btf_id 6
> [root@arch-fb-vm1 bpf]# bpftool map dump id 6
> [{
>         "value": {
>             "refcnt": {
>                 "refs": {
>                     "counter": 1
>                 }
>             },
>             "state": 1,
>             "data": {
>                 "list": {
>                     "next": 0,
>                     "prev": 0
>                 },
>                 "key": 0,
>                 "flags": 2,
>                 "init": 24,
>                 "release": 0,
>                 "ssthresh": 25,
>                 "cong_avoid": 30,
>                 "set_state": 27,
>                 "cwnd_event": 28,
>                 "in_ack_event": 26,
>                 "undo_cwnd": 29,
>                 "pkts_acked": 0,
>                 "min_tso_segs": 0,
>                 "sndbuf_expand": 0,
>                 "cong_control": 0,
>                 "get_info": 0,
>                 "name": [98,112,102,95,100,99,116,99,112,0,0,0,0,0,0,0
>                 ],
>                 "owner": 0
>             }
>         }
>     }
> ]
>
> Misc Notes:
> * bpf_struct_ops_map_sys_lookup_elem() is added for syscall lookup.
>   It does an inplace update on "*value" instead returning a pointer
>   to syscall.c.  Otherwise, it needs a separate copy of "zero" value
>   for the BPF_STRUCT_OPS_STATE_INIT to avoid races.
>
> * The bpf_struct_ops_map_delete_elem() is also called without
>   preempt_disable() from map_delete_elem().  It is because
>   the "->unreg()" may requires sleepable context, e.g.
>   the "tcp_unregister_congestion_control()".
>
> * "const" is added to some of the existing "struct btf_func_model *"
>   function arg to avoid a compiler warning caused by this patch.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

LGTM! Few questions below to improve my understanding.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  arch/x86/net/bpf_jit_comp.c |  11 +-
>  include/linux/bpf.h         |  49 +++-
>  include/linux/bpf_types.h   |   3 +
>  include/linux/btf.h         |  13 +
>  include/uapi/linux/bpf.h    |   7 +-
>  kernel/bpf/bpf_struct_ops.c | 468 +++++++++++++++++++++++++++++++++++-
>  kernel/bpf/btf.c            |  20 +-
>  kernel/bpf/map_in_map.c     |   3 +-
>  kernel/bpf/syscall.c        |  49 ++--
>  kernel/bpf/trampoline.c     |   5 +-
>  kernel/bpf/verifier.c       |   5 +
>  11 files changed, 593 insertions(+), 40 deletions(-)
>

[...]

> +               /* All non func ptr member must be 0 */
> +               if (!btf_type_resolve_func_ptr(btf_vmlinux, member->type,
> +                                              NULL)) {
> +                       u32 msize;
> +
> +                       mtype = btf_resolve_size(btf_vmlinux, mtype,
> +                                                &msize, NULL, NULL);
> +                       if (IS_ERR(mtype)) {
> +                               err = PTR_ERR(mtype);
> +                               goto reset_unlock;
> +                       }
> +
> +                       if (memchr_inv(udata + moff, 0, msize)) {


just double-checking: we are ok with having non-zeroed padding in a
struct, is that right?

> +                               err = -EINVAL;
> +                               goto reset_unlock;
> +                       }
> +
> +                       continue;
> +               }
> +

[...]

> +
> +               err = arch_prepare_bpf_trampoline(image,
> +                                                 &st_ops->func_models[i], 0,
> +                                                 &prog, 1, NULL, 0, NULL);
> +               if (err < 0)
> +                       goto reset_unlock;
> +
> +               *(void **)(kdata + moff) = image;
> +               image += err;

are there any alignment requirements on image pointer for trampoline?

> +
> +               /* put prog_id to udata */
> +               *(unsigned long *)(udata + moff) = prog->aux->id;
> +       }
> +

[...]
