Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE98624E69
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiKJXXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiKJXXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:23:32 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB89A11A09
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668122611; x=1699658611;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dkHFHct5jmMR29HfWsBOmJdLyB9m7Wj7O5Y3w3dZj3Y=;
  b=lx7SV8g6SPHGK+Ek7VuZI4aKMHmCKOAz+EfUWreo68SHp1VFl8Z07qo2
   eRcnpz+1YXADFcVzI4W4fWFEdrab865fWq7h3TwrvZukU0TZyAUeyTmAs
   ihcTpiR9SeXRXKcp9QjrNeccUN4yg8rbaiCOpbOX1UtM0/HV2j9hc93BA
   1/GPqy8xRSeSjS9dGaKES+NWnybElJHJKYNcri5rs25ShJjtSr/TfHpe6
   9cGQZwfe5gZ8Gry+SeYxY5fdzqpIdFqVK6NI9Z2VlBwsLIYfBx96APU9W
   G6sDKh63TFDO52eX7LFmflp0hxOAkZTlPy7VGJI8b0PWYqF7vUNSF4VPE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="309093990"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="309093990"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:23:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="637367373"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="637367373"
Received: from jsandova-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.81.89])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:23:29 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/5] mptcp: get sk from msk directly
Date:   Thu, 10 Nov 2022 15:23:20 -0800
Message-Id: <20221110232322.125068-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221110232322.125068-1-mathew.j.martineau@linux.intel.com>
References: <20221110232322.125068-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Use '(struct sock *)msk' to get 'sk' from 'msk' in a more direct way
instead of using '&msk->sk.icsk_inet.sk'.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_userspace.c | 4 ++--
 net/mptcp/protocol.c     | 4 ++--
 net/mptcp/sockopt.c      | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 9e82250cbb70..5cb65f0928f4 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -291,7 +291,7 @@ int mptcp_nl_cmd_sf_create(struct sk_buff *skb, struct genl_info *info)
 		goto create_err;
 	}
 
-	sk = &msk->sk.icsk_inet.sk;
+	sk = (struct sock *)msk;
 	lock_sock(sk);
 
 	err = __mptcp_subflow_connect(sk, &addr_l, &addr_r);
@@ -403,7 +403,7 @@ int mptcp_nl_cmd_sf_destroy(struct sk_buff *skb, struct genl_info *info)
 		goto destroy_err;
 	}
 
-	sk = &msk->sk.icsk_inet.sk;
+	sk = (struct sock *)msk;
 	lock_sock(sk);
 	ssk = mptcp_nl_find_ssk(msk, &addr_l, &addr_r);
 	if (ssk) {
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5a344788f843..3796d1bfef6b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2454,7 +2454,7 @@ static bool mptcp_check_close_timeout(const struct sock *sk)
 static void mptcp_check_fastclose(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
-	struct sock *sk = &msk->sk.icsk_inet.sk;
+	struct sock *sk = (struct sock *)msk;
 
 	if (likely(!READ_ONCE(msk->rcv_fastclose)))
 		return;
@@ -2616,7 +2616,7 @@ static void mptcp_do_fastclose(struct sock *sk)
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
-	struct sock *sk = &msk->sk.icsk_inet.sk;
+	struct sock *sk = (struct sock *)msk;
 	unsigned long fail_tout;
 	int state;
 
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index f85e9bbfe86f..f62f6483ef77 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -987,7 +987,7 @@ static int mptcp_getsockopt_tcpinfo(struct mptcp_sock *msk, char __user *optval,
 				    int __user *optlen)
 {
 	struct mptcp_subflow_context *subflow;
-	struct sock *sk = &msk->sk.icsk_inet.sk;
+	struct sock *sk = (struct sock *)msk;
 	unsigned int sfcount = 0, copied = 0;
 	struct mptcp_subflow_data sfd;
 	char __user *infoptr;
@@ -1078,8 +1078,8 @@ static void mptcp_get_sub_addrs(const struct sock *sk, struct mptcp_subflow_addr
 static int mptcp_getsockopt_subflow_addrs(struct mptcp_sock *msk, char __user *optval,
 					  int __user *optlen)
 {
-	struct sock *sk = &msk->sk.icsk_inet.sk;
 	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
 	unsigned int sfcount = 0, copied = 0;
 	struct mptcp_subflow_data sfd;
 	char __user *addrptr;
-- 
2.38.1

