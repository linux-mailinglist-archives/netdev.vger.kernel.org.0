Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F9B5A1858
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242986AbiHYSHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbiHYSHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:07:49 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EAEBD10D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:07:47 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u22so19172266plq.12
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=N/8DuNhBsJCfQQOnZPVC8hWFa5C0wn9sWbIDiP7z2E0=;
        b=kmevD9JcgW6BWcyGTzbziOz0nYFB4K4qqTNZE2I2x9KcthoJ3hgaetJDpFJ+o+MF9F
         0giDPpGoJMDQJjp7x7PkD2LQfbAHcGeR6qJcD0Moc4uJuA+g4yL89/7+35O2GAn33uN2
         6s4Fawkha1Ib8c00lYdemJHajlkN+WORrM9fSZHkMVNZQKAtSgcXws+9nVpOhrNNOaZo
         TL3RqoUZ1VVEdtErx+hTtsZIsBKP7Aeo3c72AeWlF5J6dPrcWRE98SHrnm9jHaJi3tVy
         9+Y9oBDMnOeZBA0/NiApYK749X07/Y8kHONkm34vkjODENg7fIqOCHc80FxYVTYha/y+
         S6xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=N/8DuNhBsJCfQQOnZPVC8hWFa5C0wn9sWbIDiP7z2E0=;
        b=0sYpReu3OJRA4mpVc9qUqvwQEc5xv14v/T7cObmux8s0FlizXe/fUFMVdBULG4m/AP
         BR4ifcZq2rKqkXpVbr58KSJutwPC//QGPhcqZNr4zHoFW+kV5l7Hc1FfYH7E9RDp3O9c
         o3GSCmuhUmkCA56+UC0N2tEK4RsHiCx1b6FU79xhc7XeQoAe5FyHWAKGv4e0ESoS0wmN
         C1UcBrYcOtn902vaXxTHfLirJ0AASBkJpYgIO/0ONIKzXcAEZbrOFSumvZmyKTVgXEuB
         GHc4vG3cN8doYYCITgSMhMbc5Huat6vNDqHcgE5SXzpBSkVEAd+b8KkJtUoDE60dFFf4
         EjHw==
X-Gm-Message-State: ACgBeo3WNeBWWg48yhAVfuoIrCG1uOPtxpHmo2sYqTJG+ekVQnrpO862
        pYE38lNyya1yzpsawBiwgrnbxJFCjxRRtM0d2u+yVg==
X-Google-Smtp-Source: AA6agR6TBAVSZfbS+YQgVAvkbJ3vuUK0QLplw2Z3smcUwMHjrHxaSEVzSfkQuvxHLuYHJYeuASrhmkPeFVyFwbVpTts=
X-Received: by 2002:a17:90b:388e:b0:1f5:40d4:828d with SMTP id
 mu14-20020a17090b388e00b001f540d4828dmr240475pjb.31.1661450867145; Thu, 25
 Aug 2022 11:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220824222601.1916776-1-kafai@fb.com> <20220824222614.1918332-1-kafai@fb.com>
