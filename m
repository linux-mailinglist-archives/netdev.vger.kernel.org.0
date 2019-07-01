Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0565B5C179
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfGAQyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:54:37 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39842 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfGAQyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:54:36 -0400
Received: by mail-qk1-f195.google.com with SMTP id i125so11555475qkd.6;
        Mon, 01 Jul 2019 09:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yqjjWJ80wfB2V95LiA7VZtkdNnbGbNC6jRcZqL+S+c0=;
        b=oPK8TIEOv7t9CxQt53EhLEB+/Q8BNQo3wU/oEjM0DVcbOf2qABObXAzq5DhecRnQxM
         1za0bYaCAooemB1otBGAmCZPM2AZhRh50CGq81k1QKsZKTTHlj0Ay8U94yYwCFLHMy3/
         DSqij7kcFMy0EOZ8fIyLCc/wPk1u8oYz9welrz0+OyozEQAABc6EOozZzzuydgIETiSp
         ekcSefvRL401L0+dzBRNwdk2tjz6MT+mYosfQrVm8i2OBbXMtJaGQPJjcOHJAGM28Y/x
         2PhaRACeEUZ2lq6mRiZt3AGGqpaYFbiUzl5p+rJ+o0dgEPY13zJRVRBwxSoN5MdoD1m4
         7ltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yqjjWJ80wfB2V95LiA7VZtkdNnbGbNC6jRcZqL+S+c0=;
        b=CAf/dIBHKDRzaeJnEqUuRvKld+55/vWg4d6jmPib5HiahbgjiM9zilHYwUAKd7mKv5
         3YxF4GCX4NzYxdeevNzWmx0pgtfEbu0VeVD2F34R1ydQf8LbXpiQUzBLLU2CW1sy6piI
         JegBCKimtrrumtl8IXDwEehKnWMw4x3+4YCBGky4u72OQLGFoN4q0x7Cp7+Q39WcwFw9
         Boy8qVv066jnQVYJfbAUWJsGd8/LtOj8Rm5vjslDF2SR9kv8qFJgVOTaxaMppj1mWoeI
         1UnItYxZF6UibVXuUx9hpwqNIHV+qxIIivgiLuXemlgmJdmnDyyTCJQSMDcqtfR1N3et
         jlfA==
X-Gm-Message-State: APjAAAUMwdhrjsTvdxC7bF/FvGUJiyrGajIeeMhvvSzO+Y79euvyu1D+
        h2Mi5Zw6Zw1f5IiXT220xhaDzjycJ135u+msUF4=
X-Google-Smtp-Source: APXvYqx2+65aBphrq9jh7DG33NFKJFzLOlfdeKbTs82IBINXIFH14AeSEFO5Ochj9gp/1tiDLo+gaWynZvwTlQ9p3wc=
X-Received: by 2002:a37:a643:: with SMTP id p64mr21969128qke.36.1562000075447;
 Mon, 01 Jul 2019 09:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190701163103.237550-1-sdf@google.com> <20190701163103.237550-2-sdf@google.com>
