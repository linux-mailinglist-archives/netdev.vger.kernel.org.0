Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E76E4A7D32
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348723AbiBCBDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:03:53 -0500
Received: from mga17.intel.com ([192.55.52.151]:7851 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239692AbiBCBDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 20:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643850229; x=1675386229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z9FXdFRTATWnPkR8TDxvMrnTWTylwxTAHt4sB0od7FY=;
  b=RViILbysVxqTvz4bL7hcjMuAiznCdDssOi91JovFjCsjM39n9OO38c2w
   qlkmWuJ/VLZG/cg3HdA/M4OjCi4Smp49Wtc/7JKnhCproflUKLJFX1yek
   kjrsludDMW6/J/Tz0eZFh8D3dQZ/BLQf4BQQJ5bZFdlh4sOiAaRn1cA5U
   EQMWNqRECUc/xb2u9EyZzY1Y9vTq1lTGzAQjs+ThPgaep63Ga33zwGVJD
   GIWXCPfB5CSMuj0lIln/zztHEwkQEOak3eOy+0KDdBD3/jLwyOq/a9NhH
   glDRgFOrdomv7sRp+kZDCeOcRJEny6chQGmOv/SoxDZk2G2nxCNFTQSA7
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="228708715"
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="228708715"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="483070829"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.1.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:48 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/7] mptcp: reduce branching when writing MP_FAIL option
Date:   Wed,  2 Feb 2022 17:03:38 -0800
Message-Id: <20220203010343.113421-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
References: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

MP_FAIL should be use in very rare cases, either when the TCP RST flag
is set -- with or without an MP_RST -- or with a DSS, see
mptcp_established_options().

Here, we do the same in mptcp_write_options().

Co-developed-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 5d0b3c3e4655..ab054c389a5f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1267,17 +1267,6 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 	const struct sock *ssk = (const struct sock *)tp;
 	struct mptcp_subflow_context *subflow;
 
-	if (unlikely(OPTION_MPTCP_FAIL & opts->suboptions)) {
-		subflow = mptcp_subflow_ctx(ssk);
-		subflow->send_mp_fail = 0;
-
-		*ptr++ = mptcp_option(MPTCPOPT_MP_FAIL,
-				      TCPOLEN_MPTCP_FAIL,
-				      0, 0);
-		put_unaligned_be64(opts->fail_seq, ptr);
-		ptr += 2;
-	}
-
 	/* DSS, MPC, MPJ, ADD_ADDR, FASTCLOSE and RST are mutually exclusive,
 	 * see mptcp_established_options*()
 	 */
@@ -1336,6 +1325,10 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			}
 			ptr += 1;
 		}
+
+		/* We might need to add MP_FAIL options in rare cases */
+		if (unlikely(OPTION_MPTCP_FAIL & opts->suboptions))
+			goto mp_fail;
 	} else if (OPTIONS_MPTCP_MPC & opts->suboptions) {
 		u8 len, flag = MPTCP_CAP_HMAC_SHA256;
 
@@ -1476,6 +1469,21 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 		put_unaligned_be64(opts->rcvr_key, ptr);
 		ptr += 2;
 
+		if (OPTION_MPTCP_RST & opts->suboptions)
+			goto mp_rst;
+		return;
+	} else if (unlikely(OPTION_MPTCP_FAIL & opts->suboptions)) {
+mp_fail:
+		/* MP_FAIL is mutually exclusive with others except RST */
+		subflow = mptcp_subflow_ctx(ssk);
+		subflow->send_mp_fail = 0;
+
+		*ptr++ = mptcp_option(MPTCPOPT_MP_FAIL,
+				      TCPOLEN_MPTCP_FAIL,
+				      0, 0);
+		put_unaligned_be64(opts->fail_seq, ptr);
+		ptr += 2;
+
 		if (OPTION_MPTCP_RST & opts->suboptions)
 			goto mp_rst;
 		return;
-- 
2.35.1

