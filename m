Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BD11F07E7
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 18:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgFFQ1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 12:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgFFQ1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 12:27:23 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1ADC03E96A
        for <netdev@vger.kernel.org>; Sat,  6 Jun 2020 09:27:22 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l1so9910306ede.11
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 09:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sDG9wHvN6L2ARsiVaWzyLnbW8ii3xZCzoN1TXo7Z7KY=;
        b=aJqe4B/sWrtHlHCiZtH6jks+rk0akf1yTJ+uPOB9MLryDAk+G9dgL2Ilvmonu5ltLr
         I4txPIF8I5H5DCMhUiLwUMW9YO0FRS9E9PXFsO8dutHR+fV2LVjb4yI0WqllcATkgNOv
         J/LxjkeTjLPqjux+pZHyvwi7x1cfClNT52Xks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sDG9wHvN6L2ARsiVaWzyLnbW8ii3xZCzoN1TXo7Z7KY=;
        b=OIjjP9xdeAXLYdEo4qniBqJM/NSp3zIHU+IbdLj0tzZhcVSJUUqWeAsIUiNzPW2Agw
         lkB7VBxxfCl3ynqgMa0C6a/9mT0J/fCdtJprBuU0XDkLFs9PciS4rw8ja7mRItnjXRVz
         CVdAsF+2qO72RwAyQhfiIf0p7mHFVSsuYGgSpaK8Jl65L49DS+VXkqf6XnZ5HuPikV3L
         G9P5EcONYYzlU6RByQ0T02J/+qed8nf3QznCfhmQcvMjmxuli2IUO8Z8fYb0B0ddw+9v
         x58usqa2b/N09cCK5/eaO1GgFyfni0fksyzzYXXYxvZpGaNhHjlKdvOZL1in9h0pHkaj
         9LjA==
X-Gm-Message-State: AOAM530uWhIg2NhHAVuRd6anED7lh2HwQ08GzPXT8/6G/xj9w6RECwYd
        YfQk/ESS6GMCd3Sqx2eBR8ARhQ==
X-Google-Smtp-Source: ABdhPJxPT0Idzamr6EhW9qzKUIi0C6qadkCgB291VMzSWq6gXqXcvV7KrcuNLIhXRiGAnC7yC5hz9g==
X-Received: by 2002:a50:fa8d:: with SMTP id w13mr14674240edr.324.1591460841287;
        Sat, 06 Jun 2020 09:27:21 -0700 (PDT)
Received: from toad ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v12sm8010594eda.39.2020.06.06.09.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 09:27:21 -0700 (PDT)
Date:   Sat, 6 Jun 2020 18:26:51 +0200
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [bpf-next PATCH 1/3] bpf: refactor sockmap redirect code so its
 easy to reuse
Message-ID: <20200606182651.0c511fd1@toad>
In-Reply-To: <159079360110.5745.7024009076049029819.stgit@john-Precision-5820-Tower>
References: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
        <159079360110.5745.7024009076049029819.stgit@john-Precision-5820-Tower>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 23:06:41 +0000
John Fastabend <john.fastabend@gmail.com> wrote:

