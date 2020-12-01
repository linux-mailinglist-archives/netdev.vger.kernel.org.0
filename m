Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B6E2CA704
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 16:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391874AbgLAP0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 10:26:24 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:6198 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390460AbgLAP0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 10:26:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606836383; x=1638372383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tsxlIUCNI2krlVx3neb8cyiIbG3hMUeUhuHM8BlO3mg=;
  b=P0BYwBLu1l3BhB1TvzpP/KPwUP4eOg+31ANouiHPhy2gYWlPw5cVG173
   kEdpnBz0yQhBCvfUxdU4td+GH0Gh+rSEKT6X21R0CFhzIxeNHGYpAYt0V
   kkbeKgftRE1r/wcIM8CdfehJ49h0S+xiRseLlQ9EAobw+Hk+5H3dboSMF
   Q=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="66964389"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 01 Dec 2020 15:25:36 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id ABA01A177C;
        Tue,  1 Dec 2020 15:25:31 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com.com (10.43.162.176) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 15:25:26 +0000
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
Subject: [PATCH net-next v1 3/3] af_vsock: Assign the vsock transport considering the vsock address flag
Date:   Tue, 1 Dec 2020 17:25:05 +0200
Message-ID: <20201201152505.19445-4-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20201201152505.19445-1-andraprs@amazon.com>
References: <20201201152505.19445-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.176]
X-ClientProxiedBy: EX13D13UWA003.ant.amazon.com (10.43.160.181) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vsock flag has been set in the connect and (listen) receive paths.

When the vsock transport is assigned, the remote CID is used to
distinguish between types of connection.

Use the vsock flag (in addition to the CID) from the remote address to
decide which vsock transport to assign. For the sibling VMs use case,
all the vsock packets need to be forwarded to the host, so always assign
the guest->host transport if the vsock flag is set. For the other use
cases, the vsock transport assignment logic is not changed.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 net/vmw_vsock/af_vsock.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d10916ab45267..bafc1cb20abd4 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -419,16 +419,21 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
  * (e.g. during the connect() or when a connection request on a listener
  * socket is received).
  * The vsk->remote_addr is used to decide which transport to use:
- *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
- *    g2h is not loaded, will use local transport;
- *  - remote CID <= VMADDR_CID_HOST will use guest->host transport;
- *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
+ *  - remote flag == VMADDR_FLAG_SIBLING_VMS_COMMUNICATION, will always
+ *    forward the vsock packets to the host and use guest->host transport;
+ *  - otherwise, going forward with the remote flag default value:
+ *    - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST
+ *      if g2h is not loaded, will use local transport;
+ *    - remote CID <= VMADDR_CID_HOST or h2g is not loaded, will use
+ *      guest->host transport;
+ *    - remote CID > VMADDR_CID_HOST will use host->guest transport;
  */
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 {
 	const struct vsock_transport *new_transport;
 	struct sock *sk = sk_vsock(vsk);
 	unsigned int remote_cid = vsk->remote_addr.svm_cid;
+	unsigned short remote_flag = vsk->remote_addr.svm_flag;
 	int ret;
 
 	switch (sk->sk_type) {
@@ -438,6 +443,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	case SOCK_STREAM:
 		if (vsock_use_local_transport(remote_cid))
 			new_transport = transport_local;
+		else if (remote_flag == VMADDR_FLAG_SIBLING_VMS_COMMUNICATION)
+			new_transport = transport_g2h;
 		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g)
 			new_transport = transport_g2h;
 		else
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

