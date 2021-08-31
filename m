Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819A73FC0DA
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 04:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239458AbhHaCfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 22:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239380AbhHaCfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 22:35:14 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08221C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 19:34:20 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id t42so13723574pfg.12
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 19:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xaLS9WE7Qe/t4Xv4DN6glmzn2o5pDXVfb3ld0I+fxMc=;
        b=oi1L1fxxgLMeAOTanwA8y7aOOn+MQCi8MULUaHsSh2pEWMTM+6BkSwHqpJDE3s15BW
         JJW+w5/uJbD2E5uhUdfuE4QlZ+nrlW5/kUM7NafV+NUJnnQSSdHhsO5naXAWAz5W2aNe
         aCpJJvwxpaeBZVX8RRX4w61edHg0hlt9H16kROKb+jKMcI5O7W211Xnm2rLEUGZaLMsh
         J/QUEAmFffq97jmxkWQEKJqrJ5ElN5YRxQ7qq4abQB6BqIZcDTrqsorfNwKEEdacS8nG
         crYrVFuO3+iH3ED/v4PhDp2ry1sU0CBgOUMsEZmrJBiH6ViQGmEHx4uugBLgyWg3r94Y
         4DdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xaLS9WE7Qe/t4Xv4DN6glmzn2o5pDXVfb3ld0I+fxMc=;
        b=qOalMIC9GD3Oct6iy3pkf06EcMGtXUg3XrbGerIS43wCUSqrbCdZ/1Kp8HuFDxQYt5
         /lFMUCsNptNetW902DtUStGfLDj53uWH118wd1OQ8YoLFBZ15oL1oEyfmYGfBTH8HhQs
         V6CLjw+LM+v2KAJXktUMGdc5qgIXvwC5F65GLS7+XNekdRm04y6KyUt6pOlAu3HDubj+
         LuoguAGNc6lSXGeozTfMDrr1aMuAKunVGd0sZnmiFkAhufW0LIYdpiDYaDTxA4ae+EUh
         Seumq5eP/b/TgaplrRsMoimn9ag9Tww9sieLsUrV4536sv5GuxQAFg1jaNBP/lLlf8rU
         ve3g==
X-Gm-Message-State: AOAM533wuLEiviTmj1SYl7JFUTgVetdLHvbk1Z36Nk+qanHAEjOW44mF
        BfA+v0cpGDrAllML/m6t4ac=
X-Google-Smtp-Source: ABdhPJwR1LKtbOQzHa8IMTAfBEtMgL28Pc1Q4S1Ny1Q74J6uZqo2Eeq5Vyg8tYGurIz0aMpSMfTtfQ==
X-Received: by 2002:aa7:9626:0:b0:3ff:6d8d:1d25 with SMTP id r6-20020aa79626000000b003ff6d8d1d25mr8479699pfg.80.1630377259538;
        Mon, 30 Aug 2021 19:34:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id f11sm14815163pfc.23.2021.08.30.19.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 19:34:18 -0700 (PDT)
Subject: Re: [PATCH net] ipv4: fix endianness issue in
 inet_rtm_getroute_build_skb()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        David Ahern <dsahern@kernel.org>
References: <20210831020210.726942-1-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b73935ca-f82e-16a7-42de-cfbaf13e1fea@gmail.com>
Date:   Mon, 30 Aug 2021 19:34:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210831020210.726942-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/21 7:02 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> The UDP length field should be in network order.
> This removes the following sparse error:
> 
> net/ipv4/route.c:3173:27: warning: incorrect type in assignment (different base types)
> net/ipv4/route.c:3173:27:    expected restricted __be16 [usertype] len
> net/ipv4/route.c:3173:27:    got unsigned long
> 
> Fixes: 404eb77ea766 ("ipv4: support sport, dport and ip_proto in RTM_GETROUTE")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Roopa Prabhu <roopa@nvidia.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  net/ipv4/route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


