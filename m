Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4144521B4C5
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGJMNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:13:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49895 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727101AbgGJMM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594383177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m8g5K4VLg4BTneoyfPTMeQatQmDnDh/9EQUZe3BPx8E=;
        b=M4TJ+oWTKfPu4JklDjw1kCPjA4V4PrLDnvuVLWgA1jkII5lv6LQZZlxTZvwNLa2cUOLuyk
        eyNXjEq/TJEShUk4YF8CuetSyy7Xtszl9HjJPh3ZJH7i5ssO0+QM1HStbcQFbBDTlspDBp
        0FX/fHTJNGwONfWZEGVMfklQD2XBlaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-L0O2jgtJMHOaw7DzDpvHNQ-1; Fri, 10 Jul 2020 08:12:54 -0400
X-MC-Unique: L0O2jgtJMHOaw7DzDpvHNQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBC0B102C7F1;
        Fri, 10 Jul 2020 12:12:52 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-112-4.ams2.redhat.com [10.36.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1E0A5C6C0;
        Fri, 10 Jul 2020 12:12:44 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH] vsock/virtio: annotate 'the_virtio_vsock' RCU pointer
Date:   Fri, 10 Jul 2020 14:12:43 +0200
Message-Id: <20200710121243.120096-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free
on the_virtio_vsock") starts to use RCU to protect 'the_virtio_vsock'
pointer, but we forgot to annotate it.

This patch adds the annotation to fix the following sparse errors:

    net/vmw_vsock/virtio_transport.c:73:17: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock *
    net/vmw_vsock/virtio_transport.c:171:17: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock *
    net/vmw_vsock/virtio_transport.c:207:17: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock *
    net/vmw_vsock/virtio_transport.c:561:13: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock *
    net/vmw_vsock/virtio_transport.c:612:9: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock *
    net/vmw_vsock/virtio_transport.c:631:9: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock *

Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
Reported-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index dfbaf6bd8b1c..2700a63ab095 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -22,7 +22,7 @@
 #include <net/af_vsock.h>
 
 static struct workqueue_struct *virtio_vsock_workqueue;
-static struct virtio_vsock *the_virtio_vsock;
+static struct virtio_vsock __rcu *the_virtio_vsock;
 static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
 
 struct virtio_vsock {
-- 
2.26.2

