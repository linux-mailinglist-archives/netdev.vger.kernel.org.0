Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CBF1E94C7
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 02:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgEaAos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 20:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729361AbgEaAos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 20:44:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390D3C03E969;
        Sat, 30 May 2020 17:44:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 663AC128DA313;
        Sat, 30 May 2020 17:44:46 -0700 (PDT)
Date:   Sat, 30 May 2020 17:44:45 -0700 (PDT)
Message-Id: <20200530.174445.526346281814829960.davem@davemloft.net>
To:     justin.he@arm.com
Cc:     stefanha@redhat.com, sgarzare@redhat.com, kuba@kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaly.Xin@arm.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200530013828.59668-1-justin.he@arm.com>
References: <20200530013828.59668-1-justin.he@arm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 17:44:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia He <justin.he@arm.com>
Date: Sat, 30 May 2020 09:38:28 +0800

> When client on the host tries to connect(SOCK_STREAM, O_NONBLOCK) to the
> server on the guest, there will be a panic on a ThunderX2 (armv8a server):
 ...
> The race condition is as follows:
> Task1                                Task2
> =====                                =====
> __sock_release                       virtio_transport_recv_pkt
>   __vsock_release                      vsock_find_bound_socket (found sk)
>     lock_sock_nested
>     vsock_remove_sock
>     sock_orphan
>       sk_set_socket(sk, NULL)
>     sk->sk_shutdown = SHUTDOWN_MASK
>     ...
>     release_sock
>                                     lock_sock
>                                        virtio_transport_recv_connecting
>                                          sk->sk_socket->state (panic!)
> 
> The root cause is that vsock_find_bound_socket can't hold the lock_sock,
> so there is a small race window between vsock_find_bound_socket() and
> lock_sock(). If __vsock_release() is running in another task,
> sk->sk_socket will be set to NULL inadvertently.
> 
> This fixes it by checking sk->sk_shutdown(suggested by Stefano) after
> lock_sock since sk->sk_shutdown is set to SHUTDOWN_MASK under the
> protection of lock_sock_nested.
> 
> Signed-off-by: Jia He <justin.he@arm.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Applied and queued up for -stable, thank you.
