Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0BF3309D9
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 10:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhCHJAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 04:00:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229737AbhCHJA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 04:00:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615194028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vrWUpIGtgFZn7irbq7MRye/8EbAlu1J6dvDk6oFAR6E=;
        b=DWdCHv646jwsyeg7T0XM6aRZ7aiJKA+BNUYc0WJFhAy2wBh8WOWNbsUO2lSNN5ZhFnAgZK
        fpnXjlNdggMyLzKDz4ky2Fz4/0jeWbXlk3h2/6hG4AS1MxzSTV8V7nU/rwZN9ZdC3D9hql
        DZ9d8kgkekZ3TeevC9/gw9hEzql6Doo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-ybqmKa0dPRmKm9IE5XZdmQ-1; Mon, 08 Mar 2021 04:00:23 -0500
X-MC-Unique: ybqmKa0dPRmKm9IE5XZdmQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02AD857;
        Mon,  8 Mar 2021 09:00:22 +0000 (UTC)
Received: from computer-6.station (unknown [10.40.192.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3738A19D7C;
        Mon,  8 Mar 2021 09:00:20 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH net] mptcp: fix length of ADD_ADDR with port sub-option
Date:   Mon,  8 Mar 2021 10:00:04 +0100
Message-Id: <66b3a2eec724af07ffdb04fefc6c7d50b85f296b.1615191605.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in current Linux, MPTCP peers advertising endpoints with port numbers use
a sub-option length that wrongly accounts for the trailing TCP NOP. Also,
receivers will only process incoming ADD_ADDR with port having such wrong
sub-option length. Fix this, making ADD_ADDR compliant to RFC8684 §3.4.1.

this can be verified running tcpdump on the kselftests artifacts:

 unpatched kernel:
 [root@bottarga mptcp]# tcpdump -tnnr unpatched.pcap | grep add-addr
 reading from file unpatched.pcap, link-type LINUX_SLL (Linux cooked v1), snapshot length 65535
 IP 10.0.1.1.10000 > 10.0.1.2.53078: Flags [.], ack 101, win 509, options [nop,nop,TS val 214459678 ecr 521312851,mptcp add-addr v1 id 1 a00:201:2774:2d88:7436:85c3:17fd:101], length 0
 IP 10.0.1.2.53078 > 10.0.1.1.10000: Flags [.], ack 101, win 502, options [nop,nop,TS val 521312852 ecr 214459678,mptcp add-addr[bad opt]]

 patched kernel:
 [root@bottarga mptcp]# tcpdump -tnnr patched.pcap | grep add-addr
 reading from file patched.pcap, link-type LINUX_SLL (Linux cooked v1), snapshot length 65535
 IP 10.0.1.1.10000 > 10.0.1.2.38178: Flags [.], ack 101, win 509, options [nop,nop,TS val 3728873902 ecr 2732713192,mptcp add-addr v1 id 1 10.0.2.1:10100 hmac 0xbccdfcbe59292a1f,nop,nop], length 0
 IP 10.0.1.2.38178 > 10.0.1.1.10000: Flags [.], ack 101, win 502, options [nop,nop,TS val 2732713195 ecr 3728873902,mptcp add-addr v1-echo id 1 10.0.2.1:10100,nop,nop], length 0

Fixes: 22fb85ffaefb ("mptcp: add port support for ADD_ADDR suboption writing")
CC: stable@vger.kernel.org # 5.11+
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-and-tested-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/protocol.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 91827d949766..e21a5bc36cf0 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -52,14 +52,15 @@
 #define TCPOLEN_MPTCP_DSS_MAP64		14
 #define TCPOLEN_MPTCP_DSS_CHECKSUM	2
 #define TCPOLEN_MPTCP_ADD_ADDR		16
-#define TCPOLEN_MPTCP_ADD_ADDR_PORT	20
+#define TCPOLEN_MPTCP_ADD_ADDR_PORT	18
 #define TCPOLEN_MPTCP_ADD_ADDR_BASE	8
-#define TCPOLEN_MPTCP_ADD_ADDR_BASE_PORT	12
+#define TCPOLEN_MPTCP_ADD_ADDR_BASE_PORT	10
 #define TCPOLEN_MPTCP_ADD_ADDR6		28
-#define TCPOLEN_MPTCP_ADD_ADDR6_PORT	32
+#define TCPOLEN_MPTCP_ADD_ADDR6_PORT	30
 #define TCPOLEN_MPTCP_ADD_ADDR6_BASE	20
-#define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	24
-#define TCPOLEN_MPTCP_PORT_LEN		4
+#define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	22
+#define TCPOLEN_MPTCP_PORT_LEN		2
+#define TCPOLEN_MPTCP_PORT_ALIGN	2
 #define TCPOLEN_MPTCP_RM_ADDR_BASE	4
 #define TCPOLEN_MPTCP_PRIO		3
 #define TCPOLEN_MPTCP_PRIO_ALIGN	4
@@ -701,8 +702,9 @@ static inline unsigned int mptcp_add_addr_len(int family, bool echo, bool port)
 		len = TCPOLEN_MPTCP_ADD_ADDR6_BASE;
 	if (!echo)
 		len += MPTCPOPT_THMAC_LEN;
+	/* account for 2 trailing 'nop' options */
 	if (port)
-		len += TCPOLEN_MPTCP_PORT_LEN;
+		len += TCPOLEN_MPTCP_PORT_LEN + TCPOLEN_MPTCP_PORT_ALIGN;
 
 	return len;
 }
-- 
2.29.2

