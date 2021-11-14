Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED8144FB63
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 21:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbhKNUEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 15:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbhKNUEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 15:04:38 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E3DC061746
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 12:01:30 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id m24so2720485pls.10
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 12:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fxdLrUNdCdBTQXYpYAyJIpHQK1aQPT5DMRZe2BmyCxA=;
        b=Oxa0AF5v48y4wfx9FprpQBmGOD0ODUN+9JgylONh8KW4Dex0G7LgU34EElY4Cu/kPV
         lwmcTTh+h3LQtl+73/TOeHKJmxRa/y3wyYbyABWmoPcAk14mEbM37sXmlRb/OhQXaWx8
         XwrvBZK0EnR7dpvnLG7tDIHnGQ55TEOZUys65N4HLHRgp8oj8Ggna5bb2k2LiRtLe6DP
         3KeyXpJxPDzqcdnA7phqOXiNjTch9Y0VFLMMULMNKYNQFmDAnND6Y+BVuZk99YQiZtq+
         QbTH92tuhIErAcfdHjcrM42DA+dFx34Grj4VGhoieKjRb7bjOewgGcqP+gamLyAm0Tkp
         o65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fxdLrUNdCdBTQXYpYAyJIpHQK1aQPT5DMRZe2BmyCxA=;
        b=31sxfDpt0kPyYQnSZK8zVwmwGu3u+b7fyLoNgURKExHQd8IkNsNco/AjssDtOVp9mp
         0/B8Voo2UmXqnk68XtHFW90HQ0aegrv3YGiqfVbbjfvEh7sHecb9kOEmw5rD7QEftGBK
         JHWzKT7FdMcW5KfSgp0+28hneHirTLMqfReSnBHZhLZYfmQsbTSUwGhUuqIzYFzr8VW8
         floVDjF4mX5sskT3dzCfYtPcVKS6xEJydEUFibRFlTqairyutCqnqA5pwHuhVOEkh/k2
         gP1OzqL06EObmKJMvUZ0ajp0oVjtgjg1eOxBIuo1xSP7v6jxKPm9Fudt1yyfoYF0ft7V
         yJqw==
X-Gm-Message-State: AOAM532BVLMBf+XMbeJR9g1DlhJ/4UK3Xfj1nbGFTVhat0ANgEWHztYi
        4xVIhTPUfWieIcyDqAWmGLFVe13eeVI=
X-Google-Smtp-Source: ABdhPJyC44LVRi6VGeIffnclakiRO/DQfYXgaXu7uRr9M4Cp5rFf+8HgpwjiyGEYOkK+OcWSsxorxQ==
X-Received: by 2002:a17:903:18d:b0:142:8ab:d11f with SMTP id z13-20020a170903018d00b0014208abd11fmr28780144plg.47.1636920089618;
        Sun, 14 Nov 2021 12:01:29 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id i2sm12433271pfe.70.2021.11.14.12.01.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 12:01:29 -0800 (PST)
Subject: Re: [PATCH] sock: fix /proc/net/sockstat underflow in sk_clone_lock()
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        netdev@vger.kernel.org
References: <20211114060222.3370-1-penguin-kernel@I-love.SAKURA.ne.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ee46d850-7dcb-b9d5-b61c-56638fa2f9ae@gmail.com>
Date:   Sun, 14 Nov 2021 12:01:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211114060222.3370-1-penguin-kernel@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/13/21 10:02 PM, Tetsuo Handa wrote:
> sk_clone_lock() needs to call get_net() and sock_inuse_inc() together, or
> socket_seq_show() will underflow when __sk_free() from sk_free() from
> sk_free_unlock_clone() is called.
> 

IMO, a "sock_inuse_get() underflow" is a very different problem,
I suspect this should be fixed with the following patch.

diff --git a/net/core/sock.c b/net/core/sock.c
index c57d9883f62c75f522b7f6bc68451aaf8429dc83..bac8e2b62521301ce897728fff9622c4c05419a3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3573,7 +3573,7 @@ int sock_inuse_get(struct net *net)
        for_each_possible_cpu(cpu)
                res += *per_cpu_ptr(net->core.sock_inuse, cpu);
 
-       return res;
+       return max(res, 0);
 }
 
 EXPORT_SYMBOL_GPL(sock_inuse_get);


Bug added in commit 648845ab7e200993dccd3948c719c858368c91e7
Author: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu Dec 14 05:51:58 2017 -0800

    sock: Move the socket inuse to namespace.


> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  net/core/sock.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 8f2b2f2c0e7b..41e91d0f7061 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2124,8 +2124,10 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
>  	newsk->sk_prot_creator = prot;
>  
>  	/* SANITY */
> -	if (likely(newsk->sk_net_refcnt))
> +	if (likely(newsk->sk_net_refcnt)) {
>  		get_net(sock_net(newsk));
> +		sock_inuse_add(sock_net(newsk), 1);
> +	}
>  	sk_node_init(&newsk->sk_node);
>  	sock_lock_init(newsk);
>  	bh_lock_sock(newsk);
> @@ -2197,8 +2199,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
>  	newsk->sk_err_soft = 0;
>  	newsk->sk_priority = 0;
>  	newsk->sk_incoming_cpu = raw_smp_processor_id();
> -	if (likely(newsk->sk_net_refcnt))
> -		sock_inuse_add(sock_net(newsk), 1);
>  
>  	/* Before updating sk_refcnt, we must commit prior changes to memory
>  	 * (Documentation/RCU/rculist_nulls.rst for details)
> 
