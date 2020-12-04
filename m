Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E635C2CF28A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbgLDRDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:03:51 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:42969 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730853AbgLDRDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 12:03:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607101431; x=1638637431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EYyiM8pBDoGfKUmrseZ/LVOnGoEY+oZtRzvsUQrt6e0=;
  b=FlLY2gJiDxb6OFOOC2kw4vRtlP/GxWlwXiWwJyD4L7QqCHNMhKyYnI//
   NqrtOsZ0y09RFWI1FDcHToHEM6dIXAwUSFUV0inhH92IrdnhVIUxxkOeu
   En1VbKea23cTEi6C5kYPwReS9SOkwOeYTc+Gwjm8woRLBHX2/mTEpX25d
   c=;
X-IronPort-AV: E=Sophos;i="5.78,393,1599523200"; 
   d="scan'208";a="93565775"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-c7f73527.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 04 Dec 2020 17:03:00 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-c7f73527.us-east-1.amazon.com (Postfix) with ESMTPS id 2DD21B103E;
        Fri,  4 Dec 2020 17:02:56 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.53) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 17:02:51 +0000
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
Subject: [PATCH net-next v2 2/4] vm_sockets: Add VMADDR_FLAG_TO_HOST vsock flag
Date:   Fri, 4 Dec 2020 19:02:33 +0200
Message-ID: <20201204170235.84387-3-andraprs@amazon.com>
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

Add VMADDR_FLAG_TO_HOST vsock flag that is used to setup a vsock
connection where all the packets are forwarded to the host.

Then, using this type of vsock channel, vsock communication between
sibling VMs can be built on top of it.

Changelog

v1 -> v2

* New patch in v2, it was split from the first patch in the series.
* Remove the default value for the vsock flags field.
* Update the naming for the vsock flag to "VMADDR_FLAG_TO_HOST".

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 include/uapi/linux/vm_sockets.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index 46735376a57a8..72e1a3d05682d 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -114,6 +114,21 @@
 
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
+ */
+#define VMADDR_FLAG_TO_HOST 0x0001
+
 /* Invalid vSockets version. */
 
 #define VM_SOCKETS_INVALID_VERSION -1U
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

