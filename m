Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00BE338C4E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 13:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCLMCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 07:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhCLMC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 07:02:27 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B602EC061761
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 04:02:26 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v11so1629793wro.7
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 04:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=t+ROwIyvN0I+X1klEDa5XTKh1twAt3hvk0NNkPAx5K4=;
        b=Kr8Rp4WtYlJ88vUcFW1Ss8NoGWhY7tTotoBXjrUVhBnxzic9mZSAy4WEGaP1Ryz00Q
         JvbMb6e8MX0wdfLoS+oYOrtK5y+KVpP/qmJrYSXCHpU4/Drg5fOCDf6TsDzvTzcLaggc
         bUO9gLbsEU+4hqy3x9+PAt8J/vkc1LD/cDedE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=t+ROwIyvN0I+X1klEDa5XTKh1twAt3hvk0NNkPAx5K4=;
        b=aozQ//q+nkrnhieWsDjSzBqLqGm5qWUZMR+L5zRRyxFWhOd+MVzH9zlq1/0jriylNw
         g9YzQcYAN+veJmOmNfETeR1+AFGh1GQgznnEQTz53isJnkbTZgpF5eiiQ1iBPbSk7OKX
         iAYpCyNbPKmLlkS6C1j5gGEtdiQtAoUBl7vHFzGTvVJCCBIkpGi2HDB+J8Aq7hDtAvVx
         OOjdXIvJHNQLaLVqw6sRVvgF4Zfs19yiSZq6U2Kc4Vhz+1snvkKPi+qrHIfEVJBGOpYK
         OBHJZNrEyhRaND4RJvMnUl84bk+HUd0Cra9cFZd3dDdLV76CHtRaa74iqz44S8ReoJPR
         pSXQ==
X-Gm-Message-State: AOAM531xKFm7ZWSh4ejQU2HrWZCw2nd45lJ3siIyqlUPnJiFDTSm101R
        h1323atewI+yDN1QveGrbXMZpqwtxvrTqnkK
X-Google-Smtp-Source: ABdhPJxpGSphkt3rzgAjSW6s2r1d3QjmzVwDIKFAXlDy7+HDU9xSmoQiXRT3u1mCdHDTiYIC35Lh8A==
X-Received: by 2002:adf:e441:: with SMTP id t1mr13550691wrm.21.1615550545354;
        Fri, 12 Mar 2021 04:02:25 -0800 (PST)
Received: from cloudflare.com (79.184.34.53.ipv4.supernova.orange.pl. [79.184.34.53])
        by smtp.gmail.com with ESMTPSA id k11sm1975320wmj.1.2021.03.12.04.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 04:02:24 -0800 (PST)
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
 <20210310053222.41371-5-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next v4 04/11] skmsg: avoid lock_sock() in
 sk_psock_backlog()
In-reply-to: <20210310053222.41371-5-xiyou.wangcong@gmail.com>
Date:   Fri, 12 Mar 2021 13:02:12 +0100
Message-ID: <87y2es37i3.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 06:32 AM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> We do not have to lock the sock to avoid losing sk_socket,
> instead we can purge all the ingress queues when we close
> the socket. Sending or receiving packets after orphaning
> socket makes no sense.
>
> We do purge these queues when psock refcnt reaches 0 but
> here we want to purge them explicitly in sock_map_close().
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/skmsg.h |  1 +
>  net/core/skmsg.c      | 22 ++++++++++++++--------
>  net/core/sock_map.c   |  1 +
>  3 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 7333bf881b81..91b357817bb8 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -347,6 +347,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
>  }
>
>  struct sk_psock *sk_psock_init(struct sock *sk, int node);
> +void sk_psock_purge(struct sk_psock *psock);
>
>  #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
>  int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 41a5f82c53e6..bf0f874780c1 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -497,7 +497,7 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
>  	if (!ingress) {
>  		if (!sock_writeable(psock->sk))
>  			return -EAGAIN;
> -		return skb_send_sock_locked(psock->sk, skb, off, len);
> +		return skb_send_sock(psock->sk, skb, off, len);
>  	}
>  	return sk_psock_skb_ingress(psock, skb);
>  }
> @@ -511,8 +511,6 @@ static void sk_psock_backlog(struct work_struct *work)
>  	u32 len, off;
>  	int ret;
>
> -	/* Lock sock to avoid losing sk_socket during loop. */
> -	lock_sock(psock->sk);
>  	if (state->skb) {
>  		skb = state->skb;
>  		len = state->len;
> @@ -529,7 +527,7 @@ static void sk_psock_backlog(struct work_struct *work)
>  		skb_bpf_redirect_clear(skb);
>  		do {
>  			ret = -EIO;
> -			if (likely(psock->sk->sk_socket))
> +			if (!sock_flag(psock->sk, SOCK_DEAD))
>  				ret = sk_psock_handle_skb(psock, skb, off,
>  							  len, ingress);
>  			if (ret <= 0) {
> @@ -537,13 +535,13 @@ static void sk_psock_backlog(struct work_struct *work)
>  					state->skb = skb;
>  					state->len = len;
>  					state->off = off;
> -					goto end;
> +					return;
>  				}
>  				/* Hard errors break pipe and stop xmit. */
>  				sk_psock_report_error(psock, ret ? -ret : EPIPE);
>  				sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
>  				kfree_skb(skb);
> -				goto end;
> +				return;
>  			}
>  			off += ret;
>  			len -= ret;
> @@ -552,8 +550,6 @@ static void sk_psock_backlog(struct work_struct *work)
>  		if (!ingress)
>  			kfree_skb(skb);
>  	}
> -end:
> -	release_sock(psock->sk);
>  }
>
>  struct sk_psock *sk_psock_init(struct sock *sk, int node)
> @@ -654,6 +650,16 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
>  	}
>  }
>
> +void sk_psock_purge(struct sk_psock *psock)
> +{
> +	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
> +
> +	cancel_work_sync(&psock->work);
> +
> +	sk_psock_cork_free(psock);
> +	sk_psock_zap_ingress(psock);
> +}
> +
>  static void sk_psock_done_strp(struct sk_psock *psock);
>
>  static void sk_psock_destroy_deferred(struct work_struct *gc)
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index dd53a7771d7e..26ba47b099f1 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -1540,6 +1540,7 @@ void sock_map_close(struct sock *sk, long timeout)
>  	saved_close = psock->saved_close;
>  	sock_map_remove_links(sk, psock);
>  	rcu_read_unlock();
> +	sk_psock_purge(psock);
>  	release_sock(sk);
>  	saved_close(sk, timeout);
>  }

Nothing stops sk_psock_backlog from running after sk_psock_purge:


CPU 1							CPU 2

sk_psock_skb_redirect()
  sk_psock(sk_other)
  sock_flag(sk_other, SOCK_DEAD)
  sk_psock_test_state(psock_other,
                      SK_PSOCK_TX_ENABLED)
							sk_psock_purge()
  skb_queue_tail(&psock_other->ingress_skb, skb)
  schedule_work(&psock_other->work)


And sock_orphan can run while we're in sendmsg/sendpage_unlocked:


CPU 1                                                   CPU 2

sk_psock_backlog
  ...
  sendmsg_unlocked
    sock = sk->sk_socket
                                                        tcp_close
                                                          __tcp_close
                                                            sock_orphan
    kernel_sendmsg(sock, msg, vec, num, size)


So, after this change, without lock_sock in sk_psock_backlog, we will
not block tcp_close from running.

This makes me think that the process socket can get released from under
us, before kernel_sendmsg/sendpage runs.

What did I miss?
