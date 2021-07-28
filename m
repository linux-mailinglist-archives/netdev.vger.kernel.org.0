Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960153D8B76
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 12:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhG1KMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 06:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhG1KMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 06:12:18 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAF5C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 03:12:16 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id r17so2942939lfe.2
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 03:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=YHpeVorEZNveMg4rGvTy65w5BJEGsEP2/CeTemEIaPs=;
        b=xOQfcX4wNFhc4WhieYxsFZEJIjF6oeP67g74nphtQupvIdYjj5zqeCdhMxNIRB0HPA
         XtDbliAYDa/pSVDsaId7iPVsXS2DncKPw6mcV6dMTjQAAL0lKfHbEjTBjL70mI1Dckyo
         FCPzqF1ITE70k+TR6IHz9cay/3I525R+8SO8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=YHpeVorEZNveMg4rGvTy65w5BJEGsEP2/CeTemEIaPs=;
        b=VL2F3noFM4omJKOJZE5idVsA3sIVdDDgeCKwy6CC1FGI9T3GZk/0VaAqKYOLbiuvfO
         qZBwNed2FqVU1yGERHFTCaFOvC0zQkbc2C53TNkhLih9O6L/21hRUHZAIkAgPf6cSp2R
         WrwOvT/VLKogA7ZtTSALuQ+ibj7yHD6+f+yxuGV582Eadiot+i7RGEd2p/If18bibQCk
         WB/Dp2xk1Vb+TE7yvnVqqsCQvaQVdJrffB+yu8nVG4PuSAcIdpP8M3ct+omoHHe7SdTd
         +3q2qh/CETWj0ecojVmcq8MEQXUyd4ocquyFJnV4KO2VL9mDkQdr1sNfCYC31M8rKhh8
         hJzw==
X-Gm-Message-State: AOAM530P3vzXRSFeRw9wqzlXzmuWo0fNbsjeHHXKU1DEXY0UcXuHuFfp
        HoP1RELxJ/QwVJ0dZAo2AdDFTA==
X-Google-Smtp-Source: ABdhPJz4lrEbEU+LJooktJ/Mzjg9VKZKLnpPFoeqppNbu7SrW0edjL/0d06jD0GnlJk1r59MsW82zA==
X-Received: by 2002:a05:6512:33d3:: with SMTP id d19mr20041647lfg.114.1627467135017;
        Wed, 28 Jul 2021 03:12:15 -0700 (PDT)
Received: from cloudflare.com (79.191.186.228.ipv4.supernova.orange.pl. [79.191.186.228])
        by smtp.gmail.com with ESMTPSA id t73sm546930lff.135.2021.07.28.03.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 03:12:14 -0700 (PDT)
References: <20210723183630.5088-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next] unix_bpf: fix a potential deadlock in
 unix_dgram_bpf_recvmsg()
In-reply-to: <20210723183630.5088-1-xiyou.wangcong@gmail.com>
Date:   Wed, 28 Jul 2021 12:12:13 +0200
Message-ID: <87h7ge3fya.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 08:36 PM CEST, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> As Eric noticed, __unix_dgram_recvmsg() may acquire u->iolock
> too, so we have to release it before calling this function.
>
> Fixes: 9825d866ce0d ("af_unix: Implement unix_dgram_bpf_recvmsg()")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/unix/unix_bpf.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
> index db0cda29fb2f..b07cb30e87b1 100644
> --- a/net/unix/unix_bpf.c
> +++ b/net/unix/unix_bpf.c
> @@ -53,8 +53,9 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  	mutex_lock(&u->iolock);
>  	if (!skb_queue_empty(&sk->sk_receive_queue) &&
>  	    sk_psock_queue_empty(psock)) {
> -		ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> -		goto out;
> +		mutex_unlock(&u->iolock);
> +		sk_psock_put(sk, psock);
> +		return __unix_dgram_recvmsg(sk, msg, len, flags);
>  	}
>  
>  msg_bytes_ready:
> @@ -68,13 +69,13 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  		if (data) {
>  			if (!sk_psock_queue_empty(psock))
>  				goto msg_bytes_ready;
> -			ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> -			goto out;
> +			mutex_unlock(&u->iolock);
> +			sk_psock_put(sk, psock);
> +			return __unix_dgram_recvmsg(sk, msg, len, flags);
>  		}
>  		copied = -EAGAIN;
>  	}
>  	ret = copied;
> -out:
>  	mutex_unlock(&u->iolock);
>  	sk_psock_put(sk, psock);
>  	return ret;

Nit: Can be just `return copied`. `ret` became useless.

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
