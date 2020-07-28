Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF7D231560
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgG1WMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:2588 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729746AbgG1WMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:15 -0400
IronPort-SDR: b6Ifuxba5yXnbTWTqAS/O1nIJ1D3/GNDBmFpyJbPOWmrYEN3HOWP6Om+BZWQm4uBWcf2YqLphq
 b8FkZv+yTc8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342671"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342671"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:13 -0700
IronPort-SDR: Y0E6xtW3/xuShlXHqY9TKeSUJM68suQxT/oICd7sxvb+K7ALOVIp6C2aNDQQi4jbt8b0tndKXv
 m6yezBqoJl3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468879"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:12 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 01/12] mptcp: Allow DATA_FIN in headers without TCP FIN
Date:   Tue, 28 Jul 2020 15:11:59 -0700
Message-Id: <20200728221210.92841-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 8684-compliant DATA_FIN needs to be sent and ack'd before subflows
are closed with TCP FIN, so write DATA_FIN DSS headers whenever their
transmission has been enabled by the MPTCP connection-level socket.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 3bc56eb608d8..0b122b2a9c69 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -482,17 +482,10 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 	struct mptcp_sock *msk;
 	unsigned int ack_size;
 	bool ret = false;
-	u8 tcp_fin;
 
-	if (skb) {
-		mpext = mptcp_get_ext(skb);
-		tcp_fin = TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN;
-	} else {
-		mpext = NULL;
-		tcp_fin = 0;
-	}
+	mpext = skb ? mptcp_get_ext(skb) : NULL;
 
-	if (!skb || (mpext && mpext->use_map) || tcp_fin) {
+	if (!skb || (mpext && mpext->use_map) || subflow->data_fin_tx_enable) {
 		unsigned int map_size;
 
 		map_size = TCPOLEN_MPTCP_DSS_BASE + TCPOLEN_MPTCP_DSS_MAP64;
@@ -502,7 +495,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		if (mpext)
 			opts->ext_copy = *mpext;
 
-		if (skb && tcp_fin && subflow->data_fin_tx_enable)
+		if (skb && subflow->data_fin_tx_enable)
 			mptcp_write_data_fin(subflow, skb, &opts->ext_copy);
 		ret = true;
 	}
-- 
2.28.0

