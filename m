Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644A44A7D2E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348724AbiBCBDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:03:55 -0500
Received: from mga17.intel.com ([192.55.52.151]:7851 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346026AbiBCBDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 20:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643850230; x=1675386230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lx38d9fhYiCL1gyKi+5TqLDwjarXqB2FJolRnno2uwY=;
  b=TlkD2zpgtchD5CfgsR1TZ/f189OAnzvzkDE5HhR095TDXXuExHuabUw8
   tS3iwgw15Zh8mE/lyVx+vDMvgdfAmG/+g70wIDUR1w3ZhmGdQZutAQ+iC
   ibaN3PEnSbU3satdaBbaUDLplAUAS4GNB3Z+f4mxGZmPmVbeNIJd9zYEM
   YRI7vnPlkMWJ+r0U24Nf13P8UEBEKanzyKNVXBU3NyuXBOJyTsgx5/3KE
   8dRC/6i0kX5XHtmtWa1u5MU/SLOU8d+XD21DC9poMNpJ0SJjkkisoXpVr
   KVQy001fBsV3u/UXMUOkr/VM/kQH0cueAUgDTiaMlNGaTnp7Q5J7nW765
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="228708716"
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="228708716"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="483070830"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.1.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:48 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/7] mptcp: clarify when options can be used
Date:   Wed,  2 Feb 2022 17:03:39 -0800
Message-Id: <20220203010343.113421-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
References: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

RFC8684 doesn't seem to clearly specify which MPTCP options can be used
together.

Some options are mutually exclusive -- e.g. MP_CAPABLE and MP_JOIN --,
some can be used together -- e.g. DSS + MP_PRIO --, some can but we
prefer not to -- e.g. DSS + ADD_ADDR -- and some have to be used
together at some points -- e.g. MP_FAIL and DSS.

We need to clarify this as a base before allowing other modifications.

For example, does it make sense to send a RM_ADDR with an MPC or MPJ?
This remains open for possible future discussions.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index ab054c389a5f..7345f28f3de1 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1267,8 +1267,27 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 	const struct sock *ssk = (const struct sock *)tp;
 	struct mptcp_subflow_context *subflow;
 
-	/* DSS, MPC, MPJ, ADD_ADDR, FASTCLOSE and RST are mutually exclusive,
-	 * see mptcp_established_options*()
+	/* Which options can be used together?
+	 *
+	 * X: mutually exclusive
+	 * O: often used together
+	 * C: can be used together in some cases
+	 * P: could be used together but we prefer not to (optimisations)
+	 *
+	 *  Opt: | MPC  | MPJ  | DSS  | ADD  |  RM  | PRIO | FAIL |  FC  |
+	 * ------|------|------|------|------|------|------|------|------|
+	 *  MPC  |------|------|------|------|------|------|------|------|
+	 *  MPJ  |  X   |------|------|------|------|------|------|------|
+	 *  DSS  |  X   |  X   |------|------|------|------|------|------|
+	 *  ADD  |  X   |  X   |  P   |------|------|------|------|------|
+	 *  RM   |  C   |  C   |  C   |  P   |------|------|------|------|
+	 *  PRIO |  X   |  C   |  C   |  C   |  C   |------|------|------|
+	 *  FAIL |  X   |  X   |  C   |  X   |  X   |  X   |------|------|
+	 *  FC   |  X   |  X   |  X   |  X   |  X   |  X   |  X   |------|
+	 *  RST  |  X   |  X   |  X   |  X   |  X   |  X   |  O   |  O   |
+	 * ------|------|------|------|------|------|------|------|------|
+	 *
+	 * The same applies in mptcp_established_options() function.
 	 */
 	if (likely(OPTION_MPTCP_DSS & opts->suboptions)) {
 		struct mptcp_ext *mpext = &opts->ext_copy;
-- 
2.35.1

