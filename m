Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E042CF28D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387546AbgLDRDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:03:53 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:51686 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731030AbgLDRDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 12:03:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607101433; x=1638637433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tZCq/DRAE1zJFmshKyLfUPPWc93kSnzv8L7Gn/h9u+Q=;
  b=N+vxj0T/5XAuJONCyCZDgtKgThDbOaqEbsGkyB1AcOMj2hjEY29SkVV6
   iX8eG+9VN/nJgC3RP4VBBQSmb/bNAcAxsq24dh1kvZt6r19F7hpNdvQ7d
   e/uEpKXobjerk/GpVmWA5K6owHFJ/MreRJ8e6eVBqOtqO4eN/1ZZ2jmLI
   4=;
X-IronPort-AV: E=Sophos;i="5.78,393,1599523200"; 
   d="scan'208";a="67389223"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 04 Dec 2020 17:03:05 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 7DEAAA1F92;
        Fri,  4 Dec 2020 17:03:02 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.53) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 17:02:56 +0000
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
Subject: [PATCH net-next v2 3/4] af_vsock: Set VMADDR_FLAG_TO_HOST flag on the receive path
Date:   Fri, 4 Dec 2020 19:02:34 +0200
Message-ID: <20201204170235.84387-4-andraprs@amazon.com>
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

The vsock flags can be set during the connect() setup logic, when
initializing the vsock address data structure variable. Then the vsock
transport is assigned, also considering this flags field.

The vsock transport is also assigned on the (listen) receive path. The
flags field needs to be set considering the use case.

Set the value of the vsock flags of the remote address to the one
targeted for packets forwarding to the host, if the following conditions
are met:

* The source CID of the packet is higher than VMADDR_CID_HOST.
* The destination CID of the packet is higher than VMADDR_CID_HOST.

Changelog

v1 -> v2

* Set the vsock flag on the receive path in the vsock transport
  assignment logic.
* Use bitwise operator for the vsock flag setup.
* Use the updated "VMADDR_FLAG_TO_HOST" flag naming.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 net/vmw_vsock/af_vsock.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d10916ab45267..83d035eab0b05 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -431,6 +431,18 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	unsigned int remote_cid = vsk->remote_addr.svm_cid;
 	int ret;
 
+	/* If the packet is coming with the source and destination CIDs higher
+	 * than VMADDR_CID_HOST, then a vsock channel where all the packets are
+	 * forwarded to the host should be established. Then the host will
+	 * need to forward the packets to the guest.
+	 *
+	 * The flag is set on the (listen) receive path (psk is not NULL). On
+	 * the connect path the flag can be set by the user space application.
+	 */
+	if (psk && vsk->local_addr.svm_cid > VMADDR_CID_HOST &&
+	    vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
+		vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
+
 	switch (sk->sk_type) {
 	case SOCK_DGRAM:
 		new_transport = transport_dgram;
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

