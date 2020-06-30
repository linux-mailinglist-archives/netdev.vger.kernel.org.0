Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E5120F668
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731518AbgF3Nzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:55:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60192 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727796AbgF3Nzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:55:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593525337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oua9djGTVgruEnJiWoMKHY+ClWCYhuYwu/zgOvxdE70=;
        b=HAeyXUxH2zffbGvJOJzySVjXxclAJh0iTmNFYCVdFYpfnzm9P7edw+bfRXZHIL9dnVoGnK
        wvUeR1Dns1g15geddnfjbtxZ2Mk+t50z4kDElaliRJGZO8WRia8OZXOEcrOQ3Dwosg3miE
        8qDz4FcNd20oFU/W4P2qLcQRCeHTQSg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-tIqZfSkhPWmg-FRGzWqsPw-1; Tue, 30 Jun 2020 09:55:31 -0400
X-MC-Unique: tIqZfSkhPWmg-FRGzWqsPw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE5818C0302;
        Tue, 30 Jun 2020 13:54:55 +0000 (UTC)
Received: from krava (unknown [10.40.192.137])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7037673FEA;
        Tue, 30 Jun 2020 13:54:50 +0000 (UTC)
Date:   Tue, 30 Jun 2020 15:54:49 +0200
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
Message-ID: <20200630135449.GA3071036@krava>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-8-jolsa@kernel.org>
 <CAEf4Bzb+Oey2pQMJvBpRR6dVqFDeV+OtyQVoCvk-1rmvb6XYPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb+Oey2pQMJvBpRR6dVqFDeV+OtyQVoCvk-1rmvb6XYPA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 06:52:21PM -0700, Andrii Nakryiko wrote:
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
> 
> This logic is very hard to follow. Each type I try to review it, I get
> lost very fast. TBH, this access_data struct is not just not helpful,
> but actually just complicates everything.

yea, it's one of the reasons I added extra function for that in first version

> 
> I'll get to this tomorrow morning with fresh brains and will try to do
> another pass.
> 
> [...]
> 
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
> 
> 
> This non-zero offset only logic looks fishy, tbh. What if the struct
> you are trying to access is at offset zero? E.g., bpf_link is pretty
> much always a first field of whatever specific link struct it is
> contained within. The fact that we allow only non-zero offsets for
> such use case looks like an arbitrary limitation.

right, that's mistake, I was after path under struct file,
and did not realize this needs to be generic

thanks,
jirka

> 
> > +                       btf_type = btf_type_by_id(btf_vmlinux, reg->btf_id);
> > +                       if (btf_struct_address(&env->log, btf_type, reg->off, meta->btf_id)) {
> > +                               verbose(env, "Helper has type %s got %s in R%d, off %d\n",
> >                                         kernel_type_name(meta->btf_id),
> > +                                       kernel_type_name(reg->btf_id), regno, reg->off);
> > +                               return -EACCES;
> > +                       }
> 
> [...]
> 

