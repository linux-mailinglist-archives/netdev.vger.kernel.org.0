Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DFC2E8E62
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 22:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbhACVTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 16:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbhACVTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 16:19:30 -0500
Received: from forward100j.mail.yandex.net (forward100j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B72C061573;
        Sun,  3 Jan 2021 13:18:49 -0800 (PST)
Received: from myt5-e5be2b47c7a3.qloud-c.yandex.net (myt5-e5be2b47c7a3.qloud-c.yandex.net [IPv6:2a02:6b8:c00:2583:0:640:e5be:2b47])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id F2CF250E1201;
        Mon,  4 Jan 2021 00:18:46 +0300 (MSK)
Received: from myt4-ee976ce519ac.qloud-c.yandex.net (myt4-ee976ce519ac.qloud-c.yandex.net [2a02:6b8:c00:1da4:0:640:ee97:6ce5])
        by myt5-e5be2b47c7a3.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 7Um83cj7X1-IkEKS9P2;
        Mon, 04 Jan 2021 00:18:46 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1609708726;
        bh=/09hiXrWBDEpRbuWT3AYbPbd36CF9zxIC8Go8TuFXi8=;
        h=In-Reply-To:From:To:Subject:Message-ID:Cc:Date:References;
        b=eJlyBt83Zh3O+wgnsiTxPgh02qkTLFZqcsm54Y+e8dhmPajog55K/ZKEZcZ6T8+q0
         7gq7Z1La44K/xbPNkvrYPccf4nVKBMVUxQQzHH0BV9C2HusLIHdcXDXgK7o2JVgaSA
         RG0TBl/ap+PRrYCHhwSoua2ec4GO1xI7/nzAlFus=
Authentication-Results: myt5-e5be2b47c7a3.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt4-ee976ce519ac.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id uKXDdlGSmJ-IjIGUj2v;
        Mon, 04 Jan 2021 00:18:45 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH 0/5] virtio/vsock: introduce SOCK_SEQPACKET support.
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Arseniy Krasnov <oxffffaa@gmail.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <b93e36c7-fd0b-6c5c-f598-234520b9fe01@yandex.ru>
Date:   Mon, 4 Jan 2021 00:18:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny, thanks for your work on this!

I did a small review in a hope it helps.
Also it may be cool to have the driver feature
for that (so that the host can see if its supported).
But I guess this was already said by Michael. :)

03.01.2021 22:54, Arseny Krasnov пишет:
> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
> do it, new packet operation was added: it marks start of record (with
> record length in header). To send record, packet with start marker is
> sent first, then all data is transmitted as 'RW' packets. On receiver's
> side, length of record is known from packet with start record marker.
> Now as  packets of one socket are not reordered neither on vsock nor on
> vhost transport layers, these marker allows to restore original record
> on receiver's side. When each 'RW' packet is inserted to rx queue of
> receiver, user is woken up, data is copied to user's buffer and credit
> update message is sent. If there is no user waiting for data, credit
> won't be updated and sender will wait. Also,  if user's buffer is full,
> and record is bigger, all unneeded data will be dropped (with sending of
> credit update message).
> 	'MSG_EOR' flag is implemented with special value of 'flags' field
> in packet header. When record is received with such flags, 'MSG_EOR' is
> set in 'recvmsg()' flags. 'MSG_TRUNC' flag is also supported.
> 	In this implementation maximum length of datagram is not limited
> as in stream socket.
>
>   drivers/vhost/vsock.c                   |   6 +-
>   include/linux/virtio_vsock.h            |   7 +
>   include/net/af_vsock.h                  |   4 +
>   include/uapi/linux/virtio_vsock.h       |   9 +
>   net/vmw_vsock/af_vsock.c                | 457 +++++++++++++++++++-----
>   net/vmw_vsock/virtio_transport.c        |   3 +
>   net/vmw_vsock/virtio_transport_common.c | 323 ++++++++++++++---
>   7 files changed, 673 insertions(+), 136 deletions(-)
>

