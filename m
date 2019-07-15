Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B4B6999C
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 19:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731574AbfGORQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 13:16:46 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36734 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731244AbfGORQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 13:16:46 -0400
Received: by mail-qt1-f194.google.com with SMTP id z4so16449727qtc.3;
        Mon, 15 Jul 2019 10:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fQjmLPP+Nuy0y8sWSNcybPlf5NOIgXkax9J7DyurAOs=;
        b=nPEWIAUIYagol98G1JbJzcqd3B/WDX1Y2P1U9uyEooX+UXefKi8v8bsLnAbfvjlRAa
         4F+F/ZbqWgHqRZMM5EXuzI2M6Pxaezlc8vl1qLIAuTIjNFo3hOPKvvrOac95p2v613N9
         NS2yvDKvzGeHjVGMQcXYWaNTaCh6E1OPUMjYmvCIXVNhEZfgN/1tCh+HnyJy7gej4f0y
         1mUe5gMpGP2Ko8teEmBqcRi6PPYA1M3Y4ahw6gOqc6V54eqTBFfo0UZwWOQNky4zE8uC
         aPVyVy2co4wtmIfd6f8XgyUgFe/qEJ9k8394vzZ595efJ8/umlnMi83oPiefXNr0kHra
         rJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fQjmLPP+Nuy0y8sWSNcybPlf5NOIgXkax9J7DyurAOs=;
        b=jKskTa5EhNTsK37Dnj9gFliOUsnMZMu7ip714SS625GP5GkUMBL7SSVmQu+eeHWN+/
         Oy5VIQkW6rJA5geNFlUAVm0rVKMpsOHbLmJuHqskWadW9kJ/l0lYLyyehKw84iIU84mC
         kmyGp/N2zAOnsLr16LfpJ6R+QBDf7XmPqB7KJKy5pKGoW+3cTDEneMNzx9bd5MQ18OAg
         //tcFFVZqC6V9HdUzXS0Sqq0df6Ihr3OGIJUcWcB/4Z4t6wM2wANH7dWnOiQGStz0iHu
         RnXbK+/daIbZ3jg0aJCL58MP0PA7eEkDZgPSPO91qVnEYqPZ+zzrVYX46I8mQymyWlXD
         tCCA==
X-Gm-Message-State: APjAAAUNs+rrg8z1zMpkeXxqDgyMM3wYoaY1fe14duhItk08VgdJX4gM
        dcaVFXmLcOxF97X50wQBvvwArQJJ4ZBwZx9jdBM=
X-Google-Smtp-Source: APXvYqxpfqHdyeHncPFNLp3Dc/Z/mEc0hjRqt/86QiPxX31jzP20Pqnvtlbe1hmoZbRXFvJ9pjCuq6CC6sTbyHM+Cps=
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr20294029qvv.38.1563211005004;
 Mon, 15 Jul 2019 10:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190715163956.204061-1-sdf@google.com>
In-Reply-To: <20190715163956.204061-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Jul 2019 10:16:33 -0700
Message-ID: <CAEf4BzYzi5afvSBSWR3TvZU1GVs1DLi08BCarmkw-z_3i5+NHA@mail.gmail.com>
Subject: Re: [PATCH bpf 0/5] bpf: allow wide (u64) aligned loads for some
 fields of bpf_sock_addr
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 9:40 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> When fixing selftests by adding support for wide stores, Yonghong
> reported that he had seen some examples where clang generates
> single u64 loads for two adjacent u32s as well:
> http://lore.kernel.org/netdev/a66c937f-94c0-eaf8-5b37-8587d66c0c62@fb.com
>
> Let's support aligned u64 reads for some bpf_sock_addr fields
> as well.
>
> (This can probably wait for bpf-next, I'll defer to Younhong and the
> maintainers.)
>
> Cc: Yonghong Song <yhs@fb.com>
>
> Stanislav Fomichev (5):
>   bpf: rename bpf_ctx_wide_store_ok to bpf_ctx_wide_access_ok
>   bpf: allow wide aligned loads for bpf_sock_addr user_ip6 and
>     msg_src_ip6
>   selftests/bpf: rename verifier/wide_store.c to verifier/wide_access.c
>   selftests/bpf: add selftests for wide loads
>   bpf: sync bpf.h to tools/
>

LGTM!

For the series:

Acked-by: Andrii Narkyiko <andriin@fb.com>

>  include/linux/filter.h                        |  2 +-
>  include/uapi/linux/bpf.h                      |  4 +-
>  net/core/filter.c                             | 24 ++++--
>  tools/include/uapi/linux/bpf.h                |  4 +-
>  .../selftests/bpf/verifier/wide_access.c      | 73 +++++++++++++++++++
>  .../selftests/bpf/verifier/wide_store.c       | 36 ---------
>  6 files changed, 95 insertions(+), 48 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/wide_access.c
>  delete mode 100644 tools/testing/selftests/bpf/verifier/wide_store.c
>
> --
> 2.22.0.510.g264f2c817a-goog
