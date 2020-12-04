Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1E62CF28F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbgLDRD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:03:56 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:55482 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387709AbgLDRD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 12:03:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607101435; x=1638637435;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2vAKgOMbsKsobaYQSS//EkxVjYpdgHLlqgbHgLmfgWg=;
  b=Ewg9xnyiWxFK5TX7iiH74X98xt/vkz3OP/g3u+dQDTnDU+D4OAQUxjUu
   CnAWA+MoB29jMiqRBoGZ1Zdj8TnH9BOQd3/oGwOMQ4q//kSpd3TkMtPor
   1rBwSJwxQNaJLgOan35dlAGzJaTL3LfVJHF5bCqkaeWiYxt/FiUHYVYOE
   E=;
X-IronPort-AV: E=Sophos;i="5.78,393,1599523200"; 
   d="scan'208";a="70635442"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 04 Dec 2020 17:03:09 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 6AF2A2833C2;
        Fri,  4 Dec 2020 17:03:07 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.53) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 17:03:02 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     netdev <netdev@vger.kernel.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH net-next v2 4/4] af_vsock: Assign the vsock transport considering the vsock address flags
Date:   Fri, 4 Dec 2020 19:02:35 +0200
Message-ID: <20201204170235.84387-5-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20201204170235.84387-1-andraprs@amazon.com>
References: <20201204170235.84387-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.53]
X-ClientProxiedBy: EX13D23UWC003.ant.amazon.com (10.43.162.81) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vsock flags field can be set in the connect and (listen) receive
paths.

When the vsock transport is assigned, the remote CID is used to
distinguish between types of connection.

Use the vsock flags value (in addition to the CID) from the remote
address to decide which vsock transport to assign. For the sibling VMs
use case, all the vsock packets need to be forwarded to the host, so
always assign the guest->host transport if the VMADDR_FLAG_TO_HOST flag
is set. For the other use cases, the vsock transport assignment logic is
not changed.

Changelog

v1 -> v2

* Use bitwise operator to check the vsock flag.
* Use the updated "VMADDR_FLAG_TO_HOST" flag naming.
* Merge the checks for the g2h transport assignment in one "if" block.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 net/vmw_vsock/af_vsock.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 83d035eab0b05..66e643c3b5f85 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -421,7 +421,8 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
  * The vsk->remote_addr is used to decide which transport to use:
  *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
  *    g2h is not loaded, will use local transport;
- *  - remote CID <= VMADDR_CID_HOST will use guest->host transport;
+ *  - remote CID <= VMADDR_CID_HOST or h2g is not loaded or remote flags field
+ *    includes VMADDR_FLAG_TO_HOST flag value, will use guest->host transport;
  *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
  */
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
@@ -429,6 +430,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	const struct vsock_transport *new_transport;
 	struct sock *sk = sk_vsock(vsk);
 	unsigned int remote_cid = vsk->remote_addr.svm_cid;
+	unsigned short remote_flags;
 	int ret;
 
 	/* If the packet is coming with the source and destination CIDs higher
@@ -443,6 +445,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	    vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
 		vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
 
+	remote_flags = vsk->remote_addr.svm_flags;
+
 	switch (sk->sk_type) {
 	case SOCK_DGRAM:
 		new_transport = transport_dgram;
@@ -450,7 +454,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	case SOCK_STREAM:
 		if (vsock_use_local_transport(remote_cid))
 			new_transport = transport_local;
-		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g)
+		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
+			 (remote_flags & VMADDR_FLAG_TO_HOST) == VMADDR_FLAG_TO_HOST)
 			new_transport = transport_g2h;
 		else
 			new_transport = transport_h2g;
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

