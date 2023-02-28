Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78156A56CF
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 11:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjB1Kc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 05:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjB1Kc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 05:32:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B8D3A8D
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677580335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pWE/IH7Gk0DOgzMvd0Lmdxjp64jnYWrJuTM5923X0kE=;
        b=gbFsZ54xYdSQwZWHMLDMB9j/Llj5PXndOhILspnMTSxreE7YB+AC+hPnyO5Mt/Iw39mUbU
        ToDWtZPSSVMCFgn4dylxIADek4XvrO/G4dwLCPcrDdksj9AUfPqPK8pqLsYiJHS+cCppN6
        uymYTbEFXKeAviMLpieFG2Rwe1lW4AY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-248-FfmdNKq_P1y2h1hWAzO-xw-1; Tue, 28 Feb 2023 05:32:10 -0500
X-MC-Unique: FfmdNKq_P1y2h1hWAzO-xw-1
Received: by mail-wr1-f72.google.com with SMTP id x3-20020a5d6503000000b002c8c421fdfaso1438912wru.15
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:32:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pWE/IH7Gk0DOgzMvd0Lmdxjp64jnYWrJuTM5923X0kE=;
        b=o3lX1PQZuIOhqtxpgERiRqe5KU5VNn02uDizkDQ1Vb5GyDzfoRlfKtbi5WyNIb6aXT
         CmMV5Wb1pqSnXo5ouzK0C3BW1OOzPHPpqaEdT7Kc9EbCUGNHLHWsNzqCMZiDOn0B0Pyq
         jxrm2PV0bRozsMz+tkwTaC0mP7cBMAmN7vamNtw8/6pRnkxbXTirRxgtTa0fMEYVouo1
         qNHxaFj8rJBTLA6M9xBB7bH119mgioN/O39L3jmqHs6l7G64ri0e9drF01SnfGlaXtN+
         L2Ops/Uc5u/wAJNpvkSNcmC7iE10rkYjJ1lod+ii8keOWg0blTwXRV9ZQKJZrt8nteSi
         Hvog==
X-Gm-Message-State: AO0yUKXwrqA+aaetQ9D5cNzSGB2fr6d8fIk5V2LTkibIOJHZ0BzJI5w6
        kIFFwZIfS8njRgz6WHDM05YB96JzLI4nwzc+k8zkoytp+Vb29L5GRkz6bNNluAJFeDiW8zuSE4u
        YjI2sfcjAzGEf+L9q
X-Received: by 2002:a5d:6f1b:0:b0:2bf:bf05:85ac with SMTP id ay27-20020a5d6f1b000000b002bfbf0585acmr1808249wrb.23.1677580329580;
        Tue, 28 Feb 2023 02:32:09 -0800 (PST)
X-Google-Smtp-Source: AK7set9ZFVtpNUSDKjWbiaTH1BQVRiKxdUcmbd6hiGVcxOhG2xmXBJ61c13FJ8zRMszkvybFURNUgQ==
X-Received: by 2002:a5d:6f1b:0:b0:2bf:bf05:85ac with SMTP id ay27-20020a5d6f1b000000b002bfbf0585acmr1808234wrb.23.1677580329303;
        Tue, 28 Feb 2023 02:32:09 -0800 (PST)
Received: from sgarzare-redhat (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id k28-20020a5d525c000000b002c556a4f1casm9321915wrc.42.2023.02.28.02.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 02:32:08 -0800 (PST)
Date:   Tue, 28 Feb 2023 11:32:05 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 12/12] test/vsock: MSG_ZEROCOPY support for
 vsock_perf
Message-ID: <20230228103205.6vorc4z363wtxwlk@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <03570f48-f56a-2af4-9579-15a685127aeb@sberdevices.ru>
 <20230216152945.qdh6vrq66pl2bfxe@sgarzare-redhat>
 <d5de8b79-f903-d65f-a5bc-e591578144e7@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d5de8b79-f903-d65f-a5bc-e591578144e7@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 09:05:12AM +0000, Krasnov Arseniy wrote:
>On 16.02.2023 18:29, Stefano Garzarella wrote:
>> On Mon, Feb 06, 2023 at 07:06:32AM +0000, Arseniy Krasnov wrote:
>>> To use this option pass '--zc' parameter:
>>
>> --zerocopy or --zero-copy maybe better follow what we did with the other parameters :-)
>>
>>>
>>> ./vsock_perf --zc --sender <cid> --port <port> --bytes <bytes to send>
>>>
>>> With this option MSG_ZEROCOPY flag will be passed to the 'send()' call.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> tools/testing/vsock/vsock_perf.c | 127 +++++++++++++++++++++++++++++--
>>> 1 file changed, 120 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/tools/testing/vsock/vsock_perf.c b/tools/testing/vsock/vsock_perf.c
>>> index a72520338f84..1d435be9b48e 100644
>>> --- a/tools/testing/vsock/vsock_perf.c
>>> +++ b/tools/testing/vsock/vsock_perf.c
>>> @@ -18,6 +18,8 @@
>>> #include <poll.h>
>>> #include <sys/socket.h>
>>> #include <linux/vm_sockets.h>
>>> +#include <sys/mman.h>
>>> +#include <linux/errqueue.h>
>>>
>>> #define DEFAULT_BUF_SIZE_BYTES    (128 * 1024)
>>> #define DEFAULT_TO_SEND_BYTES    (64 * 1024)
>>> @@ -28,9 +30,14 @@
>>> #define BYTES_PER_GB        (1024 * 1024 * 1024ULL)
>>> #define NSEC_PER_SEC        (1000000000ULL)
>>>
>>> +#ifndef SOL_VSOCK
>>> +#define SOL_VSOCK 287
>>> +#endif
>>
>> I thought we use the current kernel headers when we compile the tests,
>> do we need to fix something in the makefile?
>Not sure, of course we are using uapi. But i see, that defines like SOL_XXX is not
>defined in uapi headers. For example SOL_IP is defined in include/linux/socket.h,
>but userspace app uses SOL_IP from in.h (at least on my machine). E.g. SOL_XXX is
>not exported to user.

Right, I see only few SOL_* in the uapi, e.g. SOL_TIPC in 
uapi/linux/tipc.h

So it's fine for now, otherwise we can define it in 
uapi/linux/vm_sockets.h

Thanks,
Stefano

