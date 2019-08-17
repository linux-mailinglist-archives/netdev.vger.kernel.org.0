Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553C6910B8
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 16:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfHQOT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 10:19:59 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:55292 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbfHQOT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 10:19:59 -0400
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x7HEHr05016447;
        Sat, 17 Aug 2019 15:19:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=HZUK4esCpMqWRr83UOdTiJtE5q50tG9xMYSW+4E+yJY=;
 b=Jnrl9D8gIGztQ/EVEdcuhefZgpGw1Dy4dQtXflQv9qAZ7P/Hy1M1h3tclHs6oqvTXVkJ
 cNKrg03Kw3eBilQaYbhtDeW6CcrHXG/KoDWLuBXJZTxwCjUkOUbaiZtaNAVOnOBVWTWr
 c9lmzAWloOQBKZeAHC1XBzejysDZ2feolIwpnZ6AQ10Ag+n4o0f77ca+ofkbeqlqZgYc
 x0++MyQNEN+On6j2Ff7L9sm1q8z3DG6TVHUuV/WlQfjHokpte8QuO69HohZU2Me7J79l
 Ft/kq1ldtNpCNpUzWFQDiWVVTA2dkMt0VjKW0H3sSmV3wZ2QehgX31zRaIdKvNqmDA5f qA== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 2uea0asq1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Aug 2019 15:19:53 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x7HEGoIi004445;
        Sat, 17 Aug 2019 10:19:52 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2uecwv13kf-1;
        Sat, 17 Aug 2019 10:19:52 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id D450D1FC6B;
        Sat, 17 Aug 2019 14:19:51 +0000 (GMT)
Subject: Re: [PATCH net] tcp: make sure EPOLLOUT wont be missed
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vladimir Rutsky <rutsky@google.com>
References: <20190817042622.91497-1-edumazet@google.com>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <b9ab6b03-664c-eb81-0fbd-6f696276d9aa@akamai.com>
Date:   Sat, 17 Aug 2019 10:19:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190817042622.91497-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-17_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908170154
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-17_06:2019-08-16,2019-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 clxscore=1011 phishscore=0 bulkscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=2 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908170154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/19 12:26 AM, Eric Dumazet wrote:
> As Jason Baron explained in commit 790ba4566c1a ("tcp: set SOCK_NOSPACE
> under memory pressure"), it is crucial we properly set SOCK_NOSPACE
> when needed.
> 
> However, Jason patch had a bug, because the 'nonblocking' status
> as far as sk_stream_wait_memory() is concerned is governed
> by MSG_DONTWAIT flag passed at sendmsg() time :
> 
>     long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
> 
> So it is very possible that tcp sendmsg() calls sk_stream_wait_memory(),
> and that sk_stream_wait_memory() returns -EAGAIN with SOCK_NOSPACE
> cleared, if sk->sk_sndtimeo has been set to a small (but not zero)
> value.

Is MSG_DONTWAIT not set in this case? The original patch was intended
only for the explicit non-blocking case. The epoll manpage says:
"EPOLLET flag should use nonblocking file descriptors". So the original
intention was not to impact the blocking case. This seems to me like
a different use-case.

Thanks,

-Jason


> This patch removes the 'noblock' variable since we must always
> set SOCK_NOSPACE if -EAGAIN is returned.
> 
> It also renames the do_nonblock label since we might reach this
> code path even if we were in blocking mode.
> 
> Fixes: 790ba4566c1a ("tcp: set SOCK_NOSPACE under memory pressure")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
> Reported-by: Vladimir Rutsky  <rutsky@google.com>
> ---
>  net/core/stream.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/net/core/stream.c b/net/core/stream.c
> index e94bb02a56295ec2db34ab423a8c7c890df0a696..4f1d4aa5fb38d989a9c81f32dfce3f31bbc1fa47 100644
> --- a/net/core/stream.c
> +++ b/net/core/stream.c
> @@ -120,7 +120,6 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
>  	int err = 0;
>  	long vm_wait = 0;
>  	long current_timeo = *timeo_p;
> -	bool noblock = (*timeo_p ? false : true);
>  	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>  
>  	if (sk_stream_memory_free(sk))
> @@ -133,11 +132,8 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
>  
>  		if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))
>  			goto do_error;
> -		if (!*timeo_p) {
> -			if (noblock)
> -				set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
> -			goto do_nonblock;
> -		}
> +		if (!*timeo_p)
> +			goto do_eagain;
>  		if (signal_pending(current))
>  			goto do_interrupted;
>  		sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
> @@ -169,7 +165,13 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
>  do_error:
>  	err = -EPIPE;
>  	goto out;
> -do_nonblock:
> +do_eagain:
> +	/* Make sure that whenever EAGAIN is returned, EPOLLOUT event can
> +	 * be generated later.
> +	 * When TCP receives ACK packets that make room, tcp_check_space()
> +	 * only calls tcp_new_space() if SOCK_NOSPACE is set.
> +	 */
> +	set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
>  	err = -EAGAIN;
>  	goto out;
>  do_interrupted:
> 
