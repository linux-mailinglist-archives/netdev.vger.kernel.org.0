Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E7644613E
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 10:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhKEJTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 05:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhKEJTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 05:19:15 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ACCC061714;
        Fri,  5 Nov 2021 02:16:36 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b15so11517270edd.7;
        Fri, 05 Nov 2021 02:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O411Av9fvLd/hkgDCWHd1YQtsfITSCOYwUfbpCbSjTE=;
        b=dmA2RtV/XsFluYL7qjAeH+C3KzLmEPPlsDTodEGT0R8Kg628o3tBRQDhdf+MnmdcoC
         yZU2XF4yW6IuWltY9oWPY/ySEjrXFPeQKO4vGODrG/edm/WJOqkaN6p0RJ993iwPQAhe
         +pBW1lj5QCCEiX2CsGvwQNuJ7VUTnDzVTvilUETuOjPVFgaMM06Mq3Hu9jsEONLVrbDK
         Yk4IacgCZ8HAfvjbvshOeh2bm+ushiO7JADNdYr8hguKASVxDbhicHTEDI/FTDOc0PcP
         Fa+xMrmHi/AWkfMuqDyG7pNs9qmw+9mD8XGWnbX1n7uq5xvS4jN4zK/pOlesGCr7T+K0
         YLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O411Av9fvLd/hkgDCWHd1YQtsfITSCOYwUfbpCbSjTE=;
        b=T9ioZX4GeVpARFSui+A2yNrGzleRcwWSDbiefy7Lybpp00yScqeBvCm1ayHHhCWjmb
         aJ5WSGyZegDWbhxNEjqJ/qrt/mzpV0E2jBZRym2MXD7xVJR0uArqNNQGHdxEzh34DSCc
         ZdbMIYoQY6+jqk0SIi+s1idDJUWtcXIgEzzmJwIvhaebAVdfc7AcnG7HY91Jsu46v/T4
         pHRZ6KgU37MGnisyAjAusBz/B5RfeGv6oWJpjaSxIBy6KJ5YwRpc3ntv7Jk1L8OlMMZb
         N5H9+/o8NQ+tzeDpZJ5kpQA++e+0o3KYT7xCYKQDUUnbDxatMegcEm8uDydLZe+HsWCA
         7SjQ==
X-Gm-Message-State: AOAM533FWy2j7q+YeP/TX/oZpU0AsIQ2Ey5jmx/KRmIe0daQCfa6nMOn
        Dx93oYzojVl/q6tWqimRkE64VsRwWLnNTg==
X-Google-Smtp-Source: ABdhPJwddb+scfxjFBhL7QmsMPZ7el6H7VZwam/hk7n4Y18shnju7NBz/VKLCGmo0SzMzDRZg4DKRQ==
X-Received: by 2002:a17:907:1b25:: with SMTP id mp37mr70586192ejc.140.1636103794886;
        Fri, 05 Nov 2021 02:16:34 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:9439:4202:183c:5296? ([2a04:241e:501:3870:9439:4202:183c:5296])
        by smtp.gmail.com with ESMTPSA id d4sm4233088edk.78.2021.11.05.02.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 02:16:34 -0700 (PDT)
Subject: Re: [PATCH 1/5] tcp/md5: Don't BUG_ON() failed kmemdup()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
References: <20211105014953.972946-1-dima@arista.com>
 <20211105014953.972946-2-dima@arista.com>
 <15c0469e-9433-0a8d-50f0-de6517365464@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <e105258b-cef0-279b-a66c-e133be82a0dd@gmail.com>
Date:   Fri, 5 Nov 2021 11:16:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <15c0469e-9433-0a8d-50f0-de6517365464@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 4:55 AM, Eric Dumazet wrote:
> 
> 
> On 11/4/21 6:49 PM, Dmitry Safonov wrote:
>> static_branch_unlikely(&tcp_md5_needed) is enabled by
>> tcp_alloc_md5sig_pool(), so as long as the code doesn't change
>> tcp_md5sig_pool has been already populated if this code is being
>> executed.
>>
>> In case tcptw->tw_md5_key allocaion failed - no reason to crash kernel:
>> tcp_{v4,v6}_send_ack() will send unsigned segment, the connection won't be
>> established, which is bad enough, but in OOM situation totally
>> acceptable and better than kernel crash.
>>
>> Introduce tcp_md5sig_pool_ready() helper.
>> tcp_alloc_md5sig_pool() usage is intentionally avoided here as it's
>> fast-path here and it's check for sanity rather than point of actual
>> pool allocation. That will allow to have generic slow-path allocator
>> for tcp crypto pool.
>>
>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>> ---
>>   include/net/tcp.h        | 1 +
>>   net/ipv4/tcp.c           | 5 +++++
>>   net/ipv4/tcp_minisocks.c | 5 +++--
>>   3 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index 4da22b41bde6..3e5423a10a74 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -1672,6 +1672,7 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
>>   #endif
>>   
>>   bool tcp_alloc_md5sig_pool(void);
>> +bool tcp_md5sig_pool_ready(void);
>>   
>>   struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
>>   static inline void tcp_put_md5sig_pool(void)
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index b7796b4cf0a0..c0856a6af9f5 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -4314,6 +4314,11 @@ bool tcp_alloc_md5sig_pool(void)
>>   }
>>   EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
>>   
>> +bool tcp_md5sig_pool_ready(void)
>> +{
>> +	return tcp_md5sig_pool_populated;
>> +}
>> +EXPORT_SYMBOL(tcp_md5sig_pool_ready);
>>   
>>   /**
>>    *	tcp_get_md5sig_pool - get md5sig_pool for this user
>> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
>> index cf913a66df17..c99cdb529902 100644
>> --- a/net/ipv4/tcp_minisocks.c
>> +++ b/net/ipv4/tcp_minisocks.c
>> @@ -293,11 +293,12 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
>>   			tcptw->tw_md5_key = NULL;
>>   			if (static_branch_unlikely(&tcp_md5_needed)) {
>>   				struct tcp_md5sig_key *key;
>> +				bool err = WARN_ON(!tcp_md5sig_pool_ready());
>>   
>>   				key = tp->af_specific->md5_lookup(sk, sk);
>> -				if (key) {
>> +				if (key && !err) {
>>   					tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
>> -					BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());
>> +					WARN_ON_ONCE(tcptw->tw_md5_key == NULL);
>>   				}
>>   			}
>>   		} while (0);
>>
> 
> Hmmm.... how this BUG_ON() could trigger exactly ?
> 
> tcp_md5_needed can only be enabled after __tcp_alloc_md5sig_pool has succeeded.

The tcp_alloc_md5_pool here should just be removed, it no longer does 
anything since md5 pool reference counting and freeing were removed back 
in 2013 by commit 71cea17ed39f ("tcp: md5: remove spinlock usage in fast 
path").
