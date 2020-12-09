Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16D12D4F2A
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgLIX6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:58:12 -0500
Received: from mga06.intel.com ([134.134.136.31]:19420 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbgLIX5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:57:55 -0500
IronPort-SDR: 1Oq/AI6zB2wSBP1JGsCtntXjMQz9jJUcz1WIHvdSVv30msw3pj6sSLWnqwY64rHuYTrKf4vpXY
 O8K1nLBhRWiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235763097"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="235763097"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:40 -0800
IronPort-SDR: ViO9CH6VtMw2uKdxYpII0xG+pbEq40hXeQQBTPpb5vexSXf/eZJkrR2PlkK/EUUEMNJhGzN6ag
 v3ru2ZkURcCA==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="318582194"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.111.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:39 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 08/11] mptcp: print out port and ahmac when receiving ADD_ADDR
Date:   Wed,  9 Dec 2020 15:51:25 -0800
Message-Id: <20201209235128.175473-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
References: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch printed out more debugging information for the ADD_ADDR
suboption parsing on the incoming path.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 6a290c622ccf..1ca60d9da3ef 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -242,9 +242,6 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 
 		mp_opt->add_addr = 1;
 		mp_opt->addr_id = *ptr++;
-		pr_debug("ADD_ADDR%s: id=%d, echo=%d",
-			 (mp_opt->family == MPTCP_ADDR_IPVERSION_6) ? "6" : "",
-			 mp_opt->addr_id, mp_opt->echo);
 		if (mp_opt->family == MPTCP_ADDR_IPVERSION_4) {
 			memcpy((u8 *)&mp_opt->addr.s_addr, (u8 *)ptr, 4);
 			ptr += 4;
@@ -269,6 +266,9 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			mp_opt->ahmac = get_unaligned_be64(ptr);
 			ptr += 8;
 		}
+		pr_debug("ADD_ADDR%s: id=%d, ahmac=%llu, echo=%d, port=%d",
+			 (mp_opt->family == MPTCP_ADDR_IPVERSION_6) ? "6" : "",
+			 mp_opt->addr_id, mp_opt->ahmac, mp_opt->echo, mp_opt->port);
 		break;
 
 	case MPTCPOPT_RM_ADDR:
-- 
2.29.2

