Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676572D9C77
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440194AbgLNQPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:15:22 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:42202 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733040AbgLNQMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:12:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607962358; x=1639498358;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+bD4XI/eWkVL39fO8zY/pSMhntXw5GOQyCDbl21vd6E=;
  b=RUX/cpDYJZKqTxEYGWgP2lVEnC9qjZ0pdS4/f7ROnB8or9I0e4ZDkvKg
   1o2sEMM06qAE9EbtCwK8YhKNyO60GWHtME7tPM2bCRRXtxV2GfBd1yAg8
   ARgA/xk88gdNWajA+OxCtBwsSHNhXcNDh3L4N1HsiG5vvpRsyF+Gt+uef
   g=;
X-IronPort-AV: E=Sophos;i="5.78,420,1599523200"; 
   d="scan'208";a="95839141"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 14 Dec 2020 16:11:50 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 7971E14000B;
        Mon, 14 Dec 2020 16:11:45 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com.com (10.43.160.21) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Dec 2020 16:11:38 +0000
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
Subject: [PATCH net-next v4 2/5] vm_sockets: Add VMADDR_FLAG_TO_HOST vsock flag
Date:   Mon, 14 Dec 2020 18:11:19 +0200
Message-ID: <20201214161122.37717-3-andraprs@amazon.com>
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

Add VMADDR_FLAG_TO_HOST vsock flag that is used to setup a vsock
connection where all the packets are forwarded to the host.

Then, using this type of vsock channel, vsock communication between
sibling VMs can be built on top of it.

Changelog

v3 -> v4

* Update the "VMADDR_FLAG_TO_HOST" value, as the size of the field has
  been updated to 1 byte.

v2 -> v3

* Update comments to mention when the flag is set in the connect and
  listen paths.

v1 -> v2

* New patch in v2, it was split from the first patch in the series.
* Remove the default value for the vsock flags field.
* Update the naming for the vsock flag to "VMADDR_FLAG_TO_HOST".

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/uapi/linux/vm_sockets.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index c2eac3d0a9f00..46918a1852d7b 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -115,6 +115,26 @@
 
 #define VMADDR_CID_HOST 2
 
+/* The current default use case for the vsock channel is the following:
+ * local vsock communication between guest and host and nested VMs setup.
+ * In addition to this, implicitly, the vsock packets are forwarded to the host
+ * if no host->guest vsock transport is set.
+ *
+ * Set this flag value in the sockaddr_vm corresponding field if the vsock
+ * packets need to be always forwarded to the host. Using this behavior,
+ * vsock communication between sibling VMs can be setup.
+ *
+ * This way can explicitly distinguish between vsock channels created for
+ * different use cases, such as nested VMs (or local communication between
+ * guest and host) and sibling VMs.
+ *
+ * The flag can be set in the connect logic in the user space application flow.
+ * In the listen logic (from kernel space) the flag is set on the remote peer
+ * address. This happens for an incoming connection when it is routed from the
+ * host and comes from the guest (local CID and remote CID > VMADDR_CID_HOST).
+ */
+#define VMADDR_FLAG_TO_HOST 0x01
+
 /* Invalid vSockets version. */
 
 #define VM_SOCKETS_INVALID_VERSION -1U
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

