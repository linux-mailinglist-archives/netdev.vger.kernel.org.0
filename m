Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1A53B150D
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 09:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhFWHrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 03:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFWHrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 03:47:41 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EDCC061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 00:45:22 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id d2so1687062ljj.11
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 00:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HhAnOZMYs54+Lm6hRjoUog+UNvdxRH8o7h8b6M+0x/U=;
        b=p4oeOjg0uqNV2SYAkaIU8R8LswArTp7dMczIxJhe+rizs3QbdwpohjOnNKRDqziNU8
         lvVDf9Rg+lWATPdKkFLZYSbmpXXU0s/yUMOzbAmvRJ+bAhJNilO0DgkMwJfbETTMpFRI
         QspkM/VjVRidnGQ/4aC2yvyOcFtdJU9zeNB68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HhAnOZMYs54+Lm6hRjoUog+UNvdxRH8o7h8b6M+0x/U=;
        b=ErzwRiOrEX09B3WMW0K/z/wfvEZjoisOCoZlSigtBTkfaBDwkfQjHHYREvlqVrM2ms
         5p/rTgqfHVeo8Wo2KPJDKf3yAvad8EZL7aKuN2wmurZJtTbWg1tXPBoPYhv/fAS7rPpx
         fBbGZ7Py/KY5friOV7Jjvg4tp71CmuO+iFmYcj7fwmNXc/IjASz3az5Q+QaEWrDwKzW3
         2XKnb6qiTR61JC5e1mD8bab17htY1WdC51L8seGhc6JIRazSHEM8KSeHpTK8vwZlCP9q
         6dyZT5or5Vwf76ww6QiSoAHvyrWlLOG6WfoE6WKZoJ2j32X4TAGPt0SmsVyvO1YJsb7y
         ooPw==
X-Gm-Message-State: AOAM5307MS9sRmiNKhP8m+ZwJAFrQsOe1yddwvEpjaOBlw6HpMXhJu7m
        KPJooVnORlBope2n8Co9IIQfgv1Lr4aqUl8fQ28eSg==
X-Google-Smtp-Source: ABdhPJxkFI2SIHFa/7DJF+F+t9RQX1bJo3YczdWDejB+hu5TIS01DkfLAsFKYEzJB4wFdF+a4rc/vcixW6p5ubcbaRw=
X-Received: by 2002:a2e:8853:: with SMTP id z19mr6874428ljj.226.1624434320710;
 Wed, 23 Jun 2021 00:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210622202623.1311901-1-m@lambda.lt>
In-Reply-To: <20210622202623.1311901-1-m@lambda.lt>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 23 Jun 2021 08:45:09 +0100
Message-ID: <CACAyw99Lf=tEOiQBYY8muV=uUSMQjuksdRDWHLqnyKwC_tEnRA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: retrieve netns cookie via getsocketopt
To:     Martynas Pumputis <m@lambda.lt>
Cc:     Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 at 21:24, Martynas Pumputis <m@lambda.lt> wrote:
>
> It's getting more common to run nested container environments for
> testing cloud software. One of such examples is Kind [1] which runs a
> Kubernetes cluster in Docker containers on a single host. Each container
> acts as a Kubernetes node, and thus can run any Pod (aka container)
> inside the former. This approach simplifies testing a lot, as it
> eliminates complicated VM setups.
>
> Unfortunately, such a setup breaks some functionality when cgroupv2 BPF
> programs are used for load-balancing. The load-balancer BPF program
> needs to detect whether a request originates from the host netns or a
> container netns in order to allow some access, e.g. to a service via a
> loopback IP address. Typically, the programs detect this by comparing
> netns cookies with the one of the init ns via a call to
> bpf_get_netns_cookie(NULL). However, in nested environments the latter
> cannot be used given the Kubernetes node's netns is outside the init ns.
> To fix this, we need to pass the Kubernetes node netns cookie to the
> program in a different way: by extending getsockopt() with a
> SO_NETNS_COOKIE option, the orchestrator which runs in the Kubernetes
> node netns can retrieve the cookie and pass it to the program instead.
>
> Thus, this is following up on Eric's commit 3d368ab87cf6 ("net:
> initialize net->net_cookie at netns setup") to allow retrieval via
> SO_NETNS_COOKIE.  This is also in line in how we retrieve socket cookie
> via SO_COOKIE.
>
>   [1] https://kind.sigs.k8s.io/
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Martynas Pumputis <m@lambda.lt>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
>  arch/alpha/include/uapi/asm/socket.h  | 2 ++
>  arch/mips/include/uapi/asm/socket.h   | 2 ++
>  arch/parisc/include/uapi/asm/socket.h | 2 ++
>  arch/sparc/include/uapi/asm/socket.h  | 2 ++
>  include/uapi/asm-generic/socket.h     | 2 ++
>  net/core/sock.c                       | 9 +++++++++
>  6 files changed, 19 insertions(+)
>
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index 57420356ce4c..6b3daba60987 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -127,6 +127,8 @@
>  #define SO_PREFER_BUSY_POLL    69
>  #define SO_BUSY_POLL_BUDGET    70
>
> +#define SO_NETNS_COOKIE                71
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index 2d949969313b..cdf404a831b2 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -138,6 +138,8 @@
>  #define SO_PREFER_BUSY_POLL    69
>  #define SO_BUSY_POLL_BUDGET    70
>
> +#define SO_NETNS_COOKIE                71
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index f60904329bbc..5b5351cdcb33 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -119,6 +119,8 @@
>  #define SO_PREFER_BUSY_POLL    0x4043
>  #define SO_BUSY_POLL_BUDGET    0x4044
>
> +#define SO_NETNS_COOKIE                0x4045
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index 848a22fbac20..92675dc380fa 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -120,6 +120,8 @@
>  #define SO_PREFER_BUSY_POLL     0x0048
>  #define SO_BUSY_POLL_BUDGET     0x0049
>
> +#define SO_NETNS_COOKIE          0x0050
> +
>  #if !defined(__KERNEL__)
>
>
> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> index 4dcd13d097a9..d588c244ec2f 100644
> --- a/include/uapi/asm-generic/socket.h
> +++ b/include/uapi/asm-generic/socket.h
> @@ -122,6 +122,8 @@
>  #define SO_PREFER_BUSY_POLL    69
>  #define SO_BUSY_POLL_BUDGET    70
>
> +#define SO_NETNS_COOKIE                71
> +
>  #if !defined(__KERNEL__)
>
>  #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
> diff --git a/net/core/sock.c b/net/core/sock.c
> index ddfa88082a2b..462fe1fb2056 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1635,6 +1635,15 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
>                 v.val = sk->sk_bound_dev_if;
>                 break;
>
> +#ifdef CONFIG_NET_NS

Nit: sock_net already takes care of CONFIG_NET_NS and returns the root
ns if !NET_NS, so this define is not necessary. I think this behaviour
is nicer: uapi stays consistent even if kernel config changes.

> +       case SO_NETNS_COOKIE:
> +               lv = sizeof(u64);
> +               if (len != lv)
> +                       return -EINVAL;
> +               v.val64 = sock_net(sk)->net_cookie;
> +               break;
> +#endif
> +
>         default:
>                 /* We implement the SO_SNDLOWAT etc to not be settable
>                  * (1003.1g 7).
> --
> 2.32.0
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
