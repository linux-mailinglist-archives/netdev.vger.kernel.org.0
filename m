Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9FA6CBEE9
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjC1MUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjC1MUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:20:54 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01968F5
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 05:20:52 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id cn12so48933606edb.4
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 05:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1680006051;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=k0ihwQt2nqdrwOe9JLFYGsen3V9a0AkY0Ja7Mxmjdic=;
        b=cdY6DsRd5fCeM2URW+mDXaUD00uIvtJzeYlj9HGxvUTs6pCUYXEkop4diNOtjdkOj2
         C4MO66ZjagSmfpikCPPnGgx16kaRGsUDyEvWMZzp9xZCzWzS5it7u0VZe19lthXLwBpJ
         NETsNVK5oq5v5TWGafSQCyhRwJma0Os6GJapg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680006051;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0ihwQt2nqdrwOe9JLFYGsen3V9a0AkY0Ja7Mxmjdic=;
        b=0VfFVXgdgDaAz528Bo1uCq9LnNhFZlt1kUvmvjKRA9BJrdykcoWVMuIr/IiTGNghKI
         a4DNlt9b0reCGeqMUASz4cimDPoioadT31laFAKH44FfegEf40cddLofzTxcK5mzrrkr
         98xzZpQdMMOGh/NocudTU8YjjPD1LYKmFvp0A8MgsOmVeibUyj0PcveY/Ys+m4L1KZIH
         btqmiVUWTTOpcDEqtWeBJv9u/fYWAwtfJlYgUK2jStyy8W/8Kg8RmbtO2pi1T8tq/7mm
         j0jltvVfX02FP+8QGwlw64rbdfZ2ht/BvZALtoartQtelpjG5Ew2yYLIIdzO54YMj5kE
         8vBA==
X-Gm-Message-State: AAQBX9epGlqL6WmP9lZiG5viO5C/jY8p93XLrJHohoT3H1BMuuAeI43F
        gCtuarKgeaKqdW6SjtlWD4pHdg==
X-Google-Smtp-Source: AKy350bRcb9OoYfrgbGllA/FaDg7R1VVPVhPQiPVbyJvcu4BleKhs5iRr8p+o49TaulcllkigkxC8w==
X-Received: by 2002:aa7:cac4:0:b0:4fc:709f:7abd with SMTP id l4-20020aa7cac4000000b004fc709f7abdmr14860038edt.2.1680006051368;
        Tue, 28 Mar 2023 05:20:51 -0700 (PDT)
Received: from cloudflare.com (79.184.147.137.ipv4.supernova.orange.pl. [79.184.147.137])
        by smtp.gmail.com with ESMTPSA id cd2-20020a170906b34200b0092c8da1e5ecsm15238229ejb.21.2023.03.28.05.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 05:20:50 -0700 (PDT)
References: <20230327175446.98151-1-john.fastabend@gmail.com>
 <20230327175446.98151-3-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     cong.wang@bytedance.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        ast@kernel.org, andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v2 02/12] bpf: sockmap, convert schedule_work into
 delayed_work
