Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4072BE3954
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410215AbfJXRGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:06:48 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41934 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405931AbfJXRGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:06:48 -0400
Received: by mail-io1-f68.google.com with SMTP id r144so18528290iod.8;
        Thu, 24 Oct 2019 10:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=A5rK7AirPxFC6W3rHrnbmAsb0wvrVj+jlakvazM3nbU=;
        b=epD26dEESOYvc7p1GOEg3nv3A4tlGsoLvbmuJNRZ/qfpN/HXTtkF6sqBFVHjoWvwRw
         eOg8LNlaVKbkxSQ4zgwuhQZw51eAUj/y8OyEN5pYWZc99WfUn6pecYtMRpnYS6Z0XuY5
         PRWURsVhj4Jcopv/p00ObA7W4wtIdhAnNEf7a8A0OOciB6yPXuE5Cr9BIGJO2/xcnfq4
         YmEUtElrVF9yYxEhzseYcV8a1CZ3LQDspEdJXMOgNdicM3eA+r/P1QCngxgdDNwFFL4u
         gfb1B53qxA7rybj5+jEvVmYQeQO/WA13jsOql2SVU4t3d6hWcpBdnR/CHOGDwMpTebFf
         4Vig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=A5rK7AirPxFC6W3rHrnbmAsb0wvrVj+jlakvazM3nbU=;
        b=TlliG6oqVcod4Jya1lkjCuEwIjkzt3e82dWXLN0JHzx3Ja+wzx0URBAwg3pFi5nEPX
         oA5Of9WmnKTLS/LqU/k9LOTCJ6GeSjDhXBDi0hANNodpwG0ttNXXVr5b0F4QRJkhV+69
         SRcgNZuAK038EXlGdbFbN5OHEXfZLj11Lfa8YCkfE5FSEzw77za++wPgXJBO61K7xOyO
         BGFDdmEO55FUTU4rWoU7vsq3fwYuWUN+CJ5cCQ+xR3DdQE/fzDuLafdVXvQbVIBxtMGr
         UFt089TzsEzsEIGPaWW0QEfbCmcHMWGuLKag9S2435kdBWO0AqDQYvQ3rn1688so3WXL
         Nrog==
X-Gm-Message-State: APjAAAU+fbeteUhB7nG7BFRvvclE3/m+iErXP/PHMDkP91xJstPV4vJ3
        sUTdzy+0syNBbA4FjDiwEuk=
X-Google-Smtp-Source: APXvYqw9oDMsg7qoHAxPPWIX1VgEVrAPJTlcyTdDdfrpMM12R7ZltfZo1IOeBIUAutIpCtAdxDgZiQ==
X-Received: by 2002:a02:1ac5:: with SMTP id 188mr217824jai.77.1571936806854;
        Thu, 24 Oct 2019 10:06:46 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y5sm7650391ill.86.2019.10.24.10.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 10:06:46 -0700 (PDT)
Date:   Thu, 24 Oct 2019 10:06:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Message-ID: <5db1da20174b1_5c282ada047205c046@john-XPS-13-9370.notmuch>
In-Reply-To: <20191022113730.29303-3-jakub@cloudflare.com>
References: <20191022113730.29303-1-jakub@cloudflare.com>
 <20191022113730.29303-3-jakub@cloudflare.com>
Subject: RE: [RFC bpf-next 2/5] bpf, sockmap: Allow inserting listening TCP
 sockets into SOCKMAP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> In order for SOCKMAP type to become a generic collection for storing socket
> references we need to loosen the checks in update callback.
> 
> Currently SOCKMAP requires the TCP socket to be in established state, which
> prevents us from using it to keep references to listening sockets.
> 
> Change the update pre-checks so that it is sufficient for socket to be in a
> hash table, i.e. have a local address/port, to be inserted.
> 
> Return -EINVAL if the condition is not met to be consistent with
> REUSEPORT_SOCKARRY map type.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

We need to also have some tests then to verify redirecting to this listen socket
does the correct thing. Once its in the map we can redirect (ingress or egress)
to it and need to be sure the semantics are sane.

>  net/core/sock_map.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index facacc296e6c..222036393b90 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -415,11 +415,14 @@ static int sock_map_update_elem(struct bpf_map *map, void *key,
>  		ret = -EINVAL;
>  		goto out;
>  	}
> -	if (!sock_map_sk_is_suitable(sk) ||
> -	    sk->sk_state != TCP_ESTABLISHED) {
> +	if (!sock_map_sk_is_suitable(sk)) {
>  		ret = -EOPNOTSUPP;
>  		goto out;
>  	}
> +	if (!sk_hashed(sk)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>  
>  	sock_map_sk_acquire(sk);
>  	ret = sock_map_update_common(map, idx, sk, flags);
> -- 
> 2.20.1
> 
