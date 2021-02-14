Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A8831B028
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 11:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhBNK5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 05:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhBNK5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 05:57:13 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD47C061756
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 02:56:33 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id w18so2444984pfu.9
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 02:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f8dnL450V2PSPis5FrggYqi8yNhSum9yhG+6vwT8CDc=;
        b=i0f2ZnN9YskUWeeM4oA+JTo3ieGZLlhk4NX9/UaVzzAWN31FJlSrLGSoazCcDihAsj
         FKF8Q7x77lf34iGTKsWXB3RI/H9hOD/2gPYUOwB7PgLhwlqy8RONbySmFgO1yCBkMvZW
         0b4+z/yuAL8hE0FTcPFnlaAhCrf/ltdkbKIOjEDIyO7R2of3brKncoGBOVKG+gLJCyZK
         mblATmu8VCihSzgakjo9wRCDB6DAcx/zPtVH5X6gYrVqKWe9ITcyDlJjpBSzWP/X1LSE
         +SHIgTMZkChdQ+HRaLqQv3yGA0J3NOzun57vsG2bAS17kSkAJLRSAmEjOlmxlZB8UyLy
         nSUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f8dnL450V2PSPis5FrggYqi8yNhSum9yhG+6vwT8CDc=;
        b=lJbKXa3UlQVdwpTNFAiuwwMRXvIE4JOtJz9UMePjjO38qSQqkhT6VIwGsnheb+dYTc
         520zZIvCLNyKsFEDaUL7S/xixJcgobsUN1gpJyJCk6Nc4fzTC4kfJE2yjaWsJ44ODMjx
         7peyMdRO2z1mzhgGuhC/lq9vG/AnXrrlk/annsVSsMrg3Qxv7MXtGdZ77MXK4e7kxVF1
         UoUIYguHg4uOku11nYBpcdYVpw2RxNv12D97cAmu3FCoatNeYgfLRDBj1CWaUozMGDl9
         3OWH5k1zV0nTedcPTRPM1cOyMypbZoDR0Gzsg5h0bD0z0nTVBi+9wHYnHhFlVqdtezXE
         AaSw==
X-Gm-Message-State: AOAM530mQbwlqevU7KBpLlF/YfhLAXE1F7/VYpn6C6H3zucXnzI1gofx
        xSH05LNpBZJ57zazN8IRMhQ=
X-Google-Smtp-Source: ABdhPJy2rXipAKPiEvJDK4l+vAa67uSbZYIrl830COK/ok/lSQZkDC7m8OmPKwKJ9jhd8G9UJVNi1w==
X-Received: by 2002:a05:6a00:22d1:b029:1b4:9bb5:724c with SMTP id f17-20020a056a0022d1b02901b49bb5724cmr11073769pfj.63.1613300192517;
        Sun, 14 Feb 2021 02:56:32 -0800 (PST)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id dw23sm13078166pjb.3.2021.02.14.02.56.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 02:56:32 -0800 (PST)
Subject: Re: [PATCH net-next v2 1/7] mld: convert from timer to delayed work
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        Marek Lindner <mareklindner@neomailbox.ch>,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, dsahern@kernel.org
References: <20210213175102.28227-1-ap420073@gmail.com>
 <CAM_iQpXLMk+4VuHr8WyLE1fxNV5hsN7JvA2PoDOmnZ4beJOH7Q@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <3cbe0945-4f98-961c-29cc-5b863c99e2df@gmail.com>
Date:   Sun, 14 Feb 2021 19:56:27 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXLMk+4VuHr8WyLE1fxNV5hsN7JvA2PoDOmnZ4beJOH7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21. 2. 14. 오전 4:07, Cong Wang wrote:
 > On Sat, Feb 13, 2021 at 9:51 AM Taehee Yoo <ap420073@gmail.com> wrote:
 >> -static void mld_dad_start_timer(struct inet6_dev *idev, unsigned 
long delay)
 >> +static void mld_dad_start_work(struct inet6_dev *idev, unsigned 
long delay)
 >>   {
 >>          unsigned long tv = prandom_u32() % delay;
 >>
 >> -       if (!mod_timer(&idev->mc_dad_timer, jiffies+tv+2))
 >> +       if (!mod_delayed_work(mld_wq, &idev->mc_dad_work, 
msecs_to_jiffies(tv + 2)))
 >
 > IIUC, before this patch 'delay' is in jiffies, after this patch it is 
in msecs?
 >

Ah, I understand, It's my mistake.
I didn't change the behavior of 'delay' in this patchset.
So, 'delay' is still in jiffies, not msecs.
Therefore, msecs_to_jiffies() should not be used in this patchset.
I will send a v3 patch, which doesn't use msecs_to_jiffies().
Thanks!

By the way, I think the 'delay' is from the 
unsolicited_report_interval() and it just return value of 
idev->cnf.mldv{1 | 2}_unsolicited_report_interval.
I think this value is msecs, not jiffies.
So, It should be converted to use msecs_to_jiffies(), I think.
How do you think about it?

 > [...]
 >
 >> -static void mld_dad_timer_expire(struct timer_list *t)
 >> +static void mld_dad_work(struct work_struct *work)
 >>   {
 >> -       struct inet6_dev *idev = from_timer(idev, t, mc_dad_timer);
 >> +       struct inet6_dev *idev = container_of(to_delayed_work(work),
 >> +                                             struct inet6_dev,
 >> +                                             mc_dad_work);
 >>
 >> +       rtnl_lock();
 >
 > Any reason why we need RTNL after converting the timer to
 > delayed work?
 >

For the moment, RTNL is not needed.
But the Resources, which are used by delayed_work will be protected by 
RTNL instead of other locks.
So, It just pre-adds RTNL and the following patches will delete other locks.

 > Thanks.
 >
