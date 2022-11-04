Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED9A619A0C
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiKDOeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiKDOdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:33:21 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194FB4AF2E;
        Fri,  4 Nov 2022 07:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1667572097;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=1iIpXFsuyPQINneA2wCr5wWDQHSoRuYe4hV6XN+OD6A=;
    b=pllalSucjoTv1gml5YxbETpWUUKScNTvvb8Jwt1hcUcwguIQDW5HcTDKVJfMO4bujL
    URyPHBWQb+aWL3FG+D+Wx3Krhwp88tSFqLXgJTD1WVMBbxPFKZVsFe3Vdfl+v/JrNNYU
    srLA+mIQg/sVZPVwgXE7eAm8Nu96JLNoSx8kehnhQMqaXjevNCZGL0yRJsQyh5rriXGB
    eS132vH7l12Cvvl+g/oP7XPBVwfdYZGv7YjjuVm4SrfskheM31ToJ7t9BLtqGw9lFc4Z
    +VFY9Iv4jSRrCrQ/fxme3yadboO579VIKEHLC7wKyD35eXB5l4v3xniig/mocFNyXnH5
    wm9A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytISr6hZqJAw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d104::923]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783yA4ESHQrC
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 4 Nov 2022 15:28:17 +0100 (CET)
Message-ID: <f8a22e38-a7e9-0643-d6a6-6c5901dee7b4@hartkopp.net>
Date:   Fri, 4 Nov 2022 15:28:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] can: isotp: fix tx state handling for echo tx processing
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
References: <20221101212902.10702-1-socketcan@hartkopp.net>
 <20221104121059.kbhrpwbumuc6q3iv@pengutronix.de>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20221104121059.kbhrpwbumuc6q3iv@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On 04.11.22 13:10, Marc Kleine-Budde wrote:
> On 01.11.2022 22:29:02, Oliver Hartkopp wrote:
>> In commit 4b7fe92c0690 ("can: isotp: add local echo tx processing for
>> consecutive frames") the data flow for consecutive frames (CF) has been
>> reworked to improve the reliability of long data transfers.
>>
>> This rework did not touch the transmission and the tx state changes of
>> single frame (SF) transfers which likely led to the WARN in the
>> isotp_tx_timer_handler() catching a wrong tx state. This patch makes use
>> of the improved frame processing for SF frames and sets the ISOTP_SENDING
>> state in isotp_sendmsg() within the cmpxchg() condition handling.
>>
>> A review of the state machine and the timer handling additionally revealed
>> a missing echo timeout handling in the case of the burst mode in
>> isotp_rcv_echo() and removes a potential timer configuration uncertainty
>> in isotp_rcv_fc() when the receiver requests consecutive frames.
>>
>> Fixes: 4b7fe92c0690 ("can: isotp: add local echo tx processing for consecutive frames")
>> Link: https://lore.kernel.org/linux-can/CAO4mrfe3dG7cMP1V5FLUkw7s+50c9vichigUMQwsxX4M=45QEw@mail.gmail.com/T/#u
>> Reported-by: Wei Chen <harperchen1110@gmail.com>
>> Cc: stable@vger.kernel.org # v6.0
>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> [...]
> 
>> @@ -905,10 +915,11 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
>>   		so->tx.state = ISOTP_IDLE;
>>   		wake_up_interruptible(&so->wait);
>>   		break;
>>   
>>   	default:
>> +		pr_notice_once("can-isotp: tx timer state %X\n", so->tx.state);
>>   		WARN_ON_ONCE(1);
> 
> Can you use WARN_ONCE() instead of pr_notice_once() + WARN_ON_ONCE() here?
> 

Yes. That was a good idea! V2 is sent.

It also allowed me to print another relevant variable.

Thanks,
Oliver
