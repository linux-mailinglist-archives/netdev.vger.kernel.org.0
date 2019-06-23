Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC0C94FDDE
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 21:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfFWT3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 15:29:33 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46243 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfFWT3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 15:29:32 -0400
Received: by mail-io1-f66.google.com with SMTP id i10so418067iol.13
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 12:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oAPqNzxblEa/t1Y69+Dev/JY4lVFvQNfr72OlFwbi9Y=;
        b=V1GzaPWExFtMCkUf1a2pUgxJ2fmvRYFO3nqEUuusfW3BMpaXL3xr8pUOvxUBAL2A4V
         glwCncrRVLcAlPBIZDTQ9EJHgjO3FMYy1zxCrVWtbl0rwNAaqQ7bxnrk2sCVVviFuDVB
         qvkT4dK1HRn7M6at44n57+4tfhzk+YsU0ruoBMRZCBO3qSeHLQ8ROhpfbizBnH3R5VLn
         lQsOR6SpeUMtvjHMaJNWdgXzZrEEXB0xSeUq2DoMXd4KEwKqVYUaMv9Z64KC/JLLD/kR
         DW+6qHDjTfvfskWwTF1ftFhOxHFj+rQmvGFKdvZSQNr1crW40/Ma2Qy8wpGfrRf8VfB5
         1unw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oAPqNzxblEa/t1Y69+Dev/JY4lVFvQNfr72OlFwbi9Y=;
        b=bV8pnNE/tizpmss32tD7Xeq8QkhoFLAtETcAo+1iiLkuV1Oe2iTmQMVguTzJPNOMHa
         blnO5lmNhd5xWqGVdyTlKdFxOYHQYJRD1EBIGkFrf54/Q7Ya46WJW5/tBbpbFy1/SVh3
         EaGAWUXYgpuf+F4AH8iLaSMlxgNUt9nOADYaOcvSbcJHbOdE5sFXok1q0NE9VT5wysW8
         fYEXvpjjzO8CRqJ5WyKcrAPIfo6GMSlqq2huITFnV/aG1eDeP218rZi/U1U9PUhEKuw1
         MqAvja8VSsFqfdlr9OnDY1D8hTuXOkp9UXZ243bu0iTNdhQrV34apgn76b2vY7EmkrFc
         q7Zg==
X-Gm-Message-State: APjAAAXTbNqhskUwjtY1eULNHTVwIWuZx5sQiE2PK7noE837xWbI7mbK
        Pg4KOWWcPYlB7MIZG6cLJm4=
X-Google-Smtp-Source: APXvYqwSQaHAEJ5AiCUsa/xk43EVc583ugIxg1P0cjag6xop6n+hpnM03ZXi0gaLaPjbiPiJx+b+Cw==
X-Received: by 2002:a5d:9291:: with SMTP id s17mr32892986iom.10.1561318172092;
        Sun, 23 Jun 2019 12:29:32 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:dcc2:fba4:65c6:3e97? ([2601:284:8200:5cfb:dcc2:fba4:65c6:3e97])
        by smtp.googlemail.com with ESMTPSA id q15sm8307157ioi.15.2019.06.23.12.29.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 12:29:31 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 0/5] ipv6: avoid taking refcnt on dst during
 route lookup
To:     David Miller <davem@davemloft.net>, tracywwnj@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, kafai@fb.com,
        maheshb@google.com, weiwan@google.com
References: <20190621003641.168591-1-tracywwnj@gmail.com>
 <20190623.112716.2247998657903069805.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d458f7d7-656b-35ce-a0dc-8444e9562ec1@gmail.com>
Date:   Sun, 23 Jun 2019 13:29:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190623.112716.2247998657903069805.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/19 12:27 PM, David Miller wrote:
> From: Wei Wang <tracywwnj@gmail.com>
> Date: Thu, 20 Jun 2019 17:36:36 -0700
> 
>> v2->v3:
>> - Handled fib6_rule_lookup() when CONFIG_IPV6_MULTIPLE_TABLES is not
>>   configured in patch 03 (suggested by David Ahern)
>> - Removed the renaming of l3mdev_link_scope_lookup() in patch 05
>>   (suggested by David Ahern)
>> - Moved definition of ip6_route_output_flags() from an inline function
>>   in /net/ipv6/route.c to net/ipv6/route.c in order to address kbuild
>>   error in patch 05
> 
> I'll give David A. a chance to review this before applying.
> 

Hey Dave: I responded to the cover-letter on Friday.
