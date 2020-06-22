Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4679A204401
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731141AbgFVWqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731022AbgFVWqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 18:46:37 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F64DC061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 15:46:37 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g1so14937689edv.6
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 15:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UkY2JjVHbG10lQVAW9FvSrLE0+XRlsP4+RX8iZH+iqw=;
        b=MJ4S03+zQy7IKbfnJvCdLz1oGG+nIVmJlmjrLv3/mbB6QRsskRulbcsiPs1EOW56+j
         MbTpYJD1NoNuGLx0mSwZ3PaBbC2WLQeBhAQks60EzF7zeVtzYD2CeRz47O+xHGrxK607
         fN/ayjRKDV+/zjdl8LUG5a3ekoa0kKB+Byw5qixeqTmCdIDtXD6ozx3aLXh5K6WHilVV
         CQNHtLYH4kaBt2ZQQ+onuxGTjswqcnuEgImhkqm3QWZmyxnz0hIolKPhTBIXcoG+fN5Q
         iOonYZKOR5Ue0RA5vwDRMrwF9sY+nNlg9hohw/gho4lbuTTcvVR0ALVkwKymDlXaoE1h
         uW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UkY2JjVHbG10lQVAW9FvSrLE0+XRlsP4+RX8iZH+iqw=;
        b=CxQTNQEJo0M/SgVymisleP7TKYNlGycBSRbL+jH/UFuEtr2LY/ZjcGS78K7n3/BXK7
         Frg7i7BF8JC0lPfZ/vuiO4jZwvC/c0GEgDP4t62dyIXfM8iNmYN1K5kJbKhnWlZturqI
         Io+fSatCjOXUDSJuACHJABLQf+Py8m2sYj32yavhvgEJA1Jfpp3icwV7pcFZZOSDLYmx
         COKI2BfK/r1pP8qp2PikZ5rrNLN/+UlPP1rK0+zKxlFls3A3JwgbtRfghkAu/JptjzmN
         ai7q0esUVX7amnvlN04lkUQQZ6ghv4qsRsMS2/222m5wJC/w8ILxJmHZLXLKsd9hnzQv
         H0bA==
X-Gm-Message-State: AOAM5304YOGIT8/Vapk5CC6ZY9sy6oRyfuJZFiRS/6E9yiUXr+tBNjs9
        c3LPQ9CHn6SIehumGuZT/18=
X-Google-Smtp-Source: ABdhPJy5o1PYMmAb5IqRwIjIkXJegNFPhkYw7uFn5J4pHtHT7sb8FrnnUs3YSJG4lJ7R/doupN19tQ==
X-Received: by 2002:aa7:d3cd:: with SMTP id o13mr5164330edr.176.1592865996103;
        Mon, 22 Jun 2020 15:46:36 -0700 (PDT)
Received: from ?IPv6:2a02:8071:21c1:4200:5089:20ae:4811:8fc? ([2a02:8071:21c1:4200:5089:20ae:4811:8fc])
        by smtp.gmail.com with ESMTPSA id p13sm13416403edx.69.2020.06.22.15.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 15:46:35 -0700 (PDT)
Subject: Re: [PATCH] IPv6: Fix CPU contention on FIB6 GC
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
References: <20200622205355.GA869719@tws>
 <20200622214449.gyfn33ickesj2j2t@lion.mk-sys.cz>
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Message-ID: <3588d0fc-5c6b-b62a-f137-24abcf660d5f@gmail.com>
Date:   Tue, 23 Jun 2020 00:46:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200622214449.gyfn33ickesj2j2t@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.06.20 23:44, Michal Kubecek wrote:
> On Mon, Jun 22, 2020 at 10:53:55PM +0200, Oliver Herms wrote:
>> When fib6_run_gc is called with parameter force=true the spinlock in
>> /net/ipv6/ip6_fib.c:2310 can lock all CPUs in softirq when
>> net.ipv6.route.max_size is exceeded (seen this multiple times).
>> One sotirq/CPU get's the lock. All others spin to get it. It takes
>> substantial time until all are done. Effectively it's a DOS vector.
>>
>> As the splinlock is only enforcing that there is at most one GC running
>> at a time, it should IMHO be safe to use force=false here resulting
>> in spin_trylock_bh instead of spin_lock_bh, thus avoiding the lock
>> contention.
>>
>> Finding a locked spinlock means some GC is going on already so it is
>> save to just skip another execution of the GC.
>>
>> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> 
> I wonder if it wouldn't suffice to revert commit 14956643550f ("ipv6:
> slight optimization in ip6_dst_gc") as the reasoning in its commit
> message seems wrong: we do not always skip fib6_run_gc() when
> entries <= rt_max_size, we do so only if the time since last garbage
> collector run is shorter than rt_min_interval.
> 
> Then you would prevent the "thundering herd" effect when only gc_thresh
> is exceeded but not max_size, as commit 2ac3ac8f86f2 ("ipv6: prevent
> fib6_run_gc() contention") intended, but would still preserve enforced
> garbage collect when max_size is exceeded.
> 
> Michal
> 

Hi Michal,

I did some testing with packets causing 17k IPv6 route cache entries per 
second. With "entries > rt_max_size" all CPUs of the system get stuck 
waiting for the spinlock. With "false" CPU load stays at <<10% on every single
CPU core (tested on an Atom C2750). This makes sense as "entries > rt_max_size"
would not prevent multiple CPUs from trying to get the lock.

So reverting 14956643550f is not enough.

Kind Regards
Oliver
