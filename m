Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E69435A408
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhDIQwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbhDIQwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 12:52:30 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDABC061760
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 09:52:17 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 12so3260334wmf.5
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 09:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XESGj4ZAUZLRbAt8puPwjtTzAw9sXqSTQgzeKeuPXJg=;
        b=CPyHfZsU8doTTxIhMNsc2i99l2yqV0koovo/NAxVfSj+f60oA11iUn6V0aKjujovLc
         7V9GarMUICmxfL6is8Qni9VJWED5TCgD54h3n8HETEeQFSvXxnjF3eAcT2DUFaDCuZeX
         jijPgwAEtufZY0xQQeRjXjO5422pqKkg/UxKtALdvDGu+EDj62252iC6/NI4FW+wmLHe
         kxbWrUmlspY36cLiiB/woowQ/hBPlNd4DqGUFBb6aeWQrZt2V1C+O/lkKuAKzDAFSjpm
         16z9mZjeHNt4JAyuK43Qz66XARqkpxWkliBGnE0VAIuENksmqOrSsHd8yIcR7rJh4CvO
         s26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XESGj4ZAUZLRbAt8puPwjtTzAw9sXqSTQgzeKeuPXJg=;
        b=d+4TNEC2pXE7qbAF/G+xrfMjUhTUo7AaLpuUN6c/BGk6zf/k/8YsVSOOdssWa7xSjZ
         Akaf6wPkQcKqsLfQfKoECsGtKb93C3XYbNs/ZSiehF9LCMUU+wrEdsoRuC3yJYeZWzYU
         JjMGsa88OQ4wklDjVnbtdEysGZwxzuDaV9Wl3ctuYcsT1tlNN8Ksw2n620PAPJtIqhQ6
         T3dMxwU+OpW6CjvK5NdfXgUY3hsQpqTaopzFLIqcyd18siqR7mU63b4bRwWhx363NWNZ
         TgIafUPsDzUeIi9yuEdLvUi0/IlDMMRB2MIj7wZ0erELu+TfFcxqCjkQStugGK/nT9QL
         Ewpw==
X-Gm-Message-State: AOAM533X+BBHsSK8Ot2QWA2qmvvhPZnNfbVD/PhKGf3l9icyDO6iJLo+
        krr5P/3CXcSl1x7pRjUw7lI=
X-Google-Smtp-Source: ABdhPJydjqmktKnT6Ei2/lo0rStYD5yuwlZMDSJyW1g0rHH/RgSUSJi1owYzQ3wOSh6S4TzE/3Xyng==
X-Received: by 2002:a7b:c202:: with SMTP id x2mr10093829wmi.33.1617987136125;
        Fri, 09 Apr 2021 09:52:16 -0700 (PDT)
Received: from [192.168.1.101] ([37.167.116.29])
        by smtp.gmail.com with ESMTPSA id g189sm4877518wmf.14.2021.04.09.09.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 09:52:15 -0700 (PDT)
Subject: Re: [PATCH] tcp: Reset tcp connections in SYN-SENT state
To:     Manoj Basapathi <manojbm@codeaurora.org>, netdev@vger.kernel.org
Cc:     jgarzik@pobox.com, avem@davemloft.net, shemminger@vyatta.com,
        linville@tuxdriver.com, mkubecek@suse.cz, kuba@kernel.org,
        bpf@iogearbox.net, dsahern@gmail.com, kubakici@wp.pl,
        sharathv@qti.qualcomm.com, ssaha@qti.qualcomm.com,
        vidulak@qti.qualcomm.com, manojbm@qti.qualcomm.com,
        subashab@quicinc.com, rpavan@qti.qualcomm.com,
        Sauvik Saha <ssaha@codeaurora.org>
References: <20210405170242.830-1-manojbm@codeaurora.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <88c2e98e-8be8-3a18-81e0-9b2ad89cff75@gmail.com>
Date:   Fri, 9 Apr 2021 18:52:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210405170242.830-1-manojbm@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/5/21 7:02 PM, Manoj Basapathi wrote:
> Userspace sends tcp connection (sock) destroy on network switch
> i.e switching the default network of the device between multiple
> networks(Cellular/Wifi/Ethernet).
> 
> Kernel though doesn't send reset for the connections in SYN-SENT state
> and these connections continue to remain.
> Even as per RFC 793, there is no hard rule to not send RST on ABORT in
> this state.
> 
> Modify tcp_abort and tcp_disconnect behavior to send RST for connections
> in syn-sent state to avoid lingering connections on network switch.
> 
> Signed-off-by: Manoj Basapathi <manojbm@codeaurora.org>
> Signed-off-by: Sauvik Saha <ssaha@codeaurora.org>
> ---
>  net/ipv4/tcp.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e14fd0c50c10..627a472161fb 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2888,7 +2888,7 @@ static inline bool tcp_need_reset(int state)
>  {
>  	return (1 << state) &
>  	       (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT | TCPF_FIN_WAIT1 |
> -		TCPF_FIN_WAIT2 | TCPF_SYN_RECV);
> +		TCPF_FIN_WAIT2 | TCPF_SYN_RECV | TCPF_SYN_SENT);
>  }
>  
>  static void tcp_rtx_queue_purge(struct sock *sk)
> @@ -2954,8 +2954,7 @@ int tcp_disconnect(struct sock *sk, int flags)
>  		 */
>  		tcp_send_active_reset(sk, gfp_any());
>  		sk->sk_err = ECONNRESET;
> -	} else if (old_state == TCP_SYN_SENT)
> -		sk->sk_err = ECONNRESET;
> +	}
>  
>  	tcp_clear_xmit_timers(sk);
>  	__skb_queue_purge(&sk->sk_receive_queue);
> 

This is a completely buggy patch.

This has been sent to many people but _not_ to TCP maintainers ????

I will send a revert.
