Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643CA23E375
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 23:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgHFVSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 17:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgHFVSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 17:18:10 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C94C061574
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 14:18:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y6so38806plt.3
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 14:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ooKAEzNKcpVLps42la/UDAXClrA51RYAYP3t5x1mvQ=;
        b=fH9e/njJ/I5DfhrGOMua7P8Vac6kjThNyuRwXkCJuLtZFgGZ0Euamg1jn63uzxdWxZ
         CDXIBpTWVoWtH/6UpI70BtrOnug9hwjpPvxg99JmLwBAUmZ2zcqUmJ0AWGOZ0HpW8onh
         ljIDtIk5PcI2vNu2dr4/Yq74ivRGPJI/bRhNdd/ME5MUbLxVB48jQJLicVwa8WJYgmQn
         x2Z5AdQhd+EHl4plQ3z2yH9Dzp//RkfnX2OIKnRIa4IAuXEvgL1eOa4UuDbbNoYMv6Np
         BwGgfdaaisSaUl3TIfgKIzjQRa9lvEV7JlNzHimvN/H0KeRYJBxxUkv5A50zlSLwu5qN
         4c1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ooKAEzNKcpVLps42la/UDAXClrA51RYAYP3t5x1mvQ=;
        b=L5Ya+lAEhMGsUn2Igv8S2MJ4I2ECaB7VQq1bnoWK1XJS6rstic+nyVIcHKTGJJB/cB
         TM6LUMQPqk9VESqBJyq18T+Iyj6N3g96w6d3FQrdtn1jbmDccZYTEy+G3tp1ymhgOr3G
         CDs0By0JHw0hrvnqHwVz6UV0SHI4anODXxoXo/3aKWoXwROtPdrgbS3a85vxKV0L9uDQ
         AA0W+Abaeu1SYrM2RYFEOsFy3FTD7Ahmfw6g9w3hXpvhsfM2ZvfHgJsTf25zxGf+B0+h
         yYY63Rtyc5rw+n3KUyI9NTJLdbP700/4GiACARcROhRLA48onFLx73gtK7WZqWgtqw/l
         nE+A==
X-Gm-Message-State: AOAM530Rs4mY6yWQxIs0OhHDTBjBhYU0WdNtKCxOkO2RNlAIa6BGzLLD
        Ti4Og+bNajm+b335WZv1FMM=
X-Google-Smtp-Source: ABdhPJzk9eUwVbX7k3TUvDhQ73hcBxiqywPvYdw1gDo5ShRVT0/wxL4gQRsM2a5h6q+sZlijFuHcIw==
X-Received: by 2002:a17:902:900b:: with SMTP id a11mr9394034plp.315.1596748689856;
        Thu, 06 Aug 2020 14:18:09 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id h15sm5226635pjf.54.2020.08.06.14.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 14:18:09 -0700 (PDT)
Subject: Re: [PATCH v2] net: add support for threaded NAPI polling
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Hillf Danton <hdanton@sina.com>
References: <20200806095558.82780-1-nbd@nbd.name>
 <20200806115511.6774e922@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2ce6de8b-f520-3f09-746a-caf2ecab428a@gmail.com>
 <20200806125708.6492ebfe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e7323b08-14e2-8195-06aa-f08610a5609a@gmail.com>
Date:   Thu, 6 Aug 2020 14:18:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200806125708.6492ebfe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/6/20 12:57 PM, Jakub Kicinski wrote:
> On Thu, 6 Aug 2020 12:25:08 -0700 Eric Dumazet wrote:
>> On 8/6/20 11:55 AM, Jakub Kicinski wrote:
>>> I'm still trying to wrap my head around this.
>>>
>>> Am I understanding correctly that you have one IRQ and multiple NAPI
>>> instances?
>>>
>>> Are we not going to end up with pretty terrible cache locality here if
>>> the scheduler starts to throw rx and tx completions around to random
>>> CPUs?
>>>
>>> I understand that implementing separate kthreads would be more LoC, but
>>> we do have ksoftirqs already... maybe we should make the NAPI ->
>>> ksoftirq mapping more flexible, and improve the logic which decides to
>>> load ksoftirq rather than make $current() pay?
>>>
>>> Sorry for being slow.
>>
>> Issue with ksoftirqd is that
>> - it is bound to a cpu
> 
> Do you envision the scheduler balancing or work stealing being
> advantageous in some configurations?

It seems that softirq stealing too many cycles has been a problem
for process scheduler for a very long time. Maybe dealing with threads
will help it to take decisions instead of having to deal with
interruptions.

> 
> I was guessing that for compute workloads having ksoftirq bound will
> actually make things more predictable/stable.
> 
> For pure routers (where we expect multiple cores to reach 100% just
> doing packet forwarding) as long as there is an API to re-balance NAPIs
> to cores - a simple specialized user space daemon would probably do a
> better job as it can consult packet drop metrics etc.
> 
> Obviously I have no data to back up these claims..
> 
>> - Its nice value is 0, meaning that user threads can sometime compete too much with it.
> 
> True, I thought we could assume user level tuning.
> 
>> - It handles all kinds of softirqs, so messing with it might hurt some other layer.
> 
> Right, I have no data on how much this hurts in practice.
> 
>> Note that the patch is using a dedicate work queue. It is going to be not practical
>> in case you need to handle two different NIC, and want separate pools for each of them.
>>
>> Ideally, having one kthread per queue would be nice, but then there is more plumbing
>> work to let these kthreads being visible in a convenient way (/sys/class/net/ethX/queues/..../kthread)
> 
> Is context switching cost negligible?

Context switch to kernel thread is cheap (compared to arbitrary context switch,
from process A to process B since), no MMU games need to be played.

