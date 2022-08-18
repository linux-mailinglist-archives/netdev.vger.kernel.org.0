Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A089597D93
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 06:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243386AbiHREee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 00:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241103AbiHREec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 00:34:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1261B558D6
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 21:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660797269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TTFivvm9yHWKcVUkneavFwNxYuu+2L1pR/LF0ZMw4pU=;
        b=Fr+5mVDFc6LZbisV7Pkoxe+7Id8XPzsSrL7mH+ZR2pUkyhyHpQ/ZnVs/3S0zkMlHAsD+88
        MBokZIq1HBpPpX0MXSVDAx+4GZGmIEgo1zW//MMmbqf968tKNt5xS7RrzjqGKvGuXsSP2D
        caZ+szDtEBQ7v4LRoTtjvp/p5OqV4lc=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-511-vnv7PKT4OaOfO_7Bwp-kNA-1; Thu, 18 Aug 2022 00:34:28 -0400
X-MC-Unique: vnv7PKT4OaOfO_7Bwp-kNA-1
Received: by mail-pg1-f198.google.com with SMTP id e187-20020a6369c4000000b0041c8dfb8447so264885pgc.23
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 21:34:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=TTFivvm9yHWKcVUkneavFwNxYuu+2L1pR/LF0ZMw4pU=;
        b=i30RxUBQxD5zQydbrSpqCjyEx3CsW0RvOE1QTZEdPzSn2G+izR2yChMhix/Ze69Fx+
         qzkCCl1v739iM1v6uRjqBeLcBiFtzupiPnMkVDyKjtAxe9U86F5uxxQNeQYTa/UJeFr6
         UNKJZ6Ov3BzYOe3yEuO+BcpbKXzHKGslOF85tx817jAFAXS9trfin3ek9nPMGwLa38T5
         k0vc8xjgibllT/O8XGoYXx3JjuXnEpPdKcD7xKypmFVKI9HgPnwSZ/iKXVPUiOznhn2L
         IPDEo2Q0/GdpTkotEO5+Pdva5nQaPRPvs7Qv7qusEkPROFIovk0wd2lCmHX/vt8Rvggo
         bkkg==
X-Gm-Message-State: ACgBeo2hp6n/E1joE5Masv+xADGNrxD47MlxB62Sxi7GejGWacO/+8zn
        6AcXOcTuW+lVo6/4GojozUIddteiIegRWbxT4L7n4v5juSEwHiuj34OWNuIT2RrGDvECmgG3z0N
        FMLCZkHLJbRpOhPUX
X-Received: by 2002:a63:8848:0:b0:41c:45da:2db9 with SMTP id l69-20020a638848000000b0041c45da2db9mr1153072pgd.206.1660797267584;
        Wed, 17 Aug 2022 21:34:27 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7J3KtemYhLGoQErkrW2ImQSRRyS97OCrKf8dXjnhmz4oWC74Pc+PzZXQUPK8eeQKBWL8Ujlw==
X-Received: by 2002:a63:8848:0:b0:41c:45da:2db9 with SMTP id l69-20020a638848000000b0041c45da2db9mr1153060pgd.206.1660797267343;
        Wed, 17 Aug 2022 21:34:27 -0700 (PDT)
Received: from [10.72.13.223] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m11-20020a170902db0b00b001637529493esm299625plx.66.2022.08.17.21.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 21:34:26 -0700 (PDT)
Message-ID: <2747ac1f-390e-99f9-b24e-f179af79a9da@redhat.com>
Date:   Thu, 18 Aug 2022 12:34:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH 3/6] vsock: add netdev to vhost/virtio vsock
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com>
 <20220816123701-mutt-send-email-mst@kernel.org>
 <20220816110717.5422e976@kernel.org> <YvtAktdB09tM0Ykr@bullseye>
 <20220816160755.7eb11d2e@kernel.org> <YvtVN195TS1xpEN7@bullseye>
 <20220816181528.5128bc06@kernel.org> <Yvt2f5i5R9NNNYUL@bullseye>
 <20220817131437-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220817131437-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/8/18 01:20, Michael S. Tsirkin 写道:
> On Tue, Aug 16, 2022 at 10:50:55AM +0000, Bobby Eshleman wrote:
>>>>> Eh, I was hoping it was a side channel of an existing virtio_net
>>>>> which is not the case. Given the zero-config requirement IDK if
>>>>> we'll be able to fit this into netdev semantics :(
>>>> It's certainly possible that it may not fit :/ I feel that it partially
>>>> depends on what we mean by zero-config. Is it "no config required to
>>>> have a working socket" or is it "no config required, but also no
>>>> tuning/policy/etc... supported"?
>>> The value of tuning vs confusion of a strange netdev floating around
>>> in the system is hard to estimate upfront.
>> I think "a strange netdev floating around" is a total
>> mischaracterization... vsock is a networking device and it supports
>> vsock networks. Sure, it is a virtual device and the routing is done in
>> host software, but the same is true for virtio-net and VM-to-VM vlan.
>>
>> This patch actually uses netdev for its intended purpose: to support and
>> manage the transmission of packets via a network device to a network.
>>
>> Furthermore, it actually prepares vsock to eliminate a "strange" use of
>> a netdev. The netdev in vsockmon isn't even used to transmit
>> packets, it's "floating around" for no other reason than it is needed to
>> support packet capture, which vsock couldn't support because it didn't
>> have a netdev.
>>
>> Something smells when we are required to build workaround kernel modules
>> that use netdev for ciphoning packets off to userspace, when we could
>> instead be using netdev for its intended purpose and get the same and
>> more benefit.
> So what happens when userspace inevitably attempts to bind a raw
> packet socket to this device? Assign it an IP? Set up some firewall
> rules?
>
> These things all need to be addressed before merging since they affect UAPI.


It's possible if

1) extend virtio-net to have vsock queues

2) present vsock device on top of virtio-net via e.g auxiliary bus

Then raw socket still work at ethernet level while vsock works too.

The value is to share codes between the two type of devices (queues).

Thanks


>
>>> The nice thing about using a built-in fq with no user visible knobs is
>>> that there's no extra uAPI. We can always rip it out and replace later.
>>> And it shouldn't be controversial, making the path to upstream smoother.
>> The issue is that after pulling in fq for one kind of flow management,
>> then as users observe other flow issues, we will need to re-implement
>> pfifo, and then TBF, and then we need to build an interface to let users
>> select one, and to choose queue sizes... and then after awhile we've
>> needlessly re-implemented huge chunks of the tc system.
>>
>> I don't see any good reason to restrict vsock users to using suboptimal
>> and rigid queuing.
>>
>> Thanks.

