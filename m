Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7412D7402
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 11:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391589AbgLKKgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 05:36:24 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:30305 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389482AbgLKKgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 05:36:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607682965; x=1639218965;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q/GCUUPD33jv3eCey1WgNMDq3Oa0SVVCKraSLnKr6Bk=;
  b=fMhQAizr03+TtY0p8Z4B2m6qz5SsRHlmaM7Vs+/+shEtNaZYdvE+mzV/
   ny30YdumEpf0NaPI6PBgFLp+Rxa/pNvIrgERBjyx0n0MokP+15eee+P5R
   gJ8ScH0hX4NHvfeiYv6f+1RN1bNEag5Y4LujINBHU4z+yLAdkV5ROZJ16
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,411,1599523200"; 
   d="scan'208";a="70498097"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 11 Dec 2020 10:35:18 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 7341EA03F7;
        Fri, 11 Dec 2020 10:33:05 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.252) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Dec 2020 10:32:58 +0000
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
Subject: [PATCH net-next v3 2/4] vm_sockets: Add VMADDR_FLAG_TO_HOST vsock flag
Date:   Fri, 11 Dec 2020 12:32:39 +0200
Message-ID: <20201211103241.17751-3-andraprs@amazon.com>
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

Add VMADDR_FLAG_TO_HOST vsock flag that is used to setup a vsock
connection where all the packets are forwarded to the host.

Then, using this type of vsock channel, vsock communication between
sibling VMs can be built on top of it.

Changelog

v2 -> v3

* Update comments to mention when the flag is set in the connect and
  listen paths.

v1 -> v2

* New patch in v2, it was split from the first patch in the series.
* Remove the default value for the vsock flags field.
* Update the naming for the vsock flag to "VMADDR_FLAG_TO_HOST".

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 include/uapi/linux/vm_sockets.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index 619f8e9d55ca4..c99ed29602345 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -114,6 +114,26 @@
 
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
+#define VMADDR_FLAG_TO_HOST 0x0001
+
 /* Invalid vSockets version. */
 
 #define VM_SOCKETS_INVALID_VERSION -1U
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

