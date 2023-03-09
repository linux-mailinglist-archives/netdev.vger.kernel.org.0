Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992A36B2B14
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCIQoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjCIQnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:43:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2063AF34DA
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678379528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OhtE1bGBZ1SlZ7+wLdUpGqS+X/sS9BNBWD0AiRRx31M=;
        b=SRxRtc6pxBrEHQdRO+S0gSbQAAemrNoWqhDizZTG8x6MLwrXvXL3HqicqxdZLdC4gZ1TgW
        CweWiYz9DUqNN3f1QNNCrPJO9msEUVoyiMrBXU32CfVHcsXyMYqoTVUDhoZ4lvHB0umire
        5//ObZhMP2LFIFzok5hs+tn1Bx9og2E=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-3A976GoJMpKPcuIsE74WoA-1; Thu, 09 Mar 2023 11:32:07 -0500
X-MC-Unique: 3A976GoJMpKPcuIsE74WoA-1
Received: by mail-qt1-f200.google.com with SMTP id l2-20020ac87242000000b003bfecc6d046so1338084qtp.17
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 08:32:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678379526;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OhtE1bGBZ1SlZ7+wLdUpGqS+X/sS9BNBWD0AiRRx31M=;
        b=uu8LdWAfbh1AaSnvCJhVPBTflvwLTp2Vf0071gjiZDbISzF+c/Cc3K233vQd4fYYgm
         EGf8q14CjuNuPTcPZUnRiwGgrVXrB1nsfWXRnq2QSntNp9FYwPpIflvmKU4wzSxWBr9P
         zmzw/a3LTBB+CkzoRqvtns9rm0THyq7sV4CjhQHgivZOyxugwhTYUqAkoKUwxjSUxBmM
         icVETLX/a9SPv566n07kxknAm+Swqp0JUb4XJfNWMB7MQT8wc8D1/WASvB64/hZ2s+Qn
         iwnneoE+4AWDMtjwFJqrypD4HmfBobqPoDOtv1JQ/8/LU9tbN+lokNuCfPc5VqXMKMCi
         vWzw==
X-Gm-Message-State: AO0yUKVvcynk5p5vnFLiwHZPZqbZYfBBSTsM7c6NPiYW3Krycf5+pyTx
        vF+gRfxo7l4Y49MB8o1czEevJWFORKBW7KFlizLLtJxTyKf8DHB6zpgGUZyL+rnEri23x1O+23X
        tzSRVA3VxF8UnlomZx27VqdhE
X-Received: by 2002:ac8:5a4b:0:b0:3bf:d00a:2eae with SMTP id o11-20020ac85a4b000000b003bfd00a2eaemr38124777qta.47.1678379526074;
        Thu, 09 Mar 2023 08:32:06 -0800 (PST)
X-Google-Smtp-Source: AK7set9xKlCfrkruhxAK7QF576WQLTA90MiAGXjylmK3sCO1SvBxFAjAgjIt/fQoszp9URGRyn+5OQ==
X-Received: by 2002:ac8:5a4b:0:b0:3bf:d00a:2eae with SMTP id o11-20020ac85a4b000000b003bfd00a2eaemr38124756qta.47.1678379525784;
        Thu, 09 Mar 2023 08:32:05 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id s188-20020a3745c5000000b00742bc037f29sm13579401qka.120.2023.03.09.08.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 08:32:05 -0800 (PST)
Date:   Thu, 9 Mar 2023 17:32:00 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 0/4] several updates to virtio/vsock
Message-ID: <20230309163200.lq6dzop724diafpf@sgarzare-redhat>
References: <0abeec42-a11d-3a51-453b-6acf76604f2e@sberdevices.ru>
 <20230309162150.qqrlqmqghi5muucx@sgarzare-redhat>
 <a1788ed6-89d4-27da-a049-99e29edea4cb@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1788ed6-89d4-27da-a049-99e29edea4cb@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 07:20:20PM +0300, Arseniy Krasnov wrote:
