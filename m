Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A586CA9D0B
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 10:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732224AbfIEIcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 04:32:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36314 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfIEIcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 04:32:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so1663585wrd.3;
        Thu, 05 Sep 2019 01:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gj2R3r9NNYbhdgbLaHqDj//ho1s/xwwXxZcAR2ovCss=;
        b=VQMAQB/pJH8KCeBzd0DPGyKZzigzXkSt0nKUUsbn5uhglssFidXE1D8uc3p/A+xlQA
         YlcJiGu6FkxEPqRAgGs8bH4mprOxSq9FwCTVoUtpuMsx+KSTisZbaeyFRRE35bA9ClLg
         LATSH9OQtt3/JOFw1VoIHtzzbQIlnxJEcq4qHCVw70EaBaJjhF5t+i0s/+o6CaTbsIE0
         WOuyJsZrYFmPxoiezZFBRZJGK274Ub4zaFSiIXrsm8i8MmuKSPGJ12QZDxJr2SRE33jS
         QOelFgrUcOlfyqGS18sj5sl/fvOGp6NtNlpSg7T9+OrjjC1fO0ZjN0bu2H8m7qIGuyBH
         Xesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gj2R3r9NNYbhdgbLaHqDj//ho1s/xwwXxZcAR2ovCss=;
        b=i9YEd6gQHrHnQK0Qd1L/TFY8uQFvGqM9INNVh1usboZTjPkNKARaDmmbRkB3rVPcdz
         nDVHN4Vm5bax5BlE53D+DiReiBY1tRjcW8eqLgW/aZPilOFTnVaz54KEII7/RoZ4E6Mm
         YyDv1FL1jNEkAiEKI2FsDfV/g0EMEtRP2BK3t5ySGu9bnIFnRELd8mwOOl0bRrz+7VBa
         imvn/5oI5roDZ07aLAqDqoly4kT8H6bk1uzZD2MXiw9x76567kEVzgntqUUHdGcrf20K
         GQMSVeqAu4/PZL2RNBtXefEb0M/JShfUPp9l4Z7zwz/NFjvTAxzf1CvirquZydEYM2DL
         QIzQ==
X-Gm-Message-State: APjAAAWgbSkhF8krD0nq/EH+a7vUusFf8QIXksuVAsQelI3eH0pIiFeK
        cOzxtERXIeHiMU1zwXFKgBsoWB2b
X-Google-Smtp-Source: APXvYqykNnBQp+iBilSuDo0K9RJD9YgUJBErhXCd11xD/5ghRbmyt+hDLpVibs2nWtu76Weaarx/xw==
X-Received: by 2002:adf:8527:: with SMTP id 36mr1602341wrh.206.1567672333034;
        Thu, 05 Sep 2019 01:32:13 -0700 (PDT)
Received: from [192.168.8.147] (238.165.185.81.rev.sfr.net. [81.185.165.238])
        by smtp.gmail.com with ESMTPSA id y3sm7468107wmg.2.2019.09.05.01.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2019 01:32:12 -0700 (PDT)
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
To:     Qian Cai <cai@lca.pw>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw> <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw> <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV> <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV> <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw> <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <165827b5-6783-f4f8-69d6-b088dd97eb45@gmail.com>
Date:   Thu, 5 Sep 2019 10:32:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567629737.5576.87.camel@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/4/19 10:42 PM, Qian Cai wrote:

> To summary, those look to me are all good long-term improvement that would
> reduce the likelihood of this kind of livelock in general especially for other
> unknown allocations that happen while processing softirqs, but it is still up to
> the air if it fixes it 100% in all situations as printk() is going to take more
> time and could deal with console hardware that involve irq_exit() anyway.
> 
> On the other hand, adding __GPF_NOWARN in the build_skb() allocation will fix
> this known NET_TX_SOFTIRQ case which is common when softirqd involved at least
> in short-term. It even have a benefit to reduce the overall warn_alloc() noise
> out there.
> 
> I can resubmit with an update changelog. Does it make any sense?

It does not make sense.

We have thousands other GFP_ATOMIC allocations in the networking stacks.

Soon you will have to send more and more patches adding __GFP_NOWARN once
your workloads/tests can hit all these various points.

It is really time to fix this problem generically, instead of having
to review hundreds of patches.

This was my initial feedback really, nothing really has changed since.

The ability to send a warning with a stack trace, holding the cpu
for many milliseconds should not be decided case by case, otherwise
every call points will decide to opt-out from the harmful warnings.
