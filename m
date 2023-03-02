Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52936A816F
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 12:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCBLoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 06:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCBLo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 06:44:27 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B766A2D58;
        Thu,  2 Mar 2023 03:44:23 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id CE6555FD0A;
        Thu,  2 Mar 2023 14:44:20 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1677757460;
        bh=nXzgEDaJ7mfgPMR2dSDVcHR/9usu9xKMYmIGbh5aJzs=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=fOZ9v9mkFvHLKT2oMKeBoeidU0rEs5MYIhFdtKNJ3TCaSiQ803CM1tgkrVc2kpQrR
         Htclbjt6KtXejEbpPAj2tJGmmv+wBde4T83MRrwpbk6xjCehn5ksXT/XeT8CfBXRqp
         8FjDdGGZobZQMKDz++HR4m8S5kliZpy2hSZ2BbWzsOQWqIfnLzUohjBBCGK3Hf4XVV
         kThzJZvpJYjPwQPCf9THz6Cv2EnkcMOiKr3hSjvAN/pflo18GOhv/kgfvXJctWD5+I
         k425QVc9QEgpacMknn1azrPiN14n0xyLe5RMe4/3cpbSyHTur/OZLMdk6MSDPYTZVR
         gFQQ8c8bEW4BQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu,  2 Mar 2023 14:44:17 +0300 (MSK)
Message-ID: <3b38870c-7606-bf2e-8b17-21a75a1ed751@sberdevices.ru>
Date:   Thu, 2 Mar 2023 14:41:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1] vsock: check error queue to set EPOLLERR
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <oxffffaa@gmail.com>,
        <kernel@sberdevices.ru>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
References: <76e7698d-890b-d14d-fa34-da5dd7dd13d8@sberdevices.ru>
 <20230302100621.gk45unegjbqjgpxh@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230302100621.gk45unegjbqjgpxh@sgarzare-redhat>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/02 07:22:00 #20908555
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 02.03.2023 13:06, Stefano Garzarella wrote:
> On Wed, Mar 01, 2023 at 08:19:45AM +0300, Arseniy Krasnov wrote:
>> EPOLLERR must be set not only when there is error on the socket, but also
>> when error queue of it is not empty (may be it contains some control
>> messages). Without this patch 'poll()' won't detect data in error queue.
> 
> Do you have a reproducer?
> 
Dedicated reproducer - no:)
To reproduce this issue, i used last MSG_ZEROCOPY patches. Completion was inserted to
error queue, and 'poll()' didn't report about it. That was the reason, why this patch
was included to MSG_ZEROCOPY patchset. But also i think it is better to reduce number
of patches in it(i'm working on v2), so it is good to handle this patch separately.
May be one way to reproduce it is use SO_TIMESTAMP(time info about skbuff will be queued
to the error queue). IIUC this feature is implemented at socket layer and may work in
vsock (but i'm not sure). Ok, i'll check it and try to implement reproducer.

IIUC, for future, policy for fixes is "for each fix implement reproducer in vsock_test"?

>> This patch is based on 'tcp_poll()'.
> 
> LGTM but we should add a Fixes tag.
> It's not clear to me whether the problem depends on when we switched to using sk_buff or was pre-existing.
> 
> Do you have any idea when we introduced this issue?
git blame shows, that this code exists since first commit to vsock:

commit d021c344051af91f42c5ba9fdedc176740cbd238
Author: Andy King <acking@vmware.com>
Date:   Wed Feb 6 14:23:56 2013 +0000

    VSOCK: Introduce VM Sockets

For TCP same logic was added by:

commit 4ed2d765dfaccff5ebdac68e2064b59125033a3b
Author: Willem de Bruijn <willemb@google.com>
Date:   Mon Aug 4 22:11:49 2014 -0400

    net-timestamp: TCP timestamping


> 
> Thanks,
> Stefano
> 

Thanks Arseniy

>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/af_vsock.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 19aea7cba26e..b5e51ef4a74c 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1026,7 +1026,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
>>     poll_wait(file, sk_sleep(sk), wait);
>>     mask = 0;
>>
>> -    if (sk->sk_err)
>> +    if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
>>         /* Signify that there has been an error on this socket. */
>>         mask |= EPOLLERR;
>>
>> -- 
>> 2.25.1
>>
> 
