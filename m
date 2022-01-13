Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA90248DDEB
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 19:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbiAMSzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 13:55:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40112 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237707AbiAMSzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 13:55:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EBAB61D40;
        Thu, 13 Jan 2022 18:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB79C36AEC;
        Thu, 13 Jan 2022 18:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642100150;
        bh=hMlJ9QB1L16utXssQ293CfOFivWIchx1FAeMsc3sNoI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SkiLjRj7G2antCNr0Xeb0tvN2njwb/UzFIYBE4p/rd+fEMhJrk1ts4VdJ0kxrAJsj
         gW1/DkgQUGcA1mIgVACsYabSg4qjuJCxH+O2fWSaoCOcuxNnncFge78OV6rtYEZx/1
         uf65LChZYjW+ZJWkr4+wxD0yFO8PuMf4yuPxvLOBHmAI+WGbIWeFOirCz9TeZxsZRV
         RG1p5na1G7JWnApvrYW1pUklJq5XfycsD5QcIwBREsWfwZ/L1pQRN8wmJ+A4BzS2Hf
         k9UbHe8LwCtb95H6SRZU/JfCb2KoAZvsiqtGolfElhXlEfsVpBVvwIOwuSUIa+L6Rm
         3MSFpRRpUxvTQ==
Received: by mail-yb1-f177.google.com with SMTP id g14so17710409ybs.8;
        Thu, 13 Jan 2022 10:55:50 -0800 (PST)
X-Gm-Message-State: AOAM533yiDf0P0r/Iqf6pm1e2kSvcGTE8i2Gu5oACq8Ucj+XAi1GhktE
        B4XBX4TxZ2iefTgUsMqIwQVJlVLFJUN9wwGbSKQ=
X-Google-Smtp-Source: ABdhPJzy3uH8nfMkDWu9YayjnvJO6vmodvRntm4s02doIFEXvE99PxC88E0Afwy1DsXL6Pagrbovz9ItsUsin/jxvRQ=
X-Received: by 2002:a25:8b85:: with SMTP id j5mr7726044ybl.558.1642100149669;
 Thu, 13 Jan 2022 10:55:49 -0800 (PST)
MIME-Version: 1.0
References: <20220113070245.791577-1-imagedong@tencent.com>
In-Reply-To: <20220113070245.791577-1-imagedong@tencent.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 13 Jan 2022 10:55:38 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5zf3MqJL+tJtHTd-hYSwpUpeAvduhL7uy2T=T2+eLQug@mail.gmail.com>
Message-ID: <CAPhsuW5zf3MqJL+tJtHTd-hYSwpUpeAvduhL7uy2T=T2+eLQug@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct bpf_sock'
To:     menglong8.dong@gmail.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        mengensun@tencent.com, flyingpeng@tencent.com,
        mungerjiang@tencent.com, Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 11:03 PM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> The description of 'dst_port' in 'struct bpf_sock' is not accurated.
> In fact, 'dst_port' is not in network byte order, it is 'partly' in
> network byte order.
>
> We can see it in bpf_sock_convert_ctx_access():
>
> > case offsetof(struct bpf_sock, dst_port):
> >       *insn++ = BPF_LDX_MEM(
> >               BPF_FIELD_SIZEOF(struct sock_common, skc_dport),
> >               si->dst_reg, si->src_reg,
> >               bpf_target_off(struct sock_common, skc_dport,
> >                              sizeof_field(struct sock_common,
> >                                           skc_dport),
> >                              target_size));
>
> It simply passes 'sock_common->skc_dport' to 'bpf_sock->dst_port',
> which makes that the low 16-bits of 'dst_port' is equal to 'skc_port'
> and is in network byte order, but the high 16-bites of 'dst_port' is
> 0. And the actual port is 'bpf_ntohs((__u16)dst_port)', and
> 'bpf_ntohl(dst_port)' is totally not the right port.
>
> This is different form 'remote_port' in 'struct bpf_sock_ops' or
> 'struct __sk_buff':
>
> > case offsetof(struct __sk_buff, remote_port):
> >       BUILD_BUG_ON(sizeof_field(struct sock_common, skc_dport) != 2);
> >
> >       *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, sk),
> >                             si->dst_reg, si->src_reg,
> >                                     offsetof(struct sk_buff, sk));
> >       *insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->dst_reg,
> >                             bpf_target_off(struct sock_common,
> >                                            skc_dport,
> >                                            2, target_size));
> > #ifndef __BIG_ENDIAN_BITFIELD
> >       *insn++ = BPF_ALU32_IMM(BPF_LSH, si->dst_reg, 16);
> > #endif
>
> We can see that it will left move 16-bits in little endian, which makes
> the whole 'remote_port' is in network byte order, and the actual port
> is bpf_ntohl(remote_port).
>
> Note this in the document of 'dst_port'. ( Maybe this should be unified
> in the code? )
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  include/uapi/linux/bpf.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b0383d371b9a..891a182a749a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5500,7 +5500,11 @@ struct bpf_sock {
>         __u32 src_ip4;
>         __u32 src_ip6[4];
>         __u32 src_port;         /* host byte order */
> -       __u32 dst_port;         /* network byte order */
> +       __u32 dst_port;         /* low 16-bits are in network byte order,
> +                                * and high 16-bits are filled by 0.
> +                                * So the real port in host byte order is
> +                                * bpf_ntohs((__u16)dst_port).
> +                                */
>         __u32 dst_ip4;
>         __u32 dst_ip6[4];
>         __u32 state;
> --
> 2.34.1
>
