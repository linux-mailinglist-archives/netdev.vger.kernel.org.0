Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C666C40CC
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 04:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCVDLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 23:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjCVDLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 23:11:01 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F2E7DA8
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 20:10:59 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id d2so8910040vso.9
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 20:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679454659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHK0qxxBwxJR2pXZAjtQf6aZHM/X+GsNOkIYt52WU7I=;
        b=S19MPu+n4LMZxd9JKs+r9It0uIr/DW2PIsB1vmXkZHOVCQcAW825GPQA7Bntq4gcSw
         10jnnwNIrhIbVNw5WDyCNHni4IW0dcpZhntHdQhBbSXIJLr1srS+g4HMRZnl2jUyygWW
         obZSVfklJj9Gi4NRJqDnqn1EScCryCNnogciyw8hsytxl92mMc8bFMRUaUQxkWEboiLr
         XUCjgRon73LRwTYH92zky9YgkoGD5mMqbxXV6S0ncBXRZjlQ3yMx0mS49LY6lqEXGdNg
         XQa3Q8v2Y2Cu9HtlJgorQInVQDP+sL1TG9yUZP22sNWQ2NJmanyx9OHA6cy642NnS1mZ
         HnMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679454659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xHK0qxxBwxJR2pXZAjtQf6aZHM/X+GsNOkIYt52WU7I=;
        b=SoVVjNh9uM+WWmmK5c2qanufssyiqhKV4HHByTt7hAw19bMMm8nFQqRk04YL78fJah
         cIwy6QYkGd3t58J/RE8trPLBw9GvUJUv934tegXR/JBZ9lFICDrOmw0Nw6nK7233KH15
         j89gQYm3u3z0ctDfs6nlvIf1IjrqxMCzGo9DNgTCz7+rcf8jKzVpHmVYMVPx04Qp3hwG
         5c+iQj2abrBRIBRylFVkuVv2odE/691J16Ys+JS0RKBWB/efKweXO+bC83w85hooyYOE
         Z2yWYy1bDJ2iN0mL9DnRBLZE5ULDzQfTb2vu3nHtYS3Fhf+d9VcBqzAmTDTb55Z8Bxo4
         d+qQ==
X-Gm-Message-State: AO0yUKXSmMmffmaFYwmW530wC8j6IlbDywADIIyOqotLbSnG7mjr/V1f
        AmTizrRaTu0L08XkMMk48d44jwKHJ4i4dJHD+8HpMA==
X-Google-Smtp-Source: AK7set/KafluPjB6by5B/RNC7omj7IZaGd48nl+nbC0T59D0GxLp5Zisb0H80CftU1oqPIdj19VOesBJSenpDDYFnI4=
X-Received: by 2002:a67:c182:0:b0:425:cf00:e332 with SMTP id
 h2-20020a67c182000000b00425cf00e332mr2851292vsj.7.1679454658639; Tue, 21 Mar
 2023 20:10:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230321215212.525630-1-john.fastabend@gmail.com> <20230321215212.525630-8-john.fastabend@gmail.com>
