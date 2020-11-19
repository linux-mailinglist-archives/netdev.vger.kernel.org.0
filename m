Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC172B9BB3
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgKSTqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:46:22 -0500
Received: from mga04.intel.com ([192.55.52.120]:13142 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727736AbgKSTqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:46:10 -0500
IronPort-SDR: 17WPxIwEKTFGdbRxgW+s0wbV3BGIodUweCMrcgIc6oP6i0DBfpb3yQOqmR2U5Y8/Iz0sKCaha0
 e/7cUWgkL1AA==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="168780893"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="168780893"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
IronPort-SDR: wGQWMzQGiYjpYhVt5pvFJxNrEyCVNvoznpeEYg5o/YRx/NGuvoMVWmuNZgbz5w4WFGRpk4w11C
 c+xMtok16C+Q==
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="476940477"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.255.229.232])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:08 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, kuba@kernel.org,
        mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/10] mptcp: skip to next candidate if subflow has unacked data
Date:   Thu, 19 Nov 2020 11:45:56 -0800
Message-Id: <20201119194603.103158-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

In case a subflow path is blocked, MPTCP-level retransmit may not take
place anymore because such subflow is likely to have unacked data left
in its write queue.

Ignore subflows that have experienced loss and test next candidate.

Fixes: 3b1d6210a95773691 ("mptcp: implement and use MPTCP-level retransmission")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a46a542b1766..806c0658e42f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1725,8 +1725,11 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 			continue;
 
 		/* still data outstanding at TCP level?  Don't retransmit. */
-		if (!tcp_write_queue_empty(ssk))
+		if (!tcp_write_queue_empty(ssk)) {
+			if (inet_csk(ssk)->icsk_ca_state >= TCP_CA_Loss)
+				continue;
 			return NULL;
+		}
 
 		if (subflow->backup) {
 			if (!backup)
-- 
2.29.2

