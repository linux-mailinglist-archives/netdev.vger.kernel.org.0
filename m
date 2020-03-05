Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B1D17B06D
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 22:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgCEVRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 16:17:13 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50911 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgCEVRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 16:17:12 -0500
Received: by mail-pj1-f68.google.com with SMTP id nm6so128039pjb.0;
        Thu, 05 Mar 2020 13:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sMCdEJuXdOhoW7m3gO5zM39AjW+YF/Rrads4zZrd1kg=;
        b=QLDq4YaDIhaMBuukLE9flkTFbc+QtHMA/oiSdyTDoEucukwkh/qEIOtiLrIaSPrTK6
         IbBwi9DE4rWJY/cRk6jqyRNQWADhqF4G3vuMdui0IZQ7kCZlXSJ6hvraMZnX89JIvTfq
         BHstEMkSF+S53O+U2m43bKmbZaKOP7JCwhNQoCViZCDX8rGi8rzzaJV2caPcb181w2cV
         5Ih7zwO2yZySaFOkknNUNLu46EQk/KI0nqyA5a2gSpyIvBCNIcrXNyv4auEuOR6S6rYO
         wM8iKHLjtq8nNk20lh0Jm32XL9MiJhdHR8jU/J+3piz5zb/m8XsTiWgpo/DSCYRlR3js
         37Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sMCdEJuXdOhoW7m3gO5zM39AjW+YF/Rrads4zZrd1kg=;
        b=CwBtAR2tzZ4odrHefeJPSc4FBYLSmeegGAXL5vRWFqcQObrVYEjpZEn8I3xFeET2yV
         5lf8g6+SoqqPPgmPR60h0+pjdLz3OR968rHkuBbOzDUJWpDZkIqpxtTSVsCLT3JggrfV
         UShLh98Pf643wZRuzCtBxf/XWnRLzlsn5GAG3ksRQSgbtVd99sQ8Drcd0gv4j4OQo+eW
         0FBBLu/U2SRdx9z2RSOp0tt/0Du9ZEXRa3r8BfyWuDOik/bJukKZtezZMf5fXzTMLDCz
         v+JF4gDH7kkJs2FItyk4USnQcGIm6xNRPXhP9NEuZ+rfc1cvtn/NdlvdEBt6NUzj0uVI
         f2eg==
X-Gm-Message-State: ANhLgQ3Y/9YPnGzOOgoVDGjlTQhMckKIudO8KFUt21PKzdaTEUz5h5B8
        0Bd1HQ7QE15ovxOm+SU1HKfM2g9h
X-Google-Smtp-Source: ADFU+vuBValh/xWu8eZS3JQlD4ct4iHhbaZw6HRIxQki/aNn7M/w9mK7wdAYuhReqpJGtbECQIuY/w==
X-Received: by 2002:a17:902:401:: with SMTP id 1mr94281ple.177.1583443031459;
        Thu, 05 Mar 2020 13:17:11 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id na18sm8053910pjb.9.2020.03.05.13.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 13:17:10 -0800 (PST)
Subject: Re: [PATCH v3] net: memcg: late association of sock to memcg
To:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Roman Gushchin <guro@fb.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200305205525.245058-1-shakeelb@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9505d35b-f9fc-149b-6df5-e65ad95acabb@gmail.com>
Date:   Thu, 5 Mar 2020 13:17:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305205525.245058-1-shakeelb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/5/20 12:55 PM, Shakeel Butt wrote:
> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by such sockets will
> not be accounted by the memcg.
> 
> This issue is more widespread in cgroup v1 where network memory
> accounting is opt-in but it can happen in cgroup v2 if the source socket
> for the cloning was created in root memcg.
> 
> To fix the issue, just do the late association of the unassociated
> sockets at accept() time in the process context and then force charge
> the memory buffer already reserved by the socket.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
> Changes since v2:
> - Additional check for charging.
> - Release the sock after charging.
> 
> Changes since v1:
> - added sk->sk_rmem_alloc to initial charging.
> - added synchronization to get memory usage and set sk_memcg race-free.
> 
>  net/ipv4/inet_connection_sock.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index a4db79b1b643..5face55cf818 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -482,6 +482,26 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>  		}
>  		spin_unlock_bh(&queue->fastopenq.lock);
>  	}
> +
> +	if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> +		int amt;
> +
> +		/* atomically get the memory usage, set and charge the
> +		 * sk->sk_memcg.
> +		 */
> +		lock_sock(newsk);
> +
> +		/* The sk has not been accepted yet, no need to look at
> +		 * sk->sk_wmem_queued.
> +		 */
> +		amt = sk_mem_pages(newsk->sk_forward_alloc +
> +				   atomic_read(&sk->sk_rmem_alloc));
> +		mem_cgroup_sk_alloc(newsk);
> +		if (newsk->sk_memcg && amt)
> +			mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
> +
> +		release_sock(newsk);
> +	}
>  out:
>  	release_sock(sk);
>  	if (req)
> 

This patch looks fine, but why keeping the mem_cgroup_sk_alloc(newsk);
in sk_clone_lock() ?

Note that all TCP sk_clone_lock() calls happen in softirq context.
