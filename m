Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B6631A885
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhBMACC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:02:02 -0500
Received: from mga04.intel.com ([192.55.52.120]:41399 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229767AbhBMAB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:01:59 -0500
IronPort-SDR: uHJF1kqjSkF2I+Km+slPKfQ+DADCKW3IhhJqPgHlFiG62FfTtvRvz2vwhtsbPochGqquvRY0TY
 GdC7hQaxLLlg==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="179937485"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="179937485"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:13 -0800
IronPort-SDR: p3tGjhrdD+g0cZeIA2QD6GeM3kzDHjx+YxdsmjnQaQ7JRSeurFOtpPaWnoOPbte1z9jJosYbZ3
 Xngjv0t4khvg==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="423381129"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:13 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/8] mptcp: move subflow close loop after sk close check
Date:   Fri, 12 Feb 2021 15:59:57 -0800
Message-Id: <20210213000001.379332-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
References: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

In case mptcp socket is already dead the entire mptcp socket
will be freed. We can avoid the close check in this case.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 267c5521692d..1b8be2bf6b43 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2246,9 +2246,6 @@ static void mptcp_worker(struct work_struct *work)
 
 	mptcp_check_fastclose(msk);
 
-	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
-		__mptcp_close_subflow(msk);
-
 	if (msk->pm.status)
 		mptcp_pm_nl_work(msk);
 
@@ -2270,6 +2267,9 @@ static void mptcp_worker(struct work_struct *work)
 		goto unlock;
 	}
 
+	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
+		__mptcp_close_subflow(msk);
+
 	if (!test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		goto unlock;
 
-- 
2.30.1

