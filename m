Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26EBC044D
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 13:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfI0L2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 07:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbfI0L2X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 07:28:23 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 56D743060399;
        Fri, 27 Sep 2019 11:28:23 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-249.ams2.redhat.com [10.36.117.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 536095D9C3;
        Fri, 27 Sep 2019 11:28:20 +0000 (UTC)
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
Subject: [RFC PATCH 09/13] hv_sock: set VMADDR_CID_HOST in the hvs_remote_addr_init()
Date:   Fri, 27 Sep 2019 13:26:59 +0200
Message-Id: <20190927112703.17745-10-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-1-sgarzare@redhat.com>
References: <20190927112703.17745-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 27 Sep 2019 11:28:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remote peer is always the host, so we set VMADDR_CID_HOST as
remote CID instead of VMADDR_CID_ANY.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/hyperv_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 4f47af2054dd..306310794522 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -186,7 +186,8 @@ static void hvs_remote_addr_init(struct sockaddr_vm *remote,
 	static u32 host_ephemeral_port = MIN_HOST_EPHEMERAL_PORT;
 	struct sock *sk;
 
-	vsock_addr_init(remote, VMADDR_CID_ANY, VMADDR_PORT_ANY);
+	/* Remote peer is always the host */
+	vsock_addr_init(remote, VMADDR_CID_HOST, VMADDR_PORT_ANY);
 
 	while (1) {
 		/* Wrap around ? */
-- 
2.21.0

