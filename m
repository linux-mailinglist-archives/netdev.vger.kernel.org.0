Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401E32EF808
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 20:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbhAHTWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 14:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbhAHTWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 14:22:21 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51416C061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 11:21:41 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id v3so6151488plz.13
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 11:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=dBC1YMdtvT3Z9+9jU03+XCfqPLlCOumqVm97SHmv0dk=;
        b=cYAu0m7MXxQty+Qy1nnRae1TJSyA0AlBMPng2O4QVqd6HnoWiX37FcJKIFG+JJcTuG
         b0fKYHfLsM/1TCMLnNfi6Fq7Vq3P05FwYYmdZZ3VtxYn4IlxQ84ddv0JhAlGiaBIbkDu
         9hx9ywJiCrjFRC5lrnaWUdzdqNV821dNkuYmA5ZxvEhBaJlP6rf9uYWsbZ2FxjR6hNYE
         qoTSUD5y1v4uB37cZMaM5h5X/5xIItVTb8D2AcUT4/s2ETxtx6VflZvjPVh3FB1fqkms
         N0iI0nKZMRWG5xJQbmDmJD8eyekLUXYo1LcprsihIJ7yl+WQkC3OkqRNwX7TU6gKJdJe
         3YNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dBC1YMdtvT3Z9+9jU03+XCfqPLlCOumqVm97SHmv0dk=;
        b=QO2fuFSvnwZXAYFrb8d1Dd3XQfxFg8dl1N/HINBeUmQZFMnMqKdZahc6SB2GQBV6qd
         2g7ygZKdDNL/O7dIuJXaRnicenktsgziFXwpEp8RZFtOeB+GZGNNmt3kYa7U6m9pherF
         PUBpVDCAxFyBXPg8nMFhk5NiXOzJ4xkww58d/owBpVMYngRpC6I2i4BwNALQQty0Ce3C
         nsGUhWKxJNUfQPvUNFEMI+7TLKTkJyYoVQ1dvaoUsoP0Bpt38kVQX8DDvc9pQ7QJUSM1
         7+pumoBL5kTvhXPS9nEX8VW2YBZ4hkTbuRLSvJHFtZYFCKXNg9GBkmQCUtdUGKk8MVbE
         W2Uw==
X-Gm-Message-State: AOAM5307luSpYplLkROoUxba+q76IAV1tzmYP/yKAjB/gyWb1BLz8doT
        YMn/HI4DWVgGsIhBk9mNjWwNYw==
X-Google-Smtp-Source: ABdhPJzvPRqg2mccrMstcg71t5qx7TlwTTmeXopdlTfvbENK3Vw9oqBtQM1y4iovJECygjC+XRnAlA==
X-Received: by 2002:a17:90a:b395:: with SMTP id e21mr5260844pjr.197.1610133700858;
        Fri, 08 Jan 2021 11:21:40 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id j20sm9379186pfd.106.2021.01.08.11.21.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 11:21:40 -0800 (PST)
Subject: Re: [PATCH net-next v1 1/2] net: core: count drops from GRO
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
References: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
 <20210106215539.2103688-2-jesse.brandeburg@intel.com>
 <1e4ee1cf-c2b7-8ba3-7cb1-5c5cb3ff1e84@pensando.io>
 <20210108102630.00004202@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <c11bb25a-f73d-3ae9-b1fd-7eb96bc79cc7@pensando.io>
Date:   Fri, 8 Jan 2021 11:21:38 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108102630.00004202@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/21 10:26 AM, Jesse Brandeburg wrote:
> Shannon Nelson wrote:
>
>> On 1/6/21 1:55 PM, Jesse Brandeburg wrote:
>>> When drivers call the various receive upcalls to receive an skb
>>> to the stack, sometimes that stack can drop the packet. The good
>>> news is that the return code is given to all the drivers of
>>> NET_RX_DROP or GRO_DROP. The bad news is that no drivers except
>>> the one "ice" driver that I changed, check the stat and increment
>> If the stack is dropping the packet, isn't it up to the stack to track
>> that, perhaps with something that shows up in netstat -s?  We don't
>> really want to make the driver responsible for any drops that happen
>> above its head, do we?
> I totally agree!
>
> In patch 2/2 I revert the driver-specific changes I had made in an
> earlier patch, and this patch *was* my effort to make the stack show the
> drops.
>
> Maybe I wasn't clear. I'm seeing packets disappear during TCP
> workloads, and this GRO_DROP code was the source of the drops (I see it
> returning infrequently but regularly)
>
> The driver processes the packet but the stack never sees it, and there
> were no drop counters anywhere tracking it.
>

My point is that the patch increments a netdev counter, which to my mind 
immediately implicates the driver and hardware, rather than the stack.  
As a driver maintainer, I don't want to be chasing driver packet drop 
reports that are a stack problem.  I'd rather see a new counter in 
netstat -s that reflects the stack decision and can better imply what 
went wrong.  I don't have a good suggestion for a counter name at the 
moment.

I guess part of the issue is that this is right on the boundary of 
driver-stack.  But if we follow Eric's suggestions, maybe the problem 
magically goes away :-) .

sln

