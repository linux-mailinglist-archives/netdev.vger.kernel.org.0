Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BE551B16C
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354418AbiEDV6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351153AbiEDV6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:58:02 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8230751596
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 14:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651701263; x=1683237263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rAc1/rLJSR1p6poXeUKLegm8cyFurQp8xHNbpGX67OY=;
  b=K2qIN26Y6b5m+KssxVfX9nnM9Seztae2GO4AV9VQ5h1UrvwxAJ+FDg3R
   bz42UVQrZmOyIayE3Qw2pj+N1isI/0r5mzZs4symGdQN/Cozv1qZmUYQK
   b9HDL74IiqLJzuwoseOTTEBiuYrDS5hZv10i+QC//dpufzF6BYOsA7KRQ
   iaELtaXWT7Q+NAQbyApnrRTnF7oAp8frwSw/0+dAx3sRdMQA9XJ59Yspl
   UJJfwlK/pcSBtihWBMCDBakl6uEbL8Nm683HD9IHqQhwl6cii9B/GybZf
   QHTJCwVp3XxaB4i9K4WSzqeAXHMrxfbvUNfDwNGB0LEg/FaeEfHI9N/ef
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="248445431"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="248445431"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 14:54:23 -0700
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="621000387"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.251.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 14:54:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/5] mptcp: add more offered MIBs counter
Date:   Wed,  4 May 2022 14:54:08 -0700
Message-Id: <20220504215408.349318-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504215408.349318-1-mathew.j.martineau@linux.intel.com>
References: <20220504215408.349318-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Track the exceptional handling of MPTCP-level offered window
with a few more counters for observability.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mib.c     | 3 +++
 net/mptcp/mib.h     | 5 +++++
 net/mptcp/options.c | 6 +++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index 6a6f8151375a..0dac2863c6e1 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -57,6 +57,9 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("SubflowStale", MPTCP_MIB_SUBFLOWSTALE),
 	SNMP_MIB_ITEM("SubflowRecover", MPTCP_MIB_SUBFLOWRECOVER),
 	SNMP_MIB_ITEM("SndWndShared", MPTCP_MIB_SNDWNDSHARED),
+	SNMP_MIB_ITEM("RcvWndShared", MPTCP_MIB_RCVWNDSHARED),
+	SNMP_MIB_ITEM("RcvWndConflictUpdate", MPTCP_MIB_RCVWNDCONFLICTUPDATE),
+	SNMP_MIB_ITEM("RcvWndConflict", MPTCP_MIB_RCVWNDCONFLICT),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 2411510bef66..2be3596374f4 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -50,6 +50,11 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_SUBFLOWSTALE,		/* Subflows entered 'stale' status */
 	MPTCP_MIB_SUBFLOWRECOVER,	/* Subflows returned to active status after being stale */
 	MPTCP_MIB_SNDWNDSHARED,		/* Subflow snd wnd is overridden by msk's one */
+	MPTCP_MIB_RCVWNDSHARED,		/* Subflow rcv wnd is overridden by msk's one */
+	MPTCP_MIB_RCVWNDCONFLICTUPDATE,	/* subflow rcv wnd is overridden by msk's one due to
+					 * conflict with another subflow while updating msk rcv wnd
+					 */
+	MPTCP_MIB_RCVWNDCONFLICT,	/* Conflict with while updating msk rcv wnd */
 	__MPTCP_MIB_MAX
 };
 
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 3e3156cfe813..ac3b7b8a02f6 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1248,8 +1248,11 @@ static void mptcp_set_rwin(struct tcp_sock *tp, struct tcphdr *th)
 
 			if (rcv_wnd == rcv_wnd_old)
 				break;
-			if (before64(rcv_wnd_new, rcv_wnd))
+			if (before64(rcv_wnd_new, rcv_wnd)) {
+				MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_RCVWNDCONFLICTUPDATE);
 				goto raise_win;
+			}
+			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_RCVWNDCONFLICT);
 			rcv_wnd_old = rcv_wnd;
 		}
 		return;
@@ -1275,6 +1278,7 @@ static void mptcp_set_rwin(struct tcp_sock *tp, struct tcphdr *th)
 		/* RFC1323 scaling applied */
 		new_win >>= tp->rx_opt.rcv_wscale;
 		th->window = htons(new_win);
+		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_RCVWNDSHARED);
 	}
 }
 
-- 
2.36.0