Date:   Tue, 28 Mar 2023 14:09:27 +0200
In-reply-to: <20230327175446.98151-3-john.fastabend@gmail.com>
Message-ID: <87tty55aou.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 10:54 AM -07, John Fastabend wrote:
> Sk_buffs are fed into sockmap verdict programs either from a strparser
> (when the user might want to decide how framing of skb is done by attaching
> another parser program) or directly through tcp_read_sock. The
> tcp_read_sock is the preferred method for performance when the BPF logic is
> a stream parser.
>
> The flow for Cilium's common use case with a stream parser is,
>
>  tcp_read_sock()
>   sk_psock_verdict_recv
>     ret = bpf_prog_run_pin_on_cpu()
>     sk_psock_verdict_apply(sock, skb, ret)
>      // if system is under memory pressure or app is slow we may
>      // need to queue skb. Do this queuing through ingress_skb and
>      // then kick timer to wake up handler
>      skb_queue_tail(ingress_skb, skb)
>      schedule_work(work);
>
>
> The work queue is wired up to sk_psock_backlog(). This will then walk the
> ingress_skb skb list that holds our sk_buffs that could not be handled,
> but should be OK to run at some later point. However, its possible that
> the workqueue doing this work still hits an error when sending the skb.
> When this happens the skbuff is requeued on a temporary 'state' struct
> kept with the workqueue. This is necessary because its possible to
> partially send an skbuff before hitting an error and we need to know how
> and where to restart when the workqueue runs next.
>
> Now for the trouble, we don't rekick the workqueue. This can cause a
> stall where the skbuff we just cached on the state variable might never
> be sent. This happens when its the last packet in a flow and no further
> packets come along that would cause the system to kick the workqueue from
> that side.
>
> To fix we could do simple schedule_work(), but while under memory pressure
> it makes sense to back off some instead of continue to retry repeatedly. So
> instead to fix convert schedule_work to schedule_delayed_work and add
> backoff logic to reschedule from backlog queue on errors. Its not obvious
> though what a good backoff is so use '1'.
>
> To test we observed some flakes whil running NGINX compliance test with
> sockmap we attributed these failed test to this bug and subsequent issue.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Tested-by: William Findlay <will@isovalent.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  include/linux/skmsg.h |  2 +-
>  net/core/skmsg.c      | 19 ++++++++++++-------
>  net/core/sock_map.c   |  3 ++-
>  3 files changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 84f787416a54..904ff9a32ad6 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -105,7 +105,7 @@ struct sk_psock {
>  	struct proto			*sk_proto;
>  	struct mutex			work_mutex;
>  	struct sk_psock_work_state	work_state;
> -	struct work_struct		work;
> +	struct delayed_work		work;
>  	struct rcu_work			rwork;
>  };
>  
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 2b6d9519ff29..96a6a3a74a67 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -481,7 +481,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  	}
>  out:
>  	if (psock->work_state.skb && copied > 0)
> -		schedule_work(&psock->work);
> +		schedule_delayed_work(&psock->work, 0);
>  	return copied;
>  }
>  EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
> @@ -639,7 +639,8 @@ static void sk_psock_skb_state(struct sk_psock *psock,
>  
>  static void sk_psock_backlog(struct work_struct *work)
>  {
> -	struct sk_psock *psock = container_of(work, struct sk_psock, work);
> +	struct delayed_work *dwork = to_delayed_work(work);
> +	struct sk_psock *psock = container_of(dwork, struct sk_psock, work);
>  	struct sk_psock_work_state *state = &psock->work_state;
>  	struct sk_buff *skb = NULL;
>  	bool ingress;
> @@ -679,6 +680,10 @@ static void sk_psock_backlog(struct work_struct *work)
>  				if (ret == -EAGAIN) {
>  					sk_psock_skb_state(psock, state, skb,
>  							   len, off);
> +
> +					// Delay slightly to prioritize any
> +					// other work that might be here.
> +					schedule_delayed_work(&psock->work, 1);

Do IIUC that this means we can back out changes from commit bec217197b41
("skmsg: Schedule psock work if the cached skb exists on the psock")?

Nit: Comment syntax.

>  					goto end;
>  				}
>  				/* Hard errors break pipe and stop xmit. */
> @@ -733,7 +738,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
>  	INIT_LIST_HEAD(&psock->link);
>  	spin_lock_init(&psock->link_lock);
>  
> -	INIT_WORK(&psock->work, sk_psock_backlog);
> +	INIT_DELAYED_WORK(&psock->work, sk_psock_backlog);
>  	mutex_init(&psock->work_mutex);
>  	INIT_LIST_HEAD(&psock->ingress_msg);
>  	spin_lock_init(&psock->ingress_lock);
> @@ -822,7 +827,7 @@ static void sk_psock_destroy(struct work_struct *work)
>  
>  	sk_psock_done_strp(psock);
>  
> -	cancel_work_sync(&psock->work);
> +	cancel_delayed_work_sync(&psock->work);
>  	mutex_destroy(&psock->work_mutex);
>  
>  	psock_progs_drop(&psock->progs);
> @@ -937,7 +942,7 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
>  	}
>  
>  	skb_queue_tail(&psock_other->ingress_skb, skb);
> -	schedule_work(&psock_other->work);
> +	schedule_delayed_work(&psock_other->work, 0);
>  	spin_unlock_bh(&psock_other->ingress_lock);
>  	return 0;
>  }
> @@ -1017,7 +1022,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
>  			spin_lock_bh(&psock->ingress_lock);
>  			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
>  				skb_queue_tail(&psock->ingress_skb, skb);
> -				schedule_work(&psock->work);
> +				schedule_delayed_work(&psock->work, 0);
>  				err = 0;
>  			}
>  			spin_unlock_bh(&psock->ingress_lock);
> @@ -1048,7 +1053,7 @@ static void sk_psock_write_space(struct sock *sk)
>  	psock = sk_psock(sk);
>  	if (likely(psock)) {
>  		if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
> -			schedule_work(&psock->work);
> +			schedule_delayed_work(&psock->work, 0);
>  		write_space = psock->saved_write_space;
>  	}
>  	rcu_read_unlock();
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index a68a7290a3b2..d38267201892 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -1624,9 +1624,10 @@ void sock_map_close(struct sock *sk, long timeout)
>  		rcu_read_unlock();
>  		sk_psock_stop(psock);
>  		release_sock(sk);
> -		cancel_work_sync(&psock->work);
> +		cancel_delayed_work_sync(&psock->work);
>  		sk_psock_put(sk, psock);
>  	}
> +
>  	/* Make sure we do not recurse. This is a bug.
>  	 * Leak the socket instead of crashing on a stack overflow.
>  	 */

