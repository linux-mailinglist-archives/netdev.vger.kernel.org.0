Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F78A2D4F28
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgLIX5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:57:19 -0500
Received: from mga06.intel.com ([134.134.136.31]:19498 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgLIX43 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:56:29 -0500
IronPort-SDR: WUwCAtOVaWmDG7LOJRClyzwf6fI6LyF5oLLjHkrwQvrxq5Ao6kXKloebgF/pkE1yxO0CSrcGcK
 HpNSNDok8cpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235763091"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="235763091"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:38 -0800
IronPort-SDR: sPmC5SrhMRAyrMmZXAUTOvm/ODC1NWdTHOPko4NRysgcf2u0Rx1fgYT2K6AgT0WD/ZNdnW+zez
 v3/gtK8HVMHg==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="318582186"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.111.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:38 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 04/11] mptcp: use adding up size to get ADD_ADDR length
Date:   Wed,  9 Dec 2020 15:51:21 -0800
Message-Id: <20201209235128.175473-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
References: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch uses adding up size to get the ADD_ADDR suboption length rather
than returning the ADD_ADDR size constants.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 987046d9d1d4..5c45aabf4c6a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -578,10 +578,14 @@ static inline bool mptcp_pm_should_rm_signal(struct mptcp_sock *msk)
 
 static inline unsigned int mptcp_add_addr_len(int family, bool echo)
 {
-	if (family == AF_INET)
-		return echo ? TCPOLEN_MPTCP_ADD_ADDR_BASE
-			    : TCPOLEN_MPTCP_ADD_ADDR;
-	return echo ? TCPOLEN_MPTCP_ADD_ADDR6_BASE : TCPOLEN_MPTCP_ADD_ADDR6;
+	u8 len = TCPOLEN_MPTCP_ADD_ADDR_BASE;
+
+	if (family == AF_INET6)
+		len = TCPOLEN_MPTCP_ADD_ADDR6_BASE;
+	if (!echo)
+		len += MPTCPOPT_THMAC_LEN;
+
+	return len;
 }
 
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
-- 
2.29.2

