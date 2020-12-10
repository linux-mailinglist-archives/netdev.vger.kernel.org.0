Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F9F2D6B6F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbgLJXBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:01:43 -0500
Received: from mga04.intel.com ([192.55.52.120]:11294 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388688AbgLJXBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 18:01:03 -0500
IronPort-SDR: 45WOd/vYY42Uj8hlyCP2jc3ZZNnkFaWth0IXKT6lJS6sz94RPW29iU+uTbEQczVfdJg4DYXfaX
 GxHP9XH7hQVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="171776496"
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="171776496"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:15 -0800
IronPort-SDR: ctfvg8AUf5e6pODv/ebOroGs/e2MpUvkxD7qK/L36jxDzrIKlGKehl0zyZRVY3bH50rY8adduH
 mlSAQpnKjwBA==
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="338703761"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.112.51])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 9/9] mptcp: let MPTCP create max size skbs
Date:   Thu, 10 Dec 2020 14:25:06 -0800
Message-Id: <20201210222506.222251-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
References: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently the xmit path of the MPTCP protocol creates smaller-
than-max-size skbs, which is suboptimal for the performances.

There are a few things to improve:
- when coalescing to an existing skb, must clear the PUSH flag
- tcp_build_frag() expect the available space as an argument.
  When coalescing is enable MPTCP already subtracted the
  to-be-coalesced skb len. We must increment said argument
  accordingly.

Before:
./use_mptcp.sh netperf -H 127.0.0.1 -t TCP_STREAM
[...]
131072  16384  16384    30.00    24414.86

After:
./use_mptcp.sh netperf -H 127.0.0.1 -t TCP_STREAM
[...]
131072  16384  16384    30.05    28357.69

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index cb8b7adf218a..b812aaae8044 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1256,6 +1256,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	struct mptcp_ext *mpext = NULL;
 	struct sk_buff *skb, *tail;
 	bool can_collapse = false;
+	int size_bias = 0;
 	int avail_size;
 	size_t ret = 0;
 
@@ -1277,10 +1278,12 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
 		can_collapse = (info->size_goal - skb->len > 0) &&
 			 mptcp_skb_can_collapse_to(data_seq, skb, mpext);
-		if (!can_collapse)
+		if (!can_collapse) {
 			TCP_SKB_CB(skb)->eor = 1;
-		else
+		} else {
+			size_bias = skb->len;
 			avail_size = info->size_goal - skb->len;
+		}
 	}
 
 	/* Zero window and all data acked? Probe. */
@@ -1300,8 +1303,8 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		return 0;
 
 	ret = info->limit - info->sent;
-	tail = tcp_build_frag(ssk, avail_size, info->flags, dfrag->page,
-			      dfrag->offset + info->sent, &ret);
+	tail = tcp_build_frag(ssk, avail_size + size_bias, info->flags,
+			      dfrag->page, dfrag->offset + info->sent, &ret);
 	if (!tail) {
 		tcp_remove_empty_skb(sk, tcp_write_queue_tail(ssk));
 		return -ENOMEM;
@@ -1310,8 +1313,9 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	/* if the tail skb is still the cached one, collapsing really happened.
 	 */
 	if (skb == tail) {
-		WARN_ON_ONCE(!can_collapse);
+		TCP_SKB_CB(tail)->tcp_flags &= ~TCPHDR_PSH;
 		mpext->data_len += ret;
+		WARN_ON_ONCE(!can_collapse);
 		WARN_ON_ONCE(zero_window_probe);
 		goto out;
 	}
-- 
2.29.2

