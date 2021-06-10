Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A753A32A1
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhFJSCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:02:16 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:44907 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFJSCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:02:16 -0400
Received: by mail-wm1-f48.google.com with SMTP id m41-20020a05600c3b29b02901b9e5d74f02so3861075wms.3;
        Thu, 10 Jun 2021 11:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yuHv6RIBLHggxcOlKYOigl4Pz2f4+BXgIKr78us9l0c=;
        b=XYLoAuRI4wC3/lTj9rPk8L7qJF6v7KXS6YrFkw4ud0LLJ7FDIvGq2cQqEG7hGU+Cxa
         uOUUqL83kkn1UnZoLky1chZbHO+r2ob0m2hNfkUVvIQ1k+237n2k7a8uaZKQf3XcikwB
         0EXPXBZf8EyRAcTlGWR2EF42poWGu2hFUpDEgtwc/4c+Xrp7g1n5uqu8PiRYP4YQ5OUs
         +Hu5LVeiO7bM9090wiql0ysGJtVF17WtIabIZi2CrPRlIeK35p6LqBp89sMd+YbwoY2r
         wRwBXQ0Fcifdog89a19s+mvzZkx7diyYtAFvxLlUmRQD9jJ394esHcJntV4cHrxfoVmM
         bNOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yuHv6RIBLHggxcOlKYOigl4Pz2f4+BXgIKr78us9l0c=;
        b=gix4RYcEjl1Xnx4YA2aduSCMa3hShVq0Ms92LemLhuc5eNJd9R+02KBJ0rw0mumovY
         UCkwhxkXb+t6JDM37d4UvxepHJ1YfWY35EFRVlAFpqTcmXTH/DWCcybfE9Ls1NZng7bj
         6RFqEtF1TlG2Ij0i/Tj61c2CriWzD/xQ3ZWCRo6fdYCo6O5nHNE/AYx7Cmeilp9VzDyG
         k4tACwKeKhTX81sMekruKUOjTs9+tgsWU1uOEEOPI4OOnOsPWgKR+AkD0+BfrHYm/iZx
         n5pVZyO6kQdILNJLS6g0TR1WBjzpfjcvS+9A2Aq1e4oCcUAVG7y24EgzYe4R2bao3SbH
         j+fw==
X-Gm-Message-State: AOAM531Wfj28aISWXQCkrR7pLTud7MGVfQ3HKlu90LU1NZhvN8A//tjL
        qAwnPcv3DvW7ie9ZvllDYft/8GfbwWISMg==
X-Google-Smtp-Source: ABdhPJyDjo7Tdxg5kVxwRX8DoqxanBiePRw1F6nh5nQedv93R0/glByw2dbe4920UrV5kg3u7ac9MA==
X-Received: by 2002:a7b:c3da:: with SMTP id t26mr60961wmj.63.1623347958477;
        Thu, 10 Jun 2021 10:59:18 -0700 (PDT)
Received: from [192.168.181.98] (228.18.23.93.rev.sfr.net. [93.23.18.228])
        by smtp.gmail.com with ESMTPSA id p16sm4442505wrs.52.2021.06.10.10.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 10:59:17 -0700 (PDT)
Subject: Re: [PATCH v7 bpf-next 03/11] tcp: Keep TCP_CLOSE sockets in the
 reuseport group.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210521182104.18273-1-kuniyu@amazon.co.jp>
 <20210521182104.18273-4-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c89d2cec-4cf2-1972-354b-5f5ca1330d82@gmail.com>