>
>
>On 09.03.2023 19:21, Stefano Garzarella wrote:
>> On Thu, Mar 09, 2023 at 01:10:36PM +0300, Arseniy Krasnov wrote:
>>> Hello,
>>>
>>> this patchset evolved from previous v2 version (see link below). It does
>>> several updates to virtio/vsock:
>>> 1) Changes 'virtio_transport_inc/dec_rx_pkt()' interface. Now instead of
>>>   using skbuff state ('head' and 'data' pointers) to update 'fwd_cnt'
>>>   and 'rx_bytes', integer value is passed as an input argument. This
>>>   makes code more simple, because in this case we don't need to udpate
>>>   skbuff state before calling 'virtio_transport_inc/dec_rx_pkt()'. In
>>>   more common words - we don't need to change skbuff state to update
>>>   'rx_bytes' and 'fwd_cnt' correctly.
>>> 2) For SOCK_STREAM, when copying data to user fails, current skbuff is
>>>   not dropped. Next read attempt will use same skbuff and last offset.
>>>   Instead of 'skb_dequeue()', 'skb_peek()' + '__skb_unlink()' are used.
>>>   This behaviour was implemented before skbuff support.
>>> 3) For SOCK_SEQPACKET it removes unneeded 'skb_pull()' call, because for
>>>   this type of socket each skbuff is used only once: after removing it
>>>   from socket's queue, it will be freed anyway.
>>>
>>> Test for 2) also added:
>>> Test tries to 'recv()' data to NULL buffer, then does 'recv()' with valid
>>> buffer. For SOCK_STREAM second 'recv()' must return data, because skbuff
>>> must not be dropped, but for SOCK_SEQPACKET skbuff will be dropped by
>>> kernel, and 'recv()' will return EAGAIN.
>>>
>>> Link to v1 on lore:
>>> https://lore.kernel.org/netdev/c2d3e204-89d9-88e9-8a15-3fe027e56b4b@sberdevices.ru/
>>>
>>> Link to v2 on lore:
>>> https://lore.kernel.org/netdev/a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru/
>>>
>>> Change log:
>>>
>>> v1 -> v2:
>>> - For SOCK_SEQPACKET call 'skb_pull()' also in case of copy failure or
>>>   dropping skbuff (when we just waiting message end).
>>> - Handle copy failure for SOCK_STREAM in the same manner (plus free
>>>   current skbuff).
>>> - Replace bug repdroducer with new test in vsock_test.c
>>>
>>> v2 -> v3:
>>> - Replace patch which removes 'skb->len' subtraction from function
>>>   'virtio_transport_dec_rx_pkt()' with patch which updates functions
>>>   'virtio_transport_inc/dec_rx_pkt()' by passing integer argument
>>>   instead of skbuff pointer.
>>> - Replace patch which drops skbuff when copying to user fails with
>>>   patch which changes this behaviour by keeping skbuff in queue until
>>>   it has no data.
>>> - Add patch for SOCK_SEQPACKET which removes redundant 'skb_pull()'
>>>   call on read.
>>> - I remove "Fixes" tag from all patches, because all of them now change
>>>   code logic, not only fix something.
>>
>> Yes, but they solve the problem, so we should use the tag (I think at
>> least in patch 1 and 3).
>>
>> We usually use the tag when we are fixing a problem introduced by a
>> previous change. So we need to backport the patch to the stable branches
>> as well, and we need the tag to figure out which branches have the patch
>> or not.
>Ahh, sorry. Ok. I see now :)

No problem at all :-)

I think also patch 2 can have the Fixes tag.

Thanks,
Stefano

>
>Thanks, Arseniy
>>
>> Thanks,
>> Stefano
>>
>>>
>>> Arseniy Krasnov (4):
>>>  virtio/vsock: don't use skbuff state to account credit
>>>  virtio/vsock: remove redundant 'skb_pull()' call
>>>  virtio/vsock: don't drop skbuff on copy failure
>>>  test/vsock: copy to user failure test
>>>
>>> net/vmw_vsock/virtio_transport_common.c |  29 +++---
>>> tools/testing/vsock/vsock_test.c        | 118 ++++++++++++++++++++++++
>>> 2 files changed, 131 insertions(+), 16 deletions(-)
>>>
>>> -- 
>>> 2.25.1
>>>
>>
>

