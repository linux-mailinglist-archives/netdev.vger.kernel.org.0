Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F926B3E2D
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjCJLk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjCJLkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:40:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E405F6C55
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 03:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678448406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJwQlAakOokhmQO5hlNSSM0QAOQ7URuACK/mNX+Ecvw=;
        b=fLh3os5o79QnGlenkthg1cOwdf7xwnD6ApevQ8Rd1cdCzA5Ho31A9HzIixpnu6k0pzi4o9
        OvunRiap/4gPUvbkNqVVZY2EWHHSRpl8GXxFMqtDqnZlAXk90QaJ6GDBcqw/XeG54gGDn1
        APMVVaU23aFdNfwqAtO/1CzlTDlOHng=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-F5mqF_wJNCm5Dw0alOU-Ew-1; Fri, 10 Mar 2023 06:40:05 -0500
X-MC-Unique: F5mqF_wJNCm5Dw0alOU-Ew-1
Received: by mail-wm1-f69.google.com with SMTP id l20-20020a05600c1d1400b003e10d3e1c23so3743881wms.1
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 03:40:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678448404;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rJwQlAakOokhmQO5hlNSSM0QAOQ7URuACK/mNX+Ecvw=;
        b=jYWDm3cwOa7NU2cba8k+xPVLrzBWaVZoNLlJ5xOZXoCdGHuRlSa/Tr5tghVXu9Q+Nw
         fAFVK5DclwkACc6fs07Z7TH04LfUfay1YqV+XwI41BPdSq1lqomLhSCCwxGOYX8mej5E
         iapNfBr5bigxM6TnuFCC5m3n02G9Dt9YXMivIO+rL9pQG7usqNN46mL+nwax1fGhgdMg
         XZbOM0nuezvyCjBGL+Dn6D6KSkm+Qh1g0dN/8sh1l8PvpJ0sC13BCRIgwew4KsCVmKw5
         ESJn9saji8mqFlkPdwvRj26V1cNhaj50jtXSR0KZ1X9nXwa5oyJGymfaSouCF3h3NDQb
         NyqQ==
X-Gm-Message-State: AO0yUKUSy5DRO/1e8ymUOhByWtKPgs7rgLAh940ejVXtSOj3jPO/4qSU
        bMNGhRaPtSLSieAm5QptH5an1Oayjt0cfHhen1/sYw35c5f4wA0NPYXTp1E/YkB2/AmpE2KFXbN
        wAGs+/UCyPcwHLRSidVcnz1ju
X-Received: by 2002:adf:ef10:0:b0:2ca:3576:756d with SMTP id e16-20020adfef10000000b002ca3576756dmr17441601wro.50.1678448404005;
        Fri, 10 Mar 2023 03:40:04 -0800 (PST)
X-Google-Smtp-Source: AK7set+RNKqlJyQI+1SQ507spnOBqv3bWEPOICTIm+RgBVN6rKvCG9ALHkeDNEO4/C58wDmMpo7bIA==
X-Received: by 2002:adf:ef10:0:b0:2ca:3576:756d with SMTP id e16-20020adfef10000000b002ca3576756dmr17441579wro.50.1678448403714;
        Fri, 10 Mar 2023 03:40:03 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id m4-20020a5d6244000000b002c707b336c9sm2065136wrv.36.2023.03.10.03.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 03:40:03 -0800 (PST)
Date:   Fri, 10 Mar 2023 12:40:00 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 0/4] several updates to virtio/vsock
Message-ID: <20230310114000.6ptwpryulbvcqf5m@sgarzare-redhat>
References: <1804d100-1652-d463-8627-da93cb61144e@sberdevices.ru>
 <20230310090937.s55af2fx56zn4ewu@sgarzare-redhat>
 <15b9df26-bdc1-e139-8df7-62f966c719ed@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15b9df26-bdc1-e139-8df7-62f966c719ed@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 12:42:13PM +0300, Arseniy Krasnov wrote:
>
>
>On 10.03.2023 12:09, Stefano Garzarella wrote:
>> Hi Arseniy,
>>
>> On Thu, Mar 09, 2023 at 11:24:42PM +0300, Arseniy Krasnov wrote:
>>> Hello,
>>>
>>> this patchset evolved from previous v2 version (see link below). It does
>>> several updates to virtio/vsock:
>>> 1) Changes 'virtio_transport_inc/dec_rx_pkt()' interface. Now instead of
>>>   using skbuff state ('head' and 'data' pointers) to update 'fwd_cnt'
>>>   and 'rx_bytes', integer value is passed as an input argument. This
>>>   makes code more simple, because in this case we don't need to update
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
>>
>> thanks for the fixes, I would wait a few days to see if there are any
>> comments and then I think you can send it on net without RFC.
>>
>> @Bobby if you can take a look, your ack would be appreciated :-)
>Ok, thanks for review. I'll wait for several days and also wait until
>net-next will be opened. Then i'll resend this patchset with net-next

Since they are fixes, they should go with the net tree, not net-next.

Cheers,
Stefano

