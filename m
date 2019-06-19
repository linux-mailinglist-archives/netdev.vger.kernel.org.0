Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BC64C33E
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfFSVpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:45:33 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42907 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfFSVpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 17:45:32 -0400
Received: by mail-qt1-f195.google.com with SMTP id s15so875263qtk.9;
        Wed, 19 Jun 2019 14:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U0KKo1iM2qIRuspQZlPaLXTnOkB8zW1DJbMrcSFDewA=;
        b=AZ1oiNMtCkrWEm8hKutOf2WkDWYoiRzPTIMHCFmiG81NWP+Iee75VAMKaur7pZqmgw
         GYaOOAuitYsbYwFLBA9/XWO95+cMdNoLD/S/h/P2ph1LT7GoKKyjc77H6B27FCCxOSeA
         SmVvmcNEHvJydnrGeWoZfVE+4iUg7Nf0HNwZDuOeGUp9Kgr7plzJJeBAZ2gFYaQfOJE+
         XhTtmG2NXejzoTkUMyUIkovy7j20H0nCSzeQu6NiSPH5F0wav5h31uwmjwFv5BvWCsYU
         0+yPKLYlwTxRzq9OJGXVmhmQzQhOgL6KlugddE+ebAXyv7d2QjBqF8iiukzIhWZEo9vZ
         ksqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U0KKo1iM2qIRuspQZlPaLXTnOkB8zW1DJbMrcSFDewA=;
        b=tqTM+rXiqybnnxcnrr08Gef8iOesDFxQyDIOCwq6jGQlIPEx7R4HrnILhoaa7w4AyK
         oA2TcRkkDkxMqL/xQ6hvcRhKsSls3AowTVJQIKPFZ9rHBNmBV9bT/j52lY0m6DF3/gLF
         KN3PC8LxuL3xC9pTlXEsSscBYGMf0A1FPirINJgMRT/lBM3NrYIASzFJ3dTnsNc3NTch
         E+SqODq75OcNOkFbnFFcblMj3UFs1Ul/dfKvroqlGLFuYsJby6J/OixehmX8FoOFEzoi
         f1A45uvTveNzy89NnxOpQqTAejOvdtHptsUc+KGg34jxGOBHvlAmcEHjrm6o0boleOQa
         BdbQ==
X-Gm-Message-State: APjAAAU3dgCg6ikKIMKyWKDNKG9Md6GXsSUiizwL3GioMv3Jg6ja8fWi
        NWLJsNo419fw06OX3/+SwxmCMyuv/oJG8hZm60pWJz+L09k=
X-Google-Smtp-Source: APXvYqzQwjTvapcK9dmGHZdNxmXOFHnkeHytzsKW+iMOrdmqrPjHhSj9wdkuyAUQV6Wo8VgyBxjPe0KZv9Z3xmjwNbQ=
X-Received: by 2002:a0c:ae50:: with SMTP id z16mr34794509qvc.60.1560980731337;
 Wed, 19 Jun 2019 14:45:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190619165957.235580-1-sdf@google.com> <20190619165957.235580-2-sdf@google.com>
 <CAEf4BzZWJVWr295-6TY=pbTNoeB9cfRwpDiuRyAxajOsV_6yDQ@mail.gmail.com> <20190619201710.GB19111@mini-arch>
