Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9AD4A7D30
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348719AbiBCBDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:03:50 -0500
Received: from mga17.intel.com ([192.55.52.151]:7851 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235856AbiBCBDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 20:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643850229; x=1675386229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/9eQohXqMEYwESVU7hdbMNneG33BX8HfDAWFeLSdjic=;
  b=d21ompxF2k3uHADIBFvdwsEeqbdMJHmjU8peHEcwjIf6v+566OzXpAjf
   O48uagB4HsQWnZb10eqMNJ0yLFqq/ZslnfQsMbPLj/+rinfn7CSLT+rcX
   H0DShnIx7HHq3Lz5nbVVBtcywyu2ew5E6AOyLjdBvF9+DL/baowlBRI84
   HqPlF9uWm91fSSatvFhynDF6KP/7+gtuXH68SW0wSAXR8Stk6ClbEKEfV
   Xi3puuMNvG01gJBTcGtuV3zdAjFIuo2zQ8BZvdr50l/GhP6zDIfYVyawR
   lXDtk5vMyrrboOmBGktoQwwhDfkVnTzT0PSr8R4hqe+G+IKf4d7bvjrMZ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="228708714"
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="228708714"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="483070828"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.1.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:48 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/7] mptcp: move the declarations of ssk and subflow
Date:   Wed,  2 Feb 2022 17:03:37 -0800
Message-Id: <20220203010343.113421-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
References: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Move the declarations of ssk and subflow in MP_FAIL and MP_PRIO to the
beginning of the function mptcp_write_options().

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 645dd984fef0..5d0b3c3e4655 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1264,10 +1264,10 @@ static u16 mptcp_make_csum(const struct mptcp_ext *mpext)
 void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			 struct mptcp_out_options *opts)
 {
-	if (unlikely(OPTION_MPTCP_FAIL & opts->suboptions)) {
-		const struct sock *ssk = (const struct sock *)tp;
-		struct mptcp_subflow_context *subflow;
+	const struct sock *ssk = (const struct sock *)tp;
+	struct mptcp_subflow_context *subflow;
 
+	if (unlikely(OPTION_MPTCP_FAIL & opts->suboptions)) {
 		subflow = mptcp_subflow_ctx(ssk);
 		subflow->send_mp_fail = 0;
 
@@ -1489,9 +1489,6 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 	}
 
 	if (OPTION_MPTCP_PRIO & opts->suboptions) {
-		const struct sock *ssk = (const struct sock *)tp;
-		struct mptcp_subflow_context *subflow;
-
 		subflow = mptcp_subflow_ctx(ssk);
 		subflow->send_mp_prio = 0;
 
-- 
2.35.1

