Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243CD512012
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242965AbiD0Qad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244587AbiD0Q3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:29:52 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AA1638B;
        Wed, 27 Apr 2022 09:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1651076741;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=yCpWmVR6dk2+oovSw1y9OOXytQ1pCTE8knB7PaU+qWU=;
    b=dSmJGcmxOgUVhJklI1OU8Jo83gTZWM2ql9f0eEnzf46RH+mi5Ty7BpQwU3V4L17f9c
    def5tkkb0X25D+2SqzuHc0W69Bpxw3OQS6JWy7MCwTCAVg2guCsttTykoGZHv8DNvWE2
    d1HTEOBuMi39PchmxH2thF5xkbCdKoWNG/Z6NusSnHFtjiAfhR2N/8RPACCVGlwTT9aH
    3hasz7dFMoTYTx3A5eSmHgFuG4HvI8qkH5auDlBvJxcJWUA99ORr4SUWEfrfb07sEEGd
    /PyBylMrrrd3AkFxqjQw7SgSkQIKjCRB0VqDXCXgeverFXeSdIc/RX7PYMw3IWkoATc7
    XRWA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2krLEWFUg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00::b82]
    by smtp.strato.de (RZmta 47.42.2 AUTH)
    with ESMTPSA id 4544c9y3RGPeNFh
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 27 Apr 2022 18:25:40 +0200 (CEST)
Message-ID: <9717187f-9fa2-8787-7771-8127e752e6f1@hartkopp.net>
Date:   Wed, 27 Apr 2022 18:25:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net] drivers: net: can: Fix deadlock in grcan_close()
Content-Language: en-US
To:     Andreas Larsson <andreas@gaisler.com>,
        Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220425042400.66517-1-duoming@zju.edu.cn>
 <caaa6059-6172-e562-e48e-5987884052b9@hartkopp.net>
 <2f5295c1-d787-84a5-1b3e-813f96dd4ae2@gaisler.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <2f5295c1-d787-84a5-1b3e-813f96dd4ae2@gaisler.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.04.22 14:47, Andreas Larsson wrote:
> On 2022-04-26 21:12, Oliver Hartkopp wrote:
>> On 25.04.22 06:24, Duoming Zhou wrote:
>>> There are deadlocks caused by del_timer_sync(&priv->hang_timer)
>>> and del_timer_sync(&priv->rr_timer) in grcan_close(), one of
>>> the deadlocks are shown below:
>>>
>>>     (Thread 1)              |      (Thread 2)
>>>                             | grcan_reset_timer()
>>> grcan_close()              |  mod_timer()
>>>   spin_lock_irqsave() //(1) |  (wait a time)
>>>   ...                       | grcan_initiate_running_reset()
>>>   del_timer_sync()          |  spin_lock_irqsave() //(2)
>>>   (wait timer to stop)      |  ...
>>>
>>> We hold priv->lock in position (1) of thread 1 and use
>>> del_timer_sync() to wait timer to stop, but timer handler
>>> also need priv->lock in position (2) of thread 2.
>>> As a result, grcan_close() will block forever.
>>>
>>> This patch extracts del_timer_sync() from the protection of
>>> spin_lock_irqsave(), which could let timer handler to obtain
>>> the needed lock.
>>>
>>> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
>>> ---
>>>   drivers/net/can/grcan.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
>>> index d0c5a7a60da..1189057b5d6 100644
>>> --- a/drivers/net/can/grcan.c
>>> +++ b/drivers/net/can/grcan.c
>>> @@ -1102,8 +1102,10 @@ static int grcan_close(struct net_device *dev)
>>>       priv->closing = true;
>>>       if (priv->need_txbug_workaround) {
>>> +        spin_unlock_irqrestore(&priv->lock, flags);
>>>           del_timer_sync(&priv->hang_timer);
>>>           del_timer_sync(&priv->rr_timer);
>>> +        spin_lock_irqsave(&priv->lock, flags);
>>
>> It looks weird to unlock and re-lock the operations like this. This 
>> breaks the intended locking for the closing process.
>>
>> Isn't there any possibility to e.g. move that entire if-section before 
>> the lock?
> 
> All functions wishing to start the timers both check priv->closing and
> then, if false, start the timer within the priv->lock spinlock. Given
> that, it should be ok that del_timer_sync is not done within the
> spinlock as therefore no one can restart any timers after priv->closing
> has been set to true.
> 
> It looks a bit weird, but setting priv->closing to true needs to happen
> within the priv->lock spinlock protection and needs to happen before
> del_timer_sync to avoid a race between grcan_close and someone starting
> the timer.
> 
> Reviewed-by: Andreas Larsson <andreas@gaisler.com>
> 

Thanks Andreas!

Best regards,
Oliver
