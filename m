Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4808D2E0D70
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 17:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgLVQfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 11:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727746AbgLVQfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 11:35:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6481C0613D6;
        Tue, 22 Dec 2020 08:34:29 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c7so13483793edv.6;
        Tue, 22 Dec 2020 08:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=03N2TNkyaRVCVzSQPEc9RXd564FvnXzr8bjxSTqeeZ8=;
        b=gkaAK/UKEHq9T0Ig/KMCeqGDWvHff7PTxcwbJjAzUkizNvpQ7TuMKLxBDha8EI5B+D
         lkE4jkxQN/sdV/BWyeDLaP2EapuDt1tFA7Hbb6/ztx7sOHKF5YKhS3xeHZ2RSK6Hk/fp
         wpd2wQwWky+vnwFEJyawP5kF3RdUmi96pr96F8gHBGJqQZqvj2808gKGLZguuud06/In
         xa0mXVfM+MnVG006DbaKBooDDD3KTQTt9/T83L0bD378SGx8/BNmoVGaqxSa91fB/Tt9
         49NwZGXVSR/aehAI9qYiSf+3KsL38Ufp8VbtpeABaFKrf/C4fBH7UwpKVbZYKlrJoMFP
         jrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=03N2TNkyaRVCVzSQPEc9RXd564FvnXzr8bjxSTqeeZ8=;
        b=QGStqfr6XErwyuFK0Y4obLG+GyA4KwaJl0ykJNUm9vCOZCTEUY21uGYhPTSfzAJvS6
         D/TGZlYVivL8nukfXw2eVFcGPgPOWe1idL1Vyk626rxlzZp9G7lG97skM+fBPleaLUIK
         7nPXrHXmQxia0bUQxbuItIt4PnBFOdSWCsQy3ObMhtqvpO8f+6x816Y/gkr4p5Bzcg4D
         dsAWG9KY2KadM5aYieDVu5LWRTIaRcWxH2TnBQ2V9IJUieffd649vi+sU+9yMFR16oqk
         m5bNyMYFQcs5XgyliCkmjzqjfzkDwN27jt8xOT+vNYDaNs4zf+sZGJ1LcYakZ5iK1It5
         G1nQ==
X-Gm-Message-State: AOAM530yacXp6U8BtRO/+cMT5wSR6RHmMK+npGtL6cEFEj8u2kyF2TIt
        0yAjSOdsNWZ0onvJGqbFqAg9yuQDyJFdANnpTJFxiQ==
X-Google-Smtp-Source: ABdhPJyzgfQlujyQ7/qlsimPObTeXox3aUCbVOvAnuabcWDWAdQB6TMaMWXCpqVIXHiO6zJF2CGwow==
X-Received: by 2002:a50:9dc9:: with SMTP id l9mr20953756edk.377.1608654867659;
        Tue, 22 Dec 2020 08:34:27 -0800 (PST)
Received: from [192.168.1.101] ([37.164.29.98])
        by smtp.gmail.com with ESMTPSA id mb22sm10520154ejb.35.2020.12.22.08.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 08:34:27 -0800 (PST)
Subject: Re: [PATCH v3] net: neighbor: fix a crash caused by mod zero
To:     weichenchen <weichen.chen@linux.alibaba.com>
Cc:     splendidsky.cwc@alibaba-inc.com, yanxu.zw@alibaba-inc.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@kernel.org>, Jeff Dike <jdike@akamai.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201221113240.2ae38a77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201222123838.12951-1-weichen.chen@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dbc6cd85-c58b-add2-5801-06e8e94b7d6b@gmail.com>
Date:   Tue, 22 Dec 2020 17:34:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201222123838.12951-1-weichen.chen@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/22/20 1:38 PM, weichenchen wrote:
> pneigh_enqueue() tries to obtain a random delay by mod
> NEIGH_VAR(p, PROXY_DELAY). However, NEIGH_VAR(p, PROXY_DELAY)
> migth be zero at that point because someone could write zero
> to /proc/sys/net/ipv4/neigh/[device]/proxy_delay after the
> callers check it.
> 
> This patch makes pneigh_enqueue() get a delay time passed in
> by the callers and the callers guarantee it is not zero.
> 
> Signed-off-by: weichenchen <weichen.chen@linux.alibaba.com>
> ---
> V3:
>     - Callers need to pass the delay time to pneigh_enqueue()
>       now and they should guarantee it is not zero.
>     - Use READ_ONCE() to read NEIGH_VAR(p, PROXY_DELAY) in both
>       of the existing callers of pneigh_enqueue() and then pass
>       it to pneigh_enqueue().
> V2:
>     - Use READ_ONCE() to prevent the complier from re-reading
>       NEIGH_VAR(p, PROXY_DELAY).
>     - Give a hint to the complier that delay <= 0 is unlikely
>       to happen.
> ---
>  include/net/neighbour.h | 2 +-
>  net/core/neighbour.c    | 5 ++---
>  net/ipv4/arp.c          | 8 +++++---
>  net/ipv6/ndisc.c        | 6 +++---
>  4 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index 22ced1381ede..f7564dc5304d 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -352,7 +352,7 @@ struct net *neigh_parms_net(const struct neigh_parms *parms)
>  unsigned long neigh_rand_reach_time(unsigned long base);
>  
>  void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
> -		    struct sk_buff *skb);
> +		    struct sk_buff *skb, int delay);
>  struct pneigh_entry *pneigh_lookup(struct neigh_table *tbl, struct net *net,
>  				   const void *key, struct net_device *dev,
>  				   int creat);
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 9500d28a43b0..b440f966d109 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1567,12 +1567,11 @@ static void neigh_proxy_process(struct timer_list *t)
>  }
>  
>  void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
> -		    struct sk_buff *skb)
> +		    struct sk_buff *skb, int delay)
>  {
>  	unsigned long now = jiffies;
>  
> -	unsigned long sched_next = now + (prandom_u32() %
> -					  NEIGH_VAR(p, PROXY_DELAY));
> +	unsigned long sched_next = now + (prandom_u32() % delay);
>  
>  	if (tbl->proxy_queue.qlen > NEIGH_VAR(p, PROXY_QLEN)) {
>  		kfree_skb(skb);

This seems rather complex, what about not using a divide in the first place ? :

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9500d28a43b0e1a390382912b6fb59db935e727b..745bc89acc87c2a4802fb6f301c11edd2f0096da 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1569,10 +1569,7 @@ static void neigh_proxy_process(struct timer_list *t)
 void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
                    struct sk_buff *skb)
 {
-       unsigned long now = jiffies;
-
-       unsigned long sched_next = now + (prandom_u32() %
-                                         NEIGH_VAR(p, PROXY_DELAY));
+       unsigned long sched_next = jiffies + prandom_u32_max(NEIGH_VAR(p, PROXY_DELAY));
 
        if (tbl->proxy_queue.qlen > NEIGH_VAR(p, PROXY_QLEN)) {
                kfree_skb(skb);

