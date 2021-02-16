Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E81531CC57
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 15:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhBPOrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 09:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhBPOro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 09:47:44 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3029CC061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 06:47:04 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 189so6263706pfy.6
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 06:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SwHn93yehpShrbalJ/4lL2GKbFHsZcvdS9Bf5KUzxhc=;
        b=mNtv11bLK7YGvJ/Ay5F0oTOPUUlgh64/oOv+W+xwycQ0YbVY8WbV7N/OWMwdIx+Usz
         pZYPOBjt8yn30J5kT6r1Mvx+gs351kT++KnErJF5ShSQX6oQ6ECQ4rnfoLuXZjha02yp
         f57Q91anBSYp358K4vFJ9b6hQshSISnglrYs45cCR6yN51va7eiZkllTNZV02IU4uJC0
         tfaxAfgw8/vFZzDq5/qeejxAdmCHSpnMei1waNYUVXhxM6YqjA29AhL7QVCL+CBuB/OH
         TUSmUI815Dj4dYKhh5VUupfEpp0HVJK50xs98LcBt5iM6RoIJlWaLuu8avSJ2/ROnst4
         zRyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SwHn93yehpShrbalJ/4lL2GKbFHsZcvdS9Bf5KUzxhc=;
        b=hvBZY2X6qBS3lWmc8OtEDANuJorSgcBrvZNppussy79eHDCyj2y/g1iUSLernjsfmU
         U+WfsjaOJYJbPdn8zOFxPY0amft4TfKYSIJCJiNVPIMCg5r/xn1UimYVY5+w+78ixOmA
         KXj/QsIc1YiYMfyhRfzZ6U81HlnyVOYDryCtuDYe+tX9/HquhHjGby/Bx3mx3oA1awTy
         +pzOa9tyqqrl/AAa81dtFfqzYY300pmh1dVuzxMZX+KGm/hXg43C2ReJgGj5l68ysQHg
         2HJift/TtWiLBhaKnxVaFlNhxZKFtRx2fGnLCkXdMaFftI2w1FKtdwJQFJBxosKxJaOJ
         62fg==
X-Gm-Message-State: AOAM531ZCaus2w0U7XDBDiCY9QJllwUrglnATv7S46EO6sW/KyHdhtXb
        0MCEBgoxG1aAIbGHHMDGZN8=
X-Google-Smtp-Source: ABdhPJx6MhtEvHP/fU97vq16VcNFe2GCyvPsvSIMYnhuPbBJrneqeYU/QfrWRxI2hfZ5NgYoaj2BdQ==
X-Received: by 2002:aa7:9356:0:b029:1dd:644a:d904 with SMTP id 22-20020aa793560000b02901dd644ad904mr19868243pfn.18.1613486823665;
        Tue, 16 Feb 2021 06:47:03 -0800 (PST)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id nk3sm3141209pjb.12.2021.02.16.06.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Feb 2021 06:47:03 -0800 (PST)
Subject: Re: [PATCH net-next v2 1/7] mld: convert from timer to delayed work
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        Marek Lindner <mareklindner@neomailbox.ch>,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, ap420073@gmail.com
References: <20210213175102.28227-1-ap420073@gmail.com>
 <CAM_iQpXLMk+4VuHr8WyLE1fxNV5hsN7JvA2PoDOmnZ4beJOH7Q@mail.gmail.com>
 <3cbe0945-4f98-961c-29cc-5b863c99e2df@gmail.com>
 <CAM_iQpUVG5+EbMbMXWJ=tb6Br+s+e2-tHChNvGgxFH7XSwEXHA@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <beb4fa65-a99c-f43c-0b91-1c8d62c787dd@gmail.com>
Date:   Tue, 16 Feb 2021 23:46:58 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUVG5+EbMbMXWJ=tb6Br+s+e2-tHChNvGgxFH7XSwEXHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[...]
 >> By the way, I think the 'delay' is from the
 >> unsolicited_report_interval() and it just return value of
 >> idev->cnf.mldv{1 | 2}_unsolicited_report_interval.
 >> I think this value is msecs, not jiffies.
 >> So, It should be converted to use msecs_to_jiffies(), I think.
 >> How do you think about it?
 >
 > Hmm? I think it is in jiffies:
 >
 >          .mldv1_unsolicited_report_interval = 10 * HZ,
 >          .mldv2_unsolicited_report_interval = HZ,
 >

Ah, yes, you're right!
Thanks,

 >
 >>
 >>   > [...]
 >>   >
 >>   >> -static void mld_dad_timer_expire(struct timer_list *t)
 >>   >> +static void mld_dad_work(struct work_struct *work)
 >>   >>   {
 >>   >> -       struct inet6_dev *idev = from_timer(idev, t, mc_dad_timer);
 >>   >> +       struct inet6_dev *idev = 
container_of(to_delayed_work(work),
 >>   >> +                                             struct inet6_dev,
 >>   >> +                                             mc_dad_work);
 >>   >>
 >>   >> +       rtnl_lock();
 >>   >
 >>   > Any reason why we need RTNL after converting the timer to
 >>   > delayed work?
 >>   >
 >>
 >> For the moment, RTNL is not needed.
 >> But the Resources, which are used by delayed_work will be protected by
 >> RTNL instead of other locks.
 >> So, It just pre-adds RTNL and the following patches will delete 
other locks.
 >
 > Sounds like this change does not belong to this patch. ;) If so,
 > please move it to where ever more appropriate.
 >

Yes, I will do that,
I will rearrange it then I will send a v3 patch.
Thank you so much for your review!
