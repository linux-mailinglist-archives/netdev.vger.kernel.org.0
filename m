Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF94424D5E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 08:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbhJGGnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 02:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbhJGGnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 02:43:42 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14F4C061746;
        Wed,  6 Oct 2021 23:41:48 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id m26so5236013qtn.1;
        Wed, 06 Oct 2021 23:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZZjWmchPl2AxV82USMwNoOi/IEatk9SR7+Ig2TwmG/s=;
        b=JqZE6CCAF/RQeMAZIe6O3bLpkOg6dzcF8ZNo4aciaNw0pz7oWeRjn00CFeUfeq1h35
         ImHlbbbRZEe2yDqxJLlXD2ni4MkVJVBsPtr+jpnXof7GYA8M2mOCWE7a6ghGWtd/XFNo
         4aum+Oaq9MT1/X5FG3XtSIb5Z7HpdGHAhe1XlCOQWg5rAToQiLTfAQ3f6OE94NVTY0kh
         uwf7Kc9bj9yoQxgP9gcUY11ES4vWX+7ET8QOg9OmNEQnZOXUlNmrONZvnD8d4fdvcUVj
         V2AaNheugAyyxKJXYDnjMHQ+2sWnNfF6y6dHt4s4DQZJkGcIw6MurZmsyB4NmsZWeLiU
         KLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZZjWmchPl2AxV82USMwNoOi/IEatk9SR7+Ig2TwmG/s=;
        b=qhfbh+Hx7PHdZRX7rJTVMfMoSzLN+Ta0er78bzYI4QswE4TXxJTZBRGAyg/NRFgcR7
         pyWKy1KnNMXU1GFqvLEmltf7NL/zsZu5CDyKazdcj3nmkNkW/RHT8Xbjoyaa1SShImIV
         tv8iRFLSsHqmpW5xoyvjd7oaG0QZydiuOyYWXOtOiWwUWsYtLGKV7oAOaxjVEw7YV7Ft
         U6PCxIYs/QQOUjdqUGgDcvU38hhbDDnPUFmb3wph28Q9QtY9BsubDUjRaV9rrASaPj9h
         GT5/Th2XxWvOThmQkyVpoU9iAz4I9iMZs/OyFszJ8hdw07Mp9ItGKjvaFkWkJMejPBcq
         FW3A==
X-Gm-Message-State: AOAM531gRULqOHBWGqfCvIpAV5bBokf9vgXhxQ0D2G6XjhNf48ukHwPV
        cXlLUzQhWa5rBxZxy2e+CRejgiDe4wEq81LC6Ws=
X-Google-Smtp-Source: ABdhPJxXzEUsy3BbvH/t+km/X+wRBIXB0Y7FI32KfJ7Bvg3Oi0R6bsnbeK8TBZzrlcuzkNR+hfP87g==
X-Received: by 2002:ac8:6683:: with SMTP id d3mr3010580qtp.291.1633588908181;
        Wed, 06 Oct 2021 23:41:48 -0700 (PDT)
Received: from [10.20.0.12] ([37.120.215.226])
        by smtp.gmail.com with ESMTPSA id a3sm13146306qkh.67.2021.10.06.23.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 23:41:47 -0700 (PDT)
Subject: Re: [PATCH] tcp: md5: Fix overlap between vrf and non-vrf keys
To:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3d8387d499f053dba5cd9184c0f7b8445c4470c6.1633542093.git.cdleonard@gmail.com>
 <209548b5-27d2-2059-f2e9-2148f5a0291b@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <912670a5-8ef2-79cc-b74b-ee5c83534f2b@gmail.com>
Date:   Thu, 7 Oct 2021 09:41:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <209548b5-27d2-2059-f2e9-2148f5a0291b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.10.2021 04:14, David Ahern wrote:
> On 10/6/21 11:48 AM, Leonard Crestez wrote:
>> @@ -1103,11 +1116,11 @@ static struct tcp_md5sig_key *tcp_md5_do_lookup_exact(const struct sock *sk,
>>   #endif
>>   	hlist_for_each_entry_rcu(key, &md5sig->head, node,
>>   				 lockdep_sock_is_held(sk)) {
>>   		if (key->family != family)
>>   			continue;
>> -		if (key->l3index && key->l3index != l3index)
>> +		if (key->l3index != l3index)
> 
> That seems like the bug fix there. The L3 reference needs to match for
> new key and existing key. I think the same change is needed in
> __tcp_md5_do_lookup.

Current behavior is that keys added without tcpm_ifindex will match 
connections both inside and outside VRFs. Changing this might break real 
applications, is it really OK to claim that this behavior was a bug all 
along?

The approach with most backward compatibility would be to add a new flag 
for keys that only match non-vrf connections.

Alternatively (TCP_MD5SIG_FLAG_IFINDEX && tcpm_ifindex == 0) could be 
defined as "only non-vrf connections" while TCP_MD5SIG_FLAG_IFINDEX 
missing could be "either".

--
Regards,
Leonard
