Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D432CC237
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389044AbgLBQZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:25:58 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:35067 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387405AbgLBQZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:25:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1606926186;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=EBATEHZeZJeRrIC3X7gmTVqFxYZ3iIi6qc5SjPGFl30=;
        b=QJ8RpRZDxQVY91hhgqP1gRXE8x8xyToZlsPzpUtrUHDgFcl+X9PTgyaIB8pbK3VxqL
        FBw0GZnpmqmK2Of8KQ8dMM6TCugYEL3fMi4S91CBI6J1oSHzolj/TDDfcJPQ518oLrLZ
        gF/pw9a7Fz91QXM496TVaIT4pLvc06h1U8uYOkoK+3ofWinllJ2FhbVC0OdEoEYrVI2G
        j6UiFQyx2Rk4u4wU6vEkRMX3ZkKUOmqA/TACekMqRVOMTKZUjMSpZCsezj4ooJb+a2KQ
        hVRMjYMtmcHFD3hRH8+G71QocOw+TziaY4Jx/bSlJrhd1UP45XiiLrTO798qMnUZ+OOQ
        0sgQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGV1iO89vpw=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.177]
        by smtp.strato.de (RZmta 47.3.4 DYNA|AUTH)
        with ESMTPSA id n07f3bwB2GMvCYg
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 2 Dec 2020 17:22:57 +0100 (CET)
Subject: Re: [PATCH] can: don't count arbitration lose as an error
To:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:ARM/Allwinner sunXi SoC support" 
        <linux-arm-kernel@lists.infradead.org>
References: <20201127095941.21609-1-jhofstee@victronenergy.com>
 <434167b4-c2df-02bf-8a9c-2d4716c5435f@pengutronix.de>
 <f5f93e72-c55f-cfd3-a686-3454e42c4371@victronenergy.com>
 <0988dd09-70d9-3ee8-9945-10c4dea49407@hartkopp.net>
 <405f9e1a-e653-e82d-6d45-a1e5298b5c82@victronenergy.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <b08226a0-bd96-637f-954d-fb8dedc0017b@hartkopp.net>
Date:   Wed, 2 Dec 2020 17:22:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <405f9e1a-e653-e82d-6d45-a1e5298b5c82@victronenergy.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jeroen,

On 02.12.20 16:37, Jeroen Hofstee wrote:
> On 12/2/20 3:35 PM, Oliver Hartkopp wrote:

>> Do we agree that in one-shot mode both the tx_errors and the 
>> arbitration_lost counters are increased in the arbitration-lost case?
>>
>> At least this would fit to the Kvaser USB behaviour.
> 
> 
> I have no opinion about that. I just kept existing behavior.

That's ok for me either.

>> And btw. I wondered if we should remove the check for 
>> CAN_CTRLMODE_ONE_SHOT here, as we ALWAYS should count a tx_error and 
>> drop the echo_skb when we have a TX-interrupt and TX-complete flag is 
>> zero.
>>
>> So replace:
>>
>> if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
>>                   !(status & SR_TCS)) {
>>
>> with:
>>
>> if (!(status & SR_TCS)) {
>>
>> Any suggestions?
>>
> 
> In theory, yes. But I can't think of a reason you would end
> up there without CAN_CTRLMODE_ONE_SHOT being set.

Right. Me too. But for that reason I would remove that extra check to 
catch this error even if CAN_CTRLMODE_ONE_SHOT is not enabled.

> Aborting the current transmission in non single shot mode
> will get you there and incorrectly report the message as
> transmitted, but that is not implemented afaik.

Ahem, no. If you get there the echo_skb is deleted and the tx_errors 
counter is increased. Just as it should be.

Regards,
Oliver
