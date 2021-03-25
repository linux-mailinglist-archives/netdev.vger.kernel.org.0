Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B70348602
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 01:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhCYApH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 20:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239203AbhCYAog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 20:44:36 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8ABC06174A;
        Wed, 24 Mar 2021 17:44:35 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 32so122262pgm.1;
        Wed, 24 Mar 2021 17:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S8nubhLLioyoXmCH3IxyWRKYmuxojuhXgXoAAM29DE4=;
        b=f3nxA5ITWzgcyP2tvJamUKLnUunnt9FabBkgGYmT0tusk4RWai3NDpyUnNj829W3mR
         99w42C2X0WnIwUknlU9dh3pG7r4LsOJygg8E31NlCdOYehAs++CsSSGNdRnJd7pCysS6
         BPPNAvJcdhREjiIYaUMiqWUxDd9O/rsdw+LZlaO15neLjHC5hheEssJJOtpUdJY1oVvf
         0BrfILvyaWd95WPSIuH2mA1ynAqIKSGI3ZYty1aeZlknmIo1kpv+QuquVOGQPXMUBvV9
         Gh6qXJCQGnYcyMfvGTg2a+PDk4FldVp7/RSNVKIn1TNS9spY5BKsz54YfER4frZ47oWu
         al1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S8nubhLLioyoXmCH3IxyWRKYmuxojuhXgXoAAM29DE4=;
        b=mWbKh4wrueaLgZpA4/2n/HfDqFv0df8+cATnLHpXJlpfQ88ZPjYVk0LPsNPtfa5elX
         HpUTDFg5yfeEFWFvhP2FDCTBB0iDAvNHWyXuU0E0q+Zt/tszPAhEELLtivvWjIkZQlDh
         XcW227xOFyw6BapBC4u+lT21/KzpTpzdjmuDiuxUl5TRUK4t74jNdZbBtnpt6h/0wxvr
         6bXxn4Ox8UpQMgJZ4AiP6GQUJpZdJeTPK6p2EUvt92w3tsoHaX8jJD/MgpnGX/FmepkC
         4Eo11jVNPNnyic+7KRfmSQ1xmTE0CpbSMPerd3wBGkJ2IHm+Eb1FnGFaHbcVJe01SPuO
         fKiQ==
X-Gm-Message-State: AOAM533dqF/c2SZtjOtnv061tqkdoibVPybyeR1NAr7wNzfjtVZ++uoJ
        t6FWVFaXoCIDu8X98tQC1C9rCOomVskvJMofzBM=
X-Google-Smtp-Source: ABdhPJzhakOUij8hzTIWWd0w4c4MSCkspP33VckieZ1O37s7mt+rYN5wbqJBmbNUw3LLl8wLoO/7qJIZz90T7ODvJX4=
X-Received: by 2002:a17:902:cecf:b029:e6:ac65:4680 with SMTP id
 d15-20020a170902cecfb02900e6ac654680mr6518366plg.64.1616633075220; Wed, 24
 Mar 2021 17:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
 <161661958954.28508.16923012330549206770.stgit@john-Precision-5820-Tower>
