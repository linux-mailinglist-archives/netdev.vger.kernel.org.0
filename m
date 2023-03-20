Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7D86C2130
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjCTTTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbjCTTTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:19:23 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCF11729;
        Mon, 20 Mar 2023 12:11:17 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 1FB0E5FD1E;
        Mon, 20 Mar 2023 21:14:05 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679336045;
        bh=CL+U4euESbrv+yI1Q5hgp56UXDvzqJwz4fDRPmibhuY=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=sxT+7N1HX9qXQX6zbqe6+HHezeKeiYBehi8ABO9DS2Wj76GG9LN20wy6+XFYZApUp
         dCy+fvNawtvR1ioAy8+eNBTx2cFqURtf+aozV+bRO8EVyXDwYv8lM2YfhYmE4r2IEO
         AIDTkLBARn5ZU+h4RuYJQu1cqdW3gDxjNEZslSDdkLR283vEewPRFTlTVYByspREdT
         M99Zs/XAf1axA8nluuw1KW+RR6TmqKOAGUHQZZLD6v2m3WgzCo998hiDZ33D5FcqZz
         xTlcokOXGi7ouJ2XqLxWZJ4qOoRhQps2WSS2XNB88h9LKKtG4dxvqAq0iP/bD2l6CI
         f9I8PAybB4OEg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon, 20 Mar 2023 21:14:04 +0300 (MSK)
Message-ID: <329372cf-ef01-8a20-da6e-8c1f9795e41a@sberdevices.ru>
Date:   Mon, 20 Mar 2023 21:10:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 1/3] virtio/vsock: fix header length on skb merging
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
References: <e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru>
 <63445f2f-a0bb-153c-0e15-74a09ea26dc1@sberdevices.ru>
 <20230320145718.5gytg6t5pcz5rpnm@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230320145718.5gytg6t5pcz5rpnm@sgarzare-redhat>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/20 09:56:00 #20977321
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.03.2023 17:57, Stefano Garzarella wrote:
> On Sun, Mar 19, 2023 at 09:51:06PM +0300, Arseniy Krasnov wrote:
>> This fixes header length calculation of skbuff during data appending to
>> it. When such skbuff is processed in dequeue callbacks, e.g. 'skb_pull()'
>> is called on it, 'skb->len' is dynamic value, so it is impossible to use
>> it in header, because value from header must be permanent for valid
>> credit calculation ('rx_bytes'/'fwd_cnt').
>>
>> Fixes: 077706165717 ("virtio/vsock: don't use skbuff state to account credit")
> 
> I don't understand how this commit introduced this problem, can you
> explain it better?
Sorry, seems i said it wrong a little bit. Before 0777, implementation was buggy, but
exactly this problem was not actual - it didn't triggered somehow. I checked it with
reproducer from this patch. But in 0777 as value from header was used to 'rx_bytes'
calculation, bug become actual. Yes, may be it is not "Fixes:" for 0777, but critical
addition. I'm not sure.
> 
> Is it related more to the credit than to the size in the header itself?
> 
It is related to size in header more.
> Anyway, the patch LGTM, but we should explain better the issue.
>
 
Ok, I'll write it more clear in the commit message.

Thanks, Arseniy

> Thanks,
> Stefano
> 
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 6d15cd4d090a..3c75986e16c2 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -1091,7 +1091,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>>             memcpy(skb_put(last_skb, skb->len), skb->data, skb->len);
>>             free_pkt = true;
>>             last_hdr->flags |= hdr->flags;
>> -            last_hdr->len = cpu_to_le32(last_skb->len);
>> +            le32_add_cpu(&last_hdr->len, len);
>>             goto out;
>>         }
>>     }
>> -- 
>> 2.25.1
>>
> 
