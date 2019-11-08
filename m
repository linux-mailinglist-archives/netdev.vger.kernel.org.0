Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58B2FF3F7A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 06:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfKHFNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 00:13:49 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39040 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfKHFNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 00:13:48 -0500
Received: by mail-qt1-f193.google.com with SMTP id t8so5117616qtc.6;
        Thu, 07 Nov 2019 21:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8j7bDwfjS0FaCs6vUIGJvUGPTayAptmBC1yLK9hJfBM=;
        b=qesBbMVMWKf98yPU/EXG/JCr5GeVoqcfUKqqG3kQBGkN6hRtS4epfz+xAAQp4/ao4f
         tlkizDYvOOIr506+M5Zf8ezAf6zIugtFnPG5wyyRO5W/x1Pl9X75O8YHycUsRMWT/dK6
         fXwA0fsF8UerRzDuK+xpVT4WKK2jI6VDP8yEBXW2NKbbQ7Azei4SxVqFkH4foIP0vFWB
         LF0ReCxzxc57FcHkMNu4ybZfa0tH1CLEu0zq614yIvwkwGzd7VqKqCThH/l19OfVM1A/
         NsDF54xcWwbgsuMgnX3WeuVV5ujs+8Gb77c3CPNa1MIP67PiZTJq4y3mSrg1Vg9uPyFp
         oROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8j7bDwfjS0FaCs6vUIGJvUGPTayAptmBC1yLK9hJfBM=;
        b=TjIRB/dOdSYIwJJ7FmR7PEZyDycyBA3Z2ylRDctikT3jYOKHA4ICq5GFrENKEzEeCK
         uhbxFgQkmPGHeZhMs7sLEUKLzlSxLUL7h1yEULKsHOLyae9EAAfAq7GVSHkqUOiqu3sI
         rgMmcIvhcW68mOD1w/gwB6M7RwoNW2ArFjWaLMUr2gFhUo6PgKpSbsmsE7hSojJ2de+b
         m2Mv3dhA4La8tITXBthDfhhQlIBCSAuOP9LiiDj1waf+yM6xgUOMI8XZhH9B0I9YbVyD
         ksz3p4Auqpe/o5w1j7TgS5mWJN94tR+kcFGkghpp4J2y29N8IKxdGvOgWlYsvoMYLBWb
         roiw==
X-Gm-Message-State: APjAAAUDqVIS9dgbyxkXthHJTe+OhjjUOTE6VftXizbGJ3uur3rE/wzQ
        URdHtNBoRhiU4IyoBQb2TceCdkBau6DuduCQ4yhd3A==
X-Google-Smtp-Source: APXvYqwG9pebI0KmDpSAgZVIkrqBvNmtTfcUnQBXQkSXz35/q7zXvnDZXbP5sEuXP1V3WYmAdV2eRjmyxFn0omsuP2E=
X-Received: by 2002:ac8:4890:: with SMTP id i16mr8213327qtq.141.1573190027618;
 Thu, 07 Nov 2019 21:13:47 -0800 (PST)
MIME-Version: 1.0
References: <20191107054644.1285697-1-ast@kernel.org> <20191107054644.1285697-13-ast@kernel.org>
In-Reply-To: <20191107054644.1285697-13-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 7 Nov 2019 21:13:36 -0800
Message-ID: <CAEf4BzZ0Brfa+8yA5-J=T2nFmk55TQBsfSygXFOX3dmKt3rFGw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 12/17] bpf: Fix race in btf_resolve_helper_id()
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 9:48 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> btf_resolve_helper_id() caching logic is racy, since under root the verifier
> can verify several programs in parallel. Fix it with extra spin_lock.
>
> Fixes: a7658e1a4164 ("bpf: Check types of arguments passed into helpers")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf.h   |  3 ++-
>  kernel/bpf/btf.c      | 34 +++++++++++++++++++++++++++++++++-
>  kernel/bpf/verifier.c |  6 +-----
>  3 files changed, 36 insertions(+), 7 deletions(-)
>

[...]

> +       /* ok to race the search. The result is the same */
> +       ret = __btf_resolve_helper_id(log, fn->func, arg);
> +       if (!ret) {
> +               bpf_log(log, "BTF resolution bug\n");
> +               return -EFAULT;
> +       }
> +       spin_lock(&btf_resolve_lock);
> +       if (*btf_id) {
> +               ret = *btf_id;
> +               goto out;
> +       }
> +       *btf_id = ret;
> +out:
> +       spin_unlock(&btf_resolve_lock);

Is this race a problem? Does it cause any issues? Given that even if
you do parallel resolutions at the same time, they all will have to
result in the same btf_id, so just setting it unconditionally multiple
times without locking should be ok, no? Maybe WRITE_ONCE, but not sure
why all the way to spinlock.


> +       return ret;
> +}
> +
>  static int __get_type_size(struct btf *btf, u32 btf_id,
>                            const struct btf_type **bad_type)
>  {

[...]
