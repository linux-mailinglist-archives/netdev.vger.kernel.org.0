Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6571D4508A2
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbhKOPij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236609AbhKOPf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 10:35:58 -0500
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445B7C0613B9;
        Mon, 15 Nov 2021 07:33:00 -0800 (PST)
Received: from iva8-d2cd82b7433e.qloud-c.yandex.net (iva8-d2cd82b7433e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a88e:0:640:d2cd:82b7])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id B2D5E2E1C6E;
        Mon, 15 Nov 2021 18:30:14 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-d2cd82b7433e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id f3uZWEESWC-UEs8GQBX;
        Mon, 15 Nov 2021 18:30:14 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636990214; bh=q7RFeTOWHjEIM/VlxPWmj326XXQrc4CwLzhq+6GUhkI=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=gaLlN5jV8AvCdb2Y9O2arali2hvtD5ywrfuwugidBPyKUJozc1hbp1E7BDuIj6dsQ
         0NbxtgDc+8+oLg3t0R1OgErUvLB4fz0zg7o6zvB5TWieTYjnpAcj8ECkelE5nTaoPg
         8D6IFUDzOai3k3h4+NNFqql53RL2UrtH538eAcrY=
Authentication-Results: iva8-d2cd82b7433e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dellarbn.yandex.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id wuqDqjnGag-UExaQf1Z;
        Mon, 15 Nov 2021 18:30:14 +0300
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
Subject: [PATCH 4/6] vhost_vsock: simplify vhost_vsock_flush()
Date:   Mon, 15 Nov 2021 18:30:01 +0300
Message-Id: <20211115153003.9140-4-arbn@yandex-team.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115153003.9140-1-arbn@yandex-team.com>
References: <20211115153003.9140-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhost_vsock_flush() calls vhost_work_dev_flush(vsock->vqs[i].poll.dev)
before vhost_work_dev_flush(&vsock->dev). This seems pointless
as vsock->vqs[i].poll.dev is the same as &vsock->dev and several flushes
in a row doesn't do anything useful, one is just enough.

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 drivers/vhost/vsock.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index b0361ebbd695..b4dcefbb7e60 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -707,11 +707,6 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 
 static void vhost_vsock_flush(struct vhost_vsock *vsock)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++)
-		if (vsock->vqs[i].handle_kick)
-			vhost_work_dev_flush(vsock->vqs[i].poll.dev);
 	vhost_work_dev_flush(&vsock->dev);
 }
 
-- 
2.32.0

