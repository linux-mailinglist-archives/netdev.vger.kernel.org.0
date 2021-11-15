Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4DF450889
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbhKOPfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbhKOPfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 10:35:00 -0500
X-Greylist: delayed 108 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Nov 2021 07:32:00 PST
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDEEC061714;
        Mon, 15 Nov 2021 07:31:59 -0800 (PST)
Received: from iva8-d2cd82b7433e.qloud-c.yandex.net (iva8-d2cd82b7433e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a88e:0:640:d2cd:82b7])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id B8BAD2E101A;
        Mon, 15 Nov 2021 18:30:15 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-d2cd82b7433e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id GMtlz78Mnx-UFsmomot;
        Mon, 15 Nov 2021 18:30:15 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636990215; bh=HUFqIMgzMMmB9sHjMU91MM/DWIitYTnjAFxExYD76tw=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=1eEPqu26uj5a8uENUFAABIYIymoxkMLyFAfQuM8A1ymmqJiJHRVwgCNln9LAiABCm
         okQz+h4ueswi4w3muor8kXWcWpD4ybo7wXCV249EPRkJtzoNGaeM7nRXSTHDjfN6rC
         Pgdr9Wg2uJmuqE3AvhGl3Y+18nXvhBNCzxUlLYcA=
Authentication-Results: iva8-d2cd82b7433e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dellarbn.yandex.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id wuqDqjnGag-UFxaDJrY;
        Mon, 15 Nov 2021 18:30:15 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andrey Ryabinin <arbn@yandex-team.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] vhost_net: remove NOP vhost_net_flush() in vhost_net_release()
Date:   Mon, 15 Nov 2021 18:30:02 +0300
Message-Id: <20211115153003.9140-5-arbn@yandex-team.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115153003.9140-1-arbn@yandex-team.com>
References: <20211115153003.9140-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The second vhost_net_flush() call in vhost_net_release() doesn't do
anything. vhost_dev_cleanup() stops dev->worker and NULLifies it.
vhost_net_reset_vq(n) NULLifies n->vqs[i].ubufs

So vhost_net_flush() after vhost_dev_cleanup()&vhost_net_reset_vq() doesn't
do anything, it simply doesn't pass NULL checks.

Hence remove it for simplicity.

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 drivers/vhost/net.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b1feb5e0571e..97a209d6a527 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1406,9 +1406,7 @@ static int vhost_net_release(struct inode *inode, struct file *f)
 		sockfd_put(rx_sock);
 	/* Make sure no callbacks are outstanding */
 	synchronize_rcu();
-	/* We do an extra flush before freeing memory,
-	 * since jobs can re-queue themselves. */
-	vhost_net_flush(n);
+
 	kfree(n->vqs[VHOST_NET_VQ_RX].rxq.queue);
 	kfree(n->vqs[VHOST_NET_VQ_TX].xdp);
 	kfree(n->dev.vqs);
-- 
2.32.0

