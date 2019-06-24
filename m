Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E78B51D00
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbfFXVUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:20:03 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34628 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXVUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:20:03 -0400
Received: by mail-qt1-f196.google.com with SMTP id m29so16182141qtu.1;
        Mon, 24 Jun 2019 14:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z1XEkKQQ4kQOXdYffh4+MsjiKPUgBbSin4ZmXxLUT3s=;
        b=lHtoNFJVgt6ohOEc9mZ37e0yWZ6q+aG1oso8PxEP4JHGPNLt9OxXI5oSkuuw1NaAod
         ZiraYdV9k7FN+/cDBRA3xUteWQF3m7osu6EYoeOIEb38sIHaGAvZZnHzGiOy2rczC9VR
         hAkgIqQD3zEhQAJAIbbYKrCA9V0sZ257VYTfVbFzg361IyTXU8DriTfELg18DRexNrEh
         Zi1M5q5pxqWR4thvfyeFFS3cObURgYyz9B6B7bSFujOB+JQyQFTAXpbPrxpmo/CDl5iY
         IbvYzmAaYXRxF0w2FFxRXFAkhSyZM7Bi6U2bDAPvCnhZZv7XoasOK/UrQN/daTF+CJWZ
         ZSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z1XEkKQQ4kQOXdYffh4+MsjiKPUgBbSin4ZmXxLUT3s=;
        b=lgwn+z+VdLhIV/MVgL6G/IQHYCH0DZQvSASBahxOQFej8QX/YTNkP15Ybx6yOVgm7a
         qM7zg3wrgim0+4RMpKQl/fRCzLj0fiplalnJ4nSRSUO9QsdVH+O+IwqAL7akTqTBXLaP
         tRcwBGvrRO0eNq9docIYJQZeDLy+ADFUeDLMxzp27xLOQNAwHNcvw5MkND9lOVRhWzMs
         uewwD2gfFFYsXKPB/iWSij29+6g+kJyxG/TO3n7paRENFRx4TLqxS4dQUhhbXHHEtCNp
         jqT3Suibx0IV2u9EMDdR6TY8tENGi6ZwqUeUfX2u6hIp1m6Sqc00MPDXvWU6WXi5uLqQ
         r6og==
X-Gm-Message-State: APjAAAVsLvaTrTsHK0sE7fIz1MRES3GVIVhsD36gw9YY+NQSaWqbfwA6
        fvgMK9O2l57yqE9RCbznHsndDxvxjxUFJCZlQVg=
X-Google-Smtp-Source: APXvYqzh3izkXzhVwgv9YrlZAOs9DZCL9u0QPdeVhlfI2ASrToj3o5v0LVe3JXHLBkKqo0G9cE2w09NJZ9duhvBZ7ZY=
X-Received: by 2002:a0c:9e02:: with SMTP id p2mr58572748qve.150.1561411201895;
 Mon, 24 Jun 2019 14:20:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190624162429.16367-1-sdf@google.com> <20190624162429.16367-2-sdf@google.com>
In-Reply-To: <20190624162429.16367-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 Jun 2019 14:19:50 -0700
Message-ID: <CAEf4BzbRi9AGt5gcnFCgJPPp-64TsB37bncBXXg7B_bzGYSVAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 1/9] bpf: implement getsockopt and setsockopt hooks
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

On Mon, Jun 24, 2019 at 1:11 PM Stanislav Fomichev <sdf@google.com> wrote:
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
> v8:
> * use s32 for optlen (Andrii Nakryiko)
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