In-Reply-To: <20230321215212.525630-8-john.fastabend@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Mar 2023 20:10:46 -0700
Message-ID: <CANn89i+gbRZYzjSFR2N_xpBaFaB+0ShOgQo1EXBk-R7k1_t_8Q@mail.gmail.com>
Subject: Re: [PATCH bpf 07/11] bpf: sockmap incorrectly handling copied_seq
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 2:52=E2=80=AFPM John Fastabend <john.fastabend@gmai=
l.com> wrote:
>
> The read_skb() logic is incrementing the tcp->copied_seq which is used fo=
r
> among other things calculating how many outstanding bytes can be read by
> the application. This results in application errors, if the application
> does an ioctl(FIONREAD) we return zero because this is calculated from
> the copied_seq value.
>
> To fix this we move tcp->copied_seq accounting into the recv handler so
> that we update these when the recvmsg() hook is called and data is in
> fact copied into user buffers. This gives an accurate FIONREAD value
> as expected and improves ACK handling. Before we were calling the
> tcp_rcv_space_adjust() which would update 'number of bytes copied to
> user in last RTT' which is wrong for programs returning SK_PASS. The
> bytes are only copied to the user when recvmsg is handled.
>
> Doing the fix for recvmsg is straightforward, but fixing redirect and
> SK_DROP pkts is a bit tricker. Build a tcp_psock_eat() helper and then
> call this from skmsg handlers. This fixes another issue where a broken
> socket with a BPF program doing a resubmit could hang the receiver. This
> happened because although read_skb() consumed the skb through sock_drop()
> it did not update the copied_seq. Now if a single reccv socket is
> redirecting to many sockets (for example for lb) the receiver sk will be
> hung even though we might expect it to continue. The hang comes from
> not updating the copied_seq numbers and memory pressure resulting from
> that.
>
> We have a slight layer problem of calling tcp_eat_skb even if its not
> a TCP socket. To fix we could refactor and create per type receiver
> handlers. I decided this is more work than we want in the fix and we
> already have some small tweaks depending on caller that use the
> helper skb_bpf_strparser(). So we extend that a bit and always set
> the strparser bit when it is in use and then we can gate the
> seq_copied updates on this.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  include/net/tcp.h  |  3 +++
>  net/core/skmsg.c   |  7 +++++--
>  net/ipv4/tcp.c     | 10 +---------
>  net/ipv4/tcp_bpf.c | 28 +++++++++++++++++++++++++++-
>  4 files changed, 36 insertions(+), 12 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index db9f828e9d1e..674044b8bdaf 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1467,6 +1467,8 @@ static inline void tcp_adjust_rcv_ssthresh(struct s=
ock *sk)
>  }
>
>  void tcp_cleanup_rbuf(struct sock *sk, int copied);
> +void __tcp_cleanup_rbuf(struct sock *sk, int copied);
> +
>
>  /* We provision sk_rcvbuf around 200% of sk_rcvlowat.
>   * If 87.5 % (7/8) of the space has been consumed, we want to override
> @@ -2321,6 +2323,7 @@ struct sk_psock;
>  struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)=
;
>  int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool r=
estore);
>  void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
> +void tcp_eat_skb(struct sock *sk, struct sk_buff *skb);
>  #endif /* CONFIG_BPF_SYSCALL */
>
>  int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 10e5481da662..b141b422697c 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -1051,11 +1051,14 @@ static int sk_psock_verdict_apply(struct sk_psock=
 *psock, struct sk_buff *skb,
>                 mutex_unlock(&psock->work_mutex);
>                 break;
>         case __SK_REDIRECT:
> +               tcp_eat_skb(psock->sk, skb);
>                 err =3D sk_psock_skb_redirect(psock, skb);
>                 break;
>         case __SK_DROP:
>         default:
>  out_free:
> +               tcp_eat_skb(psock->sk, skb);
> +               skb_bpf_redirect_clear(skb);
>                 sock_drop(psock->sk, skb);
>         }
>
> @@ -1100,8 +1103,7 @@ static void sk_psock_strp_read(struct strparser *st=
rp, struct sk_buff *skb)
>                 skb_dst_drop(skb);
>                 skb_bpf_redirect_clear(skb);
>                 ret =3D bpf_prog_run_pin_on_cpu(prog, skb);
> -               if (ret =3D=3D SK_PASS)
> -                       skb_bpf_set_strparser(skb);
> +               skb_bpf_set_strparser(skb);
>                 ret =3D sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb=
));
>                 skb->sk =3D NULL;
>         }
> @@ -1207,6 +1209,7 @@ static int sk_psock_verdict_recv(struct sock *sk, s=
truct sk_buff *skb)
>         psock =3D sk_psock(sk);
>         if (unlikely(!psock)) {
>                 len =3D 0;
> +               tcp_eat_skb(sk, skb);
>                 sock_drop(sk, skb);
>                 goto out;
>         }
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 6572962b0237..e2594d8e3429 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1568,7 +1568,7 @@ static int tcp_peek_sndq(struct sock *sk, struct ms=
ghdr *msg, int len)
>   * calculation of whether or not we must ACK for the sake of
>   * a window update.
>   */
> -static void __tcp_cleanup_rbuf(struct sock *sk, int copied)
> +void __tcp_cleanup_rbuf(struct sock *sk, int copied)
>  {
>         struct tcp_sock *tp =3D tcp_sk(sk);
>         bool time_to_ack =3D false;
> @@ -1783,14 +1783,6 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t=
 recv_actor)
>                         break;
>                 }
>         }
> -       WRITE_ONCE(tp->copied_seq, seq);
> -
> -       tcp_rcv_space_adjust(sk);
> -
> -       /* Clean up data we have read: This will do ACK frames. */
> -       if (copied > 0)
> -               __tcp_cleanup_rbuf(sk, copied);
> -
>         return copied;
>  }
>  EXPORT_SYMBOL(tcp_read_skb);
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index b1ba58be0c5a..c0e5680dccc0 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -11,6 +11,24 @@
>  #include <net/inet_common.h>
>  #include <net/tls.h>
>
> +void tcp_eat_skb(struct sock *sk, struct sk_buff *skb)
> +{
> +       struct tcp_sock *tcp;
> +       int copied;
> +
> +       if (!skb || !skb->len || !sk_is_tcp(sk))
> +               return;
> +
> +       if (skb_bpf_strparser(skb))
> +               return;
> +
> +       tcp =3D tcp_sk(sk);
> +       copied =3D tcp->copied_seq + skb->len;
> +       WRITE_ONCE(tcp->copied_seq, skb->len);

It seems your tests are unable to catch this bug :/

> +       tcp_rcv_space_adjust(sk);
> +       __tcp_cleanup_rbuf(sk, skb->len);
> +}
> +
>  static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
>                            struct sk_msg *msg, u32 apply_bytes, int flags=
)
>  {
> @@ -198,8 +216,10 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
>                                   int flags,
>                                   int *addr_len)
>  {
> +       struct tcp_sock *tcp =3D tcp_sk(sk);
> +       u32 seq =3D tcp->copied_seq;
>         struct sk_psock *psock;
> -       int copied;
> +       int copied =3D 0;
>
>         if (unlikely(flags & MSG_ERRQUEUE))
>                 return inet_recv_error(sk, msg, len, addr_len);
> @@ -241,9 +261,11 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
>
>                 if (is_fin) {
>                         copied =3D 0;
> +                       seq++;
>                         goto out;
>                 }
>         }
> +       seq +=3D copied;
>         if (!copied) {
>                 long timeo;
>                 int data;
> @@ -281,6 +303,10 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
>                 copied =3D -EAGAIN;
>         }
>  out:
> +       WRITE_ONCE(tcp->copied_seq, seq);
> +       tcp_rcv_space_adjust(sk);
> +       if (copied > 0)
> +               __tcp_cleanup_rbuf(sk, copied);
>         release_sock(sk);
>         sk_psock_put(sk, psock);
>         return copied;
> --
> 2.33.0
>
