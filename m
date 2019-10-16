Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC06D9A67
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391151AbfJPTpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:45:45 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40013 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfJPTpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:45:44 -0400
Received: by mail-qt1-f193.google.com with SMTP id m61so37923394qte.7;
        Wed, 16 Oct 2019 12:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oOvpqTXEY4BWGhEZiTKlf5x55eS7zu9YCevwrw3US8g=;
        b=UEeJofNOa9TVouH3sGrMXitI1lvIC/nSelx12H9w6DDAHjECK8TJYIKJUZCr7YJbEo
         s88jLb01Bsfv54bV9hf1ftycmgfaX3jz9NwFuqzMfdJ22bNXQfITt4ZmxLNpq0usqdSN
         oU9i6a5PbegZ6D5lSqwE41CVxbX9tpGYWGz7XYEaVWSsWEvYPBgzzXDFg/Ma1sQ1F8VM
         kTrmUD2nyw+eWgmIc4TY7V2E3cE4hWqhBZOalVb3Y5uFLbCs/nr7oVZdG0dxgQ5tARyM
         yM+4c0Wr9Nb6Dz8ZCGV4ercXj9vhkYf7HUdvezzgoIo667YPxJKv+3ZwZp7ZdD9jm40Y
         q9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oOvpqTXEY4BWGhEZiTKlf5x55eS7zu9YCevwrw3US8g=;
        b=HwNvOmuEpbyEuxNgwtelozsMpPv9CiHTYy+aMX8OztryxFQn///c1KAGEXXwpCDL3a
         VpYEP1LjdOI7wuITQLR8MFX8r77a55Pcno6faLlY6Gm0/mLsiXGFwESvdobEnJ2tucE8
         UQ+LWe1dccOhE9hzR0PDUTTeAhOwTqusb7zgEqoX0PZdDb1NW4tAvQM8gEWAErhaO0gx
         vepL4S9MIGtC7rnS47ObpMxglVQE1fjwWcFwhw8fTg+zDUsfbDtM72I1R26XpU1x3KR8
         YDxM4bnPAg9kzX5V+NsLMATvvz1OlZOfkOXNRa1Rd847wNb4WxbJLXlbraaD5rQBgsEm
         +1qw==
X-Gm-Message-State: APjAAAVp0TxY/F3ctTSOP/xDm+IXNsTJbi2A1TZfPelfJYRN6fMwntPl
        zhMFO8Fp6TzlFhbeeKoDmYWqcvIChAIFcHTpT98=
X-Google-Smtp-Source: APXvYqxsILlEcXzSrLBSU603rKtxcogFdffb/dkgrY4Wd4JoLtHO0JNjT3TlLe0Dx0lUe/8+exk/AZSsUodJzoVHP94=
X-Received: by 2002:ac8:379d:: with SMTP id d29mr44513486qtc.93.1571255143633;
 Wed, 16 Oct 2019 12:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191016032505.2089704-1-ast@kernel.org> <20191016032505.2089704-5-ast@kernel.org>
In-Reply-To: <20191016032505.2089704-5-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Oct 2019 12:45:32 -0700
Message-ID: <CAEf4BzZCw5_GESsziVg9fxj17ti3h-FjBNcZjaSDspwbT=i0fQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 04/11] bpf: add attach_btf_id attribute to
 program load
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

On Wed, Oct 16, 2019 at 4:15 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Add attach_btf_id attribute to prog_load command.
> It's similar to existing expected_attach_type attribute which is
> used in several cgroup based program types.
> Unfortunately expected_attach_type is ignored for
> tracing programs and cannot be reused for new purpose.
> Hence introduce attach_btf_id to verify bpf programs against
> given in-kernel BTF type id at load time.
> It is strictly checked to be valid for raw_tp programs only.
> In a later patches it will become:
> btf_id == 0 semantics of existing raw_tp progs.
> btd_id > 0 raw_tp with BTF and additional type safety.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/syscall.c           | 18 ++++++++++++++----
>  tools/include/uapi/linux/bpf.h |  1 +
>  4 files changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 282e28bf41ec..f916380675dd 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -375,6 +375,7 @@ struct bpf_prog_aux {
>         u32 id;
>         u32 func_cnt; /* used by non-func prog as the number of func progs */
>         u32 func_idx; /* 0 for non-func prog, the index in func array for func prog */
> +       u32 attach_btf_id; /* in-kernel BTF type id to attach to */
>         bool verifier_zext; /* Zero extensions has been inserted by verifier. */
>         bool offload_requested;
>         struct bpf_prog **func;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a65c3b0c6935..3bb2cd1de341 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -420,6 +420,7 @@ union bpf_attr {
>                 __u32           line_info_rec_size;     /* userspace bpf_line_info size */
>                 __aligned_u64   line_info;      /* line info */
>                 __u32           line_info_cnt;  /* number of bpf_line_info records */
> +               __u32           attach_btf_id;  /* in-kernel BTF type id to attach to */
>         };
>
>         struct { /* anonymous struct used by BPF_OBJ_* commands */
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 82eabd4e38ad..b56c482c9760 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -23,6 +23,7 @@
>  #include <linux/timekeeping.h>
>  #include <linux/ctype.h>
>  #include <linux/nospec.h>
> +#include <uapi/linux/btf.h>
>
>  #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY || \
>                            (map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
> @@ -1565,8 +1566,9 @@ static void bpf_prog_load_fixup_attach_type(union bpf_attr *attr)
>  }
>
>  static int
> -bpf_prog_load_check_attach_type(enum bpf_prog_type prog_type,
> -                               enum bpf_attach_type expected_attach_type)
> +bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
> +                          enum bpf_attach_type expected_attach_type,
> +                          u32 btf_id)
>  {
>         switch (prog_type) {
>         case BPF_PROG_TYPE_CGROUP_SOCK:
> @@ -1608,13 +1610,19 @@ bpf_prog_load_check_attach_type(enum bpf_prog_type prog_type,
>                 default:
>                         return -EINVAL;
>                 }
> +       case BPF_PROG_TYPE_RAW_TRACEPOINT:
> +               if (btf_id > BTF_MAX_TYPE)
> +                       return -EINVAL;
> +               return 0;
>         default:
> +               if (btf_id)
> +                       return -EINVAL;

this is minor issue, feel free to fix in a follow up patch, but this
check should be done for all cases but BPF_PROG_TYPE_RAW_TRACEPOINT,
not just for default (default will ignore a bunch of cgroup attach
types).

>                 return 0;
>         }
>  }
>