In-Reply-To: <161661958954.28508.16923012330549206770.stgit@john-Precision-5820-Tower>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 24 Mar 2021 17:44:24 -0700
Message-ID: <CAM_iQpVShCqWx1CYUOO9SrgWw7ztVP6j=v=W9dAd9FbChGZauQ@mail.gmail.com>
Subject: Re: [bpf PATCH 2/2] bpf, sockmap: fix incorrect fwd_alloc accounting
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 2:00 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Incorrect accounting fwd_alloc can result in a warning when the socket
> is torn down,
>
>  [18455.319240] WARNING: CPU: 0 PID: 24075 at net/core/stream.c:208 sk_stream_kill_queues+0x21f/0x230
>  [...]
>  [18455.319543] Call Trace:
>  [18455.319556]  inet_csk_destroy_sock+0xba/0x1f0
>  [18455.319577]  tcp_rcv_state_process+0x1b4e/0x2380
>  [18455.319593]  ? lock_downgrade+0x3a0/0x3a0
>  [18455.319617]  ? tcp_finish_connect+0x1e0/0x1e0
>  [18455.319631]  ? sk_reset_timer+0x15/0x70
>  [18455.319646]  ? tcp_schedule_loss_probe+0x1b2/0x240
>  [18455.319663]  ? lock_release+0xb2/0x3f0
>  [18455.319676]  ? __release_sock+0x8a/0x1b0
>  [18455.319690]  ? lock_downgrade+0x3a0/0x3a0
>  [18455.319704]  ? lock_release+0x3f0/0x3f0
>  [18455.319717]  ? __tcp_close+0x2c6/0x790
>  [18455.319736]  ? tcp_v4_do_rcv+0x168/0x370
>  [18455.319750]  tcp_v4_do_rcv+0x168/0x370
>  [18455.319767]  __release_sock+0xbc/0x1b0
>  [18455.319785]  __tcp_close+0x2ee/0x790
>  [18455.319805]  tcp_close+0x20/0x80
>
> This currently happens because on redirect case we do skb_set_owner_r()
> with the original sock. This increments the fwd_alloc memory accounting
> on the original sock. Then on redirect we may push this into the queue
> of the psock we are redirecting to. When the skb is flushed from the
> queue we give the memory back to the original sock. The problem is if
> the original sock is destroyed/closed with skbs on another psocks queue
> then the original sock will not have a way to reclaim the memory before
> being destroyed. Then above warning will be thrown
>
>   sockA                          sockB
>
>   sk_psock_strp_read()
>    sk_psock_verdict_apply()
>      -- SK_REDIRECT --
>      sk_psock_skb_redirect()
>                                 skb_queue_tail(psock_other->ingress_skb..)
>
>   sk_close()
>    sock_map_unref()
>      sk_psock_put()
>        sk_psock_drop()
>          sk_psock_zap_ingress()
>
> At this point we have torn down our own psock, but have the outstanding
> skb in psock_other. Note that SK_PASS doesn't have this problem because
> the sk_psock_drop() logic releases the skb, its still associated with
> our psock.
>
> To resolve lets only account for sockets on the ingress queue that are
> still associated with the current socket. On the redirect case we will
> check memory limits per 6fa9201a89898, but will omit fwd_alloc accounting
> until skb is actually enqueued. When the skb is sent via skb_send_sock_locked
> or received with sk_psock_skb_ingress memory will be claimed on psock_other.

You mean sk_psock_skb_ingress(), right?

>
> Reported-by: Andrii Nakryiko <andrii@kernel.org>
> Fixes: 6fa9201a89898 ("bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/skmsg.c |   13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 1261512d6807..f150b5b63561 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -488,6 +488,7 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
>         if (unlikely(!msg))
>                 return -EAGAIN;
>         sk_msg_init(msg);
> +       skb_set_owner_r(skb, sk);
>         return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
>  }
>
> @@ -790,7 +791,6 @@ static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int
>  {
>         switch (verdict) {
>         case __SK_REDIRECT:
> -               skb_set_owner_r(skb, sk);
>                 sk_psock_skb_redirect(skb);
>                 break;
>         case __SK_PASS:
> @@ -808,10 +808,6 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
>         rcu_read_lock();
>         prog = READ_ONCE(psock->progs.skb_verdict);
>         if (likely(prog)) {
> -               /* We skip full set_owner_r here because if we do a SK_PASS
> -                * or SK_DROP we can skip skb memory accounting and use the
> -                * TLS context.
> -                */
>                 skb->sk = psock->sk;
>                 tcp_skb_bpf_redirect_clear(skb);
>                 ret = sk_psock_bpf_run(psock, prog, skb);
> @@ -880,12 +876,13 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
>                 kfree_skb(skb);
>                 goto out;
>         }
> -       skb_set_owner_r(skb, sk);
>         prog = READ_ONCE(psock->progs.skb_verdict);
>         if (likely(prog)) {
> +               skb->sk = psock->sk;

Why is skb_orphan() not needed here?

Nit: You can just use 'sk' here, so "skb->sk = sk".


>                 tcp_skb_bpf_redirect_clear(skb);
>                 ret = sk_psock_bpf_run(psock, prog, skb);
>                 ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> +               skb->sk = NULL;

Why do you want to set it to NULL here?

Thanks.
