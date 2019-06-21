Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524104F042
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 23:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfFUVEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 17:04:45 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40787 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFUVEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 17:04:45 -0400
Received: by mail-io1-f67.google.com with SMTP id n5so455442ioc.7
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 14:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GUv/2Go+C+l8UoDaXQAtiqkeqgUULLjeW1QkMNAIGKU=;
        b=QICFnwZLqcJlpqG+SKQi+8ZQ6oI7EBh0wfEejcEMoD9s1UT+yH37rnZ7jQXQ1g4T14
         aDbi9I+0iUXnwTE7ZhX7Kk8NNnmI+IVMR6okaVkdQoLBnNbfvRheR/+UfSr8XOvqP3td
         aIJrHCB5uHc8uoQ/zgJz3EAYHZE7orNpoEOZW8rSSmxJZXUaIXP2xwuxDkWsngNHnZx7
         YrRJbjZEPnExMAkiJg0OurEtHgLnWim3cG4rBYPXY0F8eJoo/8HcPw8gIzLuK8P3VAlj
         vJ20cPhyR29KfiGxkkEmsEkJOty2fO0wnxmUtM2b5iCnDBZIaX6j/GiopMVQEuE3KcIr
         6SGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GUv/2Go+C+l8UoDaXQAtiqkeqgUULLjeW1QkMNAIGKU=;
        b=XXBjhCMD5WYqYotoKyZJipn+xBQ9o+DMjYgkTikGJQljH+dcD4VzqsPr25txOCbbcn
         RLhI1yT2vEwunX1dpYsR+28aeB5yyOEfbRrJOWUHjWjE5OEWytGuOW8dxiUPviIJVpOC
         KDt/Ei5ruwT+Xk6x4Av7m6mWM1JAeeW7VxEQksKVwUQwKsrCkTwqWE74ieNIxHUJmEiq
         iqFaa8qBvKpM6Os6xSwxkWVgT+RBsB3p8yk7GHRfNmf6b3SEYBZFm5KC9bI0ym5aa7LO
         mBdOKsHztsCCBuErGrFnD4HVUxQiuOWvmbmJ6Nj3JWjYeFGX76vCBPVCydSEZwBbfwU/
         05pQ==
X-Gm-Message-State: APjAAAU4IfWWlWldx3ZPLbH4ML9Y/8yDYO2AFZsbVWEB6em9/V8rmsxf
        x15wBWWkIdddtaB5av6HXKE=
X-Google-Smtp-Source: APXvYqw2XwHBs83sBLPHe3Hhd1FkJU1pnCH6MEB2a6UFN3tkroqsXorqT0u2KxN+c/9HbOOxLI/reQ==
X-Received: by 2002:a05:6638:2a9:: with SMTP id d9mr108373291jaq.94.1561151084463;
        Fri, 21 Jun 2019 14:04:44 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:563:6fa4:e349:a2f8? ([2601:284:8200:5cfb:563:6fa4:e349:a2f8])
        by smtp.googlemail.com with ESMTPSA id r139sm7009021iod.61.2019.06.21.14.04.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 14:04:43 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: Convert gateway validation to use
 fib6_info
To:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
References: <20190620190536.3157-1-dsahern@kernel.org>
 <CAEA6p_BUSFUCJJ_WsAAM2JRhQBBHjUepNZPpFX6DrTSCancD_g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5b43374f-bcc4-bb58-ae61-b0f191330f20@gmail.com>
Date:   Fri, 21 Jun 2019 15:04:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_BUSFUCJJ_WsAAM2JRhQBBHjUepNZPpFX6DrTSCancD_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 5:43 PM, Wei Wang wrote:
> I am not very convinced that fib6_lookup() could be equivalent to
> rt6_lookup(). Specifically, rt6_lookup() calls rt6_device_match()
> while fib6_lookup() calls rt6_select() to match the oif. From a brief
> glance, it does seem to be similar, especially considering that saddr
> is NULL. So it probably is OK?


When you remove the rt6_check_neigh call since RT6_LOOKUP_F_REACHABLE is
not set that removes the RT6_NUD_FAIL_DO_RR return and round-robin
logic. I am reasonably confident that given the use case - validate the
gateway and optionally given the device - it is the same.

rt6_select is much more complicated than rt6_device_match, so there is a
small possibility that in some corner case gateway validation fails /
succeeds with fib6_table_lookup where it would succeed / fail with
ip6_pol_route_lookup. But, ip6_pol_route and fib6_table_lookup is the
code path actually used for packet Rx and Tx, so it seems to me to be
the more proper one for gateway validation.

I will send a v2 with idev change you mentioned.
