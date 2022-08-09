Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C5F58D714
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 12:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238261AbiHIKEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 06:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240472AbiHIKEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 06:04:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61967237FC
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 03:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660039448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tqwZLW2Fem8FvBOvg9FQMP8N9BRJ6oVlzGNZR0lXrSk=;
        b=eWj8M0ckdk7oOM5dC5wLX+d7pNVkCsn/R3w3TVKWnkRoi6Vgu1eWMn4iHfRZtsmTpllBV3
        SNZGtDgwe6EPTsOq9+KiE8Utk/0mDDlbb/TcJ3LjB/HpV/1FGHI8MRwZ/vJws0TMLOocps
        RR7f3GKFGXd1BbxtP8CGe4h/xtDGWRs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-HblY_ZqcONWOUL3Jn9DtaA-1; Tue, 09 Aug 2022 06:04:06 -0400
X-MC-Unique: HblY_ZqcONWOUL3Jn9DtaA-1
Received: by mail-wm1-f71.google.com with SMTP id 9-20020a1c0209000000b003a53ae8015bso2647023wmc.1
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 03:04:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tqwZLW2Fem8FvBOvg9FQMP8N9BRJ6oVlzGNZR0lXrSk=;
        b=YPIuABW3F7sqseX62j0BG77+Pq0lkYlPH0qB55191Z0RJjYF6Y/yIig1l0fu3xtSNW
         A4qrGcUDR17VMVyfgY8uy04LZoIb3uAcRFxd5bIDvdeMC5fr6oQXtGsykZIE5iFSMsYq
         EmiPH6X2kIN6G08UzDPOFYd6zgyv34KXjTWPRAckQD1Y6HMYXmFsYwS14Y4xtF3jyGnA
         dE/Dq8UAuynO2/c87u4DVcwEMHjXNjUo+N6h+Eg6C8+RLQOqZjXIjq9kaihAh9AkYYeg
         LEBzi83M/OWj5anJS1FWJG0ilwu0Pe+OaE4IX+Ini7kVEFjD8G2IcDgdxdyHQ0DmwxwC
         lVgg==
X-Gm-Message-State: ACgBeo1mRQeFhCepEWvYNHGMooXlDPwTHdvuqtupnahq0XvlBhFpFhYW
        zQEQYN/Bvw7o44qg209hgq2PZWupynGCaxUhwUsUC6FZx32YlwFcis6eBOi0ou3mQ6aD9UHbZr8
        X1Qq+5e2xRtDPEgJp
X-Received: by 2002:a05:600c:1993:b0:3a4:c0a9:5b6f with SMTP id t19-20020a05600c199300b003a4c0a95b6fmr15391377wmq.79.1660039445359;
        Tue, 09 Aug 2022 03:04:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6taqzhXrMpiY1ysC8UKte8WpDJhOBHgg7RESz57wiGmZKP/VeUv2yUUPkbkdIoRGdGpgbj7g==
X-Received: by 2002:a05:600c:1993:b0:3a4:c0a9:5b6f with SMTP id t19-20020a05600c199300b003a4c0a95b6fmr15391348wmq.79.1660039445062;
        Tue, 09 Aug 2022 03:04:05 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id ck15-20020a5d5e8f000000b002205f0890eesm13761940wrb.77.2022.08.09.03.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 03:04:03 -0700 (PDT)
Date:   Tue, 9 Aug 2022 12:03:58 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 1/9] vsock: SO_RCVLOWAT transport set callback
Message-ID: <20220809100358.xnxromtvrehsgpn3@sgarzare-redhat>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <45822644-8e37-1625-5944-63fd5fc20dd3@sberdevices.ru>
 <20220808102335.nkviqobpgcmcaqhn@sgarzare-redhat>
 <CAGxU2F513N+0sB0fEz4EF7+NeELhW9w9Rk6hh5K7QQO+eXRymA@mail.gmail.com>
 <1ea271c1-d492-d7f7-5016-7650a72b6139@sberdevices.ru>
 <d9bd1c16-7096-d267-a0ff-d3742b0dcf56@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d9bd1c16-7096-d267-a0ff-d3742b0dcf56@sberdevices.ru>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 09, 2022 at 09:45:47AM +0000, Arseniy Krasnov wrote:
