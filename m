Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66983F0EBB
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 01:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhHRXnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 19:43:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:17429 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235068AbhHRXnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 19:43:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="196031726"
X-IronPort-AV: E=Sophos;i="5.84,333,1620716400"; 
   d="scan'208";a="196031726"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 16:42:48 -0700
X-IronPort-AV: E=Sophos;i="5.84,333,1620716400"; 
   d="scan'208";a="449944708"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.117.66])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 16:42:47 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        geliangtang@gmail.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/2] mptcp: full fully established support after ADD_ADDR
Date:   Wed, 18 Aug 2021 16:42:37 -0700
Message-Id: <20210818234237.242266-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210818234237.242266-1-mathew.j.martineau@linux.intel.com>
References: <20210818234237.242266-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

If directly after an MP_CAPABLE 3WHS, the client receives an ADD_ADDR
with HMAC from the server, it is enough to switch to a "fully
established" mode because it has received more MPTCP options.

It was then OK to enable the "fully_established" flag on the MPTCP
socket. Still, best to check if the ADD_ADDR looks valid by looking if
it contains an HMAC (no 'echo' bit). If an ADD_ADDR echo is received
while we are not in "fully established" mode, it is strange and then
we should not switch to this mode now.

But that is not enough. On one hand, the path-manager has be notified
the state has changed. On the other hand, the "fully_established" flag
on the subflow socket should be turned on as well not to re-send the
MP_CAPABLE 3rd ACK content with the next ACK.

Fixes: 84dfe3677a6f ("mptcp: send out dedicated ADD_ADDR packet")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 4452455aef7f..7adcbc1f7d49 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -885,20 +885,16 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 		return subflow->mp_capable;
 	}
 
-	if (mp_opt->dss && mp_opt->use_ack) {
+	if ((mp_opt->dss && mp_opt->use_ack) ||
+	    (mp_opt->add_addr && !mp_opt->echo)) {
 		/* subflows are fully established as soon as we get any
-		 * additional ack.
+		 * additional ack, including ADD_ADDR.
 		 */
 		subflow->fully_established = 1;
 		WRITE_ONCE(msk->fully_established, true);
 		goto fully_established;
 	}
 
-	if (mp_opt->add_addr) {
-		WRITE_ONCE(msk->fully_established, true);
-		return true;
-	}
-
 	/* If the first established packet does not contain MP_CAPABLE + data
 	 * then fallback to TCP. Fallback scenarios requires a reset for
 	 * MP_JOIN subflows.
-- 
2.33.0

