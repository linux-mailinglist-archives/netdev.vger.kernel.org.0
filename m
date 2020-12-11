Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827DE2D73F3
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 11:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387708AbgLKKea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 05:34:30 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:35271 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730586AbgLKKdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 05:33:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607682827; x=1639218827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oMa58ipO9lk82GqsUITsDZKmPapfMMJiBG26d4CUhXw=;
  b=YXLnjiqPrSlCYQN83daa7vq/HrN6okOklrpDP3LARz2os2PDBjkNNRSq
   ZpeA9SRLpDXl9qRTktiuGF5ZqUPrHEHr76kZTvikYfH8VnSw5Fc7uQNVy
   qYPME+rNvuswVT/fo7fdiZFUzqqQk4y2OEXPB4ZZYCH3VRqGtZFMaiHt6
   U=;
X-IronPort-AV: E=Sophos;i="5.78,411,1599523200"; 
   d="scan'208";a="103438578"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 11 Dec 2020 10:33:00 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id EAE48A202D;
        Fri, 11 Dec 2020 10:32:58 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.252) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Dec 2020 10:32:53 +0000
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
Subject: [PATCH net-next v3 1/4] vm_sockets: Add flags field in the vsock address data structure
Date:   Fri, 11 Dec 2020 12:32:38 +0200
Message-ID: <20201211103241.17751-2-andraprs@amazon.com>
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

v2 -> v3

* Add "svm_flags" as a new field, not reusing "svm_reserved1".

v1 -> v2

* Update the field name to "svm_flags".
* Split the current patch in 2 patches.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/uapi/linux/vm_sockets.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index fd0ed7221645d..619f8e9d55ca4 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -148,10 +148,13 @@ struct sockaddr_vm {
 	unsigned short svm_reserved1;
 	unsigned int svm_port;
 	unsigned int svm_cid;
+	unsigned short svm_flags;
 	unsigned char svm_zero[sizeof(struct sockaddr) -
 			       sizeof(sa_family_t) -
 			       sizeof(unsigned short) -
-			       sizeof(unsigned int) - sizeof(unsigned int)];
+			       sizeof(unsigned int) -
+			       sizeof(unsigned int) -
+			       sizeof(unsigned short)];
 };
 
 #define IOCTL_VM_SOCKETS_GET_LOCAL_CID		_IO(7, 0xb9)
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

