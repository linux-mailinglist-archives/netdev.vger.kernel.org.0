Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EDD4C189
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 21:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfFSTcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 15:32:10 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42772 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFSTcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 15:32:10 -0400
Received: by mail-qt1-f194.google.com with SMTP id s15so402166qtk.9;
        Wed, 19 Jun 2019 12:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zyJzdLsY8xAV6bH7hXf7FjfS9orAgIpi2/QOQ0CDNS8=;
        b=PQSTn6gXTF0n4SK/6zuhuo1826iYgI43shNugp3NjzRLCefX4BS2srK9qz9sk7JVh5
         t5JMXaafhR7sjOscia/OLM5BlOoVeL0iKCPSuDcjeBMaKBtyzjjjgIXtCxxlW1BAZmXr
         jwqSiLJEyfpoJ7w8Jy0SJn/eQwqH/z/sKUh4PR0MpP23OmPqqyGfFsWBlmrjDipLEjrH
         l234xVd/5rfD9/x3bPIE0z7gpbk+qvZ7Jx0/VU4cJMiBGUttY/sKMa7A8roipCaZdzY4
         wbgL7X4y/rEWPwr43jUmgsxfwBe/D85RBy9d9VTtyTUHPtAYSHcFpDYy85RUnDQaOiW1
         btnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zyJzdLsY8xAV6bH7hXf7FjfS9orAgIpi2/QOQ0CDNS8=;
        b=E9JMZu2Q+7yI7f0X9BAB53liZf1+XBQgsR7lzakK2eoMvaLEPROQWXO6Qh/Vy8SSWu
         Qew90YTpxun44igbMQgTr45c+olcDuzhwiJZA2/h2eDTAbMOOmA2vYVF3pi2HOpiuFZq
         kL14ZCXhXxd0QnYadSj4KbM/WWblupaxZJyBR3eof8RRpbPXeMdzBZvAZE1n265KgvPV
         YPqLCk0bAWH3U+qF8aeQJBz/AVOmJPAHljuy9QcVzWhS+ce4l6SGPHW4XRUHolF/2JoV
         /AEFuaVS/PiMCmttPvfcUwt2O8gf8pwMCWw7vJjwaRJmsXS9fQ/OCKy70YuffByQi525
         QIXA==
X-Gm-Message-State: APjAAAW6FD8Xt5nIhK9S0viRXo69if9iaENcNDd/4fYlvr94M4cMTHxj
        kT5Mjfh2DEN0dbjPb6uiM4b6lLEOpJ+D7/q1Gp0=
X-Google-Smtp-Source: APXvYqxXJM1Oed8vRMl+vAQyH+svVAPFJsAc6a3VMSQzzpjNgo4/7hxKxbI45heWFtiK7NHLxt8yrt06TlCeUdSFoWw=
X-Received: by 2002:a0c:818f:: with SMTP id 15mr8563467qvd.162.1560972728942;
 Wed, 19 Jun 2019 12:32:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190619165957.235580-1-sdf@google.com> <20190619165957.235580-2-sdf@google.com>
