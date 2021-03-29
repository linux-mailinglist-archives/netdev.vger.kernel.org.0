Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D8934D8AA
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhC2T4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbhC2T4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 15:56:37 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E73C061574;
        Mon, 29 Mar 2021 12:56:36 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso9096670wmi.3;
        Mon, 29 Mar 2021 12:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MQBrb4YVkXVVUdNQVIYjRBD1ELh8gLe+l+iTh/6ZeHE=;
        b=apoBR01O0o2kiwhvAkciBfD7GZFv1B/yax9UQcmq8NLg7THJXp9CqywQmRY0GATMB8
         2pN66eybFsOGXRE5+Au+grXwApxl8fjIJSMtONFCmGjAf1Nv2+ki6LLABqPWZzgiSET6
         bTllyR8Zc81quWkKoo2E4zphFgY1NWZfD/IERlV6jNEbWU7yKf6LLxkzYYRKWM+oRmGw
         vaalZARYxt85174gBzFKUBe0gvnQcoN+roAFMsPVbON0q6eoAie9Q//Zgr+xjLXNHadu
         DVH7vezu4UgnyXOUQhwaJQ3r6M5xMFPrvkzIc7WTnSdpx6IshSgwMZBTmfzg24F2pwot
         Zk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MQBrb4YVkXVVUdNQVIYjRBD1ELh8gLe+l+iTh/6ZeHE=;
        b=qOSlKQMvfiMbv5mOvc9N+W0r+mSMdqYzXAQy+mTJ6c+kSUl8HVn3zN1j1dDUAunGnN
         PHNSUp12/W60O7vhW9g1d7Q/VyJqvkg7RQZVhcrkqnploycmj9oA5qD1Nkgv/KEYQhRf
         NU4pICGUHXLBV9HJP/Q4TdgWao2y4Id4wDx6cPOswcBM0LPDYW7CTR8IKniW2QqhpZWB
         ZkTKzSk36FNBE0UwVw5jUDDUMfQQF2URi1cLc5PSnqc2hNzr7Iq5aGYc/0hcBv3VMuIP
         tSiFXfxLbJ8iYPZEsxcOQzCws5zGLbBXj31oXghRunJbUYPYUKOq0s9IbGsJjj5Xa4/j
         8bDg==
X-Gm-Message-State: AOAM533Utk9u/8EQpYjoUPR8KFGlOTgpG+M0oMg1lls1MStT9Rcked2s
        sDaiHVZOYw7VY2WwAOe/9Xw=
X-Google-Smtp-Source: ABdhPJzaPyymGOXg3cichgFoBPMx6tnYRHhCJYXcLD4ZgPv84qLD+ONtlhrSVvSSIa0vQXYxzmbxjw==
X-Received: by 2002:a1c:3d8a:: with SMTP id k132mr590836wma.71.1617047795554;
        Mon, 29 Mar 2021 12:56:35 -0700 (PDT)
Received: from [192.168.1.101] ([37.173.175.207])
        by smtp.gmail.com with ESMTPSA id f2sm457550wmp.20.2021.03.29.12.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 12:56:35 -0700 (PDT)
Subject: Re: [PATCH net-next v3 5/7] mld: convert ifmcaddr6 to RCU
To:     Taehee Yoo <ap420073@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-s390@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
References: <20210325161657.10517-1-ap420073@gmail.com>
 <20210325161657.10517-6-ap420073@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6262890a-7789-e3dd-aa04-58e5e06499dc@gmail.com>
Date:   Mon, 29 Mar 2021 21:56:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325161657.10517-6-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/21 5:16 PM, Taehee Yoo wrote:
> The ifmcaddr6 has been protected by inet6_dev->lock(rwlock) so that
> the critical section is atomic context. In order to switch this context,
> changing locking is needed. The ifmcaddr6 actually already protected by
> RTNL So if it's converted to use RCU, its control path context can be
> switched to sleepable.
>

I do not really understand the changelog.

You wanted to convert from RCU to RTNL, right ?

Also :

> @@ -571,13 +573,9 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
>  	if (!ipv6_addr_is_multicast(group))
>  		return -EINVAL;
>  
> -	rcu_read_lock();
> -	idev = ip6_mc_find_dev_rcu(net, group, gsf->gf_interface);
> -
> -	if (!idev) {
> -		rcu_read_unlock();
> +	idev = ip6_mc_find_dev_rtnl(net, group, gsf->gf_interface);
> +	if (!idev)
>  		return -ENODEV;
> -	}
>  

I do not see RTNL being acquired before entering ip6_mc_msfget()


