Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744EB30FF6E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhBDVi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhBDViY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:38:24 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF59AC061788
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 13:37:43 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id l12so5339317wry.2
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 13:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kV3pdYkUMMPTc34QJ2Tps7N4vq40FHIT1DCdZKrmptE=;
        b=aOdtPDYDbkiEgX5SB2fOuTpADIxQaprWjbNhni26KnpeU+Aih4ppZn1u/N+CrAe2Nv
         bgvSBpOfJhPDHQY8UDdSXeFVAF4i8LT6HzqbRLfPFOc0I1F8c5ftA4totHGsDRMI95Ko
         Nb8FMpTMHyVzIgyHUyntP5ykiabnlh2N0Dxg/wo9h10+S3kjsd1FdCrbvni4EUHEKvfR
         DF2Ip30t6sEu/EisB/SET07CJxXHfBUgTQ0yCYst3fpjWKWXbjq0ho0SnN3bxMqqZgMt
         AgvNGcVQHkwRjdC/5D7Xaw8q/473G3JoTATKmlpT/frNPoh1cMSHCJ+MDX8fbuzowAMF
         e1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kV3pdYkUMMPTc34QJ2Tps7N4vq40FHIT1DCdZKrmptE=;
        b=VcE8kvcXLsO8SBZ0JPdtXKC2AS9unPdp+lqZy14jz10+P/yob8iUY3r6t4MHYhMia1
         wMR4PFCDMTkmbFE7W48q8hp8oFHa2EKemENijVI/M2cbWu06vJgMiRg9+cdXYXJSNYre
         WwuWk9N5rIZb1wwk6yK2Jso3IucNhtuH9YkNmwMQlk9khgghzNaSpjJklEFOyETdK6G6
         Y2HOFplazYbA8Wnf/rDFuBpne9nQCva8oJDnf4c1QR8FvwEjLaL8PvDXS7UW0D57EV3d
         qcL47/RPWj114CUvZx6vBtM4Qnq05gFFVa+gyC6atwvITeVOt8MAL1bPKViMvs72OywA
         27HQ==
X-Gm-Message-State: AOAM530c0ojqhJ+7MW1Qq4cRECNDhN4iLBPNvN8X+GAHThe4gjcL8WzK
        nuS4DdN9xUzZizo/XQp4JOgDcWxYT9w=
X-Google-Smtp-Source: ABdhPJzZVVhRIccF0Dm38m5eaT36rv61sTgG/KhW9t9Wr0tEqlA0nH7SxyJyLjM8BL4JfRfIWMqEUQ==
X-Received: by 2002:adf:ee09:: with SMTP id y9mr1470523wrn.74.1612474662455;
        Thu, 04 Feb 2021 13:37:42 -0800 (PST)
Received: from [192.168.1.101] ([37.171.155.194])
        by smtp.gmail.com with ESMTPSA id 35sm10834320wrn.42.2021.02.04.13.37.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 13:37:41 -0800 (PST)
Subject: Re: [PATCH] net/vmw_vsock: fix NULL pointer deref and improve locking
To:     Norbert Slusarek <nslusarek@gmx.net>,
        Stefano Garzarella <sgarzare@redhat.com>, alex.popov@linux.com,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
References: <trinity-64b93de7-52ac-4127-a29a-1a6dbbb7aeb6-1612474127915@3c-app-gmx-bap39>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d801ab6a-639d-579f-2292-9a7a557a593f@gmail.com>
Date:   Thu, 4 Feb 2021 22:37:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <trinity-64b93de7-52ac-4127-a29a-1a6dbbb7aeb6-1612474127915@3c-app-gmx-bap39>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/21 10:28 PM, Norbert Slusarek wrote:
> From: Norbert Slusarek <nslusarek@gmx.net>
> Date: Thu, 4 Feb 2021 18:49:24 +0100
> Subject: [PATCH] net/vmw_vsock: fix NULL pointer deref and improve locking
> 
> In vsock_stream_connect(), a thread will enter schedule_timeout().
> While being scheduled out, another thread can enter vsock_stream_connect() as
> well and set vsk->transport to NULL. In case a signal was sent, the first
> thread can leave schedule_timeout() and vsock_transport_cancel_pkt() will be
> called right after. Inside vsock_transport_cancel_pkt(), a null dereference
> will happen on transport->cancel_pkt.
> 
> The patch also features improved locking inside vsock_connect_timeout().


We request Fixes: tag for patches targeting net tree.

You could also mention the vsock_connect_timeout()
issue was found by a reviewer and give some credits ;)

> 
> Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
> ---
>  net/vmw_vsock/af_vsock.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 3b480ed0953a..ea7b9d208724 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -1233,7 +1233,7 @@ static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
>  {
>  	const struct vsock_transport *transport = vsk->transport;
> 
> -	if (!transport->cancel_pkt)
> +	if (!transport || !transport->cancel_pkt)
>  		return -EOPNOTSUPP;
> 
>  	return transport->cancel_pkt(vsk);
> @@ -1243,7 +1243,6 @@ static void vsock_connect_timeout(struct work_struct *work)
>  {
>  	struct sock *sk;
>  	struct vsock_sock *vsk;
> -	int cancel = 0;
> 
>  	vsk = container_of(work, struct vsock_sock, connect_work.work);
>  	sk = sk_vsock(vsk);
> @@ -1254,11 +1253,9 @@ static void vsock_connect_timeout(struct work_struct *work)
>  		sk->sk_state = TCP_CLOSE;
>  		sk->sk_err = ETIMEDOUT;
>  		sk->sk_error_report(sk);
> -		cancel = 1;
> +		vsock_transport_cancel_pkt(vsk);
>  	}
>  	release_sock(sk);
> -	if (cancel)
> -		vsock_transport_cancel_pkt(vsk);
> 
>  	sock_put(sk);
>  }
> --
> 2.30.0
> 
