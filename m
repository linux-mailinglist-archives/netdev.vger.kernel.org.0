Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDD951B169
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346099AbiEDV6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239554AbiEDV54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:57:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628C5506E7
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 14:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651701259; x=1683237259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Keh/V0hKcsPVV4uZnaQ4ISYtNk/JzPjaop5gmEJiqy4=;
  b=O4scArRW7FTX8aVpmzvMDuRG3jmEtbtYpLDU5on+LmzF3m+bqBkocz3q
   iWn0zFbOWmtLvr8AqF+VwEfkoCNYYiO3WQB7U9QMaxqU7/1VxVPbQgd4b
   Qu4HnB/b5mOGGtqZ0LgOHQZcd8zZYiQbo4qejIXUVnXkbdsXMDaaBFwAH
   zPywjIdpsyE3kUiXGIgLlhQjbBLqk1tJUeMHvb2PDWUnQDatFrTYZ6iU8
   pPszG84Zg3mL7ghinyFzGrT6I2CeBYRmdCrZ/CWtQm0bDnCT97V5gYMxJ
   n71arYYS8ceKMUn+4uA5Z3HxsdwkcKUGqohR/j5uBsAEckNfCEdvuCKb0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="248445425"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="248445425"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 14:54:19 -0700
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="621000370"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.251.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 14:54:17 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/5] mptcp: add mib for xmit window sharing
Date:   Wed,  4 May 2022 14:54:05 -0700
Message-Id: <20220504215408.349318-3-mathew.j.martineau@linux.intel.com>
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

Bump a counter for counter when snd_wnd is shared among subflow,
for observability's sake.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mib.c      | 1 +
 net/mptcp/mib.h      | 1 +
 net/mptcp/protocol.c | 4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index d93a8c9996fd..6a6f8151375a 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -56,6 +56,7 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("RcvPruned", MPTCP_MIB_RCVPRUNED),
 	SNMP_MIB_ITEM("SubflowStale", MPTCP_MIB_SUBFLOWSTALE),
 	SNMP_MIB_ITEM("SubflowRecover", MPTCP_MIB_SUBFLOWRECOVER),
+	SNMP_MIB_ITEM("SndWndShared", MPTCP_MIB_SNDWNDSHARED),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 529d07af9e14..2411510bef66 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -49,6 +49,7 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_RCVPRUNED,		/* Incoming packet dropped due to memory limit */
 	MPTCP_MIB_SUBFLOWSTALE,		/* Subflows entered 'stale' status */
 	MPTCP_MIB_SUBFLOWRECOVER,	/* Subflows returned to active status after being stale */
+	MPTCP_MIB_SNDWNDSHARED,		/* Subflow snd wnd is overridden by msk's one */
 	__MPTCP_MIB_MAX
 };
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 97a375eabd34..6710960b74f3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1153,8 +1153,10 @@ static int mptcp_check_allowed_size(const struct mptcp_sock *msk, struct sock *s
 	mptcp_snd_wnd = window_end - data_seq;
 	avail_size = min_t(unsigned int, mptcp_snd_wnd, avail_size);
 
-	if (unlikely(tcp_sk(ssk)->snd_wnd < mptcp_snd_wnd))
+	if (unlikely(tcp_sk(ssk)->snd_wnd < mptcp_snd_wnd)) {
 		tcp_sk(ssk)->snd_wnd = min_t(u64, U32_MAX, mptcp_snd_wnd);
+		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_SNDWNDSHARED);
+	}
 
 	return avail_size;
 }
-- 
2.36.0

