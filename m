Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E39A173A20
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgB1OoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 09:44:10 -0500
Received: from relay.sw.ru ([185.231.240.75]:56082 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbgB1OoJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 09:44:09 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1j7grm-000633-He; Fri, 28 Feb 2020 17:43:50 +0300
Subject: Re: [PATCH net-next v2 1/2] unix: uses an atomic type for scm files
 accounting
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1582897428.git.pabeni@redhat.com>
 <a995b03e54307b878870810e2cf4083ce50f4dac.1582897428.git.pabeni@redhat.com>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <d3a47cb1-a320-cc2f-d0ea-afa64c590d33@virtuozzo.com>
Date:   Fri, 28 Feb 2020 17:43:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a995b03e54307b878870810e2cf4083ce50f4dac.1582897428.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.02.2020 16:45, Paolo Abeni wrote:
> So the scm_stat_{add,del} helper can be invoked with no
> additional lock held.
> 
> This clean-up the code a bit and will make the next
> patch easier.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>

> ---
>  include/net/af_unix.h |  2 +-
>  net/unix/af_unix.c    | 21 ++++++---------------
>  2 files changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/af_unix.h b/include/net/af_unix.h
> index 17e10fba2152..5cb65227b7a9 100644
> --- a/include/net/af_unix.h
> +++ b/include/net/af_unix.h
> @@ -42,7 +42,7 @@ struct unix_skb_parms {
>  } __randomize_layout;
>  
>  struct scm_stat {
> -	u32 nr_fds;
> +	atomic_t nr_fds;
>  };
>  
>  #define UNIXCB(skb)	(*(struct unix_skb_parms *)&((skb)->cb))
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index cbd7dc01e147..145a3965341e 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -689,7 +689,8 @@ static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
>  
>  	if (sk) {
>  		u = unix_sk(sock->sk);
> -		seq_printf(m, "scm_fds: %u\n", READ_ONCE(u->scm_stat.nr_fds));
> +		seq_printf(m, "scm_fds: %u\n",
> +			   atomic_read(&u->scm_stat.nr_fds));
>  	}
>  }
>  
> @@ -1598,10 +1599,8 @@ static void scm_stat_add(struct sock *sk, struct sk_buff *skb)
>  	struct scm_fp_list *fp = UNIXCB(skb).fp;
>  	struct unix_sock *u = unix_sk(sk);
>  
> -	lockdep_assert_held(&sk->sk_receive_queue.lock);
> -
>  	if (unlikely(fp && fp->count))
> -		u->scm_stat.nr_fds += fp->count;
> +		atomic_add(fp->count, &u->scm_stat.nr_fds);
>  }
>  
>  static void scm_stat_del(struct sock *sk, struct sk_buff *skb)
> @@ -1609,10 +1608,8 @@ static void scm_stat_del(struct sock *sk, struct sk_buff *skb)
>  	struct scm_fp_list *fp = UNIXCB(skb).fp;
>  	struct unix_sock *u = unix_sk(sk);
>  
> -	lockdep_assert_held(&sk->sk_receive_queue.lock);
> -
>  	if (unlikely(fp && fp->count))
> -		u->scm_stat.nr_fds -= fp->count;
> +		atomic_sub(fp->count, &u->scm_stat.nr_fds);
>  }
>  
>  /*
> @@ -1801,10 +1798,8 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>  	if (sock_flag(other, SOCK_RCVTSTAMP))
>  		__net_timestamp(skb);
>  	maybe_add_creds(skb, sock, other);
> -	spin_lock(&other->sk_receive_queue.lock);
>  	scm_stat_add(other, skb);
> -	__skb_queue_tail(&other->sk_receive_queue, skb);
> -	spin_unlock(&other->sk_receive_queue.lock);
> +	skb_queue_tail(&other->sk_receive_queue, skb);
>  	unix_state_unlock(other);
>  	other->sk_data_ready(other);
>  	sock_put(other);
> @@ -1906,10 +1901,8 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>  			goto pipe_err_free;
>  
>  		maybe_add_creds(skb, sock, other);
> -		spin_lock(&other->sk_receive_queue.lock);
>  		scm_stat_add(other, skb);
> -		__skb_queue_tail(&other->sk_receive_queue, skb);
> -		spin_unlock(&other->sk_receive_queue.lock);
> +		skb_queue_tail(&other->sk_receive_queue, skb);
>  		unix_state_unlock(other);
>  		other->sk_data_ready(other);
>  		sent += size;
> @@ -2405,9 +2398,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>  			sk_peek_offset_bwd(sk, chunk);
>  
>  			if (UNIXCB(skb).fp) {
> -				spin_lock(&sk->sk_receive_queue.lock);
>  				scm_stat_del(sk, skb);
> -				spin_unlock(&sk->sk_receive_queue.lock);
>  				unix_detach_fds(&scm, skb);
>  			}
>  
> 

