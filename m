Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A2A4CDDE8
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiCDUEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiCDUEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:04:01 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12A220585E
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423941; x=1677959941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=957fvhFJOCRThfKcjyejNOUcKv2jZZkXSF5cfFEVWs4=;
  b=NS2vGwlbbMYP60ULAuu0VSIbkRhAGfwi7ip1D5SZ/1ckX15663fZa1rP
   JTmuY4SKvJn8aGBadjdsOouXSWbEXFuRJZpxvIIRs00ASTInE2UwsJoob
   qj8KCvKDCzd5D3l/AYGyIFsFt3XoKxXApzIMTG/MKGTTe1MJ0+We481jv
   awc4k3qbLQpUHJXGBZ8tGh6sRCy+LbQZumTtkCWL4xptwmH87g6l5z89u
   +gzf8nNyM9inmJvudsxpyL1Vp4TUXnEK6jTpn+GeanG7yrTRK5kSN01ZY
   87Ru94oHhBusonZjD0hSuA2JFEcZvYmO/IcQ4/lie3KRdeH3TlH7Bavxy
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253981331"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253981331"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552340779"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.225.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:42 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/11] mptcp: add the mibs for MP_FASTCLOSE
Date:   Fri,  4 Mar 2022 11:36:27 -0800
Message-Id: <20220304193636.219315-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
References: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch added two more mibs for MP_FASTCLOSE, MPTCP_MIB_MPFASTCLOSETX
for the MP_FASTCLOSE sending and MPTCP_MIB_MPFASTCLOSERX for receiving.

Also added a debug log for MP_FASTCLOSE receiving, printed out the recv_key
of MP_FASTCLOSE in mptcp_parse_option to show that MP_RST is received.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mib.c     | 2 ++
 net/mptcp/mib.h     | 2 ++
 net/mptcp/options.c | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index 7558802a1435..975d17118bfe 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -48,6 +48,8 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("MPPrioRx", MPTCP_MIB_MPPRIORX),
 	SNMP_MIB_ITEM("MPFailTx", MPTCP_MIB_MPFAILTX),
 	SNMP_MIB_ITEM("MPFailRx", MPTCP_MIB_MPFAILRX),
+	SNMP_MIB_ITEM("MPFastcloseTx", MPTCP_MIB_MPFASTCLOSETX),
+	SNMP_MIB_ITEM("MPFastcloseRx", MPTCP_MIB_MPFASTCLOSERX),
 	SNMP_MIB_ITEM("RcvPruned", MPTCP_MIB_RCVPRUNED),
 	SNMP_MIB_ITEM("SubflowStale", MPTCP_MIB_SUBFLOWSTALE),
 	SNMP_MIB_ITEM("SubflowRecover", MPTCP_MIB_SUBFLOWRECOVER),
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 2966fcb6548b..8206c65297e0 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -41,6 +41,8 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_MPPRIORX,		/* Received a MP_PRIO */
 	MPTCP_MIB_MPFAILTX,		/* Transmit a MP_FAIL */
 	MPTCP_MIB_MPFAILRX,		/* Received a MP_FAIL */
+	MPTCP_MIB_MPFASTCLOSETX,	/* Transmit a MP_FASTCLOSE */
+	MPTCP_MIB_MPFASTCLOSERX,	/* Received a MP_FASTCLOSE */
 	MPTCP_MIB_RCVPRUNED,		/* Incoming packet dropped due to memory limit */
 	MPTCP_MIB_SUBFLOWSTALE,		/* Subflows entered 'stale' status */
 	MPTCP_MIB_SUBFLOWRECOVER,	/* Subflows returned to active status after being stale */
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index ac10a04ccd7c..c3697f06faf9 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -323,6 +323,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		mp_opt->rcvr_key = get_unaligned_be64(ptr);
 		ptr += 8;
 		mp_opt->suboptions |= OPTION_MPTCP_FASTCLOSE;
+		pr_debug("MP_FASTCLOSE: recv_key=%llu", mp_opt->rcvr_key);
 		break;
 
 	case MPTCPOPT_RST:
@@ -832,6 +833,7 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 		    mptcp_established_options_mp_fail(sk, &opt_size, remaining, opts)) {
 			*size += opt_size;
 			remaining -= opt_size;
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPFASTCLOSETX);
 		}
 		/* MP_RST can be used with MP_FASTCLOSE and MP_FAIL if there is room */
 		if (mptcp_established_options_rst(sk, skb, &opt_size, remaining, opts)) {
@@ -1124,6 +1126,7 @@ bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 		    msk->local_key == mp_opt.rcvr_key) {
 			WRITE_ONCE(msk->rcv_fastclose, true);
 			mptcp_schedule_work((struct sock *)msk);
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPFASTCLOSERX);
 		}
 
 		if ((mp_opt.suboptions & OPTION_MPTCP_ADD_ADDR) &&
-- 
2.35.1

