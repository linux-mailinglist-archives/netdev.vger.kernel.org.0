Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD2962ED83
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 07:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbiKRGNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 01:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241090AbiKRGNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 01:13:38 -0500
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA3928E00
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 22:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8V9gr3/j8qCkFbSYxOKBfkHFu3h5h4oT4Gy0Matu9Rc=; b=oXkyPxw51PgqyWURx5aPrL3SeY
        TSiyp1JXKFPbGpKBw2zcmgPFJhRZcIlPfNdJQrIKU6TKJ4ejK1JhlI+i7gqRiZ1MX8D5qsn56rSio
        jS4jdEobinqpIfT4mGcM07aaq5qSmI+vrfgYq8nl47SnZd/G841yOZ+xZJumdtWm5FBg=;
Received: from [88.117.56.227] (helo=[10.0.0.160])
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ovud4-0006Wt-Gk; Fri, 18 Nov 2022 07:13:34 +0100
Message-ID: <5fefbc3d-c83b-d628-e660-15abfa596b1b@engleder-embedded.com>
Date:   Fri, 18 Nov 2022 07:13:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 2/4] tsnep: Fix rotten packets
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
References: <20221117201440.21183-1-gerhard@engleder-embedded.com>
 <20221117201440.21183-3-gerhard@engleder-embedded.com>
 <Y3ab7xim0EfyCQHm@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <Y3ab7xim0EfyCQHm@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.11.22 21:39, Andrew Lunn wrote:
> On Thu, Nov 17, 2022 at 09:14:38PM +0100, Gerhard Engleder wrote:
>> If PTP synchronisation is done every second, then sporadic the interval
>> is higher than one second:
>>
>> ptp4l[696.582]: master offset        -17 s2 freq   -1891 path delay 573
>> ptp4l[697.582]: master offset        -22 s2 freq   -1901 path delay 573
>> ptp4l[699.368]: master offset         -1 s2 freq   -1887 path delay 573
>>        ^^^^^^^ Should be 698.582!
>>
>> This problem is caused by rotten packets, which are received after
>> polling but before interrupts are enabled again.
> 
> Is this a hardware bug? At the end of the interrupt coalescence
> period, should it not check the queue and fire an interrupt?

In my case, the hardware is not signaled if a descriptor is processed by
the software. The hardware is only signaled if it gets new descriptors
assigned. So the hardware does not know if there are still descriptors
in the RX queue which need to be processed by the software. As a result,
it would only be possible to trigger an interrupt for descriptors which
may has been processed already anyway.

In the end I made the hardware stupid. If interrupts are disabled for
NAPI polling, then interrupts events in the hardware are ignored. If
interrupts are enabled again, then only new interrupt events will
trigger the interrupt. I was afraid that too intelligent hardware will
lead to hardware bugs in this case.

Gerhard
