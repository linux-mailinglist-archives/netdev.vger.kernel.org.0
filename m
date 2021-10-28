Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FF143E7EC
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhJ1SEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhJ1SEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 14:04:21 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357B5C0431A2;
        Thu, 28 Oct 2021 11:00:31 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id d204so17430570ybb.4;
        Thu, 28 Oct 2021 11:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/UqmxhR8480mrjTDLn3IXeFR7Vq7XPYW3k/R4b/MBdo=;
        b=VSnElJ0A/9MYWA250j8kXsCaxHxduIHgTlF9Eb/o3RmoI7KBZEMoQqTbCF5oq88TCv
         CG8hKVkphajrx4B3lQxyNo35F1OPtjLlrm0X3Ruaqbhp8vWhZXgn86j/a+51FOxjw8qb
         WIu3uxi4DAix3lzCjY29UCMWIH8GBwOK4moufkFPYAbKZCEVKe62fPwilram4ApZph3i
         E+BqZw6UjbWD420k2RYH5c+ImV6IcBHKXCkcc83Gw0DjP15N/9RdqSwwtjgbO6htmOkv
         jszttNXZyMquaN+ZCHYIsHch26LXalequYrvgu47DfHAkSAdmjALdRe7gC5UZRKu1CGj
         H2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/UqmxhR8480mrjTDLn3IXeFR7Vq7XPYW3k/R4b/MBdo=;
        b=c0UaTfrsSqO22866eOk4PGIFneV+vg/9D8SLJdflu4gu2PNR4Dq3tWK+EilhboqSwN
         xF4vybPG8DBy55xig9j5GU4e0ZzhFnoH5ni6sQ/HNxiBzXcTEKhvyoys0FISb8lXHeKJ
         j186UmioUwsq4fqzxKj8ZuK/0WQhwX+dRhBG6viGRW/toMXzsNccJVKIv4ShhevMsgl7
         uRO3wwlKn0mqEAd2FHl+uqel2HTPHx0GEASqx4vMqlJnQxQksqiqoQTT6WJNAt7M5DB1
         YDrOpktJnzXBZqc9vMD2rGPl3XjW72xqcK4bbUt22VWCISCifnesCdQ+4mhe1bljbNJw
         kxQQ==
X-Gm-Message-State: AOAM530ZYJUIKqiWlN5vcqZCqvSlMBrz89QWcbjKnRAVnjHVVcDIkpRg
        /VC8tgx1cFGNunvhBRqlGmkOyhISHIqPPtyoPyFp2b/sXAENgg==
X-Google-Smtp-Source: ABdhPJyraz2B+xsLtN0q+nN4Bnt7vnk+K8y9wJL9buOASAh9Ff67k7SI8O/Ll8JHVKP3dxxL+nVAG6VvRvzRNcm17X4=
X-Received: by 2002:a25:cc4c:: with SMTP id l73mr3628202ybf.114.1635444030250;
 Thu, 28 Oct 2021 11:00:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211028063501.2239335-1-memxor@gmail.com> <20211028063501.2239335-5-memxor@gmail.com>
In-Reply-To: <20211028063501.2239335-5-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Oct 2021 11:00:18 -0700
Message-ID: <CAEf4Bza=PU3tKLs22_g-tn=-S12mZLLXEyPOzr1TRMC9mRDnZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/8] libbpf: Ensure that BPF syscall fds are
 never 0, 1, or 2
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 11:35 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> Add a simple wrapper for passing an fd and getting a new one >= 3 if it
> is one of 0, 1, or 2. There are two primary reasons to make this change:
> First, libbpf relies on the assumption a certain BPF fd is never 0 (e.g.
> most recently noticed in [0]). Second, Alexei pointed out in [1] that
> some environments reset stdin, stdout, and stderr if they notice an
> invalid fd at these numbers. To protect against both these cases, switch
> all internal BPF syscall wrappers in libbpf to always return an fd >= 3.
> We only need to modify the syscall wrappers and not other code that
> assumes a valid fd by doing >= 0, to avoid pointless churn, and because
> it is still a valid assumption. The cost paid is two additional syscalls
> if fd is in range [0, 2].
>
>   [0]: e31eec77e4ab ("bpf: selftests: Fix fd cleanup in get_branch_snapshot")
>   [1]: https://lore.kernel.org/bpf/CAADnVQKVKY8o_3aU8Gzke443+uHa-eGoM0h7W4srChMXU1S4Bg@mail.gmail.com
>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---

LGTM, thanks.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/bpf.c             | 35 +++++++++++++++++++++------------
>  tools/lib/bpf/libbpf_internal.h | 24 ++++++++++++++++++++++
>  2 files changed, 46 insertions(+), 13 deletions(-)
>

[...]
