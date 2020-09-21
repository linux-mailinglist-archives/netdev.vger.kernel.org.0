Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47474273636
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgIUXJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgIUXJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:09:14 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C20C061755;
        Mon, 21 Sep 2020 16:09:14 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id c17so11518007ybe.0;
        Mon, 21 Sep 2020 16:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=meOCUgi/FKcBeyF/4oJEMnUyFhAWk8VY347IbxiigwU=;
        b=cdJKUjm1sImnmu7CYgfsp5IU8EFhOfjvU7q0Yj9XKLD9mFE9oYenBNMxSwVOCYN1KD
         /IBF4UenSdRd9OYwig/kMyX2iICOmyisflhPTcjUpwIqqTTGzjFa1xKVcjObb114fCER
         hBR7PUdFbimahKxPbbfQKPfsVYTSV5E4wmUrLRjN3/pN1uAP87ZMiKaa1zDgAZotkhie
         DL42Us4+M5TTtTr0dZVZMZn7jO8fWra/v0JGUMNwDaoKZ7CQK/NxtG2GeAdeoNCC3ZAU
         6L5vpAuxYxNGtsMHve5ze+pNznicfbUmv6vZ5t6Z9sr+644NG9RKy/qCyRqkDxphxJJm
         opeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=meOCUgi/FKcBeyF/4oJEMnUyFhAWk8VY347IbxiigwU=;
        b=HdvNNvksigc/rClIC/+F61iKPbGtslV/GcX6PEjTBKIKAYkUV7lyh6g6JoQJbefyWx
         d3t6yROV7Q+uDilknh91OOiuSH8MW/IaPcPOwir8EZlIBiQ3gewi00sxy1Tnl3VcgBCN
         uXknrxdOItDQDgdF7a/Rf1n/oT/dN8ZwIfBAP9gvEDeBWQQKTOfcxJtEUnT5zNkx5eBY
         00MYL57sVz3QIHMdYIoAMkODmiPZuwrMAdtfel+bC0tgC4hkMlm0hk6yCr/dQz7w5gCH
         wFMTT05Ic5Y/n8JoAVaop0OZ4+bj6MjnxAUZ6r3gJZL+G/YzsE63SmAJhrL3hqbS9K60
         EGaw==
X-Gm-Message-State: AOAM530BXjK3GeSOzGy8iMGfvYRxZfjWAnXp0CfkOMS2h6RciObReosC
        Si1h2p2Z8IacJ6qQWGkPrrex13yWC/DPxdOv4YwBzTRTaKw4+w==
X-Google-Smtp-Source: ABdhPJzKWOQRcV0d4FZd9nMFl66MMP0wua629Acd7MfP9on4nCvTbE6M+2M9Vh7PCCLcoLHLor8mUmcEdkJPsHIP9wo=
X-Received: by 2002:a25:730a:: with SMTP id o10mr3128754ybc.403.1600729753556;
 Mon, 21 Sep 2020 16:09:13 -0700 (PDT)
MIME-Version: 1.0
References: <160051618267.58048.2336966160671014012.stgit@toke.dk> <160051618958.58048.6126760401623211021.stgit@toke.dk>
In-Reply-To: <160051618958.58048.6126760401623211021.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 16:09:02 -0700
Message-ID: <CAEf4Bza4BXqSQMRdBm2fOFo=kV8EBR6sJraQJCxc6+x-sBwUUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 06/10] bpf: Fix context type resolving for
 extension programs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Eelco reported we can't properly access arguments if the tracing
> program is attached to extension program.
>
> Having following program:
>
>   SEC("classifier/test_pkt_md_access")
>   int test_pkt_md_access(struct __sk_buff *skb)
>
> with its extension:
>
>   SEC("freplace/test_pkt_md_access")
>   int test_pkt_md_access_new(struct __sk_buff *skb)
>
> and tracing that extension with:
>
>   SEC("fentry/test_pkt_md_access_new")
>   int BPF_PROG(fentry, struct sk_buff *skb)
>
> It's not possible to access skb argument in the fentry program,
> with following error from verifier:
>
>   ; int BPF_PROG(fentry, struct sk_buff *skb)
>   0: (79) r1 =3D *(u64 *)(r1 +0)
>   invalid bpf_context access off=3D0 size=3D8
>
> The problem is that btf_ctx_access gets the context type for the
> traced program, which is in this case the extension.
>
> But when we trace extension program, we want to get the context
> type of the program that the extension is attached to, so we can
> access the argument properly in the trace program.
>
> This version of the patch is tweaked slightly from Jiri's original one,
> since the refactoring in the previous patches means we have to get the
> target prog type from the new variable in prog->aux instead of directly
> from the target prog.
>
> Reported-by: Eelco Chaudron <echaudro@redhat.com>
> Suggested-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/btf.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>

[...]
