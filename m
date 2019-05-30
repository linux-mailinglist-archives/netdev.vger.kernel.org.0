Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34862F362
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388158AbfE3E26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:28:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46664 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730048AbfE3E24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 00:28:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F6C0136E07E5;
        Wed, 29 May 2019 21:28:55 -0700 (PDT)
Date:   Wed, 29 May 2019 21:28:52 -0700 (PDT)
Message-Id: <20190529.212852.1077585415381753122.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, mst@redhat.com
Subject: Re: [PATCH 1/4] vsock/virtio: fix locking around 'the_virtio_vsock'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528105623.27983-2-sgarzare@redhat.com>
References: <20190528105623.27983-1-sgarzare@redhat.com>
        <20190528105623.27983-2-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 21:28:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Tue, 28 May 2019 12:56:20 +0200

> @@ -68,7 +68,13 @@ struct virtio_vsock {
>  
>  static struct virtio_vsock *virtio_vsock_get(void)
>  {
> -	return the_virtio_vsock;
> +	struct virtio_vsock *vsock;
> +
> +	mutex_lock(&the_virtio_vsock_mutex);
> +	vsock = the_virtio_vsock;
> +	mutex_unlock(&the_virtio_vsock_mutex);
> +
> +	return vsock;

This doesn't do anything as far as I can tell.

No matter what, you will either get the value before it's changed or
after it's changed.

Since you should never publish the pointer by assigning it until the
object is fully initialized, this can never be a problem even without
the mutex being there.

Even if you sampled the the_virtio_sock value right before it's being
set to NULL by the remove function, that still can happen with the
mutex held too.

This function is also terribly named btw, it implies that a reference
count is being taken.  But that's not what this function does, it
just returns the pointer value as-is.
