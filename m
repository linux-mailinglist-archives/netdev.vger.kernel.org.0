Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C502CA700
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 16:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391851AbgLAP0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 10:26:16 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:64330 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391824AbgLAP0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 10:26:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606836375; x=1638372375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AaeVZAF1wZ8NpfHttbjVJiQ9rkcyAab+ouMMPH5SPnI=;
  b=eVwbWXer1Hi7FKjpjIvXvlpSPOBQjQnjLdS4fsa7O0Hstltk49b9Lg3x
   dnWzwXBtD4yBwf9SoLiDHW7RXpLVXuPETA4MHd8XDWgeKjc0p+PTF1VZO
   zbVdi4ILQ75BN+APH/UKkEMDvHYk8PMn/bY9Ur/Nqf7N36F4UyNt0zfEz
   w=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="92555288"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Dec 2020 15:25:24 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id C72802421DB;
        Tue,  1 Dec 2020 15:25:21 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com.com (10.43.162.176) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 15:25:16 +0000
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
Subject: [PATCH net-next v1 1/3] vm_sockets: Include flag field in the vsock address data structure
Date:   Tue, 1 Dec 2020 17:25:03 +0200
Message-ID: <20201201152505.19445-2-andraprs@amazon.com>
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

vsock enables communication between virtual machines and the host they
are running on. With the multi transport support (guest->host and
host->guest), nested VMs can also use vsock channels for communication.

In addition to this, by default, all the vsock packets are forwarded to
the host, if no host->guest transport is loaded. This behavior can be
implicitly used for enabling vsock communication between sibling VMs.

Add a flag field in the vsock address data structure that can be used to
explicitly mark the vsock connection as being targeted for a certain
type of communication. This way, can distinguish between nested VMs and
sibling VMs use cases and can also setup them at the same time. Till
now, could either have nested VMs or sibling VMs at a time using the
vsock communication stack.

Use the already available "svm_reserved1" field and mark it as a flag
field instead. This flag can be set when initializing the vsock address
variable used for the connect() call.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 include/uapi/linux/vm_sockets.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index fd0ed7221645d..58da5a91413ac 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -114,6 +114,22 @@
 
 #define VMADDR_CID_HOST 2
 
+/* This sockaddr_vm flag value covers the current default use case:
+ * local vsock communication between guest and host and nested VMs setup.
+ * In addition to this, implicitly, the vsock packets are forwarded to the host
+ * if no host->guest vsock transport is set.
+ */
+#define VMADDR_FLAG_DEFAULT_COMMUNICATION	0x0000
+
+/* Set this flag value in the sockaddr_vm corresponding field if the vsock
+ * channel needs to be setup between two sibling VMs running on the same host.
+ * This way can explicitly distinguish between vsock channels created for nested
+ * VMs (or local communication between guest and host) and the ones created for
+ * sibling VMs. And vsock channels for multiple use cases (nested / sibling VMs)
+ * can be setup at the same time.
+ */
+#define VMADDR_FLAG_SIBLING_VMS_COMMUNICATION	0x0001
+
 /* Invalid vSockets version. */
 
 #define VM_SOCKETS_INVALID_VERSION -1U
@@ -145,7 +161,7 @@
 
 struct sockaddr_vm {
 	__kernel_sa_family_t svm_family;
-	unsigned short svm_reserved1;
+	unsigned short svm_flag;
 	unsigned int svm_port;
 	unsigned int svm_cid;
 	unsigned char svm_zero[sizeof(struct sockaddr) -
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

