Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC91244617
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391677AbfFMQtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:49:06 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46843 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbfFMEjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 00:39:55 -0400
Received: by mail-qk1-f193.google.com with SMTP id a132so11856554qkb.13;
        Wed, 12 Jun 2019 21:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M2dvxFFbIfDQiI0YloaAcscMAFnZ0gYN51kqRsuL/SI=;
        b=ZWXhzVQ6m9TD7f8HgWMCKsCpHK/vOSYM3QcvyHd/DGEbjzeE3fkT1Z2u9+Hk35pIwU
         30H38OdMYcr91aRWAz26ZBbpWJvIozcRoqrXpKTDJjbB/2hG8H35OwsgXh+VCeLzOpu4
         dxY926sazMYiGN6FVTslsRWE4Y3jqKlfJQ101ed4HOIpIHRfY63QPKj3WRGVni72LumP
         CEy/rLkFlVacOfsCJXFjZ0QnDbnJmfEeOui+Ee4I+GIXH1Ueo7QgNMb+EVDA7wD9rlEq
         4erEjom5KGD/UVFHj2S7RjiiYW6J2f83vMPqkxW2gSpUdKP142f56rvTwrJCikkDFy3c
         xs4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M2dvxFFbIfDQiI0YloaAcscMAFnZ0gYN51kqRsuL/SI=;
        b=nxyBlS91BFJJTSDRl0K7gcpIZ9mpxFav7kEH756FHwkbJ2Z4NaRCHoPUS+OYKlItaK
         Tlo+YYtN8fO7h148y3Ijy4IwvCvCoE4SPMLmkcDBIQXJOTt9SwmaPikIrIFgqPBI1c9N
         00UJl43qRUXPngRQkgXHfrF8VEHtQ2SOXkntbAF8mJghV7vHdUJQLNE61bfMjKKAX1ax
         J5pdPurPHRRc3RAWpdyfalWq54/ozKvLStyuJD4rjjyYRsvMAEhG6hmuJ86EVrEx+jsE
         LwOeDoiZPeQ1yC4E9YD7VfuIGg5TjpSGipZy7XTE8F9p0WP3W6mohId060rZ9oZKMKbB
         Wa8Q==
X-Gm-Message-State: APjAAAUrEGPZvCTTBlGxAUsXXuanGIhyUMoE6HyPXWHf1P6uCMzAaClN
        h6RqQRMb1MZ8c5OObJalx0E1XQkKh5e6d5KSXp0=
X-Google-Smtp-Source: APXvYqzgEoHoxnO+QOmIicnL+I+T+rGc7CqGgQlg35MG9ss78k1aW07wObg+0IPOXzJ3lyhP1Vyxi/KRjuWlHCIaeVM=
X-Received: by 2002:a05:620a:14a8:: with SMTP id x8mr13830262qkj.35.1560400793606;
 Wed, 12 Jun 2019 21:39:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190612190536.2340077-1-kafai@fb.com> <20190612190537.2340206-1-kafai@fb.com>
