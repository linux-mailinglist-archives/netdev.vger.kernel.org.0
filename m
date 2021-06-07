Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DD239E69F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhFGS1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:27:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230289AbhFGS1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 14:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623090362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tu+PqQa7T7qbt8q1gmyJ3NwZg1GhwJq83MnVkJprCxk=;
        b=eZFYJ41xru+CY5AfcVwjWzJpUheaJmCr4VlzIvnhDvjFtQdp+DAgm0QmU0cQLYRCb1nBeX
        tWCTaBufHnScNl+gmM+5uGmAAmKMdDhQzxFBnCjrfBirte+QIDJ/G9L1Z7A5/k9CFn3AVL
        RVCBfK+u4c4NbS163keCSgDSsN+94ZI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-E4OlIHCiOFqiMDpB8-VVig-1; Mon, 07 Jun 2021 14:25:58 -0400
X-MC-Unique: E4OlIHCiOFqiMDpB8-VVig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32BFC1854E26;
        Mon,  7 Jun 2021 18:25:57 +0000 (UTC)
Received: from krava (unknown [10.40.192.167])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7CF491037F22;
        Mon,  7 Jun 2021 18:25:54 +0000 (UTC)
Date:   Mon, 7 Jun 2021 20:25:53 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 13/19] bpf: Add support to link multi func tracing program
Message-ID: <YL5ksRAvQEW+0csh@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-14-jolsa@kernel.org>
 <de10c18b-5861-911e-ace8-eb599b72b0a8@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de10c18b-5861-911e-ace8-eb599b72b0a8@fb.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 06, 2021 at 10:36:57PM -0700, Yonghong Song wrote:
> 
> 
> On 6/5/21 4:10 AM, Jiri Olsa wrote:
> > Adding support to attach multiple functions to tracing program
> > by using the link_create/link_update interface.
> > 
> > Adding multi_btf_ids/multi_btf_ids_cnt pair to link_create struct
> > API, that define array of functions btf ids that will be attached
> > to prog_fd.
> > 
> > The prog_fd needs to be multi prog tracing program (BPF_F_MULTI_FUNC).
> > 
> > The new link_create interface creates new BPF_LINK_TYPE_TRACING_MULTI
> > link type, which creates separate bpf_trampoline and registers it
> > as direct function for all specified btf ids.
> > 
> > The new bpf_trampoline is out of scope (bpf_trampoline_lookup) of
> > standard trampolines, so all registered functions need to be free
> > of direct functions, otherwise the link fails.
> 
> I am not sure how severe such a limitation could be in practice.
> It is possible in production some non-multi fentry/fexit program
> may run continuously. Does kprobe program impact this as well?

I did not find a way how to combine current trampolines with the
new ones for multiple programs.. what you described is a limitation
of the current approach

I'm not sure about kprobes and trampolines, but the limitation
should be same as we do have for current trampolines.. I'll check

> 
> > 
> > The new bpf_trampoline will store and pass to bpf program the highest
> > number of arguments from all given functions.
> > 
> > New programs (fentry or fexit) can be added to the existing trampoline
> > through the link_update interface via new_prog_fd descriptor.
> 
> Looks we do not support replacing old programs. Do we support
> removing old programs?

we don't.. it's not what bpftrace would do, it just adds programs
to trace and close all when it's done.. I think interface for removal
could be added if you think it's needed

