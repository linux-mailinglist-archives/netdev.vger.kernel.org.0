Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D6B52C5FA
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiERWGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiERWG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:06:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6031D865B
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652911495; x=1684447495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XhH0wmTxQ1KVSwFHJOHPbb9tf9TWh9PPcfw1KfcbbPI=;
  b=c1xnbZM5p4+TIIwfdPhBNveTleoe7d1jM6fW7oBi4RzwrcuoXPJoYzRh
   ljccgpz9qvC3ctuUX2jG9Li6E1IVLI8yhX2Ml4swPSuTuBRZqXORAfr/e
   iXmEFxzwkYQT7aFFZuMhwu1kjynQJ8vZhVFWCXTSJbRaqavTDcJFtB8lZ
   fI3/uxux0CgI7+Etxta1JtwCXikCqGbSKFZBW55T8R3hkVZhlV3PGsC14
   0AGFnMhILJ45wqB1E5//LEug1NWM7ezx8UXer7HRZdPHgxwryHrLDrRgw
   J4yxKFpEiNxMLodmUO21dm80Cn6ck0KL4AdrmAdvv/O+JxhstVh2nQ5xT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="270734205"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="270734205"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 15:04:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="598075435"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.36.18])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 15:04:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/4] mptcp: stop using the mptcp_has_another_subflow() helper
Date:   Wed, 18 May 2022 15:04:43 -0700
Message-Id: <20220518220446.209750-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518220446.209750-1-mathew.j.martineau@linux.intel.com>
References: <20220518220446.209750-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The mentioned helper requires the msk socket lock, and the
current callers don't own it nor can't acquire it, so the
access is racy.

All the current callers are really checking for infinite mapping
fallback, and the latter condition is explicitly tracked by
the relevant msk variable: we can safely remove the caller usage
- and the caller itself.

The issue is present since MP_FAIL implementation, but the
fix only applies since the infinite fallback support, ence the
somewhat unexpected fixes tag.

Fixes: 0530020a7c8f ("mptcp: track and update contiguous data status")
Acked-and-tested-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c       |  2 +-
 net/mptcp/protocol.h | 13 -------------
 net/mptcp/subflow.c  |  3 +--
 3 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index cdc2d79071f8..a3f9bf8e8912 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -304,7 +304,7 @@ void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq)
 
 	pr_debug("fail_seq=%llu", fail_seq);
 
-	if (mptcp_has_another_subflow(sk) || !READ_ONCE(msk->allow_infinite_fallback))
+	if (!READ_ONCE(msk->allow_infinite_fallback))
 		return;
 
 	if (!READ_ONCE(subflow->mp_fail_response_expect)) {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 4672901d0dfe..91f7ef6e6c56 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -649,19 +649,6 @@ static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
 	inet_csk(sk)->icsk_af_ops = ctx->icsk_af_ops;
 }
 
-static inline bool mptcp_has_another_subflow(struct sock *ssk)
-{
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk), *tmp;
-	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
-
-	mptcp_for_each_subflow(msk, tmp) {
-		if (tmp != subflow)
-			return true;
-	}
-
-	return false;
-}
-
 void __init mptcp_proto_init(void);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 int __init mptcp_proto_v6_init(void);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6d59336a8e1e..1e07b4d7ee7b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1218,8 +1218,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 	if (!__mptcp_check_fallback(msk)) {
 		/* RFC 8684 section 3.7. */
 		if (subflow->send_mp_fail) {
-			if (mptcp_has_another_subflow(ssk) ||
-			    !READ_ONCE(msk->allow_infinite_fallback)) {
+			if (!READ_ONCE(msk->allow_infinite_fallback)) {
 				ssk->sk_err = EBADMSG;
 				tcp_set_state(ssk, TCP_CLOSE);
 				subflow->reset_transient = 0;
-- 
2.36.1