Date:   Thu, 10 Jun 2021 19:59:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521182104.18273-4-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> When we close a listening socket, to migrate its connections to another
> listener in the same reuseport group, we have to handle two kinds of child
> sockets. One is that a listening socket has a reference to, and the other
> is not.
> 
> The former is the TCP_ESTABLISHED/TCP_SYN_RECV sockets, and they are in the
> accept queue of their listening socket. So we can pop them out and push
> them into another listener's queue at close() or shutdown() syscalls. On
> the other hand, the latter, the TCP_NEW_SYN_RECV socket is during the
> three-way handshake and not in the accept queue. Thus, we cannot access
> such sockets at close() or shutdown() syscalls. Accordingly, we have to
> migrate immature sockets after their listening socket has been closed.
> 
> Currently, if their listening socket has been closed, TCP_NEW_SYN_RECV
> sockets are freed at receiving the final ACK or retransmitting SYN+ACKs. At
> that time, if we could select a new listener from the same reuseport group,
> no connection would be aborted. However, we cannot do that because
> reuseport_detach_sock() sets NULL to sk_reuseport_cb and forbids access to
> the reuseport group from closed sockets.
> 
> This patch allows TCP_CLOSE sockets to remain in the reuseport group and
> access it while any child socket references them. The point is that
> reuseport_detach_sock() was called twice from inet_unhash() and
> sk_destruct(). This patch replaces the first reuseport_detach_sock() with
> reuseport_stop_listen_sock(), which checks if the reuseport group is
> capable of migration. If capable, it decrements num_socks, moves the socket
> backwards in socks[] and increments num_closed_socks. When all connections
> are migrated, sk_destruct() calls reuseport_detach_sock() to remove the
> socket from socks[], decrement num_closed_socks, and set NULL to
> sk_reuseport_cb.
> 
> By this change, closed or shutdowned sockets can keep sk_reuseport_cb.
> Consequently, calling listen() after shutdown() can cause EADDRINUSE or
> EBUSY in inet_csk_bind_conflict() or reuseport_add_sock() which expects
> such sockets not to have the reuseport group. Therefore, this patch also
> loosens such validation rules so that a socket can listen again if it has a
> reuseport group with num_closed_socks more than 0.
> 
> When such sockets listen again, we handle them in reuseport_resurrect(). If
> there is an existing reuseport group (reuseport_add_sock() path), we move
> the socket from the old group to the new one and free the old one if
> necessary. If there is no existing group (reuseport_alloc() path), we
> allocate a new reuseport group, detach sk from the old one, and free it if
> necessary, not to break the current shutdown behaviour:
> 
>   - we cannot carry over the eBPF prog of shutdowned sockets
>   - we cannot attach/detach an eBPF prog to/from listening sockets via
>     shutdowned sockets
> 
> Note that when the number of sockets gets over U16_MAX, we try to detach a
> closed socket randomly to make room for the new listening socket in
> reuseport_grow().
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/net/sock_reuseport.h    |   1 +
>  net/core/sock_reuseport.c       | 184 ++++++++++++++++++++++++++++++--
>  net/ipv4/inet_connection_sock.c |  12 ++-
>  net/ipv4/inet_hashtables.c      |   2 +-
>  4 files changed, 188 insertions(+), 11 deletions(-)
> 
> diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> index 0e558ca7afbf..1333d0cddfbc 100644
> --- a/include/net/sock_reuseport.h
> +++ b/include/net/sock_reuseport.h
> @@ -32,6 +32,7 @@ extern int reuseport_alloc(struct sock *sk, bool bind_inany);
>  extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
>  			      bool bind_inany);
>  extern void reuseport_detach_sock(struct sock *sk);
> +void reuseport_stop_listen_sock(struct sock *sk);
>  extern struct sock *reuseport_select_sock(struct sock *sk,
>  					  u32 hash,
>  					  struct sk_buff *skb,
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index 079bd1aca0e7..ea0e900d3e97 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -17,6 +17,8 @@
>  DEFINE_SPINLOCK(reuseport_lock);
>  
>  static DEFINE_IDA(reuseport_ida);
> +static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> +			       struct sock_reuseport *reuse, bool bind_inany);
>  
>  static int reuseport_sock_index(struct sock *sk,
>  				struct sock_reuseport *reuse,
> @@ -61,6 +63,29 @@ static bool __reuseport_detach_sock(struct sock *sk,
>  	return true;
>  }
>  
> +static void __reuseport_add_closed_sock(struct sock *sk,
> +					struct sock_reuseport *reuse)
> +{
> +	reuse->socks[reuse->max_socks - reuse->num_closed_socks - 1] = sk;
> +	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
> +	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks + 1);
> +}
> +
> +static bool __reuseport_detach_closed_sock(struct sock *sk,
> +					   struct sock_reuseport *reuse)
> +{
> +	int i = reuseport_sock_index(sk, reuse, true);
> +
> +	if (i == -1)
> +		return false;
> +
> +	reuse->socks[i] = reuse->socks[reuse->max_socks - reuse->num_closed_socks];
> +	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
> +	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks - 1);
> +
> +	return true;
> +}
> +
>  static struct sock_reuseport *__reuseport_alloc(unsigned int max_socks)
>  {
>  	unsigned int size = sizeof(struct sock_reuseport) +
> @@ -92,6 +117,14 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
>  	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
>  					  lockdep_is_held(&reuseport_lock));
>  	if (reuse) {
> +		if (reuse->num_closed_socks) {
> +			/* sk was shutdown()ed before */
> +			int err = reuseport_resurrect(sk, reuse, NULL, bind_inany);
> +
> +			spin_unlock_bh(&reuseport_lock);
> +			return err;

It seems coding style in this function would rather do
			ret = reuseport_resurrect(sk, reuse, NULL, bind_inany);
			goto out;

Overall, changes in this commit are a bit scarry.
