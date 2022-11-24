Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA244637D02
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiKXP3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiKXP3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:29:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4251121FA
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669303719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L0SFnyMJt/QKXqNsYANy2CzhozYJsECW+F48X0zh0KA=;
        b=eb7PO5YLQCURepXhnPjwhpLJ4pdGHi0tOnkjkTowEaXKNrgEqUwMfWyLzS6cnZ8QDzEPci
        eDPsY+QG/6WvEmLS/gaY2wFDg/1SPBFcxExeB+7fEc788tPcBDfPblrQkIYBcSf01QqCbh
        QerBGiwc9rKnKUOo2SOAiO9p/51lJyM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-363-WCq9gonYPLSI8JXBBgDqxA-1; Thu, 24 Nov 2022 10:28:35 -0500
X-MC-Unique: WCq9gonYPLSI8JXBBgDqxA-1
Received: by mail-wm1-f71.google.com with SMTP id az40-20020a05600c602800b003cfa26c40easo2967786wmb.1
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:28:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L0SFnyMJt/QKXqNsYANy2CzhozYJsECW+F48X0zh0KA=;
        b=LQRpDqmXLtBpKlQ6ZxwYhtrcYsA41RNkXJD6JkC1hefKgwYQ6WY/TyqWBH1UNTMtyP
         EaKRvm5p+46uDLJ+QCR2N1QHpaONnw5TfE/Ds+HepZTtGFP6wLlH1mkubJwiIg2zdN8d
         Musn48cGOIbyA53uYKlTnd0nczZENeTf8V56EXOrZlgRXjeXAFqMeNAGi4BYubkAq9hJ
         X3XVHgCk5kk2nBRg/x67dz3cieZHL0Ghr4hJFgS/DgO0TLC0kNgRM+Y3I2Y7JAFAtDLp
         pcAqLJLG2/+N2FFpLXS4boFO4TP44xLCNbPEu9FG0FgHbzOKbyKgDIa3YL+qeZWGer25
         HGZQ==
X-Gm-Message-State: ANoB5pmXotyad3XFUdhN6N9RL03q71w3NTMWMEKgBWQpkE3qb3fARHLN
        sPulZzL7ixdjvFor6yUHW/1aC0AYDto7edKjv522H9a8CYZsPe05eQj3QYTgYM7nbOPpYOOVl/H
        kX7Dvprr6tc97Ihz7
X-Received: by 2002:a05:600c:4f54:b0:3d0:2d56:eb55 with SMTP id m20-20020a05600c4f5400b003d02d56eb55mr9174228wmq.176.1669303713854;
        Thu, 24 Nov 2022 07:28:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7SFNvqeKEPdLoVnHkMNhD+pT2srs/vzS8vYQq70+XvhHxAMEBPydOx0THF/3kwewwS66ozzQ==
X-Received: by 2002:a05:600c:4f54:b0:3d0:2d56:eb55 with SMTP id m20-20020a05600c4f5400b003d02d56eb55mr9174213wmq.176.1669303713559;
        Thu, 24 Nov 2022 07:28:33 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id az26-20020a05600c601a00b003d01b84e9b2sm2207408wmb.27.2022.11.24.07.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 07:28:33 -0800 (PST)
Date:   Thu, 24 Nov 2022 16:28:30 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <oxffffaa@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, AVKrasnov@sberdevices.ru
Subject: Re: [PATCH v4] virtio/vsock: replace virtio_vsock_pkt with sk_buff
Message-ID: <20221124152830.6qhbgujs6ssw2pqx@sgarzare-redhat>
References: <20221124060750.48223-1-bobby.eshleman@bytedance.com>
 <20221124150005.vchk6ieoacrcu2gb@sgarzare-redhat>
 <03d74a68-91a3-04dd-613b-33e232937cbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03d74a68-91a3-04dd-613b-33e232937cbc@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 06:13:49PM +0300, Arseniy Krasnov wrote:
>Hello Stefano
>
>On 24.11.2022 18:00, Stefano Garzarella wrote:
>> This is a net-next material, please remember to use net-next tag:
>> https://www.kernel.org/doc/html/v6.0/process/maintainer-netdev.html#netdev-faq
>>
>> On Wed, Nov 23, 2022 at 10:07:49PM -0800, Bobby Eshleman wrote:
>>> This commit changes virtio/vsock to use sk_buff instead of
>>> virtio_vsock_pkt. Beyond better conforming to other net code, using
>>> sk_buff allows vsock to use sk_buff-dependent features in the future
>>> (such as sockmap) and improves throughput.
>>>
>>> This patch introduces the following performance changes:
>>>
>>> Tool/Config: uperf w/ 64 threads, SOCK_STREAM
>>> Test Runs: 5, mean of results
>>> Before: commit 95ec6bce2a0b ("Merge branch 'net-ipa-more-endpoints'")
>>>
>>> Test: 64KB, g2h
>>> Before: 21.63 Gb/s
>>> After: 25.59 Gb/s (+18%)
>>>
>>> Test: 16B, g2h
>>> Before: 11.86 Mb/s
>>> After: 17.41 Mb/s (+46%)
>>>
>>> Test: 64KB, h2g
>>> Before: 2.15 Gb/s
>>> After: 3.6 Gb/s (+67%)
>>>
>>> Test: 16B, h2g
>>> Before: 14.38 Mb/s
>>> After: 18.43 Mb/s (+28%)
>>>
>>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>>> ---
>>
>> The patch LGTM. I run several tests (iperf3, vsock_test,
>> vsock_diag_test, vhost-user-vsock, tcpdump) and IMO we are okay.
>>
>> I found the following problems that I would like to report:
>>
>> - vhost-user-vsock [1] is failing, but it is not an issue of this patch,
>>   but a spec violation in the rust-vmm/vm-virtio/virtio-vsock crate as I
>>   reported here [2]. We will fix it there, this patch is fine, indeed
>>   trying a guest with the new layout (1 descriptor for both header and
>>   data) with vhost-vsock in Linux 6.0, everything works perfectly.
>>
>> - the new "SOCK_SEQPACKET msg bounds" [3] reworked by Arseniy fails
>>   intermittently with this patch.
>>
>>   Using the tests currently in the kernel tree everything is fine, so
>>   I don't understand if it's a problem in the new test or in this
>>   patch. I've looked at the code again and don't seem to see any
>>   criticisms.
>>
>>   @Arseniy @Bobby can you take a look?
>Seems i've found this problem here:
>
>https://lkml.org/lkml/2022/11/24/708
>
>Being fixed - all tests passes

Good catch!

Thanks,
Stefano

