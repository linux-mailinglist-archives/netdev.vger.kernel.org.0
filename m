Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA40D348BB
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfFDNbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:31:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37208 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfFDNbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:31:32 -0400
Received: by mail-pf1-f193.google.com with SMTP id a23so12713657pff.4;
        Tue, 04 Jun 2019 06:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3b5aub+eecNpo+4U92Rj62KFwfdLX+w3MzlhVC2SeQ0=;
        b=nDr3GyLSyEbLOjZ9Kc+s6Gi2ZoFfHg9lNRMq6CdYJRbZJrSjQnpOJZ1/A21Zr+7Jz8
         Bjr2dkpMZu6188dW0lBPP5JSEYTPmjlCXRnbtKMTBzMOO1bvVj01fkQiD6eNMotQ6p+N
         0rCYw3UkWqbvUFw3LCUvtF6sI4iL34c7cNgg4JYHgC/0ObVA+BN5q1C/Jmc0eYfivG+J
         eTrk46MFrtKj/4xjj/ZrQQxsPnwdg6+hH+bejYT5ePWNkVMvt0m3sB2NwM2LcAtHVGPf
         BflIm5CRvE0Nm3swYtM70TbGRXCaimgvLr3KQWN4pkNQUd1gUDe1tge6v9xwH3zB0HIG
         WZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3b5aub+eecNpo+4U92Rj62KFwfdLX+w3MzlhVC2SeQ0=;
        b=ATXEhslJTtIjK4z8fWkDGt8WzR3vYdwxxBX6cNutv03lg/cXRHETcMeMByP1fyRLN7
         71Wfwore1O838SYJXVTQL+MEpyX3lP8YkatRXI9o5HcsBDW/QF2Hp3+55/u7W58LhjFR
         rtRVGlSaOnHS5bTCAYRQ94qF8FGQCZisUxXO5sJ2tk+8h/wEkDSZOQUIr5EnlefJIXca
         HoZisftyHJmlUx6JtU1vQJhQOIFlyr3lRa4kpIxISfh2OE48aM73zoyPpPYJwY+isb1m
         0qnhjysZA2g432ko3dLt4AT9Q8Dixt54ECLlbClOHIvjS+4JAO6FREXOVhmAXbX5BarH
         Hijg==
X-Gm-Message-State: APjAAAXVRGqR2q7OSS96P0BuEwhtJwRIoO0oXzxMqjh8XWw0Xyc2cS91
        NWTkW3xE+AadgcXqMdjpg88CqY6e
X-Google-Smtp-Source: APXvYqyvUvoqZQRwD3+IAd/XJ22hnRVQk6nNZvcu9NNlpa4H7aEFxjUBMjmxaQ/jZhpt4l5kPXeS2w==
X-Received: by 2002:a17:90a:a596:: with SMTP id b22mr24671756pjq.20.1559655091975;
        Tue, 04 Jun 2019 06:31:31 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id u123sm18874576pfu.67.2019.06.04.06.31.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 06:31:31 -0700 (PDT)
Subject: Re: [PATCH] rose: af_rose: avoid overflows in rose_setsockopt()
To:     Young Xiao <92siuyang@gmail.com>, ralf@linux-mips.org,
        davem@davemloft.net, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1559650290-17054-1-git-send-email-92siuyang@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a3ac9063-b11a-347d-713b-846907765366@gmail.com>
Date:   Tue, 4 Jun 2019 06:31:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559650290-17054-1-git-send-email-92siuyang@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/19 5:11 AM, Young Xiao wrote:
> Check setsockopt arguments to avoid overflows and return -EINVAL for
> too large arguments.
> 
> See commit 32288eb4d940 ("netrom: avoid overflows in nr_setsockopt()")
> for details.
> 
> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> ---
>  net/rose/af_rose.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
> index e274bc6..af831ee9 100644
> --- a/net/rose/af_rose.c
> +++ b/net/rose/af_rose.c
> @@ -372,15 +372,15 @@ static int rose_setsockopt(struct socket *sock, int level, int optname,
>  {
>  	struct sock *sk = sock->sk;
>  	struct rose_sock *rose = rose_sk(sk);
> -	int opt;
> +	unsigned long opt;
>  
>  	if (level != SOL_ROSE)
>  		return -ENOPROTOOPT;
>  
> -	if (optlen < sizeof(int))
> +	if (optlen < sizeof(unsigned int))
>  		return -EINVAL;
>  
> -	if (get_user(opt, (int __user *)optval))
> +	if (get_user(opt, (unsigned int __user *)optval))
>  		return -EFAULT;
>  
>  	switch (optname) {
> @@ -389,31 +389,31 @@ static int rose_setsockopt(struct socket *sock, int level, int optname,
>  		return 0;
>  
>  	case ROSE_T1:
> -		if (opt < 1)
> +		if (opt < 1 || opt > ULONG_MAX / HZ)
>  			return -EINVAL;
>  		rose->t1 = opt * HZ;
>  		return 0;
>  
>  	case ROSE_T2:
> -		if (opt < 1)
> +		if (opt < 1 || opt > ULONG_MAX / HZ)
>  			return -EINVAL;
>  		rose->t2 = opt * HZ;
>  		return 0;
>  
>  	case ROSE_T3:
> -		if (opt < 1)
> +		if (opt < 1 || opt > ULONG_MAX / HZ)
>  			return -EINVAL;
>  		rose->t3 = opt * HZ;
>  		return 0;
>  
>  	case ROSE_HOLDBACK:
> -		if (opt < 1)
> +		if (opt < 1 || opt > ULONG_MAX / HZ)
>  			return -EINVAL;
>  		rose->hb = opt * HZ;
>  		return 0;
>  
>  	case ROSE_IDLE:
> -		if (opt < 0)
> +		if (opt < 0 || opt > ULONG_MAX / HZ)

Buggy check.

>  			return -EINVAL;
>  		rose->idle = opt * 60 * HZ;
>  		return 0;
> 