> We will need this block of code called from tls context shortly
> lets refactor the redirect logic so its easy to use. This also
> cleans up the switch stmt so we have fewer fallthrough cases.
> 
> No logic changes are intended.
> 
> Fixes: d829e9c4112b5 ("tls: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/skmsg.c |   55 +++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 34 insertions(+), 21 deletions(-)
> 
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index c479372..9d72f71 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -682,13 +682,43 @@ static struct sk_psock *sk_psock_from_strp(struct strparser *strp)
>  	return container_of(parser, struct sk_psock, parser);
>  }
>  
> -static void sk_psock_verdict_apply(struct sk_psock *psock,
> -				   struct sk_buff *skb, int verdict)
> +static void sk_psock_skb_redirect(struct sk_psock *psock, struct sk_buff *skb)
>  {
>  	struct sk_psock *psock_other;
>  	struct sock *sk_other;
>  	bool ingress;
>  
> +	sk_other = tcp_skb_bpf_redirect_fetch(skb);
> +	if (unlikely(!sk_other)) {
> +		kfree_skb(skb);
> +		return;
> +	}
> +	psock_other = sk_psock(sk_other);

I think we're not in RCU read-side critical section and so lockdep-RCU
[0] is complaining about accessing sk_user_data with rcu_dereference:

bash-5.0# ./test_sockmap
# 1/ 6  sockmap::txmsg test passthrough:OK
# 2/ 6  sockmap::txmsg test redirect:OK
# 3/ 6  sockmap::txmsg test drop:OK
# 4/ 6  sockmap::txmsg test ingress redirect:OK
[   96.791996]
[   96.792211] =============================
[   96.792763] WARNING: suspicious RCU usage
[   96.793297] 5.7.0-rc7-02964-g615b5749876a-dirty #692 Not tainted
[   96.794032] -----------------------------
[   96.794480] include/linux/skmsg.h:284 suspicious rcu_dereference_check() usage!
[   96.795154]
[   96.795154] other info that might help us debug this:
[   96.795154]
[   96.795926]
[   96.795926] rcu_scheduler_active = 2, debug_locks = 1
[   96.796556] 1 lock held by test_sockmap/1060:
[   96.796970]  #0: ffff8880a0d35f20 (sk_lock-AF_INET){+.+.}-{0:0}, at: tls_sw_recvmsg+0x238/0xc10
[   96.797813]
[   96.797813] stack backtrace:
[   96.798224] CPU: 1 PID: 1060 Comm: test_sockmap Not tainted 5.7.0-rc7-02964-g615b5749876a-dirty #692
[   96.799071] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
[   96.800294] Call Trace:
[   96.800543]  dump_stack+0x97/0xe0
[   96.800864]  sk_psock_skb_redirect.isra.0+0xa6/0x1b0
[   96.801338]  sk_psock_tls_strp_read+0x298/0x310
[   96.801769]  tls_sw_recvmsg+0xa47/0xc10
[   96.802144]  ? decrypt_skb+0x80/0x80
[   96.802491]  ? lock_downgrade+0x330/0x330
[   96.802887]  inet_recvmsg+0xae/0x2a0
[   96.803224]  ? rw_copy_check_uvector+0x15e/0x1b0
[   96.803669]  ? inet_sendpage+0xc0/0xc0
[   96.804029]  ____sys_recvmsg+0x110/0x210
[   96.804417]  ? kernel_recvmsg+0x60/0x60
[   96.804785]  ? copy_msghdr_from_user+0x91/0xd0
[   96.805200]  ? __copy_msghdr_from_user+0x230/0x230
[   96.805665]  ? lock_acquire+0x120/0x4b0
[   96.806025]  ? match_held_lock+0x1b/0x230
[   96.806417]  ___sys_recvmsg+0xb8/0x100
[   96.806778]  ? ___sys_sendmsg+0x110/0x110
[   96.807155]  ? lock_downgrade+0x330/0x330
[   96.807555]  ? __fget_light+0xad/0x110
[   96.807917]  ? sockfd_lookup_light+0x91/0xb0
[   96.808334]  __sys_recvmsg+0x87/0xe0
[   96.808674]  ? __sys_recvmsg_sock+0x70/0x70
[   96.809064]  ? rcu_read_lock_sched_held+0x81/0xb0
[   96.809540]  ? switch_fpu_return+0x1/0x250
[   96.809948]  ? do_syscall_64+0x5f/0x9a0
[   96.810325]  do_syscall_64+0xad/0x9a0
[   96.810676]  ? handle_mm_fault+0x21e/0x3d0
[   96.811060]  ? syscall_return_slowpath+0x530/0x530
[   96.811524]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[   96.811955]  ? lockdep_hardirqs_off+0xb5/0x100
[   96.812383]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[   96.812871]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
[   96.813425] RIP: 0033:0x7f92ff15c737
[   96.813762] Code: 02 b8 ff ff ff ff eb bd 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2f 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
[   96.815477] RSP: 002b:00007ffd80734b68 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
[   96.816177] RAX: ffffffffffffffda RBX: 000000000000001c RCX: 00007f92ff15c737
[   96.816847] RDX: 0000000000004000 RSI: 00007ffd80734bd0 RDI: 000000000000001c
[   96.817602] RBP: 00007ffd80734c50 R08: 00007ffd80734bc0 R09: 0000000000000060
[   96.818351] R10: fffffffffffffb15 R11: 0000000000000246 R12: 0000000000000000
[   96.819107] R13: 0000000000004000 R14: 00007f92fef7a6b8 R15: 00007ffd80734d50

[0] https://www.kernel.org/doc/Documentation/RCU/lockdep-splat.txt

> +	if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
> +	    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
> +		kfree_skb(skb);
> +		return;
> +	}
> +
> +	ingress = tcp_skb_bpf_ingress(skb);
> +	if ((!ingress && sock_writeable(sk_other)) ||
> +	    (ingress &&
> +	     atomic_read(&sk_other->sk_rmem_alloc) <=
> +	     sk_other->sk_rcvbuf)) {
> +		if (!ingress)
> +			skb_set_owner_w(skb, sk_other);
> +		skb_queue_tail(&psock_other->ingress_skb, skb);
> +		schedule_work(&psock_other->work);
> +	} else {
> +		kfree_skb(skb);
> +	}
> +}
> +
> +static void sk_psock_verdict_apply(struct sk_psock *psock,
> +				   struct sk_buff *skb, int verdict)
> +{
> +	struct sock *sk_other;
> +
>  	switch (verdict) {
>  	case __SK_PASS:
>  		sk_other = psock->sk;
> @@ -707,25 +737,8 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
>  		}
>  		goto out_free;
>  	case __SK_REDIRECT:
> -		sk_other = tcp_skb_bpf_redirect_fetch(skb);
> -		if (unlikely(!sk_other))
> -			goto out_free;
> -		psock_other = sk_psock(sk_other);
> -		if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
> -		    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED))
> -			goto out_free;
> -		ingress = tcp_skb_bpf_ingress(skb);
> -		if ((!ingress && sock_writeable(sk_other)) ||
> -		    (ingress &&
> -		     atomic_read(&sk_other->sk_rmem_alloc) <=
> -		     sk_other->sk_rcvbuf)) {
> -			if (!ingress)
> -				skb_set_owner_w(skb, sk_other);
> -			skb_queue_tail(&psock_other->ingress_skb, skb);
> -			schedule_work(&psock_other->work);
> -			break;
> -		}
> -		/* fall-through */
> +		sk_psock_skb_redirect(psock, skb);
> +		break;
>  	case __SK_DROP:
>  		/* fall-through */
>  	default:
> 
