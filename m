Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB112CA702
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 16:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391863AbgLAP0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 10:26:19 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:32932 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391824AbgLAP0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 10:26:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606836378; x=1638372378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=175i00pbzLR8fa9gozvAYFUoomwH6U7DOj8Jpaq5o/M=;
  b=Lu2pcPuEogztCqgGp09gOo8HQtgELf3s4rLFXfoY3bTPFsqQFcr8SWdr
   hsmphTUH6WG8WKKjlVTm+osVJQSab1HAFDOwNZh/gkBHb8G3w7aIAeDnD
   9zahZQqzady1rX5surKImWMMkfSiHttSHvadIHwlom5GP0fljMbOHTYIn
   U=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="100825315"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 01 Dec 2020 15:25:30 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 9657D240F54;
        Tue,  1 Dec 2020 15:25:26 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com.com (10.43.162.176) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 15:25:21 +0000
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
Subject: [PATCH net-next v1 2/3] virtio_transport_common: Set sibling VMs flag on the receive path
Date:   Tue, 1 Dec 2020 17:25:04 +0200
Message-ID: <20201201152505.19445-3-andraprs@amazon.com>
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

The vsock flag can be set during the connect() setup logic, when
initializing the vsock address data structure variable. Then the vsock
transport is assigned, also considering this flag.

The vsock transport is also assigned on the (listen) receive path. The
flag needs to be set considering the use case.

Set the vsock flag of the remote address to the one targeted for sibling
VMs communication if the following conditions are met:

* The source CID of the packet is higher than VMADDR_CID_HOST.
* The destination CID of the packet is higher than VMADDR_CID_HOST.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 net/vmw_vsock/virtio_transport_common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 5956939eebb78..871c84e0916b1 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1062,6 +1062,14 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
 	vsock_addr_init(&vchild->remote_addr, le64_to_cpu(pkt->hdr.src_cid),
 			le32_to_cpu(pkt->hdr.src_port));
 
+	/* If the packet is coming with the source and destination CIDs higher
+	 * than VMADDR_CID_HOST, then a vsock channel should be established for
+	 * sibling VMs communication.
+	 */
+	if (vchild->local_addr.svm_cid > VMADDR_CID_HOST &&
+	    vchild->remote_addr.svm_cid > VMADDR_CID_HOST)
+		vchild->remote_addr.svm_flag = VMADDR_FLAG_SIBLING_VMS_COMMUNICATION;
+
 	ret = vsock_assign_transport(vchild, vsk);
 	/* Transport assigned (looking at remote_addr) must be the same
 	 * where we received the request.
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

