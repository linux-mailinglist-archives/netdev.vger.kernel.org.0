Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F520446331
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 13:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhKEMNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 08:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhKEMNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 08:13:42 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2931C061714;
        Fri,  5 Nov 2021 05:11:02 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w1so32571042edd.10;
        Fri, 05 Nov 2021 05:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A9FWe+Q/3oFjwcEgdT/9ZzBWdSEkL2HviP2PBDNeDAg=;
        b=law0s4iYgwruPU72un+fzKv2mg2XMoS7Jnoon+uSS5tk2nGWBLSem7c5IKlXkVfq2V
         gLXquo3p04ZqgppUGU5EnYOMBf1F7R0F+pWGZjHCghzpvcTP2mwtME7huHxIhjLzexMr
         pSnBD9xUpCVqUYWg67p0elr/gcB0IFJtuqhI8T3cqEwJz27fqZopekQ7W9oCOfwyng+E
         nGVEX61skj9rTD833PVdMuwDKwGmxbbPOp+EiZyN3lo3MteDNPyBStWXRsA+/Nmv9ddZ
         Ir4++VmEL8ZcTpj8mztlCPWd/3r9ofYZ+VvJBq8ic/cYHxVzFX6btRFn7Ay0R2f6XHSv
         Fwkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A9FWe+Q/3oFjwcEgdT/9ZzBWdSEkL2HviP2PBDNeDAg=;
        b=oxUZHAPYrMhTqMwtPMu/Jxpjqw4SFOyNZVIhz5rMSISxJZgdbjy1sGfvAnE777Nfbs
         gU6KalZiCcy94VZ81m44vKzdJtwGnez9kB4sCu8az4UY2SiQWwvONOiDELa9a5/yNm+z
         mi+GqQt7lGDiSGpyPnnkQ4WC9oiI54DdzI62CYoDwiQTmsd/pRegFLLOZVHcP+e+VMyz
         dX9RbJOIsJCVGOKjtUYib+R17TZOca67TE3CfqKd57ZKZGkZTLjQWO7Zkgu554ehPXKi
         30hWLo+yTLDd4YYgUfg2HclK0+5YT2zI+fBqcwT9k2I0HSmLL9vAzTKjhoXZFXjCJwLf
         RrFg==
X-Gm-Message-State: AOAM530ZgYqyRozGAvpCPoweCcyh5gx+KFm7tShHuQBW8/IP9KW2yluc
        /HOz91t+AkgH3v6D7pLW6tM=
X-Google-Smtp-Source: ABdhPJzRqInKUKr3eTOuYcKNukH8MLjObmuAS+KGGzGkToD1LRSnKEjR4qRuDwHaHJfN6a8HlOVXXA==
X-Received: by 2002:a05:6402:27cd:: with SMTP id c13mr36175664ede.365.1636114261340;
        Fri, 05 Nov 2021 05:11:01 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:9439:4202:183c:5296? ([2a04:241e:501:3870:9439:4202:183c:5296])
        by smtp.gmail.com with ESMTPSA id mc3sm819869ejb.24.2021.11.05.05.10.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 05:11:00 -0700 (PDT)
Subject: Re: [PATCH v2 01/25] tcp: authopt: Initial support and key management
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
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
 <51044c39f2e4331f2609484d28c756e2a9db5144.1635784253.git.cdleonard@gmail.com>
 <54e31e3f-d6b3-2124-b57a-4e791938ff2f@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <d6155622-07fd-d9ab-9174-feb945b1b069@gmail.com>
Date:   Fri, 5 Nov 2021 14:10:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <54e31e3f-d6b3-2124-b57a-4e791938ff2f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 4:29 AM, David Ahern wrote:
> On 11/1/21 10:34 AM, Leonard Crestez wrote:
>> diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
>> new file mode 100644
>> index 000000000000..c412a712f229
>> --- /dev/null
>> +++ b/net/ipv4/tcp_authopt.c
>> @@ -0,0 +1,263 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +#include <linux/kernel.h>
>> +#include <net/tcp.h>
>> +#include <net/tcp_authopt.h>
>> +#include <crypto/hash.h>
>> +
>> +/* checks that ipv4 or ipv6 addr matches. */
>> +static bool ipvx_addr_match(struct sockaddr_storage *a1,
>> +			    struct sockaddr_storage *a2)
>> +{
>> +	if (a1->ss_family != a2->ss_family)
>> +		return false;
>> +	if (a1->ss_family == AF_INET &&
>> +	    (((struct sockaddr_in *)a1)->sin_addr.s_addr !=
>> +	     ((struct sockaddr_in *)a2)->sin_addr.s_addr))
>> +		return false;
>> +	if (a1->ss_family == AF_INET6 &&
>> +	    !ipv6_addr_equal(&((struct sockaddr_in6 *)a1)->sin6_addr,
>> +			     &((struct sockaddr_in6 *)a2)->sin6_addr))
>> +		return false;
> 
> The above 2 could just be
> 
> 	if (a1->ss_family == AF_INET)
> 		return (((struct sockaddr_in *)a1)->sin_addr.s_addr ==
> 			((struct sockaddr_in *)a2)->sin_addr.s_addr))

OK. The function is a little weird that it has a final "return true" 
which is technically also reachable if AF is unexpected but that 
situation is prevented from higher up.

--
Regards,
Leonard
