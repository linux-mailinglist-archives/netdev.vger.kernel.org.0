Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A146447BD5
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237871AbhKHIdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:33:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238009AbhKHIdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 03:33:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636360219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dZ2Q+DY5lRLHrC4/deim612KwtYNG+pVAfJvd8a6ths=;
        b=QQHAk2Lahq6U9v7kueBp9hTOBjfN2IC4xoI08oop29gPgOdA3ck7ySXBJw4mRybZlZUyWc
        5sBIvs1zeTSka2Ers/9wAvZp98MFnHvgO08b9H6gpG3ogw/TWib370OvDFJxeGV394T81K
        9ARVprIj2gbA/iSCILU8cZcBCehXb2Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-hqZGFc4NNnq2j9tB8yUOLA-1; Mon, 08 Nov 2021 03:30:18 -0500
X-MC-Unique: hqZGFc4NNnq2j9tB8yUOLA-1
Received: by mail-ed1-f71.google.com with SMTP id w13-20020a05640234cd00b003e2fde5ff8aso8504169edc.14
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 00:30:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dZ2Q+DY5lRLHrC4/deim612KwtYNG+pVAfJvd8a6ths=;
        b=vVF+VlW/MlLoGQeJfoC37BliUyLjUo9GuKfSvRjtt1mqg3rtQfYbKYtQWPNIbKwxNL
         Fyz0CBjO/NNTjOkp9NMny310uOznHrxzK2xGrX8kq3BI3T/D1CEYV6Fwv3LMEEgSxKAO
         ifBrXW2//CR8wP4Jbwy6NBmwx8Sv0RnVqwQCZ8D9jRAF9mRiZ3DhKrJu7+Rd71S7Az49
         bTBWhg1NcgRpMvOXLhGOI6TPWheP6cpwN7f4TEa/ZGou5uTNQIHFEQVHL/oJq28OQQ7P
         r1C+fVRW3T06J+VsgAm85hKkgxFSeQgnFqMduZzfhUa49Y7J3/6o7n5Z85g18rfgfAlv
         tAjQ==
X-Gm-Message-State: AOAM531pwaz5HbJAs84SgfVll4kYdxIqkQ6SSU+IMfZBmenzZaAqC0qN
        xYBoIIkk/NmNukiH/ct+L+eGOCjSf0vJQXamY2Krl/8p69M3dzDZeYUuuSGLZRAfEWC1Hqndksq
        Jde30qkfuzjqJ7Wn+
X-Received: by 2002:a17:906:11c5:: with SMTP id o5mr91025533eja.42.1636360216945;
        Mon, 08 Nov 2021 00:30:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx55rmukR33/BtWzxQ4veIc0curLmXRJTSzYxLwdm7CCry7Yxjy1ZS8/OpXpMRCM02Ir5v9qQ==
X-Received: by 2002:a17:906:11c5:: with SMTP id o5mr91025508eja.42.1636360216758;
        Mon, 08 Nov 2021 00:30:16 -0800 (PST)
Received: from steredhat (host-87-10-72-39.retail.telecomitalia.it. [87.10.72.39])
        by smtp.gmail.com with ESMTPSA id s26sm9112853edq.6.2021.11.08.00.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:30:16 -0800 (PST)
Date:   Mon, 8 Nov 2021 09:30:13 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] vsock: prevent unnecessary refcnt inc for
 nonblocking connect
Message-ID: <20211108083013.svl77coopyryngfl@steredhat>
References: <20211107120304.38224-1-eiichi.tsukata@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211107120304.38224-1-eiichi.tsukata@nutanix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 07, 2021 at 12:03:04PM +0000, Eiichi Tsukata wrote:
>Currently vosck_connect() increments sock refcount for nonblocking
>socket each time it's called, which can lead to memory leak if
>it's called multiple times because connect timeout function decrements
>sock refcount only once.
>
>Fixes it by making vsock_connect() return -EALREADY immediately when
>sock state is already SS_CONNECTING.
>
>Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
>---
> net/vmw_vsock/af_vsock.c | 2 ++
> 1 file changed, 2 insertions(+)

Make sense to me, thanks for fixing this issue!
I think would be better to add the Fixes ref in the commit message:

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")

With that:
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

