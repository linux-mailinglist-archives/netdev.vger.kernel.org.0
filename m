Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F8830A84E
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 14:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhBANHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 08:07:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231489AbhBANHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 08:07:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612184768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6DDFlumTehUaRYr4O1LIVMwqMGra9RibhaImhvBuKNU=;
        b=aHDCLN400zDMOyWthv+nvFGZMnqKN0XSE9KhjGTq3+Q/mqrEhQQB0Rv+gfyNkpou0A2+q7
        zn8SL6+eQviDnEtd25vpTWKsWgSx7PJ0gabCkxk/zIGq/myh1hioluQDhD9ybkkbHCbqJi
        x50+fEKVooXGqZwQl/I2ilZGXV98Isk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-mJDahxL7NEGPHDoNjZ2wEw-1; Mon, 01 Feb 2021 08:06:04 -0500
X-MC-Unique: mJDahxL7NEGPHDoNjZ2wEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2356B801817;
        Mon,  1 Feb 2021 13:06:03 +0000 (UTC)
Received: from computer-6.station (unknown [10.40.192.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64DCA10016DB;
        Mon,  1 Feb 2021 13:06:01 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next v3] mptcp: fix length of MP_PRIO suboption
Date:   Mon,  1 Feb 2021 14:05:26 +0100
Message-Id: <846cdd41e6ad6ec88ef23fee1552ab39c2f5a3d1.1612184361.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With version 0 of the protocol it was legal to encode the 'Subflow Id' in
the MP_PRIO suboption, to specify which subflow would change its 'Backup'
flag. This has been removed from v1 specification: thus, according to RFC
8684 §3.3.8, the resulting 'Length' for MP_PRIO changed from 4 to 3 byte.

Current Linux generates / parses MP_PRIO according to the old spec, using
'Length' equal to 4, and hardcoding 1 as 'Subflow Id'; RFC compliance can
improve if we change 'Length' in other to become 3, leaving a 'Nop' after
the MP_PRIO suboption. In this way the kernel will emit and accept *only*
MP_PRIO suboptions that are compliant to version 1 of the MPTCP protocol.

 unpatched 5.11-rc kernel:
 [root@bottarga ~]# tcpdump -tnnr unpatched.pcap | grep prio
 reading from file unpatched.pcap, link-type LINUX_SLL (Linux cooked v1)
 dropped privs to tcpdump
 IP 10.0.3.2.48433 > 10.0.1.1.10006: Flags [.], ack 1, win 502, options [nop,nop,TS val 4032325513 ecr 1876514270,mptcp prio non-backup id 1,mptcp dss ack 14084896651682217737], length 0

 patched 5.11-rc kernel:
 [root@bottarga ~]# tcpdump -tnnr patched.pcap | grep prio
 reading from file patched.pcap, link-type LINUX_SLL (Linux cooked v1)
 dropped privs to tcpdump
 IP 10.0.3.2.49735 > 10.0.1.1.10006: Flags [.], ack 1, win 502, options [nop,nop,TS val 1276737699 ecr 2686399734,mptcp prio non-backup,nop,mptcp dss ack 18433038869082491686], length 0

Changes since v2:
 - when accounting for option space, don't increment 'TCPOLEN_MPTCP_PRIO'
   and use 'TCPOLEN_MPTCP_PRIO_ALIGN' instead, thanks to Matthieu Baerts.
Changes since v1:
 - refactor patch to avoid using 'TCPOLEN_MPTCP_PRIO' with its old value,
   thanks to Geliang Tang.

Fixes: 067065422fcd ("mptcp: add the outgoing MP_PRIO support")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/options.c  | 5 +++--
 net/mptcp/protocol.h | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index c9643344a8d7..17ad42c65087 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -699,10 +699,11 @@ static bool mptcp_established_options_mp_prio(struct sock *sk,
 	if (!subflow->send_mp_prio)
 		return false;
 
-	if (remaining < TCPOLEN_MPTCP_PRIO)
+	/* account for the trailing 'nop' option */
+	if (remaining < TCPOLEN_MPTCP_PRIO_ALIGN)
 		return false;
 
-	*size = TCPOLEN_MPTCP_PRIO;
+	*size = TCPOLEN_MPTCP_PRIO_ALIGN;
 	opts->suboptions |= OPTION_MPTCP_PRIO;
 	opts->backup = subflow->request_bkup;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 1460705aaad0..07ee319f7847 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -60,7 +60,8 @@
 #define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	24
 #define TCPOLEN_MPTCP_PORT_LEN		4
 #define TCPOLEN_MPTCP_RM_ADDR_BASE	4
-#define TCPOLEN_MPTCP_PRIO		4
+#define TCPOLEN_MPTCP_PRIO		3
+#define TCPOLEN_MPTCP_PRIO_ALIGN	4
 #define TCPOLEN_MPTCP_FASTCLOSE		12
 
 /* MPTCP MP_JOIN flags */
-- 
2.29.2

