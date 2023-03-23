Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955FC6C66CA
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjCWLiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCWLiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:38:09 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D77193F0;
        Thu, 23 Mar 2023 04:38:04 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 277F75FD0A;
        Thu, 23 Mar 2023 14:38:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679571482;
        bh=7lZi752yaidVYn1I7MsqCySIdC2Vy7xBMR/W3J+6ogU=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=c8GcqIsVoN/ou8o+y4TgdM7++0urDlRBiw8kOscr5GSl8eIYcuk5nFyEA9a4uChQ2
         FV6LBxYoJp0c4J0hBBJgOzc+/rbMpNV+3rrSleFjPtE5BEt6mdctkRspkHXqSPlDqZ
         0G7gEOqGr/RagIdwUCaKkrforW/YpRAQtE7l+EYmy9y2la1h1SJBzLjn5QoZ41LoAl
         75VNB+glS1T8kknmxsEJ3uqNb4lgnERFwBH2GjXt25lltEGSm1v63T2JxU9cBWZNPN
         kPUpn0RQTMjfFb/xSTKLvXiTycNGO6kTgmMeQ3r9W1JWh6WPfQcZDVAzafYjGr6mCv
         n2xbMCeU/374w==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu, 23 Mar 2023 14:37:56 +0300 (MSK)
Message-ID: <11b36ca2-4f0a-5fe4-bd84-d93eb0fa34c5@sberdevices.ru>
Date:   Thu, 23 Mar 2023 14:34:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v5 0/2] allocate multiple skbuffs on tx
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <f0b283a1-cc63-dc3d-cc0c-0da7f684d4d2@sberdevices.ru>
 <2e06387d-036b-dde2-5ddc-734c65a2f50d@sberdevices.ru>
 <20230323104800.odrkkiuxi3o2l37q@sgarzare-redhat>
 <15e9ac56-bedc-b444-6d9a-8a1355e32eaf@sberdevices.ru>
 <20230323111110.gb4vlaqaf7icymv3@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230323111110.gb4vlaqaf7icymv3@sgarzare-redhat>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/23 09:00:00 #20997914
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23.03.2023 14:11, Stefano Garzarella wrote:
> On Thu, Mar 23, 2023 at 01:53:40PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 23.03.2023 13:48, Stefano Garzarella wrote:
>>> On Thu, Mar 23, 2023 at 01:01:40PM +0300, Arseniy Krasnov wrote:
>>>> Hello Stefano,
>>>>
>>>> thanks for review!
>>>
>>> You're welcome!
>>>
>>>>
>>>> Since both patches are R-b, i can wait for a few days, then send this
>>>> as 'net-next'?
>>>
>>> Yep, maybe even this series could have been directly without RFC ;-)
>>
>> "directly", You mean 'net' tag? Of just without RFC, like [PATCH v5]. In this case
>> it will be merged to 'net' right?
> 
> Sorry for the confusion. I meant without RFC but with net-next.
> 
> Being enhancements and not fixes this is definitely net-next material,
> so even in RFCs you can already use the net-next tag, so the reviewer
> knows which branch to apply them to. (It's not super important since
> being RFCs it's expected that it's not complete, but it's definitely an
> help for the reviewer).
> 
> Speaking of the RFC, we usually use it for patches that we don't think
> are ready to be merged. But when they reach a good state (like this
> series for example), we can start publishing them already without the
> RFC tag.
> 
> Anyway, if you are not sure, use RFC and then when a maintainer has
> reviewed them all, surely you can remove the RFC tag.
> 
> Hope this helps, at least that's what I usually do, so don't take that
> as a strict rule ;-)

Ah ok, I see now, thanks for details

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
