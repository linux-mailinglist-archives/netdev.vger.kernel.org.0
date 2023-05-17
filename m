Return-Path: <netdev+bounces-3433-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A711D7071CE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14EC7281761
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86552449A1;
	Wed, 17 May 2023 19:16:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863E831F15;
	Wed, 17 May 2023 19:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF32C4339C;
	Wed, 17 May 2023 19:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684350995;
	bh=ZjM7OOfC3AeCHvlE5Yy28iFPBn6q3LOa2FbcG+q3L4M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Uv6lsxDYG3qVtZoQpyQ8osGnu+4SMW4WSV8bMo2fkk/nLaQqkvBkF+mcKJt90rTY4
	 kOn7WtbNCOdANDUsNqRCXiGLgqvmlrQtRgLeHVfPyaa2KWYS4y054n582QtooVJu04
	 K7m6WnZa/C3hSwnyAV9kg/xUFfOb2Rw+oQnTPGHxU9183Q5hpD4PGfCLRav5MWnQgi
	 sUBQZ1EbiibA+8O2WZTOAQ8SuVZpnnfucjbyx8w6+RxvP09VC+Y0cmaZE/12PGme3g
	 VlqI89mUnEqveg9Kh84mLM6TassAcOPIkdlaPpOYWkontAV3GtL7fg/CvvuJagTsAY
	 2lDF+4k2Srw9g==
From: Mat Martineau <martineau@kernel.org>
Date: Wed, 17 May 2023 12:16:16 -0700
Subject: [PATCH net-next 3/5] mptcp: introduces more address related mibs
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230516-send-net-next-20220516-v1-3-e91822b7b6e0@kernel.org>
References: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
In-Reply-To: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>
X-Mailer: b4 0.12.2

From: Paolo Abeni <pabeni@redhat.com>

Currently we don't track explicitly a few events related to address
management suboption handling; this patch adds new mibs for ADD_ADDR
and RM_ADDR options tx and for missed tx events due to internal storage
exhaustion.

The self-tests must be updated to properly handle different mibs with
the same/shared prefix.

Additionally removes a couple of warning tracking the loss event.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/378
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 net/mptcp/mib.c                                 |  6 ++++++
 net/mptcp/mib.h                                 | 18 ++++++++++++++++++
 net/mptcp/options.c                             |  5 ++++-
 net/mptcp/pm.c                                  |  6 ++++--
 tools/testing/selftests/net/mptcp/mptcp_join.sh |  4 ++--
 5 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index 0dac2863c6e1..a0990c365a2e 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -34,7 +34,11 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("NoDSSInWindow", MPTCP_MIB_NODSSWINDOW),
 	SNMP_MIB_ITEM("DuplicateData", MPTCP_MIB_DUPDATA),
 	SNMP_MIB_ITEM("AddAddr", MPTCP_MIB_ADDADDR),
+	SNMP_MIB_ITEM("AddAddrTx", MPTCP_MIB_ADDADDRTX),
+	SNMP_MIB_ITEM("AddAddrTxDrop", MPTCP_MIB_ADDADDRTXDROP),
 	SNMP_MIB_ITEM("EchoAdd", MPTCP_MIB_ECHOADD),
+	SNMP_MIB_ITEM("EchoAddTx", MPTCP_MIB_ECHOADDTX),
+	SNMP_MIB_ITEM("EchoAddTxDrop", MPTCP_MIB_ECHOADDTXDROP),
 	SNMP_MIB_ITEM("PortAdd", MPTCP_MIB_PORTADD),
 	SNMP_MIB_ITEM("AddAddrDrop", MPTCP_MIB_ADDADDRDROP),
 	SNMP_MIB_ITEM("MPJoinPortSynRx", MPTCP_MIB_JOINPORTSYNRX),
@@ -44,6 +48,8 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("MismatchPortAckRx", MPTCP_MIB_MISMATCHPORTACKRX),
 	SNMP_MIB_ITEM("RmAddr", MPTCP_MIB_RMADDR),
 	SNMP_MIB_ITEM("RmAddrDrop", MPTCP_MIB_RMADDRDROP),
+	SNMP_MIB_ITEM("RmAddrTx", MPTCP_MIB_RMADDRTX),
+	SNMP_MIB_ITEM("RmAddrTxDrop", MPTCP_MIB_RMADDRTXDROP),
 	SNMP_MIB_ITEM("RmSubflow", MPTCP_MIB_RMSUBFLOW),
 	SNMP_MIB_ITEM("MPPrioTx", MPTCP_MIB_MPPRIOTX),
 	SNMP_MIB_ITEM("MPPrioRx", MPTCP_MIB_MPPRIORX),
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 2be3596374f4..cae71d947252 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -27,7 +27,15 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_NODSSWINDOW,		/* Segments not in MPTCP windows */
 	MPTCP_MIB_DUPDATA,		/* Segments discarded due to duplicate DSS */
 	MPTCP_MIB_ADDADDR,		/* Received ADD_ADDR with echo-flag=0 */
+	MPTCP_MIB_ADDADDRTX,		/* Sent ADD_ADDR with echo-flag=0 */
+	MPTCP_MIB_ADDADDRTXDROP,	/* ADD_ADDR with echo-flag=0 not send due to
+					 * resource exhaustion
+					 */
 	MPTCP_MIB_ECHOADD,		/* Received ADD_ADDR with echo-flag=1 */
