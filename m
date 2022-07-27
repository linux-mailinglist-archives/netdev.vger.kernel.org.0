Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4159F5826C5
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiG0MhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiG0MhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:37:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5408632D9D
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658925438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4LWH5gfewkP2m9y0QehAONnCxfwoC2hdUW6P/cyixj4=;
        b=MpFDnMIn5YsixoYMfxydyZGmBOrW4acAfgOaEv/w7cUB4HilrTkHDxInljKQG+KzbfnDg1
        mcPVOi91/ny6hRF/ehyVt/wbI2zy9Mdhx4jptMbCscUIrUgw60D4w3wmjWqtTaVee1vrNL
        qqeV07Zg2Prh3xrEROr6oXTEjaAq/ME=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-l7HIVSKKPzaquBRTxSSJlQ-1; Wed, 27 Jul 2022 08:37:17 -0400
X-MC-Unique: l7HIVSKKPzaquBRTxSSJlQ-1
Received: by mail-wr1-f71.google.com with SMTP id u17-20020adfa191000000b0021ed2209fccso322081wru.16
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4LWH5gfewkP2m9y0QehAONnCxfwoC2hdUW6P/cyixj4=;
        b=fTSavFzWnhA2YBUST+GWA5bMokxWOgnBmOCH8Fce2PoGQJxiCfMsT3osJFiRlF23zb
         3jSrzbYEaf2gdGorPDpdE6yF3ItRk3wmLtiGZl8iIJb0wWgkLEK68iwfRY3XVaW1d0ZE
         L7cDHWz/Ng1HZ/DqfMPUAIvYO89JPU+E/QC+ekVD5C9qxi1ZusXuJOg0wmRbBGZCtoXg
         EGmJg9Y0NL8HSKgKLQnnnPuHj7+nA3f/uIXGJQxa0jUGGO/BMFgNAtjIAv5qrWpECNlx
         A0pWyyO9mPmGeVWtwVV/YlD+2V8Y1jwjXkAKD5EDv6Wv/Xd2C9KZAw+Py/k94/nvpqP3
         R/zA==
X-Gm-Message-State: AJIora+Uu8ncS0TK1QS5/YOL0SMMFg7Kf+Wum0CMO2rdcB3a7aGQaK1V
        eRFKVz3C5yjhXMNzlYYBLAcgxh945f7reXzh28pSIQ4UZGUdSbF5JI7XO8UhGjKV17whAB/cNFN
        RUtUI05aGSv1JhU2M
X-Received: by 2002:adf:d1e8:0:b0:21d:ac9c:983d with SMTP id g8-20020adfd1e8000000b0021dac9c983dmr13770276wrd.629.1658925436043;
        Wed, 27 Jul 2022 05:37:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vJrWqBiaq6uBMB03xiUMkRFhOPCI0fFvUqiEuTuZWyTbuHIhoAAyTdDFMM07jJhUESZdjGNg==
X-Received: by 2002:adf:d1e8:0:b0:21d:ac9c:983d with SMTP id g8-20020adfd1e8000000b0021dac9c983dmr13770264wrd.629.1658925435819;
        Wed, 27 Jul 2022 05:37:15 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id u9-20020adff889000000b0020fcaba73bcsm16755266wrp.104.2022.07.27.05.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 05:37:15 -0700 (PDT)
Date:   Wed, 27 Jul 2022 14:37:10 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 0/9] vsock: updates for SO_RCVLOWAT handling
Message-ID: <20220727123710.pwzy6ag3gavotxda@sgarzare-redhat>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseniy,

On Mon, Jul 25, 2022 at 07:54:05AM +0000, Arseniy Krasnov wrote:
>Hello,
>
>This patchset includes some updates for SO_RCVLOWAT:
>
>1) af_vsock:
>   During my experiments with zerocopy receive, i found, that in some
>   cases, poll() implementation violates POSIX: when socket has non-
>   default SO_RCVLOWAT(e.g. not 1), poll() will always set POLLIN and
>   POLLRDNORM bits in 'revents' even number of bytes available to read
>   on socket is smaller than SO_RCVLOWAT value. In this case,user sees
>   POLLIN flag and then tries to read data(for example using  'read()'
>   call), but read call will be blocked, because  SO_RCVLOWAT logic is
>   supported in dequeue loop in af_vsock.c. But the same time,  POSIX
>   requires that:
>
>   "POLLIN     Data other than high-priority data may be read without
>               blocking.
>    POLLRDNORM Normal data may be read without blocking."
>
>   See https://www.open-std.org/jtc1/sc22/open/n4217.pdf, page 293.
>
>   So, we have, that poll() syscall returns POLLIN, but read call will
>   be blocked.
>
>   Also in man page socket(7) i found that:
>
>   "Since Linux 2.6.28, select(2), poll(2), and epoll(7) indicate a
>   socket as readable only if at least SO_RCVLOWAT bytes are available."
>
>   I checked TCP callback for poll()(net/ipv4/tcp.c, tcp_poll()), it
>   uses SO_RCVLOWAT value to set POLLIN bit, also i've tested TCP with
>   this case for TCP socket, it works as POSIX required.
>
>   I've added some fixes to af_vsock.c and virtio_transport_common.c,
>   test is also implemented.
>
>2) virtio/vsock:
>   It adds some optimization to wake ups, when new data arrived. Now,
>   SO_RCVLOWAT is considered before wake up sleepers who wait new data.
>   There is no sense, to kick waiter, when number of available bytes
>   in socket's queue < SO_RCVLOWAT, because if we wake up reader in
>   this case, it will wait for SO_RCVLOWAT data anyway during dequeue,
>   or in poll() case, POLLIN/POLLRDNORM bits won't be set, so such
>   exit from poll() will be "spurious". This logic is also used in TCP
>   sockets.

Nice, it looks good!

>
>3) vmci/vsock:
>   Same as 2), but i'm not sure about this changes. Will be very good,
>   to get comments from someone who knows this code.

I CCed VMCI maintainers to the patch and also to this cover, maybe 
better to keep them in the loop for next versions.

(Jorgen's and Rajesh's emails bounced back, so I'm CCing here only 
Bryan, Vishnu, and pv-drivers@vmware.com)

>
>4) Hyper-V:
>   As Dexuan Cui mentioned, for Hyper-V transport it is difficult to
>   support SO_RCVLOWAT, so he suggested to disable this feature for
>   Hyper-V.

I left a couple of comments in some patches, but it seems to me to be in 
a good state :-)

I would just suggest a bit of a re-organization of the series (the 
patches are fine, just the order):
   - introduce vsock_set_rcvlowat()
   - disabling it for hv_sock
   - use 'target' in virtio transports
   - use 'target' in vmci transports
   - use sock_rcvlowat in vsock_poll()
     I think is better to pass sock_rcvlowat() as 'target' when the
     transports are already able to use it
   - add vsock_data_ready()
   - use vsock_data_ready() in virtio transports
   - use vsock_data_ready() in vmci transports
   - tests

What do you think?

Thanks,
Stefano

