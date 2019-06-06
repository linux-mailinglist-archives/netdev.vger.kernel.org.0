Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4B437375
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfFFLww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:52:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45104 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbfFFLww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 07:52:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so2067199wre.12
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 04:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D7yjwBR1jsr0+9ayTlNRfsWf5Eqwq17fMyTwPLqOJM8=;
        b=AaO++9FK1kt9ca+Ai8+jjRozM8PKI8lXEvXUq+h9J1ULqRGpEPV15looEGtDOJYH/n
         RqkPEYnWGk6tjIz1uVnt14DkZ+FcyoC+9fwFeudb1STm1Q7x8U2YJItmii+9+J+6dOJT
         ol4J8tij2wU9JRVmur0FsXLYHCF6BpVCmPIMRhaSli60ZNuxh8LzYCjqfI19K40qtrOb
         TG9HLRI6AJYSP+8i0CXovG5yvSgqAVIJ5GI+Cjea6nak7L6+YsMlYoRH83qEjHffbx3s
         ZFfaM43+MdJJzRSLliGWmd9kZjkHPzDGJmKafvigCRnMJwZwtLYDliATi1aduTTLKq4N
         miVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=D7yjwBR1jsr0+9ayTlNRfsWf5Eqwq17fMyTwPLqOJM8=;
        b=sI6m9Uq7XaxEuKaMA2VB8hagN7ghkk/aON4iOeMR1oYMpyTXXxZhw/yh8gkcWx0x0H
         C682NGjrZMkQtc+j5Cmh1sAdURLtxKmVbsrQSU0c4JIciANPj+npGLUWmRERJlYntRW6
         0kMN+06sBaGO/at4h9foylBhKf8GVMysjn/DqIFnW5UIiOEm8zOqBJGyADBYrilCqAWg
         r2Mf5D2n3NM4Zpczwmy9unl3Uj6/s0Y3wQo6fvbvmgDs8Pcl1XlAGLtewFPtnOIf6+xv
         4CIvRYvrGAWNPUjD5tqhC3tQQex4oNFVF0Zpkk7URbESrLPa1EI4MfZpuNCbQYHCbUB+
         CktA==
X-Gm-Message-State: APjAAAWJTHiR9fkjCTX7C7fRc4eSE7Tuvo3KrqRtZ8dMxjCClsJ8xX6z
        03+QZzL1aB3GjQVSBEkjDN2Mhw==
X-Google-Smtp-Source: APXvYqxqLuSpDVaWfaJgY7eBysBC32Xzf0PxmQtxM/5sCOtd0qSDxHvv21npAERcrx2FSea7BSQX2w==
X-Received: by 2002:adf:ec0f:: with SMTP id x15mr29557905wrn.165.1559821970592;
        Thu, 06 Jun 2019 04:52:50 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:991b:82da:b53a:751f? ([2a01:e35:8b63:dc30:991b:82da:b53a:751f])
        by smtp.gmail.com with ESMTPSA id z192sm1170461wme.9.2019.06.06.04.52.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 04:52:49 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net 2/2] ipv6: fix EFAULT on sendto with icmpv6 and
 hdrincl
To:     Olivier Matz <olivier.matz@6wind.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Cc:     Hannes Frederic Sowa <hannes@stressinduktion.org>
References: <20190606071519.5841-1-olivier.matz@6wind.com>
 <20190606071519.5841-3-olivier.matz@6wind.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <ba701a09-64c8-93c6-7e1a-2e3de3879678@6wind.com>
Date:   Thu, 6 Jun 2019 13:52:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190606071519.5841-3-olivier.matz@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 06/06/2019 à 09:15, Olivier Matz a écrit :
> The following code returns EFAULT (Bad address):
> 
>   s = socket(AF_INET6, SOCK_RAW, IPPROTO_ICMPV6);
>   setsockopt(s, SOL_IPV6, IPV6_HDRINCL, 1);
>   sendto(ipv6_icmp6_packet, addr);   /* returns -1, errno = EFAULT */
> 
> The IPv4 equivalent code works. A workaround is to use IPPROTO_RAW
> instead of IPPROTO_ICMPV6.
> 
> The failure happens because 2 bytes are eaten from the msghdr by
> rawv6_probe_proto_opt() starting from commit 19e3c66b52ca ("ipv6
> equivalent of "ipv4: Avoid reading user iov twice after
> raw_probe_proto_opt""), but at that time it was not a problem because
> IPV6_HDRINCL was not yet introduced.
> 
> Only eat these 2 bytes if hdrincl == 0.
> 
> Fixes: 715f504b1189 ("ipv6: add IPV6_HDRINCL option for raw sockets")
> Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
