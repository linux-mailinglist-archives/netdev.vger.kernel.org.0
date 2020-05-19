Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9151B1D9265
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 10:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgESIsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 04:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgESIsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 04:48:08 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A70C05BD09
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 01:48:07 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id e125so9740375lfd.1
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 01:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U/ld2C6UkfUm+0XXaV5SCELf0Vu+fvPgEOXXaaV4x74=;
        b=f54vyIKs0CnsN31YzeIxowVAKASrqI5IDMQpU0gF3uPy+ATUat8dkWzSRqqogy77Mc
         K0SlhCxkbIE3x/PDSMnLHccl//h/oPBSYYvH60VqAqxQxbyYX2FiJYvOPFN2GWRO0XCZ
         pWGRBJoJcUhTriCOO/6P4sEo48rlApQZMOXIo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U/ld2C6UkfUm+0XXaV5SCELf0Vu+fvPgEOXXaaV4x74=;
        b=gxOSAr67TtyPdXelbmL/YgD1EWtfbiXzyyZkt6sXA4Ks4DuSnb6K6e5izidajLdavS
         vJJnVcyyB57b/oEzjeLLKOEhu51YytgIGuG6BYoQ6BqcVGyyLzdoFoc/FsUIcQ6I2f+7
         vCI5SjEzcXInTjBxXUyv7WyJEkI4G2e2ad4n829CqI1UYO4eD6FtcGdVCYDdez+ufY+3
         eCHbQ44WO9ljbvIM77A4+EgqOGt3WLrgxzQKsPYRwN+IKGX5rm80vjd9beEouEN/OE++
         fjlZglvx2Q+iW/4dEhoS8AtoU6ifVYJbbAQ2ovC3rUgyJUh4iSu92Chv3kXAMbYqLIQd
         zWjQ==
X-Gm-Message-State: AOAM532jP5zb3G77+7QOnGTATn+wRAyl+7CLUcHi4hD7pOABGlw0dpzy
        hc0UGvO4YGXVhKPkZWk8aJYjfQ==
X-Google-Smtp-Source: ABdhPJz2qU6elmnp/uxpc+sB7cZ0fXIi9UNLnAWgtaDLcOfrxCyKAbC/9A6GwmoqwE7MAAJFeZ/lfg==
X-Received: by 2002:a19:d57:: with SMTP id 84mr14589460lfn.112.1589878086400;
        Tue, 19 May 2020 01:48:06 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v18sm4015249ljc.55.2020.05.19.01.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 01:48:05 -0700 (PDT)
Subject: Re: [PATCH net-next 1/6] nexthop: dereference nh only once in
 nexthop_select_path
To:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        petrm@mellanox.com
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
 <1589854474-26854-2-git-send-email-roopa@cumulusnetworks.com>
 <ecd765d8-4e83-dd20-5d71-8c4bb7b30639@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <999e09f0-2593-d079-e8f4-f9db6f2f85af@cumulusnetworks.com>
Date:   Tue, 19 May 2020 11:48:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <ecd765d8-4e83-dd20-5d71-8c4bb7b30639@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2020 06:25, David Ahern wrote:
> On 5/18/20 8:14 PM, Roopa Prabhu wrote:
>> From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>>
>> the ->nh pointer might become suddenly null while we're selecting the
>> path and we may dereference it. Dereference it only once in the
>> beginning and use that if it's not null, we rely on the refcounting and
>> rcu to protect against use-after-free. (This is needed for later
>> vxlan patches that exposes the problem)
>>
>> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
>> ---
>>  net/ipv4/nexthop.c | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>
> 
> Should this be a bug fix? Any chance the route path can hit it?
> 

That was fast, I didn't expect to see it on upstream so quickly. :)
So I haven't had time to inspect it in detail, but it did seem to me
that it should be possible to hit from the route path. When I tried
running a few basic tests to make it happen I couldn't mainly due to the
fib flush done at nexthop removal, but I still believe with the right
timing one could hit it.

In fact I'd go 1 step further and add a null check from the return
of nexthop_select_path() in the helpers which dereference the value it
returns like:  nexthop_path_fib6_result() and nexthop_path_fib_result()

The reason is that the .nh ptr is set and read without any sync primitives
so in theory it can become null at any point (being cleared on nh group removal),
and also the nh count in a group (num_nh), when it becomes == 0 while destroying a nh group
and we hit it then in nexthop_select_path() rc would remain == NULL and we'll
deref a null ptr. We did see the above with the vxlan code due to it missing the equivalent
of a fib flush (or rather it being more relaxed), but I haven't had time to see how feasible
it is to hit it via the route path yet.





