Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306A6310E9A
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 18:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhBEPmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 10:42:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58126 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230374AbhBEPjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 10:39:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612545598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J8+NmPdJaQBRZhAOkxdsoZeapuA2iFi/S9BYhy4o7S4=;
        b=aD/hMXSasyjaBk2v5YdPQArcYEEk3TSAc37UEiJjrzl2G30ExwW+y5Be+bJAwHHt1NdtrG
        B1ybYM5f8l+etxYZG3gSY3AmPsFr7rh9eMa7LosfnodNA95XC0jswRS1xKo59oxxdESbwA
        am2b58oJmoeU8ujG2T+Y7M/g+i8EGDc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-JERAAg8tPciNmPdR8fJimQ-1; Fri, 05 Feb 2021 12:19:56 -0500
X-MC-Unique: JERAAg8tPciNmPdR8fJimQ-1
Received: by mail-wr1-f69.google.com with SMTP id m7so5781408wro.12
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 09:19:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J8+NmPdJaQBRZhAOkxdsoZeapuA2iFi/S9BYhy4o7S4=;
        b=BzZ3o+Kx3f6gElRg28h/hMAeUz9Oj9WXUFGCTEUgSLlLElEOQh58oqLipILXhgM54m
         xLY32lNu+ntFZRLxusFv1V/KpPW5NhGOxk9yKBPKF+fZbFPJol2n5sNR0cXV9pLvJx1u
         VLEnoPvIJZsVj/nzbzBeeMekoZ2bb3Iq5/rSDg+ySTUQ+OuR3bS9IV3HsdT7So+m10ft
         AX44XkN0M3tugf4FfLFMQsNDr/GIK1hyDZVVQW81S+MXgQNK1dGQVA4fk+viKVXbvIRe
         VNzU3e+9FTZHgF/mJ6hJvPk9pbGltlqsv2sutLRoMZC8+Hmbe5x5v22Cyo2bRtbMtbXQ
         nVcA==
X-Gm-Message-State: AOAM533f7ucM1bSmcg9TDBgepZDe0JvTRlXLQqMimnRrqqC5ftURZUmf
        4Lp78E46sfJ5jv2ZLfKIRl4rHWNddjmLRdTNjSNRuGwR3am6uG842lKSTgK6ho1Cp1PG3HRbt74
        uSJOBH/ixAdmSwZm4
X-Received: by 2002:a7b:c153:: with SMTP id z19mr4414264wmi.87.1612545594912;
        Fri, 05 Feb 2021 09:19:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3m74JGku8EiqNRXR4tan60CL7BVm6p6llXhoKxt320DWnvje7ylzv3oXrLKrJopoYFr8AQg==
X-Received: by 2002:a7b:c153:: with SMTP id z19mr4414254wmi.87.1612545594691;
        Fri, 05 Feb 2021 09:19:54 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id v6sm13120933wrx.32.2021.02.05.09.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 09:19:54 -0800 (PST)
Date:   Fri, 5 Feb 2021 18:19:51 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Norbert Slusarek <nslusarek@gmx.net>
Cc:     kuba@kernel.org, alex.popov@linux.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/vmw_vsock: improve locking in vsock_connect_timeout()
Message-ID: <20210205171951.emlq5t5fuiwtpse3@steredhat>
References: <trinity-f8e0937a-cf0e-4d80-a76e-d9a958ba3ef1-1612535522360@3c-app-gmx-bap12>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <trinity-f8e0937a-cf0e-4d80-a76e-d9a958ba3ef1-1612535522360@3c-app-gmx-bap12>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 03:32:02PM +0100, Norbert Slusarek wrote:
>From: Norbert Slusarek <nslusarek@gmx.net>
>Date: Fri, 5 Feb 2021 13:14:05 +0100
>Subject: [PATCH] net/vmw_vsock: improve locking in vsock_connect_timeout()
>
>A possible locking issue in vsock_connect_timeout() was recognized by
>Eric Dumazet which might cause a null pointer dereference in
>vsock_transport_cancel_pkt(). This patch assures that
>vsock_transport_cancel_pkt() will be called within the lock, so a race
>condition won't occur which could result in vsk->transport to be set to NULL.
>
>Fixes: 380feae0def7 ("vsock: cancel packets when failing to connect")

I have a doubt about the tag to use, since until we introduced 
transports in commit c0cfa2d8a788 ("vsock: add multi-transports 
support") this issue didn't cause many problems.

But it must be said that in the commit 380feae0def7 ("vsock: cancel 
packets when failing to connect") the vsock_transport_cancel_pkt() was 
called with the lock held in vsock_stream_connect() and without lock in 
vsock_connect_timeout(), so maybe this tag is okay.

Anyway, the patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


>Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
>Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
>---
> net/vmw_vsock/af_vsock.c | 5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 6894f21dc147..ad7dd9d93b5b 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1243,7 +1243,6 @@ static void vsock_connect_timeout(struct work_struct *work)
> {
> 	struct sock *sk;
> 	struct vsock_sock *vsk;
>-	int cancel = 0;
>
> 	vsk = container_of(work, struct vsock_sock, connect_work.work);
> 	sk = sk_vsock(vsk);
>@@ -1254,11 +1253,9 @@ static void vsock_connect_timeout(struct work_struct *work)
> 		sk->sk_state = TCP_CLOSE;
> 		sk->sk_err = ETIMEDOUT;
> 		sk->sk_error_report(sk);
>-		cancel = 1;
>+		vsock_transport_cancel_pkt(vsk);
> 	}
> 	release_sock(sk);
>-	if (cancel)
>-		vsock_transport_cancel_pkt(vsk);
>
> 	sock_put(sk);
> }
>--
>2.30.0
>

