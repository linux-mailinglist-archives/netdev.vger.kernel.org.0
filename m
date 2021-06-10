Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADA33A32BF
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhFJSMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:12:42 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:42987 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFJSMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:12:42 -0400
Received: by mail-wr1-f46.google.com with SMTP id c5so3305622wrq.9;
        Thu, 10 Jun 2021 11:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SapgZjVRdGw+smc0HYc4yIvhWkiTCIxbdpvuRy6CsfM=;
        b=ONY+z6BD6gIjHkEsWC+RECN5F+JpqL9vWMyXgbul0GXQ7Fq3vwknQPPndI1/ot4k0T
         wmzXdnqBUrVldOW5vRHL7FT54Sfs6j4THaPIQb/QJWOI89k1gms/ZhHxYzp9+30jFDKw
         pBp29VUKOXz0PGft4wW7YYe2NFTnJTP1b9vXraTyK6muhOr5kx4vXkbLjZSBWhtW2356
         +Gren59jHbCwuDi0eVuwUGO1zTHYOcFd8YTi+iQi4V9kzkNnsX7Rxp0wk24ajgIicr2v
         0A2uvNXlhWdrepLGM1DH5rjkrmZqUOFMJq8xqAQk62Zyl38xFr6WkhQgMAmOGsu5ZG1Z
         lvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SapgZjVRdGw+smc0HYc4yIvhWkiTCIxbdpvuRy6CsfM=;
        b=hjA/74xwLyIHujXPRajgSl9ooY/zimkOaCBfPOs5f1STTty+gXYgR5jLUXL6Chaa/E
         glpnXGgN+Rb4zyG1+0BUuhxJ4gN0WWU3d3NcztOwpMhI3qlmXtsQ4XsZ/ZKLcqtG+bFa
         xP/BvdMHCjmFLhimAGcRaCjHJfSq6PoMWArBhmmJtjzZGfFcRd/HvTlUMJW7eGhZPJUb
         GLscqUN4tpgeHm3vjUAmeJbllFnx+ImztRwuba8TlNJfXRxZ7Dc1NVBcxPrY4ByNa+fB
         lj1HeCipoJLguwIlb/UNQeb2chsiXSsYcQMYJP6uUFY3TrREHEO2zOQUCX4UJ9isPOXQ
         Dbaw==
X-Gm-Message-State: AOAM532pBVcQIxj2Q1nv4Jn/bhUwLkNch44PUhaOOXOq0B2RVF6GKs5e
        DQpppf7dbg6B6LDwEeVDEMDPxCYyHgafYw==
X-Google-Smtp-Source: ABdhPJzIukjrUlRIC3L4KJh0w/VXHgrci+zDDcUSTyTyJETArHmRN71aJp+x/XvZt1ViePdN0uJylA==
X-Received: by 2002:a5d:47ce:: with SMTP id o14mr6729048wrc.273.1623348575861;
        Thu, 10 Jun 2021 11:09:35 -0700 (PDT)
Received: from [192.168.181.98] (228.18.23.93.rev.sfr.net. [93.23.18.228])
        by smtp.gmail.com with ESMTPSA id b62sm3593979wmh.47.2021.06.10.11.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 11:09:35 -0700 (PDT)
Subject: Re: [PATCH v7 bpf-next 04/11] tcp: Add reuseport_migrate_sock() to
 select a new listener.
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
 <20210521182104.18273-5-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fb9a3615-4ce3-f676-abfc-4a5a641a9e58@gmail.com>
Date:   Thu, 10 Jun 2021 20:09:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521182104.18273-5-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> reuseport_migrate_sock() does the same check done in
> reuseport_listen_stop_sock(). If the reuseport group is capable of
> migration, reuseport_migrate_sock() selects a new listener by the child
> socket hash and increments the listener's sk_refcnt beforehand. Thus, if we
> fail in the migration, we have to decrement it later.
> 
> We will support migration by eBPF in the later commits.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/net/sock_reuseport.h |  3 ++
>  net/core/sock_reuseport.c    | 78 +++++++++++++++++++++++++++++-------
>  2 files changed, 67 insertions(+), 14 deletions(-)

Reviewed-by: Eric Dumazet <edumazet@google.com>

