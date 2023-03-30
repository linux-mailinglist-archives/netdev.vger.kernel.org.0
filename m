Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343FC6CFE0D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjC3IT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjC3IT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:19:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26716E90
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680164349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j6eqKpHQyukUldknWnkYJ906zqmkvEYnde83ajid2aw=;
        b=QY4LU/tTZkzcL2bXx+Wwpm3FjhKStiqSZDDn7o6ozNvBnmIVkpxcUnOjMkaZjTeQFcwMkt
        yWSL5UBdbcbRcy7Dj2GLW1K+Z30xuca7td2fvomar6IWABFNPBYLcLK3pyvAIqc+lxD/oE
        VcfPYoTDqpfRtbjtoixN2wAjHf1RO/0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-z5eeF-F_PxCZSPS5JHz4hA-1; Thu, 30 Mar 2023 04:19:07 -0400
X-MC-Unique: z5eeF-F_PxCZSPS5JHz4hA-1
Received: by mail-qt1-f197.google.com with SMTP id l13-20020a05622a174d00b003e4df699997so9749108qtk.20
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680164347;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6eqKpHQyukUldknWnkYJ906zqmkvEYnde83ajid2aw=;
        b=UL51qPUVLy8Pjaus0Z5XOGjGn5440zBV4YKLA2cl795iwDLnsJR2l9Q4cZdp85BVBm
         b8x/D1QgzLS33IbfmWAgByFNwoe459yi1W/IMZGogeO5JnYzX3P9smJy1H/ZDKYf0Rlt
         sxINz0q8/cFUmi+i+6h+MkuBSAEAfkeXiHdxCufqw1wx/4NeJvUIm1EfVMfFPwixtKcy
         SZlL3ZmpilkIwjRKckB/UIwSOoAQ8NMXMbBb8cjmiiSwsSbIbORFtNo8oD1J+StiM53i
         JOnkZ/rUqxnp7w7jAjpjyt80y9NoTfppPzyQx2VZJ+ugpzkKlDf7xi17Mtf2J/SbwzUF
         5gIw==
X-Gm-Message-State: AO0yUKVVa4nWm2BvebvnzG8JoTaatQq3GekzUx0lVoVh3N3jwT9Rq2mu
        9erSLHsovDqyy8yWHRSs56JByvMPJx/NdF68yA7BIDV7ExkeBUdLPZr9vJ4UaVQbGFFbuR7lBt8
        VoljFUhlnjGmCSOpC
X-Received: by 2002:ac8:5852:0:b0:3dd:f4cd:9457 with SMTP id h18-20020ac85852000000b003ddf4cd9457mr33846449qth.10.1680164347090;
        Thu, 30 Mar 2023 01:19:07 -0700 (PDT)
X-Google-Smtp-Source: AK7set9ZSR8zCgeepFuAa6Qdv4Dz8GV22rVmnZtGEo7xGCKbU5A+Z7X8US2CvtEhcqENxoJDdCpmFg==
X-Received: by 2002:ac8:5852:0:b0:3dd:f4cd:9457 with SMTP id h18-20020ac85852000000b003ddf4cd9457mr33846439qth.10.1680164346857;
        Thu, 30 Mar 2023 01:19:06 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-130.retail.telecomitalia.it. [82.57.51.130])
        by smtp.gmail.com with ESMTPSA id r14-20020ac867ce000000b003c034837d8fsm16827815qtp.33.2023.03.30.01.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 01:19:06 -0700 (PDT)
Date:   Thu, 30 Mar 2023 10:19:00 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>,
        Vishnu Dasa <vdasa@vmware.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, pv-drivers@vmware.com
Subject: Re: [RFC PATCH v2 2/3] vsock/vmci: convert VMCI error code to -ENOMEM
Message-ID: <wzkkagpfxfi7nioixpcmz4uscxojilwhuj4joslwevkm25m6h7@z4yl33oe7wqu>
References: <60abc0da-0412-6e25-eeb0-8e32e3ec21e7@sberdevices.ru>
 <94d33849-d3c1-7468-72df-f87f897bafd2@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <94d33849-d3c1-7468-72df-f87f897bafd2@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 10:07:36AM +0300, Arseniy Krasnov wrote:
>This adds conversion of VMCI specific error code to general -ENOMEM. It
>is needed, because af_vsock.c passes error value returned from transport
>to the user.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/vmci_transport.c | 19 ++++++++++++++++---
> 1 file changed, 16 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
>index 36eb16a40745..45de3e75597f 100644
>--- a/net/vmw_vsock/vmci_transport.c
>+++ b/net/vmw_vsock/vmci_transport.c
>@@ -1831,10 +1831,17 @@ static ssize_t vmci_transport_stream_dequeue(
> 	size_t len,
> 	int flags)
> {
>+	int err;

Please, use the same type returned by the function.

>+
> 	if (flags & MSG_PEEK)
>-		return vmci_qpair_peekv(vmci_trans(vsk)->qpair, msg, len, 0);
>+		err = vmci_qpair_peekv(vmci_trans(vsk)->qpair, msg, len, 0);
> 	else
>-		return vmci_qpair_dequev(vmci_trans(vsk)->qpair, msg, len, 0);
>+		err = vmci_qpair_dequev(vmci_trans(vsk)->qpair, msg, len, 0);
>+
>+	if (err < 0)
>+		err = -ENOMEM;
>+
>+	return err;
> }
>
> static ssize_t vmci_transport_stream_enqueue(
>@@ -1842,7 +1849,13 @@ static ssize_t vmci_transport_stream_enqueue(
> 	struct msghdr *msg,
> 	size_t len)
> {
>-	return vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
>+	int err;

Ditto.

>+
>+	err = vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
>+	if (err < 0)
>+		err = -ENOMEM;
>+
>+	return err;
> }

@Vishnu: should we backport the change for
vmci_transport_stream_enqueue() to stable branches?

In this case I would split this patch and I would send the
vmci_transport_stream_enqueue() change to the net branch including:

Fixes: c43170b7e157 ("vsock: return errors other than -ENOMEM to socket")

Thanks,
Stefano

