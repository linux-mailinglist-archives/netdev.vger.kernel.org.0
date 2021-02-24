Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A0C324532
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 21:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbhBXU3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 15:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbhBXU3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 15:29:34 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC21CC061574;
        Wed, 24 Feb 2021 12:28:53 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id k13so3438353otn.13;
        Wed, 24 Feb 2021 12:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g8yzyix+IBCeN/i+RiSu4Jq3q/QFYRj0Nua9JyTjFK4=;
        b=hqDvrFDsQ5MvQSbJVnlL/9wEf+SAx47eVa3PVW0GqFk7CflZ4iulDIBXQVzWD/AdQb
         z8CdTdSUggVtoa8YgDRhKtV0YjEDogFXBZL3f0BsUodiJzM+g3R+1DkP1gvwRmkXjpx7
         lkoARERQplIs8XTTwfWSZt6eb5S39YqdWyt1ZlBuULD9OGNFHwPBzZsxF8ftlFqhFYRb
         ZxoUrR4Szn/5gAYB2ygEUAl/TOSouQjh7feR5eG5rZ/LNoUi6riHzh8Sb0+mXNDUW4X9
         6DOT19PHUayPbBm4uGZQA0OM6qFPtAC/EQnpsX+QVQRmTiqcOoYYgIPVxk/6yg/Di0VV
         JyIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g8yzyix+IBCeN/i+RiSu4Jq3q/QFYRj0Nua9JyTjFK4=;
        b=tA7iPbEuXqsmVQlSZFaCC3Rw6GyxqUQFf1545xTI0eut2b0yB49DA3HyhyGVtk9rX4
         v/o4AoIOdNcmdIxpciSKgKJz7X8gyUQlb7SCY7ABtbtXaDrYHSp5LsSbHlLFV/lXjS/y
         UUxAq608S3gJDUQh8Rm/P5Ui9JVQ0PQ4r5eMYz5ww2iDaLdlhhKArEV7l54dKcovZNOh
         t62i/cwtzICcO5dBwakXeFHvBqm/IdRqCAkLvwtR28CWEn9Uw19WXlboVAkFbcdh+eox
         4jC0qK3+e8/3t5G0gkk5/4cPAJvqdSZA15vj0d1dwQtThz/r6zJRn4PMM8KTpA1/q55P
         GVeA==
X-Gm-Message-State: AOAM531uCTH+3xJgfqIiwi6XpDqf7ceJmJ56JfKqlAJr2rM+pxD24sIf
        KGwB8Ks/KfLa8qx6O5IqjU4=
X-Google-Smtp-Source: ABdhPJyyb/Tctv0HAuz3MFor4ImuhjdoiT5AWIvz+WIQw7tqI/ZQkeGs/rqa/9iNH8KMUN2e4Lak7Q==
X-Received: by 2002:a9d:7103:: with SMTP id n3mr25109608otj.223.1614198533309;
        Wed, 24 Feb 2021 12:28:53 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id h15sm598731otq.13.2021.02.24.12.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 12:28:52 -0800 (PST)
Subject: Re: [PATCH] ipv6: Honor route mtu if it is within limit of dev mtu
To:     Kaustubh Pandey <kapandey@codeaurora.org>,
        Stefano Brivio <sbrivio@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sharathv@codeaurora.org,
        chinagar@codeaurora.org
References: <1614011555-21951-1-git-send-email-kapandey@codeaurora.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ef380be3-0a87-9599-f3ea-ec7779ad5db1@gmail.com>
Date:   Wed, 24 Feb 2021 13:28:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1614011555-21951-1-git-send-email-kapandey@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/21 9:32 AM, Kaustubh Pandey wrote:
> When netdevice MTU is increased via sysfs, NETDEV_CHANGEMTU is raised.
> 
> addrconf_notify -> rt6_mtu_change -> rt6_mtu_change_route ->
> fib6_nh_mtu_change
> 
> As part of handling NETDEV_CHANGEMTU notification we land up on a
> condition where if route mtu is less than dev mtu and route mtu equals
> ipv6_devconf mtu, route mtu gets updated.
> 
> Due to this v6 traffic end up using wrong MTU then configured earlier.
> This commit fixes this by removing comparison with ipv6_devconf
> and updating route mtu only when it is greater than incoming dev mtu.
> 
> This can be easily reproduced with below script:
> pre-condition:
> device up(mtu = 1500) and route mtu for both v4 and v6 is 1500
> 
> test-script:
> ip route change 192.168.0.0/24 dev eth0 src 192.168.0.1 mtu 1400
> ip -6 route change 2001::/64 dev eth0 metric 256 mtu 1400
> echo 1400 > /sys/class/net/eth0/mtu
> ip route change 192.168.0.0/24 dev eth0 src 192.168.0.1 mtu 1500
> echo 1500 > /sys/class/net/eth0/mtu
> 
> Signed-off-by: Kaustubh Pandey <kapandey@codeaurora.org>
> ---
>  net/ipv6/route.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 1536f49..653b6c7 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -4813,8 +4813,7 @@ static int fib6_nh_mtu_change(struct fib6_nh *nh, void *_arg)
>  		struct inet6_dev *idev = __in6_dev_get(arg->dev);
>  		u32 mtu = f6i->fib6_pmtu;
>  
> -		if (mtu >= arg->mtu ||
> -		    (mtu < arg->mtu && mtu == idev->cnf.mtu6))
> +		if (mtu >= arg->mtu)
>  			fib6_metric_set(f6i, RTAX_MTU, arg->mtu);
>  
>  		spin_lock_bh(&rt6_exception_lock);
> 

The existing logic mirrors what is done for exceptions, see
rt6_mtu_change_route_allowed and commit e9fa1495d738.

It seems right to me to drop the mtu == idev->cnf.mtu6 comparison in
which case the exceptions should do the same.

Added author of e9fa1495d738 in case I am overlooking something.

Test case should be added to tools/testing/selftests/net/pmtu.sh, and
did you run that script with the proposed change?
