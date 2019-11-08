Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 835FAF3F37
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 06:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfKHFDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 00:03:45 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39075 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfKHFDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 00:03:44 -0500
Received: by mail-qk1-f196.google.com with SMTP id 15so4188231qkh.6;
        Thu, 07 Nov 2019 21:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oZ9NmCe+QKCUl1JcPeiJrOvospkKvnGTD0rfCkZJ57k=;
        b=PjYxSk1n+1U8d1IbXnNrvHPESDYw8nDcsDIjS4f7rBj+I1yVv4GZhQOsWquE1BbxUz
         HNzrmpKY/LUokc3e3F8twmVVQPDGYYRolWBCEPhQRDSRjQUQ1ZqY+7+m8isv7ysQ584f
         p8iFk5ywwdotHwhJppy93g2j1Wr1T44VLSlHZm8OOtx5ONRlbU8xQZsio5P5RZN9xVFu
         uQtaAb/hLNOs7vGMNkw2gh4c713UOJ23MLcNV6EFBvButqclGI4uRB7BzR3dPgbtWirR
         SA6QAtF1Nl1kz7wgO6Qq107pmHYBEdTR3s3FXfir72my6SmwN5TgWJBv4hy7n2mygr5T
         rEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oZ9NmCe+QKCUl1JcPeiJrOvospkKvnGTD0rfCkZJ57k=;
        b=mHl4YkItA/xrQfrRvWJBQReD2hiwJjD/ksD3IbBdvsPLY7lsbzMLDL0KqlzBBtOB7K
         Oz8a15qt3pjq33Gz/QYsOzx+JovFP8m+oaBgTIJnHGsEn0IXNIKHfNulmR3gMfZnjR0q
         rO49CPL9UliCOx3BzMGrrmppECRc0BkmZV0tnaD+Lbu4pYb+EMS1xeo9loRbyRo2/M8a
         vw+G8bSQP1TiDfz3/WjOe6MEoj4dQkV1gTIglcSJCWsQVS8j4S+itPi+qYuy3fHKSJ1K
         OTGUEubDUOdUEKRPvJ6hPfdpb1uB1r8C9kl8sDYaPEMcpvpranhWkXqv/Rjn/o+jgbpS
         Ldfw==
X-Gm-Message-State: APjAAAXbi/RkDpekiGgpbf6flsBtfbp7op5dGDrIIvQbzMEurVjUqrzG
        SHjf0X1w6DZuwKzN5ErfZDNRkVuBEVSateY+sFBJCQ==
X-Google-Smtp-Source: APXvYqwQb7E1b0FjAz4AdCTxke4BudPptxI0nk+Ema767ok0paAgExhMP9j4lE8j5I4cLNR64SB8JWDuBu/16hvLd3U=
X-Received: by 2002:a37:aa8b:: with SMTP id t133mr7433938qke.449.1573189423413;
 Thu, 07 Nov 2019 21:03:43 -0800 (PST)
MIME-Version: 1.0
References: <20191107054644.1285697-1-ast@kernel.org> <20191107054644.1285697-12-ast@kernel.org>
In-Reply-To: <20191107054644.1285697-12-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 7 Nov 2019 21:03:32 -0800
Message-ID: <CAEf4BzZM2+tYPkKK03edzM+H0qcnHD3k=tbzdVQ9qBF8Tjbh0A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 11/17] bpf: Reserver space for BPF trampoline
 in BPF programs
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
> BPF trampoline can be made to work with existing 5 bytes of BPF program
> prologue, but let's add 5 bytes of NOPs to the beginning of every JITed BPF
> program to make BPF trampoline job easier. They can be removed in the future.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  arch/x86/net/bpf_jit_comp.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 44169e8bffc0..260f61276f18 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -206,7 +206,7 @@ struct jit_context {
>  /* number of bytes emit_call() needs to generate call instruction */
>  #define X86_CALL_SIZE          5
>
> -#define PROLOGUE_SIZE          20
> +#define PROLOGUE_SIZE          25

nit: define as 20 + X86_CALL_SIZE ?

[...]
