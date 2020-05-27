Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76B31E4F0B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 22:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgE0USD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 16:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgE0USC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 16:18:02 -0400
X-Greylist: delayed 1089 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 May 2020 13:18:01 PDT
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC47C05BD1E;
        Wed, 27 May 2020 13:18:01 -0700 (PDT)
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 3D3612E14DF;
        Wed, 27 May 2020 23:18:00 +0300 (MSK)
Received: from localhost (localhost [::1])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 5jY0hxews0-HxxWaNOB;
        Wed, 27 May 2020 23:18:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1590610680; bh=3yB6G6GNrY0FeOeLkTcZLnLR95X1u/MBTeJFaFGU8u8=;
        h=Subject:In-Reply-To:Cc:Date:References:To:From:Message-Id;
        b=TZs+VBJMi2JtxzGNAZKFf9QkJqwTRWVTWXTs2H3+hDTcqq7wt0fbeBmOzwpyJst3Y
         nH1Rj2NecRLc8bl3tfSQAZB78rhVnCY7+nvWhcFD1WH9N5jpehnM2d+0FerF6DTOQm
         wziC6X024q8irhfAPOeP0CJmds02DGJhMT+PWGnE=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
X-Yandex-Sender-Uid: 1120000000093952
X-Yandex-Avir: 1
Received: from mxbackcorp2j.mail.yandex.net (localhost [::1])
        by mxbackcorp2j.mail.yandex.net with LMTP id MeQIsvrJmY-KKs6XZzo
        for <zeil@yandex-team.ru>; Wed, 27 May 2020 23:17:49 +0300
Received: by iva8-edafde7c849c.qloud-c.yandex.net with HTTP;
        Wed, 27 May 2020 23:17:48 +0300
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "brakmo@fb.com" <brakmo@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <b5133e4e-4562-1ea0-9d46-c5fb74528ec8@gmail.com>
References: <20200527150543.93335-1-zeil@yandex-team.ru> <b5133e4e-4562-1ea0-9d46-c5fb74528ec8@gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add SO_KEEPALIVE and related options to bpf_setsockopt
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Wed, 27 May 2020 23:17:59 +0300
Message-Id: <158141590610140@mail.yandex-team.ru>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



27.05.2020, 19:43, "Eric Dumazet" <eric.dumazet@gmail.com>:
> On 5/27/20 8:05 AM, Dmitry Yakunin wrote:
>>  This patch adds support of SO_KEEPALIVE flag and TCP related options
>>  to bpf_setsockopt() routine. This is helpful if we want to enable or tune
>>  TCP keepalive for applications which don't do it in the userspace code.
>>  In order to avoid copy-paste, common code from classic setsockopt was moved
>>  to auxiliary functions in the headers.
>
> Please split this in two patches :
> - one adding the helpers, a pure TCP patch.
> - one for BPF additions.

Thanks for your comment.
I've split this into three patches (sock, tcp and bpf) and resent.

