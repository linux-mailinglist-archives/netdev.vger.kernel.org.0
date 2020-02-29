Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5051743C9
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 01:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgB2AXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 19:23:53 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42536 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgB2AXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 19:23:53 -0500
Received: by mail-qt1-f194.google.com with SMTP id r5so3414173qtt.9;
        Fri, 28 Feb 2020 16:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MiQaTVw+NEXi6UZVua5Gb5oGF/n2CDbDGU7d6kef8X4=;
        b=IOqBli+8eMXqXIl24zDSLiuX5dwknHb8PffBOFfGaRRdfd0FcsWP1HxDuwlDjaaifw
         7JImQhpp2hLAzslfx+0grIZ68rnFtoXDeIh5wTB5XzjxHe70Nv1UKtbE5Kin+fVMJmDD
         aKw5+ZlM2Qz7xMiRvzYkKXCmY4E6Qo5y+1wtdcV2pzHtx0gtyoucG9USq9zCziiEQ/5a
         TBHesKYVWZJ4iBoJRlZOHG7x7Dp4QKxcEvmN+cBlTr8sIEqW/HR1qkJTGNziazb2QzDO
         UvY7Am9xPPINZg/S2RW34Rn2t/pKYF1MPw6htTtw6+q1IgeQdCH7E3hCCpTswKW3RyLP
         rCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MiQaTVw+NEXi6UZVua5Gb5oGF/n2CDbDGU7d6kef8X4=;
        b=VOLEBdPm+zEK29SElqRlDQwJvF3D1/iETJLUB/U35R5Ys3omlBQ47GAp2kPMRAYDyv
         iWkGi4Jk7+QGypbuLGVyR4+lvrpP6reZAtxL6Buj7AJ/8k7aDlYcCJmjOgiJQuGJaWYE
         S5aNNzM4qQNzrdXyOjBbuAP0l9zr8suiBHP+56WC6vbLuQ0eTMbpZC/KLS1L4c3l3Ji3
         lC/CmHRzB5Xe0hBDSg0JghSJBb478uZIUFLPFHTf+S0FpcfeEYd8S6iB5uQ+QZ5NJml4
         HoZo/YTyPrh+Vw1FvVy1YtdNZNgYD3EakDsCK2THQ3Tsg+ucUetzadrJj2yfJAz1xV5O
         FJAQ==
X-Gm-Message-State: APjAAAV986BYxfCxd+mbr0HsCk7oX6Ctt9TV9glLk/AanzpcYoYa2u1d
        y8w2xV6AZf3QTuVAuvp9XVB68kGniddDdWJv1rY=
X-Google-Smtp-Source: APXvYqwBDifEhSSUWTgsvv2LuzVQ7lhkZ02Psr6krpxKJnYa/EcZ+hrNlWS+TX8h0OjLzY2AvvAza249k7ORdHQPTxw=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr6140156qtq.93.1582935832248;
 Fri, 28 Feb 2020 16:23:52 -0800 (PST)
MIME-Version: 1.0
References: <20200228020212.16183-1-komachi.yoshiki@gmail.com>
In-Reply-To: <20200228020212.16183-1-komachi.yoshiki@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 28 Feb 2020 16:23:41 -0800
Message-ID: <CAEf4Bza9J3e=dfzDud6KY7_=4Qv77YqW2srfdxKg9ieiUCJgXw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: btf: Fix BTF verification of the enum size in struct/union
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 6:07 PM Yoshiki Komachi
<komachi.yoshiki@gmail.com> wrote:
>
> btf_enum_check_member() checked if the size of "enum" as a struct
> member exceeded struct_size or not. Then, the function definitely
> compared it with the size of "int" now. Therefore, errors could occur
> when the size of the "enum" type was changed.
>
> Although the size of "enum" is 4-byte by default, users can change it
> as needed (e.g., the size of the following test variable is not 4-byte
> but 1-byte). It can be used as a struct member as below:
>
> enum test : char {

you can't specify that in pure C, but this will work for C:

struct {
    enum { X, Y, Z } __attribute__((packed)) e;
} tmp;

Please add such a selftest, as part of fixing this bug. Thanks!

Otherwise logic looks good.

>         X,
>         Y,
>         Z,
> };
>
> struct {
>         char a;
>         enum test b;
>         char c;
> } tmp;
>
> With the setup above, when I tried to load BTF, the error was given
> as below:
>
> ------------------------------------------------------------------
>
> [58] STRUCT (anon) size=3 vlen=3
>         a type_id=55 bits_offset=0
>         b type_id=59 bits_offset=8
>         c type_id=55 bits_offset=16
> [59] ENUM test size=1 vlen=3
>         X val=0
>         Y val=1
>         Z val=2
>
> [58] STRUCT (anon) size=3 vlen=3
>         b type_id=59 bits_offset=8 Member exceeds struct_size
>
> libbpf: Error loading .BTF into kernel: -22.
>
> ------------------------------------------------------------------
>
> The related issue was previously fixed by the commit 9eea98497951 ("bpf:
> fix BTF verification of enums"). On the other hand, this patch fixes
> my explained issue by using the correct size of "enum" declared in
> BPF programs.
>
> Fixes: 179cde8cef7e ("bpf: btf: Check members of struct/union")
> Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
> ---
>  kernel/bpf/btf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 7871400..32ab922 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -2418,7 +2418,7 @@ static int btf_enum_check_member(struct btf_verifier_env *env,
>
>         struct_size = struct_type->size;
>         bytes_offset = BITS_ROUNDDOWN_BYTES(struct_bits_off);
> -       if (struct_size - bytes_offset < sizeof(int)) {
> +       if (struct_size - bytes_offset < member_type->size) {
>                 btf_verifier_log_member(env, struct_type, member,
>                                         "Member exceeds struct_size");
>                 return -EINVAL;
> --
> 1.8.3.1
>
