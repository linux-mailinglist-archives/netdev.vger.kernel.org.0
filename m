Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE8FE3703
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 17:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409774AbfJXPvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 11:51:03 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:43381 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407481AbfJXPvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 11:51:02 -0400
Received: by mail-il1-f193.google.com with SMTP id t5so22820935ilh.10
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 08:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=91YCoLQglIjFy/V8ekofQrN5p+EG2Cg5zkInQ0hf2Iw=;
        b=mrVhAIk5Kq9tm94pW8qHY8ikxBBKBeeCuPs14C3wfckC4EibFvfwN61vx2NAqCraLg
         SLpiQPtOUUInFIRr8hFeHEaYGTmr837/+c0Ky0rhzesqcLSjjYB/8Q7/nihbc4/z65qB
         qpzmOr/3tsRHAI7vB9VVukOXXuhW/MMX86VqmZgJTrUJ+Ngdp2C2BCdSZX8SDud5/k9s
         ds19DE3LPcJGXW78pKEMsv0/4QKD+IP/n/8wqPKAOpNKi1brJHT4u97Qeo1bmnp5zgaG
         S0uRarXQ0C/DqHv0je53lEowT2t6KAshWHIa66OUEc+2xuidyWqavfsdqO29ljY4g/mo
         qZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=91YCoLQglIjFy/V8ekofQrN5p+EG2Cg5zkInQ0hf2Iw=;
        b=BPUR9xV51e7DnQlOe6/Y8CavnLCWlAFKreyCXy2kooxtDtCv9eNs2bW75JmZNDyv+v
         q4mMi2sAMMXfXj42ZQ5a7QEB3Gk2Q9+GU+nUoqReR0SKcUzWpCIrjoNJfanUMNkzhLzC
         QRrNWXl0dtmRbXxEzlRFr1y5ljgR7tAcGG40Nca3kvyhqrsbA/lNBHs34DoKuryWhNAO
         jlIP9XH9zxEBggk7j2IP/xcKSHRtOWn4Q8/1Ry+ji8kZ9nCdBAqB8NmgTGyLdjHRZfPA
         pZu/MM63jHBFTZBFGhkEbuZKW8bipp25TPi5FVTrMBOZ70RnRC7ELEwxtRbaR8IVIpZ+
         O/NA==
X-Gm-Message-State: APjAAAW1XPIEzgZTUTH8h6HVhRdk+/Q7uiIIFTJpzJ9yo7rVQdus7J9q
        9OMtuCoumcXQzHD+5iIq/nyZeWfgQPM=
X-Google-Smtp-Source: APXvYqwroipN9kMiYDpUMOks4c+0DNHxa7bO2dXjdSHh9fNfeFDzh7gaii30bCf7QnovZzKmhWVihw==
X-Received: by 2002:a92:a103:: with SMTP id v3mr46654281ili.52.1571932261968;
        Thu, 24 Oct 2019 08:51:01 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:cc37:f84e:7c6c:2bc6])
        by smtp.googlemail.com with ESMTPSA id n2sm5864208ion.25.2019.10.24.08.50.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 08:51:00 -0700 (PDT)
Subject: Re: [PATCH net] ipv4: fix route update on metric change.
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Beniamino Galvani <bgalvani@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <84623b02bd882d91555b9bf76ea58d6cff29cd2a.1571908701.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a93347d4-b363-23c8-75e4-d5d0c8ad4592@gmail.com>
Date:   Thu, 24 Oct 2019 09:50:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <84623b02bd882d91555b9bf76ea58d6cff29cd2a.1571908701.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/19 3:19 AM, Paolo Abeni wrote:
> Since commit af4d768ad28c ("net/ipv4: Add support for specifying metric
> of connected routes"), when updating an IP address with a different metric,
> the associated connected route is updated, too.
> 
> Still, the mentioned commit doesn't handle properly some corner cases:
> 
> $ ip addr add dev eth0 192.168.1.0/24
> $ ip addr add dev eth0 192.168.2.1/32 peer 192.168.2.2
> $ ip addr add dev eth0 192.168.3.1/24
> $ ip addr change dev eth0 192.168.1.0/24 metric 10
> $ ip addr change dev eth0 192.168.2.1/32 peer 192.168.2.2 metric 10
> $ ip addr change dev eth0 192.168.3.1/24 metric 10
> $ ip -4 route
> 192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.0
> 192.168.2.2 dev eth0 proto kernel scope link src 192.168.2.1
> 192.168.3.0/24 dev eth0 proto kernel scope link src 192.168.2.1 metric 10

Please add this test and route checking to
tools/testing/selftests/net/fib_tests.sh. There is a
ipv4_addr_metric_test function that handles permutations and I guess the
above was missed.

Also, does a similar sequence for IPv6 work as expected?


> 
> Only the last route is correctly updated.
> 
> The problem is the current test in fib_modify_prefix_metric():
> 
> 	if (!(dev->flags & IFF_UP) ||
> 	    ifa->ifa_flags & (IFA_F_SECONDARY | IFA_F_NOPREFIXROUTE) ||
> 	    ipv4_is_zeronet(prefix) ||
> 	    prefix == ifa->ifa_local || ifa->ifa_prefixlen == 32)
> 
> Which should be the logical 'not' of the pre-existing test in
> fib_add_ifaddr():
> 
> 	if (!ipv4_is_zeronet(prefix) && !(ifa->ifa_flags & IFA_F_SECONDARY) &&
> 	    (prefix != addr || ifa->ifa_prefixlen < 32))
> 
> To properly negate the original expression, we need to change the last
> logical 'or' to a logical 'and'.
> 
> Fixes: af4d768ad28c ("net/ipv4: Add support for specifying metric of connected routes")
> Reported-and-suggested-by: Beniamino Galvani <bgalvani@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/ipv4/fib_frontend.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index dde77f72e03e..71c78d223dfd 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -1148,7 +1148,7 @@ void fib_modify_prefix_metric(struct in_ifaddr *ifa, u32 new_metric)
>  	if (!(dev->flags & IFF_UP) ||
>  	    ifa->ifa_flags & (IFA_F_SECONDARY | IFA_F_NOPREFIXROUTE) ||
>  	    ipv4_is_zeronet(prefix) ||
> -	    prefix == ifa->ifa_local || ifa->ifa_prefixlen == 32)
> +	    (prefix == ifa->ifa_local && ifa->ifa_prefixlen == 32))
>  		return;
>  
>  	/* add the new */
> 

Thanks for the patch

Reviewed-by: David Ahern <dsahern@gmail.com>
