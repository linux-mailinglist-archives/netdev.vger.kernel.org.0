Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648E9172936
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730738AbgB0UEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:04:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44680 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbgB0UEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 15:04:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 370B2121793F1;
        Thu, 27 Feb 2020 12:04:24 -0800 (PST)
Date:   Thu, 27 Feb 2020 12:04:23 -0800 (PST)
Message-Id: <20200227.120423.2054408641031093845.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     decui@microsoft.com, hdanton@sina.com,
        virtualization@lists.linux-foundation.org, kys@microsoft.com,
        kvm@vger.kernel.org, sthemmin@microsoft.com,
        syzbot+731710996d79d0d58fbc@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, sashal@kernel.org, sunilmut@microsoft.com,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kuba@kernel.org, haiyangz@microsoft.com, stefanha@redhat.com,
        jhansen@vmware.com
Subject: Re: [PATCH net] vsock: fix potential deadlock in
 transport->release()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226105818.36055-1-sgarzare@redhat.com>
References: <20200226105818.36055-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 12:04:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 26 Feb 2020 11:58:18 +0100

> Some transports (hyperv, virtio) acquire the sock lock during the
> .release() callback.
> 
> In the vsock_stream_connect() we call vsock_assign_transport(); if
> the socket was previously assigned to another transport, the
> vsk->transport->release() is called, but the sock lock is already
> held in the vsock_stream_connect(), causing a deadlock reported by
> syzbot:
 ...
> To avoid this issue, this patch remove the lock acquiring in the
> .release() callback of hyperv and virtio transports, and it holds
> the lock when we call vsk->transport->release() in the vsock core.
> 
> Reported-by: syzbot+731710996d79d0d58fbc@syzkaller.appspotmail.com
> Fixes: 408624af4c89 ("vsock: use local transport when it is loaded")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Applied, thank you.
