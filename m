Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E528B4449CC
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhKCU5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKCU5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:57:18 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FC8C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 13:54:41 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id t11so3544179plq.11
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 13:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O9US7vTq58Ew9xWLwdb1jO2p/YkczeZgHagU6nvApyI=;
        b=iMuWQBLE323okgGvQ0NqD6E3BPUJsvtUbdtYI7rsxZVtxxDx6wNvChIyEhIBqlJQfx
         LS3R+LVOkYn/RsPuRGUt0wv8FZ8Yl2hZBxCTV/EksBoK/33F3OVoid14fRli6gKe67E8
         xvCzeokyvItUoKtq2H/j66uG0UjBcZqidYb5ndTo2mXKJ2vxCTWDE6J8UKq4fK1knsWz
         B22oRa+wOM8Ka6JR1CaCDdQTt0TgaPprfz6WLWPUCASAOg0mxxfKWvBN9S60YFLc4kya
         7oMeWu7rBmJCvEUfow+UkQBZpRW0nhTIkCXLLAij479ooAaJFp6MYW+o32k9SxH6AFjs
         Zrqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O9US7vTq58Ew9xWLwdb1jO2p/YkczeZgHagU6nvApyI=;
        b=A5vx31TQIJBT83CC/Cg7wui9ga5OCfWqBmB9EXZb9yTLOf+UPbiYM+WGpr3hxBgB/K
         WsGnlThz5TQ5oV0TMLncyeVtoDj0j7d8rWhZ/XROEfklLbj2+pRRmxzEOVBvfEvp091z
         yQBrpcezXPKuApxrMOOo3NFFDRJlouM9ntdIDE+3h0Q/CLMDUqpYGf1eeJF6ILJ1Jmod
         3QMVgmEr9AmfPpfGipTbBHCXELoGkVIjuAgogfFjm8aCpcPaPRZfOq2rtLTHh2rlVvI4
         gOIieOU19O0WYIFJL/8A9CefN0tNEHRmhej40NxTm4Mm3a9pP7F/Oiy+2i2Ngji2+NQd
         xzJA==
X-Gm-Message-State: AOAM530cZU0noj7HcojTi1OA2n8AsJ7lfTRTLddOsvT3vlMH9Rem6aKm
        9vgueI38A/g6wunV9H7zlus=
X-Google-Smtp-Source: ABdhPJygUgN4kFa1ru/Xgd57xVJsW3fVZxwumBymw3LLuShrceDgh6KPi4oufyB0iFytjQY4dsfAPA==
X-Received: by 2002:a17:90a:71c5:: with SMTP id m5mr17391559pjs.105.1635972880928;
        Wed, 03 Nov 2021 13:54:40 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f28sm3198547pfk.157.2021.11.03.13.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 13:54:40 -0700 (PDT)
Subject: Re: [PATCH v3] tcp: Use BPF timeout setting for SYN ACK RTO
To:     Akhmat Karakotov <hmukos@yandex-team.ru>, kafai@fb.com
Cc:     brakmo@fb.com, eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        ncardwell@google.com, netdev@vger.kernel.org, ycheng@google.com,
        zeil@yandex-team.ru
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
 <20211103204607.21491-1-hmukos@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <314e86f0-512a-77a9-9a48-de191eea2600@gmail.com>
Date:   Wed, 3 Nov 2021 13:54:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211103204607.21491-1-hmukos@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/3/21 1:46 PM, Akhmat Karakotov wrote:
> When setting RTO through BPF program, some SYN ACK packets were unaffected
> and continued to use TCP_TIMEOUT_INIT constant. This patch adds timeout
> option to struct request_sock. Option is initialized with TCP_TIMEOUT_INIT
> and is reassigned through BPF using tcp_timeout_init call. SYN ACK
> retransmits now use newly added timeout option.
> 
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>  include/net/request_sock.h      |  2 ++
>  include/net/tcp.h               |  2 +-
>  net/ipv4/inet_connection_sock.c |  4 +++-
>  net/ipv4/tcp_input.c            |  8 +++++---
>  net/ipv4/tcp_minisocks.c        | 12 +++++++++---
>  5 files changed, 20 insertions(+), 8 deletions(-)

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>

