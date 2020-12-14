Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA0E2D9C3D
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440171AbgLNQNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:13:01 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:17431 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440129AbgLNQMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:12:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607962374; x=1639498374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zXFK+MoocoSV73CfHWbUW2KCkZcW9mL6RBYOgT9upFg=;
  b=C5KZOmC9oy1NgaW0BsLMJ5LQIn5HujHWlzs2nHAyfgWmylFwT/O7iwvM
   sbaNOR0/LpoT3Y3PQ3vTuy9nwM3OAk1Q8mabTEKB3L0AZZjzQtRVE2x4a
   utk6fHSMXEuubrTHAci0Dr3y4vM+3y2hAi3pc1/YKxtAGpbMELA7I6UI7
   4=;
X-IronPort-AV: E=Sophos;i="5.78,420,1599523200"; 
   d="scan'208";a="72496270"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 14 Dec 2020 16:12:06 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 22E13A19BB;
        Mon, 14 Dec 2020 16:12:06 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com.com (10.43.160.21) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Dec 2020 16:12:00 +0000
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
Subject: [PATCH net-next v4 5/5] af_vsock: Assign the vsock transport considering the vsock address flags
Date:   Mon, 14 Dec 2020 18:11:22 +0200
Message-ID: <20201214161122.37717-6-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20201214161122.37717-1-andraprs@amazon.com>
References: <20201214161122.37717-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.21]
X-ClientProxiedBy: EX13D23UWC001.ant.amazon.com (10.43.162.196) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vsock flags field can be set in the connect path (user space app)
and the (listen) receive path (kernel space logic).

When the vsock transport is assigned, the remote CID is used to
distinguish between types of connection.

Use the vsock flags value (in addition to the CID) from the remote
address to decide which vsock transport to assign. For the sibling VMs
use case, all the vsock packets need to be forwarded to the host, so
always assign the guest->host transport if the VMADDR_FLAG_TO_HOST flag
is set. For the other use cases, the vsock transport assignment logic is
not changed.

Changelog

v3 -> v4

* Update the "remote_flags" local variable type to reflect the change of
  the "svm_flags" field to be 1 byte in size.

v2 -> v3

* Update bitwise check logic to not compare result to the flag value.

v1 -> v2

* Use bitwise operator to check the vsock flag.
* Use the updated "VMADDR_FLAG_TO_HOST" flag naming.
* Merge the checks for the g2h transport assignment in one "if" block.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 83d035eab0b05..fc484fb37fffb 100644
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
+	__u8 remote_flags;
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
+			 (remote_flags & VMADDR_FLAG_TO_HOST))
 			new_transport = transport_g2h;
 		else
 			new_transport = transport_h2g;
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

