Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42D2D42CF
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfJKO0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:26:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbfJKO0l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 10:26:41 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5424E7FD6C
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 14:26:41 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id 59so9598806qtc.5
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u9P7ZH+Y5VJTavkHr+ZiIN7ARusJlNnypFrPGuqGbsc=;
        b=ituB/DiMUakcJUvY66vf4/3tuPalNNWEWvH4RSTLKEPZWmVMdSWp3r8cVFoOT+rm9Q
         hQrQLlRKzBeH7FOQ0hTobAAPQiXY+01/ejw7TLKhssdWWEVhXxAV/AVZEgbu0bGtWdNb
         fYYofZbmjMrK5LJ9QVTC7MXylbd2k7B8ZrjtGdVmieBHOxntdOfaxYzIFBWP+I5G9P++
         +rY2Au/PdupHNk4ZZ/b1SBqT5oqs49HtJFtqfKUxPdl1LMBXm8SAP9s01h33xU84YupA
         rGeO/XyTNEh//DT4uSRVQzGF4YrP7ry4cBx5QdvDVY8De1mUG/iw8l316qPSsPSmjAe8
         mzlw==
X-Gm-Message-State: APjAAAVQGcFmw4IdXX5v8c6Rnj0Rkz7sNpzz0JardgTUNlZYUGky2W5F
        GlYzAqXBjynTc/aac40Q6M669K3n29SsAb/JsUfbVmvzPsEiiqLXZQ+X0/WAVHHXyfwS8ZKXTwQ
        yrb2kGjwhG/ZxFIVo
X-Received: by 2002:a37:6114:: with SMTP id v20mr16560727qkb.329.1570804000585;
        Fri, 11 Oct 2019 07:26:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxRQu0tWlUWQUkl0Snv5crytJ8wM4hPrKuPA7AXRTavuKo53VLfKGDp3FcKv1ZsSQwyKNvQTQ==
X-Received: by 2002:a37:6114:: with SMTP id v20mr16560681qkb.329.1570804000320;
        Fri, 11 Oct 2019 07:26:40 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id i30sm4661684qte.27.2019.10.11.07.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 07:26:39 -0700 (PDT)
Date:   Fri, 11 Oct 2019 10:26:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] vhost/vsock: don't allow half-closed socket in
 the host
Message-ID: <20191011102246-mutt-send-email-mst@kernel.org>
References: <20191011130758.22134-1-sgarzare@redhat.com>
 <20191011130758.22134-3-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011130758.22134-3-sgarzare@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 03:07:58PM +0200, Stefano Garzarella wrote:
> vmci_transport never allowed half-closed socket on the host side.
> In order to provide the same behaviour, we changed the
> vhost_transport_stream_has_data() to return 0 (no data available)
> if the peer (guest) closed the connection.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

I don't think we should copy bugs like this.
Applications don't actually depend on this VMCI limitation, in fact
it looks like a working application can get broken by this.

So this looks like a userspace visible ABI change
which we can't really do.

If it turns out some application cares, it can always
fully close the connection. Or add an ioctl so the application
can find out whether half close works.

> ---
>  drivers/vhost/vsock.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 9f57736fe15e..754120aa4478 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -58,6 +58,21 @@ static u32 vhost_transport_get_local_cid(void)
>  	return VHOST_VSOCK_DEFAULT_HOST_CID;
>  }
>  
> +static s64 vhost_transport_stream_has_data(struct vsock_sock *vsk)
> +{
> +	/* vmci_transport doesn't allow half-closed socket on the host side.
> +	 * recv() on the host side returns EOF when the guest closes a
> +	 * connection, also if some data is still in the receive queue.
> +	 *
> +	 * In order to provide the same behaviour, we always return 0
> +	 * (no data available) if the peer (guest) closed the connection.
> +	 */
> +	if (vsk->peer_shutdown == SHUTDOWN_MASK)
> +		return 0;
> +
> +	return virtio_transport_stream_has_data(vsk);
> +}
> +
>  /* Callers that dereference the return value must hold vhost_vsock_mutex or the
>   * RCU read lock.
>   */
> @@ -804,7 +819,7 @@ static struct virtio_transport vhost_transport = {
>  
>  		.stream_enqueue           = virtio_transport_stream_enqueue,
>  		.stream_dequeue           = virtio_transport_stream_dequeue,
> -		.stream_has_data          = virtio_transport_stream_has_data,
> +		.stream_has_data          = vhost_transport_stream_has_data,
>  		.stream_has_space         = virtio_transport_stream_has_space,
>  		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
>  		.stream_is_active         = virtio_transport_stream_is_active,
> -- 
> 2.21.0
