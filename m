Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D641B4C3A88
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 01:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiBYAxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 19:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiBYAxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 19:53:37 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438B910A7F0
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 16:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645750386; x=1677286386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jppViAbtrq9fvgOH1K0JJZbz2wwEgWwtbwzSeFNMgyo=;
  b=GDRgg6ihwR+L/kAtr6+5aZmD0ls8X4Z+m/lOUMySmND3KmSctJ139VKL
   EBSiSJWZk0WmgzwaeMLruudXTLlf7dEVXFRyJwVDkU5vU06LO0F64hY4a
   UB5XEzirulZPR1bSmtlo7j8pep5a1Sur1Ev4MMKpZR/P1GFR3OW5oMwal
   SUo2+0QZzQhGcbEEarvchSYZimhRdPjy3t50LIvjiqg1bVltz7oIdkjB8
   kehXUKZp2fw6Rfps7cqsEK749rQ759EIdrOiV5dePmYXl3TTvA0IF5nYg
   jb1Nrz8lLuG+e28TeeuGm1gPYonD4UTpqW4/L+52zQTiHcm0m1L6pOYph
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="313105743"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="313105743"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 16:53:05 -0800
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="638050198"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.28.67])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 16:53:04 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, fw@strlen.de,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/3] mptcp: accurate SIOCOUTQ for fallback socket
Date:   Thu, 24 Feb 2022 16:52:57 -0800
Message-Id: <20220225005259.318898-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220225005259.318898-1-mathew.j.martineau@linux.intel.com>
References: <20220225005259.318898-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The MPTCP SIOCOUTQ implementation is not very accurate in
case of fallback: it only measures the data in the MPTCP-level
write queue, but it does not take in account the subflow
write queue utilization. In case of fallback the first can be
empty, while the latter is not.

The above produces sporadic self-tests issues and can foul
legit user-space application.

Fix the issue additionally querying the subflow in case of fallback.

Fixes: 644807e3e462 ("mptcp: add SIOCINQ, OUTQ and OUTQNSD ioctls")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/260
Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f60f01b14fac..12bb28c5007e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3294,6 +3294,17 @@ static int mptcp_ioctl_outq(const struct mptcp_sock *msk, u64 v)
 		return 0;
 
 	delta = msk->write_seq - v;
+	if (__mptcp_check_fallback(msk) && msk->first) {
+		struct tcp_sock *tp = tcp_sk(msk->first);
+
+		/* the first subflow is disconnected after close - see
+		 * __mptcp_close_ssk(). tcp_disconnect() moves the write_seq
+		 * so ignore that status, too.
+		 */
+		if (!((1 << msk->first->sk_state) &
+		      (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_CLOSE)))
+			delta += READ_ONCE(tp->write_seq) - tp->snd_una;
+	}
 	if (delta > INT_MAX)
 		delta = INT_MAX;
 
-- 
2.35.1

