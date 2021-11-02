Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADBD442B0B
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 10:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhKBJyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 05:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhKBJxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 05:53:50 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFA7C061239;
        Tue,  2 Nov 2021 02:50:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w1so19941645edd.10;
        Tue, 02 Nov 2021 02:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=phT7BPlJVjW6ePMt+YURvMOEW4v6/gql/qbCudKf21c=;
        b=hwYcMpbxOJBhA2H4xFMNy3YthlGe77+7VaHJwM1EcWGxP3zh3DPXERJfvVM+9nEGTP
         wT6hfp5yDlP5tQqDd6MXzzIKx3qCOaygo0HDKxa9xkVFsCNe0f2OozONiorH/CuzBOc6
         V1sTyYGPqu80ejeFHU5VVzEFbORQnDlRWiLwtRNDHq3JI3EyvuT3cjWYdlQZQSSewo0r
         RmjvFviV4xe6vzCAKrLuKSQzCueeeOz9rWmgGama8XYWrQJdLRQIRAGVPfnRd4dm72m5
         n6b9wxKQh/t/VGC3xBZaBt/tU+MGSlpNAhqS+TeXvbvDSusWbb+YNwVcsLajz6ED4Xf6
         OqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=phT7BPlJVjW6ePMt+YURvMOEW4v6/gql/qbCudKf21c=;
        b=mD1uTaqr9hRkq12Di2H8mlhW6fJSao5x91+cQDrUrGGUJM0WY11WWIPRHHmwr9d0Av
         FteQM31mkyY7BaMBihnvAeWj4HExfxEkCOfBPfLZUYh16NgzKO3vfFPFgfwkVm/kNErQ
         +flCqC3IvH/gVa1sb84MgqP6UW6QraEfgh50YxZcnZghT0tlFWph89a4gM7puLKHwyYh
         ipaVKjeE7c7v8dkkYoQOytB1XqbhwWG2JziEGM5uI6v30ptBVP0t1I+3Y/sJUxSpQKoo
         W1/qDj/vNM5Gk3Z99GM3N/lIaTMLUxPQ/Wpabatsl/O4CTX/GnE5O49xlzOVJzNvM//O
         8jHw==
X-Gm-Message-State: AOAM532UqgVVAEHnItFw3QhUypZ4ev5KMN1LL1PCalU18Whzb11gXosF
        g3e09FW5Wnr78j/BWywSAfE=
X-Google-Smtp-Source: ABdhPJxnALGXIZMcJ/oN1CzPmiie5WA5VQewo2TvYMcnOMUt8YKU7kdHG07188Y1g11ACuVaMDZHBQ==
X-Received: by 2002:a05:6402:280f:: with SMTP id h15mr17701049ede.286.1635846649084;
        Tue, 02 Nov 2021 02:50:49 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:88ff:d1a0:a1c6:4b6a? ([2a04:241e:501:3870:88ff:d1a0:a1c6:4b6a])
        by smtp.gmail.com with ESMTPSA id hc15sm7849472ejc.73.2021.11.02.02.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 02:50:48 -0700 (PDT)
Subject: Re: [PATCH v2 11/25] tcp: authopt: Implement Sequence Number
 Extension
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>
References: <cover.1635784253.git.cdleonard@gmail.com>
 <6097ec24d87efc55962a1bfac9441132f0fc4206.1635784253.git.cdleonard@gmail.com>
 <07987e29-87a0-9a09-bdf0-b5e385d9c55f@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <344a6d47-3d4d-ee98-10ef-c710b8538f24@gmail.com>
Date:   Tue, 2 Nov 2021 11:50:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <07987e29-87a0-9a09-bdf0-b5e385d9c55f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 10:54 PM, Eric Dumazet wrote:
> On 11/1/21 9:34 AM, Leonard Crestez wrote:
>> Add a compute_sne function which finds the value of SNE for a certain
>> SEQ given an already known "recent" SNE/SEQ. This is implemented using
>> the standard tcp before/after macro and will work for SEQ values that
>> are without 2^31 of the SEQ for which we know the SNE.
> 
>>   }
>> +void __tcp_authopt_update_rcv_sne(struct tcp_sock *tp, struct tcp_authopt_info *info, u32 seq);
>> +static inline void tcp_authopt_update_rcv_sne(struct tcp_sock *tp, u32 seq)
>> +{
>> +	struct tcp_authopt_info *info;
>> +
>> +	if (static_branch_unlikely(&tcp_authopt_needed)) {
>> +		rcu_read_lock();
>> +		info = rcu_dereference(tp->authopt_info);
>> +		if (info)
>> +			__tcp_authopt_update_rcv_sne(tp, info, seq);
>> +		rcu_read_unlock();
>> +	}
>> +}
>> +void __tcp_authopt_update_snd_sne(struct tcp_sock *tp, struct tcp_authopt_info *info, u32 seq);
>> +static inline void tcp_authopt_update_snd_sne(struct tcp_sock *tp, u32 seq)
>> +{
>> +	struct tcp_authopt_info *info;
>> +
>> +	if (static_branch_unlikely(&tcp_authopt_needed)) {
>> +		rcu_read_lock();
>> +		info = rcu_dereference(tp->authopt_info);
>> +		if (info)
>> +			__tcp_authopt_update_snd_sne(tp, info, seq);
>> +		rcu_read_unlock();
>> +	}
>> +}
>>
> 
> I would think callers of these helpers own socket lock,
> so no rcu_read_lock()/unlock() should be needed.
> 
> Perhaps instead
> rcu_dereference_protected(tp->authopt_info, lockdep_sock_is_held(sk));

Yes, all the callers hold the socket lock and replacing rcu_read_lock 
doesn't trigger any RCU warnings.

--
Regards,
Leonard
