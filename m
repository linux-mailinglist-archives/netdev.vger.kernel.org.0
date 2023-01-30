Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13BF6816DE
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbjA3QuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237430AbjA3QuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:50:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCABC12870
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675097374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RUe1+at8qNUL3tbG/zwrRwNfw83JyE6i/0LXaPJqQZw=;
        b=aztKYQmrpfVlk1d6hW7MqNBYM6wRxJyBrDbsgudEDa3l3s3kIzmKaYUPyE3Y3pFeEM53hl
        f1mvcTVdZUJdU8H2HRWrXs2BBYIL1PdkwQDFgQoNkkYrK5jg7yiG1OSFp637GB5jzJefIC
        VSHnu+7vwOKdtGTT06dEmkzsTMx1Ic4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-303-UqPL8WP1OriXp_NvkuKX3A-1; Mon, 30 Jan 2023 11:49:30 -0500
X-MC-Unique: UqPL8WP1OriXp_NvkuKX3A-1
Received: by mail-ed1-f69.google.com with SMTP id m23-20020aa7c2d7000000b004a230f52c81so3499354edp.11
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:49:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RUe1+at8qNUL3tbG/zwrRwNfw83JyE6i/0LXaPJqQZw=;
        b=gFzL1ASXYEJEldur07jviisV7NHjOqIue60o1g0IUblt3oekIzu9guknR5FU33rU+J
         j9KcOCkzI/n3P5lDfYJmgXhsywzaAOW/QK6fGUoXMjz1AQsB2UF9NcLa0wZArYHHZJ6r
         B+5N+ZicbrtLSrrIIDX3b/0BVL7PrOVttW/oLx7r5mAVRf0EK6n4s5O63ihvL/NVZXGP
         rivo2QOQyJ+NPC86ly6teK8E0ukN/aosZYVE3KfMCF0MRSPyQcD6yaGQwuJjkyCNPh/D
         DgMf2ZPGxTEaOisuN0CEJIOXmDpyshl/rTk82o/RLJCMXMzVvK1igM9t5Mw/88lBc+Hj
         gwcA==
X-Gm-Message-State: AO0yUKUocAH4f/4bMJ8dR1LprVhHRoUYahAX4n5qfHAI1Kb/65zawONF
        W9mj4LMy6f6OJaUo5AiACWlYCJX4wNWbPM01ti+nnDqyTYfb8MMA02FM3ssMz0zGDZePC73MYii
        EDFtT2+Q3Ve1KAXk8
X-Received: by 2002:a17:907:8a24:b0:881:23a:aba5 with SMTP id sc36-20020a1709078a2400b00881023aaba5mr13075773ejc.11.1675097369618;
        Mon, 30 Jan 2023 08:49:29 -0800 (PST)
X-Google-Smtp-Source: AK7set+RCtksUvJEWryR3yHzEyUiPRPfVvrQL5JDNsl576kHJhhgicW1XmPS8wJt2PCjU2EPXJ3UYg==
X-Received: by 2002:a17:907:8a24:b0:881:23a:aba5 with SMTP id sc36-20020a1709078a2400b00881023aaba5mr13075752ejc.11.1675097369399;
        Mon, 30 Jan 2023 08:49:29 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id x26-20020a1709060a5a00b00877f2b842fasm7129078ejf.67.2023.01.30.08.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 08:49:28 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <4d2d1d1d-1dc8-60d7-8999-f5ea571107c4@redhat.com>
Date:   Mon, 30 Jan 2023 17:49:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, nbd@nbd.name, davem@davemloft.net,
        edumazet@google.com, hawk@kernel.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, linyunsheng@huawei.com,
        lorenzo@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in
 GRO
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
 <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
 <20230126151317.73d67045@kernel.org>
In-Reply-To: <20230126151317.73d67045@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/01/2023 00.13, Jakub Kicinski wrote:
> On Thu, 26 Jan 2023 11:06:59 -0800 Alexander Duyck wrote:
>> From: Alexander Duyck<alexanderduyck@fb.com>
>>
>> GSO should not merge page pool recycled frames with standard reference
>> counted frames. Traditionally this didn't occur, at least not often.
>> However as we start looking at adding support for wireless adapters there
>> becomes the potential to mix the two due to A-MSDU repartitioning frames in
>> the receive path. There are possibly other places where this may have
>> occurred however I suspect they must be few and far between as we have not
>> seen this issue until now.
>>
>> Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
>> Reported-by: Felix Fietkau<nbd@nbd.name>
>> Signed-off-by: Alexander Duyck<alexanderduyck@fb.com>
> Exciting investigation!
> Felix, out of curiosity - the impact of loosing GRO on performance is
> not significant enough to care?  We could possibly try to switch to
> using the frag list if we can't merge into frags safely.

Using the frag list sounds scary, because we recently learned that
kfree_skb_list requires all SKBs on the list to have same refcnt (else
the walking of the list can lead to other bugs).

--Jesper

