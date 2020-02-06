Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F69154B87
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 20:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgBFTBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 14:01:40 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40338 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgBFTBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 14:01:40 -0500
Received: by mail-pl1-f196.google.com with SMTP id y1so2704353plp.7;
        Thu, 06 Feb 2020 11:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=a2sauIoE8yJSGD4MjyvXJjJ8GqHISXK/q5BHRJnrkVY=;
        b=Yb+ngTWheEbyy3sFO9Q5DZdJPhcVQsy93f/PE8lCkTKdHQ0bDdg+kCnb6oIPT0XFsU
         ush4O4P1hUWgbrfxocZRu233bYFQztIZ34HC2+lUefvvrMhJlIgoA7HNi6M9Ymf08EKC
         9ruvWf+fRr/IShI7Uzdya9KLcDW9zxCUdlUi7uHdGJ1RA8wnSSXWTKXudft3paQUUkh0
         FiCZtLvY1mxAzS8aetJEF07eSwckELKr6QOxMy6UeuMqzlRZp2XijJzepDM+mN95+mJi
         6BjjoFrqeN0PDXdJr81BrD0SAkjrbUKhPMCMeb7ycfB0mVyIZn/3eBuNBOqFXvuj/1xU
         5lFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=a2sauIoE8yJSGD4MjyvXJjJ8GqHISXK/q5BHRJnrkVY=;
        b=cLNbkHDts6fw21+bIDHx4u8KiAZqULcpEXqA3b08O081wYsi9lzwML56BIKc6T8Szp
         3TK6fFWOWzcLHznoGEPlmsICiY/GNqZXz1tllihVILnwRVWnJ7u+R2/jq2F67QQSY4qf
         i3FF1Oxm7WY+Z7k+wWJEgM+AJ6E0mGE5gV0XaOERxV0LaOxtwIY+9ntJYW+06NIBFgcT
         x5+C58PN2MKCYwgmPJNk2iJ4TXc0KhedAxLRShn9Jl1OiajJbQW0L4WdOcWGn8dtdYph
         AhJDO5kw8aMTR7Hopidkny0GAEj4UBJg0BhYOMIDgC+tZdv2wpZ5yFyC74U1loZDyRdf
         Mb6g==
X-Gm-Message-State: APjAAAWrx8b7edlM9qfFceVEO9vwt0wq5HDrLJmeywLefoALfBpzm2G8
        J5FCHlHDjlRFqtlGUz7MAew=
X-Google-Smtp-Source: APXvYqxxUJrBa1rlpwgknK+tBAVut5RFwDUDnEgwyBHIz/ZFS0ItE51VBJe6jeh4U7SYK7OOvgUV0w==
X-Received: by 2002:a17:90b:8ce:: with SMTP id ds14mr6432992pjb.70.1581015699596;
        Thu, 06 Feb 2020 11:01:39 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a21sm170044pgd.12.2020.02.06.11.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:01:39 -0800 (PST)
Date:   Thu, 06 Feb 2020 11:01:30 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5e3c628ac298e_22ad2af2cbd0a5b4e3@john-XPS-13-9370.notmuch>
In-Reply-To: <20200206111652.694507-3-jakub@cloudflare.com>
References: <20200206111652.694507-1-jakub@cloudflare.com>
 <20200206111652.694507-3-jakub@cloudflare.com>
Subject: RE: [PATCH bpf 2/3] bpf, sockhash: synchronize_rcu before free'ing
 map
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> We need to have a synchronize_rcu before free'ing the sockhash because any
> outstanding psock references will have a pointer to the map and when they
> use it, this could trigger a use after free.
> 
> This is a sister fix for sockhash, following commit 2bb90e5cc90e ("bpf:
> sockmap, synchronize_rcu before free'ing map") which addressed sockmap,
> which comes from a manual audit.
> 
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/sock_map.c | 4 ++++
>  1 file changed, 4 insertions(+)

Nice catch thanks. As far as I know I've never seen this happen but
lets get this fixed.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index fd8b426dbdf3..f36e13e577a3 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -250,6 +250,7 @@ static void sock_map_free(struct bpf_map *map)
>  	}
>  	raw_spin_unlock_bh(&stab->lock);
>  
> +	/* wait for psock readers accessing its map link */
>  	synchronize_rcu();
>  
>  	bpf_map_area_free(stab->sks);
> @@ -873,6 +874,9 @@ static void sock_hash_free(struct bpf_map *map)
>  		raw_spin_unlock_bh(&bucket->lock);
>  	}
>  
> +	/* wait for psock readers accessing its map link */
> +	synchronize_rcu();
> +
>  	bpf_map_area_free(htab->buckets);
>  	kfree(htab);
>  }
> -- 
> 2.24.1
> 


