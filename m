Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10F7474E79
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbhLNXQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:16:25 -0500
Received: from mga18.intel.com ([134.134.136.126]:9338 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238169AbhLNXQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 18:16:24 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="225961171"
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="225961171"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 15:16:09 -0800
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="518491435"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.180.223])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 15:16:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        syzbot+1fd9b69cde42967d1add@syzkaller.appspotmail.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/4] mptcp: remove tcp ulp setsockopt support
Date:   Tue, 14 Dec 2021 15:16:01 -0800
Message-Id: <20211214231604.211016-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211214231604.211016-1-mathew.j.martineau@linux.intel.com>
References: <20211214231604.211016-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

TCP_ULP setsockopt cannot be used for mptcp because its already
used internally to plumb subflow (tcp) sockets to the mptcp layer.

syzbot managed to trigger a crash for mptcp connections that are
in fallback mode:

KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 1083 Comm: syz-executor.3 Not tainted 5.16.0-rc2-syzkaller #0
RIP: 0010:tls_build_proto net/tls/tls_main.c:776 [inline]
[..]
 __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
 tcp_set_ulp+0x428/0x4c0 net/ipv4/tcp_ulp.c:160
 do_tcp_setsockopt+0x455/0x37c0 net/ipv4/tcp.c:3391
 mptcp_setsockopt+0x1b47/0x2400 net/mptcp/sockopt.c:638

Remove support for TCP_ULP setsockopt.

Fixes: d9e4c1291810 ("mptcp: only admit explicitly supported sockopt")
Reported-by: syzbot+1fd9b69cde42967d1add@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 0f1e661c2032..f8efd478ac97 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -525,7 +525,6 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		case TCP_NODELAY:
 		case TCP_THIN_LINEAR_TIMEOUTS:
 		case TCP_CONGESTION:
-		case TCP_ULP:
 		case TCP_CORK:
 		case TCP_KEEPIDLE:
 		case TCP_KEEPINTVL:
-- 
2.34.1

