Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D8823DD32
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgHFRFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729618AbgHFREr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:04:47 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7890CC061575
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 03:47:12 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id jp10so23210006ejb.0
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 03:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YG1Q9ynyALFe9AR4AZSnu22cCvufmDI+jK/ShRTakaM=;
        b=y5QJ1RTOml2RSAjIvBYsdVJ2k8poyIbAEqK9gbXMvf/anLbi20BZWlKrIHnB30nI0o
         LMcfKgqvmQhpTkNTN/uVT2Oppdah2LqBb4AFhcL2ZU0O84VOqggfijA3nXRfjnyWxMqg
         8LYg/feEy49SaB/FTnYHvZpsjBaae2IF4aai6ydPwwXY271DMkUG+tnTFfLuA481asuY
         ncqAKCMbDfhJbvRlEToPaTm8qaLiG/vCaXTCTxqMtZ5LfCGpeORnYTysGbGUccu8RqHP
         Y/FNI3Z4fHBttNubfHeMVQnHSB3brn45wUMNRL8WM0cu9ZHtIdjUGC5q5rs1uDKQzlIZ
         fFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YG1Q9ynyALFe9AR4AZSnu22cCvufmDI+jK/ShRTakaM=;
        b=Y4oUxgfP/vSAZH3bVDge1I0/J3qKFyS/O+SzlzTgCOw7lhY4ITsiGE9OEI0jUyuhdg
         +/nUx9mUramDUdMn33Cs7t9+9FON+QIelaoghkwcKfSWJKmHUvUrOYptBzcnY6AEvqNL
         abAsD8bLhLYhBaEmd+GoX0Aatz8nfAyCKspUEN0H7yX9fONWq/wSJPDO84HFqspT6hgy
         fsVHQsXQHN31EBKQ9Fa0TNQ0tyLh4+whvoKR3Lhj8sH7qmEJ5HplB8fQmZuCv/vK5F2i
         c7YY5PQOoZeo3bcNT5vTXaR36z/z5KBIig8bYyE7kTOs2QJjHACm0u7kBloB9a2qjl0t
         wy9A==
X-Gm-Message-State: AOAM530NVPndpfoIiGiCr4QBuEOWP/037P1Y+9T2EoOAoHxsiIs8M/Da
        HgqnJAIWBFSh7YkTt8xnVC3+tA==
X-Google-Smtp-Source: ABdhPJySSAYHHGXG7ZhusGtY3TlrMlJ2Bid0HtSCCmNCIXaptwIq+EGfkdHrYLhPWUyULEZJsrYJKQ==
X-Received: by 2002:a17:906:1986:: with SMTP id g6mr3896501ejd.404.1596710830139;
        Thu, 06 Aug 2020 03:47:10 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id e14sm3227107edl.86.2020.08.06.03.47.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 03:47:09 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: refactor bind_bucket fastreuse into helper
To:     Tim Froidcoeur <tim.froidcoeur@tessares.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        KOVACS Krisztian <hidden@balabit.hu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200806064109.183059-1-tim.froidcoeur@tessares.net>
 <20200806064109.183059-2-tim.froidcoeur@tessares.net>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <a4143368-bfe8-a3f1-c6e0-753359388191@tessares.net>
Date:   Thu, 6 Aug 2020 12:47:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806064109.183059-2-tim.froidcoeur@tessares.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tim,

Thank you for having sent the patch!

On 06/08/2020 08:41, Tim Froidcoeur wrote:
> Refactor the fastreuse update code in inet_csk_get_port into a small
> helper function that can be called from other places.

(...)

> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index afaf582a5aa9..3b46b1f6086e 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -266,7 +266,7 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
>   static inline int sk_reuseport_match(struct inet_bind_bucket *tb,
>   				     struct sock *sk)
>   {
> -	kuid_t uid = sock_i_uid(sk);
> +	kuid_t uid = sock_i_uid((struct sock *)sk);

It seems there is a left over from a previous version. This modification 
is no longer needed.

>   
>   	if (tb->fastreuseport <= 0)
>   		return 0;
> @@ -296,6 +296,57 @@ static inline int sk_reuseport_match(struct inet_bind_bucket *tb,
>   				    ipv6_only_sock(sk), true, false);
>   }
>   
> +void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
> +			       struct sock *sk)
> +{
> +	kuid_t uid = sock_i_uid((struct sock *)sk);

Same here.

May you send a v2 without these two casts please?

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
