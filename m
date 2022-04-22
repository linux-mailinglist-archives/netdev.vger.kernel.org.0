Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A1950C447
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbiDVWay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiDVWah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:30:37 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5988223FB45
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650664553; x=1682200553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OLEkBdK7onccBpmQX1luhp5dKr/ZK3Z7PbbHCEDcqyg=;
  b=YXB4lqdYFQOtfvz/GxQQrU82IME+5NgosUkeQ7GMb9qDypIe3nL2BJQR
   WY1Crp4F9QrDQDNtjHsiF+HPTVxcaDmaoI+cHAwOi+PqsakuJDhDYnJal
   CCMkkMIERFWoV61ccmUDZxohON+2ayi/EUHxTD4OmlN2MaWk081L4eLSZ
   heeJcsSDR+5HYfGxkram40cC6PSnUTFXZubHKnJ2NKFCFtILyUkhSLsUs
   FuD8Spp7FGhIIb+j6MwgzavsCEwl0EJpqKDonXuJbhIaGvEB8jI2bRd8r
   +GMQ077FnCZaUD0TB85udGHgjvID/25DCO0YBAye0EMtOy6rOFTFewrBx
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264285979"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="264285979"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="578119257"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.99.29])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:48 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/8] mptcp: add the fallback check
Date:   Fri, 22 Apr 2022 14:55:37 -0700
Message-Id: <20220422215543.545732-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220422215543.545732-1-mathew.j.martineau@linux.intel.com>
References: <20220422215543.545732-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch adds the fallback check in subflow_check_data_avail(). Only
do the fallback when the msk hasn't fallen back yet.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index f217926f6a9c..7f26a5b04ad3 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1203,35 +1203,38 @@ static bool subflow_check_data_avail(struct sock *ssk)
 	return false;
 
 fallback:
-	/* RFC 8684 section 3.7. */
-	if (subflow->send_mp_fail) {
-		if (mptcp_has_another_subflow(ssk)) {
+	if (!__mptcp_check_fallback(msk)) {
+		/* RFC 8684 section 3.7. */
+		if (subflow->send_mp_fail) {
+			if (mptcp_has_another_subflow(ssk)) {
+				ssk->sk_err = EBADMSG;
+				tcp_set_state(ssk, TCP_CLOSE);
+				subflow->reset_transient = 0;
+				subflow->reset_reason = MPTCP_RST_EMIDDLEBOX;
+				tcp_send_active_reset(ssk, GFP_ATOMIC);
+				while ((skb = skb_peek(&ssk->sk_receive_queue)))
+					sk_eat_skb(ssk, skb);
+			}
+			WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
+			return true;
+		}
+
+		if (subflow->mp_join || subflow->fully_established) {
+			/* fatal protocol error, close the socket.
+			 * subflow_error_report() will introduce the appropriate barriers
+			 */
 			ssk->sk_err = EBADMSG;
 			tcp_set_state(ssk, TCP_CLOSE);
 			subflow->reset_transient = 0;
-			subflow->reset_reason = MPTCP_RST_EMIDDLEBOX;
+			subflow->reset_reason = MPTCP_RST_EMPTCP;
 			tcp_send_active_reset(ssk, GFP_ATOMIC);
-			while ((skb = skb_peek(&ssk->sk_receive_queue)))
-				sk_eat_skb(ssk, skb);
+			WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
+			return false;
 		}
-		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
-		return true;
-	}
 
-	if (subflow->mp_join || subflow->fully_established) {
-		/* fatal protocol error, close the socket.
-		 * subflow_error_report() will introduce the appropriate barriers
-		 */
-		ssk->sk_err = EBADMSG;
-		tcp_set_state(ssk, TCP_CLOSE);
-		subflow->reset_transient = 0;
-		subflow->reset_reason = MPTCP_RST_EMPTCP;
-		tcp_send_active_reset(ssk, GFP_ATOMIC);
-		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
-		return false;
+		__mptcp_do_fallback(msk);
 	}
 
-	__mptcp_do_fallback(msk);
 	skb = skb_peek(&ssk->sk_receive_queue);
 	subflow->map_valid = 1;
 	subflow->map_seq = READ_ONCE(msk->ack_seq);
-- 
2.36.0

