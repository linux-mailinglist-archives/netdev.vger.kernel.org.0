Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F781642924
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiLENSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiLENRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:17:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B7B1C105
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 05:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670246206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DO8SJNUghVVw6i+5wKTtjH6tRTTOZjv69W3dDMY1mWw=;
        b=B9VCNdCC82mB4LencUq1jnmS7e9OzHBkDOh8mmuMNPqHvxrvuFU7t4+B0/t4GLCRjOJoHB
        8ToApV1nmgSY39cc5GgTEjr0fCNhx1ZX5FIouXEl+c+hLZDXEp2Vclvf9bZhBd9xtUdFDW
        Y3J8xD+gJAHyCWPQUvUDbeJSXE7YSwE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-57-FrSEXCbbP5CjRjiDxRB7vQ-1; Mon, 05 Dec 2022 08:16:43 -0500
X-MC-Unique: FrSEXCbbP5CjRjiDxRB7vQ-1
Received: by mail-wr1-f69.google.com with SMTP id i25-20020adfaad9000000b002426945fa63so450618wrc.6
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 05:16:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DO8SJNUghVVw6i+5wKTtjH6tRTTOZjv69W3dDMY1mWw=;
        b=qiUJb1YdD9qXuUwBKjgrRfSknUc1nglpcKgCTn9njnSepynGL9IsuoIlw0peOiE23d
         aZZxDhztzHL8Z+wMrQfxGjUwrY5rxrOxz5k+JAl8fYflUIq9WuELxK/ruaq5k3kJNDEn
         RUzMnjzgKeht0Mo96x/J15UeMLjQW/J/kWkis95Bqo6AF75OK0TlyZ813TGXy+nA6TmQ
         1/NMhz3FxQe+1PgpsVIfJv//miN9PcqTVz7f4vMJT7GXGqhdLFWgYNUs2fT6l0Av9uMD
         BXtqkflL2jCObbj26q7XC4GtCRFACXrlNi75hZekm1Ms5UeaJ1svo6oF24cpFmQ2CIbk
         fcbA==
X-Gm-Message-State: ANoB5pn4ieLfQCWteCKiiwfXB0Z+RuVD8PpJ+2xP9SO0UIRBZNUW8G9/
        VQTnu3IjRa0Nhx45ycj4O2+l/gEG32IUcWEdnxOBZhXYPngNKCfCF/KzQpRloh25uyJrDnHlMAW
        IW4G3zAPrI7As2tU6
X-Received: by 2002:a05:600c:4f83:b0:3cf:8b32:a52 with SMTP id n3-20020a05600c4f8300b003cf8b320a52mr65013334wmq.72.1670246201983;
        Mon, 05 Dec 2022 05:16:41 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5dHQeZqTtLmzELyCvm4sexqKq5GSBWNyWh4RYxCnvNU/SWwzywpUQAkj8otDW6yIuu0Vwtdw==
X-Received: by 2002:a05:600c:4f83:b0:3cf:8b32:a52 with SMTP id n3-20020a05600c4f8300b003cf8b320a52mr65013316wmq.72.1670246201772;
        Mon, 05 Dec 2022 05:16:41 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id d10-20020adffbca000000b002366f9bd717sm17153303wrs.45.2022.12.05.05.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 05:16:41 -0800 (PST)
Date:   Mon, 5 Dec 2022 14:16:38 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 1/4] vsock: return errors other than -ENOMEM to
 socket
Message-ID: <20221205131638.7ymjzijkqlrimzqg@sgarzare-redhat>
References: <6bd77692-8388-8693-f15f-833df1fa6afd@sberdevices.ru>
 <b9ea0ff4-3aef-030e-0a9b-e2fcb67b305b@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b9ea0ff4-3aef-030e-0a9b-e2fcb67b305b@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 07:19:20PM +0000, Arseniy Krasnov wrote:
>From: Bobby Eshleman <bobby.eshleman@bytedance.com>
>
>This removes behaviour, where error code returned from any
>transport was always switched to ENOMEM.

I would add here the example you described in the cover letter with 
EMSGSIZE, so the problem is better explained.

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

