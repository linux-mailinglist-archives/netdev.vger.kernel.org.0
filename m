Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575A06A83AB
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 14:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCBNjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 08:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCBNjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 08:39:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D2015CB5
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 05:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677764333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ZdM39Rwm+APVNSKOoKjEHl8iHMadAxZ6z3x8N7ucVs=;
        b=dYJMQJoJ6/bCHLLqmUBaabh71V4ncfVQcK6UDLf+sEv2AQhd9oovKjoWHX4hstd8jf36Xg
        1AK4fR7f0GfTkv/so5MO/7yOlLAfKKAj5fslOCy9TXmGwPWIiTbFoOJJapzcOcur2+PnV/
        Y4tVIMa/UEt8ShfNd1XPDv6xwz29Mfw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-288-L7J_81O5OiWV2Nr7xPNUcg-1; Thu, 02 Mar 2023 08:38:51 -0500
X-MC-Unique: L7J_81O5OiWV2Nr7xPNUcg-1
Received: by mail-wm1-f72.google.com with SMTP id n15-20020a05600c500f00b003dd07ce79c8so1101055wmr.1
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 05:38:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677764330;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZdM39Rwm+APVNSKOoKjEHl8iHMadAxZ6z3x8N7ucVs=;
        b=UEg3tGL9JrnrC16GHV0/MgLI3vNmqr9GHOMmwifH2nxq0vqBR7gbalVZgEpnFoPht1
         MbQ3eMlsV2QXY0aqTxzYctwi60p7n5odeowhWw7t716+r9HJj2DQW0Jo3GKAnKR7bs/L
         pksokzuLbXiicBdoypxJ+/gUlNV/3uvJBJDwTZvVgvc6eNtEaG/M4Pfwr1PI9+gLiOJt
         XKSPigEv36094KoUs8rPu9tyC4aVYO2N/WMakDg3vBW3Mu+pjBVMpbjDrdg1ory/2+PW
         rJCbgzOikA3ZvKSrtYv+tMo/uDsnGi/tsiUh7pSvsnvz0FekBmZfV56UV2/uph4FRzqg
         qBfA==
X-Gm-Message-State: AO0yUKW/UbHYycS9KsV7i6o5ccXBjA6beGGfDFAmfM8PIiKqbF5cs8Lb
        JgjGfXLwUHeMqa1TFUwjeiT3gVHKWhMy4zRJ52jh688eVdhZXwXlIw1eb7GC0Z9sve7myOJypL/
        U47drkG/nf97rqx1j
X-Received: by 2002:a5d:56cb:0:b0:2c7:1b3d:1fb9 with SMTP id m11-20020a5d56cb000000b002c71b3d1fb9mr7355478wrw.50.1677764329883;
        Thu, 02 Mar 2023 05:38:49 -0800 (PST)
X-Google-Smtp-Source: AK7set86niPGr89uB0anqISxCl4PutLnmZ7/ReX6UXFcr5ISdGk14j6U7XkC6IbLZNuiZojlUcc9Bw==
X-Received: by 2002:a5d:56cb:0:b0:2c7:1b3d:1fb9 with SMTP id m11-20020a5d56cb000000b002c71b3d1fb9mr7355466wrw.50.1677764329563;
        Thu, 02 Mar 2023 05:38:49 -0800 (PST)
Received: from sgarzare-redhat (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id hg13-20020a05600c538d00b003d9aa76dc6asm3022317wmb.0.2023.03.02.05.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 05:38:49 -0800 (PST)
Date:   Thu, 2 Mar 2023 14:38:45 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, oxffffaa@gmail.com,
        kernel@sberdevices.ru, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: Re: [RFC PATCH v1] vsock: check error queue to set EPOLLERR
Message-ID: <20230302133845.hglm4uregjsvrcrc@sgarzare-redhat>
References: <76e7698d-890b-d14d-fa34-da5dd7dd13d8@sberdevices.ru>
 <20230302100621.gk45unegjbqjgpxh@sgarzare-redhat>
 <3b38870c-7606-bf2e-8b17-21a75a1ed751@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b38870c-7606-bf2e-8b17-21a75a1ed751@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 02:41:29PM +0300, Arseniy Krasnov wrote:
>Hello!
>
>On 02.03.2023 13:06, Stefano Garzarella wrote:
>> On Wed, Mar 01, 2023 at 08:19:45AM +0300, Arseniy Krasnov wrote:
>>> EPOLLERR must be set not only when there is error on the socket, but also
>>> when error queue of it is not empty (may be it contains some control
>>> messages). Without this patch 'poll()' won't detect data in error queue.
>>
>> Do you have a reproducer?
>>
>Dedicated reproducer - no:)
>To reproduce this issue, i used last MSG_ZEROCOPY patches. Completion was inserted to
>error queue, and 'poll()' didn't report about it. That was the reason, why this patch
>was included to MSG_ZEROCOPY patchset. But also i think it is better to reduce number
>of patches in it(i'm working on v2), so it is good to handle this patch separately.

Yep, absolutely!

>May be one way to reproduce it is use SO_TIMESTAMP(time info about skbuff will be queued
>to the error queue). IIUC this feature is implemented at socket layer and may work in
>vsock (but i'm not sure). Ok, i'll check it and try to implement reproducer.
>
>IIUC, for future, policy for fixes is "for each fix implement reproducer in vsock_test"?

Nope, but for each fix we should have a Fixes tag.

Usually we use vsock_test to check regressions on features and also the
behaviour of different transports.
My question was more about whether this problem was there before
supporting sk_buff or not, to figure out which Fixes tag to use.

>
>>> This patch is based on 'tcp_poll()'.
>>
>> LGTM but we should add a Fixes tag.
>> It's not clear to me whether the problem depends on when we switched to using sk_buff or was pre-existing.
>>
>> Do you have any idea when we introduced this issue?
>git blame shows, that this code exists since first commit to vsock:

Okay, but did we use sk_error_queue before supporting sk_buff?

Anyway, if we are not sure I think we can use the following Fixes tag,
I don't see any issue if we backport this patch also before supporting
sk_buff.

Thanks,
Stefano

>
>commit d021c344051af91f42c5ba9fdedc176740cbd238
>Author: Andy King <acking@vmware.com>
>Date:   Wed Feb 6 14:23:56 2013 +0000
>
>    VSOCK: Introduce VM Sockets
>
>For TCP same logic was added by:
>
>commit 4ed2d765dfaccff5ebdac68e2064b59125033a3b
>Author: Willem de Bruijn <willemb@google.com>
>Date:   Mon Aug 4 22:11:49 2014 -0400
>
>    net-timestamp: TCP timestamping
>
>
>>
>> Thanks,
>> Stefano
>>
>
>Thanks Arseniy
>
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> net/vmw_vsock/af_vsock.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>> index 19aea7cba26e..b5e51ef4a74c 100644
>>> --- a/net/vmw_vsock/af_vsock.c
>>> +++ b/net/vmw_vsock/af_vsock.c
>>> @@ -1026,7 +1026,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
>>>     poll_wait(file, sk_sleep(sk), wait);
>>>     mask = 0;
>>>
>>> -    if (sk->sk_err)
>>> +    if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
>>>         /* Signify that there has been an error on this socket. */
>>>         mask |= EPOLLERR;
>>>
>>> -- 
>>> 2.25.1
>>>
>>
>

