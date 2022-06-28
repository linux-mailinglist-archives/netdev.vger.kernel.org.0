Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0133455DA73
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242857AbiF1BDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242980AbiF1BCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:02:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659C322B20
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 18:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656378171; x=1687914171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tLpm/6YlKgbIGfFnE3XzACYNDy3Fa3RMftk+V5S+jhA=;
  b=T7NBE/4ltn/KrvJAklabClx5vW35HxX1odo8v4Bcpr56WHGndXEYiPEx
   I419cNf1FBnNoCUpRa4IDab/czSGRigh+v8jtN1fJtgvtbM6LWBOBkZtv
   U9yti2oSUpbY09FRsV4/X/UQOaA0EHpCLkokDfhpkWTtuHzQW/MBSkDNc
   6fJ9MCRe8mNx7n3H0dIwJ3YAbQOF1WutbgsbDrisDcptxpWHuiQYHhXq6
   IbBORwlxGAqX9Ys/bvUf+cdpd84yCJJQ701d47Ggw/vdfYK3M++9pKrjj
   aYl4r4yLrAvVxyFOSphZm+lBO/KMo3ykuZeXoqCrGKIzrwGlep9IEEZE4
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="264642444"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="264642444"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:50 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="692867367"
Received: from cgarner-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.0.217])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, fw@strlen.de,
        geliang.tang@suse.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/9] mptcp: introduce MAPPING_BAD_CSUM
Date:   Mon, 27 Jun 2022 18:02:36 -0700
Message-Id: <20220628010243.166605-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220628010243.166605-1-mathew.j.martineau@linux.intel.com>
References: <20220628010243.166605-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

This allow moving a couple of conditional out of the fast path,
making the code more easy to follow and will simplify the next
patch.

Fixes: ae66fb2ba6c3 ("mptcp: Do TCP fallback on early DSS checksum failure")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 50ad19adc003..42a7c18a1c24 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -843,7 +843,8 @@ enum mapping_status {
 	MAPPING_INVALID,
 	MAPPING_EMPTY,
 	MAPPING_DATA_FIN,
-	MAPPING_DUMMY
+	MAPPING_DUMMY,
+	MAPPING_BAD_CSUM
 };
 
 static void dbg_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
@@ -958,9 +959,7 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
 				 subflow->map_data_csum);
 	if (unlikely(csum)) {
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DATACSUMERR);
-		if (subflow->mp_join || subflow->valid_csum_seen)
-			subflow->send_mp_fail = 1;
-		return subflow->mp_join ? MAPPING_INVALID : MAPPING_DUMMY;
+		return MAPPING_BAD_CSUM;
 	}
 
 	subflow->valid_csum_seen = 1;
@@ -1182,10 +1181,8 @@ static bool subflow_check_data_avail(struct sock *ssk)
 
 		status = get_mapping_status(ssk, msk);
 		trace_subflow_check_data_avail(status, skb_peek(&ssk->sk_receive_queue));
-		if (unlikely(status == MAPPING_INVALID))
-			goto fallback;
-
-		if (unlikely(status == MAPPING_DUMMY))
+		if (unlikely(status == MAPPING_INVALID || status == MAPPING_DUMMY ||
+			     status == MAPPING_BAD_CSUM))
 			goto fallback;
 
 		if (status != MAPPING_OK)
@@ -1227,7 +1224,10 @@ static bool subflow_check_data_avail(struct sock *ssk)
 fallback:
 	if (!__mptcp_check_fallback(msk)) {
 		/* RFC 8684 section 3.7. */
-		if (subflow->send_mp_fail) {
+		if (status == MAPPING_BAD_CSUM &&
+		    (subflow->mp_join || subflow->valid_csum_seen)) {
+			subflow->send_mp_fail = 1;
+
 			if (!READ_ONCE(msk->allow_infinite_fallback)) {
 				ssk->sk_err = EBADMSG;
 				tcp_set_state(ssk, TCP_CLOSE);
-- 
2.37.0

