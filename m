Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26ABF6163
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfKIU3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:29:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfKIU3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:29:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21D7B1474DF0F;
        Sat,  9 Nov 2019 12:29:35 -0800 (PST)
Date:   Fri, 08 Nov 2019 12:19:46 -0800 (PST)
Message-Id: <20191108.121946.1084660860645163442.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        smbarber@chromium.org, stefanha@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] vsock/virtio: fix sock refcnt holding during the
 shutdown
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108160850.51278-1-sgarzare@redhat.com>
References: <20191108160850.51278-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 09 Nov 2019 12:29:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Fri,  8 Nov 2019 17:08:50 +0100

> The "42f5cda5eaf4" commit rightly set SOCK_DONE on peer shutdown,
> but there is an issue if we receive the SHUTDOWN(RDWR) while the
> virtio_transport_close_timeout() is scheduled.
> In this case, when the timeout fires, the SOCK_DONE is already
> set and the virtio_transport_close_timeout() will not call
> virtio_transport_reset() and virtio_transport_do_close().
> This causes that both sockets remain open and will never be released,
> preventing the unloading of [virtio|vhost]_transport modules.
> 
> This patch fixes this issue, calling virtio_transport_reset() and
> virtio_transport_do_close() when we receive the SHUTDOWN(RDWR)
> and there is nothing left to read.
> 
> Fixes: 42f5cda5eaf4 ("vsock/virtio: set SOCK_DONE on peer shutdown")
> Cc: Stephen Barber <smbarber@chromium.org>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Applied and queued up for -stable, thanks.
