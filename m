Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E212D9C3A
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440099AbgLNQMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:12:47 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:34962 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440157AbgLNQMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:12:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607962351; x=1639498351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H4hUrpQkQaB99khaw2z1dTFINxPyA41ufrSv3EMjN5Y=;
  b=HPMPK/1ICe6H9nwv7sBj3H30oHf++hvkps7e69IcdWP7EAoA3LeMXrps
   AfxtVKf2mlwklOOU8byq8NYv7cEbqwra2Mv/SYt6HnNHQD8ipJ8X1OKbx
   aacn/CTXBbip84z/3yOpaTUrYDByGGzaeAgKXu2MzQB6E855dq0CHIzwq
   I=;
X-IronPort-AV: E=Sophos;i="5.78,420,1599523200"; 
   d="scan'208";a="104127375"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 14 Dec 2020 16:11:42 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 4F8C1240B38;
        Mon, 14 Dec 2020 16:11:39 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com.com (10.43.160.21) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Dec 2020 16:11:33 +0000
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
Subject: [PATCH net-next v4 1/5] vm_sockets: Add flags field in the vsock address data structure
Date:   Mon, 14 Dec 2020 18:11:18 +0200
Message-ID: <20201214161122.37717-2-andraprs@amazon.com>
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

vsock enables communication between virtual machines and the host they
are running on. With the multi transport support (guest->host and
host->guest), nested VMs can also use vsock channels for communication.

In addition to this, by default, all the vsock packets are forwarded to
the host, if no host->guest transport is loaded. This behavior can be
implicitly used for enabling vsock communication between sibling VMs.

Add a flags field in the vsock address data structure that can be used
to explicitly mark the vsock connection as being targeted for a certain
type of communication. This way, can distinguish between different use
cases such as nested VMs and sibling VMs.

This field can be set when initializing the vsock address variable used
for the connect() call.

Changelog

v3 -> v4

* Update the size of "svm_flags" field to be 1 byte instead of 2 bytes.

v2 -> v3

* Add "svm_flags" as a new field, not reusing "svm_reserved1".

v1 -> v2

* Update the field name to "svm_flags".
* Split the current patch in 2 patches.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/uapi/linux/vm_sockets.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index fd0ed7221645d..c2eac3d0a9f00 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -18,6 +18,7 @@
 #define _UAPI_VM_SOCKETS_H
 
 #include <linux/socket.h>
+#include <linux/types.h>
 
 /* Option name for STREAM socket buffer size.  Use as the option name in
  * setsockopt(3) or getsockopt(3) to set or get an unsigned long long that
@@ -148,10 +149,13 @@ struct sockaddr_vm {
 	unsigned short svm_reserved1;
 	unsigned int svm_port;
 	unsigned int svm_cid;
+	__u8 svm_flags;
 	unsigned char svm_zero[sizeof(struct sockaddr) -
 			       sizeof(sa_family_t) -
 			       sizeof(unsigned short) -
-			       sizeof(unsigned int) - sizeof(unsigned int)];
+			       sizeof(unsigned int) -
+			       sizeof(unsigned int) -
+			       sizeof(__u8)];
 };
 
 #define IOCTL_VM_SOCKETS_GET_LOCAL_CID		_IO(7, 0xb9)
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