In-Reply-To: <20190619201710.GB19111@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Jun 2019 14:45:20 -0700
Message-ID: <CAEf4BzbTfCG3Mk9=78=Kh5u4ofxdYePm=xVEcN8g38cXQ_gq6Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 1/9] bpf: implement getsockopt and setsockopt hooks
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 1:17 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/19, Andrii Nakryiko wrote:
> > On Wed, Jun 19, 2019 at 10:00 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> > > BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> > >
> > > BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> > > BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> > > Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
> > >
> > > The buffer memory is pre-allocated (because I don't think there is
> > > a precedent for working with __user memory from bpf). This might be
> > > slow to do for each {s,g}etsockopt call, that's why I've added
> > > __cgroup_bpf_prog_array_is_empty that exits early if there is nothing
> > > attached to a cgroup. Note, however, that there is a race between
> > > __cgroup_bpf_prog_array_is_empty and BPF_PROG_RUN_ARRAY where cgroup
> > > program layout might have changed; this should not be a problem
> > > because in general there is a race between multiple calls to
> > > {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
> > >
> > > The return code of the BPF program is handled as follows:
> > > * 0: EPERM
> > > * 1: success, continue with next BPF program in the cgroup chain
> > >
> > > v7:
> > > * return only 0 or 1 (Alexei Starovoitov)
> > > * always run all progs (Alexei Starovoitov)
> > > * use optval=0 as kernel bypass in setsockopt (Alexei Starovoitov)
> > >   (decided to use optval=-1 instead, optval=0 might be a valid input)
> > > * call getsockopt hook after kernel handlers (Alexei Starovoitov)
> > >
> > > v6:
> > > * rework cgroup chaining; stop as soon as bpf program returns
> > >   0 or 2; see patch with the documentation for the details
> > > * drop Andrii's and Martin's Acked-by (not sure they are comfortable
> > >   with the new state of things)
> >
> > I like the general approach, just overall unclear about seemingly
> > artificial restrictions I mentioned below.
> >
> > >
> > > v5:
> > > * skip copy_to_user() and put_user() when ret == 0 (Martin Lau)
> > >
> > > v4:
> > > * don't export bpf_sk_fullsock helper (Martin Lau)
> > > * size != sizeof(__u64) for uapi pointers (Martin Lau)
> > > * offsetof instead of bpf_ctx_range when checking ctx access (Martin Lau)
> > >
> > > v3:
> > > * typos in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY comments (Andrii Nakryiko)
> > > * reverse christmas tree in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY (Andrii
> > >   Nakryiko)
> > > * use __bpf_md_ptr instead of __u32 for optval{,_end} (Martin Lau)
> > > * use BPF_FIELD_SIZEOF() for consistency (Martin Lau)
> > > * new CG_SOCKOPT_ACCESS macro to wrap repeated parts
> > >
> > > v2:
> > > * moved bpf_sockopt_kern fields around to remove a hole (Martin Lau)
> > > * aligned bpf_sockopt_kern->buf to 8 bytes (Martin Lau)
> > > * bpf_prog_array_is_empty instead of bpf_prog_array_length (Martin Lau)
> > > * added [0,2] return code check to verifier (Martin Lau)
> > > * dropped unused buf[64] from the stack (Martin Lau)
> > > * use PTR_TO_SOCKET for bpf_sockopt->sk (Martin Lau)
> > > * dropped bpf_target_off from ctx rewrites (Martin Lau)
> > > * use return code for kernel bypass (Martin Lau & Andrii Nakryiko)
> > >
> > > Cc: Martin Lau <kafai@fb.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> >
> > <snip>
> >
> > >
> > > +struct bpf_sockopt_kern {
> > > +       struct sock     *sk;
> > > +       u8              *optval;
> > > +       u8              *optval_end;
> > > +       s32             level;
> > > +       s32             optname;
> > > +       u32             optlen;
> >
> > Optlen is used below as signed integer, so switch it to s32?
> Good catch, should be s32 here and below, thanks!
>
> > > +       s32             retval;
> > > +
> > > +       /* Small on-stack optval buffer to avoid small allocations.
> > > +        */
> > > +       u8 buf[64] __aligned(8);
> > > +};
> > > +
> >
> > <snip>
> >
> > >
> > > +struct bpf_sockopt {
> > > +       __bpf_md_ptr(struct bpf_sock *, sk);
> > > +       __bpf_md_ptr(void *, optval);
> > > +       __bpf_md_ptr(void *, optval_end);
> > > +
> > > +       __s32   level;
> > > +       __s32   optname;
> > > +       __u32   optlen;
> >
> > Same as above, we expect BPF program to be able to set it to -1, so __s32?
> >
> > > +       __s32   retval;
> > > +};
> > > +
> > >  #endif /* _UAPI__LINUX_BPF_H__ */
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> >
> > <snip>
> >
> > > +
> > > +       if (ctx.optlen == -1)
> > > +               /* optlen set to -1, bypass kernel */
> > > +               ret = 1;
> > > +       else if (ctx.optlen == optlen)
> > > +               /* optlen not changed, run kernel handler */
> > > +               ret = 0;
> > > +       else
> > > +               /* any other value is rejected */
> > > +               ret = -EFAULT;
> >
> > I'm consufed about this assymetry between getsockopt and setsockopt
> > behavior. Why we are disallowing setsockopt from changing optlen (and
> > value itself)? Is there any harm in allowing that? Imagining some use
> > case that provides transparent "support" for some option, you'd need
> > to be able to intercept and provide custom values both for setsockopt
> > and getsockopt. So unless I'm missing some security implications, why
> > not make both sides able to write?
> Because kernel setsockopt handlers use get_user to read the data. We
> can definitely allow changing optval+optlen, but we'd have to copy
> that data back to userspace to let kernel handle it. I'm not sure how
> userspace might feel about it. Can it be a buffer in the readonly
> elf section?

Ah, ok, now I see why :) Yeah, I guess it can be in read-only section.
Alright, I don't see an easy solution to that, I guess we can live
with that for now.

