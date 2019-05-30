Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F852FA42
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 12:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfE3K1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 06:27:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35363 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfE3K1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 06:27:46 -0400
Received: by mail-wm1-f67.google.com with SMTP id c6so569944wml.0
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 03:27:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ufaJ69bV1ZdV2vK3Yvd7HZfDeRwHgRdBfrRRr7OPOt8=;
        b=uRM/uFXPcjpCHzr/4pjh7fzi82nhwdseVuyRl+ib045xhaMUQR4bdI4MIw/hKhIcLW
         GO770FUcWPmTaPNPaVFH6bv/miqRHbskhohNWRwzINlf6rXSRrDX5I/f476PpmNxR/mN
         Bmnuxutz2qmF/SjXWldXY/KGeN7Mq6YbzTwzlslGykQ9QCLLALh991D/cJKx/GZ6z7YC
         j8Iq6v7DHv1LL3lCytH1oEt4B9FqV+P6Ei+qrkW3jZ3jFiNd2R9A5xLxehqp2k09UmaW
         yw7gi2JmHtjCPrFMWo+f68/yREae014g33l40dkgrYANo5/Y6xturypn8WPxZRfpJ51r
         iDFg==
X-Gm-Message-State: APjAAAWuVF9nsx9kqahcEQfdGXs2usgQNKpwdr7/Pq/cQJ1km35G5YvN
        YdG0g0mcDn38lGY6OxJE7AD2EA==
X-Google-Smtp-Source: APXvYqwCZoROfm1dwQ0BbuZ4fQ3gtir9ydTTXaC6tZ+Z2VET1TLknia55mcrtyiStuIylOJjK8wEIA==
X-Received: by 2002:a05:600c:1051:: with SMTP id 17mr1836219wmx.10.1559212064154;
        Thu, 30 May 2019 03:27:44 -0700 (PDT)
Received: from steredhat.homenet.telecomitalia.it (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id f3sm1958585wre.93.2019.05.30.03.27.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 03:27:43 -0700 (PDT)
Date:   Thu, 30 May 2019 12:27:40 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, mst@redhat.com
Subject: Re: [PATCH 1/4] vsock/virtio: fix locking around 'the_virtio_vsock'
Message-ID: <20190530102740.nyg6akggvy2asikt@steredhat.homenet.telecomitalia.it>
References: <20190528105623.27983-1-sgarzare@redhat.com>
 <20190528105623.27983-2-sgarzare@redhat.com>
 <20190529.212852.1077585415381753122.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529.212852.1077585415381753122.davem@davemloft.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 09:28:52PM -0700, David Miller wrote:
> From: Stefano Garzarella <sgarzare@redhat.com>
> Date: Tue, 28 May 2019 12:56:20 +0200
> 
> > @@ -68,7 +68,13 @@ struct virtio_vsock {
> >  
> >  static struct virtio_vsock *virtio_vsock_get(void)
> >  {
> > -	return the_virtio_vsock;
> > +	struct virtio_vsock *vsock;
> > +
> > +	mutex_lock(&the_virtio_vsock_mutex);
> > +	vsock = the_virtio_vsock;
> > +	mutex_unlock(&the_virtio_vsock_mutex);
> > +
> > +	return vsock;
> 
> This doesn't do anything as far as I can tell.
> 
> No matter what, you will either get the value before it's changed or
> after it's changed.
> 
> Since you should never publish the pointer by assigning it until the
> object is fully initialized, this can never be a problem even without
> the mutex being there.
> 
> Even if you sampled the the_virtio_sock value right before it's being
> set to NULL by the remove function, that still can happen with the
> mutex held too.

Yes, I found out when I was answering Jason's question [1]. :(

I proposed to use RCU to solve this issue, do you agree?
Let me know if there is a better way.

> 
> This function is also terribly named btw, it implies that a reference
> count is being taken.  But that's not what this function does, it
> just returns the pointer value as-is.

What do you think if I remove the function, using directly the_virtio_vsock?
(should be easier to use with RCU API)

Thanks,
Stefano

[1] https://lore.kernel.org/netdev/20190529105832.oz3sagbne5teq3nt@steredhat
