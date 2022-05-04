Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8353751B168
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbiEDV5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiEDV5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:57:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A044E50473
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 14:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651701257; x=1683237257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qnJzb3wltAIT3SqGTtEHEESmhK0f8+gNhdxlDAAqu2E=;
  b=HZZI8q1JsSlkulMzDkN0XeNQaVAZCFOQzuHTUJykzX32739Dk13/wfyU
   mOJKTTzqlstagRo+EwQ13uy3mhEo6G2wPea0nJA0jkY9mIHNnWKs5YiDO
   bKlNopnVtnnlaFQ5ns82pnF/6cfaUAxghi1Ddjg83kmHaKoJRTOhAWSIX
   tkK4FvWz/u9CMlwiIk2mYZmbkfU3QwL0kZoY/g95I2pXx7p9mzGojCf+P
   BRBHP+GTKhDD/YXRofvojrTZFIoPoSr759nBL9n7RzqaGmTTHlt8pratQ
   B2AU33RRCAY5frV0emu1oV+KAyZs5Y/Oks92IVGJLJVjocm1JHeVsgIoB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="248445422"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="248445422"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 14:54:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="621000359"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.251.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 14:54:16 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/5] mptcp: really share subflow snd_wnd
Date:   Wed,  4 May 2022 14:54:04 -0700
Message-Id: <20220504215408.349318-2-mathew.j.martineau@linux.intel.com>
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

As per RFC, mptcp subflows use a "shared" snd_wnd: the effective
window is the maximum among the current values received on all
subflows. Without such feature a data transfer using multiple
subflows could block.

Window sharing is currently implemented in the RX side:
__tcp_select_window uses the mptcp-level receive buffer to compute
the announced window.

That is not enough: the TCP stack will stick to the window size
received on the given subflow; we need to propagate the msk window
value on each subflow at xmit time.

Change the packet scheduler to ignore the subflow level window
and use instead the msk level one

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 52ed2c0ac901..97a375eabd34 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1141,19 +1141,20 @@ struct mptcp_sendmsg_info {
 	bool data_lock_held;
 };
 
-static int mptcp_check_allowed_size(struct mptcp_sock *msk, u64 data_seq,
-				    int avail_size)
+static int mptcp_check_allowed_size(const struct mptcp_sock *msk, struct sock *ssk,
+				    u64 data_seq, int avail_size)
 {
 	u64 window_end = mptcp_wnd_end(msk);
+	u64 mptcp_snd_wnd;
 
 	if (__mptcp_check_fallback(msk))
 		return avail_size;
 
-	if (!before64(data_seq + avail_size, window_end)) {
-		u64 allowed_size = window_end - data_seq;
+	mptcp_snd_wnd = window_end - data_seq;
+	avail_size = min_t(unsigned int, mptcp_snd_wnd, avail_size);
 
-		return min_t(unsigned int, allowed_size, avail_size);
-	}
+	if (unlikely(tcp_sk(ssk)->snd_wnd < mptcp_snd_wnd))
+		tcp_sk(ssk)->snd_wnd = min_t(u64, U32_MAX, mptcp_snd_wnd);
 
 	return avail_size;
 }
@@ -1305,7 +1306,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	}
 
 	/* Zero window and all data acked? Probe. */
-	copy = mptcp_check_allowed_size(msk, data_seq, copy);
+	copy = mptcp_check_allowed_size(msk, ssk, data_seq, copy);
 	if (copy == 0) {
 		u64 snd_una = READ_ONCE(msk->snd_una);
 
@@ -1498,11 +1499,16 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 	 * to check that subflow has a non empty cwin.
 	 */
 	ssk = send_info[SSK_MODE_ACTIVE].ssk;
-	if (!ssk || !sk_stream_memory_free(ssk) || !tcp_sk(ssk)->snd_wnd)
+	if (!ssk || !sk_stream_memory_free(ssk))
 		return NULL;
 
-	burst = min_t(int, MPTCP_SEND_BURST_SIZE, tcp_sk(ssk)->snd_wnd);
+	burst = min_t(int, MPTCP_SEND_BURST_SIZE, mptcp_wnd_end(msk) - msk->snd_nxt);
 	wmem = READ_ONCE(ssk->sk_wmem_queued);
+	if (!burst) {
+		msk->last_snd = NULL;
+		return ssk;
+	}
+
 	subflow = mptcp_subflow_ctx(ssk);
 	subflow->avg_pacing_rate = div_u64((u64)subflow->avg_pacing_rate * wmem +
 					   READ_ONCE(ssk->sk_pacing_rate) * burst,
-- 
2.36.0

