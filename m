Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C492E8E6B
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 22:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbhACVYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 16:24:22 -0500
Received: from forward106p.mail.yandex.net ([77.88.28.109]:52947 "EHLO
        forward106p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727520AbhACVYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 16:24:20 -0500
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jan 2021 16:24:18 EST
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward106p.mail.yandex.net (Yandex) with ESMTP id 40CFF1C81615;
        Mon,  4 Jan 2021 00:15:56 +0300 (MSK)
Received: from vla1-5c8ce23a551e.qloud-c.yandex.net (vla1-5c8ce23a551e.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:400d:0:640:5c8c:e23a])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id 3A7B47080002;
        Mon,  4 Jan 2021 00:15:56 +0300 (MSK)
Received: from vla1-cde8305024b9.qloud-c.yandex.net (vla1-cde8305024b9.qloud-c.yandex.net [2a02:6b8:c0d:4201:0:640:cde8:3050])
        by vla1-5c8ce23a551e.qloud-c.yandex.net (mxback/Yandex) with ESMTP id Zmbgus4Wxf-FtD043si;
        Mon, 04 Jan 2021 00:15:56 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1609708556;
        bh=JpyCmtxEdI8Td/OU+MHa2hHDzXpkg7mVDuvl2393vs8=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=QUSdve57xiAIK6nfNnmsduZzIzJ5chendnc3wKtoa8eWhSY9O7orI/KCclFX6gEYV
         0orSD1kyKUoAKBjnmQRZ8+hmtHz0ABM8xwjpEDDH4pTCF8z35Trdmu/LOkFjdDeIz7
         9Dmr2WKXhf+yLbw+B79VsaWZBPL0kozBl2AYyiGM=
Authentication-Results: vla1-5c8ce23a551e.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla1-cde8305024b9.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 5b7UsktbHB-FsIS2kxr;
        Mon, 04 Jan 2021 00:15:55 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH 4/5] af_vsock: add socket ops for SOCK_SEQPACKET.
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Arseniy Krasnov <oxffffaa@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
 <20210103200421.1956545-1-arseny.krasnov@kaspersky.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <f790ca57-cec9-4884-c8e5-bf8806364dd7@yandex.ru>
Date:   Mon, 4 Jan 2021 00:15:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210103200421.1956545-1-arseny.krasnov@kaspersky.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

03.01.2021 23:04, Arseny Krasnov пишет:
> From: Arseniy Krasnov <oxffffaa@gmail.com>
>
> ---
>   net/vmw_vsock/af_vsock.c | 107 +++++++++++++++++++++++++++++++++------
>   1 file changed, 91 insertions(+), 16 deletions(-)
>
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 7ff00449a9a2..30caad9815f7 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -452,6 +452,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>   		new_transport = transport_dgram;
>   		break;
>   	case SOCK_STREAM:
> +	case SOCK_SEQPACKET:
>   		if (vsock_use_local_transport(remote_cid))
>   			new_transport = transport_local;
>   		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
> @@ -459,6 +460,12 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>   			new_transport = transport_g2h;
>   		else
>   			new_transport = transport_h2g;
> +
> +		if (sk->sk_type == SOCK_SEQPACKET) {
> +			if (!new_transport->seqpacket_seq_send_len ||
> +			    !new_transport->seqpacket_seq_get_len)
> +				return -ENODEV;

Is ENODEV the right error here?
Just a quick look at a man page, and
I am under impression something like
EPROTONOSUPPORT or ESOCKNOSUPPORT
may suit?

