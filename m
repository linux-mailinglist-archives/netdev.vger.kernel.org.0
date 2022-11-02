Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEAD615FCE
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 10:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiKBJcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 05:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiKBJcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 05:32:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E2F12AD5
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 02:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667381505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FiXyFbNQfgw1EbxRUL2H94emHZF9fnomkSKKEY8Wyhw=;
        b=V7MrpPYaCoCQytswCrFkezV6dc19wkNirVYzr3S42jh/mvmaeyRWzgQBV/EKqodoivsRfC
        M/0lurqfsxhssyWjYte7ZzMXGPOOxP+s7bAmNYF5GPOIf3V8MrcklsYPmETs+5kn0YuO9w
        vX7mFc1Xqxb1NUp/taSkj35muy9a9FQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-235-Hx0Uqyg3N4i4fvq9CIgROg-1; Wed, 02 Nov 2022 05:31:44 -0400
X-MC-Unique: Hx0Uqyg3N4i4fvq9CIgROg-1
Received: by mail-qt1-f200.google.com with SMTP id b20-20020ac844d4000000b003a542f9de3dso1518179qto.7
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 02:31:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FiXyFbNQfgw1EbxRUL2H94emHZF9fnomkSKKEY8Wyhw=;
        b=0v/gndbfKAPN2ztiWhoI2yMXxBCEjoJg5qma/FjlPs6GqULLYfA3KK97OWDfRKrKL3
         MQROS97u5bxJsnNcoYROLAEA4gHiVE0mQdlyKRgpS63gqcL9rdRNBV5ztAURK94szm1u
         Bey4+ZbwhjAkLYP4FNF6mEiFruIAgid345eggr1y4ozSIzc4nZqETlqr1PhSzFbWd0Bf
         7czpNggtye6TNSBkgbekUSwK8bnZUgaeX4hwVGTd3JKQIK+dcTmK56m4KozeIOPa8zLY
         Kz6zZDhiQ9vXt5zx43LivFfWN6heN+yRrmwc2ps/0qoyKOIa5IKNBV8ubuqXoHuPRRkf
         0t0A==
X-Gm-Message-State: ACrzQf0K6gWlZ9Rg1c9zNEioQMr3PGBvwLZu9ov1fT4tKjLGx0Vpwyix
        CW08+1it7kpM051TfVYBS9CTccBqXZd1YAZnmIDRAG+ttsLlSwB3jPyIY41sdtTFyb2dePs8uA5
        M1Tcl4PGGFcpbfc6o
X-Received: by 2002:a0c:e2d4:0:b0:4bb:5902:922c with SMTP id t20-20020a0ce2d4000000b004bb5902922cmr20026051qvl.57.1667381504105;
        Wed, 02 Nov 2022 02:31:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7fwcDDdofDJz+WZYfF1ydzjXTJWpUN8/UcIhN3q3TEjSy7NElKUQE03Ks6CSlPZF4dfR2Qnw==
X-Received: by 2002:a0c:e2d4:0:b0:4bb:5902:922c with SMTP id t20-20020a0ce2d4000000b004bb5902922cmr20026034qvl.57.1667381503910;
        Wed, 02 Nov 2022 02:31:43 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id bs33-20020a05620a472100b006fa617ac616sm486080qkb.49.2022.11.02.02.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 02:31:43 -0700 (PDT)
Date:   Wed, 2 Nov 2022 10:31:37 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arseny.krasnov@kaspersky.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 2/2] vsock: fix possible infinite sleep in
 vsock_connectible_wait_data()
Message-ID: <20221102093137.2il5u7opfyddheis@sgarzare-redhat>
References: <20221101021706.26152-1-decui@microsoft.com>
 <20221101021706.26152-3-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221101021706.26152-3-decui@microsoft.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 07:17:06PM -0700, Dexuan Cui wrote:
>Currently vsock_connectible_has_data() may miss a wakeup operation
>between vsock_connectible_has_data() == 0 and the prepare_to_wait().
>
>Fix the race by adding the process to the wait queue before checking
>vsock_connectible_has_data().
>
>Fixes: b3f7fd54881b ("af_vsock: separate wait data loop")
>Signed-off-by: Dexuan Cui <decui@microsoft.com>
>---
>
>Changes in v2 (Thanks Stefano!):
>  Fixed a typo in the commit message.
>  Removed the unnecessary finish_wait() at the end of the loop.

LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
> net/vmw_vsock/af_vsock.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index d258fd43092e..884eca7f6743 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1905,8 +1905,11 @@ static int vsock_connectible_wait_data(struct sock *sk,
> 	err = 0;
> 	transport = vsk->transport;
>
>-	while ((data = vsock_connectible_has_data(vsk)) == 0) {
>+	while (1) {
> 		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
>+		data = vsock_connectible_has_data(vsk);
>+		if (data != 0)
>+			break;
>
> 		if (sk->sk_err != 0 ||
> 		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>-- 
>2.25.1
>

