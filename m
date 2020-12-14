Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3B92D9C40
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440187AbgLNQOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:14:08 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20625 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439358AbgLNQMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:12:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607962366; x=1639498366;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MAH6GOf+jbflt4y3GeDXU0Z0K7yx0pYZRgOrJ1MMZK8=;
  b=G7kqxoPg7WQrftpWnlk9it1lXRJZTFUvnbDhh79mbPKv9m/Pmj/H4Wis
   Relw0WcK0TMdnau24kq7wCvAV7R2ZT53xgng8MklBsiEiHOxkTHe+dFlx
   dl1fEh7vA1nCVAK0jFoxtXlSrD9xTa17bkBTN+eX9szFnvJ6PiUfvTRBP
   Q=;
X-IronPort-AV: E=Sophos;i="5.78,420,1599523200"; 
   d="scan'208";a="68997978"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 14 Dec 2020 16:11:59 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id E425B100FA3;
        Mon, 14 Dec 2020 16:11:55 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com.com (10.43.160.21) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Dec 2020 16:11:50 +0000
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
Subject: [PATCH net-next v4 4/5] af_vsock: Set VMADDR_FLAG_TO_HOST flag on the receive path
Date:   Mon, 14 Dec 2020 18:11:21 +0200
Message-ID: <20201214161122.37717-5-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20201214161122.37717-1-andraprs@amazon.com>
References: <20201214161122.37717-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.21]
X-ClientProxiedBy: EX13D14UWC001.ant.amazon.com (10.43.162.5) To
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

v3 -> v4

* No changes.

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

