Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BD02D73F5
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 11:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732697AbgLKKeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 05:34:21 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:35287 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730706AbgLKKdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 05:33:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607682831; x=1639218831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3eRzJpEWDyvkFeasgrVlf1SEht8OrvPE8hRj49UxTs8=;
  b=tBDi+r+pX21ibwfWBNJ68msHfkfYpss3axi8LJTkJ6+4KSa+giv2A9jY
   Wy/AXu/EJjXr0Sp6qVixu2XDOJ4mVSaqHkZeJ9Z1pmLWRuiXBJhVjrsnB
   QbISv/LnJEPuilhwNjAlHbfUVb0VvFvnhQzVCnfS3LHROc8+0i7YTHgwm
   4=;
X-IronPort-AV: E=Sophos;i="5.78,411,1599523200"; 
   d="scan'208";a="103438615"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 11 Dec 2020 10:33:10 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id 571F7120DB2;
        Fri, 11 Dec 2020 10:33:09 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.252) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Dec 2020 10:33:03 +0000
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
Subject: [PATCH net-next v3 3/4] af_vsock: Set VMADDR_FLAG_TO_HOST flag on the receive path
Date:   Fri, 11 Dec 2020 12:32:40 +0200
Message-ID: <20201211103241.17751-4-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20201211103241.17751-1-andraprs@amazon.com>
References: <20201211103241.17751-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.252]
X-ClientProxiedBy: EX13D28UWB003.ant.amazon.com (10.43.161.60) To
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

v2 -> v3

* No changes.

v1 -> v2

* Set the vsock flag on the receive path in the vsock transport
  assignment logic.
* Use bitwise operator for the vsock flag setup.
* Use the updated "VMADDR_FLAG_TO_HOST" flag naming.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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

