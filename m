Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC902CF287
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgLDRDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:03:43 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:25286 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgLDRDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 12:03:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607101422; x=1638637422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G7auZkc6T08G0jXKQkzjcTF8QZO5GeMAp4AHovLuciA=;
  b=obt606+gfnJbJQqQ3p1Us/ssciAxLMNhZBUlz9jCqodT9Fe2hQR4FdCG
   Bmru/a2JB4nwh2sKmknggTGR7tDEvJTphY1c1ak/T64oJ9mJoGV5mrgl0
   UVNzwW/6HwohomDmiV+8mJ6BpVCJ7foDMUnvzO2t49ttuUhR2Bluhl5HI
   g=;
X-IronPort-AV: E=Sophos;i="5.78,393,1599523200"; 
   d="scan'208";a="900684958"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 04 Dec 2020 17:02:55 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id 5B6CE1010E5;
        Fri,  4 Dec 2020 17:02:52 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.53) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 17:02:46 +0000
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
Subject: [PATCH net-next v2 1/4] vm_sockets: Include flags field in the vsock address data structure
Date:   Fri, 4 Dec 2020 19:02:32 +0200
Message-ID: <20201204170235.84387-2-andraprs@amazon.com>
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

Use the already available "svm_reserved1" field and mark it as a flags
field instead. This field can be set when initializing the vsock address
variable used for the connect() call.

Changelog

v1 -> v2

* Update the field name to "svm_flags".
* Split the current patch in 2 patches.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 include/uapi/linux/vm_sockets.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index fd0ed7221645d..46735376a57a8 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -145,7 +145,7 @@
 
 struct sockaddr_vm {
 	__kernel_sa_family_t svm_family;
-	unsigned short svm_reserved1;
+	unsigned short svm_flags;
 	unsigned int svm_port;
 	unsigned int svm_cid;
 	unsigned char svm_zero[sizeof(struct sockaddr) -
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