> 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   include/linux/bpf.h            |   3 +
> >   include/uapi/linux/bpf.h       |   5 +
> >   kernel/bpf/syscall.c           | 185 ++++++++++++++++++++++++++++++++-
> >   kernel/bpf/trampoline.c        |  53 +++++++---
> >   tools/include/uapi/linux/bpf.h |   5 +
> >   5 files changed, 237 insertions(+), 14 deletions(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 23221e0e8d3c..99a81c6c22e6 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -661,6 +661,7 @@ struct bpf_trampoline {
> >   	struct bpf_tramp_image *cur_image;
> >   	u64 selector;
> >   	struct module *mod;
> > +	bool multi;
> >   };
> >   struct bpf_attach_target_info {
> > @@ -746,6 +747,8 @@ void bpf_ksym_add(struct bpf_ksym *ksym);
> >   void bpf_ksym_del(struct bpf_ksym *ksym);
> >   int bpf_jit_charge_modmem(u32 pages);
> >   void bpf_jit_uncharge_modmem(u32 pages);
> > +struct bpf_trampoline *bpf_trampoline_multi_alloc(void);
> > +void bpf_trampoline_multi_free(struct bpf_trampoline *tr);
> >   #else
> >   static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
> >   					   struct bpf_trampoline *tr)
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index ad9340fb14d4..5fd6ff64e8dc 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1007,6 +1007,7 @@ enum bpf_link_type {
> >   	BPF_LINK_TYPE_ITER = 4,
> >   	BPF_LINK_TYPE_NETNS = 5,
> >   	BPF_LINK_TYPE_XDP = 6,
> > +	BPF_LINK_TYPE_TRACING_MULTI = 7,
> >   	MAX_BPF_LINK_TYPE,
> >   };
> > @@ -1454,6 +1455,10 @@ union bpf_attr {
> >   				__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
> >   				__u32		iter_info_len;	/* iter_info length */
> >   			};
> > +			struct {
> > +				__aligned_u64	multi_btf_ids;		/* addresses to attach */
> > +				__u32		multi_btf_ids_cnt;	/* addresses count */
> > +			};
> >   		};
> >   	} link_create;
> [...]
> > +static int bpf_tracing_multi_link_fill_link_info(const struct bpf_link *link,
> > +						 struct bpf_link_info *info)
> > +{
> > +	struct bpf_tracing_multi_link *tr_link =
> > +		container_of(link, struct bpf_tracing_multi_link, link);
> > +
> > +	info->tracing.attach_type = tr_link->attach_type;
> > +	return 0;
> > +}
> > +
> > +static int check_multi_prog_type(struct bpf_prog *prog)
> > +{
> > +	if (!prog->aux->multi_func &&
> > +	    prog->type != BPF_PROG_TYPE_TRACING)
> 
> I think prog->type != BPF_PROG_TYPE_TRACING is not needed, it should have
> been checked during program load time?
> 
> > +		return -EINVAL;
> > +	if (prog->expected_attach_type != BPF_TRACE_FENTRY &&
> > +	    prog->expected_attach_type != BPF_TRACE_FEXIT)
> > +		return -EINVAL;
> > +	return 0;
> > +}
> > +
> > +static int bpf_tracing_multi_link_update(struct bpf_link *link,
> > +					 struct bpf_prog *new_prog,
> > +					 struct bpf_prog *old_prog __maybe_unused)
> > +{
> > +	struct bpf_tracing_multi_link *tr_link =
> > +		container_of(link, struct bpf_tracing_multi_link, link);
> > +	int err;
> > +
> > +	if (check_multi_prog_type(new_prog))
> > +		return -EINVAL;
> > +
> > +	err = bpf_trampoline_link_prog(new_prog, tr_link->tr);
> > +	if (err)
> > +		return err;
> > +
> > +	err = modify_ftrace_direct_multi(&tr_link->ops,
> > +					 (unsigned long) tr_link->tr->cur_image->image);
> > +	return WARN_ON(err);
> 
> Why WARN_ON here? Some comments will be good.
> 
> > +}
> > +
> > +static const struct bpf_link_ops bpf_tracing_multi_link_lops = {
> > +	.release = bpf_tracing_multi_link_release,
> > +	.dealloc = bpf_tracing_multi_link_dealloc,
> > +	.show_fdinfo = bpf_tracing_multi_link_show_fdinfo,
> > +	.fill_link_info = bpf_tracing_multi_link_fill_link_info,
> > +	.update_prog = bpf_tracing_multi_link_update,
> > +};
> > +
> [...]
> > +
> >   struct bpf_raw_tp_link {
> >   	struct bpf_link link;
> >   	struct bpf_raw_event_map *btp;
> > @@ -3043,6 +3222,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
> >   	case BPF_CGROUP_SETSOCKOPT:
> >   		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
> >   	case BPF_TRACE_ITER:
> > +	case BPF_TRACE_FENTRY:
> > +	case BPF_TRACE_FEXIT:
> >   		return BPF_PROG_TYPE_TRACING;
> >   	case BPF_SK_LOOKUP:
> >   		return BPF_PROG_TYPE_SK_LOOKUP;
> > @@ -4099,6 +4280,8 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
> >   	if (prog->expected_attach_type == BPF_TRACE_ITER)
> >   		return bpf_iter_link_attach(attr, uattr, prog);
> > +	else if (prog->aux->multi_func)
> > +		return bpf_tracing_multi_attach(prog, attr);
> >   	else if (prog->type == BPF_PROG_TYPE_EXT)
> >   		return bpf_tracing_prog_attach(prog,
> >   					       attr->link_create.target_fd,
> > @@ -4106,7 +4289,7 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
> >   	return -EINVAL;
> >   }
> > -#define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
> > +#define BPF_LINK_CREATE_LAST_FIELD link_create.multi_btf_ids_cnt
> 
> It is okay that we don't change this. link_create.iter_info_len
> has the same effect since it is a union.
> 
> >   static int link_create(union bpf_attr *attr, bpfptr_t uattr)
> >   {
> >   	enum bpf_prog_type ptype;
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 2755fdcf9fbf..660b8197c27f 100644
> > --- a/kernel/bpf/trampoline.c
> > +++ b/kernel/bpf/trampoline.c
> > @@ -58,7 +58,7 @@ void bpf_image_ksym_del(struct bpf_ksym *ksym)
> >   			   PAGE_SIZE, true, ksym->name);
> >   }
> > -static struct bpf_trampoline *bpf_trampoline_alloc(void)
> > +static struct bpf_trampoline *bpf_trampoline_alloc(bool multi)
> >   {
> >   	struct bpf_trampoline *tr;
> >   	int i;
> > @@ -72,6 +72,7 @@ static struct bpf_trampoline *bpf_trampoline_alloc(void)
> >   	mutex_init(&tr->mutex);
> >   	for (i = 0; i < BPF_TRAMP_MAX; i++)
> >   		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
> > +	tr->multi = multi;
> >   	return tr;
> >   }
> > @@ -88,7 +89,7 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> >   			goto out;
> >   		}
> >   	}
> > -	tr = bpf_trampoline_alloc();
> > +	tr = bpf_trampoline_alloc(false);
> >   	if (tr) {
> >   		tr->key = key;
> >   		hlist_add_head(&tr->hlist, head);
> > @@ -343,14 +344,16 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
> >   	struct bpf_tramp_image *im;
> >   	struct bpf_tramp_progs *tprogs;
> >   	u32 flags = BPF_TRAMP_F_RESTORE_REGS;
> > -	int err, total;
> > +	bool update = !tr->multi;
> > +	int err = 0, total;
> >   	tprogs = bpf_trampoline_get_progs(tr, &total);
> >   	if (IS_ERR(tprogs))
> >   		return PTR_ERR(tprogs);
> >   	if (total == 0) {
> > -		err = unregister_fentry(tr, tr->cur_image->image);
> > +		if (update)
> > +			err = unregister_fentry(tr, tr->cur_image->image);
> >   		bpf_tramp_image_put(tr->cur_image);
> >   		tr->cur_image = NULL;
> >   		tr->selector = 0;
> > @@ -363,9 +366,15 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
> >   		goto out;
> >   	}
> > +	if (tr->multi)
> > +		flags |= BPF_TRAMP_F_IP_ARG;
> > +
> >   	if (tprogs[BPF_TRAMP_FEXIT].nr_progs ||
> > -	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
> > +	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs) {
> >   		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
> > +		if (tr->multi)
> > +			flags |= BPF_TRAMP_F_ORIG_STACK | BPF_TRAMP_F_IP_ARG;
> 
> BPF_TRAMP_F_IP_ARG is not needed. It has been added before.

it's erased in 2 lines above.. which reminds me that I forgot to check
if that's a bug or intended ;-)

jirka

