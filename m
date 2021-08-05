Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC263E1F35
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 01:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbhHEXN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 19:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhHEXNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 19:13:25 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4FEC0613D5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 16:13:10 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id g5-20020a9d6b050000b02904f21e977c3eso6911062otp.5
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 16:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=24XAboUUyxpv3JLo8zr8d3XCXSfLEMkk0OCni9MjHsY=;
        b=Xpi7UveHPov3Z+cAK3YpPwQVmlokvAvCewd+e9/cNYN8paDSjHUHPnEw95CDF198R4
         IH8EW0sVmFmPn1xcrahca78zVsJ2x8UI2lOSael9o6wsf/2UZeqa5fyjz6gJoQiZRTrw
         HBOL+ulgugP+ysPyK9OxWpo7DKGqhwoMw2FWDTjGLJ/M3066zwwLADpA/ifhlVkMLtLz
         GSkmSPif9SnOGJHUussdQfzjTppCY+mjYJNRpA9O3ZgOhw5DIvy6gxy5dJ0ElDw9XAEy
         FUy9f3IYyS3/DP6dHIOJ24QK9kE3RHJV3SRJF4EfHy5EbTmxQnQYXrzEw8EZALJHWvP8
         Hapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=24XAboUUyxpv3JLo8zr8d3XCXSfLEMkk0OCni9MjHsY=;
        b=pjCyXULVh045lXRlDABAN/9lCRM2KPw+Wl2PlmzyV3gOOcK9vC4n/jZo456rRIvD+W
         6QXzwZ7fK52cNZrbjq5rU0aTvwhpmTz2H7QBNyynndH2wZ7ihfpjxkW8zqhlMikcx/1G
         S02FE2AuQAHtfDOwngEpMfgG94+BmW9o4+2AGdXJyfMqn6dy2ns8XAfu9V39L7r/TLE/
         hLzzSqQtn2aqXUbqfOsX5mZ6VPBqWB3duQ9QkQXby9myt7tM8Gtfz3o/RmpFJZifTZy2
         2daHGQDTVE9sQOKhcEu+jsqF4UYa/uEqghWboq8PGJSxHeqEq4xG6Yaw97adYOEPo6hj
         Lk7g==
X-Gm-Message-State: AOAM532BK6WeNvN1niEaZ1eZJ3qGHIkrlhrSs8LM1pmV1WnMedFJIol/
        1dYaHN0NOt69U74k/jgINduNB2cMlJUJ0Q==
X-Google-Smtp-Source: ABdhPJzGS4tWAUSZz7rSIHcOMeVp+oaschTTDBzfWpydAy4E/AU/DnzsdWRe00n+nuNiJKSpJEPxYg==
X-Received: by 2002:a05:6830:2a0b:: with SMTP id y11mr5625582otu.275.1628205189972;
        Thu, 05 Aug 2021 16:13:09 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id w6sm1002040otu.25.2021.08.05.16.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 16:13:09 -0700 (PDT)
Subject: Re: [PATCH net] net: ipv4: fix path MTU for multi path routes
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210731011729.4357-1-vfedorenko@novek.ru>
 <dc6aafb6-cd1f-2006-6f45-55a4f224e319@gmail.com>
 <71b3384d-6d9c-4841-c610-463879f993b2@novek.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <54587372-eb47-e154-2d63-75b14fa6f3d5@gmail.com>
Date:   Thu, 5 Aug 2021 17:13:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <71b3384d-6d9c-4841-c610-463879f993b2@novek.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/21 2:51 PM, Vadim Fedorenko wrote:
> On 01.08.2021 18:12, David Ahern wrote:
>> On 7/30/21 7:17 PM, Vadim Fedorenko wrote:
>>> Bug 213729 showed that MTU check could be used against route that
>>> will not be used in actual transmit if source ip is not specified.
>>> But path MTU update is always done on route with defined source ip.
>>> Fix route selection by updating flow info in case when source ip
>>> is not explicitly defined in raw and udp sockets.
>>
>> There is more to it than just setting the source address and doing a
>> second lookup.
>>
> You are right. Update of source address fixes only some specific cases.
> Also, I'm not fun of doing several lookups just because we found additional
> next hops. It looks like (for ipv4 case) fib_table_lookup() should select
> correct next-hop based on hash and update source ip and output interface
> for flowi4. But right now flowi4 is constant and such change looks more
> like net-next improvement. Or do you have another solution?
> 

This is a rare case where I wrote the test script first lacking ideas at
that moment. What comes to mind now is that one part of the solution is
to make ipv4 similar to ipv6 in that

1. device bind is always stronger than source address bind, and
2. if saddr is set, prefer the nexthop device with that address (but
only for local traffic). This handles the connect() case where saddr has
not been set yet.

The second one will get expensive if a device has multiple addresses.
FIB lookups for IPv4 have been highly optimized, and we do not want to
explode the lookup time for forwards where saddr is always known and it
does not need to be considered in the lookup to fix local local traffic
which needs a saddr to be picked along with the egress device. Perhaps a
flow flag (SKIP_SADDR similar to the current SKIP_NH_OIF) will address
this part. Another less desirable option is to improve but not totally
fix the problem by only considering the primary address.

For ICMP the PMTU update should look at the header returned in the icmp
payload to determine which device needs the pmtu exception.
