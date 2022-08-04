Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384435897F8
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 08:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238754AbiHDG7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 02:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiHDG7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 02:59:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ACDA15A16B
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 23:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659596369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ExEtxHMeVEdV8bG+hyv5znpbqanF/kL14mBYzm730MI=;
        b=KvaJG2fMx4mDJ0HUlkHDSpevIPET9ZFnaBd5b9N7Vt4VN3m0kQhB0ziQUiEkD6wJABkpuH
        x8iq42368YQaQzLcM0NaQPGeBgnqOu8Y8i2hDBRqqKtM/3Tog61wv+LpFcG3EVFCQY4URf
        GkYJvDUJPXNM8GibtKCRn4hqTYlX2WQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-f7lOm7kDN5eBbMGp6MrkmQ-1; Thu, 04 Aug 2022 02:59:28 -0400
X-MC-Unique: f7lOm7kDN5eBbMGp6MrkmQ-1
Received: by mail-ej1-f71.google.com with SMTP id qf23-20020a1709077f1700b007308a195618so3384946ejc.7
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 23:59:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ExEtxHMeVEdV8bG+hyv5znpbqanF/kL14mBYzm730MI=;
        b=haVvLTQ4sppb3pCz8wiykDm+CofHGIDAPCE6/q0DeitlE+idnAkJ6CUjAkcb3Ehh1U
         DGLsxP+eDumswZvMiAn171QDSrenv4gAKigPHawCLyUtu6jMY3sPZ+OB6uGYwAG79R8a
         JTYwOtAfNaVIPirVlCWWjATbt5CG6RiN8041wCwBYAq/2n+DUDx3k34erLMYeXAugn73
         GlTp+zYNGJJOLqqC6FgSPE9fBowzD10guja6yDi6chzCFZVN/zmfxf+/Tb8IAO88IgmE
         CmDjHScdoP2KofjVwDmgZXV5dNsKpV6XqLnmoGHSTsYPsSVX/VRGma+0OG/bxeRgDNCJ
         VPaw==
X-Gm-Message-State: ACgBeo3p0dgIrcAkVwLgd/elaQCkQY48xxME0ztBTzlbanuesInI6cVk
        ua8UPYlTEwV6WyZYMiV0g4QuGctnOYjDmHxb3XMrBOe5XqZRFtNqEh+QE+D53QUTBY4fhH67pri
        PTTTn7emg/hvCjhy0
X-Received: by 2002:a17:906:7952:b0:730:6ab7:6655 with SMTP id l18-20020a170906795200b007306ab76655mr360571ejo.171.1659596367221;
        Wed, 03 Aug 2022 23:59:27 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7Ik1DuQerRmV01wlFYMNwdnqCD+oKxuFKA0C8LkP/PgPoBMCDxqmCixUtgsIrJfFVs/lJMKQ==
X-Received: by 2002:a17:906:7952:b0:730:6ab7:6655 with SMTP id l18-20020a170906795200b007306ab76655mr360560ejo.171.1659596366980;
        Wed, 03 Aug 2022 23:59:26 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id u1-20020a1709061da100b0072b2ffc662esm167ejh.156.2022.08.03.23.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 23:59:26 -0700 (PDT)
Date:   Thu, 4 Aug 2022 08:59:23 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next] vsock: Reschedule connect_work for
 O_NONBLOCK connect() requests
Message-ID: <20220804065923.66bor7cyxwk2bwsf@sgarzare-redhat>
References: <20220804020925.32167-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220804020925.32167-1-yepeilin.cs@gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 07:09:25PM -0700, Peilin Ye wrote:
>From: Peilin Ye <peilin.ye@bytedance.com>
>
>An O_NONBLOCK vsock_connect() request may try to reschedule
>@connect_work.  Consider the following vsock_connect() requests:
>
>  1. The 1st, non-blocking request schedules @connect_work, which will
>     expire after, say, 200 jiffies.  Socket state is now SS_CONNECTING;
>
>  2. Later, the 2nd, blocking request gets interrupted by a signal after
>     5 jiffies while waiting for the connection to be established.
>     Socket state is back to SS_UNCONNECTED, and @connect_work will
>     expire after 100 jiffies;
>
>  3. Now, the 3rd, non-blocking request tries to schedule @connect_work
>     again, but @connect_work has already been scheduled, and will
>     expire in, say, 50 jiffies.
>
>In this scenario, currently this 3rd request simply decreases the sock
>reference count and returns.  Instead, let it reschedules @connect_work
>and resets the timeout back to @connect_timeout.
>
>Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
>---
>Hi all,
>
>This patch is RFC because it bases on Stefano's WIP fix [1] for a bug 
>[2]
>reported by syzbot, and it won't apply on current net-next.  I think it
>solves a separate issue.

Nice, this is better!

Feel free to include my patch in this (inclunding also the Fixes tag and 
maybe senidng to syzbot and including its tag as well).

The last thing I was trying to figure out before sending the patch was 
whether to set sock->state = SS_UNCONNECTED in vsock_connect_timeout(). 

I think we should do that, otherwise a subsequent to connect() with 
O_NONBLOCK set would keep returning -EALREADY, even though the timeout 
has expired.

What do you think?

I don't think it changes anything for the bug raised by sysbot, so it 
could be a separate patch.

Thanks,
Stefano

>
>Please advise, thanks!
>Peilin Ye
>
>[1] https://gitlab.com/sgarzarella/linux/-/commit/2d0f0b9cbbb30d58fdcbca7c1a857fd8f3110d61
>[2] https://syzkaller.appspot.com/bug?id=cd9103dc63346d26acbbdbf5c6ba9bd74e48c860
>
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 194d22291d8b..417e4ad17c03 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1395,7 +1395,7 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
> 			/* If the timeout function is already scheduled, ungrab
> 			 * the socket refcount to not leave it unbalanced.
> 			 */
>-			if (!schedule_delayed_work(&vsk->connect_work, timeout))
>+			if (mod_delayed_work(system_wq, &vsk->connect_work, timeout))
> 				sock_put(sk);
>
> 			/* Skip ahead to preserve error code set above. */
>-- 
>2.20.1
>

