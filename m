Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E58D3B4A1F
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 23:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFYV1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 17:27:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:25036 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhFYV1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 17:27:48 -0400
IronPort-SDR: EO3PMga50sslSdnGyEZo5Zu0lHYmgPNob2sKJ1lmgwahbFJS1qJR9zV35zRoy9tkuyv4fc6XBh
 d1BWrTRYEU3A==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="229345341"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="229345341"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 14:25:26 -0700
IronPort-SDR: kLvqyrhibWyoJs+8bsVB3bukHfrLrEe/kHi1E5C7zVIv9bHJmjZbJru29rU1p4Fp5WO5y92L7Y
 TZwy1jvj8Maw==
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="481971934"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.148.185])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 14:25:26 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        mptcp@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next] mptcp: fix 'masking a bool' warning
Date:   Fri, 25 Jun 2021 14:25:22 -0700
Message-Id: <20210625212522.264000-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

Dan Carpenter reported an issue introduced in
commit fde56eea01f9 ("mptcp: refine mptcp_cleanup_rbuf") where a new
boolean (ack_pending) is masked with 0x9.

This is not the intention to ignore values by using a boolean. This
variable should not have a 'bool' type: we should keep the 'u8' to allow
this comparison.

Fixes: fde56eea01f9 ("mptcp: refine mptcp_cleanup_rbuf")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ce0c45dfb79e..7bb82424e551 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -455,7 +455,7 @@ static void mptcp_subflow_cleanup_rbuf(struct sock *ssk)
 static bool mptcp_subflow_could_cleanup(const struct sock *ssk, bool rx_empty)
 {
 	const struct inet_connection_sock *icsk = inet_csk(ssk);
-	bool ack_pending = READ_ONCE(icsk->icsk_ack.pending);
+	u8 ack_pending = READ_ONCE(icsk->icsk_ack.pending);
 	const struct tcp_sock *tp = tcp_sk(ssk);
 
 	return (ack_pending & ICSK_ACK_SCHED) &&
-- 
2.32.0

