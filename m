Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983AC50C2A1
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiDVWa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiDVWah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:30:37 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA5732FF64
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650664553; x=1682200553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1ZI/wWdgV4VW/clVksEhHQFe+EsRIy22X9gG8piZujc=;
  b=iHittmVZ1YHT07JNaCxycfj44DtY0+w5rSU2KP0SxiHoHGiwFWeza4al
   bFKi7iUbRdzi/C6fo37KrN+Jkh6FcDz1a5c1Sp4aUMwdgt+ro55vtA3go
   cqjAHcruUQDLjiG05mCJI81TMzO6oq09WYp5aFUy0+P+sdU/6Kgf7cCAg
   vIEGRMqeAvJvi75vcjroQEnnrtFWEslFATVGVDHJIb2PIs/RCWLMpwktG
   VlI6BS6nJpsYmo6ApHW4a8SWdSxG1r8KNoPdv1db1Z1mPZvawEQYThfDf
   SmgnDbD5/jZIpx499mcEV9PGfcWf6JRMeJsKU0atNkVXGpJLkrKXFfdgo
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264285977"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="264285977"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="578119255"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.99.29])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:48 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/8] mptcp: don't send RST for single subflow
Date:   Fri, 22 Apr 2022 14:55:36 -0700
Message-Id: <20220422215543.545732-2-mathew.j.martineau@linux.intel.com>
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

When a bad checksum is detected and a single subflow is in use, don't
send RST + MP_FAIL, send data_ack + MP_FAIL instead.

So invoke tcp_send_active_reset() only when mptcp_has_another_subflow()
is true.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index aba260f547da..f217926f6a9c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1206,14 +1206,14 @@ static bool subflow_check_data_avail(struct sock *ssk)
 	/* RFC 8684 section 3.7. */
 	if (subflow->send_mp_fail) {
 		if (mptcp_has_another_subflow(ssk)) {
+			ssk->sk_err = EBADMSG;
+			tcp_set_state(ssk, TCP_CLOSE);
+			subflow->reset_transient = 0;
+			subflow->reset_reason = MPTCP_RST_EMIDDLEBOX;
+			tcp_send_active_reset(ssk, GFP_ATOMIC);
 			while ((skb = skb_peek(&ssk->sk_receive_queue)))
 				sk_eat_skb(ssk, skb);
 		}
-		ssk->sk_err = EBADMSG;
-		tcp_set_state(ssk, TCP_CLOSE);
-		subflow->reset_transient = 0;
-		subflow->reset_reason = MPTCP_RST_EMIDDLEBOX;
-		tcp_send_active_reset(ssk, GFP_ATOMIC);
 		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
 		return true;
 	}
-- 
2.36.0

