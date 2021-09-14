Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07EF40A5CE
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 07:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239509AbhINFPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 01:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239472AbhINFPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 01:15:20 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7DDC061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 22:14:03 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f65so11037163pfb.10
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 22:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mcvft/WSJsosP49uzH6QwlI5VYO6arRd3KcMaD9r3u0=;
        b=C+wN8jyrH+M3VE+TKNY3bv+N+q5VUooVF0zHp4BuDvZPCYL2IO0My+JJcrdpObQSi2
         uxv7sOY6HkVQnZhRajp0U5XIXKyQ+eJoG5bzCl48kScV//uRg50pUX909Nl1gCE8UT/H
         f97xRh91WHUuDL/KnxRLq1Ewdiu5dJnlojbpptFG7n0jvUAODvLmjLcPzIu2KKGqe7BH
         3ku4rh/venoq6kmbh3TEqRdbtbihGMvpakMEik8E2WgEFTehV9PVVaVcbwMvx1QLnpzZ
         eT4cFcAxbJip7s3I3opPSsXSTFCRbGHr6apa9cUjpPkyO8CUza5q6Uwy/SaWoJNjVwCM
         ONnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mcvft/WSJsosP49uzH6QwlI5VYO6arRd3KcMaD9r3u0=;
        b=7xlkrGL5LnkATpMPAYH2lZoEpymMVj4jVcbdM0F/7rtkZIW4iOH0EhQeaN8KAbvyV7
         2DiLsaUnYukEnnpmTgip3Oya3j6gV7JzEOeVwVW+7G15Cg0HdddsYpX9cbuPtOqCIy4p
         exqvOTMvOLtwaqZRSLNpSqzVMQe2MiBoqefMkfKJJ7kiPRtB+nTjPLqzdpp/jGz2nLLV
         iqemc+FXHijmzZqlEICRJFd4GvYOaZCV4p86I6vt3rRp6Ziy8cgRMV7tcHWxQEZr9Sow
         rZCL8aVzP7f6pXDHOKvBy1vSTgKoM++a2a461xYuzJvaKMrbwTPrJqcYgtAXVmNJM3rL
         2wXw==
X-Gm-Message-State: AOAM531JoeQLl5fb6722LKgSU7bj+FK/2rnFrpv9C0GU3WcX//yZGc7R
        KY48c/hhIPgF3vaMi1G/q75g75WxQKs=
X-Google-Smtp-Source: ABdhPJxtiQY+YRLGXyW0Qmjj4FZilQgHIpN9k9P7eAdazCFGK8NgUhFt5eZC+2TQ4Eqdcij6WZZ+vg==
X-Received: by 2002:a63:d205:: with SMTP id a5mr13986453pgg.30.1631596442785;
        Mon, 13 Sep 2021 22:14:02 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 207sm6168728pfu.56.2021.09.13.22.14.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 22:14:02 -0700 (PDT)
Subject: Re: [RFC net] net: stream: don't purge sk_error_queue without holding
 its lock
To:     Jakub Kicinski <kuba@kernel.org>, eric.dumazet@gmail.com
Cc:     willemb@google.com, netdev@vger.kernel.org
References: <20210913223850.660578-1-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3b5549a2-cb0e-0dc1-3cb3-00d15a74873b@gmail.com>
Date:   Mon, 13 Sep 2021 22:14:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210913223850.660578-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/13/21 3:38 PM, Jakub Kicinski wrote:
> sk_stream_kill_queues() can be called when there are still
> outstanding skbs to transmit. Those skbs may try to queue
> notifications to the error queue (e.g. timestamps).
> If sk_stream_kill_queues() purges the queue without taking
> its lock the queue may get corrupted.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Sending as an RFC for review, compile-tested only.
> 
> Seems far more likely that I'm missing something than that
> this has been broken forever and nobody noticed :S
> ---
>  net/core/stream.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/stream.c b/net/core/stream.c
> index 4f1d4aa5fb38..7c585088f394 100644
> --- a/net/core/stream.c
> +++ b/net/core/stream.c
> @@ -196,7 +196,7 @@ void sk_stream_kill_queues(struct sock *sk)
>  	__skb_queue_purge(&sk->sk_receive_queue);
>  
>  	/* Next, the error queue. */
> -	__skb_queue_purge(&sk->sk_error_queue);
> +	skb_queue_purge(&sk->sk_error_queue);
>  
>  	/* Next, the write queue. */
>  	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
> 


This should not be needed.

By definition, sk_stream_kill_queues() is only called when there is no
more references on the sockets.

So all outstanding packets must have been orphaned or freed.

Anyway, Linux-2.6.12-rc2 had no timestamps yet.
