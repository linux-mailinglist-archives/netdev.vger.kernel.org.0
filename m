Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AF223E214
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 21:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgHFTZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 15:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFTZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 15:25:11 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53777C061574
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 12:25:11 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id s26so25640897pfm.4
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 12:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=To2MW/ZLzkU5qbwRidMORRkwauMA9S2eSF34IO8XfIk=;
        b=Q0HXgoRXJGUmfYVW4VPIZC7zueuBK3CwLWZv5DnQbyHUAeDt157XHOzbY/mfy0/sBn
         DjBhReDTLe+C51Eut7QErxz75vEdHXQn2q0bCpJN8UKJKzGjBiO1mR4SZ/51ut85Wcex
         tAnZj3ruYY5xokuGlHlHCoGCYk90tmMbSj0YxMVRkYHBUc5VuQsucskrLviNp9Vk1+Yl
         i3RSJfYbDd8DYRGgmBpzygQsgiQKGdkk4tjtdAeN3wu+f2Z8PhgMIZQi75DVWobldZ2o
         /h9rSLaTi6jiVLIfvmd13hsRW+pMfHTouKJWiFDRmRkU3lVdISl3SNXphscjSPFnG99z
         LL7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=To2MW/ZLzkU5qbwRidMORRkwauMA9S2eSF34IO8XfIk=;
        b=Rrz9YmYrRxEqNK9K95xXdGxR9K8deaV+ufhExDlOlb6Ne2T4Nf/NaC+lIX3NXkVcBM
         S0TWqqlGtY9Xwiwh8vWh+oPLOFJmX5bN7hkqkp5b4mZuxHyD0s25l+bGJ4wgwPxsl2Mq
         fxPMJRePmT+mnpJsKPHUZUIrth111UZca/v3n5yy+307q5t8TRzuSa0WgjJnc8bHDNnE
         hoBv0nSU/jCEJSx/T9cF9+49mNCqv7Et6io1/z1yO+Y6IVw+igy6AuzIBZozT/QvfPTb
         AyX5SEUN2JVj7qdGb2zXnMeyRlcKZPssNL9ZqkMSZLau4Tyy619yMtW7s0H/ncNnm/MB
         euuA==
X-Gm-Message-State: AOAM533miFawjNuZi8v372Ms+gcLHKdJxnuqf2iF/BZn+AoB1llU7mSr
        TNCpKVRN2WO3IAGcOpHXhy5GGNQ4
X-Google-Smtp-Source: ABdhPJznxYh9papXrUe5QJOB4+o1Ng1icOyDt/TpcTcKWboMy+zplYhXuhWRZpvah7bUNxsWG+cjmQ==
X-Received: by 2002:a63:7c9:: with SMTP id 192mr1772432pgh.181.1596741910846;
        Thu, 06 Aug 2020 12:25:10 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id a15sm8522227pfo.185.2020.08.06.12.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 12:25:09 -0700 (PDT)
Subject: Re: [PATCH v2] net: add support for threaded NAPI polling
To:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Hillf Danton <hdanton@sina.com>
References: <20200806095558.82780-1-nbd@nbd.name>
 <20200806115511.6774e922@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2ce6de8b-f520-3f09-746a-caf2ecab428a@gmail.com>
Date:   Thu, 6 Aug 2020 12:25:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200806115511.6774e922@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/6/20 11:55 AM, Jakub Kicinski wrote:
> On Thu,  6 Aug 2020 11:55:58 +0200 Felix Fietkau wrote:
>> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
>> poll function does not perform well. Since NAPI poll is bound to the CPU it
>> was scheduled from, we can easily end up with a few very busy CPUs spending
>> most of their time in softirq/ksoftirqd and some idle ones.
>>
>> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
>> same except for using netif_threaded_napi_add instead of netif_napi_add.
>>
>> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
>> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
>> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
>> thread.
>>
>> With threaded NAPI, throughput seems stable and consistent (and higher than
>> the best results I got without it).
> 
> I'm still trying to wrap my head around this.
> 
> Am I understanding correctly that you have one IRQ and multiple NAPI
> instances?
> 
> Are we not going to end up with pretty terrible cache locality here if
> the scheduler starts to throw rx and tx completions around to random
> CPUs?
> 
> I understand that implementing separate kthreads would be more LoC, but
> we do have ksoftirqs already... maybe we should make the NAPI ->
> ksoftirq mapping more flexible, and improve the logic which decides to
> load ksoftirq rather than make $current() pay?
> 
> Sorry for being slow.
> 


Issue with ksoftirqd is that
- it is bound to a cpu
- Its nice value is 0, meaning that user threads can sometime compete too much with it.
- It handles all kinds of softirqs, so messing with it might hurt some other layer.

Note that the patch is using a dedicate work queue. It is going to be not practical
in case you need to handle two different NIC, and want separate pools for each of them.

Ideally, having one kthread per queue would be nice, but then there is more plumbing
work to let these kthreads being visible in a convenient way (/sys/class/net/ethX/queues/..../kthread)

