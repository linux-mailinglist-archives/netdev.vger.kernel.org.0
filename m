Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E893ABFB4
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhFQXsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:13474 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233058AbhFQXsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:40 -0400
IronPort-SDR: Xba2SUzWaIv7qukZTCplgcnui+EsKXLHDCBvd16Sk8yUCu8EWec/uB00h904KlaKi++dNTSKU3
 OkPckRTif6Sg==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506641"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506641"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:31 -0700
IronPort-SDR: w/m6fS/4wPiwxxLJIzsmarOxcWRTeyLSkDz/atpZ9JUO1kaeTUAo1F3Gy/zZspiWX6ThbgleVG
 id6TbPXCyURQ==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943907"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:30 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 07/16] mptcp: add csum_reqd in mptcp_options_received
Date:   Thu, 17 Jun 2021 16:46:13 -0700
Message-Id: <20210617234622.472030-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new flag csum_reqd in struct mptcp_options_received, if
the flag MPTCP_CAP_CHECKSUM_REQD is set in the receiving MP_CAPABLE
suboption, set this flag.

In mptcp_sk_clone and subflow_finish_connect, if the csum_reqd flag is set,
enable the msk->csum_enabled flag.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 7 ++++---
 net/mptcp/protocol.c | 2 ++
 net/mptcp/protocol.h | 1 +
 net/mptcp/subflow.c  | 2 ++
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index ae69059583a7..2e2551590ecd 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -71,11 +71,9 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		 * "If a checksum is not present when its use has been
 		 * negotiated, the receiver MUST close the subflow with a RST as
 		 * it is considered broken."
-		 *
-		 * We don't implement DSS checksum - fall back to TCP.
 		 */
 		if (flags & MPTCP_CAP_CHECKSUM_REQD)
-			break;
+			mp_opt->csum_reqd = 1;
 
 		mp_opt->mp_capable = 1;
 		if (opsize >= TCPOLEN_MPTCP_MPC_SYNACK) {
@@ -327,6 +325,8 @@ void mptcp_get_options(const struct sock *sk,
 		       const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt)
 {
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	const struct tcphdr *th = tcp_hdr(skb);
 	const unsigned char *ptr;
 	int length;
@@ -342,6 +342,7 @@ void mptcp_get_options(const struct sock *sk,
 	mp_opt->dss = 0;
 	mp_opt->mp_prio = 0;
 	mp_opt->reset = 0;
+	mp_opt->csum_reqd = READ_ONCE(msk->csum_enabled);
 
 	length = (th->doff * 4) - sizeof(struct tcphdr);
 	ptr = (const unsigned char *)(th + 1);
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f0da067301f6..b6e5c0930533 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2810,6 +2810,8 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk->token = subflow_req->token;
 	msk->subflow = NULL;
 	WRITE_ONCE(msk->fully_established, false);
+	if (mp_opt->csum_reqd)
+		WRITE_ONCE(msk->csum_enabled, true);
 
 	msk->write_seq = subflow_req->idsn + 1;
 	msk->snd_nxt = msk->write_seq;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a7ed0b8eb9bc..66e5063ac6c9 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -133,6 +133,7 @@ struct mptcp_options_received {
 		rm_addr : 1,
 		mp_prio : 1,
 		echo : 1,
+		csum_reqd : 1,
 		backup : 1;
 	u32	token;
 	u32	nonce;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index aa6b307b27c8..9b82ce635c6e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -405,6 +405,8 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			goto fallback;
 		}
 
+		if (mp_opt.csum_reqd)
+			WRITE_ONCE(mptcp_sk(parent)->csum_enabled, true);
 		subflow->mp_capable = 1;
 		subflow->can_ack = 1;
 		subflow->remote_key = mp_opt.sndr_key;
-- 
2.32.0