+	MPTCP_MIB_ECHOADDTX,		/* Send ADD_ADDR with echo-flag=1 */
+	MPTCP_MIB_ECHOADDTXDROP,	/* ADD_ADDR with echo-flag=1 not send due
+					 * to resource exhaustion
+					 */
 	MPTCP_MIB_PORTADD,		/* Received ADD_ADDR with a port-number */
 	MPTCP_MIB_ADDADDRDROP,		/* Dropped incoming ADD_ADDR */
 	MPTCP_MIB_JOINPORTSYNRX,	/* Received a SYN MP_JOIN with a different port-number */
@@ -37,6 +45,8 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_MISMATCHPORTACKRX,	/* Received an ACK MP_JOIN with a mismatched port-number */
 	MPTCP_MIB_RMADDR,		/* Received RM_ADDR */
 	MPTCP_MIB_RMADDRDROP,		/* Dropped incoming RM_ADDR */
+	MPTCP_MIB_RMADDRTX,		/* Sent RM_ADDR */
+	MPTCP_MIB_RMADDRTXDROP,		/* RM_ADDR not sent due to resource exhaustion */
 	MPTCP_MIB_RMSUBFLOW,		/* Remove a subflow */
 	MPTCP_MIB_MPPRIOTX,		/* Transmit a MP_PRIO */
 	MPTCP_MIB_MPPRIORX,		/* Received a MP_PRIO */
@@ -63,6 +73,14 @@ struct mptcp_mib {
 	unsigned long mibs[LINUX_MIB_MPTCP_MAX];
 };
 
+static inline void MPTCP_ADD_STATS(struct net *net,
+				   enum linux_mptcp_mib_field field,
+				   int val)
+{
+	if (likely(net->mib.mptcp_statistics))
+		SNMP_ADD_STATS(net->mib.mptcp_statistics, field, val);
+}
+
 static inline void MPTCP_INC_STATS(struct net *net,
 				   enum linux_mptcp_mib_field field)
 {
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 19a01b6566f1..8a8083207be4 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -687,9 +687,12 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	}
 	opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
 	if (!echo) {
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ADDADDRTX);
 		opts->ahmac = add_addr_generate_hmac(msk->local_key,
 						     msk->remote_key,
 						     &opts->addr);
+	} else {
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ECHOADDTX);
 	}
 	pr_debug("addr_id=%d, ahmac=%llu, echo=%d, port=%d",
 		 opts->addr.id, opts->ahmac, echo, ntohs(opts->addr.port));
@@ -723,7 +726,7 @@ static bool mptcp_established_options_rm_addr(struct sock *sk,
 
 	for (i = 0; i < opts->rm_list.nr; i++)
 		pr_debug("rm_list_ids[%d]=%d", i, opts->rm_list.ids[i]);
-
+	MPTCP_ADD_STATS(sock_net(sk), MPTCP_MIB_RMADDRTX, opts->rm_list.nr);
 	return true;
 }
 
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 78c924506e83..7d03b5fd8200 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -26,7 +26,8 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 
 	if (add_addr &
 	    (echo ? BIT(MPTCP_ADD_ADDR_ECHO) : BIT(MPTCP_ADD_ADDR_SIGNAL))) {
-		pr_warn("addr_signal error, add_addr=%d, echo=%d", add_addr, echo);
+		MPTCP_INC_STATS(sock_net((struct sock *)msk),
+				echo ? MPTCP_MIB_ECHOADDTXDROP : MPTCP_MIB_ADDADDRTXDROP);
 		return -EINVAL;
 	}
 
@@ -48,7 +49,8 @@ int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_
 	pr_debug("msk=%p, rm_list_nr=%d", msk, rm_list->nr);
 
 	if (rm_addr) {
-		pr_warn("addr_signal error, rm_addr=%d", rm_addr);
+		MPTCP_ADD_STATS(sock_net((struct sock *)msk),
+				MPTCP_MIB_RMADDRTXDROP, rm_list->nr);
 		return -EINVAL;
 	}
 
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 26310c17b4c6..0886ed2c59ea 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1492,7 +1492,7 @@ chk_add_nr()
 	fi
 
 	echo -n " - echo  "
-	count=$(ip netns exec $ns1 nstat -as | grep MPTcpExtEchoAdd | awk '{print $2}')
+	count=$(ip netns exec $ns1 nstat -as MPTcpExtEchoAdd | grep MPTcpExtEchoAdd | awk '{print $2}')
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$echo_nr" ]; then
 		echo "[fail] got $count ADD_ADDR echo[s] expected $echo_nr"
@@ -1614,7 +1614,7 @@ chk_rm_nr()
 	fi
 
 	printf "%-${nr_blank}s %s" " " "rm "
-	count=$(ip netns exec $addr_ns nstat -as | grep MPTcpExtRmAddr | awk '{print $2}')
+	count=$(ip netns exec $addr_ns nstat -as MPTcpExtRmAddr | grep MPTcpExtRmAddr | awk '{print $2}')
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$rm_addr_nr" ]; then
 		echo "[fail] got $count RM_ADDR[s] expected $rm_addr_nr"

-- 
2.40.1


