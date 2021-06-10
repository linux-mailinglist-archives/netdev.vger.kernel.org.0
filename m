Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F843A34C4
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhFJUYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:24:16 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:46844 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhFJUYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 16:24:14 -0400
Received: by mail-wr1-f41.google.com with SMTP id a11so3634759wrt.13;
        Thu, 10 Jun 2021 13:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TN2cshQq+RX26SMmNXh1Nu44ZA1Ux0EDgXl9lnKWGk4=;
        b=ZxG0lJ7pNGKSIONSvneoDHyc9N5VroxhPRBF8zZ6uJJpUBffCXeBDahel9ZrhMslxw
         qmhhUZIwuCw0aRasco/oO8D/3AuVInr7PLghKazzTaFrils04scdqkTfMjLQAGpwqpDo
         xaizBCYTs+NDt+OzePKS/i+qAlM/WJW207Uwqwh7t2Et4BYkE6VjuNlql94EbunJLRwl
         ssYMPWz/7fhG3KvzB9lvKA586IllARZIPwKDWxBa4lPIkkYaj2tLrMVQ05COLlpSt8hz
         7LleAW2uDjDAlTH5djq0Bb6WJyVMuOPj1tJuOFEP9PvR3RF1Quq1N9pRCbsWA68eCtRT
         aMrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TN2cshQq+RX26SMmNXh1Nu44ZA1Ux0EDgXl9lnKWGk4=;
        b=uTOLPjLZKNnZozNtCWLz4UIpELH6bWsV2tDWnUaJUGCI9PX2ICJ98EKeE/2KcPvvFg
         Arg/8h/kRHuhXPx0nG4jrh2ssI1L5gpIN8UXg1UV0PuNc8IViDFJwr5T94Usc8fpZD3b
         tWFCKL+/tas+pXGBPNkEFRzbr6JMgm4n6J3eurMP/tfEN83EfZdVcvoOPivGjdoWU1go
         f8hxEcWep96F64A2W/5RruXjI1Xrk4HEI8lpwGAD0pL9e7JIKIPwwHnYEXmmBXzNVB0D
         y/tIKsoZwdjT67v6ADeAc8bAIUHPhUqLe8EXOQAqjGduSkbg37U2vo4ZcXLUTFAL5Mbc
         3VjA==
X-Gm-Message-State: AOAM533luUb4P7Cryp00a6o8ZWM8F+j2yrJKmltRuMLe6VFIJv9nEhBc
        7qwgITHaFW2ngMeUHbyBz2IbtMEaIizqfg==
X-Google-Smtp-Source: ABdhPJxinlYLVoxRistGCFjG3FNYheDpd1itdip/HlJmQpagg9rAFamMRmNloFnq4oQWpa66Z82IqA==
X-Received: by 2002:a05:6000:2a3:: with SMTP id l3mr210126wry.395.1623356463466;
        Thu, 10 Jun 2021 13:21:03 -0700 (PDT)
Received: from [192.168.181.98] (228.18.23.93.rev.sfr.net. [93.23.18.228])
        by smtp.gmail.com with ESMTPSA id z3sm4807643wrl.13.2021.06.10.13.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 13:21:03 -0700 (PDT)
Subject: Re: [PATCH v7 bpf-next 06/11] tcp: Migrate TCP_NEW_SYN_RECV requests
 at retransmitting SYN+ACKs.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210521182104.18273-1-kuniyu@amazon.co.jp>
 <20210521182104.18273-7-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3e02db84-1cda-8b5a-49ea-cdbad900e3ea@gmail.com>
Date:   Thu, 10 Jun 2021 22:21:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521182104.18273-7-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> As with the preceding patch, this patch changes reqsk_timer_handler() to
> call reuseport_migrate_sock() and inet_reqsk_clone() to migrate in-flight
> requests at retransmitting SYN+ACKs. If we can select a new listener and
> clone the request, we resume setting the SYN+ACK timer for the new req. If
> we can set the timer, we call inet_ehash_insert() to unhash the old req and
> put the new req into ehash.
> 

...

>  static void reqsk_migrate_reset(struct request_sock *req)
>  {
> +	req->saved_syn = NULL;
> +	inet_rsk(req)->ireq_opt = NULL;
>  #if IS_ENABLED(CONFIG_IPV6)
> -	inet_rsk(req)->ipv6_opt = NULL;
> +	inet_rsk(req)->pktopts = NULL;
>  #endif
>  }

This is fragile. 

Maybe instead :

#if IS_ENABLED(CONFIG_IPV6)
	inet_rsk(req)->ipv6_opt = NULL;
	inet_rsk(req)->pktopts = NULL;
#else
	inet_rsk(req)->ireq_opt = NULL;
#endif