>On 09.08.2022 12:37, Arseniy Krasnov wrote:
>> On 08.08.2022 13:30, Stefano Garzarella wrote:
>>> On Mon, Aug 8, 2022 at 12:23 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>>
>>>> On Wed, Aug 03, 2022 at 01:51:05PM +0000, Arseniy Krasnov wrote:
>>>>> This adds transport specific callback for SO_RCVLOWAT, because in some
>>>>> transports it may be difficult to know current available number of bytes
>>>>> ready to read. Thus, when SO_RCVLOWAT is set, transport may reject it.
>>>>>
>>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>>> ---
>>>>> include/net/af_vsock.h   |  1 +
>>>>> net/vmw_vsock/af_vsock.c | 25 +++++++++++++++++++++++++
>>>>> 2 files changed, 26 insertions(+)
>>>>>
>>>>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>>>> index f742e50207fb..eae5874bae35 100644
>>>>> --- a/include/net/af_vsock.h
>>>>> +++ b/include/net/af_vsock.h
>>>>> @@ -134,6 +134,7 @@ struct vsock_transport {
>>>>>       u64 (*stream_rcvhiwat)(struct vsock_sock *);
>>>>>       bool (*stream_is_active)(struct vsock_sock *);
>>>>>       bool (*stream_allow)(u32 cid, u32 port);
>>>>> +      int (*set_rcvlowat)(struct vsock_sock *, int);
>>>>
>>>> checkpatch suggests to add identifier names. For some we put them in,
>>>> for others we didn't, but I suggest putting them in for the new ones
>>>> because I think it's clearer too.
>>>>
>>>> WARNING: function definition argument 'struct vsock_sock *' should also
>>>> have an identifier name
>>>> #25: FILE: include/net/af_vsock.h:137:
>>>> +       int (*set_rcvlowat)(struct vsock_sock *, int);
>>>>
>>>> WARNING: function definition argument 'int' should also have an identifier name
>>>> #25: FILE: include/net/af_vsock.h:137:
>>>> +       int (*set_rcvlowat)(struct vsock_sock *, int);
>>>>
>>>> total: 0 errors, 2 warnings, 0 checks, 44 lines checked
>>>>
>>>>>
>>>>>       /* SEQ_PACKET. */
>>>>>       ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>>> index f04abf662ec6..016ad5ff78b7 100644
>>>>> --- a/net/vmw_vsock/af_vsock.c
>>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>>> @@ -2129,6 +2129,30 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>>>>>       return err;
>>>>> }
>>>>>
>>>>> +static int vsock_set_rcvlowat(struct sock *sk, int val)
>>>>> +{
>>>>> +      const struct vsock_transport *transport;
>>>>> +      struct vsock_sock *vsk;
>>>>> +      int err = 0;
>>>>> +
>>>>> +      vsk = vsock_sk(sk);
>>>>> +
>>>>> +      if (val > vsk->buffer_size)
>>>>> +              return -EINVAL;
>>>>> +
>>>>> +      transport = vsk->transport;
>>>>> +
>>>>> +      if (!transport)
>>>>> +              return -EOPNOTSUPP;
>>>>
>>>> I don't know whether it is better in this case to write it in
>>>> sk->sk_rcvlowat, maybe we can return EOPNOTSUPP only when the trasport
>>>> is assigned and set_rcvlowat is not defined. This is because usually the
>>>> options are set just after creation, when the transport is practically
>>>> unassigned.
>>>>
>>>> I mean something like this:
>>>>
>>>>          if (transport) {
>>>>                  if (transport->set_rcvlowat)
>>>>                          return transport->set_rcvlowat(vsk, val);
>>>>                  else
>>>>                          return -EOPNOTSUPP;
>>>>          }
>>>>
>>>>          WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
>>>>
>>>>          return 0;
>>>
>>> Since hv_sock implements `set_rcvlowat` to return EOPNOTSUPP. maybe we
>>> can just do the following:
>>>
>>>         if (transport && transport->set_rcvlowat)
>>>                 return transport->set_rcvlowat(vsk, val);
>>>
>>>         WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
>>>         return 0;
>>>
>>> That is, the default behavior is to set sk->sk_rcvlowat, but for
>>> transports that want a different behavior, they need to define
>>> set_rcvlowat() (like hv_sock).
>> Hm ok, i see. I've implemented logic when non-empty transport is required, because hyperv transport
>> forbids to set SO_RCVLOWAT, so user needs to call this setsockopt AFTER transport is assigned(to check
>> that transport allows it. Not after socket creation as You mentioned above). Otherwise there is no sense
>> in such callback - it will be never used. Also in code above - for hyperv we will have different behavior
>> depends on when set_rcvlowat is called: before or after transport assignment. Is it ok?
>sorry, i mean: for hyperv, if user sets sk_rcvlowat before transport is assigned, it sees 0 - success, but in fact
>hyperv transport forbids this option.

I see, but I think it's better to set it and not respect in hyperv (as 
we've practically done until now with all transports) than to prevent 
the setting until we assign a transport.

At most when we use hyperv anyway we get notified per byte, so we should 
just get more notifications than we expect.

Thanks,
Stefano

