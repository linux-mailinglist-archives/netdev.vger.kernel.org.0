Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7A36310FB
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 21:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbiKSUrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 15:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235148AbiKSUrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 15:47:33 -0500
Received: from mx10lb.world4you.com (mx10lb.world4you.com [81.19.149.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59E013D32
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 12:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Y+z/ckFz8kQeTSdijIKzkj1sQSAZqk8w8VZ2RCgN15s=; b=A+z+/QYi5FASmBFCSkGQg9oKio
        4CSMOsf2QPaxl7Azqsqmh281P+s9SAgGMtu172ds+MNhOh3hI4ry+buU66jZWAKya5NdXxc1RiXgR
        Hepr/IQqv0mJekKNYnX5yyCoP4E7S8PSA04MiYG3wLclyvu/i86/3e5p9hyJbPiHvxuk=;
Received: from [88.117.56.227] (helo=[10.0.0.160])
        by mx10lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1owUkM-0006Wx-36; Sat, 19 Nov 2022 21:47:30 +0100
Message-ID: <e95f3666-8d5b-57ac-df18-17a2967dd196@engleder-embedded.com>
Date:   Sat, 19 Nov 2022 21:47:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 2/4] tsnep: Fix rotten packets
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
References: <20221117201440.21183-1-gerhard@engleder-embedded.com>
 <20221117201440.21183-3-gerhard@engleder-embedded.com>
 <20221118172618.34c7097e@kernel.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20221118172618.34c7097e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19.11.22 02:26, Jakub Kicinski wrote:
> On Thu, 17 Nov 2022 21:14:38 +0100 Gerhard Engleder wrote:
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
> This patch needs to go to net separately :(
> Packets getting stuck in a queue can cause real issues to users.

I will post it separately.