>>  Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
>>  ---
>>   include/net/sock.h | 9 +++++++++
>>   include/net/tcp.h | 18 ++++++++++++++++++
>>   net/core/filter.c | 39 ++++++++++++++++++++++++++++++++++++++-
>>   net/core/sock.c | 9 ---------
>>   net/ipv4/tcp.c | 15 ++-------------
>>   5 files changed, 67 insertions(+), 23 deletions(-)
>>
>>  diff --git a/include/net/sock.h b/include/net/sock.h
>>  index 3e8c6d4..ee35dea 100644
>>  --- a/include/net/sock.h
>>  +++ b/include/net/sock.h
>>  @@ -879,6 +879,15 @@ static inline void sock_reset_flag(struct sock *sk, enum sock_flags flag)
>>           __clear_bit(flag, &sk->sk_flags);
>>   }
>>
>>  +static inline void sock_valbool_flag(struct sock *sk, enum sock_flags bit,
>>  + int valbool)
>>  +{
>>  + if (valbool)
>>  + sock_set_flag(sk, bit);
>>  + else
>>  + sock_reset_flag(sk, bit);
>>  +}
>>  +
>>   static inline bool sock_flag(const struct sock *sk, enum sock_flags flag)
>>   {
>>           return test_bit(flag, &sk->sk_flags);
>>  diff --git a/include/net/tcp.h b/include/net/tcp.h
>>  index b681338..ae6a495 100644
>>  --- a/include/net/tcp.h
>>  +++ b/include/net/tcp.h
>>  @@ -1465,6 +1465,24 @@ static inline u32 keepalive_time_elapsed(const struct tcp_sock *tp)
>>                             tcp_jiffies32 - tp->rcv_tstamp);
>>   }
>>
>>  +/* val must be validated at the top level function */
>>  +static inline void keepalive_time_set(struct tcp_sock *tp, int val)
>>  +{
>>  + struct sock *sk = (struct sock *)tp;
>
> We prefer the other way to avoid a cast unless really needed :
>
> static inline tcp_keepalive_time_set(struct sock *sk, int val)
> {
>       stuct tcp_sock *tp = tcp_sk(sk);
>
>>  +
>>  + tp->keepalive_time = val * HZ;
>>  + if (sock_flag(sk, SOCK_KEEPOPEN) &&
>>  + !((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))) {
>>  + u32 elapsed = keepalive_time_elapsed(tp);
>>  +
>>  + if (tp->keepalive_time > elapsed)
>>  + elapsed = tp->keepalive_time - elapsed;
>>  + else
>>  + elapsed = 0;
>>  + inet_csk_reset_keepalive_timer(sk, elapsed);
>>  + }
>>  +}
>>  +
>>   static inline int tcp_fin_time(const struct sock *sk)
>>   {
>>           int fin_timeout = tcp_sk(sk)->linger2 ? : sock_net(sk)->ipv4.sysctl_tcp_fin_timeout;
>>  diff --git a/net/core/filter.c b/net/core/filter.c
>>  index a6fc234..1035e43 100644
>>  --- a/net/core/filter.c
>>  +++ b/net/core/filter.c
>>  @@ -4248,8 +4248,8 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
>>   static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>>                              char *optval, int optlen, u32 flags)
>>   {
>>  + int val, valbool;
>>           int ret = 0;
>>  - int val;
>>
>>           if (!sk_fullsock(sk))
>>                   return -EINVAL;
>>  @@ -4260,6 +4260,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>>                   if (optlen != sizeof(int))
>>                           return -EINVAL;
>>                   val = *((int *)optval);
>>  + valbool = val ? 1 : 0;
>>
>>                   /* Only some socketops are supported */
>>                   switch (optname) {
>>  @@ -4298,6 +4299,11 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>>                                   sk_dst_reset(sk);
>>                           }
>>                           break;
>>  + case SO_KEEPALIVE:
>>  + if (sk->sk_prot->keepalive)
>>  + sk->sk_prot->keepalive(sk, valbool);
>>  + sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
>>  + break;
>>                   default:
>>                           ret = -EINVAL;
>>                   }
>>  @@ -4358,6 +4364,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>>                           ret = tcp_set_congestion_control(sk, name, false,
>>                                                            reinit, true);
>>                   } else {
>>  + struct inet_connection_sock *icsk = inet_csk(sk);
>>                           struct tcp_sock *tp = tcp_sk(sk);
>>
>>                           if (optlen != sizeof(int))
>>  @@ -4386,6 +4393,36 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>>                                   else
>>                                           tp->save_syn = val;
>>                                   break;
>>  + case TCP_KEEPIDLE:
>>  + if (val < 1 || val > MAX_TCP_KEEPIDLE)
>>  + ret = -EINVAL;
>>  + else
>>  + keepalive_time_set(tp, val);
>>  + break;
>>  + case TCP_KEEPINTVL:
>>  + if (val < 1 || val > MAX_TCP_KEEPINTVL)
>>  + ret = -EINVAL;
>>  + else
>>  + tp->keepalive_intvl = val * HZ;
>>  + break;
>>  + case TCP_KEEPCNT:
>>  + if (val < 1 || val > MAX_TCP_KEEPCNT)
>>  + ret = -EINVAL;
>>  + else
>>  + tp->keepalive_probes = val;
>>  + break;
>>  + case TCP_SYNCNT:
>>  + if (val < 1 || val > MAX_TCP_SYNCNT)
>>  + ret = -EINVAL;
>>  + else
>>  + icsk->icsk_syn_retries = val;
>>  + break;
>>  + case TCP_USER_TIMEOUT:
>>  + if (val < 0)
>>  + ret = -EINVAL;
>>  + else
>>  + icsk->icsk_user_timeout = val;
>>  + break;
>>                           default:
>>                                   ret = -EINVAL;
>>                           }
>>  diff --git a/net/core/sock.c b/net/core/sock.c
>>  index fd85e65..9836b01 100644
>>  --- a/net/core/sock.c
>>  +++ b/net/core/sock.c
>>  @@ -684,15 +684,6 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
>>           return ret;
>>   }
>>
>>  -static inline void sock_valbool_flag(struct sock *sk, enum sock_flags bit,
>>  - int valbool)
>>  -{
>>  - if (valbool)
>>  - sock_set_flag(sk, bit);
>>  - else
>>  - sock_reset_flag(sk, bit);
>>  -}
>>  -
>>   bool sk_mc_loop(struct sock *sk)
>>   {
>>           if (dev_recursion_level())
>>  diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>  index 9700649..7b239e8 100644
>>  --- a/net/ipv4/tcp.c
>>  +++ b/net/ipv4/tcp.c
>>  @@ -3003,19 +3003,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
>>           case TCP_KEEPIDLE:
>>                   if (val < 1 || val > MAX_TCP_KEEPIDLE)
>>                           err = -EINVAL;
>>  - else {
>>  - tp->keepalive_time = val * HZ;
>>  - if (sock_flag(sk, SOCK_KEEPOPEN) &&
>>  - !((1 << sk->sk_state) &
>>  - (TCPF_CLOSE | TCPF_LISTEN))) {
>>  - u32 elapsed = keepalive_time_elapsed(tp);
>>  - if (tp->keepalive_time > elapsed)
>>  - elapsed = tp->keepalive_time - elapsed;
>>  - else
>>  - elapsed = 0;
>>  - inet_csk_reset_keepalive_timer(sk, elapsed);
>>  - }
>>  - }
>>  + else
>>  + keepalive_time_set(tp, val);
>>                   break;
>>           case TCP_KEEPINTVL:
>>                   if (val < 1 || val > MAX_TCP_KEEPINTVL)
