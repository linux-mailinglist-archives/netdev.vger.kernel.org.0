Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA734634482
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 20:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiKVTZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 14:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKVTZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 14:25:58 -0500
Received: from mx24lb.world4you.com (mx24lb.world4you.com [81.19.149.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE83E8E286
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OTJCUWwOxeQZx2xhOc7yCP8HEI3Pc9Vkz7Ed9FlMjD8=; b=v84bHgHfvB/8OK2VyjQozPIiLm
        C8UZmlRydQnxF4Pyuq/qLa9Gx2yKBLaBrjqZo2nWJLZbEgu3nUzyRLlQC8vL61+9EAAaQ8TiNvJor
        KRC7BKwtLOOXRzMigBgCt/KNF6vHVDmJXf3/mJQmTsgl8rzF6fdJm1t3BffIUAzMAzog=;
Received: from [88.117.56.227] (helo=[10.0.0.160])
        by mx24lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oxYu1-0002oW-P0; Tue, 22 Nov 2022 20:25:53 +0100
Message-ID: <c6d4a25c-8bc0-89e9-dbec-f493c45f99ed@engleder-embedded.com>
Date:   Tue, 22 Nov 2022 20:25:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next] tsnep: Fix rotten packets
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com
References: <20221119211825.81805-1-gerhard@engleder-embedded.com>
 <fd546e83a38157b76f8bde2219f985c70056abf7.camel@redhat.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <fd546e83a38157b76f8bde2219f985c70056abf7.camel@redhat.com>
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

On 22.11.22 15:51, Paolo Abeni wrote:
> On Sat, 2022-11-19 at 22:18 +0100, Gerhard Engleder wrote:
>> If PTP synchronisation is done every second, then sporadic the interval
>> is higher than one second:
>>
>> ptp4l[696.582]: master offset        -17 s2 freq   -1891 path delay 573
>> ptp4l[697.582]: master offset        -22 s2 freq   -1901 path delay 573
>> ptp4l[699.368]: master offset         -1 s2 freq   -1887 path delay 573
>>        ^^^^^^^ Should be 698.582!
>>
>> This problem is caused by rotten packets, which are received after
>> polling but before interrupts are enabled again. This can be fixed by
>> checking for pending work and rescheduling if necessary after interrupts
>> has been enabled again.
>>
>> Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> 
> For the records, when targeting the net tree, you should include the
> 'net' tag into the patch prefix, instead of 'net-next'.

Ok, I understand. Will do better next time. Thanks!

Gerhard
