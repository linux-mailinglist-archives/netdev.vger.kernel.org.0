Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8286EDDFE
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbjDYI3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbjDYI3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:29:50 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79DF49C3;
        Tue, 25 Apr 2023 01:29:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 789D960161;
        Tue, 25 Apr 2023 10:29:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682411385; bh=KyqatyXSmiybBdZf8kL0kB6Fpz4lArIKu5YaNvuHwlQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZruPUvK1iStW/J9EvlGBEHLp2qkXOYERHLn5Q5RZHvY0eLMVyR1RvEmftLCFu/ObQ
         Ri5JvyaHWhY4svBF2PKc+WQusIJ3RiAU3rQYh6V1lpsB21AE6YpvrrtIZm//ED9XT7
         F7n9h4DF/5DUqSLfsobB8vryUHOY62/M7+wEe3jht7/ED7pjOfWcPSD/jIuOGqTfEL
         sedkUKq/Qbn6GmVwJrfiXoVnrr5GG6LEaWsshHHPeR9LFDZplEoGS3PzhdqOfXjMn6
         WiSs6AnkGCDVbZ7jlkUmRH9cvTjyrGrMSllBNctV2gzNsJvTtgHtSiLlEIyFz3tJ//
         OhLaYDRY7e2GQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Z3y7YojNxraQ; Tue, 25 Apr 2023 10:29:43 +0200 (CEST)
Received: from [10.0.1.134] (grf-nat.grf.hr [161.53.83.23])
        by domac.alu.hr (Postfix) with ESMTPSA id 65B466015F;
        Tue, 25 Apr 2023 10:29:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682411383; bh=KyqatyXSmiybBdZf8kL0kB6Fpz4lArIKu5YaNvuHwlQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=DxIJt7QNEXgwt5QgcyC1tuJnXD2hvUZmpDdZDFc/ZzIj/WGRRT6FTe/35h4k5F9hV
         xr8GbDc62pmr2wHiNaXwiTLmo6oV17XzyTNXA0G+PBhWwNR4tbHxuZOS28g+IzJmkx
         FvPxW8TDtHwYr+aiXRxh5AkHqNdzvXvxzgRK54Fsl21TzaqcbkQqbiVM3JjZ9+ryfX
         PnUh6fKrjHat+k77Y2TosQgtYaRiAXDTbDuwdwehqttJN9DErfF+FEz+IXS0WbPyBN
         VU5jm5+K+z0eV5ACZDEB3Ecaj6X+KWNZO1SDGjOt1nYUdXppb5KM0bbMAs/ZiydoHo
         F7YW8Bn2lwNlQ==
Message-ID: <cdc80531-f25f-6f9d-b15f-25e16130b53a@alu.unizg.hr>
Date:   Tue, 25 Apr 2023 10:29:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v1 1/1] net: mac80211: fortify the spinlock against
 deadlock in interrupt
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Wetzel <alexander@wetzel-home.de>
References: <20230423082403.49143-1-mirsad.todorovac@alu.unizg.hr>
 <017c5178594e2df6ca02f2d7ffa9109755315c56.camel@sipsolutions.net>
Content-Language: en-US, hr
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <017c5178594e2df6ca02f2d7ffa9109755315c56.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.4.2023. 19:27, Johannes Berg wrote:
> On Sun, 2023-04-23 at 10:24 +0200, Mirsad Goran Todorovac wrote:
>> In the function ieee80211_tx_dequeue() there is a locking sequence:
>>
>> begin:
>> 	spin_lock(&local->queue_stop_reason_lock);
>> 	q_stopped = local->queue_stop_reasons[q];
>> 	spin_unlock(&local->queue_stop_reason_lock);
>>
>> However small the chance (increased by ftracetest), an asynchronous
>> interrupt can occur in between of spin_lock() and spin_unlock(),
>> and the interrupt routine will attempt to lock the same
>> &local->queue_stop_reason_lock again.
>>
>> This is the only remaining spin_lock() on local->queue_stop_reason_lock
>> that did not disable interrupts and could have possibly caused the deadlock
>> on the same CPU (core).
>>
>> This will cause a costly reset of the CPU and wifi device or an
>> altogether hang in the single CPU and single core scenario.
>>
>> This is the probable reproduce of the deadlock:
>>
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  Possible unsafe locking scenario:
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        CPU0
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        ----
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   lock(&local->queue_stop_reason_lock);
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   <Interrupt>
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:     lock(&local->queue_stop_reason_lock);
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:
>>                                                   *** DEADLOCK ***
>>
>> Fixes: 4444bc2116ae
> 
> That fixes tag is wrong, should be
> 
> Fixes: 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
> 
> Otherwise seems fine to me, submit it properly?
> 
> johannes

Will do, Sir. Do I have an Acked-by: ?

Thank you.

Mirsad

-- 
Mirsad Todorovac
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb
Republic of Croatia, the European Union

Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

