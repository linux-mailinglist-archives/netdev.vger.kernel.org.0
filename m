Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B58763EC30
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiLAJTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLAJTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:19:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7609756ECB
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669886298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vIuTEZiHlEaLkOOiRuwwN1u46N3S1zvX6DQsFHhXfNs=;
        b=apmj8t6mZssPErjBUa68EdwPlf9OZ62ORQDhjg1F8XDHjIlKGpjyLiA2iPYQcMAhn05IFi
        KUvjFRPV3EknCwadtqn2crOu/cxnCx9PeKHwDZddQotQNv27iSOciCHW9FXaMAnImE7EIv
        nXZRkyPkgk52DEXR/OHBjX3l5RX5MSw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-546-zDBy1ft0MRKqJEIwSw204Q-1; Thu, 01 Dec 2022 04:18:17 -0500
X-MC-Unique: zDBy1ft0MRKqJEIwSw204Q-1
Received: by mail-wm1-f71.google.com with SMTP id z18-20020a05600c221200b003cf7fcc286aso452271wml.1
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 01:18:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vIuTEZiHlEaLkOOiRuwwN1u46N3S1zvX6DQsFHhXfNs=;
        b=wPExP/bDf09gUhBYIU14ZHX1T90dDNqAdb+f08DlBvrn2/PUkUvhuvYYd8N9byeREn
         qdr6STLu4aDalEadMXPSlJNuBWdogNY/gwCZaEISth8uss8yvOLyroF0Ggn69VtnzDNj
         R8AfyyaS1aaER0q/qjR8bWKXr8LmtZ68eyv9bprgWg0AHUaBG1Oy+yMbG+q/cHbu0rtW
         A4db5VEMpMAfo4NzTHI8O7C7OYT5j7UqsYQ19bRM03H5cqHACxvbj2YKdrw/kZDvVKU6
         8ymT3BpDaeiOqNt+avhJRWtm0B1Y7yjmrVwhsVkdDiWukzbMHmrPiBKT6md2YcP7bmXN
         SA0A==
X-Gm-Message-State: ANoB5pmfdZcdcxUYbt8w2ypVIiP1qw48gaVCqNe3ancqYZiphUhTrPF0
        gyFxX4YmhqDE8yjoAZ+q3mCFfa5Ku5yxiZuTh77s0GbZ88A0fySkSZv3rWUY/qqre3eOho879Qt
        82KH5C8PAm3UDQxRv
X-Received: by 2002:a5d:5948:0:b0:241:e929:fc44 with SMTP id e8-20020a5d5948000000b00241e929fc44mr25586476wri.27.1669886296306;
        Thu, 01 Dec 2022 01:18:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf56QBIAqebrTf81srtx8Wms1KunBwXJwbQrplf/Bwb4UBr5M9FHfw01rhXcxCuBcF+looDkuA==
X-Received: by 2002:a5d:5948:0:b0:241:e929:fc44 with SMTP id e8-20020a5d5948000000b00241e929fc44mr25586457wri.27.1669886296097;
        Thu, 01 Dec 2022 01:18:16 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id n22-20020a7bc5d6000000b003c6c5a5a651sm4692542wmk.28.2022.12.01.01.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 01:18:15 -0800 (PST)
Date:   Thu, 1 Dec 2022 10:17:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 1/6] vsock: return errors other than -ENOMEM to
 socket
Message-ID: <20221201091722.p7fth4vkbbpq2zx4@sgarzare-redhat>
References: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
 <84f44358-dd8b-de8f-b782-7b6f03e0a759@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <84f44358-dd8b-de8f-b782-7b6f03e0a759@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 05:03:06PM +0000, Arseniy Krasnov wrote:
>From: Bobby Eshleman <bobby.eshleman@bytedance.com>
>
>This removes behaviour, where error code returned from any
>transport was always switched to ENOMEM.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)

This patch LGTM, but I would move after the 2 patches that change vmci 
and hyperv transports.

First we should fix the transports by returning the error we think is 
right, and then expose it to the user.

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 884eca7f6743..61ddab664c33 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1862,8 +1862,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 			written = transport->stream_enqueue(vsk,
> 					msg, len - total_written);
> 		}
>+
> 		if (written < 0) {
>-			err = -ENOMEM;
>+			err = written;
> 			goto out_err;
> 		}
>
>-- 
>2.25.1

