Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F506D4333
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjDCLQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjDCLQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:16:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A086E8D
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 04:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680520497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sl4rkdnr0o5W52X2aSuuGluJKvhKvYjxKheoSDXESvI=;
        b=HC53iE9lfa/a4g+NG7iR86i8p357Xec7RaJ/vqwIjS5aYFLduvk89sKL9isg/Br77nbw91
        PHFbQqwXGvqsNaA3y1l7aQfxqg45ilJz3NzjlfrtUpPzRbybZvCb35qT6ztYskiyVLgiDd
        8WhQwlvYXYXwD7CH3p2WzFD7/BoOUPI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-Wrf5A1-lNKqL79fqnQIm_A-1; Mon, 03 Apr 2023 07:14:56 -0400
X-MC-Unique: Wrf5A1-lNKqL79fqnQIm_A-1
Received: by mail-qk1-f197.google.com with SMTP id 72-20020a37064b000000b007467c5d3abeso12903885qkg.19
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 04:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680520495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sl4rkdnr0o5W52X2aSuuGluJKvhKvYjxKheoSDXESvI=;
        b=6nsqAeKfHgkfad3YiLOoT4i6wr2N4ymrZlNT3IrLcLF8X0C1dQQBDYkMX83rz2NVX4
         83iTn+VrkXlFb2CQcG1vWIm9EwstFDBongxrcSNMVDGy2mW89zhUhEdodPdslRhl/owE
         MgCojcgMRhFJazMPonsMqKYzbcL0IgAAGE9KvsbQJ8adoy6VkOGIxJR6gCJaRpAg50k7
         gYIXaIqKgE079YbrjAi2fSON9g+ObpOhYPY5ylzjEWbZdbAROQK7UFcFKKkG20LeoG5p
         hrhjdtPDo7vCSTsO0BJwGktVB9E9miDXh7lKflcBAtyXPiaqGQhLJ6c8Yk1eQRU4tixp
         6Prg==
X-Gm-Message-State: AAQBX9c+mMZip8YmZYwx52SUtysz2mn59aD5he2Jkpvoio/ShWGBDHQc
        vW4a66bAas+ZWbC5EEoqizJqo9RfD6prqXPkGwz1gK9edy/K6L4edxZ/7LJ4LKE+x0AlPPn+WSB
        Gl2Y3pqciEpblCpZ3
X-Received: by 2002:a05:622a:15ce:b0:3e6:3032:827b with SMTP id d14-20020a05622a15ce00b003e63032827bmr25440147qty.7.1680520495545;
        Mon, 03 Apr 2023 04:14:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350bdQmEU9WWUOrbzCJ+Bq0v8HXzqQQ+6ONbGa/DU8+jSLKW1/RzfPc/4ZJ/IS5EkzEjM/uHPCg==
X-Received: by 2002:a05:622a:15ce:b0:3e6:3032:827b with SMTP id d14-20020a05622a15ce00b003e63032827bmr25440112qty.7.1680520495295;
        Mon, 03 Apr 2023 04:14:55 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-130.retail.telecomitalia.it. [82.57.51.130])
        by smtp.gmail.com with ESMTPSA id 136-20020a37058e000000b00747d211536dsm2688864qkf.107.2023.04.03.04.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 04:14:54 -0700 (PDT)
Date:   Mon, 3 Apr 2023 13:14:49 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, pv-drivers@vmware.com
Subject: Re: [RFC PATCH v4 1/3] vsock/vmci: convert VMCI error code to
 -ENOMEM on receive
Message-ID: <djxa4zzfqu463t6rw3plwegghwmem36rue3czs7ype2xn3f6b7@65ly3ebfkt6w>
References: <5440aa51-8a6c-ac9f-9578-5bf9d66217a5@sberdevices.ru>
 <fb3308c0-4a7a-a0b0-dbfd-92e50985600e@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fb3308c0-4a7a-a0b0-dbfd-92e50985600e@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 09:15:49PM +0300, Arseniy Krasnov wrote:
>This adds conversion of VMCI specific error code to general -ENOMEM. It
>is preparation for the next patch, which changes af_vsock.c behaviour
>on receive to pass value returned from transport to the user.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
>---
> net/vmw_vsock/vmci_transport.c | 11 +++++++++--
> 1 file changed, 9 insertions(+), 2 deletions(-)

LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
>index 36eb16a40745..a5375c97f5b0 100644
>--- a/net/vmw_vsock/vmci_transport.c
>+++ b/net/vmw_vsock/vmci_transport.c
>@@ -1831,10 +1831,17 @@ static ssize_t vmci_transport_stream_dequeue(
> 	size_t len,
> 	int flags)
> {
>+	ssize_t err;
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
>-- 
>2.25.1
>

