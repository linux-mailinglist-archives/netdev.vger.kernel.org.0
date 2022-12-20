Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5237651EF9
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 11:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbiLTKj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 05:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiLTKj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 05:39:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DEDBE3D
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 02:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671532714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pGyKBGNxgSsLzO3pKUHqDVQ10lAuvdMbzCBmDzDMwWg=;
        b=XcyauHfe71i4+bKomEIxCppm38XAShBaBPnIyYi/ddqjDNTuqh/Aj5YBol0aLR3trUg2Tb
        J+5K9Cvk6XnfUg1FW0bG6T6Mp+VKZpxu7Y53y8uKa5zB0vAZkOMKC3zVgI0NlecRxX3X6T
        FJLpHl9iXWgcfeySnAk+GHV8skLYFHE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-104-BbGS9WYoPO6cWFukKEQPSw-1; Tue, 20 Dec 2022 05:38:32 -0500
X-MC-Unique: BbGS9WYoPO6cWFukKEQPSw-1
Received: by mail-wm1-f70.google.com with SMTP id h64-20020a1c2143000000b003d65ff910e1so119878wmh.2
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 02:38:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGyKBGNxgSsLzO3pKUHqDVQ10lAuvdMbzCBmDzDMwWg=;
        b=wyPgjfmX+3IKRPS5I7GmdnG/k0odIVw57aM/mCIfq5BKV1zBZk7B/O9myD/9J4JqeZ
         lyhjDEp5Tn/Fi87r3aMXeKo91RjegG2ETJM/PPwEOSgULsBDwkajKkQaRgDbmj/EyE80
         c56vAzT6cmEr9mYydS6+qz/7fEfE2zuvxo04TYZwmLXAvNKefWPDZH4LsU9Tfi+XLIO8
         XKetKrzSjcRXxnlAdKh3+Ic83jUibC54S3BKu6CvFvLBHfApRamH5i9/rHUFg92occhB
         S+6u8KlNelaM5DlRGHbAAyVn7ok3UBrlrpY+De0p46g/yI/rWZcKVKdRdVuxi1Hdi7WT
         +Mbg==
X-Gm-Message-State: ANoB5plWRs07XC+ZTpnlkgkVaJ3o5Xj25AlCP/FWkvUb3gBsDH5y8vnH
        SeSfm/Y9teqEG4zySUmris3+4waMizzZVO+Try7ZUopmEVrAJP/HlmgpHvoOadqMbhMnhiNcFTv
        zOg5X9rkNyhmhy7BX
X-Received: by 2002:a5d:6a0c:0:b0:242:4bbe:2d20 with SMTP id m12-20020a5d6a0c000000b002424bbe2d20mr27326562wru.42.1671532710892;
        Tue, 20 Dec 2022 02:38:30 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6khTwIwEcU2qnc4GKFKF5TXghb3TA4wdU4AkUtOMeLLbU1Z1pmd4Etf27CLPRLnoQwbbImWA==
X-Received: by 2002:a5d:6a0c:0:b0:242:4bbe:2d20 with SMTP id m12-20020a5d6a0c000000b002424bbe2d20mr27326542wru.42.1671532710621;
        Tue, 20 Dec 2022 02:38:30 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id s13-20020a5d510d000000b00241e5b917d0sm14621347wrt.36.2022.12.20.02.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 02:38:30 -0800 (PST)
Date:   Tue, 20 Dec 2022 11:38:24 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v5 0/4] vsock: update tools and error handling
Message-ID: <20221220103824.w7xcwsg3o2mls7cs@sgarzare-redhat>
References: <e04f749e-f1a7-9a1d-8213-c633ffcc0a69@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e04f749e-f1a7-9a1d-8213-c633ffcc0a69@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 07:16:38AM +0000, Arseniy Krasnov wrote:
>Patchset consists of two parts:
>
>1) Kernel patch
>One patch from Bobby Eshleman. I took single patch from Bobby:
>https://lore.kernel.org/lkml/d81818b868216c774613dd03641fcfe63cc55a45
>.1660362668.git.bobby.eshleman@bytedance.com/ and use only part for
>af_vsock.c, as VMCI and Hyper-V parts were rejected.
>
>I used it, because for SOCK_SEQPACKET big messages handling was broken -
>ENOMEM was returned instead of EMSGSIZE. And anyway, current logic which
>always replaces any error code returned by transport to ENOMEM looks
>strange for me also(for example in EMSGSIZE case it was changed to
>ENOMEM).
>
>2) Tool patches
>Since there is work on several significant updates for vsock(virtio/
>vsock especially): skbuff, DGRAM, zerocopy rx/tx, so I think that this
>patchset will be useful.
>
>This patchset updates vsock tests and tools a little bit. First of all
>it updates test suite: two new tests are added. One test is reworked
>message bound test. Now it is more complex. Instead of sending 1 byte
>messages with one MSG_EOR bit, it sends messages of random length(one
>half of messages are smaller than page size, second half are bigger)
>with random number of MSG_EOR bits set. Receiver also don't know total
>number of messages. Message bounds control is maintained by hash sum
>of messages length calculation. Second test is for SOCK_SEQPACKET - it
>tries to send message with length more than allowed. I think both tests
>will be useful for DGRAM support also.
>
>Third thing that this patchset adds is small utility to test vsock
>performance for both rx and tx. I think this util could be useful as
>'iperf'/'uperf', because:
>1) It is small comparing to 'iperf' or 'uperf', so it very easy to add
>   new mode or feature to it(especially vsock specific).
>2) It allows to set SO_RCVLOWAT and SO_VM_SOCKETS_BUFFER_SIZE option.
>   Whole throughtput depends on both parameters.
>3) It is located in the kernel source tree, so it could be updated by
>   the same patchset which changes related kernel functionality in vsock.
>
>I used this util very often to check performance of my rx zerocopy
>support(this tool has rx zerocopy support, but not in this patchset).
>
>Here is comparison of outputs from three utils: 'iperf', 'uperf' and
>'vsock_perf'. In all three cases sender was at guest side. rx and
>tx buffers were always 64Kb(because by default 'uperf' uses 8K).
>
>iperf:
>
>   [ ID] Interval           Transfer     Bitrate
>   [  5]   0.00-10.00  sec  12.8 GBytes  11.0 Gbits/sec sender
>   [  5]   0.00-10.00  sec  12.8 GBytes  11.0 Gbits/sec receiver
>
>uperf:
>
>   Total     16.27GB /  11.36(s) =    12.30Gb/s       23455op/s
>
>vsock_perf:
>
>   tx performance: 12.301529 Gbits/s
>   rx performance: 12.288011 Gbits/s
>
>Results are almost same in all three cases.

Thanks for checking this!

>
>Patchset was rebased and tested on skbuff v8 patch from Bobby Eshleman:
>https://lore.kernel.org/netdev/20221215043645.3545127-1-bobby.eshleman@bytedance.com/

I reviewed all the patches, in the last one there is just to update the 
README, so I think it is ready for net-next (when it will re-open).

Thanks,
Stefano

