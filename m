Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE3D511956
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbiD0Mvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbiD0Mvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:51:40 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Apr 2022 05:48:28 PDT
Received: from bin-mail-out-06.binero.net (bin-mail-out-06.binero.net [195.74.38.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A06272741
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 05:48:28 -0700 (PDT)
X-Halon-ID: 28f2a90e-c628-11ec-9da0-005056917f90
Authorized-sender: andreas@gaisler.com
Received: from [192.168.0.25] (h-98-128-223-123.na.cust.bahnhof.se [98.128.223.123])
        by bin-vsp-out-02.atm.binero.net (Halon) with ESMTPA
        id 28f2a90e-c628-11ec-9da0-005056917f90;
        Wed, 27 Apr 2022 14:47:14 +0200 (CEST)
Message-ID: <2f5295c1-d787-84a5-1b3e-813f96dd4ae2@gaisler.com>
Date:   Wed, 27 Apr 2022 14:47:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] drivers: net: can: Fix deadlock in grcan_close()
Content-Language: en-US
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220425042400.66517-1-duoming@zju.edu.cn>
 <caaa6059-6172-e562-e48e-5987884052b9@hartkopp.net>
From:   Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <caaa6059-6172-e562-e48e-5987884052b9@hartkopp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-26 21:12, Oliver Hartkopp wrote:
> On 25.04.22 06:24, Duoming Zhou wrote:
>> There are deadlocks caused by del_timer_sync(&priv->hang_timer)
>> and del_timer_sync(&priv->rr_timer) in grcan_close(), one of
>> the deadlocks are shown below:
>>
>>     (Thread 1)              |      (Thread 2)
>>                             | grcan_reset_timer()
>> grcan_close()              |  mod_timer()
>>   spin_lock_irqsave() //(1) |  (wait a time)
>>   ...                       | grcan_initiate_running_reset()
>>   del_timer_sync()          |  spin_lock_irqsave() //(2)
>>   (wait timer to stop)      |  ...
>>
>> We hold priv->lock in position (1) of thread 1 and use
>> del_timer_sync() to wait timer to stop, but timer handler
>> also need priv->lock in position (2) of thread 2.
>> As a result, grcan_close() will block forever.
>>
>> This patch extracts del_timer_sync() from the protection of
>> spin_lock_irqsave(), which could let timer handler to obtain
>> the needed lock.
>>
>> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
>> ---
>>   drivers/net/can/grcan.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
>> index d0c5a7a60da..1189057b5d6 100644
>> --- a/drivers/net/can/grcan.c
>> +++ b/drivers/net/can/grcan.c
>> @@ -1102,8 +1102,10 @@ static int grcan_close(struct net_device *dev)
>>       priv->closing = true;
>>       if (priv->need_txbug_workaround) {
>> +        spin_unlock_irqrestore(&priv->lock, flags);
>>           del_timer_sync(&priv->hang_timer);
>>           del_timer_sync(&priv->rr_timer);
>> +        spin_lock_irqsave(&priv->lock, flags);
> 
> It looks weird to unlock and re-lock the operations like this. This 
> breaks the intended locking for the closing process.
> 
> Isn't there any possibility to e.g. move that entire if-section before 
> the lock?

All functions wishing to start the timers both check priv->closing and
then, if false, start the timer within the priv->lock spinlock. Given
that, it should be ok that del_timer_sync is not done within the
spinlock as therefore no one can restart any timers after priv->closing
has been set to true.

It looks a bit weird, but setting priv->closing to true needs to happen
within the priv->lock spinlock protection and needs to happen before
del_timer_sync to avoid a race between grcan_close and someone starting
the timer.

Reviewed-by: Andreas Larsson <andreas@gaisler.com>

-- 
Andreas Larsson