>
> > Similar will apply w.r.t. retval, why can't setsockopt return EINVAL
> > to reject some options? This seems very useful and very similar to
> > what sysctl BPF hooks do.
> I was just being defensive because I'm not sure what's the use-case.
> We can already return EPERM, why do we need to return a different
> error code? Are we comfortable letting progs return arbitrary number?
> Or you just want to allow a bunch of pre-defined error codes?
>
> I haven't seen the ability to return arbitrary error from the sysctl
> hooks, but maybe I didn't look hard enough.

Yeah, seems like sysctl is only 0 or EPERM. I missed for a moment that
there is return value from BPF program and retval from the context. I
think it's good enough as is.

>
> > > +
> > > +out:
> > > +       sockopt_free_buf(&ctx);
> > > +       return ret;
> > > +}
> > > +EXPORT_SYMBOL(__cgroup_bpf_run_filter_setsockopt);
> > > +
> > > +int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
> > > +                                      int optname, char __user *optval,
> > > +                                      int __user *optlen, int max_optlen,
> > > +                                      int retval)
> > > +{
> >
> > <snip>
> >
> > > +
> > > +       if (ctx.optlen > max_optlen) {
> > > +               ret = -EFAULT;
> > > +               goto out;
> > > +       }
> > > +
> > > +       /* BPF programs only allowed to set retval to 0, not some
> > > +        * arbitrary value.
> > > +        */
> > > +       if (ctx.retval != 0 && ctx.retval != retval) {
> >
> > Lookin at manpage of getsockopt, seems like at least two error codes
> > are relevant and generally useful for BPF program to be able to
> > return: EINVAL and ENOPROTOOPT? Why we are disallowing anything but 0
> > (or preserving original retval)?
> I was thinking about simple use-case where it's either BPF that
> handles the opt or the kernel. And then it's BFP returning success or
> EPERM. I don't think I understand why BPF needs to be able to
> return different error codes. We can certainly do that if you think
> that it makes sense; alternatively, we can start with 0 or kernel retval
> and relax the requirements if someone really needs that in the future.
>
> (I don't have a strong opinion here tbh).

As replied above, EPERM is probably good enough for practical
purposes, I was being a bit pedantic :)

>
> > > +               ret = -EFAULT;
> > > +               goto out;
> > > +       }
> > > +
> > > +       if (copy_to_user(optval, ctx.optval, ctx.optlen) ||
> > > +           put_user(ctx.optlen, optlen)) {
> > > +               ret = -EFAULT;
> > > +               goto out;
> > > +       }
> > > +
> > > +       ret = ctx.retval;
> > > +
> > > +out:
> > > +       sockopt_free_buf(&ctx);
> > > +       return ret;
> > > +}
> > > +EXPORT_SYMBOL(__cgroup_bpf_run_filter_getsockopt);
> > > +
> >
> > <snip>
