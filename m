Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7F164B372
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 11:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbiLMKpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 05:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbiLMKpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 05:45:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEC163BE
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 02:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670928285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pMYwjIC6UHS7AUmMk2EC3pw2uQe+h6oRlfhlealRKwM=;
        b=Bd5Yv1V7MQ/yroSEfHX6Do2salJvpzv1HtZALSc6tyrZwtx7GvcabInIIV7f/tOqjX3asG
        l/eKRQbUwhtU4rrF7M8kEOxBGHDjTfsAUFiqdlPXmOCq27YwJTgKbO6WNJ7a0B9jyEY360
        MIco/XEJ5oWAFg7PVrkg9o8OhWoeUCA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-N6RKsmQ6NcSAr7VaeYhbDg-1; Tue, 13 Dec 2022 05:44:44 -0500
X-MC-Unique: N6RKsmQ6NcSAr7VaeYhbDg-1
Received: by mail-wm1-f72.google.com with SMTP id bg25-20020a05600c3c9900b003cf3ed7e27bso4636356wmb.4
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 02:44:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMYwjIC6UHS7AUmMk2EC3pw2uQe+h6oRlfhlealRKwM=;
        b=sPpvJ5lOdfkI0o78Zx5PMd56QKRBJmvtG9rRaLmyrylYuKh4ZrqqtkHCUdCSpdMMl2
         59EgKcJdLrdqiTdZWGSRNd1qRfVRBY7zrN1sFuJJN2JDnGUGw2V/WkrI9OwkZJRfspPf
         NIKnKUm+XEjmDKpDRj3YId8ibiH1Us+jzkdLNSXoJxGYOX1dW2U7yYI4AxMqXq3sp9OE
         L8KMzuvXIPjsAupMiPkXjIvJ1Hiwf9T2IBdmuhIE2qUTcRHiL5sBRoSukM3Cn8+nqmGm
         gT4eA+dFkH7a/dWWddT2+mt+jCBr/UY680fUM/ujWym07MgPY/KFmkcipsptREWNTigt
         g0xA==
X-Gm-Message-State: ANoB5pmFkmcVbhnw/e/sRg1Y2rbZxlTzT4X6jKTvHaJNJ0zC1Fmdaetb
        fO+ldH1QK3Dpvjm4sgDZFktkvZ4Rj7HZj7WDGnOCZMl3dUleilefd8fQjN3oJieNrRkP1fR283K
        VBKMm2gaZE3MfZuZI
X-Received: by 2002:a05:600c:1da2:b0:3cf:5fd2:87a0 with SMTP id p34-20020a05600c1da200b003cf5fd287a0mr14395233wms.40.1670928283202;
        Tue, 13 Dec 2022 02:44:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6fNK5scCDlhlIETzu6ffXOPOCbtR/s/QsA8Tjaa1BqGfXMLIjfHxR3Ilv8TxdOGnEeUVk8cA==
X-Received: by 2002:a05:600c:1da2:b0:3cf:5fd2:87a0 with SMTP id p34-20020a05600c1da200b003cf5fd287a0mr14395218wms.40.1670928282971;
        Tue, 13 Dec 2022 02:44:42 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c444a00b003cff309807esm13399985wmn.23.2022.12.13.02.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 02:44:42 -0800 (PST)
Date:   Tue, 13 Dec 2022 11:44:37 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v4 1/4] vsock: return errors other than -ENOMEM to
 socket
Message-ID: <20221213104437.llci2g7zbbffjfjo@sgarzare-redhat>
References: <6be11122-7cf2-641f-abd8-6e379ee1b88f@sberdevices.ru>
 <727f2c9e-a909-a3d3-c04f-a16529df7bb2@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <727f2c9e-a909-a3d3-c04f-a16529df7bb2@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 08:49:19PM +0000, Arseniy Krasnov wrote:
>From: Bobby Eshleman <bobby.eshleman@bytedance.com>
>
>This removes behaviour, where error code returned from any transport
>was always switched to ENOMEM. For example when user tries to send too
>big message via SEQPACKET socket, transport layers return EMSGSIZE, but
>this error code will be replaced to ENOMEM and returned to user.

Just a minor thing here, I would write
"this error code was always replaced with ENOMEM and returned to user"

To make it clearer that it was the previous behavior.

Anyway, the patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
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

