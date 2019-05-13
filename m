Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D5C1B38B
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 12:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfEMKCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 06:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbfEMKCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 06:02:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 204F4307D854;
        Mon, 13 May 2019 10:02:04 +0000 (UTC)
Received: from [10.72.12.49] (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D31595D706;
        Mon, 13 May 2019 10:01:54 +0000 (UTC)
Subject: Re: [PATCH v2 7/8] vsock/virtio: increase RX buffer size to 64 KiB
To:     Stefano Garzarella <sgarzare@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-8-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bf0416f1-0e69-722d-75ce-3d101e6d7d71@redhat.com>
Date:   Mon, 13 May 2019 18:01:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190510125843.95587-8-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 13 May 2019 10:02:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/10 下午8:58, Stefano Garzarella wrote:
> In order to increase host -> guest throughput with large packets,
> we can use 64 KiB RX buffers.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   include/linux/virtio_vsock.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index 84b72026d327..5a9d25be72df 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -10,7 +10,7 @@
>   #define VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE	128
>   #define VIRTIO_VSOCK_DEFAULT_BUF_SIZE		(1024 * 256)
>   #define VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE	(1024 * 256)
> -#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
> +#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 64)
>   #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
>   #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
>   


We probably don't want such high order allocation. It's better to switch 
to use order 0 pages in this case. See add_recvbuf_big() for virtio-net. 
If we get datapath unified, we will get more stuffs set.

Thanks

