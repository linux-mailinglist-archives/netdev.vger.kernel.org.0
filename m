Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F083196AC
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhBKXcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:32:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:55194 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhBKXcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 18:32:36 -0500
IronPort-SDR: 6jB1CJveKZ2ZOH8y9IYfUWlpN5BrkxF1qy/l++qX0El8NomK56F4fPo5FwBj/cGwF9Ia3Mg0Sr
 jNvp/fQ8kyvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9892"; a="267177935"
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="267177935"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:48 -0800
IronPort-SDR: dHWqR2hz/sksUcePhygyVPhnq7qGUMbCuLwvRpSLEzf9OxE9negUnxHBi+wov2KA+fmZCYeiD4
 f8vR7eC4yf5A==
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="381226384"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.100.224])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:48 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/6] mptcp: fix poll after shutdown
Date:   Thu, 11 Feb 2021 15:30:38 -0800
Message-Id: <20210211233042.304878-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
References: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The current mptcp_poll() implementation gives unexpected
results after shutdown(SEND_SHUTDOWN) and when the msk
status is TCP_CLOSE.

Set the correct mask.

Fixes: 8edf08649eed ("mptcp: rework poll+nospace handling")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 9eecd1383d24..42ca49954bdd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3321,7 +3321,7 @@ static __poll_t mptcp_check_writeable(struct mptcp_sock *msk)
 	struct sock *sk = (struct sock *)msk;
 
 	if (unlikely(sk->sk_shutdown & SEND_SHUTDOWN))
-		return 0;
+		return EPOLLOUT | EPOLLWRNORM;
 
 	if (sk_stream_is_writeable(sk))
 		return EPOLLOUT | EPOLLWRNORM;
@@ -3354,6 +3354,8 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 		mask |= mptcp_check_readable(msk);
 		mask |= mptcp_check_writeable(msk);
 	}
+	if (sk->sk_shutdown == SHUTDOWN_MASK || state == TCP_CLOSE)
+		mask |= EPOLLHUP;
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 
-- 
2.30.1

