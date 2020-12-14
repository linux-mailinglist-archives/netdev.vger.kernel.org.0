Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885E92D9C46
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440195AbgLNQP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:15:29 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:35013 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440167AbgLNQMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:12:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607962352; x=1639498352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/HJXDyhDQPI8rjCBAGpOdjJBK7W2eXwWXiezPz2E/Y4=;
  b=sylFxu28ForbKG9tCHwSPWgt2f1yFwCXt609jWjxck5CATBV14Lf8gyO
   7qvBvHz33+f97fgVQ05RVurrp515MAENzCCg1L04ApDjvY3Egj/VnLarg
   cCrdAVbEtna1Ioi7pP7ZHMVQnpywFbEAyZ4hS45xvxaRPMxzfRv23+2wL
   o=;
X-IronPort-AV: E=Sophos;i="5.78,420,1599523200"; 
   d="scan'208";a="104127436"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 14 Dec 2020 16:11:51 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 7E4E3A04C9;
        Mon, 14 Dec 2020 16:11:50 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com.com (10.43.160.21) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Dec 2020 16:11:44 +0000
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
Subject: [PATCH net-next v4 3/5] vsock_addr: Check for supported flag values
Date:   Mon, 14 Dec 2020 18:11:20 +0200
Message-ID: <20201214161122.37717-4-andraprs@amazon.com>
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

Check if the provided flags value from the vsock address data structure
includes the supported flags in the corresponding kernel version.

The first byte of the "svm_zero" field is used as "svm_flags", so add
the flags check instead.

Changelog

v3 -> v4

* New patch in v4.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 net/vmw_vsock/vsock_addr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/vsock_addr.c b/net/vmw_vsock/vsock_addr.c
index 909de26cb0e70..223b9660a759f 100644
--- a/net/vmw_vsock/vsock_addr.c
+++ b/net/vmw_vsock/vsock_addr.c
@@ -22,13 +22,15 @@ EXPORT_SYMBOL_GPL(vsock_addr_init);
 
 int vsock_addr_validate(const struct sockaddr_vm *addr)
 {
+	__u8 svm_valid_flags = VMADDR_FLAG_TO_HOST;
+
 	if (!addr)
 		return -EFAULT;
 
 	if (addr->svm_family != AF_VSOCK)
 		return -EAFNOSUPPORT;
 
-	if (addr->svm_zero[0] != 0)
+	if (addr->svm_flags & ~svm_valid_flags)
 		return -EINVAL;
 
 	return 0;
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

