Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35E4D14AB
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731665AbfJIQzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:55:07 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42749 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731145AbfJIQzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:55:06 -0400
Received: by mail-qk1-f193.google.com with SMTP id f16so2830353qkl.9;
        Wed, 09 Oct 2019 09:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2/HF9NREfSQkdboNiYLB4mdV2BC4zZWqkjbH6CrigBU=;
        b=Ik9UQ1pVjDXAXl5D9zROUvPBuhjWeO0V8nn6PnzCOIuP5EQuq5LQEaSrM+cyyPW3qp
         faauOXKazJwuaxqCKuYJfs+WkOjQEb4T/JMn/m8tGie6IxEYLvTp7KeUI6KfkKfudlw6
         GITXuCJTf4PhMkMgXjVhtQfUB5bVwmkOdwm7R499I9enV9JTtSajL0hfMfrZx3pH2NtL
         woDtjvZ4TuDQotmDSoHv4MJWWA/N6i+7d3rwvvdoV/8m9iYYvioqdqZbdwEUb56AlyZB
         FMz6K+Tp6XkJlIntRYhqhh0YNvzlcLSoST9pjwVQhDsNB7Tpe3VXZNsZ4HKmNUychf3q
         9AAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2/HF9NREfSQkdboNiYLB4mdV2BC4zZWqkjbH6CrigBU=;
        b=ZqNA9w+1CefhFQskq0jnIHxmDbWPKxoE5ZCvN1DTR+cpDyr8bmf5ywpuLk2+lbMMfr
         f90G6WnlXns4CNgMpo/UP2L95t3XZ+we4dyaSpMabgsjTEH1kJssfIaY1Zh60g+emir7
         mAF3akPX0HfTUVNlyfoKfeePqShc3IYLxBgQsaRgulkwp+Bg1Mh0BNMWcN8EN7loEnhk
         7ubGKQX3aS7wrVWdx99gOXM/MwiUKGqapZsDnGoxSdaDvwOKY15G3w8s8XhdWDli7vFw
         OpdQX2OnM40Ab/A2plw21OUdB9SOcQlFTf7zVCYNa825gH7ZA0fiXRq7ihhU8R2qNqAZ
         VQ1Q==
X-Gm-Message-State: APjAAAXRQKMeLo9F+DwN5HLOH0SuXb55FsNGoF7LaUQgisW75IZ6OhHJ
        KYHa/0d7NJ+F9D1ITqAV/0xe8foR1n7uhfsRgbM=
X-Google-Smtp-Source: APXvYqwkjEP6LQDwqyHgGNWPt2O8X8oEf9t3UY72mJKFPYOpn1GVrTNy2vlG4+DasgIr1qwwNWVKWBVGof7jwzagf7U=
X-Received: by 2002:a37:520a:: with SMTP id g10mr4604504qkb.39.1570640103797;
 Wed, 09 Oct 2019 09:55:03 -0700 (PDT)
MIME-Version: 1.0
References: <20191009164929.17242-1-i.maximets@ovn.org>
In-Reply-To: <20191009164929.17242-1-i.maximets@ovn.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Oct 2019 09:54:52 -0700
Message-ID: <CAEf4BzbL1qxyZaS=3-++Z=WDAK+0gVtVEFijgj_SJFi_NpAwyw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] libbpf: fix passing uninitialized bytes to setsockopt
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 9:49 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>
> 'struct xdp_umem_reg' has 4 bytes of padding at the end that makes
> valgrind complain about passing uninitialized stack memory to the
> syscall:
>
>   Syscall param socketcall.setsockopt() points to uninitialised byte(s)
>     at 0x4E7AB7E: setsockopt (in /usr/lib64/libc-2.29.so)
>     by 0x4BDE035: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:172)
>   Uninitialised value was created by a stack allocation
>     at 0x4BDDEBA: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:140)
>
> Padding bytes appeared after introducing of a new 'flags' field.
> memset() is required to clear them.
>
> Fixes: 10d30e301732 ("libbpf: add flags to umem config")
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
>

Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

> Version 2:
>   * Struct initializer replaced with explicit memset(). [Andrii]
>
>  tools/lib/bpf/xsk.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index a902838f9fcc..9d5348086203 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -163,6 +163,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
>         umem->umem_area = umem_area;
>         xsk_set_umem_config(&umem->config, usr_config);
>
> +       memset(&mr, 0, sizeof(mr));
>         mr.addr = (uintptr_t)umem_area;
>         mr.len = size;
>         mr.chunk_size = umem->config.frame_size;
> --
> 2.17.1
>