In-Reply-To: <20190612190537.2340206-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 Jun 2019 21:39:42 -0700
Message-ID: <CAEf4BzZX=fqxKGi_ptCtLnt7YSr4V4PJ8GQYADR55Y1yk-Azcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: net: Add SO_DETACH_REUSEPORT_BPF
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Craig Gallek <kraig@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 12:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> There is SO_ATTACH_REUSEPORT_[CE]BPF but there is no DETACH.
> This patch adds SO_DETACH_REUSEPORT_BPF sockopt.  The same
> sockopt can be used to undo both SO_ATTACH_REUSEPORT_[CE]BPF.
>
> reseport_detach_prog() is added and it is mostly a mirror
> of the existing reuseport_attach_prog().  The differences are,
> it does not call reuseport_alloc() and returns -ENOENT when
> there is no old prog.
>
> Cc: Craig Gallek <kraig@google.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  arch/alpha/include/uapi/asm/socket.h  |  2 ++
>  arch/mips/include/uapi/asm/socket.h   |  2 ++
>  arch/parisc/include/uapi/asm/socket.h |  2 ++
>  arch/sparc/include/uapi/asm/socket.h  |  2 ++
>  include/net/sock_reuseport.h          |  2 ++
>  include/uapi/asm-generic/socket.h     |  2 ++
>  net/core/sock.c                       |  4 ++++
>  net/core/sock_reuseport.c             | 24 ++++++++++++++++++++++++
>  8 files changed, 40 insertions(+)
>
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index 976e89b116e5..de6c4df61082 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -122,6 +122,8 @@
>  #define SO_RCVTIMEO_NEW         66
>  #define SO_SNDTIMEO_NEW         67
>
> +#define SO_DETACH_REUSEPORT_BPF 68
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index d41765cfbc6e..d0a9ed2ca2d6 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -133,6 +133,8 @@
>  #define SO_RCVTIMEO_NEW         66
>  #define SO_SNDTIMEO_NEW         67
>
> +#define SO_DETACH_REUSEPORT_BPF 68
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index 66c5dd245ac7..10173c32195e 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -114,6 +114,8 @@
>  #define SO_RCVTIMEO_NEW         0x4040
>  #define SO_SNDTIMEO_NEW         0x4041
>
> +#define SO_DETACH_REUSEPORT_BPF 0x4042
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index 9265a9eece15..1895ac112a24 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -115,6 +115,8 @@
>  #define SO_RCVTIMEO_NEW          0x0044
>  #define SO_SNDTIMEO_NEW          0x0045
>
> +#define SO_DETACH_REUSEPORT_BPF  0x0046
> +
>  #if !defined(__KERNEL__)
>
>
> diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> index 8a5f70c7cdf2..d9112de85261 100644
> --- a/include/net/sock_reuseport.h
> +++ b/include/net/sock_reuseport.h
> @@ -35,6 +35,8 @@ extern struct sock *reuseport_select_sock(struct sock *sk,
>                                           struct sk_buff *skb,
>                                           int hdr_len);
>  extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
> +extern int reuseport_detach_prog(struct sock *sk);
> +
>  int reuseport_get_id(struct sock_reuseport *reuse);
>
>  #endif  /* _SOCK_REUSEPORT_H */
> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> index 8c1391c89171..77f7c1638eb1 100644
> --- a/include/uapi/asm-generic/socket.h
> +++ b/include/uapi/asm-generic/socket.h
> @@ -117,6 +117,8 @@
>  #define SO_RCVTIMEO_NEW         66
>  #define SO_SNDTIMEO_NEW         67
>
> +#define SO_DETACH_REUSEPORT_BPF 68
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 75b1c950b49f..06be30737b69 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1045,6 +1045,10 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>                 }
>                 break;
>
> +       case SO_DETACH_REUSEPORT_BPF:
> +               ret = reuseport_detach_prog(sk);
> +               break;
> +
>         case SO_DETACH_FILTER:
>                 ret = sk_detach_filter(sk);
>                 break;
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index dc4aefdf2a08..e0cb29469fa7 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -332,3 +332,27 @@ int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
>         return 0;
>  }
>  EXPORT_SYMBOL(reuseport_attach_prog);
> +
> +int reuseport_detach_prog(struct sock *sk)
> +{
> +       struct sock_reuseport *reuse;
> +       struct bpf_prog *old_prog;
> +
> +       if (!rcu_access_pointer(sk->sk_reuseport_cb))
> +               return sk->sk_reuseport ? -ENOENT : -EINVAL;
> +
> +       spin_lock_bh(&reuseport_lock);
> +       reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> +                                         lockdep_is_held(&reuseport_lock));
> +       old_prog = rcu_dereference_protected(reuse->prog,
> +                                            lockdep_is_held(&reuseport_lock));
> +       RCU_INIT_POINTER(reuse->prog, NULL);
> +       spin_unlock_bh(&reuseport_lock);
> +
> +       if (!old_prog)
> +               return -ENOENT;
> +
> +       sk_reuseport_prog_free(old_prog);
> +       return 0;
> +}
> +EXPORT_SYMBOL(reuseport_detach_prog);
> --
> 2.17.1
>