In-Reply-To: <20190619165957.235580-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Jun 2019 12:31:57 -0700
Message-ID: <CAEf4BzZWJVWr295-6TY=pbTNoeB9cfRwpDiuRyAxajOsV_6yDQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 1/9] bpf: implement getsockopt and setsockopt hooks
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 10:00 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
>
> BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
>
> The buffer memory is pre-allocated (because I don't think there is
> a precedent for working with __user memory from bpf). This might be
> slow to do for each {s,g}etsockopt call, that's why I've added
> __cgroup_bpf_prog_array_is_empty that exits early if there is nothing
> attached to a cgroup. Note, however, that there is a race between
> __cgroup_bpf_prog_array_is_empty and BPF_PROG_RUN_ARRAY where cgroup
> program layout might have changed; this should not be a problem
> because in general there is a race between multiple calls to
> {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
>
> The return code of the BPF program is handled as follows:
> * 0: EPERM
> * 1: success, continue with next BPF program in the cgroup chain
>
> v7:
> * return only 0 or 1 (Alexei Starovoitov)
> * always run all progs (Alexei Starovoitov)
> * use optval=0 as kernel bypass in setsockopt (Alexei Starovoitov)
>   (decided to use optval=-1 instead, optval=0 might be a valid input)
> * call getsockopt hook after kernel handlers (Alexei Starovoitov)
>
> v6:
> * rework cgroup chaining; stop as soon as bpf program returns
>   0 or 2; see patch with the documentation for the details
> * drop Andrii's and Martin's Acked-by (not sure they are comfortable
>   with the new state of things)

I like the general approach, just overall unclear about seemingly
artificial restrictions I mentioned below.

>
> v5:
> * skip copy_to_user() and put_user() when ret == 0 (Martin Lau)
>
> v4:
> * don't export bpf_sk_fullsock helper (Martin Lau)
> * size != sizeof(__u64) for uapi pointers (Martin Lau)
> * offsetof instead of bpf_ctx_range when checking ctx access (Martin Lau)
>
> v3:
> * typos in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY comments (Andrii Nakryiko)
> * reverse christmas tree in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY (Andrii
>   Nakryiko)
> * use __bpf_md_ptr instead of __u32 for optval{,_end} (Martin Lau)
> * use BPF_FIELD_SIZEOF() for consistency (Martin Lau)
> * new CG_SOCKOPT_ACCESS macro to wrap repeated parts
>
> v2:
> * moved bpf_sockopt_kern fields around to remove a hole (Martin Lau)
> * aligned bpf_sockopt_kern->buf to 8 bytes (Martin Lau)
> * bpf_prog_array_is_empty instead of bpf_prog_array_length (Martin Lau)
> * added [0,2] return code check to verifier (Martin Lau)
> * dropped unused buf[64] from the stack (Martin Lau)
> * use PTR_TO_SOCKET for bpf_sockopt->sk (Martin Lau)
> * dropped bpf_target_off from ctx rewrites (Martin Lau)
> * use return code for kernel bypass (Martin Lau & Andrii Nakryiko)
>
> Cc: Martin Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

<snip>

>
> +struct bpf_sockopt_kern {
> +       struct sock     *sk;
> +       u8              *optval;
> +       u8              *optval_end;
> +       s32             level;
> +       s32             optname;
> +       u32             optlen;

Optlen is used below as signed integer, so switch it to s32?

> +       s32             retval;
> +
> +       /* Small on-stack optval buffer to avoid small allocations.
> +        */
> +       u8 buf[64] __aligned(8);
> +};
> +

<snip>

>
> +struct bpf_sockopt {
> +       __bpf_md_ptr(struct bpf_sock *, sk);
> +       __bpf_md_ptr(void *, optval);
> +       __bpf_md_ptr(void *, optval_end);
> +
> +       __s32   level;
> +       __s32   optname;
> +       __u32   optlen;

Same as above, we expect BPF program to be able to set it to -1, so __s32?

> +       __s32   retval;
> +};
> +
>  #endif /* _UAPI__LINUX_BPF_H__ */
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c

<snip>

> +
> +       if (ctx.optlen == -1)
> +               /* optlen set to -1, bypass kernel */
> +               ret = 1;
> +       else if (ctx.optlen == optlen)
> +               /* optlen not changed, run kernel handler */
> +               ret = 0;
> +       else
> +               /* any other value is rejected */
> +               ret = -EFAULT;

I'm consufed about this assymetry between getsockopt and setsockopt
behavior. Why we are disallowing setsockopt from changing optlen (and
value itself)? Is there any harm in allowing that? Imagining some use
case that provides transparent "support" for some option, you'd need
to be able to intercept and provide custom values both for setsockopt
and getsockopt. So unless I'm missing some security implications, why
not make both sides able to write?


Similar will apply w.r.t. retval, why can't setsockopt return EINVAL
to reject some options? This seems very useful and very similar to
what sysctl BPF hooks do.

> +
> +out:
> +       sockopt_free_buf(&ctx);
> +       return ret;
> +}
> +EXPORT_SYMBOL(__cgroup_bpf_run_filter_setsockopt);
> +
> +int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
> +                                      int optname, char __user *optval,
> +                                      int __user *optlen, int max_optlen,
> +                                      int retval)
> +{

<snip>

> +
> +       if (ctx.optlen > max_optlen) {
> +               ret = -EFAULT;
> +               goto out;
> +       }
> +
> +       /* BPF programs only allowed to set retval to 0, not some
> +        * arbitrary value.
> +        */
> +       if (ctx.retval != 0 && ctx.retval != retval) {

Lookin at manpage of getsockopt, seems like at least two error codes
are relevant and generally useful for BPF program to be able to
return: EINVAL and ENOPROTOOPT? Why we are disallowing anything but 0
(or preserving original retval)?

> +               ret = -EFAULT;
> +               goto out;
> +       }
> +
> +       if (copy_to_user(optval, ctx.optval, ctx.optlen) ||
> +           put_user(ctx.optlen, optlen)) {
> +               ret = -EFAULT;
> +               goto out;
> +       }
> +
> +       ret = ctx.retval;
> +
> +out:
> +       sockopt_free_buf(&ctx);
> +       return ret;
> +}
> +EXPORT_SYMBOL(__cgroup_bpf_run_filter_getsockopt);
> +

<snip>
