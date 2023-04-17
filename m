Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3826E5019
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjDQSYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDQSYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:24:21 -0400
Received: from mx13lb.world4you.com (mx13lb.world4you.com [81.19.149.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167BC3C1F;
        Mon, 17 Apr 2023 11:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zGJQ8qrCmdCkHx8hGPRhHH2fYfablCYius5LjLv298w=; b=uV8/vLLVj/+PuRqyQC1vPBzrkB
        FXnStrgoFTXGwpwG7J3Wc62bFBzVvIdyBNKU0L1Hoiv0z1zECVoHqRF6I8WObsW+/Fp/ZoEp4fQYg
        aJgleLKJHLCsxR+HpQQc2wpzap6tVCho9Qvzia4YusLPiqkLc9G/LA334p2H0H8eEWgc=;
Received: from [88.117.57.231] (helo=[10.0.0.160])
        by mx13lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1poTWO-0005pR-Ha; Mon, 17 Apr 2023 20:24:12 +0200
Message-ID: <4520b112-96c7-2dd8-b2c0-027961eb3a7c@engleder-embedded.com>
Date:   Mon, 17 Apr 2023 20:24:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: issue with inflight pages from page_pool
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name
References: <ZD2HjZZSOjtsnQaf@lore-desk>
 <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
 <ZD2NSSYFzNeN68NO@lore-desk>
Content-Language: en-US
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <ZD2NSSYFzNeN68NO@lore-desk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.04.23 20:17, Lorenzo Bianconi wrote:
>> On Mon, Apr 17, 2023 at 7:53 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>>>
>>> Hi all,
>>>
>>> I am triggering an issue with a device running the page_pool allocator.
>>> In particular, the device is running an iperf tcp server receiving traffic
>>> from a remote client. On the driver I loaded a simple xdp program returning
>>> xdp_pass. When I remove the ebpf program and destroy the pool, page_pool
>>> allocator starts complaining in page_pool_release_retry() that not all the pages
>>> have been returned to the allocator. In fact, the pool is not really destroyed
>>> in this case.
>>> Debugging the code it seems the pages are stuck softnet_data defer_list and
>>> they are never freed in skb_defer_free_flush() since I do not have any more tcp
>>> traffic. To prove it, I tried to set sysctl_skb_defer_max to 0 and the issue
>>> does not occur.
>>> I developed the poc patch below and the issue seems to be fixed:
>>
>> I do not see why this would be different than having buffers sitting
>> in some tcp receive
>> (or out or order) queues for a few minutes ?
> 
> The main issue in my tests (and even in mt76 I think) is the pages are not returned
> to the pool for a very long time (even hours) and doing so the pool is like in a
> 'limbo' state where it is not actually deallocated and page_pool_release_retry
> continues complaining about it. I think this is because we do not have more tcp
> traffic to deallocate them, but I am not so familiar with tcp codebase :)
> 
> Regards,
> Lorenzo
> 
>>
>> Or buffers transferred to another socket or pipe (splice() and friends)

I'm not absolutely sure that it is the same problem, but I also saw some
problems with page_pool destroying and page_pool_release_retry(). I did
post it, but I did not get any reply:

https://lore.kernel.org/bpf/20230311213709.42625-1-gerhard@engleder-embedded.com/T/

Could this be a similar issue?

Gerhard
