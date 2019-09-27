Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07A2C045E
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 13:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfI0L2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 07:28:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64723 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbfI0L2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 07:28:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 47D5C18C428E;
        Fri, 27 Sep 2019 11:28:41 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-249.ams2.redhat.com [10.36.117.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47A785D9C3;
        Fri, 27 Sep 2019 11:28:38 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [RFC PATCH 13/13] vsock: fix bind() behaviour taking care of CID
Date:   Fri, 27 Sep 2019 13:27:03 +0200
Message-Id: <20190927112703.17745-14-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-1-sgarzare@redhat.com>
References: <20190927112703.17745-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Fri, 27 Sep 2019 11:28:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we are looking for a socket bound to a specific address,
we also have to take into account the CID.

This patch is useful with multi-transports support because it
allows the binding of the same port with different CID, and
it prevents a connection to a wrong socket bound to the same
port, but with different CID.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 750b62711b01..bffa6fa7b8e5 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -230,10 +230,16 @@ static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
 {
 	struct vsock_sock *vsk;
 
-	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table)
-		if (addr->svm_port == vsk->local_addr.svm_port)
+	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
+		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
 			return sk_vsock(vsk);
 
+		if (addr->svm_port == vsk->local_addr.svm_port &&
+		    (vsk->local_addr.svm_cid == VMADDR_CID_ANY ||
+		     addr->svm_cid == VMADDR_CID_ANY))
+			return sk_vsock(vsk);
+	}
+
 	return NULL;
 }
 
-- 
2.21.0

