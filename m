Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B40834BD4D
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 17:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbfFSPyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 11:54:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42029 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFSPyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 11:54:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so10004673pff.9
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 08:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ASmM9gQmF/3k+Nfuv02EdnEKhKJvjuRw3mP4uOO9qGg=;
        b=iIY5sOfQvEbdAvdDmTqt+ZKKVRAmAe+1wv4aDXwi3CtVBmymL8Kl/SzPiB8tII3vqx
         wpNurwisErBzTOqcEVGYYX9Ccw0G9CXo7BznCfjAP7Ad/y0kRLuyenatQ+3a7mfZTakF
         KzbDC5ny3jaGNLEEYXxKD9mPHNhzOs7UgA1qH2dJtKkuHu5rupPE8vNGy4YFkt1MW/Je
         NP0/TAvz6hXzMKAGQdKUk44Gn/nGXmcYgNIZ9UuaQYkS5C4VtnanXTL62w7udZXzilOj
         na5D2x52ohy1Z14M0giqYfa9LsdUhyI2SsMPYOWTfBOF8x+9Pq8ddlkLMHnONCGWBj6B
         2A/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ASmM9gQmF/3k+Nfuv02EdnEKhKJvjuRw3mP4uOO9qGg=;
        b=jVnFFU6YrPW02pRh5nWQvvr5B3hp1WkU7EMZ6gA1+WbmSKp694iVsr55dwETeI1mVp
         drtULCpJL86dDCzvHR94rNF2CcuuJqaG+hmekSeFpfcMS4hfSts3yVpNI8nid+u6YL11
         1Rcp1quBDNQ+Rp0c+Wn99RCltqAuFstTEFHztFhPUBEnrBGUc3kMcJF52hVcuXEoBM3Y
         +DBe71XcVme4TswC4wIX8/sUyUpdrtoWJrgUEdIX1GbGfutbc4HQ38sg0gE0bFhm/AI3
         WopZG0mUqnvbN1UiLkZKEb3UQyVVOe5aGSplDI+BKVTbsGFYksGfvR4MKomWPnW6XDze
         5I5g==
X-Gm-Message-State: APjAAAVXgzv+66yBBbH4/Op3BWxM7BheMe31bA0eL6MzzAJio5Ir7CIU
        csPlzh/EbdSaUlAw0ckfF+UHmW5R
X-Google-Smtp-Source: APXvYqwbeIWURPm9w1tvoEj5lqfCiyp2I+pgSI/R5Ld6uIi5VBYr8AzT2LJKCpPgwfMBV9B2a3M6Vw==
X-Received: by 2002:a63:4104:: with SMTP id o4mr8637149pga.345.1560959652892;
        Wed, 19 Jun 2019 08:54:12 -0700 (PDT)
Received: from [172.31.75.235] ([216.9.110.12])
        by smtp.gmail.com with ESMTPSA id p23sm2308371pjo.4.2019.06.19.08.54.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 08:54:12 -0700 (PDT)
Subject: Re: [PATCH net-next 4/8] tcp: undo init congestion window on false
 SYNACK timeout
To:     Yuchung Cheng <ycheng@google.com>, davem@davemloft.net,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, soheil@google.com
References: <20190429224620.151064-1-ycheng@google.com>
 <20190429224620.151064-5-ycheng@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c0d35c03-0d95-b316-7ae9-64ca4251bba7@gmail.com>
Date:   Wed, 19 Jun 2019 08:54:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190429224620.151064-5-ycheng@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/19 3:46 PM, Yuchung Cheng wrote:
> Linux implements RFC6298 and use an initial congestion window
> of 1 upon establishing the connection if the SYNACK packet is
> retransmitted 2 or more times. In cellular networks SYNACK timeouts
> are often spurious if the wireless radio was dormant or idle. Also
> some network path is longer than the default SYNACK timeout. In
> both cases falsely starting with a minimal cwnd are detrimental
> to performance.
> 
> This patch avoids doing so when the final ACK's TCP timestamp
> indicates the original SYNACK was delivered. It remembers the
> original SYNACK timestamp when SYNACK timeout has occurred and
> re-uses the function to detect spurious SYN timeout conveniently.
> 
> Note that a server may receives multiple SYNs from and immediately
> retransmits SYNACKs without any SYNACK timeout. This often happens
> on when the client SYNs have timed out due to wireless delay
> above. In this case since the server will still use the default
> initial congestion (e.g. 10) because tp->undo_marker is reset in
> tcp_init_metrics(). This is an intentional design because packets
> are not lost but delayed.
> 
> This patch only covers regular TCP passive open. Fast Open is
> supported in the next patch.
> 
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv4/tcp_input.c     | 2 ++
>  net/ipv4/tcp_minisocks.c | 5 +++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 30c6a42b1f5b..53b4c5a3113b 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6101,6 +6101,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
>  			 */
>  			tcp_rearm_rto(sk);
>  		} else {
> +			tcp_try_undo_spurious_syn(sk);
> +			tp->retrans_stamp = 0;
>  			tcp_init_transfer(sk, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB);
>  			tp->copied_seq = tp->rcv_nxt;
>  		}
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 79900f783e0d..9c2a0d36fb20 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -522,6 +522,11 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
>  		newtp->rx_opt.ts_recent_stamp = 0;
>  		newtp->tcp_header_len = sizeof(struct tcphdr);
>  	}
> +	if (req->num_timeout) {

It seems that req->num_timeout could contain garbage value at this point.

That is because we clear req->num_timeout late (in reqsk_queue_hash_req())

I will send a fix.


> +		newtp->undo_marker = treq->snt_isn;
> +		newtp->retrans_stamp = div_u64(treq->snt_synack,
> +					       USEC_PER_SEC / TCP_TS_HZ);
> +	}
>  	newtp->tsoffset = treq->ts_off;
>  #ifdef CONFIG_TCP_MD5SIG
>  	newtp->md5sig_info = NULL;	/*XXX*/
> 
