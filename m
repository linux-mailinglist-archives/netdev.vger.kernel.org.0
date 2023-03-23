Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C1C6C65E6
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbjCWK5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjCWK5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:57:12 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AD7269F;
        Thu, 23 Mar 2023 03:56:56 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 45FB15FD0A;
        Thu, 23 Mar 2023 13:56:54 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679569014;
        bh=8eddXPC/awXNoMqy6byR3Hi8fDvqg6PVzKfliU62rbA=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=HbdKtnpY6qlblx62oixH39Ew4smcAa1Z2EYZ5iWp5IvqSmrGl6W/M/ck5O5NcDOEz
         nhygucMMWj6ONBE/ULSVny/z7m2blwKv+LJ6OCUDWNdb/yPHvufLIqtt/ZTN+DtoLt
         crW33coG0gIoCz0g6z0SOaiIxl68kpKpiC3847/G/NZqD5GSICYYODd9pWAeXkSg2i
         5Mt3UNyr8xD/WPjbQ9MkTWHomVCLpNLHdZ/eMYT/TS9qP7lxUOkFXLI357xxDRD7mK
         35xNtUrwkQgCkzEDXhXgwKBsBAAsuyV0cD0/R4dkmwPJcS2oU3bsDbANmDxRLWlRPx
         wPsssu8PZhR+A==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu, 23 Mar 2023 13:56:52 +0300 (MSK)
Message-ID: <15e9ac56-bedc-b444-6d9a-8a1355e32eaf@sberdevices.ru>
Date:   Thu, 23 Mar 2023 13:53:40 +0300
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
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230323104800.odrkkiuxi3o2l37q@sgarzare-redhat>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
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



On 23.03.2023 13:48, Stefano Garzarella wrote:
> On Thu, Mar 23, 2023 at 01:01:40PM +0300, Arseniy Krasnov wrote:
>> Hello Stefano,
>>
>> thanks for review!
> 
> You're welcome!
> 
>>
>> Since both patches are R-b, i can wait for a few days, then send this
>> as 'net-next'?
> 
> Yep, maybe even this series could have been directly without RFC ;-)

"directly", You mean 'net' tag? Of just without RFC, like [PATCH v5]. In this case 
it will be merged to 'net' right?

Thanks, Arseniy
> 
> Thanks,
> Stefano
> 