In-Reply-To: <20190701163103.237550-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jul 2019 09:54:24 -0700
Message-ID: <CAEf4BzYRHjkuKKk+eR3-zbTFjjxae1Ks3SXr7kkAVgZxmVWU-A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] bpf: allow wide (u64) aligned stores for
 some fields of bpf_sock_addr
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        kernel test robot <rong.a.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 9:51 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Since commit cd17d7770578 ("bpf/tools: sync bpf.h") clang decided
> that it can do a single u64 store into user_ip6[2] instead of two
> separate u32 ones:
>
>  #  17: (18) r2 = 0x100000000000000
>  #  ; ctx->user_ip6[2] = bpf_htonl(DST_REWRITE_IP6_2);
>  #  19: (7b) *(u64 *)(r1 +16) = r2
>  #  invalid bpf_context access off=16 size=8
>
> From the compiler point of view it does look like a correct thing
> to do, so let's support it on the kernel side.
>
> Credit to Andrii Nakryiko for a proper implementation of
> bpf_ctx_wide_store_ok.
>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Fixes: cd17d7770578 ("bpf/tools: sync bpf.h")
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/filter.h   |  6 ++++++
>  include/uapi/linux/bpf.h |  4 ++--
>  net/core/filter.c        | 22 ++++++++++++++--------
>  3 files changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 340f7d648974..3901007e36f1 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -746,6 +746,12 @@ bpf_ctx_narrow_access_ok(u32 off, u32 size, u32 size_default)
>         return size <= size_default && (size & (size - 1)) == 0;
>  }
>
> +#define bpf_ctx_wide_store_ok(off, size, type, field)                  \
> +       (size == sizeof(__u64) &&                                       \
> +       off >= offsetof(type, field) &&                                 \
> +       off + sizeof(__u64) <= offsetofend(type, field) &&              \
> +       off % sizeof(__u64) == 0)
> +
>  #define bpf_classic_proglen(fprog) (fprog->len * sizeof(fprog->filter[0]))
>
>  static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a396b516a2b2..586867fe6102 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3237,7 +3237,7 @@ struct bpf_sock_addr {
>         __u32 user_ip4;         /* Allows 1,2,4-byte read and 4-byte write.
>                                  * Stored in network byte order.
>                                  */
> -       __u32 user_ip6[4];      /* Allows 1,2,4-byte read an 4-byte write.
> +       __u32 user_ip6[4];      /* Allows 1,2,4-byte read an 4,8-byte write.

typo: an -> and

>                                  * Stored in network byte order.
>                                  */
>         __u32 user_port;        /* Allows 4-byte read and write.
> @@ -3249,7 +3249,7 @@ struct bpf_sock_addr {
>         __u32 msg_src_ip4;      /* Allows 1,2,4-byte read an 4-byte write.

same

>                                  * Stored in network byte order.
>                                  */
> -       __u32 msg_src_ip6[4];   /* Allows 1,2,4-byte read an 4-byte write.
> +       __u32 msg_src_ip6[4];   /* Allows 1,2,4-byte read an 4,8-byte write.

the power of copy/paste! :)

>                                  * Stored in network byte order.
>                                  */
>         __bpf_md_ptr(struct bpf_sock *, sk);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index dc8534be12fc..5d33f2146dab 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6849,6 +6849,16 @@ static bool sock_addr_is_valid_access(int off, int size,
>                         if (!bpf_ctx_narrow_access_ok(off, size, size_default))
>                                 return false;
>                 } else {
> +                       if (bpf_ctx_wide_store_ok(off, size,
> +                                                 struct bpf_sock_addr,
> +                                                 user_ip6))
> +                               return true;
> +
> +                       if (bpf_ctx_wide_store_ok(off, size,
> +                                                 struct bpf_sock_addr,
> +                                                 msg_src_ip6))
> +                               return true;
> +
>                         if (size != size_default)
>                                 return false;
>                 }
> @@ -7689,9 +7699,6 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
>  /* SOCK_ADDR_STORE_NESTED_FIELD_OFF() has semantic similar to
>   * SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF() but for store operation.
>   *
> - * It doesn't support SIZE argument though since narrow stores are not
> - * supported for now.
> - *
>   * In addition it uses Temporary Field TF (member of struct S) as the 3rd
>   * "register" since two registers available in convert_ctx_access are not
>   * enough: we can't override neither SRC, since it contains value to store, nor
> @@ -7699,7 +7706,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
>   * instructions. But we need a temporary place to save pointer to nested
>   * structure whose field we want to store to.
>   */
> -#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF, TF)                       \
> +#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE, OFF, TF)         \
>         do {                                                                   \
>                 int tmp_reg = BPF_REG_9;                                       \
>                 if (si->src_reg == tmp_reg || si->dst_reg == tmp_reg)          \
> @@ -7710,8 +7717,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
>                                       offsetof(S, TF));                        \
>                 *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(S, F), tmp_reg,         \
>                                       si->dst_reg, offsetof(S, F));            \
> -               *insn++ = BPF_STX_MEM(                                         \
> -                       BPF_FIELD_SIZEOF(NS, NF), tmp_reg, si->src_reg,        \
> +               *insn++ = BPF_STX_MEM(SIZE, tmp_reg, si->src_reg,              \
>                         bpf_target_off(NS, NF, FIELD_SIZEOF(NS, NF),           \
>                                        target_size)                            \
>                                 + OFF);                                        \
> @@ -7723,8 +7729,8 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
>                                                       TF)                      \
>         do {                                                                   \
>                 if (type == BPF_WRITE) {                                       \
> -                       SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF,    \
> -                                                        TF);                  \
> +                       SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE,   \
> +                                                        OFF, TF);             \
>                 } else {                                                       \
>                         SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(                  \
>                                 S, NS, F, NF, SIZE, OFF);  \
> --
> 2.22.0.410.gd8fdbe21b5-goog
>
