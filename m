Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BA03ACC61
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbhFRNiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233947AbhFRNiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:38:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624023351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXqmNJYdW4k2bFeB+YFnzlxYcdTW1K7N5BohB9KAzV0=;
        b=D8omukd5nmfJ9xmsKEfKEkzPsgssNyuZul6yINq6hxaac56oQNiDtmUHt1AxDfP5YH2lZu
        tpYB+LVHmoAbrRYpDPcsLE293+59oN+DUMouz7gc6oKHnVKSFBgNAFHOFJh0xRvQmB51bA
        3M4CeBOs/us7LWHaGtIpoqin/GYEo6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-wOd1bvkeOcuyxnn8SmCVng-1; Fri, 18 Jun 2021 09:35:48 -0400
X-MC-Unique: wOd1bvkeOcuyxnn8SmCVng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43348CC623;
        Fri, 18 Jun 2021 13:35:47 +0000 (UTC)
Received: from steredhat.lan (ovpn-115-127.ams2.redhat.com [10.36.115.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE7571000324;
        Fri, 18 Jun 2021 13:35:38 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Arseny Krasnov <arseny.krasnov@kaspersky.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] vsock: rename vsock_wait_data()
Date:   Fri, 18 Jun 2021 15:35:25 +0200
Message-Id: <20210618133526.300347-3-sgarzare@redhat.com>
In-Reply-To: <20210618133526.300347-1-sgarzare@redhat.com>
References: <20210618133526.300347-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vsock_wait_data() is used only by STREAM and SEQPACKET sockets,
so let's rename it to vsock_connectible_wait_data(), using the same
nomenclature (connectible) used in other functions after the
introduction of SEQPACKET.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index de8249483081..21ccf450e249 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1866,10 +1866,11 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 	return err;
 }
 
-static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
-			   long timeout,
-			   struct vsock_transport_recv_notify_data *recv_data,
-			   size_t target)
+static int vsock_connectible_wait_data(struct sock *sk,
+				       struct wait_queue_entry *wait,
+				       long timeout,
+				       struct vsock_transport_recv_notify_data *recv_data,
+				       size_t target)
 {
 	const struct vsock_transport *transport;
 	struct vsock_sock *vsk;
@@ -1967,7 +1968,8 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
 	while (1) {
 		ssize_t read;
 
-		err = vsock_wait_data(sk, &wait, timeout, &recv_data, target);
+		err = vsock_connectible_wait_data(sk, &wait, timeout,
+						  &recv_data, target);
 		if (err <= 0)
 			break;
 
@@ -2022,7 +2024,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
-	err = vsock_wait_data(sk, &wait, timeout, NULL, 0);
+	err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
 	if (err <= 0)
 		goto out;
 
-- 
2.31.1

