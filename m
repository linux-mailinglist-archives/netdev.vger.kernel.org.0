Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E524635BAF5
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbhDLHkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236917AbhDLHkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:40:36 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00642C061574;
        Mon, 12 Apr 2021 00:40:16 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so6268284wmi.3;
        Mon, 12 Apr 2021 00:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VlhQoqqQup2EQc4EKSdGaI4dxwZDzOfrhmT9hkGCxW8=;
        b=Zrn9cdTLvdgO9jzqu1N0dQxDyXNF9OjdLREK9WOB57MAOqSBs3tKlXLRV7pVh8txTf
         kSszZ//7SfofUAvD2Wweorv29UNnf64DciT3fwqF8DgHM+wlUAGmy3UGZFg0VgTij06K
         gRYXVvss7fCzkNfPZ0NQRrZ7zX6ebnEH+OkUs7hWzK78gxXYKCtNc/Y0SybYQoqudDzF
         qVxdrFwug6g+RRWcAPQ6624vTI1wUQZpGGdEkuArT4MmBOBDnV8mlvzfVdnOoUWDEcRV
         ia1xRWg3vzZHw194349FF4nSi77gKPaXFDITcHC8j6ayQMxjfk+Pdto3FRvlXbmJKNWX
         PdiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VlhQoqqQup2EQc4EKSdGaI4dxwZDzOfrhmT9hkGCxW8=;
        b=lNOOqE/c80iE2wb+czO2hgufLAiXRm9vgoyD5qjOCR0fSa/DD84RxYm0Vvh4aQgRz4
         VyB1RKUDPlGa/78mymODVD85ti42l7/Gu22oMk3gqN+EupLCZnxNrd53TK+uKXN3/srl
         IGdP5CYa/KUNQd+b8XCCg5XUob17FBBhy1dKuFRvbqJ1qBN+dzz4yWjgRlzgsOB0g33O
         HXsffUyz+urJPEP7DayqPClrRD7utTJSwH9aRzZYdQHuEDxe4+PMY9OxLCVNNJypl233
         pcOE52bPjD4l6HRdchT3c85mk8lOpH9LVDIMP8W1uTVzRo2DI+9i4oSc8bR0RG63kl86
         CLrw==
X-Gm-Message-State: AOAM531JYUCcXbP86kZWD+HAtLQiE/8mK6s4bGGlNnR4mGKQPfgtnusG
        dc0Ry35MmfydHA7gk9vi/Lhh6ROwrAo=
X-Google-Smtp-Source: ABdhPJxPM+IATReMlcDqqyeKZK/B1R1r2JTyuEvtXLxfwJbofp8uucJTGxbEl8Y2A2vh9w6XKDce9g==
X-Received: by 2002:a1c:5454:: with SMTP id p20mr3834383wmi.187.1618213215806;
        Mon, 12 Apr 2021 00:40:15 -0700 (PDT)
Received: from [192.168.1.101] ([37.164.79.211])
        by smtp.gmail.com with ESMTPSA id v18sm13650978wmh.28.2021.04.12.00.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 00:40:15 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/3] net: use skb_for_each_frag() helper where
 possible
To:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
References: <20210412003802.51613-1-mcroce@linux.microsoft.com>
 <20210412003802.51613-3-mcroce@linux.microsoft.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <44e9ef55-cafd-6613-938b-381ff84d3fc5@gmail.com>
Date:   Mon, 12 Apr 2021 09:40:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210412003802.51613-3-mcroce@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/21 2:38 AM, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> use the new helper macro skb_for_each_frag() which allows to iterate
> through all the SKB fragments.
> 
> The patch was created with Coccinelle, this was the semantic patch:
> 
> @@
> struct sk_buff *skb;
> identifier i;
> statement S;
> iterator name skb_for_each_frag;
> @@
> -for (i = 0; i < skb_shinfo(skb)->nr_frags; \(++i\|i++\))
> +skb_for_each_frag(skb, i)
>  S
> @@
> struct skb_shared_info *sinfo;
> struct sk_buff *skb;
> identifier i;
> statement S;
> iterator name skb_for_each_frag;
> @@


I disagree with this part :

>  sinfo = skb_shinfo(skb)
>  ...
> -for (i = 0; i < sinfo->nr_frags; \(++i\|i++\))
> +skb_for_each_frag(skb, i)
>  S
>


> index bde781f46b41..5de00477eaf9 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1644,7 +1644,7 @@ static int __pskb_trim_head(struct sk_buff *skb, int len)
>  	eat = len;
>  	k = 0;
>  	shinfo = skb_shinfo(skb);
> -	for (i = 0; i < shinfo->nr_frags; i++) {
> +	skb_for_each_frag(skb, i) {
>  		int size = skb_frag_size(&shinfo->frags[i]);
>  
>  		if (size <= eat) {

This will force the compiler to re-evaluate skb_shinfo(skb)->nr_frags in the loop,
since atomic operations like skb_frag_unref() have a memory clobber.

skb_shinfo(skb)->nr_frags has to reload three vars.

The macro should only be used when the code had

for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)


