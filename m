Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9BD6131C9
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 09:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJaIiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 04:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJaIiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 04:38:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8772CCE0B
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 01:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667205429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g7Dq1aOGhSqbnLXSSpuWXNREMYffR0XtNShs/CkTqkk=;
        b=D6/Z5a026gLfys+dccFVPbixA22pLuKI7oRMgB+FoJvyWuAlgveYZ9qBlxhS0ljuT2jGl6
        2SIpIzfFPi8vd2BLVnlT82jMI0BrS5wb9XrMnEjjTN+tW1G3ly1uhflaumwuaNrDfeS13+
        nzhmhX3Fkg6OQDgZvdPLmZ4OE5N09a8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-628-0iV09aHfOYGoiI9MrhSgyw-1; Mon, 31 Oct 2022 04:37:07 -0400
X-MC-Unique: 0iV09aHfOYGoiI9MrhSgyw-1
Received: by mail-ed1-f70.google.com with SMTP id f16-20020a056402355000b00461cf923fdcso7271673edd.13
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 01:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7Dq1aOGhSqbnLXSSpuWXNREMYffR0XtNShs/CkTqkk=;
        b=AfNONiCi2avINyo+cfLgu4h++rZZeJMkrvKMRpL7idJuUfBgEJSKUVVuPiruXAfrLn
         UQ8epA5btNcBRUUDoIAQDWD/+sYVeg7qan1PliqI/JqN1Yxiu65Q6fLDpTmWe+66/e5J
         BLBH7T8EkeM4aSa/cleCAlz/Ec6+NpBwU+f4GiBweu/MvTSkuUn3sSc6h0Fw1XzKK/9V
         ABtvyJTMgwVi9IOPV7HLObVPvLpIDN5mjBrjTZrOw5Uxjk4NvmtqnplWxy8Am/RtyiHh
         nGjhAw52gaGbmTSl1GlZSE+RAtOW8AEtPIv/e+q41mLLBKnHZSHLxfsc6iOJ5zsUvAGs
         mq+w==
X-Gm-Message-State: ACrzQf3CrUnTKVseclJeVK8hBbX7zbBt5U0iL7YeVDswsvs+z821hnb4
        xmcnb+WwER/9JC+7YSadKELQ5TkA1MWbrsbPk3MxytU2zkxVf3XxxDQbxggrYAExTgbwuWqspV0
        KYJ95Fb83vfd/mRs1
X-Received: by 2002:a17:906:4795:b0:794:8b93:2e33 with SMTP id cw21-20020a170906479500b007948b932e33mr11943135ejc.265.1667205426653;
        Mon, 31 Oct 2022 01:37:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5uNSsXtfuDCxQDPjmlh78PdWRxENqpMT+1GcFwXzsCqnYJKcM79AP3wlMyFUJpg0Tdpzq1ow==
X-Received: by 2002:a17:906:4795:b0:794:8b93:2e33 with SMTP id cw21-20020a170906479500b007948b932e33mr11943114ejc.265.1667205426401;
        Mon, 31 Oct 2022 01:37:06 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id m24-20020aa7c2d8000000b0044dbecdcd29sm2909250edp.12.2022.10.31.01.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 01:37:06 -0700 (PDT)
Date:   Mon, 31 Oct 2022 09:37:04 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arseny.krasnov@kaspersky.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 1/2] vsock: remove the unused 'wait' in
 vsock_connectible_recvmsg()
Message-ID: <20221031083704.yqzz4qcrzbcqxbrw@sgarzare-redhat>
References: <20221028205646.28084-1-decui@microsoft.com>
 <20221028205646.28084-2-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221028205646.28084-2-decui@microsoft.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 01:56:45PM -0700, Dexuan Cui wrote:
>Remove the unused variable introduced by 19c1b90e1979.
>
>Fixes: 19c1b90e1979 ("af_vsock: separate receive data loop")
>Signed-off-by: Dexuan Cui <decui@microsoft.com>
>---
> net/vmw_vsock/af_vsock.c | 2 --
> 1 file changed, 2 deletions(-)

Good catch!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index ee418701cdee..d258fd43092e 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2092,8 +2092,6 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	const struct vsock_transport *transport;
> 	int err;
>
>-	DEFINE_WAIT(wait);
>-
> 	sk = sock->sk;
> 	vsk = vsock_sk(sk);
> 	err = 0;
>-- 
>2.25.1
>

