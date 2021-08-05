Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8883E1651
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241450AbhHEOFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241858AbhHEOFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 10:05:17 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A867C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 07:04:19 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id b25-20020a4ac2990000b0290263aab95660so1329746ooq.13
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 07:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jriByzyhrgk5PqT0TTXr/bcvWNeCJ6JcDk7WTOQw6+g=;
        b=UY3MUxv1wlBCJqD6cmpk9bqYXvgh1S2LtSLbUQE9EihTSplUt4y/64GVYiZrGiH8oq
         0bnrENhJcqT68G+pLjQNuCmzffFPVeEPLrsqBOgfi/5V6yPRT6hgRxgWpWIXSTOJ7q4h
         sHPtXOaZ49m+FT0OdeQCvShRXwhUEolxTr7rW/9YFHU8ltvnnUE89Hc9lII10um54MU2
         gdd9oxikr4LLBMwJlNmyCPhkiz8pQeEQwi583/jtOddp4Du6XcMWo2y6yCjWhWznwSgf
         cwzejssfylkDNTKMV49FlO9UjhsNMd6NADvy8eMLAJfLM1B9fZ/vm3ebHinFSL41AwdM
         nXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jriByzyhrgk5PqT0TTXr/bcvWNeCJ6JcDk7WTOQw6+g=;
        b=Nch6CbWqMCP7rv7XOSb8t+UOkKFEC6gVPENGiFTtq2dQT1gvB3E8mjbSDI5umzQFGe
         GBKIRdiP0+ccWETl2ZUFd3dkjBkO78JsNGtZ+1SuaDPGojHmYmE1Y5eQWn35CeNAeRCH
         TZWecVMOLJZ32OLN8nJw3Ow4VPruHgNrXRZOTfDizSkMpVJPrp8G4d2rinLMxLaFbBrH
         4PJDWoKzWQyAaPfcq56bwKTuw9nXr3VIdFPSk9FyPcn6LT2fGcCyyZrdSvSkMACzsfEl
         5D3EYG+4w1TRq9SR+CQdLELROkNT0eaR1UP6oRFp3Skn4FujBtci1X0dQIRMsSJ5n+Ge
         lV0A==
X-Gm-Message-State: AOAM533tuF3pIGDYo4WrP22le278gc4mX8qbEIOx7Isnsxa5JvwFz9bi
        Tl8PJPu7WgC8C3suvfpJFGs=
X-Google-Smtp-Source: ABdhPJzSg2KmVSL9RGDxX20fyRhpdh0GgK3KKaHKkFl2wcol32d3r/whCl7Dlkkhl0v3Lbm84VyFnA==
X-Received: by 2002:a4a:d40a:: with SMTP id n10mr3340780oos.32.1628172258812;
        Thu, 05 Aug 2021 07:04:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id m2sm951539otr.46.2021.08.05.07.04.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 07:04:18 -0700 (PDT)
Subject: Re: net/ipv6: broken handling of ICMPv6 redirects since Linux
 4.18-rc1
To:     =?UTF-8?Q?Ond=c5=99ej_Caletka?= <Ondrej.Caletka@ripe.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>
References: <472e38a0-5096-4d5a-755b-f8658a05c4b3@ripe.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <17674516-5e6b-5222-4925-2af73b91f84e@gmail.com>
Date:   Thu, 5 Aug 2021 08:04:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <472e38a0-5096-4d5a-755b-f8658a05c4b3@ripe.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/21 6:50 AM, Ondřej Caletka wrote:
> 
> Dear maintainers,
> 
> I think I discovered a bug introduced in 4.18-rc1 and still present in
> 5.14-rc4. The problem is that Linux does not react on received ICMPv6
> redirect - the nexthop visible in the output of "ip -6 route get <dest>"
> does not get changed and the data are still sent to the nexthop of the
> default gateway. This used to work in kernels up to and including 4.17.19.
> 
> Steps to reproduce:
> -------------------
> 
> I am reproducing the issue in a VM running Ubuntu 20.04 running three
> LXD containers. I use tool `redir6` from
> [THC-IPv6](https://github.com/vanhauser-thc/thc-ipv6) to perform the
> redirect attack. I am testing using vanilla kernels, compiled following
> this guide: https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
> 
>  1. Download and run [the
> VM](https://github.com/RIPE-NCC/ipv6-security-lab)
>  2. on hostA, check that an arbitrary IPv6 address is routed through the
> default gateway:
> 
>     root@hostA:~# ip -6 rou get 2001:db8:bad:dad::1
>     2001:db8:bad:dad::1 from :: via fe80::216:3eff:feee:1 dev eth0 proto
> ra src 2001:db8:f:1:216:3eff:feee:a metric 100 mtu 1500 pref medium
> 
>  3. on hostC, perform the redirect attack and sniff the incoming traffic
> 
>     root@hostC:~# redir6 eth0 2001:db8:f:1:216:3eff:feee:a
> 2001:db8:bad:dad::1 fe80::216:3eff:feee:1 fe80::216:3eff:feee:c
>     Sent ICMPv6 redirect for 2001:db8:bad:dad::1
>     root@hostC:~# tcpdump -nei eth0 dst host 2001:db8:bad:dad::1
> 
>  4. on hostA, check the route again and try to send an echo request to
> that address:
> 
>     root@hostA:~# ip -6 rou get 2001:db8:bad:dad::1
>     2001:db8:bad:dad::1 from :: via fe80::216:3eff:feee:1 dev eth0 proto
> ra src 2001:db8:f:1:216:3eff:feee:a metric 100 mtu 1500 pref medium
>     root@hostA:~# ping -c 1 2001:db8:bad:dad::1
>     PING 2001:db8:bad:dad::1(2001:db8:bad:dad::1) 56 data bytes
>     From 2001:db8:f:1::1 icmp_seq=1 Destination unreachable: No route
> 

how does your test differ from:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/tools/testing/selftests/net/icmp_redirect.sh

Can you create a similar script for your test setup?

