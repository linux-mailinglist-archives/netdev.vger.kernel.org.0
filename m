Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F800102AE4
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbfKSRky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:40:54 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42694 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfKSRky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 12:40:54 -0500
Received: by mail-pf1-f194.google.com with SMTP id s5so12515485pfh.9
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 09:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KfsvNYi7dTzcPOtvAdMAPkGMzCWXlZQtM8UbRNvesKw=;
        b=NKOk0HykkkX5uYNjpkUv+XRg/TCUka2fJiHQD71TAFa85Cu1JZafiwh0nhliI3xFsw
         cLBziL1Fdtm7nW+zsr04ftDLM/P0TygGaHmrAtOgaOX1wrTyc5NHXNXY2NgRJ8+B7QYg
         c0fXGj3ALAMMhcIYKRaWW+mIU3y+Rnai835W+FCEiUaGM2Akn9kdkUtUYn4DlfKQ1CfQ
         6IcezYPD3781D7tFs55IHwj3hhMpstUXEGdxsr14bvqwnMQznj/lDsQmdZB2N78eWM9g
         J/WHk9NAWTmfi41FjhOztJGfiw2NKVj9X1RtjjjAmnNM6RKD5frieWJZ25DGrwgOGG6Y
         EN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KfsvNYi7dTzcPOtvAdMAPkGMzCWXlZQtM8UbRNvesKw=;
        b=eeMM/NRbx3sjLHTrvjkYHeWdTYReYqKLyfygczRNmw27sAzCJAZ2nNj/1PVaqT6agi
         3xLzQnrfzVX2w5YSLx9uGpGhgIrW7v+n+g/KquCIG7jApFs+nl6gSMhUa8ni+LjxshZl
         nFGmp9FTAgqYM1Kmgk/1th2Idk6Wm4UukM0xk3VoRCBrZywCuZ3GiJwoa6g28iyjeI6B
         ftZo+hd4t3YkvlNbGfe7+uRfrCHzyIIMjS6jwQsFRdH7Zv8gKEVGl9ouzVurtM+inxKz
         VyDC1uuUNS5lpLINvkYzCER4P6yP/YbN9gaoOg+hwp7AhtP8ni5mU8Tkq45SLYLetNtj
         xBqw==
X-Gm-Message-State: APjAAAXW4xKHAa9lpOfqIfwUXC3kG64QzQO/p+bftDnNXs1p2umqqmoi
        9DgDUR3CT6KITKr4mqj3gJk=
X-Google-Smtp-Source: APXvYqyOhEkeh5w+a14kRpgmKmHhjlSe19hFRi6uzLkNMQ2oLIfYBDEvCIG1Lz8yM0E1nDzu51zbGQ==
X-Received: by 2002:a63:cc17:: with SMTP id x23mr6853893pgf.446.1574185253802;
        Tue, 19 Nov 2019 09:40:53 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:3071:8113:4ecc:7f4c])
        by smtp.googlemail.com with ESMTPSA id i3sm25697587pfd.154.2019.11.19.09.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 09:40:53 -0800 (PST)
Subject: Re: [PATCH net-next v3 1/2] ipv6: introduce and uses route look hints
 for list input
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
References: <cover.1574165644.git.pabeni@redhat.com>
 <422ebfbf2fcb8a6ce23bcd97ab1f7c3a0c633cbd.1574165644.git.pabeni@redhat.com>
 <c6d67eb8-623e-9265-567c-3d5cc1de7477@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <115be9f5-7c80-5df9-f030-ae62d83f0e8b@gmail.com>
Date:   Tue, 19 Nov 2019 10:40:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <c6d67eb8-623e-9265-567c-3d5cc1de7477@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/19 10:34 AM, Eric Dumazet wrote:
>> diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
>> index 5d1615463138..9ab60611b97b 100644
>> --- a/include/net/ip6_fib.h
>> +++ b/include/net/ip6_fib.h
>> @@ -502,6 +502,11 @@ static inline bool fib6_metric_locked(struct fib6_info *f6i, int metric)
>>  }
>>  
>>  #ifdef CONFIG_IPV6_MULTIPLE_TABLES
>> +static inline bool fib6_has_custom_rules(struct net *net)
> 
> const struct net *net
> 
>> +{
>> +	return net->ipv6.fib6_has_custom_rules;
> 
> It would be nice to be able to detect that some custom rules only impact egress routes :/
> 

Or vrf. :-)

It's a common problem that needs a better solution - not lumping the
full complexity of fib rules into a single boolean.

