Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01DA1C694B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgEFGrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:47:31 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:51597 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727812AbgEFGra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:47:30 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2020 02:47:30 EDT
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 5 May 2020 23:32:25 -0700
Received: from localhost.localdomain (ashwinh-vm-1.vmware.com [10.110.19.225])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id ACE81400A2;
        Tue,  5 May 2020 23:32:25 -0700 (PDT)
From:   ashwin-h <ashwinh@vmware.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>
CC:     <davem@davemloft.net>, <linux-sctp@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <rostedt@goodmis.org>, <srostedt@vmware.com>,
        <gregkh@linuxfoundation.org>, <ashwin.hiranniah@gmail.com>,
        Xin Long <lucien.xin@gmail.com>, Ashwin H <ashwinh@vmware.com>
Subject: [PATCH 1/2] sctp: implement memory accounting on tx path
Date:   Wed, 6 May 2020 19:50:53 +0530
Message-ID: <4ce6c13946803700d235082b9c52460ed38dab1e.1588242081.git.ashwinh@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1588242081.git.ashwinh@vmware.com>
References: <cover.1588242081.git.ashwinh@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: ashwinh@vmware.com does not
 designate permitted sender hosts)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 1033990ac5b2ab6cee93734cb6d301aa3a35bcaa upstream.

Now when sending packets, sk_mem_charge() and sk_mem_uncharge() have been
used to set sk_forward_alloc. We just need to call sk_wmem_schedule() to
check if the allocated should be raised, and call sk_mem_reclaim() to
check if the allocated should be reduced when it's under memory pressure.

If sk_wmem_schedule() returns false, which means no memory is allowed to
allocate, it will block and wait for memory to become available.

Note different from tcp, sctp wait_for_buf happens before allocating any
skb, so memory accounting check is done with the whole msg_len before it
too.

Reported-by: Matteo Croce <mcroce@redhat.com>
Tested-by: Matteo Croce <mcroce@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ashwin H <ashwinh@vmware.com>
---
 net/sctp/socket.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c93be3b..df4a7d7 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1931,7 +1931,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 	if (sctp_wspace(asoc) < (int)msg_len)
 		sctp_prsctp_prune(asoc, sinfo, msg_len - sctp_wspace(asoc));
 
-	if (sctp_wspace(asoc) <= 0) {
+	if (sk_under_memory_pressure(sk))
+		sk_mem_reclaim(sk);
+
+	if (sctp_wspace(asoc) <= 0 || !sk_wmem_schedule(sk, msg_len)) {
 		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
 		if (err)
@@ -8515,7 +8518,10 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 			goto do_error;
 		if (signal_pending(current))
 			goto do_interrupted;
-		if ((int)msg_len <= sctp_wspace(asoc))
+		if (sk_under_memory_pressure(sk))
+			sk_mem_reclaim(sk);
+		if ((int)msg_len <= sctp_wspace(asoc) &&
+		    sk_wmem_schedule(sk, msg_len))
 			break;
 
 		/* Let another process have a go.  Since we are going
-- 
2.7.4