In-Reply-To: <20220824222614.1918332-1-kafai@fb.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 25 Aug 2022 11:07:36 -0700
Message-ID: <CAKH8qBtT332XrJ3aEw=o_9K+g6LYHbdhPG7s8R1uuNbKBso0+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/17] bpf: net: Change sk_getsockopt() to take
 the sockptr_t argument
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 3:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch changes sk_getsockopt() to take the sockptr_t argument
> such that it can be used by bpf_getsockopt(SOL_SOCKET) in a
> latter patch.
>
> security_socket_getpeersec_stream() is not changed.  It stays
> with the __user ptr (optval.user and optlen.user) to avoid changes
> to other security hooks.  bpf_getsockopt(SOL_SOCKET) also does not
> support SO_PEERSEC.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/filter.h  |  3 +--
>  include/linux/sockptr.h |  5 +++++
>  net/core/filter.c       |  5 ++---
>  net/core/sock.c         | 43 +++++++++++++++++++++++------------------
>  4 files changed, 32 insertions(+), 24 deletions(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index a5f21dc3c432..527ae1d64e27 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -900,8 +900,7 @@ int sk_reuseport_attach_filter(struct sock_fprog *fprog, struct sock *sk);
>  int sk_reuseport_attach_bpf(u32 ufd, struct sock *sk);
>  void sk_reuseport_prog_free(struct bpf_prog *prog);
>  int sk_detach_filter(struct sock *sk);
> -int sk_get_filter(struct sock *sk, struct sock_filter __user *filter,
> -                 unsigned int len);
> +int sk_get_filter(struct sock *sk, sockptr_t optval, unsigned int len);
>
>  bool sk_filter_charge(struct sock *sk, struct sk_filter *fp);
>  void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp);
> diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
> index d45902fb4cad..bae5e2369b4f 100644
> --- a/include/linux/sockptr.h
> +++ b/include/linux/sockptr.h
> @@ -64,6 +64,11 @@ static inline int copy_to_sockptr_offset(sockptr_t dst, size_t offset,
>         return 0;
>  }
>
> +static inline int copy_to_sockptr(sockptr_t dst, const void *src, size_t size)
> +{
> +       return copy_to_sockptr_offset(dst, 0, src, size);
> +}
> +
>  static inline void *memdup_sockptr(sockptr_t src, size_t len)
>  {
>         void *p = kmalloc_track_caller(len, GFP_USER | __GFP_NOWARN);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 63e25d8ce501..0f6f86b9e487 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -10712,8 +10712,7 @@ int sk_detach_filter(struct sock *sk)
>  }
>  EXPORT_SYMBOL_GPL(sk_detach_filter);
>
> -int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
> -                 unsigned int len)
> +int sk_get_filter(struct sock *sk, sockptr_t optval, unsigned int len)
>  {
>         struct sock_fprog_kern *fprog;
>         struct sk_filter *filter;
> @@ -10744,7 +10743,7 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
>                 goto out;
>
>         ret = -EFAULT;
> -       if (copy_to_user(ubuf, fprog->filter, bpf_classic_proglen(fprog)))
> +       if (copy_to_sockptr(optval, fprog->filter, bpf_classic_proglen(fprog)))
>                 goto out;
>
>         /* Instead of bytes, the API requests to return the number
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 21bc4bf6b485..7fa30fd4b37f 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -712,8 +712,8 @@ static int sock_setbindtodevice(struct sock *sk, sockptr_t optval, int optlen)
>         return ret;
>  }
>
> -static int sock_getbindtodevice(struct sock *sk, char __user *optval,
> -                               int __user *optlen, int len)
> +static int sock_getbindtodevice(struct sock *sk, sockptr_t optval,
> +                               sockptr_t optlen, int len)
>  {
>         int ret = -ENOPROTOOPT;
>  #ifdef CONFIG_NETDEVICES
> @@ -737,12 +737,12 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
>         len = strlen(devname) + 1;
>
>         ret = -EFAULT;
> -       if (copy_to_user(optval, devname, len))
> +       if (copy_to_sockptr(optval, devname, len))
>                 goto out;
>
>  zero:
>         ret = -EFAULT;
> -       if (put_user(len, optlen))
> +       if (copy_to_sockptr(optlen, &len, sizeof(int)))
>                 goto out;
>
>         ret = 0;
> @@ -1568,20 +1568,23 @@ static void cred_to_ucred(struct pid *pid, const struct cred *cred,
>         }
>  }
>
> -static int groups_to_user(gid_t __user *dst, const struct group_info *src)
> +static int groups_to_user(sockptr_t dst, const struct group_info *src)
>  {
>         struct user_namespace *user_ns = current_user_ns();
>         int i;
>
> -       for (i = 0; i < src->ngroups; i++)
> -               if (put_user(from_kgid_munged(user_ns, src->gid[i]), dst + i))
> +       for (i = 0; i < src->ngroups; i++) {
> +               gid_t gid = from_kgid_munged(user_ns, src->gid[i]);
> +
> +               if (copy_to_sockptr_offset(dst, i * sizeof(gid), &gid, sizeof(gid)))
>                         return -EFAULT;
> +       }
>
>         return 0;
>  }
>
>  static int sk_getsockopt(struct sock *sk, int level, int optname,
> -                        char __user *optval, int __user *optlen)
> +                        sockptr_t optval, sockptr_t optlen)
>  {
>         struct socket *sock = sk->sk_socket;
>
> @@ -1600,7 +1603,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
>         int lv = sizeof(int);
>         int len;
>
> -       if (get_user(len, optlen))
> +       if (copy_from_sockptr(&len, optlen, sizeof(int)))

Do we want to be consistent wrt to sizeof?

copy_from_sockptr(&len, optlen, sizeof(int))
vs
copy_from_sockptr(&len, optlen, sizeof(optlen))

Alternatively, should we have put_sockptr/get_sockopt with a semantics
similar to put_user/get_user to remove all this ambiguity?

>                 return -EFAULT;
>         if (len < 0)
>                 return -EINVAL;
> @@ -1735,7 +1738,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
>                 cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
>                 spin_unlock(&sk->sk_peer_lock);
>
> -               if (copy_to_user(optval, &peercred, len))
> +               if (copy_to_sockptr(optval, &peercred, len))
>                         return -EFAULT;
>                 goto lenout;
>         }
> @@ -1753,11 +1756,11 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
>                 if (len < n * sizeof(gid_t)) {
>                         len = n * sizeof(gid_t);
>                         put_cred(cred);
> -                       return put_user(len, optlen) ? -EFAULT : -ERANGE;
> +                       return copy_to_sockptr(optlen, &len, sizeof(int)) ? -EFAULT : -ERANGE;
>                 }
>                 len = n * sizeof(gid_t);
>
> -               ret = groups_to_user((gid_t __user *)optval, cred->group_info);
> +               ret = groups_to_user(optval, cred->group_info);
>                 put_cred(cred);
>                 if (ret)
>                         return ret;
> @@ -1773,7 +1776,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
>                         return -ENOTCONN;
>                 if (lv < len)
>                         return -EINVAL;
> -               if (copy_to_user(optval, address, len))
> +               if (copy_to_sockptr(optval, address, len))
>                         return -EFAULT;
>                 goto lenout;
>         }
> @@ -1790,7 +1793,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
>                 break;
>
>         case SO_PEERSEC:
> -               return security_socket_getpeersec_stream(sock, optval, optlen, len);
> +               return security_socket_getpeersec_stream(sock, optval.user, optlen.user, len);

I'm assuming there should be something to prevent this being called
from BPF? (haven't read all the patches yet)
Do we want to be a bit more defensive with 'if (!optval.user) return
-EFAULT' or something similar?


>         case SO_MARK:
>                 v.val = sk->sk_mark;
> @@ -1822,7 +1825,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
>                 return sock_getbindtodevice(sk, optval, optlen, len);
>
>         case SO_GET_FILTER:
> -               len = sk_get_filter(sk, (struct sock_filter __user *)optval, len);
> +               len = sk_get_filter(sk, optval, len);
>                 if (len < 0)
>                         return len;
>
> @@ -1870,7 +1873,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
>                 sk_get_meminfo(sk, meminfo);
>
>                 len = min_t(unsigned int, len, sizeof(meminfo));
> -               if (copy_to_user(optval, &meminfo, len))
> +               if (copy_to_sockptr(optval, &meminfo, len))
>                         return -EFAULT;
>
>                 goto lenout;
> @@ -1939,10 +1942,10 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
>
>         if (len > lv)
>                 len = lv;
> -       if (copy_to_user(optval, &v, len))
> +       if (copy_to_sockptr(optval, &v, len))
>                 return -EFAULT;
>  lenout:
> -       if (put_user(len, optlen))
> +       if (copy_to_sockptr(optlen, &len, sizeof(int)))
>                 return -EFAULT;
>         return 0;
>  }
> @@ -1950,7 +1953,9 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
>  int sock_getsockopt(struct socket *sock, int level, int optname,
>                     char __user *optval, int __user *optlen)
>  {
> -       return sk_getsockopt(sock->sk, level, optname, optval, optlen);
> +       return sk_getsockopt(sock->sk, level, optname,
> +                            USER_SOCKPTR(optval),
> +                            USER_SOCKPTR(optlen));
>  }
>
>  /*
> --
> 2.30.2
>
