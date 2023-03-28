Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3856CBD54
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbjC1LUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjC1LUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:20:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0F01A7
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 04:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680002361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xTS3qxFhBqMP5asqq6o4vShlFpc+3Cgiy/wm+SvxL0Q=;
        b=E4nXNwQoeURnz5bknTQx7aZmKkHu4q8IaDd94j01/oc6/LC+ckUjHJejWhksCnmPW9ZipZ
        zDL6L2eHDiMfDcDddU1qAHG1xeAmNyhklNczvYYd6gWgsCyADc6O49+wK+PqOC0aBAglsz
        lxpIBPQtJR9TeUzOyb04iv4CPU84JCY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-P067p9ivOHe5PE5MHygbaw-1; Tue, 28 Mar 2023 07:19:20 -0400
X-MC-Unique: P067p9ivOHe5PE5MHygbaw-1
Received: by mail-qv1-f72.google.com with SMTP id w2-20020a0cc242000000b00583d8e55181so4845279qvh.23
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 04:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680002360;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTS3qxFhBqMP5asqq6o4vShlFpc+3Cgiy/wm+SvxL0Q=;
        b=ZJDPaYLzhKI/G4aV7NH+31IMsItd0cK5kie9QVOlAyj6p69mQGi/oAi3LgBAVP813p
         AtnJWmHRdpL3o0bpTz+VjWU6i9Kr9I4c72JDlANdRvi/djlE9t+k24ADFYT8CeRxsMX/
         8ZdB4pbOhGUykkxoaDNbEOTSLvxIWYwF3abgpTHmSCN0TIINxm9Lyem/E+0QEvbk/cZh
         ebKsuAUDlT5whi0A1VVxUtSiArddC0Gg7t3CPMp7JYZf/jFrRpw+Npel8F6Ak4m7mhx3
         GxLsMPL2uUYyxFdQUvp3HlT0/zcVaB4kWWdbG+Nipk39Q88Xb4yoCXxHpTNSXnOV+SSa
         vDGg==
X-Gm-Message-State: AO0yUKUCmAWthQ0uQTcHzguH4xLHRNduWKPhGSJVkk0HOyqMCHz2pQZ2
        11hqNfWJ+/vrP6WRQyP8NHkRTm5x6G61jk7ZGycl5SMjCRnGXVxCukRi0BI9yaO8hEFT9pcKhL1
        7fVyKY+U3gNuswgGQ
X-Received: by 2002:a05:622a:88:b0:3d8:3aed:66f4 with SMTP id o8-20020a05622a008800b003d83aed66f4mr26549977qtw.41.1680002359531;
        Tue, 28 Mar 2023 04:19:19 -0700 (PDT)
X-Google-Smtp-Source: AK7set9rLhqoc1M0lOv19pEk7kytc7wZbIHzVGbGY5clwetaWE5MDsGKBYhOBeIW8AABeuWV7JcagA==
X-Received: by 2002:a05:622a:88:b0:3d8:3aed:66f4 with SMTP id o8-20020a05622a008800b003d83aed66f4mr26549929qtw.41.1680002359066;
        Tue, 28 Mar 2023 04:19:19 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id v127-20020a379385000000b007456c75edbbsm17581456qkd.129.2023.03.28.04.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 04:19:18 -0700 (PDT)
Date:   Tue, 28 Mar 2023 13:19:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>,
        Vishnu Dasa <vdasa@vmware.com>
Cc:     Bryan Tan <bryantan@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 1/2] vsock: return errors other than -ENOMEM to
 socket
Message-ID: <ak74j6l2qesrixxmw7pfw56najqhdn32lv3xfxcb53nvmkyi3x@fr25vo2jlvbj>
References: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
 <99da938b-3e67-150c-2f74-41d917a95950@sberdevices.ru>
 <itjmw7vh3a7ggbodsu4mksu2hqbpdpxmu6cpexbra66nfhsw4x@hzpuzwldkfx5>
 <CAGxU2F648TyvAJN+Zk6YCnGUhn=0W_MZTox7RxQ45zHmHHO0SA@mail.gmail.com>
 <0f0a8603-e8a1-5fb2-23d9-5773c808ef85@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f0a8603-e8a1-5fb2-23d9-5773c808ef85@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 01:42:19PM +0300, Arseniy Krasnov wrote:
>
>
>On 28.03.2023 12:42, Stefano Garzarella wrote:
>> I pressed send too early...
>>
>> CCing Bryan, Vishnu, and pv-drivers@vmware.com
>>
>> On Tue, Mar 28, 2023 at 11:39 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>
>>> On Sun, Mar 26, 2023 at 01:13:11AM +0300, Arseniy Krasnov wrote:
>>>> This removes behaviour, where error code returned from any transport
>>>> was always switched to ENOMEM. This works in the same way as:
>>>> commit
>>>> c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
>>>> but for receive calls.
>>>>
>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>> ---
>>>> net/vmw_vsock/af_vsock.c | 4 ++--
>>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>> index 19aea7cba26e..9262e0b77d47 100644
>>>> --- a/net/vmw_vsock/af_vsock.c
>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>> @@ -2007,7 +2007,7 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>>>>
>>>>               read = transport->stream_dequeue(vsk, msg, len - copied, flags);
>>>
>>> In vmci_transport_stream_dequeue() vmci_qpair_peekv() and
>>> vmci_qpair_dequev() return VMCI_ERROR_* in case of errors.
>>>
>>> Maybe we should return -ENOMEM in vmci_transport_stream_dequeue() if
>>> those functions fail to keep the same behavior.
>
>Yes, seems i missed it, because several months ago we had similar question for send
>logic:
>https://www.spinics.net/lists/kernel/msg4611091.html
>And it was ok to not handle VMCI send path in this way. So i think current implementation
>for tx is a little bit buggy, because VMCI specific error from 'vmci_qpair_enquev()' is
>returned to af_vsock.c. I think error conversion must be added to VMCI transport for tx
>also.

Good point!

These are negative values, so there are no big problems, but I don't
know what the user expects in this case.

@Vishnu Do we want to return an errno to the user or a VMCI_ERROR_*?

In both cases I think we should do the same for both enqueue and
dequeue.

>
>Good thing is that Hyper-V uses general error codes.

Yeah!

Thanks,
Stefano

>
>Thanks, Arseniy
>>>
>>> CCing Bryan, Vishnu, and pv-drivers@vmware.com
>>>
>>> The other transports seem okay to me.
>>>
>>> Thanks,
>>> Stefano
>>>
>>>>               if (read < 0) {
>>>> -                      err = -ENOMEM;
>>>> +                      err = read;
>>>>                       break;
>>>>               }
>>>>
>>>> @@ -2058,7 +2058,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>>>       msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
>>>>
>>>>       if (msg_len < 0) {
>>>> -              err = -ENOMEM;
>>>> +              err = msg_len;
>>>>               goto out;
>>>>       }
>>>>
>>>> --
>>>> 2.25.1
>>>>
>>
>

