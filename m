Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B61145347C
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhKPOnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:43:42 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:37170 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237634AbhKPOmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 09:42:50 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 45AB02171F;
        Tue, 16 Nov 2021 14:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637073591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Emkp3ncKzdkgLkKn49m2PKxs/r574HeH3hwAVh72iw=;
        b=o6p+tfWoQjEX7Tf0zL7HstYS41Q25rGUCkRxy2fZC57AXkmLEJ5Tp1yv4dDlL3MrmYhWxa
        lr+rDs7a9JYIQAB0v2IyeOEL2SyguOnJwTfXqzimKwkW/P/AR3iT16pQPRWteQox79HVJt
        BjPYEMohRiaWxxBn+TeOf0VjwEU7quo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637073591;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Emkp3ncKzdkgLkKn49m2PKxs/r574HeH3hwAVh72iw=;
        b=oSNyWbiaffOLqZbxHTHtqG94j8F5n4l34KDHIN4lglj2R9OkOcY2Z9pHpT1L5Y9TNvidnI
        qw0SNz5TglyxdkBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9DE7313C25;
        Tue, 16 Nov 2021 14:39:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2/UQIrbCk2HhHQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Tue, 16 Nov 2021 14:39:50 +0000
Subject: Re: [PATCH 1/6] vhost: get rid of vhost_poll_flush() wrapper
To:     Andrey Ryabinin <arbn@yandex-team.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211115153003.9140-1-arbn@yandex-team.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <02b1d549-9c67-7d05-0bb6-4d018106eff5@suse.de>
Date:   Tue, 16 Nov 2021 17:39:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211115153003.9140-1-arbn@yandex-team.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/15/21 6:29 PM, Andrey Ryabinin пишет:
> vhost_poll_flush() is a simple wrapper around vhost_work_dev_flush().
> It gives wrong impression that we are doing some work over vhost_poll,
> while in fact it flushes vhost_poll->dev.
> It only complicate understanding of the code and leads to mistakes
> like flushing the same vhost_dev several times in a row.
> 
> Just remove vhost_poll_flush() and call vhost_work_dev_flush() directly.

Then you should send the series prefixed with net-next

> 
> Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
> ---
>   drivers/vhost/net.c   |  4 ++--
>   drivers/vhost/test.c  |  2 +-
>   drivers/vhost/vhost.c | 12 ++----------
>   drivers/vhost/vsock.c |  2 +-
>   4 files changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 28ef323882fb..11221f6d11b8 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1375,8 +1375,8 @@ static void vhost_net_stop(struct vhost_net *n, struct socket **tx_sock,
>   
>   static void vhost_net_flush_vq(struct vhost_net *n, int index)
>   {
> -	vhost_poll_flush(n->poll + index);
> -	vhost_poll_flush(&n->vqs[index].vq.poll);
> +	vhost_work_dev_flush(n->poll[index].dev);
> +	vhost_work_dev_flush(n->vqs[index].vq.poll.dev);
>   }
>   
>   static void vhost_net_flush(struct vhost_net *n)
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index a09dedc79f68..1a8ab1d8cb1c 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -146,7 +146,7 @@ static void vhost_test_stop(struct vhost_test *n, void **privatep)
>   
>   static void vhost_test_flush_vq(struct vhost_test *n, int index)
>   {
> -	vhost_poll_flush(&n->vqs[index].poll);
> +	vhost_work_dev_flush(n->vqs[index].poll.dev);
>   }
>   
>   static void vhost_test_flush(struct vhost_test *n)
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..ca088481da0e 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -245,14 +245,6 @@ void vhost_work_dev_flush(struct vhost_dev *dev)
>   }
>   EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
>   
> -/* Flush any work that has been scheduled. When calling this, don't hold any
> - * locks that are also used by the callback. */
> -void vhost_poll_flush(struct vhost_poll *poll)
> -{
> -	vhost_work_dev_flush(poll->dev);
> -}
> -EXPORT_SYMBOL_GPL(vhost_poll_flush);
> -
>   void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
>   {
>   	if (!dev->worker)
> @@ -663,7 +655,7 @@ void vhost_dev_stop(struct vhost_dev *dev)
>   	for (i = 0; i < dev->nvqs; ++i) {
>   		if (dev->vqs[i]->kick && dev->vqs[i]->handle_kick) {
>   			vhost_poll_stop(&dev->vqs[i]->poll);
> -			vhost_poll_flush(&dev->vqs[i]->poll);
> +			vhost_work_dev_flush(dev->vqs[i]->poll.dev);
>   		}
>   	}
>   }
> @@ -1712,7 +1704,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
>   	mutex_unlock(&vq->mutex);
>   
>   	if (pollstop && vq->handle_kick)
> -		vhost_poll_flush(&vq->poll);
> +		vhost_work_dev_flush(vq->poll.dev);
>   	return r;
>   }
>   EXPORT_SYMBOL_GPL(vhost_vring_ioctl);
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 938aefbc75ec..b0361ebbd695 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -711,7 +711,7 @@ static void vhost_vsock_flush(struct vhost_vsock *vsock)
>   
>   	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++)
>   		if (vsock->vqs[i].handle_kick)
> -			vhost_poll_flush(&vsock->vqs[i].poll);
> +			vhost_work_dev_flush(vsock->vqs[i].poll.dev);
>   	vhost_work_dev_flush(&vsock->dev);
>   }
>   
> 
